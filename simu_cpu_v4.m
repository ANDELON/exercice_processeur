%simu cpu v3
clc
clear;
global bus;
global reg_A;
global reg_B;
global reg_PC;
global reg_IR;
global reg_CS;
global clock;
global RAM;
global petit_compteur;
global reg_OUT;



bus = [0,0,0,0,0,0,0,0];
reg_A = [0,0,0,0,0,0,0,0];
reg_B = [0,0,0,0,0,0,0,0];
reg_PC = [0,0,0,0,0,0,0,1];
reg_IR = [0,0,0,0,0,0,0,0];
reg_CS = [0,0,0,0,0,0,0,0,0,0,0,0,0]; %B2A,B2B,...
reg_OUT = [0,0,0,0,0,0,0,0];

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
RAM = [0  0  0  0  0  1  1  1;0  0  0  1  0  1  1  0;0  0  1  1  0  0  0  0;0  0  1  0  0  0  0  0;0  0  0  0  1  0  1  0;0  0  0  0  1  1  0  0;0  0  0  0  1  1  1  1;];
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
[lignes,colonnes] = size(RAM);
for i = 1:lignes
    val_RAM(i) = bin2dec(tab2str(RAM(i,:)));
end
val_RAM = val_RAM';

for i = 1:lignes
    RAMH(i) = bin2dec(tab2str(RAM(i,1:4)));
    RAML(i) = bin2dec(tab2str(RAM(i,5:8)));
end
RAMH = RAMH';
RAML = RAML';


clock = 1;
petit_compteur = 1;
while clock <55
    halt = action_CS(1);
    if(halt)
        clock = 55;
    else
        clock = clock + 1;
    end
    
end
disp('Fin');




function bus =  reg_set_bus(reg)
bus = reg;
end

function reg =  bus_set_reg(bus)
reg = bus;
end

function bus = ALU(reg_A,reg_B,commande)
A = bin2dec(tab2str(reg_A));
B = bin2dec(tab2str(reg_B));
switch commande
    case '+'
        bus = str2tab(dec2bin(A+B,8));
    case '-'
        bus = str2tab(dec2bin(A-B,8));
end
end

function string = tab2str(reg)
tab = 1:length(reg);
for i = length(reg):-1:1
    string(tab(i)) = num2str(reg(i));
end
end

function tab = str2tab(string)
for i = 1:length(string)
    tab(i) = str2num(string(i));
end
end

function reg_CS = set_CS(reg_IR)
temp = reg_IR(1:4);
temp = bin2dec(tab2str(temp));
switch temp
    case 0 %LOAD bus to A
        reg_CS = [1,0,0,0,0,0,0,0,0,0,0,0,0];
    case 1 %LOAD bus to B
        reg_CS = [0,1,0,0,0,0,0,0,0,0,0,0,0];
    case 2
        reg_CS = [0,0,1,0,0,0,0,0,0,0,0,0,0];
    case 3
        reg_CS = [0,0,1,1,0,0,0,0,0,0,0,0,0];
end
end

function reg_PC = reg_inc(reg_PC)
temp = bin2dec(tab2str(reg_PC));
reg_PC = str2tab(dec2bin(temp+1,8));
end

function halt = action_CS(val)
global bus;
global reg_A;
global reg_B;
global petit_compteur;
global reg_IR;
global reg_PC;
global reg_CS;
global RAM;
global reg_OUT;

halt = 0;

temp = bin2dec(tab2str(reg_IR(1:4)));

% switch temp
%     case 1
%         reg_A = bus_set_reg(bus);
%     case 2
%         reg_B = bus_set_reg(bus);
% end

switch petit_compteur
    case 1  %IF
        bus = RAM(bin2dec(tab2str(reg_PC(5:8))),:);%lecture RAM
    case 2   %IF
        reg_IR = bus_set_reg(bus);
        reg_PC = reg_inc(reg_PC); %incrémente le PC
    case 3  %IE
        switch temp  %IE
            case 0
                bus = RAM(bin2dec(tab2str(reg_IR(5:8))),:);%première micro instruction de l'opcode 1
                %pour ces µinstructions, ça devrait se passer en deux
                %étapes: 
                %pousser la valeur de reg_IR sur le bus et récupérer le bus sur reg_RIMAR
                %pousser la valeur à l'adresse ram sur le bus
                
            case 1
                bus = RAM(bin2dec(tab2str(reg_IR(5:8))),:);%première micro instruction de l'opcode 2

            case 2
                halt = 1;
            case 3
                bus = ALU(reg_A,reg_B,'+');
        end
    case 4  %IE
        switch temp
            case 0
                reg_A = bus_set_reg(bus);%deuxième micro instruction de l'opcode 1
            case 1
                reg_B = bus_set_reg(bus);%deuxième micro instruction de l'opcode 2
            case 3
                reg_OUT = bus_set_reg(bus);
                reg_A = bus_set_reg(bus);
        end
    case 5  %IE ou MB
        switch temp
            case 0
                %troisième micro instruction de l'opcode 1
            case 1
                %troisième micro instruction de l'opcode 2
        end
    case 6  %RAZ modules FETCH et EXECUTE
        petit_compteur = 0;
end


petit_compteur = petit_compteur + 1;
end


