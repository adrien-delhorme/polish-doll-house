include <../parameters.scad>;
use <../library.scad>;


module SmallRoom(width, depth, height, is_3D=true) {
  module Floor(with_labels=false, with_dimensions=false) {
    cube([width, depth, wood_height]);

    if (with_labels == true) {
      Label(width, depth);
    }

    if (with_dimensions == true) {
      translate([-10, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);

      translate([0, -10, 0])
        Dimension(width);
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
    cube([x, height, wood_height]);

    if (with_labels == true) {
      Label(x, height);
    }

    if (with_dimensions == true) {
      translate([0, height + 10, 0])
        Dimension(x);
    }
  }

  module WallBack(with_labels=false, with_dimensions=false) {
    cube([d, height, wood_height]);

    if (with_labels == true) {
      Label(d, height, angle=90);
    }

    if (with_dimensions == true) {
      translate([-10, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);

      translate([0, height + 10, 0])
        Dimension(d);
    }
  }

  module WallRight(with_labels=false, with_dimensions=false) {
    cube([depth, height, wood_height]);

    if (with_labels == true) {
      Label(depth, height);
    }

    if (with_dimensions == true) {
      translate([0, height + 10, 0])
        Dimension(depth);
    }
  }

  module 3D() {
    Floor();

    translate([0, 0, height + wood_height])
      Ceil();

    translate([0, 0, wood_height])
      rotate([90, 0, 90])
        WallLeft();

    translate([wood_height, depth, wood_height])
      rotate([90, 0, 0])
        WallBack();

    translate([width - wood_height, 0, wood_height])
      rotate([90, 0, 90])
        WallRight();
  }

  module Flat() {
    padding = 10;

    Floor(with_labels=true, with_dimensions=true);

    translate([0, depth + padding, 0])
      Ceil(with_labels=true, with_dimensions=true);

    translate([0, 2 * (depth + padding), 0])
      WallBack(with_labels=true, with_dimensions=true);

    translate([d + padding, 2 * (depth + padding), 0])
      WallLeft(with_labels=true, with_dimensions=true);

    translate([d + x + 2 * padding, 2 * (depth + padding), 0])
      WallRight(with_labels=true, with_dimensions=true);
  }

  if (is_3D == true) 3D();
  else Flat();
}

SmallRoom(width=L, depth=x, height=H, is_3D=false);
