module SmallRoom(width, length, height) {
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
      translate([-DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          Dimension(length);

      translate([0, -DIMENSION_GAP, 0])
        Dimension(width);
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
      translate([0, height + DIMENSION_GAP, 0])
        Dimension(length);
    }
  }

  module WallBack() {
    dimensions = [openings_width, height, material_thickness];
    difference() {
      if (RENDER_MODE == "2D") {
        projection()
          cube(dimensions);
      } else {  
        cube(dimensions);
      }

      if (SHOW_LABELS == true) {
        Label(bbox=[openings_width, height], height=material_thickness, angle=90);
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

  module renderFlatOr2D() {
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
  else renderFlatOr2D();
}
