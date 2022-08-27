LOADA variable1  ;charge le contenu de l'addresse variable1 dans le registre A
LOADB variable2  ;charge le contenu de l'addresse variable2 dans le registre B
ADD         ;Additionne A à B et stocke le résultat dans A
LOADB variable2  ;charge le contenu de l'addresse variable2 dans le registre B
ADD ;
LOADB variable1  ;
ADD ;
LOADB variable3  ;
ADD ;
HALT          ;Stoppe l'éxécution

BYT variable1 38 ; bien ajouter un espace après chaque instruction, point virgule obligatoire à la fin de chaque ligne
BYT variable2 12 ;
BYT variable3 15 ;
