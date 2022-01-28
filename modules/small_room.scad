include <../parameters.scad>;

module Floor(width, depth) {
	cube([width, depth, wood_height]);
}

module Ceil(width, depth) {
	Floor(width, depth);
}

module WallLeft(height) {
	cube([x, height, wood_height]);
}

module WallBack(height) {
	cube([d, height, wood_height]);
}

module WallRight(width, height) {
	cube([width, height, wood_height]);
}

module 3D(width, depth, height){
	Floor(width, depth);

	translate([0, 0, height + wood_height])
  	Ceil(width, depth);

	translate([0, 0, wood_height])
  	rotate([90, 0, 90])
  		WallLeft(height);

	translate([wood_height, depth, wood_height])
		rotate([90, 0, 0])
			WallBack(height);

	translate([width - wood_height, 0, wood_height])
		rotate([90, 0, 90])
			WallRight(depth, height);
}

module Flat(width, depth, height) {
	Floor(width, depth);

	translate([0, depth, 0])
		Ceil(width, depth);

	translate([0, 2 * depth, 0])
		WallLeft(height);
		
	translate([x, 2 * depth, 0])
		WallBack(height);

	translate([x + d, 2 * depth, 0])
		WallRight(depth, height);
}

module SmallRoom(width, depth, height, is3D=true) {
	if (is3D == true)
		3D(width, depth, height);
	else
		Flat(width, depth, height);
}

SmallRoom(L, x, H, is3D=true);
