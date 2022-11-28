include <dimensional-drawings/dimlines.scad>;

// parameters (in millimeters)
x = 80;

H = 2 * x; // Floor height
d = 48; // Door and windows width

D = 4 * x; // Width
L = 3 * x; // Length

wood_thickness = 5;
eps = 0.1;

// Labelling
LABEL_COLOR = "white";
DIMENSION_COLOR = "white";
DIM_LINE_WIDTH = 0.5;
DIM_FONTSCALE = 1 * DIM_LINE_WIDTH;
$fn = 100;
