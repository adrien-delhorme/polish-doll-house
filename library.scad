include <parameters.scad>;


module rotate_origin(angles, origin) {
    translate(origin)
        rotate(angles)
            translate(-origin)
                children();
}

module Label(width=0, height=0, string, angle=0) {
  translate([width/2, height/2, wood_height * 2])
    rotate([0, 0, angle]) {
      color("black") {
        if (is_undef(string) == true)
          text(parent_module(1), halign="center", valign="center");
        else 
          text(string, halign="center", valign="center");
      }
    }
}
