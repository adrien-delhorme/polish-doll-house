module SmallRoom(width, length, height) {
  module Floor() {
    difference() {
      cube([width, length, material_thickness]);

      if (SHOW_LABELS == true) {
        Label(width, length, material_thickness);
      }
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(length);

      translate([0, -DIMENSION_GAP, 0])
        Dimension(width);
    }
  }

  module Ceil() {
    difference() {
      cube([width, length, material_thickness]);

      if (SHOW_LABELS == true) {
        Label(width, length, material_thickness);
      }
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(length);
    }
  }

  module WallLeft() {
    difference() {
      cube([length, height, material_thickness]);

      if (SHOW_LABELS == true) {
        Label(length, height, material_thickness);
      }
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, height + DIMENSION_GAP, 0])
        Dimension(length);
    }
  }

  module WallBack() {
    difference() {
      cube([openings_width, height, material_thickness]);

      if (SHOW_LABELS == true) {
        Label(openings_width, height, material_thickness, angle=90);
      }
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);

      translate([0, height + DIMENSION_GAP, 0])
        Dimension(openings_width);
    }
  }

  module WallRight() {
    difference() {
      cube([length, height, material_thickness]);

      if (SHOW_LABELS == true) {
        Label(length, height, material_thickness);
      }
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, height + DIMENSION_GAP, 0])
        Dimension(length);
    }
  }

  module render3d() {
    Floor();

    translate([0, 0, height + material_thickness])
      Ceil();

    translate([0, 0, material_thickness])
      rotate([90, 0, 90])
        WallLeft();

    translate([material_thickness, length, material_thickness])
      rotate([90, 0, 0])
        WallBack();

    translate([width - material_thickness, 0, material_thickness])
      rotate([90, 0, 90])
        WallRight();
  }

  module renderFlat() {
    Floor();

    translate([0, length + GAP_2D, 0])
      Ceil();

    translate([0, 2 * (length + GAP_2D), 0])
      WallBack();

    translate([openings_width + GAP_2D, 2 * (length + GAP_2D), 0])
      WallLeft();

    translate([openings_width + length + 2 * GAP_2D, 2 * (length + GAP_2D), 0])
      WallRight();
  }

  if (RENDER_MODE == "3D") render3d();
  else renderFlat();
}
