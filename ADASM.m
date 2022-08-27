%script assembleur
clear;
clc;
%entree: fichier texte
%sortie: contenu RAM au format:
% RAM = [0,0,0,0,1,1,1,1;...
%        0,0,0,1,1,1,1,0;...
%        0,0,1,1,0,0,0,0;...
%        0,0,1,0,0,0,0,0;...
%        0,0,0,0,0,0,0,0;...
%        0,0,0,0,0,0,0,0;...
%        0,0,0,0,0,0,0,0;...
%        0,0,0,0,0,0,0,0;...
%        0,0,0,0,0,0,0,0;...
%        0,0,0,0,0,0,0,0;...
%        0,0,0,0,0,0,0,0;...
%        0,0,0,0,0,0,0,0;...
%        0,0,0,0,0,0,0,0;...
%        0,0,0,0,0,0,1,1;...
%        0,0,0,0,0,1,0,1];


%ISA
%LOADA  '0000'
%LOADB  '0001'
%ADDA,B '0011' (store result in A and reg_OUT)
%HALT   '0010'

%Programme
%Pogramme ci-dessous traduit assembleur avec adresses 8 bits, architecture VN:
%LOADA '1111' ; charge le contenu à l'adresse 1111 dans A
%LOADB '1110' ; charge le contenu à l'adresse 1110 dans B
%ADDA,B
%HALT

%opcode 8 bit, 4 bits opérande, 4 bits adresse: o,o,o,o,a,a,a,a

%chargement du contenu du fichier assembleur:

fileID = fopen('prog.asm', 'r');
if fileID == -1, error('Cannot open file: %s', filename); end
format = 'char';
Data = fread(fileID, Inf, format);
fclose(fileID);

%recherche des opcodes
%découpage en lignes
[NL,point_virgule] = recherche_NL_PV(Data,1,length(Data));
[data_ligne_brute] = decoupage_buffer(Data,1,length(Data),NL,point_virgule);
char(data_ligne_brute.ligne)
for i = 1:length(data_ligne_brute)
    instructions(i) = decoupage_ligne(data_ligne_brute(i));
end

bloc_RAM = assembleur(instructions);
ram_as_matlab_matrix(bloc_RAM);



function [NL,point_virgule] = recherche_NL_PV(buffer,depart,long_buffer)
%NL = zeros(long_buffer,1)-1;
compteur_NL = 1;
%point_virgule = NL;
compteur_pv = 1;
for i = depart:long_buffer
    if(i < long_buffer+1)
        if((buffer(i) == 10)) %attention si on coupe le buffer entre le 13 et 10
            NL(compteur_NL) = i;
            compteur_NL = compteur_NL+1;
        end
    else
        if((buffer(i) == 13) ) %attention si on coupe le buffer entre le 13 et 10
            NL(compteur_NL) = i;
            compteur_NL = compteur_NL+1;
        end
    end
    
    if((buffer(i) == 59))
        point_virgule(compteur_pv) = i;
        compteur_pv = compteur_pv + 1;
    end
end
end

function [data_ligne_brute] = decoupage_buffer(buffer,depart,long_buffer,NL,point_virgule)
%data_extraites = struct('ligne',0,'temps',0,'AX',0,'AY',0,'AZ',0,'complete',1);
for i = 1:length(NL)
    if(i == 1)
        data_extraites(i) = struct('ligne',(buffer(depart:(NL(1)-2)))','indice',i,'index_debut',depart);
        %data_extraites{i} = (buffer(depart:(NL(1)-1)))';
    else
        if( NL(i) < (long_buffer))
            data_extraites(i) = struct('ligne',(buffer((NL(i-1)+1):(NL(i)-2)))','indice',i,'index_debut',(NL(i-1)+2));
            %data_extraites{i} = (buffer((NL(i-1)+2):(NL(i)-1)))';
        else
            data_extraites(i) = struct('ligne',(buffer((NL(i-1)+1):long_buffer-2))','indice',i,'index_debut',(NL(i-1)+2));
            %data_extraites{i} = (buffer((NL(i-1)+2):long_buffer))';
        end
    end
    ligne = data_extraites(i).ligne;
    ligne_clean = ligne;
    for k = 1:length(ligne)
        if(ligne(k) == ';')
            ligne_clean = ligne(1:k-1);
        end
    end
    data_extraites(i).ligne = ligne_clean;
    data_ligne_brute(i) = data_extraites(i);
end
end

function [instruction] = decoupage_ligne(data)
longueur_ligne = length(data.ligne);
%on cherche ici les fronts montants du caractère espace dans la ligne
isspace = double(data.ligne == 32);
disspace = diff(isspace);
compteur = 1;
fm = [];

for i= 1 : longueur_ligne-1
    if((disspace(i) == 1))
        fm(compteur) = i+1;
        compteur = compteur + 1;
    end
end
%decoupage de la ligne
switch length(fm)
    case 0
        instruction = struct('variable',0,'nb_blocs',0,'opcode','','operande1','','operande2','','operande3','','direct',0,'adresse',0,'vecteur',0,'n_opcode',0);
    case 1
        instruction = struct('variable',0,'nb_blocs',1,'opcode',data.ligne(1:fm(1)-1),'operande1','','operande2','','operande3','','direct',0,'adresse',0,'vecteur',0,'n_opcode',0);
    case 2
        instruction = struct('variable',0,'nb_blocs',2,'opcode',data.ligne(1:fm(1)-1),'operande1',data.ligne(fm(1)+1:fm(2)-1),'operande2','','operande3','','direct',0,'adresse',0,'vecteur',0,'n_opcode',0);
    case 3
        instruction = struct('variable',1,'nb_blocs',3,'opcode',data.ligne(1:fm(1)-1),'operande1',data.ligne(fm(1)+1:fm(2)-1),'operande2',data.ligne(fm(2)+1:fm(3)-1),'operande3','','direct',0,'adresse',0,'vecteur',0,'n_opcode',0);
end

end

function [bloc_RAM] = assembleur(instructions)
nb_opcodes = 0;
nb_variables = 0;

for i = 1:length(instructions)
    if( (instructions(i).variable == 0) && (instructions(i).nb_blocs > 0)) % l'instruction courante n'est pas une variable et ce n'est pas un saut de ligne
        nb_opcodes = nb_opcodes + 1;
        code(nb_opcodes) = instructions(i);
        
    elseif(instructions(i).variable == 1) %cas des variables séparé
        nb_variables = nb_variables + 1;
        variables(nb_variables) = instructions(i);
    end
end

%pre allocation pour tout le monde, sans verification du code (on verifiera
%après): on connait le nombre d'instructions et de variables dans le code, on peut tout
%placer. Il faut un octet par instruction, et un octet par variable.

longueur_totale = nb_opcodes+nb_variables;
bloc_RAM = zeros(longueur_totale,8);
%on place les variables d'abord, on met les adresses des variables
for i = 1:nb_variables
    variables(i).adresse = dec2bin(longueur_totale - (nb_variables - i),4);
    %val_RAM(i) = bin2dec(tab2str(RAM(i,:)));
end

%Ensuite les instructions
for i = 1:nb_opcodes
    code(i).adresse = dec2bin(i,4);
    %val_RAM(i) = bin2dec(tab2str(RAM(i,:)));
end

[code,variables_demandees] = verification_addressage(code);

for i = 1:length(variables_demandees)
    for k = 1:nb_variables
        if(norm(variables(k).operande1 - variables_demandees(i).variable) == 0)
            variables_demandees(i).id_var_code = k;
        end
    end
end

adresses_instructions = find([code(:).direct] == 0);

for i = 1:length(variables_demandees)
    code(adresses_instructions(i)).vecteur = variables(variables_demandees(i).id_var_code).adresse;
end

for i = 1:nb_opcodes
    if(code(i).direct == 1)
        code(i).vecteur = dec2bin(0,4);
    end
end

%ISA
%LOADA  '0000'
%LOADB  '0001'
%ADD '0011' (store result in A and reg_OUT)
%HALT   '0010'

for i = 1:nb_opcodes
    switch char(code(i).opcode)
        case 'LOADA'
            code(i).n_opcode = '0000';
        case 'LOADB'
            code(i).n_opcode = '0001';
        case 'ADD'
            code(i).n_opcode = '0011';
        case 'HALT'
            code(i).n_opcode = '0010';
    end
end

for i = 1:nb_variables
    variables(i).vecteur =  dec2bin(str2num(char(variables(i).operande2)),8);
end

for i = 1:nb_opcodes
    for k = 1:4
        if((code(i).n_opcode(k)) == '0')
            bloc_RAM(i,k) = 0;
        else
            bloc_RAM(i,k) = 1;
        end
    end
    for k = 1:4
        if((code(i).vecteur(k)) == '0')
            bloc_RAM(i,k+4) = 0;
        else
            bloc_RAM(i,k+4) = 1;
        end
    end
end

for i = 1:nb_variables
    for k = 1:8
        if((variables(i).vecteur(k)) == '0')
            bloc_RAM(i+nb_opcodes,k) = 0;
        else
            bloc_RAM(i+nb_opcodes,k) = 1;
        end
    end
end

end

function [code,variables_demandees] = verification_addressage(code)
%on vérifie juste que la première opérande est un chiffre ou un nom
variables_demandees(1) = struct('variable','','id_var_code',0);
compteur_variables = 1;
for i = 1:length(code)
    operande1 = code(i).operande1;
    test =  func_test_variable(operande1);
    
    if(test == 0)
        code(i).direct = 1;
    else
        variables_demandees(compteur_variables) = struct('variable',operande1,'id_var_code',0);
        compteur_variables = compteur_variables + 1 ;
    end
end



end

function test =  func_test_variable(operande)
test_variable = 0;
for i = 1:length(operande)
    if(operande(i) > 57 ||  operande(i) < 48)
        test_variable = test_variable + 1;
    end
end
test = 0;
if(test_variable > 0)
    test = 1;
end

end

function ram_as_matlab_matrix(ram)
[lignes,colonnes] = size(ram);
vec = ['['];
for i = 1:lignes
    vec = [vec,[num2str(ram(i,1:8)),';']];
end
vec = [vec,'];']
end
