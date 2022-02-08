include <../parameters.scad>;
use <../library.scad>;

module Stairs(width, depth, height, is_3d=true) {
  module WallLeft(with_labels=false, with_dimensions=false) {
    cube([x, height, wood_height]);

    if (with_labels == true) {
      Label(x, height, angle=90);
    }

    if (with_dimensions == true) {
      translate([-5, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module BottomFloor(with_labels=false, with_dimensions=false) {
    cube([width, depth, wood_height]);

    if (with_labels == true) {
      Label(width, depth);
    }

    if (with_dimensions == true) {
      translate([0, -10, 0])
        Dimension(width);

      translate([-10, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);
    }
  }

  module TopFloor(with_labels=false, with_dimensions=false) {
		cube([top_floor_width, x, wood_height]);

    if (with_labels == true) {
      Label(top_floor_width, x);
    }

    if (with_dimensions == true) {
      translate([-10, 0, 0])
        rotate([0, 0, 90])
          Dimension(x);

      translate([0, top_floor_width + 5, 0])
        Dimension(top_floor_width);
    }
  }

	top_floor_width = width - H + wood_height;
	steps_number = 12;
	step_width = (width - top_floor_width) / (steps_number - 1);
	step_height = (H + 2 * wood_height) / steps_number;

  module 3D() {
    BottomFloor();

    translate([0, 0, H + wood_height])
      TopFloor();

    first_step_x_translation = top_floor_width - wood_height;
    first_step_z_translation = H + wood_height - step_height;

    for (i = [0 : steps_number - 1]) {
      translate([
        first_step_x_translation + i * step_width,
        0,
        first_step_z_translation - i * step_height
      ]) {

        // is last step?
        if (i == steps_number - 1) {
          translate([- step_width, 0, 2 * wood_height]) {
            cube([step_width + wood_height, x, step_height - 2 * wood_height]);
          }
        } else {
          cube([wood_height, x, step_height]);

          translate([wood_height, 0, 0]) {
            cube([step_width, x, wood_height]);
          }
        }
      }
    }

    translate([0, 0, wood_height])
      rotate([90, 0, 90])
        WallLeft();
	}

  module Flat() {
    padding = 10;

    BottomFloor(with_labels=true, with_dimensions=true);

    translate([0, depth + padding, 0])
      TopFloor(with_labels=true, with_dimensions=true);

    first_step_x_translation = top_floor_width - wood_height;
    first_step_z_translation = H + wood_height - step_height;

    translate([0, depth + x + 2 * padding]) {
      for (i = [0 : steps_number - 1]) {
        translate([i * (step_width + padding), 0, 0]) {
          // is last step?
          if (i == steps_number - 1) {
            echo(step_height - 2 * wood_height);
            if (step_height - 2 * wood_height < wood_height) {
              color("red") cube([step_width + wood_height, x, step_height - 2 * wood_height]);
              translate([0, x + 5, 0])
                Dimension(round((step_width+wood_height)*10)/10, loc=DIM_OUTSIDE);
            } else {
              cube([step_width + wood_height, x, step_height - 2 * wood_height]);
            }
          } else {
            cube([step_height, x, wood_height]);

            translate([0, x + padding, 0]) {
              cube([step_width, x, wood_height]);
            }
          }

        }
      }

      translate([-10, 0, 0])
        rotate([0, 0, 90])
          Dimension(x);

      translate([-10, x + padding, 0])
        rotate([0, 0, 90])
          Dimension(x);

      translate([0, x + 5, 0])
        Dimension(round(step_height*10)/10, loc=DIM_OUTSIDE);

      translate([0, 2 * x + padding + 5, 0])
        Dimension(round(step_width*10)/10, loc=DIM_OUTSIDE);
    }

    translate([x + padding, x + depth + padding, 0])
      rotate([0, 0, -90])
        WallLeft(with_labels=true, with_dimensions=true);
  }

  if (is_3d == true) 3D();
  else Flat();
}

Stairs(width=L, depth=2 * x, height=H, is_3d=false);
