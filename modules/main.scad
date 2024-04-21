include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>
include <house.scad>;
include <openings.scad>;

// Main room
module Main(width, length) {
  wall_left_height = ceiling_height + 90 + material_thickness;
  wall_right_height = ceiling_height + 60 + material_thickness;
  peak_height = (ceiling_height * 1.95) + 90;
  wall_front_width = 1.3 * d;

  first_floor_door_size = [d, ceiling_height];  // width, height
  first_floor_door_position = [5 / 8 * width, 0];  // x, z
  second_floor_door_size = [d, 85 / 100 * ceiling_height];  // width, height
  second_floor_door_position = [width / 2 - d - material_thickness, ceiling_height + material_thickness - eps];  // x, z

  first_floor_window_size = 1.25 * [d, d];  // width, height
  first_floor_window_position = [1 / 4 * width - first_floor_window_size[0] / 2, doll_height - first_floor_window_size[1] / 2]; // x, z
  second_floor_window_size = [1.5 * d, d / 2];  // width, height
  second_floor_window_position = [5/8 * width, ceiling_height + doll_height / 3];  // x, z

  module SecondFloor() {
    size = [width - 2 * material_thickness, length - material_thickness, material_thickness];
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

  module WallBack() {
    size = [width - 2 * material_thickness - 2 * eps, peak_height, material_thickness];

    difference() {
      cube(size);

      // Door first floor
      translate([first_floor_door_position[0], first_floor_door_position[1] - eps, -eps])
        Door(first_floor_door_size[0], first_floor_door_size[1]);

      // Door second floor
      translate([second_floor_door_position[0], second_floor_door_position[1], -eps])
        Door(second_floor_door_size[0],  second_floor_door_size[1]);

      // Window first floor
      translate([first_floor_window_position[0], first_floor_window_position[1], -eps])
        Window(first_floor_window_size[0], first_floor_window_size[1]);
          
      // Window second floor
      translate([second_floor_window_position[0], second_floor_window_position[1], -eps])
        Window(second_floor_window_size[0], second_floor_window_size[1]);
    }

    if (SHOW_LABELS == true) {
      Label(size[0] + 80, size[1] - 80, material_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, -DIMENSION_GAP, 0])
        Dimension(round(size[0]));
    }
  }

  module WallFront() {
    size = [wall_front_width - 2 * eps, 1.5 * ceiling_height, material_thickness];
    cube(size);

    if (SHOW_LABELS == true) {
      Label(size[0], size[1] / 2, material_thickness, angle=90);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, -5, 0])
        Dimension(round(size[0]));

      // We don't know the position of the clipping mask, so we cannot process the dimension
      // translate([-5, 0, 0])
      //   rotate([0, 0, 90])
      //     Dimension(ceiling_height + 16);
    }
  }

  module 3d() {
    translate([0, 0, ceiling_height + material_thickness]) {
      SecondFloor();
    }
    
    difference() {
      House(
        wall_left_height=wall_left_height,
        wall_right_height=wall_right_height,
        width=width,
        length=length,
        peak_height=peak_height
      ) {
        translate([eps, length, material_thickness + eps])
          rotate([90, 0, 0])
            WallBack();

        translate([width / 2 + d + eps, material_thickness, ceiling_height + 2 * material_thickness])
          rotate([90, 0, 0])
            WallFront();
      }
    }
  }

  module 2d() {
    column2 = 150 + GAP_2D + max([wall_left_height, wall_right_height]);
    wall_base_z_offset = material_thickness;

    translate([column2, GAP_2D + main_room_length])
      SecondFloor();
    
    difference() {
      House(
        wall_left_height=wall_left_height,
        wall_right_height=wall_right_height,
        width=width,
        length=main_room_length,
        peak_height=peak_height
      ) {
        translate([0, wall_base_z_offset])
          WallBack();
        translate([main_room_width / 2 + d + eps, ceiling_height + wall_base_z_offset])
          WallFront();
      }
    }
  }

  if (RENDER_3D == true) 3d();
  else 2d();
}
