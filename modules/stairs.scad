use <../libs/dimensions/dimensions.scad>;

module Stairs(width, depth, height) {
  module WallLeft() {
    cube([x, height, wood_thickness]);

    if ($show_labels == true) {
      Label(x, height, wood_thickness, angle=90);
    }

    if ($show_dimensions == true) {
      translate([-$dimensions_gap, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module BottomFloor() {
    cube([width, depth, wood_thickness]);

    if ($show_labels == true) {
      Label(width, depth, wood_thickness);
    }

    if ($show_dimensions == true) {
      translate([0, -$dimensions_gap, 0])
        Dimension(width);

      translate([-$dimensions_gap, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);
    }
  }

  module TopFloor() {
		cube([top_floor_width, x, wood_thickness]);

    if ($show_labels == true) {
      Label(top_floor_width, x, wood_thickness);
    }

    if ($show_dimensions == true) {
      translate([-$dimensions_gap, 0, 0])
        rotate([0, 0, 90])
          Dimension(x);

      translate([0, x + $dimensions_gap, 0])
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

    translate([0, depth + $gap_2d, 0])
      TopFloor();

    first_step_x_translation = top_floor_width - wood_thickness;
    first_step_z_translation = H + wood_thickness - step_height;

    translate([0, depth + x + 2 * $gap_2d]) {
      for (i = [0 : steps_number - 1]) {
        translate([i * (step_width + $gap_2d), 0, 0]) {
          // is last step?
          if (i == steps_number - 1) {
            if (step_height - 2 * wood_thickness < wood_thickness) {
              cube([step_width + wood_thickness, x, step_height - 2 * wood_thickness]);
              if ($show_dimensions == true) {
                translate([0, x + $dimensions_gap, 0])
                  Dimension(round((step_width+wood_thickness)*10)/10, loc=DIM_OUTSIDE);
              }
            } else {
              cube([step_width + wood_thickness, x, step_height - 2 * wood_thickness]);
            }
          } else {
            cube([step_height, x, wood_thickness]);

            translate([0, x + $gap_2d, 0]) {
              cube([step_width, x, wood_thickness]);
            }
          }

        }
      }

      if ($show_dimensions == true) {
        translate([-$dimensions_gap, 0, 0])
          rotate([0, 0, 90])
            Dimension(x);

        translate([-$dimensions_gap, x + $gap_2d, 0])
          rotate([0, 0, 90])
            Dimension(x);

        translate([0, x + $dimensions_gap, 0])
          Dimension(round(step_height*10)/10, loc=DIM_OUTSIDE);

        translate([0, 2 * x + $gap_2d + $dimensions_gap, 0])
          Dimension(round(step_width*10)/10, loc=DIM_OUTSIDE);
      }
    }

    translate([x + $gap_2d, x + depth + $gap_2d, 0])
      rotate([0, 0, -90])
        WallLeft();
  }

  if ($render_3d == true) 3d();
  else 2d();
}
