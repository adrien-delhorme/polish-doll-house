module LargeRoom(width, depth, height) {
  module Floor() {
    cube([width, depth, material_thickness]);

    if (SHOW_LABELS == true) {
      Label(width, depth, material_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, -DIMENSION_GAP, 0])
        Dimension(width);

      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);
    }
  }

  module Ceil() {
    cube([width, depth, material_thickness]);

    if (SHOW_LABELS == true) {
      Label(width, depth, material_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);
    }
  }

  module WallLeft() {
    cube([doll_height, height, material_thickness]);

    if (SHOW_LABELS == true) {
      Label(doll_height, height, material_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, height + DIMENSION_GAP, 0])
        Dimension(doll_height);

      translate([doll_height + DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module WallBack() {
    cube([2 * doll_height, height, material_thickness]);

    if (SHOW_LABELS == true) {
      Label(2 * doll_height, height, material_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, height + DIMENSION_GAP, 0])
        Dimension(2 * doll_height);
    }
  }

  module WallRight() {
    cube([depth, height, material_thickness]);

    if (SHOW_LABELS == true) {
      Label(depth, height, material_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, -DIMENSION_GAP, 0])
        Dimension(depth);

      translate([depth + DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module 3d()  {
    Floor();

    translate([0, 0, height + material_thickness])
      Ceil();

    translate([0, 0, material_thickness])
      rotate([90, 0, 90])
        WallLeft();

    translate([0, depth, material_thickness])
      rotate([90, 0, 0])
        WallBack();

    translate([width - material_thickness, 0, material_thickness])
      rotate([90, 0, 90])
        WallRight();
  }

  module 2d() {
    Floor();

    translate([0, depth + GAP_2D])
      Ceil();

    translate([width + 2 * (doll_height + GAP_2D), height + GAP_2D])
      WallLeft();

    translate([width + GAP_2D, height + GAP_2D])
      WallBack();

    translate([width + GAP_2D, 0])
      WallRight();
  }

	if (RENDER_3D==true) 3d();
	else 2d();
}
