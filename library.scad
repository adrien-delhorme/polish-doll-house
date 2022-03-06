include <parameters.scad>;


module Label(width=0, height=0, string, angle=0) {
  translate([width/2, height/2, wood_thickness * 2])
    rotate([0, 0, angle]) {
      color(LABEL_COLOR) {
        if (is_undef(string) == true)
          text(parent_module(1), halign="center", valign="center");
        else 
          text(string, halign="center", valign="center");
      }
    }
}

module Dimension(length, loc=DIM_CENTER) {
  color(DIMENSION_COLOR)
    dimensions(length=length, loc=loc);
}

module Line(length) {
  color(DIMENSION_COLOR)
    line(length);
}

module Arc(angle, radius) {
  color(DIMENSION_COLOR)
    intersection() {
      difference() {
        circle(radius);
        offset(delta=-DIM_LINE_WIDTH)
          circle(radius);
      }
      scale(radius * 2) polygon([[0, 0], [1, 0], [cos(angle), sin(angle)]]);
    }
}

module Angle(angle, radius=10, label_angle=0) {
  label_angle = label_angle == 0 ? angle/2 : label_angle;
  Arc(angle, radius);
  offset = 5;
  translate([radius + offset, ((radius + offset) * tan(angle)) / 2, 0])
    rotate([0, 0, label_angle])
      scale(DIM_FONTSCALE)
        color(DIMENSION_COLOR)
          text(str(round(angle), "°"));
}
