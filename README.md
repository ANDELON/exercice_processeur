# exercice_processeur

Ce petit projet est un exercice (basé sur rien d'existant, pour tester mes connaissances) en Matlab, qui comprend:

- un simulateur de cpu 8 bits, simplifié au niveau logiciel. Il n'a que quelques instructions simples, LOADA, LOADB, ADD et HALT (et c'est tout). 
Il simule l'utilisation d'un bus par l'utilisation d'une variable. La modélisation du fetch et de l'éxécution est un switch case, plus des utilitaires pour utiliser
une représentation mémoire visuelle, de type matrice.
Le cpu n'a pas de système d'addressage évolué, et ne peut adresser que 4 bits de mémoire, soit 16 octets.
L'idée est de pratiquer la conception processeur de manière basique et rapide.

- un assembleur (écrit en Matlab également), qui lit un fichier texte où sont insrites les instructions, et qui peut gérer l'addressage de variables, et affiche le contenu mémoire
compatible avec le simulateur de cpu (il faut faire un copier-coller). Le code est à reprendre, j'ai simplement empilé (en les découvrant) les différents modules nécessaires pour un assembleur. Le code est donc brouillon et plutôt sale.

Et c'est tout!

Ce projet me sert aussi à m'entrainer à utiliser GIT.

Un modèle logisim de ce petit processeur, et notamment de la machine à état sera déposé quand il sera fait.

Les codes ont peut d'intérêt en eux-mêmes, ceci dit vous pouvez les utiliser librement si vous en trouvez l'usage.
