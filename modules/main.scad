include <../library.scad>;
include <../parameters.scad>;
use <house.scad>;
include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

wall_left_height = H + 90 + wood_thickness;
wall_right_height = H + 60 + wood_thickness;
peak_height = (H * 1.95) + 90;

// Main room
module Main(width, depth, is_3d=true) {
  module SecondFloor(with_labels=false, with_dimensions=false) {
    size = [width - 2 * wood_thickness, depth - wood_thickness, wood_thickness];
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

  module WallBack(with_labels=false, with_dimensions=false) {
    size = [D - 2 * wood_thickness - 2 * eps, 3 * H, wood_thickness];
    cube(size);

    if (with_labels == true) {
      Label(size[0] + 80, size[1] - 80);
    }

    if (with_dimensions == true) {
      translate([0, -5, 0])
        Dimension(round(size[0]));
    }
  }

  module WallFront(with_labels=false, with_dimensions=false) {
    size = [1.3 * d - 2 * eps, 1.5 * H, wood_thickness];
    cube(size);

    if (with_labels == true) {
      Label(size[0], size[1] - 70, angle=90);
    }

    if (with_dimensions == true) {
      translate([0, -5, 0])
        Dimension(round(size[0]));

      translate([-5, 0, 0])
        rotate([0, 0, 90])
          Dimension(H + 16); // We don't know the position of the clipping mask
    }
  }

  module Door(with_dimensions=false) {
    size = [d, H + 2 * eps, wood_thickness + 2 * eps];
    cube(size);

    if (with_dimensions == true) {
      translate([0, H-5, 0])
        #Dimension(round(size[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          #Dimension(round(size[1]));
    }
  }

  module SquareWindow(with_dimensions=false) {
    size = [d, d, wood_thickness + 2 * eps];
    cube(size);

    if (with_dimensions == true) {
      translate([0, size[1]-5, 0])
        #Dimension(round(size[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          #Dimension(round(size[1]));
    }
  }

  module RectangularWindow(with_dimensions=false) {
    size = [1.5 * d, d/2, wood_thickness + 2 * eps];
    cube(size);

    if (with_dimensions == true) {
      translate([0, size[1]-5, 0])
        #Dimension(round(size[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          #Dimension(round(size[1]));
    }
  }

  module 3D() {
    translate([wood_thickness, 0, H + wood_thickness]) {
      SecondFloor();
    }
    
    difference() {
      House(
        wall_left_height=H + 90 + wood_thickness,
        wall_right_height=H + 60 + wood_thickness,
        width=D,
        depth=2 * x,
        peak_height=(H * 1.95) + 90
      ) {
        translate([wood_thickness + eps, 2 * x, wood_thickness + eps])
          rotate([90, 0, 0])
            WallBack();

        translate([D / 2 + d + eps, wood_thickness, H + 2 * wood_thickness])
          rotate([90, 0, 0])
            WallFront();
      }

      // Door wall left
      translate([-eps, -eps, wood_thickness - eps])
        rotate([90, 0, 90])
          Door();

      // Door wall left
      translate([width - wood_thickness - eps, -eps, wood_thickness - eps])
        rotate([90, 0, 90])
          Door();

      // Door floor 1
      translate([L - d/2, depth + eps, wood_thickness - eps])
        rotate([90, 0, 0])
          Door();

      // Door floor 2
      translate([width / 2 - d - wood_thickness, depth + eps, H + 2 * wood_thickness - eps])
        rotate([90, 0, 0])
          Door();

      // Window floor 1
      position = 80;
      translate([H - position - d + 2 * wood_thickness, depth + eps, position])
        rotate([90, 0, 0])
          SquareWindow();
          
      // Window floor 2
      translate([L - d, depth + eps, 240])
        rotate([90, 0, 0])
          RectangularWindow();
    }
  }

  module Flat() {
    padding = 30;
    wall_base_z_offset = wood_thickness;

    SecondFloor(with_labels=true, with_dimensions=true);
    
    translate([0, depth - wood_thickness + padding, 0]) {
      difference() {
        House(
          wall_left_height=wall_left_height,
          wall_right_height=wall_right_height,
          width=D,
          depth=2 * x,
          peak_height=peak_height,
          is_3d=is_3d
        ) {
          translate([0, wall_base_z_offset])
            WallBack(with_labels=true, with_dimensions=true);
          translate([D / 2 + d + eps, H + wall_base_z_offset, 0])
            WallFront(with_labels=true, with_dimensions=true);
        }

        // Door wall left
        translate([wood_thickness - eps, 2 * depth + padding + eps, -eps])
          rotate([0, 0, -90])
            Door(with_dimensions=true);

        // Door wall right
        translate([wood_thickness - eps, 2 * (depth + padding) - eps, wood_thickness + eps])
          rotate([0, 180, -90])
            Door();

        translate([0, 3 * (depth + padding) + wall_base_z_offset, 0]) {
          // Door floor 1
          door_floor1_pos = [L - d, 0];
          translate([door_floor1_pos[0], door_floor1_pos[1] - eps, -eps]) {
            Door(with_dimensions=true);
            translate([-door_floor1_pos[0], -door_floor1_pos[1] + 10, 10])
              #Dimension(L - d);
          }

          // Door floor 2
          door_floor2_pos = [width / 2 - d - wood_thickness, H + wood_thickness];
          translate([door_floor2_pos[0], door_floor2_pos[1], -eps]) {
            Door(with_dimensions=true);
            translate([-door_floor2_pos[0], 0, 10])
              #Dimension(door_floor2_pos[0]);
            translate([0, -door_floor2_pos[1], 10])
              rotate([0, 0, 90])
                #Dimension(door_floor2_pos[1]);
          }

          // Window floor 1
          window_floor1_pos = [H - 80 - d + 2 * wood_thickness, 80];
          translate([window_floor1_pos[0], window_floor1_pos[1], -eps]) {
            SquareWindow(with_dimensions=true);
            translate([-window_floor1_pos[0], 0, 10])
              #Dimension(window_floor1_pos[0]);
            translate([0, -window_floor1_pos[1], 10])
              rotate([0, 0, 90])
                #Dimension(window_floor1_pos[1]);
          }
              
          // Window floor 2
          window_floor2_pos = [L - d, 240];
          translate([window_floor2_pos[0], window_floor2_pos[1], -eps]) {
            RectangularWindow(with_dimensions=true);
            translate([1.5 * d, -window_floor2_pos[1], 10])
              rotate([0, 0, 90])
                #Dimension(window_floor2_pos[1]);
          }
        }
      }
    }
  }

  if (is_3d == true) 3D();
  else Flat();
}

Main(width=D, depth=2 * x, is_3d=false);
