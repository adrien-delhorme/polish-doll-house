include <constants.scad>;

DIMENSION_LINE_WIDTH = .5; // width of dimension lines
DIMENSION_HEIGHT = .1; // height of lines (Z axis)
DIMENSION_ARROW_WIDTH = .5; // width of arrows
DIMENSION_ARROW_LENGTH = 4; // length of arrows
DIMENSION_ARROW_HOLLOW = 1; // value between .1 and 1

DIMENSION_FONTSIZE = DIMENSION_LINE_WIDTH * 1;

DIMENSION_COLOR = "black";
LABEL_COLOR = "black";


module Arrow(arr_points, arr_length, height) {
    width = DIMENSION_ARROW_WIDTH;
    // arrow points to the left
    linear_extrude(height=height, convexity=2) {
      polygon(
          points = [[0, 0],
                  [arr_points, arr_points * width],
                  [arr_length, 0],
                  [arr_points, -arr_points * width]],
          paths = [[0, 1, 2, 3]], convexity=2);
    }
}

module Line(length, width=DIMENSION_LINE_WIDTH, height=DIMENSION_HEIGHT, left_arrow=false, right_arrow=false) {
    /* This module draws a line that can have an arrow on either end. Because
     * the intended use is to be viewed strictly from above, the height of the
     * line is set arbitrarily thin.
     *
     * You can control the shape of the arrow with DIMENSION_ARROW_WIDTH,
     * DIMENSION_ARROW_LENGTH and DIMENSION_ARROW_HOLLOW.
     */

    arr_points = width * DIMENSION_ARROW_LENGTH;
    arr_length = arr_points * DIMENSION_ARROW_HOLLOW;

    color(DIMENSION_COLOR) {
      union() {
          if (left_arrow && right_arrow) {
              translate([arr_length, -width / 2, 0])
                cube([length - arr_length * 2, width, height], center=false);
          } else {

              if (left_arrow) {
                  translate([arr_length, -width / 2, 0])
                    cube([length - arr_length, width, height], center=false);
              } else {
                  if (right_arrow) {
                      translate([0, -width / 2, 0])
                        cube([length - arr_length, width, height], center=false);
                  } else {
                      translate([0, -width / 2, 0])
                        cube([length, width, height], center=false);
                  }

              }
          }

          if (left_arrow) {
              Arrow(arr_points, arr_length, height);
          }

          if (right_arrow) {
              translate([length, 0, 0])
                rotate([0, 0, 180])
                  Arrow(arr_points, arr_length, height);
          }
      }
    }
}

module Dimension(length, line_width=DIMENSION_LINE_WIDTH, loc=DIMENSION_CENTER) {
    color(DIMENSION_COLOR) {
      text = str(length);
      space = len(text) * DIMENSION_FONTSIZE * 7;
      margin = 3;

      if (loc == DIMENSION_CENTER) {
        Line(
          length=length / 2 - space / 2 - margin,
          width=line_width,
          height=DIMENSION_HEIGHT,
          left_arrow=true,
          right_arrow=false
        );
        translate([length / 2 - space / 2, -DIMENSION_FONTSIZE * 4, 0])
          scale([DIMENSION_FONTSIZE, DIMENSION_FONTSIZE, DIMENSION_FONTSIZE])
            text(text);

        translate([length / 2 + space / 2 + margin, 0, 0])
          Line(
            length=length / 2 - space / 2 - margin,
            width=line_width,
            height=DIMENSION_HEIGHT,
            left_arrow=false,
            right_arrow=true
          );
      } else if (loc == DIMENSION_LEFT) {
        Line(
          length=length,
          width=line_width,
          height=DIMENSION_HEIGHT,
          left_arrow=true,
          right_arrow=true
        );

        translate([-space, -DIMENSION_FONTSIZE * 3, 0])
          scale([DIMENSION_FONTSIZE, DIMENSION_FONTSIZE, DIMENSION_FONTSIZE])
            text(text);
      } else if (loc == DIMENSION_RIGHT) {
        Line(
          length=length,
          width=line_width,
          height=DIMENSION_HEIGHT,
          left_arrow=true,
          right_arrow=true
        );

        translate([length + space, -DIMENSION_FONTSIZE * 3, 0])
          scale([DIMENSION_FONTSIZE, DIMENSION_FONTSIZE, DIMENSION_FONTSIZE])
            text(text);
      } else if (loc == DIMENSION_OUTSIDE) {
        rotate([0, 180, 0])
          Line(
            length=length / 2,
            width=line_width,
            height=DIMENSION_HEIGHT,
            left_arrow=true,
            right_arrow=false
          );

        translate([(length) / 2 - space / 2 * .9, -DIMENSION_FONTSIZE * 3, 0])
          scale([DIMENSION_FONTSIZE, DIMENSION_FONTSIZE, DIMENSION_FONTSIZE])
            text(text);

        translate([length, 0, 0])
          Line(
            length=length / 2,
            width=line_width,
            height=DIMENSION_HEIGHT,
            left_arrow=true,
            right_arrow=false
          );
      } else if (loc == DIMENSION_ABOVE) {
        Line(
          length=length,
          width=line_width,
          height=DIMENSION_HEIGHT,
          left_arrow=true,
          right_arrow=true
        );

        translate([length / 2 - space / 2, DIMENSION_FONTSIZE * 4, 0])
          scale([DIMENSION_FONTSIZE, DIMENSION_FONTSIZE, DIMENSION_FONTSIZE])
            text(text);
      } else if (loc == DIMENSION_UNDER) {
        Line(
          length=length,
          width=line_width,
          height=DIMENSION_HEIGHT,
          left_arrow=true,
          right_arrow=true
        );

        translate([length / 2 - space / 2, -DIMENSION_FONTSIZE * 15, 0])
          scale([DIMENSION_FONTSIZE, DIMENSION_FONTSIZE, DIMENSION_FONTSIZE])
            text(text);
      }
  }
}

module Arc(angle, radius) {
  color(DIMENSION_COLOR)
    intersection() {
      difference() { // the line
        circle(radius);
        offset(delta=-DIMENSION_LINE_WIDTH)
          circle(radius);
      }
      // the "mask" that removes all parts of the line outside of the angle
      scale(radius * 2) polygon([[0, 0], [1, 0], [cos(angle), sin(angle)]]);
    }
}

module Angle(angle, radius=10, label_angle=0, label_offset=10, show_spokes=false) {
  spoke_overflow = 2;
  Arc(angle, radius);

  // Spokes
  Line(radius + spoke_overflow);
  rotate([0, 0, angle])
    Line(radius + spoke_overflow);

  // Label
  rotate(angle/2)
    translate([radius + label_offset, 0, 0])
      scale(DIMENSION_FONTSIZE)
        rotate([0, 0, label_angle])
          color(DIMENSION_COLOR)
            text(str(round(angle), "°"), halign="center", valign="center");
}

module AngleOverview(angle, height, label="", zoom=2, max_width=20) {
  y = height / tan(angle);

  // Shape
  polygon([[0, 0], [max_width * zoom, 0], [max_width * zoom, height * zoom], [y * zoom, height * zoom]]);

  // Label
  translate([max_width * zoom + 10, 0, 0]) scale(DIMENSION_FONTSIZE) color(DIMENSION_COLOR) text(label);

  // Angle label
  rotate([0, 0, angle])
    Angle(90 - angle, radius=20 * zoom, show_spokes=true);
}

module Label(width=0, height=0, z_height=0, string, angle=0) {
  color(LABEL_COLOR) {
    linear_extrude(z_height + eps) {
      translate([width/2, height/2]) {
        rotate([0, 0, angle]) {
          if (is_undef(string) == true)
            text(parent_module(1), halign="center", valign="center");
          else 
            text(string, halign="center", valign="center");
        }
      }
    }
  }
}
