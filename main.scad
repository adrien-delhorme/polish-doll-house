include <library.scad>;
include <parameters.scad>;
include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

eps = 0.01;

// Main room
module Main(width, height) {
	// 1st floor
	translate([wood_height, 0, 0]) {
		cube(size=[width - 2 * wood_height, height, wood_height]);
	}

	// 2nd floor
	translate([wood_height, 0, H + wood_height]) {
		cube(size=[width - 2 * wood_height, height, wood_height]);
	}

	// roof variables
	second_floor_wall_1 = 100;
	second_floor_wall_2 = 80;

	roof_peak_height = H * 0.75;
	roof_base_width = width - 2 * wood_height;

	roof1_angle = atan(roof_peak_height / (roof_base_width / 2));
	roof1_length = (roof_base_width / 2) / cos(roof1_angle);
  roof2_angle = atan((roof_peak_height + abs(second_floor_wall_1 - second_floor_wall_2)) / (roof_base_width / 2));
	roof2_length = (roof_base_width / 2) / cos(roof2_angle);

	roof1_junction_left = wood_height * tan((90 - roof1_angle) / 2);
	roof1_junction_right = wood_height * tan(90 - (180 - roof1_angle - roof2_angle)/2);
	roof2_junction_left = wood_height * tan(90 - (180 - roof1_angle - roof2_angle)/2);
	roof2_junction_right = wood_height * tan((90 - roof2_angle) / 2);

	// wall 1
	difference() {
		xb = height;
		xt = height;
		yb = H + wood_height + second_floor_wall_1 + roof1_junction_left;
		yt = H + wood_height + second_floor_wall_1;
		prismoid(size1=[xb, yb], size2=[xt, yt], h=wood_height, shift=[0, abs(yb - yt)/2 - roof1_junction_left], orient=ORIENT_X, align=V_UP+V_RIGHT+V_BACK);
		// Door
		translate([wood_height + eps, -eps, wood_height]) {
			rotate([0, 0, 90]) {
				cube(size=[d + eps, wood_height + 2 * eps, H]);
			}
		}
	}

	// wall 2
	translate([width - wood_height, 0, 0]) {
		difference() {
			xb = height;
			xt = height;
			yt = H + wood_height + second_floor_wall_2 + roof2_junction_right;
			yb = H + wood_height + second_floor_wall_2;
			prismoid(size1=[xb, yb], size2=[xt, yt], h=wood_height, shift=[0, -abs(yb - yt)/2 + roof2_junction_right], orient=ORIENT_X, align=V_UP+V_RIGHT+V_BACK);
			// Door
			translate([wood_height + eps, -eps, wood_height]) {
				rotate([0, 0, 90]) {
					cube(size=[d + eps, wood_height + 2 * eps, H]);
				}
		  }
		}
	}

	// roof 1
	translate([wood_height, 0, wood_height + H + second_floor_wall_1]) {
		rotate([0, -roof1_angle, 0]) {
			xb = roof1_length;
			xt = roof1_junction_left + roof1_length + roof1_junction_right;
			yb = height;
			yt = height;
			prismoid(size1=[xb, yb], size2=[xt, yt], h=wood_height, shift=[abs(xb - xt)/2 - roof1_junction_left, 0], align=V_BACK+V_RIGHT+V_UP);	
		}
  }

	// roof 2
	translate([width - wood_height - roof2_junction_right, 0, H + second_floor_wall_2 + wood_height]) {
		rotate_origin([0, 180+roof2_angle, 0], [roof2_junction_right, 0, 0]) {
			xb = roof2_junction_left + roof2_length + roof2_junction_right;
			xt = roof2_length;
			yb = height;
			yt = height;
			prismoid(size1=[xb, yb], size2=[xt, yt], h=wood_height, shift=[-abs(xb - xt)/2 + roof2_junction_right, 0], align=V_BACK+V_RIGHT+V_DOWN);	
		}
  }

	// wall back
	translate([wood_height, height - wood_height, wood_height]) {
		difference() {
			cube(size=[width - 2 * wood_height, wood_height, 2.5 * H]);
			translate([0, -eps, H + second_floor_wall_1]) {
				rotate([0, -roof1_angle, 0]) {
				  cube([roof1_length + 50, wood_height + 2 * eps, H]);
				}
			}
			translate([width - 2 * wood_height, -eps, H + second_floor_wall_2]) {
				rotate([0, 180 + roof2_angle, 0]) {
				  zflip() cube([roof2_length + 50, wood_height + 2 * eps, H]);
				}
			}
			// Door floor 1
			translate([L - d, -eps, -eps]) {
				cube([d, wood_height + 2 * eps, H + eps]);
			}
			// Door floor 2
			translate([width / 2 - d, -eps, H + wood_height - eps]) {
				cube([d, wood_height + 2 * eps, H + eps]);
			}
		}
	}
}
