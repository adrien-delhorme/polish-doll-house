include <parameters.scad>;

module Stairs(width, height) {
	top_floor_width = width - H + wood_height;
	steps_number = 12;
	step_width = (width - top_floor_width) / (steps_number - 1);
	step_height = (H + 2 * wood_height) / steps_number;
	echo("height", step_height, "width", step_width)

	// bottom floor
	cube(size=[width, height, wood_height]);

	// top floor
	translate([0, 0, H + wood_height]) {
		cube(size=[top_floor_width, x, wood_height]);
	}

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
					cube(size=[step_width + wood_height, x, step_height - 2 * wood_height]);
				}
			} else {
				cube(size=[wood_height, x, step_height]);

				translate([wood_height, 0, 0]) {
					cube(size=[step_width, x, wood_height]);
				}
			}
		}
	}

	// wall 1
	translate([0, 0, wood_height]) {
		cube(size=[wood_height, x, H]);
	}
}
