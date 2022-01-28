include <parameters.scad>;
use <modules/main.scad>;
use <modules/large_room.scad>;
use <modules/small_room.scad>;
use <modules/stairs.scad>;

translate([0, x, H + 2 * wood_height])
  Main(width=D, depth=2 * x);

LargeRoom(width=D, depth=3 * x, height=H);

translate([-d - wood_height, 0, H + 2 * wood_height]) {
	SmallRoom(width=L, depth=x, height=H);
}

translate([D, 0, 0]) {
	Stairs(width=L, depth=2 * x, height=H);
}
