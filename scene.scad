include <libs/dimensions/constants.scad>;
include <libs/dimensions/dimensions.scad>;

include <modules/main.scad>;
include <modules/large_room.scad>;
include <modules/small_room.scad>;
include <modules/stairs.scad>;


/* [Parameters] */
// Height of the doll (millimeters)
doll_height = 200;

// Width of the doll (millimeters)
doll_width = doll_height * 2/8;

// Ceiling height
ceiling_height = 1.5 * doll_height;

// Door and windows width
openings_width = 1.7 * doll_width;

// Width of the house
house_width = 12 * doll_width;

// Length of the house
house_length = 10 * doll_width;

// Tickness of the material (millimeters)
material_thickness = 8;

/* [Labelling] */
// Check to show labels
SHOW_LABELS = true;
ROOF_SHOW_LABELS = SHOW_LABELS;
STAIRS_SHOW_LABELS = SHOW_LABELS;

// Color
LABEL_COLOR = "black"; // [aliceblue antiquewhite, aqua, aquamarine, azure, beige, bisque, black, blanchedalmond, blue, blueviolet, brown, burlywood, cadetblue, chartreuse, chocolate, coral, cornflowerblue, cornsilk, crimson, cyan, darkblue, darkcyan, darkgoldenrod, darkgray, darkgreen, darkgrey, darkkhaki, darkmagenta, darkolivegreen, darkorange, darkorchid, darkred, darksalmon, darkseagreen, darkslateblue, darkslategray, darkslategrey, darkturquoise, darkviolet, deeppink, deepskyblue, dimgray, dimgrey, dodgerblue, firebrick, floralwhite, forestgreen, fuchsia, gainsboro, ghostwhite, gold, goldenrod, gray, green, greenyellow, grey, honeydew, hotpink, indianred, indigo, ivory, khaki, lavender, lavenderblush, lawngreen, lemonchiffon, lightblue, lightcoral, lightcyan, lightgoldenrodyellow, lightgray, lightgreen, lightgrey, lightpink, lightsalmon, lightseagreen, lightskyblue, lightslategray, lightslategrey, lightsteelblue, lightyellow, lime, limegreen, linen, magenta, maroon, mediumaquamarine, mediumblue, mediumorchid, mediumpurple, mediumseagreen, mediumslateblue, mediumspringgreen, mediumturquoise, mediumvioletred, midnightblue, mintcream, mistyrose, moccasin, navajowhite, navy, oldlace, olive, olivedrab, orange, orangered, orchid, palegoldenrod, palegreen, paleturquoise, palevioletred, papayawhip, peachpuff, peru, pink, plum, powderblue, purple, red, rosybrown, royalblue, saddlebrown, salmon, sandybrown, seagreen, seashell, sienna, silver, skyblue, slateblue, slategray, slategrey, snow, springgreen, steelblue, tan, teal, thistle, tomato, turquoise, violet, wheat, white, whitesmoke, yellow, yellowgreen]


/* [Dimensions] */
// Check to show dimensions
SHOW_DIMENSIONS = true;
ROOF_SHOW_DIMENSIONS = SHOW_DIMENSIONS;
STAIRS_SHOW_DIMENSIONS = SHOW_DIMENSIONS;

// Color
DIMENSION_COLOR = "black"; // [aliceblue antiquewhite, aqua, aquamarine, azure, beige, bisque, black, blanchedalmond, blue, blueviolet, brown, burlywood, cadetblue, chartreuse, chocolate, coral, cornflowerblue, cornsilk, crimson, cyan, darkblue, darkcyan, darkgoldenrod, darkgray, darkgreen, darkgrey, darkkhaki, darkmagenta, darkolivegreen, darkorange, darkorchid, darkred, darksalmon, darkseagreen, darkslateblue, darkslategray, darkslategrey, darkturquoise, darkviolet, deeppink, deepskyblue, dimgray, dimgrey, dodgerblue, firebrick, floralwhite, forestgreen, fuchsia, gainsboro, ghostwhite, gold, goldenrod, gray, green, greenyellow, grey, honeydew, hotpink, indianred, indigo, ivory, khaki, lavender, lavenderblush, lawngreen, lemonchiffon, lightblue, lightcoral, lightcyan, lightgoldenrodyellow, lightgray, lightgreen, lightgrey, lightpink, lightsalmon, lightseagreen, lightskyblue, lightslategray, lightslategrey, lightsteelblue, lightyellow, lime, limegreen, linen, magenta, maroon, mediumaquamarine, mediumblue, mediumorchid, mediumpurple, mediumseagreen, mediumslateblue, mediumspringgreen, mediumturquoise, mediumvioletred, midnightblue, mintcream, mistyrose, moccasin, navajowhite, navy, oldlace, olive, olivedrab, orange, orangered, orchid, palegoldenrod, palegreen, paleturquoise, palevioletred, papayawhip, peachpuff, peru, pink, plum, powderblue, purple, red, rosybrown, royalblue, saddlebrown, salmon, sandybrown, seagreen, seashell, sienna, silver, skyblue, slateblue, slategray, slategrey, snow, springgreen, steelblue, tan, teal, thistle, tomato, turquoise, violet, wheat, white, whitesmoke, yellow, yellowgreen]

// Line width
DIMENSION_LINE_WIDTH = 0.5;

// Font size
DIMENSION_FONTSIZE = 0.5;

// Space between dimensions and elements
DIMENSION_GAP = 10;
ROOF_DIMENSION_GAP = DIMENSION_GAP;
STAIRS_DIMENSION_GAP = DIMENSION_GAP;

/* [View] */
// Check to render the view in 3D
RENDER_3D = false;
$ROOF_RENDER_3D = RENDER_3D;
STAIRS_RENDER_3D = RENDER_3D;

// Space between 2D elements
GAP_2D = 20;
ROOF_GAP_2D = GAP_2D;
STAIRS_GAP_2D = GAP_2D;

/* [Hidden] */
eps = 0.1;
$fn = 25;

main_room_width = 12 * doll_width;
main_room_length = 1.5 * doll_height;
small_room_length = 1/2 * main_room_length;
large_room_width = main_room_width;
large_room_length = main_room_length + small_room_length;
small_room_width = large_room_length;
stairs_width = small_room_width;
stairs_length = main_room_length;


module 3d() {
  translate([material_thickness, small_room_length, ceiling_height + 2 * material_thickness])
    Main(width=main_room_width, length=main_room_length);

  LargeRoom(width=large_room_width, length=large_room_length, height=ceiling_height);

  translate([-openings_width - material_thickness, 0, ceiling_height + 2 * material_thickness]) {
    SmallRoom(width=small_room_width, length=small_room_length, height=ceiling_height);
  }

  translate([main_room_width, 0, 0]) {
    StairWell(width=stairs_width, length=stairs_length, height=ceiling_height);
  }
}

module 2d() {
  Main(width=main_room_width, length=main_room_length);

  translate([5 * main_room_length, 0, 0])
    LargeRoom(width=large_room_width, length=large_room_length, height=ceiling_height);

  translate([0, -2*(doll_height+GAP_2D)-ceiling_height-2*GAP_2D, 0])
    SmallRoom(width=small_room_width, length=small_room_length, height=ceiling_height);

  translate([2 * main_room_length, -3*(doll_height+GAP_2D)-2*doll_height-3*GAP_2D, 0])
    StairWell(width=stairs_width, length=stairs_length, height=ceiling_height);
}

if (RENDER_3D == true) 3d();
else 2d();
