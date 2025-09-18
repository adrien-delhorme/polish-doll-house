include <dimensions/dimensions.scad>


module Stairs(dimensions, stairs_count, stair_thickness) {
  horizontal_stair_dimensions = [
    dimensions.x,
    (dimensions.y - stair_thickness * (2 - stairs_count)) / (stairs_count - 1),
    stair_thickness
  ];

  vertical_stair_dimensions = [
    dimensions.x,
    stair_thickness,
    (dimensions.z - stair_thickness * (stairs_count + 1)) / stairs_count
  ];

  module 3d() {
    for (i = [0 : stairs_count - 1]) {
      translate([0, i * (horizontal_stair_dimensions.y - vertical_stair_dimensions.y), i * (vertical_stair_dimensions.z + horizontal_stair_dimensions.z)]) {
        cube(vertical_stair_dimensions);

        if (i != stairs_count - 1) {
          translate([0, 0, vertical_stair_dimensions.z]) {
            cube(horizontal_stair_dimensions);
          }
        }
      }
    }

    if (STAIRS_SHOW_DIMENSIONS == true) {
      // x dimension
      translate([0, -STAIRS_DIMENSION_GAP, 0])
        Dimension(vertical_stair_dimensions.x);

      // vertical stair z dimension
      translate([-STAIRS_DIMENSION_GAP, 0, vertical_stair_dimensions.z])
        rotate([90, 90, 0])
          Dimension(round(vertical_stair_dimensions.z));

      
      // horizontal stair y dimension
      translate([0, horizontal_stair_dimensions.y, vertical_stair_dimensions.z + horizontal_stair_dimensions.z])
        translate([-STAIRS_DIMENSION_GAP, 0, 0])
          rotate([0, 0, -90])
            Dimension(round(horizontal_stair_dimensions.y));
    }
	}

  module 2d() {
    for (i = [0 : stairs_count - 1]) {
      translate([i * (vertical_stair_dimensions.z + STAIRS_GAP_2D), 0, 0]) {
        cube([vertical_stair_dimensions.z, vertical_stair_dimensions.x, vertical_stair_dimensions.y]);
      }

      if (i != stairs_count - 1) {
        translate([i * (horizontal_stair_dimensions.y + STAIRS_GAP_2D), vertical_stair_dimensions.x + STAIRS_GAP_2D, 0]) {
          cube([horizontal_stair_dimensions.y, horizontal_stair_dimensions.x, horizontal_stair_dimensions.z]);
        }
      }
    }

    if (STAIRS_SHOW_DIMENSIONS == true) {
      // vertical stair x dimensions
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(vertical_stair_dimensions.x);

      // horizontal stair x dimensions
      translate([-DIMENSION_GAP, vertical_stair_dimensions.x + STAIRS_GAP_2D, 0])
        rotate([0, 0, 90])
          Dimension(horizontal_stair_dimensions.x);

      // vertical stair z dimension
      translate([0, -DIMENSION_GAP, 0])
        rotate([0, 0, 0])
          Dimension(round(vertical_stair_dimensions.z));

      
      // horizontal stair y dimension
      translate([0, vertical_stair_dimensions.x + STAIRS_GAP_2D, 0])
        translate([0, -DIMENSION_GAP, 0])
          Dimension(round(horizontal_stair_dimensions.y));
    }
  }

  if (STAIRS_RENDER_3D == true) 3d();
  else 2d();
}

// STAIRS_RENDER_3D = true;
// STAIRS_SHOW_DIMENSIONS = true;
// DIMENSION_GAP = 5;
// STAIRS_GAP_2D = 20;

// Stairs(
//   [200, 400, 100],
//   7,
//   5
// );