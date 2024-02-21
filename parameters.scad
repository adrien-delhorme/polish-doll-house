
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

$render_3d = false;
$roof_render_3d = $render_3d;
$gap_2d = 20;
$roof_gap_2d = $gap_2d;

$show_dimensions = true;
$roof_show_dimensions = $show_dimensions;
$dimensions_gap = 10;
$roof_dimensions_gap = $dimensions_gap;

$show_labels = true;
$roof_show_labels = $show_labels;

$fn = 100;
