# TODO

- [x] régler le problème des tailles des traits et polices des dimensions
- [x] régler le problème des Labels du Roof qui ne sont pas aligné en 3d
- [x] renommer wood_thickness sans faire référence au wood ? par exemple : material ou plate ?
- [x] préfixer les variables spéciales avec le nom de la lib
- [x] améliorer les variables à paramétrer : qu'est-ce que D et L ? Renommer
- [x] rendre les modules moins dépendants de ces paramètres
- [x] documenter les variables et les rendre accessibles au configurateur
- [x] pouvoir donner des labels aux slopes du roof
- [x] le morceau de mur du premier étage est situé trop loin en vue 2D
- [ ] créer une librairie plus compact que dimensional-drawings
    - [x] renommer les constantes
    - [x] ajouter des constantes pour les tailles de flèches
    - [x] ajouter une variable spéciale pour l'espacement entre les dimensions et la forme (10)
    - [ ] trouver un nom : openscad-dimensions
- [ ] créer une librairie pour faire des angles en bois (comme la toiture)
    - [x] ajouter le with_dimensions
    - [x] inclure les schémas de coupes d'angles dans la lib
    - [ ] inclure le SecondFloor comme children de la house ?
    - [ ] trouver un nom : openscad-roof-blueprint
- [ ] créer une librairie pour faire des escaliers en bois (openscad-stairs-blueprint)
- [ ] créer une librairie pour faire une maison de poupée
- [ ] créer une librairie pour disposer toutes les pièces d'un éléments les uns à côté des autres (rectangle packing algorithme) --> pas possible dans OpenSCAD (python ?)
	
- Mise à plat des éléments : http://scottbezek.blogspot.com/2016/05/openscad-rendering-tricks-part-2-laser.html
- Rectangle packing algorithme : https://github.com/mapbox/potpack
- Librairie pour afficher les côtes : https://github.com/pwpearson/dimensional-drawings
- OpenSCAD BOSL2 sort : https://github.com/revarbat/BOSL2/wiki/comparisons.scad#function-sort
- Library example : https://github.com/larsch/lasercut-box-openscad
- Polycube : https://github.com/imageguy/openscad_primitives/blob/master/polycube.scad

# Pourquoi on ne fait pas des projections pour les vues flat ?

Car sinon ça supprime les textes

# Traçage des dimensions

## Dans un outil externe (SketchUp, LibreCad, Inkscape, ...)

1. Si un élément du modèle change de taille, il faut re-exporter et re-dessiner les dimensions --> est-ce que ça arrive souvent ?
2. Pour avoir les dimensions en 3D et en Flat, il faut les dessiner deux fois --> les dimensions en 3D sont elles nécessaires

## Dans OpenSCAD

1. Il faut ajouter les dimensions dans le code, c'est long et des erreurs de calcul peuvent se glisser 
2. Il faut calculer toutes les dimensions, même celles qui sont obtenus par fusion/découpe de formes, c'est très long et sujet aux erreurs

Pourquoi ne pas exporter le plan en SVG et utiliser un outil qui afficherait automatiquement les côtes sur ce SVG ?
Par exemple LibreCAD à l'air de faire ça très bien. Mais il faut nécessairement faire ça manuellement.
Une solution pourrait être d'exporter certaines Line avec une propriété particulière dans le SVG et ensuite utiliser un script pour afficher les longeurs sur ces lignes.
Mais ça paraît très compliqué.
Ou alors exporter direct en DXF puis utiliser https://github.com/mozman/ezdxf pour rajouter les dimensions ? https://ezdxf.mozman.at/docs/tutorials/linear_dimension.html#tut-linear-dimension


# Module de création de toit

On décrit les différentes pentes et longueurs des pans de toit successivement.
Les pentes sont en absolute par rapport à l'horizontal (et non relativement par rapport à la précédente).

Une jonction se situe entre deux pans de toit.
S'il n'y a pas de pan de toit qui précède ou qui suit alors la jonction et perpendiculaire au pan de toit.
Sinon, l'angle de la jonction est égal à la moitié de l'angle relatif entre les deux pans.

Problèmes :
- le lazy union va empêcher d'itérer sur les children ? Non car on ne passe pas de children, on passe un vecteur qui décrit des angles et des longeurs, largeur, épaisseur

# Module de création de maison (House)

Le hack pour éviter le lazy union créé un bug lors de l'affichage du fichier house.scad (on voit tous les clipping mask)
