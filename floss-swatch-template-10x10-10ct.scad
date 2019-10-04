/*
Blank 10x10 10ct Floss Color Swatch

Avery Label 1/2 in x 5/16 in

DMC Label 1/4 in x 1/4 in = 6.35 mm

Max 1 1/2 in square = 38.1 mm
*/

use <lib.scad>;

/*
 * Camera
 */

// $vpr = [38.5, 0, 45.5];
$vpt = [19.885, 13.2321, 10.0017];
$vpd = 200;

// echo("$vpr", $vpr);
// echo("$vpt", $vpt);
// echo("$vpd", $vpd);

// ECHO: "$vpr", [38.5, 0, 45.5]
// ECHO: "$vpt", [19.885, 13.2321, 10.0017]
// ECHO: "$vpd", 200

/*
 * Base Settings
 */
frame_height = 2;  // Frame Height
frame_width = 3;  // Frame Width
grid_count = 10;
hole_pz = -1;
hole_r = convertInchesToMillimeters(0.125);
label_dy = convertInchesToMillimeters(.25); // 1/4 in
label_dz = 1;
label_pz = 1.25;
line_width = 1.25; // Line Width
stitch_count = 10; // How many stitches per inch
label_id = "X0Y0X";

/*
 * Derived Constants
 */
grid_size = convertInchesToMillimeters(grid_count / stitch_count); // 25.4 * (20 / 10 = 2) = 50.8

frame_length = grid_size + (frame_width * 2); // Frame Length
hole_h = frame_height * 2;
hole_px = frame_width + hole_r;
hole_py = frame_length + frame_width;
label_dx = frame_length - (hole_r * 2) - (frame_width * 3); // Label Length
label_px = frame_length - frame_width - label_dx;
label_py = frame_length;
top_frame_width = hole_r * 2 + frame_width * 2;

// echo("frame_length (width inches)", convertMillimetersToInches(frame_length));
// echo("frame_length (width inches)", convertMillimetersToInches(frame_length + frame_width * 2));

union() {
	hole(dim_r=hole_r, dim_h=hole_h, faces=60, pos_x=hole_px, pos_y=hole_py, pos_z=hole_pz) {
		label_inset(pos_x=label_px, pos_y=label_py, pos_z=label_pz, dim_x=label_dx, dim_y=label_dy, dim_z=label_dz) {
			frame();
		}
	}
	label_text();
	grid();
}

module frame() {
	color("DarkSlateGray") {
		// Bottom Frame
		cube([frame_length, frame_width, frame_height]);
		
		// Top Frame
		translate([0, frame_length-frame_width, 0])
			cube([frame_length, top_frame_width, frame_height]);
		
		// Left Frame
		rotate(a=90, v=[0, 0, 1])
			translate([0, -frame_width, 0])
				cube([frame_length, frame_width, frame_height]);

		// Right Frame
		rotate(a=90, v=[0, 0, 1])
			translate([0, -frame_length, 0])
				cube([frame_length, frame_width, frame_height]);
	}
}

module grid() {
	translate([frame_width,frame_width,0])
		grid_square(grid_size=grid_size, line_count=grid_count, line_width=line_width, base="SteelBlue");
}

module label_text() {
	translate([label_px + 8, label_py + 3, label_pz - .25]) {
		linear_extrude(height = 1) {
			// text(text=label_id, font="American Typewriter:style=Condensed Bold", size=3.5, spacing=1.1, halign="center", valign="center");
			// text(text=label_id, font="Arial Black:style=Regular", size=3.5, spacing=1, halign="center", valign="center");
			text(text=label_id, font="Arial Narrow:style=Bold", size=3.5, spacing=1.1, halign="center", valign="center");
		}
	}
}

