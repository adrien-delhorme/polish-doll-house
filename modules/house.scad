include <BOSL/constants.scad>;
use <BOSL/shapes.scad>;
use <BOSL/transforms.scad>;
include <openings.scad>;
include <openscad-roof-on-fire/roof.scad>;


module Floor(width, length) {
  dimensions = [width - 2 * material_thickness, length, material_thickness];
  difference() {
    if (RENDER_MODE == "2D") {
      projection()
        cube(dimensions);
    } else {
      cube(dimensions);
    }

    if (SHOW_LABELS == true) {
      % Label(bbox=[dimensions[0], dimensions[1]], height=material_thickness);
    }
  }

  if (SHOW_DIMENSIONS == true) {
    translate([0, -DIMENSION_GAP, 0])
      Dimension(dimensions[0]);

    translate([-DIMENSION_GAP, 0, 0])
      rotate([0, 0, 90])
        Dimension(dimensions[1]);
  }
}

module House(
  wall_left_height,
  wall_right_height,
  width,
  length,
  peak_height
) {
  roof_base_width = width;

  roof_left_angle = atan(
    (peak_height - wall_left_height) / (roof_base_width / 2)
  );
  roof_right_angle = atan(
    ((peak_height - wall_right_height)) / (roof_base_width / 2)
  );

  roof_left_length = (roof_base_width / 2) / cos(roof_left_angle);
  roof_right_length = (roof_base_width / 2) / cos(roof_right_angle);

  wall_left_door_size = [openings_width, ceiling_height];
  wall_left_door_position = [0, 0]; // x, z
  wall_right_door_size = [openings_width, ceiling_height];
  wall_right_door_position = [0, 0];  // x, z
  

  module RoofClippingMask() {
    translate([0, -eps, 0]) {
      Roof([
        [[wall_left_height, length + 2 * eps, material_thickness], -90],
        [[roof_left_length, length + 2 * eps, material_thickness], -roof_left_angle],
        [[roof_right_length, length + 2 * eps, material_thickness], roof_right_angle],
        [[wall_right_height, length + 2 * eps, material_thickness], 90]
      ], render_mode=ROOF_RENDER_MODE_MASK, mask_offset=3); // the roof module must always be rendered in 3D in this case
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

  module renderFlatOr2D() {
    module renderOpeningsFlat() {
      // Door wall right
      translate([
        wall_left_height
        + roof_left_length
        + roof_right_length
        + wall_right_height
        - wall_right_door_size[1]
        + 3 * GAP_2D
        - material_thickness,
        wall_right_door_size[0] -eps,
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

    rotate([0, 0, 90])
      translate([0, -length, 0]) {
        difference() {
          Roof([
              [[wall_left_height, length, material_thickness], -90, "Wall left"],
              [[roof_left_length, length, material_thickness], -roof_left_angle, "Roof left"],
              [[roof_right_length, length, material_thickness], roof_right_angle, "Roof right"],
              [[wall_right_height, length, material_thickness], 90, "Wall  right"]
            ],
          );

          if (RENDER_MODE == "2D") {
            projection() renderOpeningsFlat();
          } else {
            renderOpeningsFlat();
          }
        }
      }


    module renderChildrenFlat() {
      difference() {
        children();
        rotate([-90, 0, 0])
          translate([0, -material_thickness, 0])
            RoofClippingMask();
      }
    }

    translate([150 + GAP_2D + max([wall_left_height, roof_left_length, roof_right_length, wall_right_height]), 0, 0]) {
      Floor(width, length);

      // Children
      translate([0, 2 * (length + GAP_2D), 0]) {
        for (i=[0:1:$children-1]) {
          translate([i * 250, i * -290, 0])
            if (RENDER_MODE == "2D") {
              projection() renderChildrenFlat() children(i);
            } else {
              renderChildrenFlat() children(i);
            }
        }
      }
    }
  }

  module renderFlat() {
    rotate([0, 0, 90])
      translate([0, -length, 0]) {
        difference() {
          Roof([
              [[wall_left_height, length, material_thickness], -90, "Wall left"],
              [[roof_left_length, length, material_thickness], -roof_left_angle, "Roof left"],
              [[roof_right_length, length, material_thickness], roof_right_angle, "Roof right"],
              [[wall_right_height, length, material_thickness], 90, "Wall  right"]
            ],
          );

          // Define below all the walls openings
          // -----------------------------------
          
          // Door wall right
          translate([
            wall_left_height
            + roof_left_length
            + roof_right_length
            + wall_right_height
            - wall_right_door_size[1]
            + 3 * GAP_2D
            - material_thickness,
            wall_right_door_size[0] -eps,
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

  if (RENDER_MODE == "3D") {
    render3d() children();
  } else {
    renderFlatOr2D() {
      // Workaround until https://github.com/openscad/openscad/issues/350 is released
      children(0);
      children(1);
    }
  }
}
