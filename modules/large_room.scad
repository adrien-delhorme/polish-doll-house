use <../library.scad>;
include <../parameters.scad>;


module LargeRoom(width, depth, height, is_3d=true) {
  module Floor(with_labels=false, with_dimensions=false) {
    cube([width, depth, wood_thickness]);

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

  module Ceil(with_labels=false, with_dimensions=false) {
    Floor();

    if (with_labels == true) {
      Label(width, depth);
    }

    if (with_dimensions == true) {
      translate([-10, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);
    }
  }

  module WallLeft(with_labels=false, with_dimensions=false) {
    cube([x, height, wood_thickness]);

    if (with_labels == true) {
      Label(x, height);
    }

    if (with_dimensions == true) {
      translate([0, height + 10, 0])
        Dimension(x);

      translate([x + 10, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module WallBack(with_labels=false, with_dimensions=false) {
    cube([2 * x, height, wood_thickness]);

    if (with_labels == true) {
      Label(2 * x, height);
    }

    if (with_dimensions == true) {
      translate([0, height + 10, 0])
        Dimension(2 * x);
    }
  }

  module WallRight(with_labels=false, with_dimensions=false) {
    cube([depth, height, wood_thickness]);

    if (with_labels == true) {
      Label(depth, height);
    }

    if (with_dimensions == true) {
      translate([0, -10, 0])
        Dimension(depth);

      translate([depth + 10, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module 3D()  {
    Floor();

    translate([0, 0, height + wood_thickness])
      Ceil();

    translate([0, 0, wood_thickness])
      rotate([90, 0, 90])
        WallLeft();

    translate([0, depth, wood_thickness])
      rotate([90, 0, 0])
        WallBack();

    translate([width - wood_thickness, 0, wood_thickness])
      rotate([90, 0, 90])
        WallRight();
  }

  module Flat() {
    padding = 10;

    Floor(with_labels=true, with_dimensions=true);

    translate([0, depth + padding])
      Ceil(with_labels=true, with_dimensions=true);

    translate([width + 2 * (x + padding), height + padding])
      WallLeft(with_labels=true, with_dimensions=true);

    translate([width + padding, height + padding])
      WallBack(with_labels=true, with_dimensions=true);

    translate([width + padding, 0])
      WallRight(with_labels=true, with_dimensions=true);
  }

	if (is_3d==true) 3D();
	else Flat();
}

LargeRoom(width=D, depth=3 * x, height=H, is_3d=false);
