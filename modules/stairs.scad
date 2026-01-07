include <openscad-new-dimensions/dimensions.scad>;
include <openscad-fred-a-stair/stairs.scad>;

module StairWell(width, length, height) {
  module WallLeft() {
    dimensions = [doll_height, height, material_thickness];
    difference() {
      if (STAIRS_RENDER_MODE == "2D") {
        projection()
          cube(dimensions);
      } else {
        cube(dimensions);
      }

      if (STAIRS_SHOW_LABELS == true) {
        Label(bbox=[doll_height, height], height=material_thickness, angle=90);
      }
    }

    if (STAIRS_SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module BottomFloor() {
    dimensions = [width, length, material_thickness];
    difference() {
      if (STAIRS_RENDER_MODE == "2D") {
        projection()
          cube(dimensions);
      } else {
        cube(dimensions);
      }

      if (STAIRS_SHOW_LABELS == true) {
        Label(bbox=[width, length], height=material_thickness);
      }
    }

    if (STAIRS_SHOW_DIMENSIONS == true) {
      translate([0, -STAIRS_DIMENSION_GAP, 0])
        Dimension(width);

      translate([-STAIRS_DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(length);
    }
  }

  module TopFloor() {
    dimensions = [top_floor_width, doll_height, material_thickness];
    difference() {
      if (STAIRS_RENDER_MODE == "2D") {
        projection()
          cube(dimensions);
      } else {
        cube(dimensions);
      }

      if (STAIRS_SHOW_LABELS == true) {
        Label(bbox=[top_floor_width, doll_height], height=material_thickness);
      }
    }

    if (STAIRS_SHOW_DIMENSIONS == true) {
      translate([-STAIRS_DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(doll_height);

      translate([0, doll_height + STAIRS_DIMENSION_GAP, 0])
        Dimension(top_floor_width);
    }
  }

	top_floor_width = width - height + material_thickness;
	steps_number = 11;
  stairs_width = width - top_floor_width;
	step_width = (width - top_floor_width) / (steps_number - 1);
	step_height = (height + 2 * material_thickness) / steps_number;

  module render3d() {
    BottomFloor();

    translate([0, 0, height + material_thickness])
      TopFloor();

    first_step_x_translation = top_floor_width - material_thickness;
    first_step_z_translation = height + material_thickness - step_height;

    rotate([0, 0, 90])
      translate([0, -top_floor_width - length + material_thickness, material_thickness])
        Stairs([doll_height, stairs_width + material_thickness, height + 2 * material_thickness], steps_number, material_thickness);

    translate([0, 0, material_thickness])
      rotate([90, 0, 90])
        WallLeft();
	}


  module renderFlatOr2D() {
    BottomFloor();

    translate([0, length + STAIRS_GAP_2D, 0])
      TopFloor();

    first_step_x_translation = top_floor_width - material_thickness;
    first_step_z_translation = height + material_thickness - step_height;

    translate([0, doll_height + 3 * STAIRS_GAP_2D + length, 0])
      Stairs([doll_height, stairs_width + material_thickness, height + 2 * material_thickness], steps_number, material_thickness);

    translate([top_floor_width + STAIRS_GAP_2D, doll_height + length + STAIRS_GAP_2D, 0])
      rotate([0, 0, -90])
        WallLeft();
  }

  if (STAIRS_RENDER_MODE == "3D") render3d();
  else renderFlatOr2D();
}