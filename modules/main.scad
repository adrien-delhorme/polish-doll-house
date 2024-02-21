include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>
include <house.scad>;

// Main room
module Main(width, depth) {
  wall_left_height = H + 90 + wood_thickness;
  wall_right_height = H + 60 + wood_thickness;
  peak_height = (H * 1.95) + 90;

  module SecondFloor() {
    size = [width - 2 * wood_thickness, depth - wood_thickness, wood_thickness];
    cube(size);

    if ($show_labels == true) {
      Label(size[0], size[1], wood_thickness);
    }

    if ($show_dimensions == true) {
      translate([0, -$dimensions_gap, 0])
        Dimension(size[0]);

      translate([-$dimensions_gap, 0, 0])
        rotate([0, 0, 90])
          Dimension(size[1]);
    }
  }

  module WallBack() {
    size = [D - 2 * wood_thickness - 2 * eps, 3 * H, wood_thickness];
    cube(size);

    if ($show_labels == true) {
      Label(size[0] + 80, size[1] - 80, wood_thickness);
    }

    if ($show_dimensions == true) {
      translate([0, -$dimensions_gap, 0])
        Dimension(round(size[0]));
    }
  }

  module WallFront() {
    size = [1.3 * d - 2 * eps, 1.5 * H, wood_thickness];
    cube(size);

    if ($show_labels == true) {
      Label(size[0], size[1] - 70, wood_thickness, angle=90);
    }

    if ($show_dimensions == true) {
      translate([0, -5, 0])
        Dimension(round(size[0]));

      translate([-5, 0, 0])
        rotate([0, 0, 90])
          Dimension(H + 16); // We don't know the position of the clipping mask
    }
  }

  module Door() {
    size = [d, H + 2 * eps, wood_thickness + 2 * eps];
    cube(size);

    if ($show_dimensions == true) {
      translate([0, H-5, 0])
        %Dimension(round(size[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          %Dimension(round(size[1]));
    }
  }

  module SquareWindow() {
    size = [d, d, wood_thickness + 2 * eps];
    cube(size);

    if ($show_dimensions == true) {
      translate([0, size[1]-5, 0])
        %Dimension(round(size[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          %Dimension(round(size[1]));
    }
  }

  module RectangularWindow() {
    size = [1.5 * d, d/2, wood_thickness + 2 * eps];
    cube(size);

    if ($show_dimensions == true) {
      translate([0, size[1]-5, 0])
        %Dimension(round(size[0]));

      translate([5, 0, 0])
        rotate([0, 0, 90])
          %Dimension(round(size[1]));
    }
  }

  module 3d() {
    translate([0, 0, H + wood_thickness]) {
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
        translate([eps, 2 * x, wood_thickness + eps])
          rotate([90, 0, 0])
            WallBack();

        translate([D / 2 + d + eps, wood_thickness, H + 2 * wood_thickness])
          rotate([90, 0, 0])
            WallFront();
      }

      // Door wall left
      translate([-wood_thickness - eps, -eps, wood_thickness - eps])
        rotate([90, 0, 90])
          Door();

      // Door wall right
      translate([width - 2 * wood_thickness - eps, -eps, wood_thickness - eps])
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

  module 2d() {
    column2 = 150 + $gap_2d + max([wall_left_height, wall_right_height]);
    wall_base_z_offset = wood_thickness;

    translate([column2, $gap_2d + 2 * x])
      SecondFloor();
    
    difference() {
      House(
        wall_left_height=wall_left_height,
        wall_right_height=wall_right_height,
        width=D,
        depth=2 * x,
        peak_height=peak_height
      ) {
        translate([0, wall_base_z_offset])
          WallBack();
        translate([D / 2 + d + eps, H + wall_base_z_offset])
          WallFront();
      }

      // Door wall left
      translate([wood_thickness - eps, 2 * depth + $gap_2d + eps, -eps])
        rotate([0, 0, -90])
          Door();

      // Door wall right
      translate([wood_thickness - eps, 2 * (depth + $gap_2d) - eps, wood_thickness + eps])
        rotate([0, 180, -90])
          Door();

      translate([column2, 2 * (depth + $gap_2d) + wall_base_z_offset, 0]) {
        // Door floor 1
        door_floor1_pos = [L - d, 0];
        translate([door_floor1_pos[0], door_floor1_pos[1] - eps, -eps]) {
          Door();
          if ($show_dimensions == true) {
            translate([-door_floor1_pos[0], -door_floor1_pos[1] + $dimensions_gap, wood_thickness + eps])
              %Dimension(L - d);
          }
        }

        // Door floor 2
        door_floor2_pos = [width / 2 - d - wood_thickness, H + wood_thickness];
        translate([door_floor2_pos[0], door_floor2_pos[1], -eps]) {
          Door();

          if ($show_dimensions == true) {
            translate([-door_floor2_pos[0], 0, wood_thickness + eps])
              %Dimension(door_floor2_pos[0]);
            translate([0, -door_floor2_pos[1], wood_thickness + eps])
              rotate([0, 0, 90])
                %Dimension(door_floor2_pos[1]);
          }
        }

        // Window floor 1
        window_floor1_pos = [H - 80 - d + 2 * wood_thickness, 80];
        translate([window_floor1_pos[0], window_floor1_pos[1], -eps]) {
          SquareWindow();

          if ($show_dimensions == true) {
            translate([-window_floor1_pos[0], 0, wood_thickness + eps])
              %Dimension(window_floor1_pos[0]);
            translate([0, -window_floor1_pos[1], wood_thickness + eps])
              rotate([0, 0, 90])
                %Dimension(window_floor1_pos[1]);
          }
        }
            
        // Window floor 2
        window_floor2_pos = [L - d, 240];
        translate([window_floor2_pos[0], window_floor2_pos[1], -eps]) {
          RectangularWindow();

          if ($show_dimensions == true) {
            translate([1.5 * d, -window_floor2_pos[1], wood_thickness + eps])
              rotate([0, 0, 90])
                %Dimension(window_floor2_pos[1]);
          }
        }
      }
    }
  }

  if ($render_3d == true) 3d();
  else 2d();
}
