include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>
include <house.scad>;

// Main room
module Main(width, depth) {
  wall_left_height = H + 90 + material_thickness;
  wall_right_height = H + 60 + material_thickness;
  peak_height = (H * 1.95) + 90;

  module SecondFloor() {
    size = [width - 2 * material_thickness, depth - material_thickness, material_thickness];
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
    size = [D - 2 * material_thickness - 2 * eps, 3 * H, material_thickness];
    cube(size);

    if (SHOW_LABELS == true) {
      Label(size[0] + 80, size[1] - 80, material_thickness);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, -DIMENSION_GAP, 0])
        Dimension(round(size[0]));
    }
  }

  module WallFront() {
    size = [1.3 * d - 2 * eps, 1.5 * H, material_thickness];
    cube(size);

    if (SHOW_LABELS == true) {
      Label(size[0], size[1] - 70, material_thickness, angle=90);
    }

    if (SHOW_DIMENSIONS == true) {
      translate([0, -5, 0])
        Dimension(round(size[0]));

      translate([-5, 0, 0])
        rotate([0, 0, 90])
          Dimension(H + 16); // We don't know the position of the clipping mask
    }
  }

  module Door() {
    size = [d, H + 2 * eps, material_thickness + 2 * eps];
    cube(size);

    if (SHOW_DIMENSIONS == true) {
      translate([0, H-5, 0])
        %Dimension(round(size[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          %Dimension(round(size[1]));
    }
  }

  module SquareWindow() {
    size = [d, d, material_thickness + 2 * eps];
    cube(size);

    if (SHOW_DIMENSIONS == true) {
      translate([0, size[1]-5, 0])
        %Dimension(round(size[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          %Dimension(round(size[1]));
    }
  }

  module RectangularWindow() {
    size = [1.5 * d, d/2, material_thickness + 2 * eps];
    cube(size);

    if (SHOW_DIMENSIONS == true) {
      translate([0, size[1]-5, 0])
        %Dimension(round(size[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          %Dimension(round(size[1]));
    }
  }

  module 3d() {
    translate([0, 0, H + material_thickness]) {
      SecondFloor();
    }
    
    difference() {
      House(
        wall_left_height=H + 90 + material_thickness,
        wall_right_height=H + 60 + material_thickness,
        width=D,
        depth=2 * doll_height,
        peak_height=(H * 1.95) + 90
      ) {
        translate([eps, 2 * doll_height, material_thickness + eps])
          rotate([90, 0, 0])
            WallBack();

        translate([D / 2 + d + eps, material_thickness, H + 2 * material_thickness])
          rotate([90, 0, 0])
            WallFront();
      }

      // Door wall left
      translate([-material_thickness - eps, -eps, material_thickness - eps])
        rotate([90, 0, 90])
          Door();

      // Door wall right
      translate([width - 2 * material_thickness - eps, -eps, material_thickness - eps])
        rotate([90, 0, 90])
          Door();

      // Door floor 1
      translate([L - d/2, depth + eps, material_thickness - eps])
        rotate([90, 0, 0])
          Door();

      // Door floor 2
      translate([width / 2 - d - material_thickness, depth + eps, H + 2 * material_thickness - eps])
        rotate([90, 0, 0])
          Door();

      // Window floor 1
      position = 80;
      translate([H - position - d + 2 * material_thickness, depth + eps, position])
        rotate([90, 0, 0])
          SquareWindow();
          
      // Window floor 2
      translate([L - d, depth + eps, 240])
        rotate([90, 0, 0])
          RectangularWindow();
    }
  }

  module 2d() {
    column2 = 150 + GAP_2D + max([wall_left_height, wall_right_height]);
    wall_base_z_offset = material_thickness;

    translate([column2, GAP_2D + 2 * doll_height])
      SecondFloor();
    
    difference() {
      House(
        wall_left_height=wall_left_height,
        wall_right_height=wall_right_height,
        width=D,
        depth=2 * doll_height,
        peak_height=peak_height
      ) {
        translate([0, wall_base_z_offset])
          WallBack();
        translate([D / 2 + d + eps, H + wall_base_z_offset])
          WallFront();
      }

      // Door wall left
      translate([material_thickness - eps, 2 * depth + GAP_2D + eps, -eps])
        rotate([0, 0, -90])
          Door();

      // Door wall right
      translate([material_thickness - eps, 2 * (depth + GAP_2D) - eps, material_thickness + eps])
        rotate([0, 180, -90])
          Door();

      translate([column2, 2 * (depth + GAP_2D) + wall_base_z_offset, 0]) {
        // Door floor 1
        door_floor1_pos = [L - d, 0];
        translate([door_floor1_pos[0], door_floor1_pos[1] - eps, -eps]) {
          Door();
          if (SHOW_DIMENSIONS == true) {
            translate([-door_floor1_pos[0], -door_floor1_pos[1] + DIMENSION_GAP, material_thickness + eps])
              %Dimension(L - d);
          }
        }

        // Door floor 2
        door_floor2_pos = [width / 2 - d - material_thickness, H + material_thickness];
        translate([door_floor2_pos[0], door_floor2_pos[1], -eps]) {
          Door();

          if (SHOW_DIMENSIONS == true) {
            translate([-door_floor2_pos[0], 0, material_thickness + eps])
              %Dimension(door_floor2_pos[0]);
            translate([0, -door_floor2_pos[1], material_thickness + eps])
              rotate([0, 0, 90])
                %Dimension(door_floor2_pos[1]);
          }
        }

        // Window floor 1
        window_floor1_pos = [H - 80 - d + 2 * material_thickness, 80];
        translate([window_floor1_pos[0], window_floor1_pos[1], -eps]) {
          SquareWindow();

          if (SHOW_DIMENSIONS == true) {
            translate([-window_floor1_pos[0], 0, material_thickness + eps])
              %Dimension(window_floor1_pos[0]);
            translate([0, -window_floor1_pos[1], material_thickness + eps])
              rotate([0, 0, 90])
                %Dimension(window_floor1_pos[1]);
          }
        }
            
        // Window floor 2
        window_floor2_pos = [L - d, 240];
        translate([window_floor2_pos[0], window_floor2_pos[1], -eps]) {
          RectangularWindow();

          if (SHOW_DIMENSIONS == true) {
            translate([1.5 * d, -window_floor2_pos[1], material_thickness + eps])
              rotate([0, 0, 90])
                %Dimension(window_floor2_pos[1]);
          }
        }
      }
    }
  }

  if (RENDER_3D == true) 3d();
  else 2d();
}
