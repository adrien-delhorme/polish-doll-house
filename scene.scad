include <libs/dimensions/constants.scad>;
include <libs/dimensions/dimensions.scad>;

include <modules/main.scad>;
include <modules/large_room.scad>;
include <modules/small_room.scad>;
include <modules/stairs.scad>;


/* [Parameters] */
x = 80;

// Floor height
H = 2 * x;

// Door and windows width
d = 48;

// Width
D = 4 * x;

// Length
L = 3 * x;

// Tickness of the wood plank (millimeters)
wood_thickness = 5;

/* [Labelling] */
// Show labels
$show_labels = true;
$roof_show_labels = $show_labels;
// Color
LABEL_COLOR = "black"; // [aliceblue antiquewhite, aqua, aquamarine, azure, beige, bisque, black, blanchedalmond, blue, blueviolet, brown, burlywood, cadetblue, chartreuse, chocolate, coral, cornflowerblue, cornsilk, crimson, cyan, darkblue, darkcyan, darkgoldenrod, darkgray, darkgreen, darkgrey, darkkhaki, darkmagenta, darkolivegreen, darkorange, darkorchid, darkred, darksalmon, darkseagreen, darkslateblue, darkslategray, darkslategrey, darkturquoise, darkviolet, deeppink, deepskyblue, dimgray, dimgrey, dodgerblue, firebrick, floralwhite, forestgreen, fuchsia, gainsboro, ghostwhite, gold, goldenrod, gray, green, greenyellow, grey, honeydew, hotpink, indianred, indigo, ivory, khaki, lavender, lavenderblush, lawngreen, lemonchiffon, lightblue, lightcoral, lightcyan, lightgoldenrodyellow, lightgray, lightgreen, lightgrey, lightpink, lightsalmon, lightseagreen, lightskyblue, lightslategray, lightslategrey, lightsteelblue, lightyellow, lime, limegreen, linen, magenta, maroon, mediumaquamarine, mediumblue, mediumorchid, mediumpurple, mediumseagreen, mediumslateblue, mediumspringgreen, mediumturquoise, mediumvioletred, midnightblue, mintcream, mistyrose, moccasin, navajowhite, navy, oldlace, olive, olivedrab, orange, orangered, orchid, palegoldenrod, palegreen, paleturquoise, palevioletred, papayawhip, peachpuff, peru, pink, plum, powderblue, purple, red, rosybrown, royalblue, saddlebrown, salmon, sandybrown, seagreen, seashell, sienna, silver, skyblue, slateblue, slategray, slategrey, snow, springgreen, steelblue, tan, teal, thistle, tomato, turquoise, violet, wheat, white, whitesmoke, yellow, yellowgreen]


/* [Dimensions] */
// Show dimensions
$show_dimensions = true;
$roof_show_dimensions = $show_dimensions;

// Color
DIMENSION_COLOR = "black"; // [aliceblue antiquewhite, aqua, aquamarine, azure, beige, bisque, black, blanchedalmond, blue, blueviolet, brown, burlywood, cadetblue, chartreuse, chocolate, coral, cornflowerblue, cornsilk, crimson, cyan, darkblue, darkcyan, darkgoldenrod, darkgray, darkgreen, darkgrey, darkkhaki, darkmagenta, darkolivegreen, darkorange, darkorchid, darkred, darksalmon, darkseagreen, darkslateblue, darkslategray, darkslategrey, darkturquoise, darkviolet, deeppink, deepskyblue, dimgray, dimgrey, dodgerblue, firebrick, floralwhite, forestgreen, fuchsia, gainsboro, ghostwhite, gold, goldenrod, gray, green, greenyellow, grey, honeydew, hotpink, indianred, indigo, ivory, khaki, lavender, lavenderblush, lawngreen, lemonchiffon, lightblue, lightcoral, lightcyan, lightgoldenrodyellow, lightgray, lightgreen, lightgrey, lightpink, lightsalmon, lightseagreen, lightskyblue, lightslategray, lightslategrey, lightsteelblue, lightyellow, lime, limegreen, linen, magenta, maroon, mediumaquamarine, mediumblue, mediumorchid, mediumpurple, mediumseagreen, mediumslateblue, mediumspringgreen, mediumturquoise, mediumvioletred, midnightblue, mintcream, mistyrose, moccasin, navajowhite, navy, oldlace, olive, olivedrab, orange, orangered, orchid, palegoldenrod, palegreen, paleturquoise, palevioletred, papayawhip, peachpuff, peru, pink, plum, powderblue, purple, red, rosybrown, royalblue, saddlebrown, salmon, sandybrown, seagreen, seashell, sienna, silver, skyblue, slateblue, slategray, slategrey, snow, springgreen, steelblue, tan, teal, thistle, tomato, turquoise, violet, wheat, white, whitesmoke, yellow, yellowgreen]

// Font size
DIM_LINE_WIDTH = 0.5;
DIM_FONTSCALE = 1 * DIM_LINE_WIDTH;

// Space between dimensions and elements
$dimensions_gap = 10;
$roof_dimensions_gap = $dimensions_gap;

/* [View] */
// 3D render
$render_3d = false;
$roof_render_3d = $render_3d;

// Space between 2D elements
$gap_2d = 20;
$roof_gap_2d = $gap_2d;

/* [Hidden]*/
eps = 0.1;
$fn = 100;


module 3d() {
  translate([wood_thickness, x, H + 2 * wood_thickness])
    Main(width=D, depth=2 * x);

  LargeRoom(width=D, depth=3 * x, height=H);

  translate([-d - wood_thickness, 0, H + 2 * wood_thickness]) {
    SmallRoom(width=L, depth=x, height=H);
  }

  translate([D, 0, 0]) {
    Stairs(width=L, depth=2 * x, height=H);
  }
}

module 2d() {
  Main(width=D, depth=2 * x);

  translate([4 * L, 0, 0])
    LargeRoom(width=D, depth=3 * x, height=H);

  translate([2*L, -2*(x+$gap_2d)-H-2*$gap_2d, 0])
    SmallRoom(width=L, depth=x, height=H);

  translate([0, -3*(x+$gap_2d)-2*x-2*$gap_2d, 0])
    Stairs(width=L, depth=2 * x, height=H);
}

if ($render_3d == true) 3d();
else 2d();
