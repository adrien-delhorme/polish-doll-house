include <../parameters.scad>;
use <../library.scad>;


module SmallRoom(width, depth, height, is_3D=true) {
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
    cube([width, height, wood_height]);

    if (with_labels == true) {
      Label(width, height);
    }
  }

  module WallRight(with_labels=false) {
    cube([d, height, wood_height]);

    if (with_labels == true) {
      Label(d, height, angle=90);
    }
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

  module Flat() {
    padding = 10;

    Floor(with_labels=true);

    translate([0, depth + padding, 0])
      Ceil(with_labels=true);

    translate([0, 2 * (depth + padding), 0])
      WallLeft(with_labels=true);
      
    translate([x + d + 2 * padding, 2 * (depth + padding), 0])
      WallBack(with_labels=true);

    translate([x + padding, 2 * (depth + padding), 0])
      WallRight(with_labels=true);
  }

	if (is_3D == true) 3D();
	else Flat();
}

SmallRoom(width=L, depth=x, height=H, is_3D=false);
