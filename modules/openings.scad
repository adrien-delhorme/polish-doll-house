  module Door(width, height) {
    size = [width, height + 2 * eps, material_thickness + 2 * eps];
    cube(size);

    if (SHOW_DIMENSIONS == true) {
      translate([0, height - DIMENSION_GAP, 0])
        %Dimension(round(size[0]));

      translate([DIMENSION_GAP, 0, 0])
        rotate([0, 0, 90])
          %Dimension(round(size[1]));
    }
  }

  module Window(width, height) {
    size = [width, height, material_thickness + 2 * eps];
    cube(size);

    if (SHOW_DIMENSIONS == true) {
      translate([0, size[1]-5, 0])
        %Dimension(round(size[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          %Dimension(round(size[1]));
    }
  }