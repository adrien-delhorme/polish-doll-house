include <../parameters.scad>;
use <../library.scad>;
use <dimensional-drawings/dimlines.scad>;


module LargeRoom(width, depth, height, is_3d=true) {
  module Floor(with_labels=false) {
    cube([width, depth, wood_height]);

    if (with_labels == true) {
      Label(width, depth);
    }
  }

  module Ceil(with_labels=false) {
    Floor();

    if (with_labels == true) {
      Label(width, depth);
    }
  }

  module WallLeft(with_labels=false) {
    cube([x, height, wood_height]);

    if (with_labels == true) {
      Label(x, height);
    }
  }

  module WallBack(with_labels=false) {
    cube([2 * x, height, wood_height]);

    if (with_labels == true) {
      Label(2 * x, height);
    }
  }

  module WallRight(with_labels=false) {
    cube([depth, height, wood_height]);

    if (with_labels == true) {
      Label(depth, height);
    }
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
    padding = 10;

    Floor(with_labels=true);

    translate([0, depth + padding])
      Ceil(with_labels=true);

    translate([width + 2 * (x + padding), height + padding])
      WallLeft(with_labels=true);

    translate([width + padding, height + padding])
      WallBack(with_labels=true);

    translate([width + padding, 0])
      WallRight(with_labels=true);
  }

	if (is_3d==true) 3D();
	else Flat();
}

LargeRoom(width=D, depth=3 * x, height=H, is_3d=true);
