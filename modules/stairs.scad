use <../libs/dimensions/dimensions.scad>;

module Stairs(width, depth, height) {
  module WallLeft() {
    cube([x, height, wood_thickness]);

    if (SHOW_LABELS == true) {
      Label(x, height, wood_thickness, angle=90);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module BottomFloor() {
    cube([width, depth, wood_thickness]);

    if (SHOW_LABELS == true) {
      Label(width, depth, wood_thickness);
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
		cube([top_floor_width, x, wood_thickness]);

    if (SHOW_LABELS == true) {
      Label(top_floor_width, x, wood_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(x);

      translate([0, x + DIMENSION_GAP, 0])
        Dimension(top_floor_width);
    }
  }

	top_floor_width = width - H + wood_thickness;
	steps_number = 12;
	step_width = (width - top_floor_width) / (steps_number - 1);
	step_height = (H + 2 * wood_thickness) / steps_number;

  module 3d() {
    BottomFloor();

    translate([0, 0, H + wood_thickness])
      TopFloor();

    first_step_x_translation = top_floor_width - wood_thickness;
    first_step_z_translation = H + wood_thickness - step_height;

    for (i = [0 : steps_number - 1]) {
      translate([
        first_step_x_translation + i * step_width,
        0,
        first_step_z_translation - i * step_height
      ]) {

        // is last step?
        if (i == steps_number - 1) {
          translate([- step_width, 0, 2 * wood_thickness]) {
            cube([step_width + wood_thickness, x, step_height - 2 * wood_thickness]);
          }
        } else {
          cube([wood_thickness, x, step_height]);

          translate([wood_thickness, 0, 0]) {
            cube([step_width, x, wood_thickness]);
          }
        }
      }
    }

    translate([0, 0, wood_thickness])
      rotate([90, 0, 90])
        WallLeft();
	}

  module 2d() {
    BottomFloor();

    translate([0, depth + GAP_2D, 0])
      TopFloor();

    first_step_x_translation = top_floor_width - wood_thickness;
    first_step_z_translation = H + wood_thickness - step_height;

    translate([0, depth + x + 2 * GAP_2D]) {
      for (i = [0 : steps_number - 1]) {
        translate([i * (step_width + GAP_2D), 0, 0]) {
          // is last step?
          if (i == steps_number - 1) {
            if (step_height - 2 * wood_thickness < wood_thickness) {
              cube([step_width + wood_thickness, x, step_height - 2 * wood_thickness]);
              if (SHOW_DIMENSIONS == true) {
                translate([0, x + DIMENSION_GAP, 0])
                  Dimension(round((step_width+wood_thickness)*10)/10, loc=DIMENSION_OUTSIDE);
              }
            } else {
              cube([step_width + wood_thickness, x, step_height - 2 * wood_thickness]);
            }
          } else {
            cube([step_height, x, wood_thickness]);

            translate([0, x + GAP_2D, 0]) {
              cube([step_width, x, wood_thickness]);
            }
          }

        }
      }

      if (SHOW_DIMENSIONS == true) {
        translate([-DIMENSION_GAP, 0, 0])
          rotate([0, 0, 90])
            Dimension(x);

        translate([-DIMENSION_GAP, x + GAP_2D, 0])
          rotate([0, 0, 90])
            Dimension(x);

        translate([0, x + DIMENSION_GAP, 0])
          Dimension(round(step_height*10)/10, loc=DIMENSION_OUTSIDE);

        translate([0, 2 * x + GAP_2D + DIMENSION_GAP, 0])
          Dimension(round(step_width*10)/10, loc=DIMENSION_OUTSIDE);
      }
    }

    translate([x + GAP_2D, x + depth + GAP_2D, 0])
      rotate([0, 0, -90])
        WallLeft();
  }

  if (RENDER_3D == true) 3d();
  else 2d();
}
