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
SHOW_LABELS = true;
ROOF_SHOW_LABELS = SHOW_LABELS;

// Color
LABEL_COLOR = "black"; // [aliceblue antiquewhite, aqua, aquamarine, azure, beige, bisque, black, blanchedalmond, blue, blueviolet, brown, burlywood, cadetblue, chartreuse, chocolate, coral, cornflowerblue, cornsilk, crimson, cyan, darkblue, darkcyan, darkgoldenrod, darkgray, darkgreen, darkgrey, darkkhaki, darkmagenta, darkolivegreen, darkorange, darkorchid, darkred, darksalmon, darkseagreen, darkslateblue, darkslategray, darkslategrey, darkturquoise, darkviolet, deeppink, deepskyblue, dimgray, dimgrey, dodgerblue, firebrick, floralwhite, forestgreen, fuchsia, gainsboro, ghostwhite, gold, goldenrod, gray, green, greenyellow, grey, honeydew, hotpink, indianred, indigo, ivory, khaki, lavender, lavenderblush, lawngreen, lemonchiffon, lightblue, lightcoral, lightcyan, lightgoldenrodyellow, lightgray, lightgreen, lightgrey, lightpink, lightsalmon, lightseagreen, lightskyblue, lightslategray, lightslategrey, lightsteelblue, lightyellow, lime, limegreen, linen, magenta, maroon, mediumaquamarine, mediumblue, mediumorchid, mediumpurple, mediumseagreen, mediumslateblue, mediumspringgreen, mediumturquoise, mediumvioletred, midnightblue, mintcream, mistyrose, moccasin, navajowhite, navy, oldlace, olive, olivedrab, orange, orangered, orchid, palegoldenrod, palegreen, paleturquoise, palevioletred, papayawhip, peachpuff, peru, pink, plum, powderblue, purple, red, rosybrown, royalblue, saddlebrown, salmon, sandybrown, seagreen, seashell, sienna, silver, skyblue, slateblue, slategray, slategrey, snow, springgreen, steelblue, tan, teal, thistle, tomato, turquoise, violet, wheat, white, whitesmoke, yellow, yellowgreen]


/* [Dimensions] */
// Show dimensions
SHOW_DIMENSIONS = true;
ROOF_SHOW_DIMENSIONS = SHOW_DIMENSIONS;

// Color
DIMENSION_COLOR = "black"; // [aliceblue antiquewhite, aqua, aquamarine, azure, beige, bisque, black, blanchedalmond, blue, blueviolet, brown, burlywood, cadetblue, chartreuse, chocolate, coral, cornflowerblue, cornsilk, crimson, cyan, darkblue, darkcyan, darkgoldenrod, darkgray, darkgreen, darkgrey, darkkhaki, darkmagenta, darkolivegreen, darkorange, darkorchid, darkred, darksalmon, darkseagreen, darkslateblue, darkslategray, darkslategrey, darkturquoise, darkviolet, deeppink, deepskyblue, dimgray, dimgrey, dodgerblue, firebrick, floralwhite, forestgreen, fuchsia, gainsboro, ghostwhite, gold, goldenrod, gray, green, greenyellow, grey, honeydew, hotpink, indianred, indigo, ivory, khaki, lavender, lavenderblush, lawngreen, lemonchiffon, lightblue, lightcoral, lightcyan, lightgoldenrodyellow, lightgray, lightgreen, lightgrey, lightpink, lightsalmon, lightseagreen, lightskyblue, lightslategray, lightslategrey, lightsteelblue, lightyellow, lime, limegreen, linen, magenta, maroon, mediumaquamarine, mediumblue, mediumorchid, mediumpurple, mediumseagreen, mediumslateblue, mediumspringgreen, mediumturquoise, mediumvioletred, midnightblue, mintcream, mistyrose, moccasin, navajowhite, navy, oldlace, olive, olivedrab, orange, orangered, orchid, palegoldenrod, palegreen, paleturquoise, palevioletred, papayawhip, peachpuff, peru, pink, plum, powderblue, purple, red, rosybrown, royalblue, saddlebrown, salmon, sandybrown, seagreen, seashell, sienna, silver, skyblue, slateblue, slategray, slategrey, snow, springgreen, steelblue, tan, teal, thistle, tomato, turquoise, violet, wheat, white, whitesmoke, yellow, yellowgreen]

// Line width
DIMENSION_LINE_WIDTH = 0.5;

// Font size
DIMENSION_FONTSIZE = 0.5;

// Space between dimensions and elements
DIMENSION_GAP = 10;
ROOF_DIMENSION_GAP = DIMENSION_GAP;

/* [View] */
// 3D render
RENDER_3D = false;
$ROOF_RENDER_3D = RENDER_3D;

// Space between 2D elements
GAP_2D = 20;
ROOF_GAP_2D = GAP_2D;

/* [Hidden] */
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

  translate([2*L, -2*(x+GAP_2D)-H-2*GAP_2D, 0])
    SmallRoom(width=L, depth=x, height=H);

  translate([0, -3*(x+GAP_2D)-2*x-2*GAP_2D, 0])
    Stairs(width=L, depth=2 * x, height=H);
}

if (RENDER_3D == true) 3d();
else 2d();
