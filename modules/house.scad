include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>
include <../libs/roof.scad>;


module Floor(width, depth) {
  size = [width - 2 * material_thickness, depth, material_thickness];
  cube(size);

  if (SHOW_LABELS == true) {
    Label(size[0], size[1], material_thickness);
  }

  if (SHOW_DIMENSIONS == true) {
    translate([0, -DIMENSION_GAP, 0])
      Dimension(size[0]);

    translate([-DIMENSION_GAP, 0, 0])
      rotate([0, 0, 90])
        Dimension(size[1]);
  }
}

module Wall(height, depth, junction_height) {
  height1 = height + junction_height;
  height2 = height;

  prismoid(
    size1=[height1, depth],
    size2=[height2, depth],
    h=material_thickness,
    shift=[abs(height1 - height2)/2 - junction_height, 0],
    orient=ORIENT_Z,
    align=V_UP+V_RIGHT+V_BACK
  );

  if (SHOW_DIMENSIONS == true) {
    translate([0, -DIMENSION_GAP, 0])
      Dimension(height);

    translate([-DIMENSION_GAP, 0, 0])
      rotate([0, 0, 90])
        Dimension(depth);

    translate([height, -10, 0]) 
      rotate([0, 0, 90])
        Line(depth + 20);
  }
}

module Slope(length, depth, left_junction_height, right_junction_height) {
  length1 = length;
  length2 = left_junction_height + length + right_junction_height;

  prismoid(
    size1=[length1, depth],
    size2=[length2, depth],
    h=material_thickness,
    shift=[abs(length1 - length2)/2 - left_junction_height, 0],
    orient=ORIENT_Z,
    align=V_BACK+V_RIGHT+V_UP
  );

  if (SHOW_DIMENSIONS == true) {
    translate([0, -DIMENSION_GAP, 0])
      Dimension(round(length));

    translate([-left_junction_height, depth + DIMENSION_GAP, 0])
      Dimension(round(left_junction_height), loc=DIMENSION_OUTSIDE);

    translate([0, -10, 0]) 
      rotate([0, 0, 90])
        Line(depth + 20);

    translate([length, -10, 0]) 
      rotate([0, 0, 90])
        Line(depth + 20);

    translate([length, depth + DIMENSION_GAP, 0])
      Dimension(round(right_junction_height), loc=DIMENSION_OUTSIDE);
  }
}

module House(
  wall_left_height,
  wall_right_height,
  width,
  depth,
  peak_height
) {
  roof_base_width = width - 2 * material_thickness;

  roof_left_angle = atan(
    (peak_height - wall_left_height) / (roof_base_width / 2)
  );
  roof_right_angle = atan(
    ((peak_height - wall_right_height)) / (roof_base_width / 2)
  );

  roof_left_length = (roof_base_width / 2) / cos(roof_left_angle);
  roof_right_length = (roof_base_width / 2) / cos(roof_right_angle);

  roof_left_junction_left = material_thickness * tan((90 - roof_left_angle) / 2);
  roof_left_junction_right = material_thickness * tan(90 - (180 - roof_left_angle - roof_right_angle)/2);
  roof_right_junction_left = roof_left_junction_right;
  roof_right_junction_right = material_thickness * tan((90 - roof_right_angle) / 2);

  module WallLeft() {
    Wall(wall_left_height, depth, roof_left_junction_left);

    if (SHOW_LABELS == true) {
      Label(wall_left_height, depth, material_thickness);
    }
  }

  module WallRight() {
    Wall(wall_right_height, depth, roof_right_junction_right);

    if (SHOW_LABELS == true) {
      Label(wall_right_height, depth, material_thickness);
    }
  }

  module SlopeLeft() {
    Slope(
      length=roof_left_length,
      depth=depth,
      left_junction_height=roof_left_junction_left,
      right_junction_height=roof_left_junction_right
    );

    if (SHOW_LABELS == true) {
      Label(roof_left_length, depth, material_thickness);
    }

  }
  
  module SlopeRight() {
    Slope(
      length=roof_right_length,
      depth=depth,
      left_junction_height=roof_right_junction_left,
      right_junction_height=roof_right_junction_right
    );

    if (SHOW_LABELS == true) {
      Label(roof_right_length, depth, material_thickness);
    }
  }

  module RoofClippingMask() {
    $ROOF_RENDER_3D = true; // the roof module must always be rendered in 3D in this case
    translate([0, -eps, 0])
      union() {
        offset = 300;
        Roof([
          [[wall_left_height, depth + 2 * eps, offset], -90],
          [[roof_left_length, depth + 2 * eps, offset], -roof_left_angle],
          [[roof_right_length, depth + 2 * eps, offset], roof_right_angle],
          [[wall_right_height, depth + 2 * eps, offset], 90]
        ]);
      }
  }

  module 3d() {
    Floor(width, depth);

    Roof([
      [[wall_left_height, depth, material_thickness], -90],
      [[roof_left_length, depth, material_thickness], -roof_left_angle],
      [[roof_right_length, depth, material_thickness], roof_right_angle],
      [[wall_right_height, depth, material_thickness], 90]
    ]);
    
    // Clipping mask for children
    difference() {
      children();
      RoofClippingMask();
    }
  }

  module 2d() {
    Roof([
        [[wall_left_height, depth, material_thickness], -90],
        [[roof_left_length, depth, material_thickness], -roof_left_angle],
        [[roof_right_length, depth, material_thickness], roof_right_angle],
        [[wall_right_height, depth, material_thickness], 90]
      ]
    );

    translate([150 + GAP_2D + max([wall_left_height, roof_left_length, roof_right_length, wall_right_height]), 0, 0]) {
      Floor(width, depth);

      // Children
      translate([0, 2 * (depth + GAP_2D), 0]) {
        for (i=[0:1:$children-1]) {
          translate([i * 150, 0, 0])
            difference() {
              children(i);
              rotate([-90, 0, 0])
                translate([0, -material_thickness, 0])
                  RoofClippingMask();
            }
        }

        // Dimensions
        if (SHOW_DIMENSIONS == true) {
          peak_x_offset = roof_base_width / 2;
          wall_base_z_offset = material_thickness;
          translate([peak_x_offset, wall_base_z_offset, material_thickness])
            rotate([0, 0, 90])
              Dimension(round(peak_height - wall_base_z_offset));

          translate([-DIMENSION_GAP, wall_base_z_offset, 0])
            rotate([0, 0, 90])
              Dimension(wall_left_height - wall_base_z_offset);
          translate([width - 2 * material_thickness + DIMENSION_GAP, wall_base_z_offset, 0])
            rotate([0, 0, 90])
              Dimension(wall_right_height - wall_base_z_offset);

          // Angles
          translate([0, wall_left_height, material_thickness])
            Angle(roof_left_angle);

          translate([roof_base_width, wall_right_height, material_thickness])
            rotate([0, 0, 180 - roof_right_angle])
              Angle(roof_right_angle, label_angle=-180);
        }
      }
    }
  }

  if (RENDER_3D == true) 3d() children();
  else 2d() {
    // Workaround until https://github.com/openscad/openscad/issues/350 is released
    children(0);
    children(1);
  }
}
