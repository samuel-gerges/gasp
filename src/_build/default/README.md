Auteur
======

Gerges Samuel 71804327 (MONÔME)

Parties traitées et architecture
================================

Pour ce projet, j'ai traité l'intégralité du sujet minimal et j'ai implémenté 3 extensions qui sont les suivantes :
- une instruction permettant de changer l'épaisseur des traits.
- une instruction permettant de changer la couleur des traits.
- 'Si `expression` alors `instruction`', sans 'Sinon' derrière.

Voici une brève description des fichiers de mon programme :

* `ast.ml` : définit la syntaxe abstraite de la grammaire.

* `lexer.mll` : qui est le fichier d'entrée pour produire l'analyse lexicale (avec `ocamllex`).

* `parser.mly` : qui va parser l'entrée en utilisant les jetons qui y sont déclarés.

Les deux fichiers précédents vont alors permettre d'obtenir un arbre de syntaxe abstraite qui va être donné en paramètre aux fonctions princiaples des deux fichiers suivants.

* `typecheck.ml` : les fonctions définies dans ce fichier vont s'assurer que toute variable utilisée dans l'entrée est bien déclarée, et qu'elle est bien déclarée une seule fois.
**Remarque :** dans le cas d'une variable déclarée et utilisée sans qu'elle ait été initialisée avec une valeur, j'ai choisi de lui attribuer la valeur 0.

* `interpreter.ml` : les fonctions définies dans ce fichier vont interpréter l'entrée et produire l'affichage à l'écran.

* `main.ml` : fichier principal du programme qui va :
   1. récupérer l'entrée standard
   2. faire l'analyse syntaxique sur l'entrée standard récupérée, ce qui va alors produire un arbre de syntaxe abstraite
   3. appeler la fonction principale du module `Typecheck` sur l'AST produit, qui va vérifier le typage
   4. appeler la fonction principale du module `Interpreter` sur l'AST produit, qui va se charger de produire l'affichage

Tout ceci est fait dans un `try catch` qui va potentiellement rattraper les différentes exceptions qu'on a définies dans les modules `Lexer`, `Parser` et `Typecheck`, et des messages d'erreurs appropriés seront alors affichés à l'écran.
**À savoir :** l'erreur de division par 0 et de sortie du curseur du canevas sont traitées dans l'interpréteur, et des messages d'erreurs sont alors affichés à l'écran quand elles se produisent.

Comment compiler et exécuter le projet ?
========================================

Pour compiler le projet j'utilise l'outil `dune` et un `Makefile`. Il vous suffira alors de taper `make` pour obtenir un exécutable `main.exe` que vous pourrez exécuter de deux manières :
* `./main.exe`, sans argument. Le programme attendra alors que vous écriviez dans l'entrée standard et agira sur cette entrée. Il vous suffit de faire `ENTRÉE` puis `CTRL+D`, dès que vous aurez fini d'écrire, pour que le programme traite votre entrée.

* `./main.exe fichier_test`, avec `fichier_test` un chemin vers un fichier de test que vous pourrez récupérer dans le répertoire `test`. Un exemple d'utilisation serait : `./main.exe ../test/TestAngle`.

Pour garder la fenêtre graphique ouverte j'utilise la fonction `Graphics.wait_next_event` qui attend alors qu'on appuie sur la touche `e` du clavier pour la fermer.

J'ai rajouté des fichiers tests `TestCouleurEpaisseur`, `TestErrCouleur`, `TestErrEpaisseur`, `TestSiAlors`, `TestSiAlorsSinon`, `TestTantQue` qui traitent tout ce que les exemples déjà présents ne traitaient pas (y compris les extensions que j'ai implémentées).
