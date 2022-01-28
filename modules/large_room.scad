include <../parameters.scad>;


module LargeRoom(width, depth, height, is_3d=true) {
  module Floor() {
    cube([width, depth, wood_height]);
  }

  module Ceil() {
    Floor();
  }

  module WallLeft() {
    cube([x, height, wood_height]);
  }

  module WallBack() {
    cube([2 * x, height, wood_height]);
  }

  module WallRight() {
    cube([depth, height, wood_height]);
  }

  module 3D()  {
    Floor();

    translate([0, 0, height + wood_height])
      Ceil();

    translate([0, 0, wood_height])
      rotate([90, 0, 90])
        WallLeft();

    translate([0, depth, wood_height])
      rotate([90, 0, 0])
        WallBack();

    translate([width - wood_height, 0, wood_height])
      rotate([90, 0, 90])
        WallRight();
  }

  module Flat() {
    Floor();

    translate([0, depth])
      Ceil();

    translate([width + 2 * x, height])
      WallLeft();

    translate([width, height])
      WallBack();

    translate([width, 0])
      WallRight();
  }

	if (is_3d==true) 3D();
	else Flat();
}

LargeRoom(width=D, depth=3 * x, height=H, is_3d=true);
