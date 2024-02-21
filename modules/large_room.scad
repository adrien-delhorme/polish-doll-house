module LargeRoom(width, depth, height) {
  module Floor() {
    cube([width, depth, wood_thickness]);

    if ($show_labels == true) {
      Label(width, depth, wood_thickness);
    }

    if ($show_dimensions == true) {
      translate([0, -$dimensions_gap, 0])
        Dimension(width);

      translate([-$dimensions_gap, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);
    }
  }

  module Ceil() {
    cube([width, depth, wood_thickness]);

    if ($show_labels == true) {
      Label(width, depth, wood_thickness);
    }

    if ($show_dimensions == true) {
      translate([-$dimensions_gap, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);
    }
  }

  module WallLeft() {
    cube([x, height, wood_thickness]);

    if ($show_labels == true) {
      Label(x, height, wood_thickness);
    }

    if ($show_dimensions == true) {
      translate([0, height + $dimensions_gap, 0])
        Dimension(x);

      translate([x + $dimensions_gap, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module WallBack() {
    cube([2 * x, height, wood_thickness]);

    if ($show_labels == true) {
      Label(2 * x, height, wood_thickness);
    }

    if ($show_dimensions == true) {
      translate([0, height + $dimensions_gap, 0])
        Dimension(2 * x);
    }
  }

  module WallRight() {
    cube([depth, height, wood_thickness]);

    if ($show_labels == true) {
      Label(depth, height, wood_thickness);
    }

    if ($show_dimensions == true) {
      translate([0, -$dimensions_gap, 0])
        Dimension(depth);

      translate([depth + $dimensions_gap, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module 3d()  {
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

  module 2d() {
    Floor();

    translate([0, depth + $gap_2d])
      Ceil();

    translate([width + 2 * (x + $gap_2d), height + $gap_2d])
      WallLeft();

    translate([width + $gap_2d, height + $gap_2d])
      WallBack();

    translate([width + $gap_2d, 0])
      WallRight();
  }

	if ($render_3d==true) 3d();
	else 2d();
}
