  module Door(width, height) {
    dimensions = [width, height + 2 * eps, material_thickness + 2 * eps];
    cube(dimensions);

    if (SHOW_DIMENSIONS == true) {
      translate([0, height - DIMENSION_GAP, 0])
        %Dimension(round(dimensions[0]));

      translate([DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          %Dimension(round(dimensions[1]));
    }
  }

  module Window(width, height) {
    dimensions = [width, height, material_thickness + 2 * eps];
    cube(dimensions);

    if (SHOW_DIMENSIONS == true) {
      translate([0, dimensions[1]-5, 0])
        %Dimension(round(dimensions[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          %Dimension(round(dimensions[1]));
    }
  }