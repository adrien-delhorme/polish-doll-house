module SmallRoom(width, depth, height) {
  module Floor() {
    cube([width, depth, wood_thickness]);

    if (SHOW_LABELS == true) {
      Label(width, depth, wood_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);

      translate([0, -DIMENSION_GAP, 0])
        Dimension(width);
    }
  }

  module Ceil() {
    cube([width, depth, wood_thickness]);

    if (SHOW_LABELS == true) {
      Label(width, depth, wood_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(depth);
    }
  }

  module WallLeft() {
    cube([x, height, wood_thickness]);

    if (SHOW_LABELS == true) {
      Label(x, height, wood_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, height + DIMENSION_GAP, 0])
        Dimension(x);
    }
  }

  module WallBack() {
    cube([d, height, wood_thickness]);

    if (SHOW_LABELS == true) {
      Label(d, height, wood_thickness, angle=90);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);

      translate([0, height + DIMENSION_GAP, 0])
        Dimension(d);
    }
  }

  module WallRight() {
    cube([depth, height, wood_thickness]);

    if (SHOW_LABELS == true) {
      Label(depth, height, wood_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, height + DIMENSION_GAP, 0])
        Dimension(depth);
    }
  }

  module 3d() {
    Floor();

    translate([0, 0, height + wood_thickness])
      Ceil();

    translate([0, 0, wood_thickness])
      rotate([90, 0, 90])
        WallLeft();

    translate([wood_thickness, depth, wood_thickness])
      rotate([90, 0, 0])
        WallBack();

    translate([width - wood_thickness, 0, wood_thickness])
      rotate([90, 0, 90])
        WallRight();
  }

  module 2d() {
    Floor();

    translate([0, depth + GAP_2D, 0])
      Ceil();

    translate([0, 2 * (depth + GAP_2D), 0])
      WallBack();

    translate([d + GAP_2D, 2 * (depth + GAP_2D), 0])
      WallLeft();

    translate([d + x + 2 * GAP_2D, 2 * (depth + GAP_2D), 0])
      WallRight();
  }

  if (RENDER_3D == true) 3d();
  else 2d();
}
