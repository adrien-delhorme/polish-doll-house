include <constants.scad>;

/* Constants related to the annotation lines
 *
 * Because the dimension of the part to be documented can vary widely, you
 * probably are going to need to adjust the parameters to fit the context of
 * your part.
 *
 * For example, the following parameters were used for a part 3.5 units long.
 * In addition, DIM_HEIGHT is a height meant to be slightly above your tallest
 * part.
 */

DIM_LINE_WIDTH = .3; // width of dimension lines
DIM_SPACE = .1;  // a spacing value to make it easier to adjust line spacing etc
DIM_HEIGHT = .01; // height of lines

// an approximation that sets the font size relative to the line widths
DIM_FONTSCALE = DIM_LINE_WIDTH * .7;

DIMENSION_COLOR = "red";
LABEL_COLOR = "red";


module Arrow(arr_points, arr_length, height) {
    // arrow points to the left
    linear_extrude(height=height, convexity=2)

    polygon(
        points = [[0, 0],
                [arr_points, arr_points / 2],
                [arr_length, 0],
                [arr_points, -arr_points / 2]],
        paths = [[0, 1, 2, 3]], convexity = 2);
}

module Line(length, width=DIM_LINE_WIDTH, height=DIM_HEIGHT, left_arrow=false, right_arrow=false) {
    /* This module draws a line that can have an arrow on either end. Because
     * the intended use is to be viewed strictly from above, the height of the
     * line is set arbitrarily thin.
     *
     * The factors arr_length and arr_points are used to create a proportionate
     * arrow. Your sense of asthetics may lead you to choose different
     * numbers.
     */

    arr_points = width * 4;
    arr_length = arr_points * .6;

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

module Dimension(length, line_width=DIM_LINE_WIDTH, loc=DIM_CENTER) {
    color(DIMENSION_COLOR) {
      text = str(length);
      space = len(text) * DIM_FONTSCALE * 7;
      margin = 3;

      if (loc == DIM_CENTER) {
        Line(
          length=length / 2 - space / 2 - margin,
          width=line_width,
          height=DIM_HEIGHT,
          left_arrow=true,
          right_arrow=false
        );
        translate([length / 2 - space / 2, -DIM_FONTSCALE * 4, 0])
          scale([DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE])
            text(text);

        translate([length / 2 + space / 2 + margin, 0, 0])
          Line(
            length=length / 2 - space / 2 - margin,
            width=line_width,
            height=DIM_HEIGHT,
            left_arrow=false,
            right_arrow=true
          );
      } else {
        if (loc == DIM_LEFT) {
          Line(
            length=length,
            width=line_width,
            height=DIM_HEIGHT,
            left_arrow=true,
            right_arrow=true
          );

          translate([-space, -DIM_FONTSCALE * 3, 0])
            scale([DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE])
              text(text);
        } else {
          if (loc == DIM_RIGHT) {
            Line(
              length=length,
              width=line_width,
              height=DIM_HEIGHT,
              left_arrow=true,
              right_arrow=true
            );

            translate([length + space, -DIM_FONTSCALE * 3, 0])
              scale([DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE])
                text(text);
          } else {
            if (loc == DIM_OUTSIDE) {
              rotate([0, 180, 0])
                Line(
                  length=length / 2,
                  width=line_width,
                  height=DIM_HEIGHT,
                  left_arrow=true,
                  right_arrow=false
                );

              translate([(length) / 2 - space / 2 * .9, -DIM_FONTSCALE * 3, 0])
                scale([DIM_FONTSCALE, DIM_FONTSCALE, DIM_FONTSCALE])
                  text(text);

              translate([length, 0, 0])
                Line(
                  length=length / 2,
                  width=line_width,
                  height=DIM_HEIGHT,
                  left_arrow=true,
                  right_arrow=false
                );
            }
          }
        }
      }
  }
}

module Arc(angle, radius) {
  color(DIMENSION_COLOR)
    intersection() {
      difference() { // the line
        circle(radius);
        offset(delta=-DIM_LINE_WIDTH)
          circle(radius);
      }
      // the "mask" that removes all parts of the line outsid of the angle
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
      scale(DIM_FONTSCALE)
        rotate([0, 0, label_angle])
          color(DIMENSION_COLOR)
            text(str(round(angle), "°"), halign="center", valign="center");
}

module AngleOverview(angle, height, label="") {
  zoom = 2;
  width = 20;
  y = height / tan(angle);

  scale(zoom) {
    // Shape
    polygon([[0, 0], [width, 0], [width, height], [y, height]]);

    // Label
    translate([width + 10, 0, 0]) scale(DIM_FONTSCALE) color(DIMENSION_COLOR) text(label);

    // Angle label
    rotate([0, 0, angle])
      Angle(90 - angle, radius=20, show_spokes=true);
  }
}

module Label(width=0, height=0, z_offset=0, string, angle=0) {
  translate([width/2, height/2, z_offset])
    rotate([0, 0, angle]) {
      color(LABEL_COLOR) {
        if (is_undef(string) == true)
          text(parent_module(1), halign="center", valign="center");
        else 
          text(string, halign="center", valign="center");
      }
    }
}
