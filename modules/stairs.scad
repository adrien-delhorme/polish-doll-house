use <../libs/dimensions/dimensions.scad>;

module Stairs(width, depth, height) {
  module WallLeft() {
    cube([doll_height, height, material_thickness]);

    if (SHOW_LABELS == true) {
      Label(doll_height, height, material_thickness, angle=90);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module BottomFloor() {
    cube([width, depth, material_thickness]);

    if (SHOW_LABELS == true) {
      Label(width, depth, material_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, -DIMENSION_GAP, 0])
        Dimension(width);

      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);
    }
  }

  module TopFloor() {
		cube([top_floor_width, doll_height, material_thickness]);

    if (SHOW_LABELS == true) {
      Label(top_floor_width, doll_height, material_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(doll_height);

      translate([0, doll_height + DIMENSION_GAP, 0])
        Dimension(top_floor_width);
    }
  }

	top_floor_width = width - ceiling_height + material_thickness;
	steps_number = 12;
	step_width = (width - top_floor_width) / (steps_number - 1);
	step_height = (ceiling_height + 2 * material_thickness) / steps_number;

  module 3d() {
    BottomFloor();

    translate([0, 0, ceiling_height + material_thickness])
      TopFloor();

    first_step_x_translation = top_floor_width - material_thickness;
    first_step_z_translation = ceiling_height + material_thickness - step_height;

    for (i = [0 : steps_number - 1]) {
      translate([
        first_step_x_translation + i * step_width,
        0,
        first_step_z_translation - i * step_height
      ]) {

        // is last step?
        if (i == steps_number - 1) {
          translate([- step_width, 0, 2 * material_thickness]) {
            cube([step_width + material_thickness, doll_height, step_height - 2 * material_thickness]);
          }
        } else {
          cube([material_thickness, doll_height, step_height]);

          translate([material_thickness, 0, 0]) {
            cube([step_width, doll_height, material_thickness]);
          }
        }
      }
    }

    translate([0, 0, material_thickness])
      rotate([90, 0, 90])
        WallLeft();
	}

  module 2d() {
    BottomFloor();

    translate([0, depth + GAP_2D, 0])
      TopFloor();

    first_step_x_translation = top_floor_width - material_thickness;
    first_step_z_translation = ceiling_height + material_thickness - step_height;

    translate([0, depth + doll_height + 2 * GAP_2D]) {
      for (i = [0 : steps_number - 1]) {
        translate([i * (step_width + GAP_2D), 0, 0]) {
          // is last step?
          if (i == steps_number - 1) {
            if (step_height - 2 * material_thickness < material_thickness) {
              cube([step_width + material_thickness, doll_height, step_height - 2 * material_thickness]);
              if (SHOW_DIMENSIONS == true) {
                translate([0, doll_height + DIMENSION_GAP, 0])
                  Dimension(round((step_width+material_thickness)*10)/10, loc=DIMENSION_OUTSIDE);
              }
            } else {
              cube([step_width + material_thickness, doll_height, step_height - 2 * material_thickness]);
            }
          } else {
            cube([step_height, doll_height, material_thickness]);

            translate([0, doll_height + GAP_2D, 0]) {
              cube([step_width, doll_height, material_thickness]);
            }
          }

        }
      }

      if (SHOW_DIMENSIONS == true) {
        translate([-DIMENSION_GAP, 0, 0])
          rotate([0, 0, 90])
            Dimension(doll_height);

        translate([-DIMENSION_GAP, doll_height + GAP_2D, 0])
          rotate([0, 0, 90])
            Dimension(doll_height);

        translate([0, doll_height + DIMENSION_GAP, 0])
          Dimension(round(step_height*10)/10, loc=DIMENSION_OUTSIDE);

        translate([0, 2 * doll_height + GAP_2D + DIMENSION_GAP, 0])
          Dimension(round(step_width*10)/10, loc=DIMENSION_OUTSIDE);
      }
    }

    translate([doll_height + GAP_2D, doll_height + depth + GAP_2D, 0])
      rotate([0, 0, -90])
        WallLeft();
  }

  if (RENDER_3D == true) 3d();
  else 2d();
}
