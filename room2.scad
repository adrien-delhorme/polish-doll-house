include <parameters.scad>;

// Room 2
module Room2(width, height){
	// floor
	cube(size=[width, height, wood_height]);

	// ceil
	translate([0, 0, H + wood_height]) {
		cube(size=[width, height, wood_height]);
	}

	// wall 1
	translate([0, 0, wood_height]) {
		cube(size=[wood_height, x, H]);
	}

	// wall 2
	translate([0, height - wood_height, wood_height]) {
		cube(size=[d, wood_height, H]);
	}

	// wall 3
	translate([width - wood_height, 0, wood_height]) {
		cube(size=[wood_height, height, H]);
	}
}
