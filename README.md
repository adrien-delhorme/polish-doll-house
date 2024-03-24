# TODO

- [x] régler le problème des tailles des traits et polices des dimensions
- [x] régler le problème des Labels du Roof qui ne sont pas aligné en 3d
- [ ] renommer wood_thickness sans faire référence au wood ? par exemple : plate
- [x] préfixer les variables spéciales avec le nom de la lib
- [ ] documenter les variables et les rendre accessibles au configurateur
- [ ] créer une librairie plus compact que dimensional-drawings
    - [x] renommer les constantes
    - [x] ajouter des constantes pour les tailles de flèches
    - [x] ajouter une variable spéciale pour l'espacement entre les dimensions et la forme (10)
    - [ ] trouver un nom : openscad-dimensions
- [ ] créer une librairie pour faire des angles en bois (comme la toiture)
    - [x] ajouter le with_dimensions
    - [x] inclure les schémas de coupes d'angles dans la lib
    - [ ] inclure le SecondFloor comme children de la house ?
    - [ ] trouver un nom : openscad-wood-roof
- [ ] créer une librairie pour faire des escaliers en bois
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

# Pourquoi utiliser OpenSCAD pour afficher les dimensions ?

Pourquoi ne pas exporter le modèle 3D fait dans OpenSCAD pour ensuite l'importer dans Sketchup par exemple et dessiner les dimensions dans cet outil ?
1. Si un élément du modèle change de taille, il faut re-exporter et re-dessiner les dimensions
2. Pour avoir les dimensions en 3D et en Flat, il faut les dessiner deux fois

# Module de création de toit

On décrit les différentes pentes et longueurs des pans de toit successivement.
Les pentes sont en absolute par rapport à l'horizontal (et non relativement par rapport à la précédente).

Une jonction se situe entre deux pans de toit.
S'il n'y a pas de pan de toit qui précède ou qui suit alors la jonction et perpendiculaire au pan de toit.
Sinon, l'angle de la jonction est égal à la moitié de l'angle relatif entre les deux pans.

Problèmes :
- le lazy union va empêcher d'itérer sur les children ? Non car on ne passe pas de children, on passe un vecteur qui décrit des angles et des longeurs, largeur, épaisseur

# Module de création de maison (House)

Le hack pour éviter le lazy union créé un bug lors de l'affichage du fihier house.scad (on voit tous les clipping mask)

# Fichier récalcitrants

Les fichiers room1.scad, room2.scad, main.scad et v0.scad sont supprimés mais reviennent régulièrement hanter le dossier
