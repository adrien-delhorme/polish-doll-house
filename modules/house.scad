include <../library.scad>;
include <../parameters.scad>;
include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>


module Floor(width, depth) {
  cube([width - 2 * wood_height, depth, wood_height]);
}

module Wall(height, depth, junction_height) {
  height1 = height + junction_height;
  height2 = height;

  prismoid(
    size1=[height1, depth],
    size2=[height2, depth],
    h=wood_height,
    shift=[abs(height1 - height2)/2 - junction_height, 0],
    orient=ORIENT_Z,
    align=V_UP+V_RIGHT+V_BACK
  );
}

module Slope(length, depth, left_junction_height, right_junction_height) {
  length1 = length;
  length2 = left_junction_height + length + right_junction_height;

  prismoid(
    size1=[length1, depth],
    size2=[length2, depth],
    h=wood_height,
    shift=[abs(length1 - length2)/2 - left_junction_height, 0],
    orient=ORIENT_Z,
    align=V_BACK+V_RIGHT+V_UP
  );
}

module House(
  wall_left_height,
  wall_right_height,
  width,
  depth,
  peak_height,
  is_3d=true
) {
  roof_base_width = width - 2 * wood_height;

  roof_left_angle = atan(
    (peak_height - wall_left_height) / (roof_base_width / 2)
  );
  roof_right_angle = atan(
    ((peak_height - wall_right_height)) / (roof_base_width / 2)
  );

  roof_left_length = (roof_base_width / 2) / cos(roof_left_angle);
  roof_right_length = (roof_base_width / 2) / cos(roof_right_angle);

  roof_left_junction_left = wood_height * tan((90 - roof_left_angle) / 2);
  roof_left_junction_right = wood_height * tan(90 - (180 - roof_left_angle - roof_right_angle)/2);
  roof_right_junction_left = wood_height * tan(90 - (180 - roof_left_angle - roof_right_angle)/2);
  roof_right_junction_right = wood_height * tan((90 - roof_right_angle) / 2);

  module WallLeft() {
    Wall(wall_left_height, depth, roof_left_junction_left);
  }

  module WallRight() {
    Wall(wall_right_height, depth, roof_right_junction_right);
  }

  module SlopeLeft() {
    Slope(
      length=roof_left_length,
      depth=depth,
      left_junction_height=roof_left_junction_left,
      right_junction_height=roof_left_junction_right
    );
  }
  
  module SlopeRight() {
    Slope(
      length=roof_right_length,
      depth=depth,
      left_junction_height=roof_right_junction_left,
      right_junction_height=roof_right_junction_right
    );
  }

  module RoofClippingMask() {
    union() {
      offset = 300;
      translate([0, wall_left_height, -eps])
        rotate([0, 0, roof_left_angle])
          translate([-offset/2, 0, 0])
            cube([roof_left_length + offset, peak_height, depth + 2 * eps]);

      translate([width / 2, wood_height + peak_height, -eps])
        rotate([0, 0, -roof_right_angle])
          translate([-offset/2, 0, 0])
            cube([roof_right_length + offset, peak_height, depth + 2 * eps]);
    }
  }

  module 3D() {
    translate([wood_height, 0, 0])
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
    translate([wood_height, 0, wall_left_height])
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
          translate([wood_height, -eps, wall_left_height])
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
    Floor(width, depth);

    // Wall left
    translate([0, depth, 0])
      WallLeft();

    // Wall right
    translate([0, 2 * depth, 0])
      WallRight();

    // Roof slope left
    translate([wall_left_height + roof_left_junction_left, depth, 0])
      SlopeLeft();

    // Roof slope right
    translate([wall_right_height + roof_right_junction_right, 2 * depth, 0])
      SlopeRight();

    // Children
    translate([0, 3 * depth, 0])
      for (i=[0:1:$children-1]) {
        translate([i * 150, 0, 0])
          difference() {
            children(i);
            RoofClippingMask();
          }
      }
  }

  if (is_3d == true) 3D() children();
  else Flat() {
    // Workaround until https://github.com/openscad/openscad/issues/350 is released:w
    children(0);
    children(1);
  }
}

House(
  wall_left_height=H + 80 + wood_height,
  wall_right_height=H + 50 + wood_height,
  width=D,
  depth=2 * x,
  peak_height=(H * 1.95) + 80,
  is_3d=true
);
