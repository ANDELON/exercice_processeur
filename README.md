# exercice_processeur

This small project is an exercise (based on nothing existing, to test my knowledge) in Matlab, which includes:

- an 8-bit cpu simulator, simplified at the software level. It only has a few simple instructions, LOADA, LOADB, ADD, and HALT (and that's it).
It simulates the use of a bus by the use of a variable. Fetch and run modeling is a switch case, plus utilities to use
a visual memory representation, of matrix type.
The cpu does not have an advanced addressing system, and can only address 4 bits of memory, or 16 bytes.
The idea is to practice processor design in a basic and fast way.

- an assembler (also written in Matlab), which reads a text file where the instructions are written, and which can manage the addressing of variables, and displays the memory content
compatible with the cpu simulator (you have to copy and paste). The code is to be taken again, I simply stacked (by discovering them) the various modules necessary for an assembler. The code is therefore messy and rather dirty.

And that's all!

This project is also useful for me to practice using GIT.

A logisim model of this small processor, and in particular of the state machine, will be deposited when it is done.

The codes have little interest in themselves, however you can use them freely if you find the use.




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
