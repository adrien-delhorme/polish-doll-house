include <../library.scad>;
include <../parameters.scad>;
include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>


module Floor(width, depth, with_labels=false, with_dimensions=false) {
  size = [width - 2 * wood_thickness, depth, wood_thickness];
  cube(size);

  if (with_labels == true) {
    Label(size[0], size[1]);
  }

  if (with_dimensions == true) {
    translate([0, -10, 0])
      Dimension(size[0]);

    translate([-10, 0, 0])
      rotate([0, 0, 90])
        Dimension(size[1]);
  }
}

module Wall(height, depth, junction_height, with_dimensions=false) {
  height1 = height + junction_height;
  height2 = height;

  prismoid(
    size1=[height1, depth],
    size2=[height2, depth],
    h=wood_thickness,
    shift=[abs(height1 - height2)/2 - junction_height, 0],
    orient=ORIENT_Z,
    align=V_UP+V_RIGHT+V_BACK
  );

  if (with_dimensions == true) {
    translate([0, -5, 0])
      Dimension(height);

    translate([-10, 0, 0])
      rotate([0, 0, 90])
        Dimension(depth);

    translate([height, -10, 0]) 
      rotate([0, 0, 90])
        Line(depth + 20);
  }
}

module Slope(length, depth, left_junction_height, right_junction_height, with_dimensions=false) {
  length1 = length;
  length2 = left_junction_height + length + right_junction_height;

  prismoid(
    size1=[length1, depth],
    size2=[length2, depth],
    h=wood_thickness,
    shift=[abs(length1 - length2)/2 - left_junction_height, 0],
    orient=ORIENT_Z,
    align=V_BACK+V_RIGHT+V_UP
  );

  if (with_dimensions == true) {
    translate([0, -5, 0])
      Dimension(round(length));

    translate([-left_junction_height, depth + 5, 0])
      Dimension(round(left_junction_height), loc=DIM_OUTSIDE);

    translate([0, -10, 0]) 
      rotate([0, 0, 90])
        Line(depth + 20);

    translate([length, -10, 0]) 
      rotate([0, 0, 90])
        Line(depth + 20);

    translate([length, depth + 5, 0])
      Dimension(round(right_junction_height), loc=DIM_OUTSIDE);
  }
}

module House(
  wall_left_height,
  wall_right_height,
  width,
  depth,
  peak_height,
  is_3d=true
) {
  roof_base_width = width - 2 * wood_thickness;

  roof_left_angle = atan(
    (peak_height - wall_left_height) / (roof_base_width / 2)
  );
  roof_right_angle = atan(
    ((peak_height - wall_right_height)) / (roof_base_width / 2)
  );

  roof_left_length = (roof_base_width / 2) / cos(roof_left_angle);
  roof_right_length = (roof_base_width / 2) / cos(roof_right_angle);

  roof_left_junction_left = wood_thickness * tan((90 - roof_left_angle) / 2);
  roof_left_junction_right = wood_thickness * tan(90 - (180 - roof_left_angle - roof_right_angle)/2);
  roof_right_junction_left = roof_left_junction_right;
  roof_right_junction_right = wood_thickness * tan((90 - roof_right_angle) / 2);

  module WallLeft(with_labels=false, with_dimensions=false) {
    Wall(wall_left_height, depth, roof_left_junction_left, with_dimensions);

    if (with_labels == true) {
      Label(wall_left_height, depth);
    }
  }

  module WallRight(with_labels=false, with_dimensions=false) {
    Wall(wall_right_height, depth, roof_right_junction_right, with_dimensions);

    if (with_labels == true) {
      Label(wall_right_height, depth);
    }
  }

  module SlopeLeft(with_labels=false, with_dimensions=false) {
    Slope(
      length=roof_left_length,
      depth=depth,
      left_junction_height=roof_left_junction_left,
      right_junction_height=roof_left_junction_right,
      with_dimensions=with_dimensions
    );

    if (with_labels == true) {
      Label(roof_left_length, depth);
    }

  }
  
  module SlopeRight(with_labels=false, with_dimensions=false) {
    Slope(
      length=roof_right_length,
      depth=depth,
      left_junction_height=roof_right_junction_left,
      right_junction_height=roof_right_junction_right,
      with_dimensions=with_dimensions
    );

    if (with_labels == true) {
      Label(roof_right_length, depth);
    }
  }

  module RoofClippingMask() {
    union() {
      offset = 300;
      translate([0, wall_left_height, -eps])  // Do not depend on wall_left_height
        rotate([0, 0, roof_left_angle])
          translate([-offset/2, 0, 0])
            cube([roof_left_length + offset, peak_height, depth + 2 * eps]);

      translate([roof_base_width / 2, peak_height, -eps])
        rotate([0, 0, -roof_right_angle])
          translate([-offset/2, 0, 0])
            cube([roof_right_length + offset, peak_height, depth + 2 * eps]);
    }
  }

  module 3D() {
    translate([wood_thickness, 0, 0])
      Floor(width, depth);

    // Wall left
    rotate([0, -90, 0])
      mirror([0, 0, 1])
        WallLeft();

    // Wall right
    translate([width, 0, 0])
      rotate([0, -90, 0])
        WallRight();

    // Roof slope left
    translate([wood_thickness, 0, wall_left_height])
      rotate([0, -roof_left_angle, 0])
        SlopeLeft();

    // Roof slope right
    translate([width / 2, 0, peak_height])
      rotate([0, roof_right_angle, 0])
        SlopeRight();

    // Clipping mask for children
    difference() {
      children();
      translate([0, 0, -eps]) // avoid fusion on render
        // TODO: replace with RoofClippingMask
        union() {
          offset = 300;
          translate([wood_thickness, -eps, wall_left_height])
            rotate([0, -roof_left_angle, 0])
              translate([-offset/2, 0, 0])
                cube([roof_left_length + offset, depth + 2 * eps, peak_height]);

          translate([width / 2, -eps, peak_height])
            rotate([0, roof_right_angle, 0])
              translate([-offset/2, 0, 0])
                cube([roof_right_length + offset, depth + 2 * eps, peak_height]);
        }
    }
  }

  module Flat() {
    padding = 30;

    Floor(width, depth, with_labels=true, with_dimensions=true);

    // Wall left
    translate([0, depth + padding, 0])
      WallLeft(with_labels=true, with_dimensions=true);

    // Wall right
    translate([0, 2 * (depth + padding), 0])
      WallRight(with_labels=true, with_dimensions=true);

    // Roof slope left
    translate([wall_left_height + roof_left_junction_left + padding, depth + padding, 0])
      SlopeLeft(with_labels=true, with_dimensions=true);

    // Roof slope right
    translate([wall_right_height + roof_right_junction_right + padding, 2 * (depth + padding), 0])
      SlopeRight(with_labels=true, with_dimensions=true);

    // Children
    translate([0, 3 * (depth + padding), 0]) {
      for (i=[0:1:$children-1]) {
        translate([i * 150, 0, 0])
          difference() {
            children(i);
            RoofClippingMask();
          }
      }

      // Dimensions
      peak_x_offset = roof_base_width / 2;
      wall_base_z_offset = wood_thickness;
      translate([peak_x_offset, wall_base_z_offset, 10])
        rotate([0, 0, 90])
          #Dimension(round(peak_height - wall_base_z_offset));

      translate([-10, wall_base_z_offset, 0])
        rotate([0, 0, 90])
          Dimension(wall_left_height - wall_base_z_offset);
      translate([width - 2 * wood_thickness + 10, wall_base_z_offset, 0])
        rotate([0, 0, 90])
          Dimension(wall_right_height - wall_base_z_offset);

      // Angles
      translate([0, wall_left_height, 10]) {
        Angle(roof_left_angle);
        Line(12);
      }
      translate([roof_base_width, wall_right_height, 10]) {
        rotate([0, 0, 180]) {
          rotate([0, 0, -roof_right_angle]) Angle(roof_right_angle, label_angle=-130);
          Line(12);
        }
      }
    }

    zoom = 2;
    // Cutting angle left
    translate([width + padding, depth / 2, 0]) {
      cutting_angle = 45 - roof_left_angle / 2;
      scale(zoom)
        intersection() {
          square([30, wood_thickness]);
          projection() {
            translate([roof_left_junction_left, wood_thickness, 0])
              rotate([90, 0, 0])
                SlopeLeft();
          }
        }
      translate([roof_left_junction_left * zoom, 0, 0])
        rotate([0, 0, 90])
          Line(50 + wood_thickness * zoom);
      rotate([0, 0, roof_left_angle + cutting_angle])
        Line(51 + wood_thickness * zoom);

      translate([roof_left_junction_left * zoom, wood_thickness * zoom])
        rotate([0, 0, roof_left_angle + cutting_angle])
          Angle(angle=cutting_angle, radius=45, label_angle=-roof_left_angle - cutting_angle);

      translate([10, 2, 10])
        scale(DIM_FONTSCALE) color(DIMENSION_COLOR) text("Left");
    }

    // Cutting angle top
    translate([width + 35 + 3 * padding, depth / 4, 0]) {
      cutting_angle = atan(roof_left_junction_right / wood_thickness);
      scale(zoom)
        intersection() {
          square([30, wood_thickness]);
          projection() {
            translate([20-roof_left_length, wood_thickness, 0])
              rotate([90, 0, 0])
                SlopeLeft();
          }
        }
      translate([20 * zoom, 0, 0])
        rotate([0, 0, 90])
          Line(50 + wood_thickness * zoom);
      translate([20 * zoom + roof_left_junction_right * zoom, 0, 0])
        rotate([0, 0, 90 + cutting_angle])
          Line(53 + wood_thickness * zoom);

      translate([20 * zoom, wood_thickness * zoom])
        rotate([0, 0, 90])
          Angle(angle=cutting_angle, radius=45, label_angle=-90);

      translate([2, 2, 10])
        scale(DIM_FONTSCALE) color(DIMENSION_COLOR) text("Peak");
    }

    // Cutting angle right
    translate([width + padding, 0, 0]) {
      cutting_angle = 45 - roof_right_angle / 2;
      scale(zoom)
        intersection() {
          square([30, wood_thickness]);
          projection() {
            translate([roof_right_length + roof_right_junction_right, wood_thickness, 0])
              rotate([90, 0, 0])
                mirror([1, 0, 0]) SlopeRight();
          }
        }
      translate([roof_right_junction_right * zoom, 0, 0])
        rotate([0, 0, 90])
          Line(50 + wood_thickness * zoom);
      rotate([0, 0, roof_right_angle + cutting_angle])
        Line(51 + wood_thickness * zoom);

      translate([roof_right_junction_right * zoom, wood_thickness * zoom])
        rotate([0, 0, roof_right_angle + cutting_angle])
          Angle(angle=cutting_angle, radius=45, label_angle=-roof_right_angle - cutting_angle);

      translate([10, 2, 10])
        scale(DIM_FONTSCALE) color(DIMENSION_COLOR) text("Right");
    }
  }

  if (is_3d == true) 3D() children();
  else Flat() {
    // Workaround until https://github.com/openscad/openscad/issues/350 is released
    children(0);
    children(1);
  }
}

House(
  wall_left_height=H + 90 + wood_thickness,
  wall_right_height=H + 60 + wood_thickness,
  width=D,
  depth=2 * x,
  peak_height=(H * 1.95) + 90,
  is_3d=false
);
