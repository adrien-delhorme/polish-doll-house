include <BOSL/constants.scad>;
use <BOSL/shapes.scad>;
use <BOSL/transforms.scad>;
include <../libs/roof.scad>;
include <openings.scad>;


module Floor(width, length) {
  size = [width - 2 * material_thickness, length, material_thickness];
  difference() {
    cube(size);

    if (SHOW_LABELS == true) {
      Label(size[0], size[1], material_thickness);
    }
  }

  if (SHOW_DIMENSIONS == true) {
    translate([0, -DIMENSION_GAP, 0])
      Dimension(size[0]);

    translate([-DIMENSION_GAP, 0, 0])
      rotate([0, 0, 90])
        Dimension(size[1]);
  }
}

module Wall(height, length, junction_height) {
  height1 = height + junction_height;
  height2 = height;

  prismoid(
    size1=[height1, length],
    size2=[height2, length],
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
        Dimension(length);

    translate([height, -10, 0]) 
      rotate([0, 0, 90])
        Line(length + 20);
  }
}

module Slope(length, length, left_junction_height, right_junction_height) {
  length1 = length;
  length2 = left_junction_height + length + right_junction_height;

  prismoid(
    size1=[length1, length],
    size2=[length2, length],
    h=material_thickness,
    shift=[abs(length1 - length2)/2 - left_junction_height, 0],
    orient=ORIENT_Z,
    align=V_BACK+V_RIGHT+V_UP
  );

  if (SHOW_DIMENSIONS == true) {
    translate([0, -DIMENSION_GAP, 0])
      Dimension(round(length));

    translate([-left_junction_height, length + DIMENSION_GAP, 0])
      Dimension(round(left_junction_height), loc=DIMENSION_OUTSIDE);

    translate([0, -10, 0]) 
      rotate([0, 0, 90])
        Line(length + 20);

    translate([length, -10, 0]) 
      rotate([0, 0, 90])
        Line(length + 20);

    translate([length, length + DIMENSION_GAP, 0])
      Dimension(round(right_junction_height), loc=DIMENSION_OUTSIDE);
  }
}

module House(
  wall_left_height,
  wall_right_height,
  width,
  length,
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

  wall_left_door_size = [openings_width, ceiling_height];
  wall_left_door_position = [0, 0]; // x, z
  wall_right_door_size = [openings_width, ceiling_height];
  wall_right_door_position = [0, 0];  // x, z
  

  module RoofClippingMask() {
    $ROOF_RENDER_3D = true; // the roof module must always be rendered in 3D in this case
    translate([0, -eps, 0])
      union() {
        offset = 3 * doll_height;
        Roof([
          [[wall_left_height, length + 2 * eps, offset], -90],
          [[roof_left_length, length + 2 * eps, offset], -roof_left_angle],
          [[roof_right_length, length + 2 * eps, offset], roof_right_angle],
          [[wall_right_height, length + 2 * eps, offset], 90]
        ]);
      }
  }

  module render3d() {
    Floor(width, length);

    difference() {
      Roof([
        [[wall_left_height, length, material_thickness], -90, "Wall left"],
        [[roof_left_length, length, material_thickness], -roof_left_angle, "Roof left"],
        [[roof_right_length, length, material_thickness], roof_right_angle, "Roof right"],
        [[wall_right_height, length, material_thickness], 90, "Wall right"]
      ]);

      // Define below all the walls openings
      // -----------------------------------
      
      // Door wall left
      translate([-material_thickness - eps, wall_left_door_position[0] - eps, wall_left_door_position[1] + material_thickness - eps])
        rotate([90, 0, 90])
          Door(wall_left_door_size[0], wall_left_door_size[1]);

      // Door wall right
      translate([width - 2 * material_thickness - eps, wall_right_door_position[0] - eps, wall_right_door_position[1] + material_thickness - eps])
        rotate([90, 0, 90])
          Door(wall_right_door_size[0], wall_right_door_size[1]);
    }
    
    // Clipping mask for children
    difference() {
      children();
      RoofClippingMask();
    }
  }

  module renderFlat() {
    difference() {
      Roof([
          [[wall_left_height, length, material_thickness], -90, "Wall left"],
          [[roof_left_length, length, material_thickness], -roof_left_angle, "Roof left"],
          [[roof_right_length, length, material_thickness], roof_right_angle, "Roof right"],
          [[wall_right_height, length, material_thickness], 90, "Wall  right"]
        ]
      );

      // Define below all the walls openings
      // -----------------------------------
      
      // Door wall right
      translate([
        wall_right_height + roof_right_junction_right - wall_right_door_size[1] - wall_right_door_position[1] - material_thickness - eps,
        3 * (length + GAP_2D) + wall_right_door_size[0] + wall_right_door_position[0] - eps,
        - eps
      ])
        rotate([0, 0, -90])
          Door(wall_right_door_size[0], wall_right_door_size[1]);

      // Door wall left
      translate([
        wall_left_door_position[1] + material_thickness - eps,
        wall_left_door_size[0] + wall_left_door_position[0] - eps,
        -eps
      ])
        rotate([0, 0, -90])
          Door(wall_left_door_size[0], wall_left_door_size[1]);
    }

    translate([150 + GAP_2D + max([wall_left_height, roof_left_length, roof_right_length, wall_right_height]), 0, 0]) {
      Floor(width, length);

      // Children
      translate([0, 2 * (length + GAP_2D), 0]) {
        for (i=[0:1:$children-1]) {
          translate([i * 250, i * -290, 0])
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

  if (RENDER_3D == true) render3d() children();
  else renderFlat() {
    // Workaround until https://github.com/openscad/openscad/issues/350 is released
    children(0);
    children(1);
  }
}
