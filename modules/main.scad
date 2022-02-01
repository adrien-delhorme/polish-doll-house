include <../library.scad>;
include <../parameters.scad>;
use <house.scad>;
include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>


// Main room
module Main(width, depth, is_3d=true) {
  module SecondFloor(with_labels=false) {
    size = [width - 2 * wood_height, depth - wood_height, wood_height];
    cube(size);

    if (with_labels == true) {
      Label(size[0], size[1]);
    }
  }

  module WallBack(with_labels=false) {
    size = [D - 2 * wood_height - 2 * eps, 3 * H, wood_height];
    cube(size);

    if (with_labels == true) {
      Label(size[0] + 80, size[1] - 80);
    }
  }

  module WallFront(with_labels=false) {
    size = [1.3 * d - 2 * eps, 1.5 * H, wood_height];
    cube(size);

    if (with_labels == true) {
      Label(size[0], size[1] - 70, angle=90);
    }
  }

  module Door() {
    cube([d, H + 2 * eps, wood_height + 2 * eps]);
  }

  module SquareWindow() {
    cube([d, d, wood_height + 2 * eps]);
  }

  module RectangularWindow() {
    cube([1.5 * d, d/2, wood_height + 2 * eps]);
  }

  module 3D() {
    translate([wood_height, 0, H + wood_height]) {
      SecondFloor();
    }
    
    difference() {
      House(
        wall_left_height=H + 90 + wood_height,
        wall_right_height=H + 60 + wood_height,
        width=D,
        depth=2 * x,
        peak_height=(H * 1.95) + 90
      ) {
        translate([wood_height + eps, 2 * x, wood_height + eps])
          rotate([90, 0, 0])
            WallBack();

        translate([D / 2 + d + eps, wood_height, H + 2 * wood_height])
          rotate([90, 0, 0])
            WallFront();
      }

      // Door wall left
      translate([-eps, -eps, wood_height - eps])
        rotate([90, 0, 90])
          Door();

      // Door wall left
      translate([width - wood_height - eps, -eps, wood_height - eps])
        rotate([90, 0, 90])
          Door();

      // Door floor 1
      translate([L - d/2, depth + eps, wood_height - eps])
        rotate([90, 0, 0])
          Door();

      // Door floor 2
      translate([width / 2 - d - wood_height, depth + eps, H + 2 * wood_height - eps])
        rotate([90, 0, 0])
          Door();

      // Window floor 1
      position = 80;
      translate([H - position - d + 2 * wood_height, depth + eps, position])
        rotate([90, 0, 0])
          SquareWindow();
          
      // Window floor 2
      translate([L - d, depth + eps, 240])
        rotate([90, 0, 0])
          RectangularWindow();
    }
  }

  module Flat() {
    padding = 10;

    SecondFloor(with_labels=true);
    
    translate([0, depth - wood_height + padding, 0]) {
      difference() {
        House(
          wall_left_height=H + 90 + wood_height,
          wall_right_height=H + 60 + wood_height,
          width=D,
          depth=2 * x,
          peak_height=(H * 1.95) + 90,
          is_3d=is_3d
        ) {
          WallBack(with_labels=true);
          translate([D / 2 + d + eps, H + 2 * wood_height, 0])
            WallFront(with_labels=true);
        }

        // Door wall left
        translate([wood_height - eps, 2 * (depth + padding) + eps, -eps])
          rotate([0, 0, -90])
            Door();

        // Door wall right
        translate([wood_height - eps, 2 * (depth + padding) - eps, wood_height + eps])
          rotate([0, 180, -90])
            Door();

        // Door floor 1
        translate([L - d/1, 3 * (depth + padding) - eps, - eps])
          Door();

        // Door floor 2
        translate([width / 2 - d - wood_height, 3 * (depth + padding) + H + 2 * wood_height, -eps])
          Door();

        // Window floor 1
        position = 80;
        translate([H - position - d + 2 * wood_height, 3 * (depth + padding) + position, -eps])
          SquareWindow();
            
        // Window floor 2
        translate([L - d, 3 * (depth + padding) + 240, -eps])
          RectangularWindow();
      }
    }
  }

  if (is_3d == true) 3D();
  else Flat();
}

Main(width=D, depth=2 * x, is_3d=true);
