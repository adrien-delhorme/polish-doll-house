module LargeRoom(width, length, height) {
  module Floor() {
    dimensions = [width, length, material_thickness];
    difference() {
      if (RENDER_MODE == "2D") {
        projection()
          cube(dimensions);
      } else {
        cube(dimensions);
      }

      if (SHOW_LABELS == true) {
        Label(bbox=[width, length], height=material_thickness);
      }
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, -DIMENSION_GAP, 0])
        Dimension(width);

      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(length);
    }
  }

  module Ceil() {
    dimensions = [width, length, material_thickness];
    difference() {
      if (RENDER_MODE == "2D") {
        projection()
          cube(dimensions);
      } else {
        cube(dimensions);
      }

      if (SHOW_LABELS == true) {
        Label(bbox=[width, length], height=material_thickness);
      }
    }

    if (SHOW_DIMENSIONS == true) {
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(length);
    }
  }

  module WallLeft() {
    dimensions = [doll_height, height, material_thickness];
    difference() {
      if (RENDER_MODE == "2D") {
        projection()
          cube(dimensions);
      } else {
        cube(dimensions);
      }

      if (SHOW_LABELS == true) {
        Label(bbox=[doll_height, height], height=material_thickness);
      }
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
    dimensions = [5/8 * width + material_thickness, height, material_thickness];
    difference() {
      if (RENDER_MODE == "2D") {
        projection()
          cube(dimensions);
      } else {
        cube(dimensions);
      }

      if (SHOW_LABELS == true) {
        Label(bbox=[dimensions.x, dimensions.y], height=dimensions.z);
      }
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, dimensions.y + DIMENSION_GAP, 0])
        Dimension(dimensions.x);
    }
  }

  module WallRight() {
    dimensions = [length, height, material_thickness];
    difference() {
      if (RENDER_MODE == "2D") {
        projection()
          cube(dimensions);
      } else {
        cube(dimensions);
      }

      if (SHOW_LABELS == true) {
        Label(bbox=[length, height], height=material_thickness);
      }
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, -DIMENSION_GAP, 0])
        Dimension(length);

      translate([length + DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(height);
    }
  }

  module render3d()  {
    Floor();

    translate([0, 0, height + material_thickness])
      Ceil();

    translate([0, 0, material_thickness])
      rotate([90, 0, 90])
        WallLeft();

    translate([0, length, material_thickness])
      rotate([90, 0, 0])
        WallBack();

    translate([width - material_thickness, 0, material_thickness])
      rotate([90, 0, 90])
        WallRight();
  }

  module renderFlatOr2D() {
    Floor();

    translate([0, length + GAP_2D])
      Ceil();

    translate([width + 2 * doll_height + GAP_2D, height + GAP_2D])
      WallLeft();

    translate([width + GAP_2D, height + GAP_2D])
      WallBack();

    translate([width + GAP_2D, 0])
      WallRight();
  }

	if (RENDER_MODE == "3D") render3d();
	else renderFlatOr2D();
}
