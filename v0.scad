include <parameters.scad>;
include <main.scad>;
include <room1.scad>;
include <room2.scad>;
include <stairs.scad>;

Main(D, 2 * x);

translate([-D - 20, 0, 0]) {
	Room1(D, 3 * x);
}

translate([D + 20, 0, 0]) {
	Room2(L, x);
}

translate([2 * D, 0, 0]) {
	Stairs(L, 2 * x);
}
