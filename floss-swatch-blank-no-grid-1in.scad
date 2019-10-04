/*
Floss Color Swatch

Avery Label 1/2 in x 5/16 in

DMC Label 1/4 in x 1/4 in = 6.35 mm

Max 1 1/2 in square = 38.1 mm
*/

// Camera

$vpr = [38.5, 0, 45.5];
$vpt = [19.885, 13.2321, 10.0017];
$vpd = 200;

// echo("$vpr", $vpr);
// echo("$vpt", $vpt);
// echo("$vpd", $vpd);

// ECHO: "$vpr", [38.5, 0, 45.5]
// ECHO: "$vpt", [19.885, 13.2321, 10.0017]
// ECHO: "$vpd", 200


// Constants
conv_in_to_mm = 25.4;
conv_mm_to_in = 0.0393701; // NOTE: Just for echo


// Base Settings
frame_height = 2;  // Frame Height
frame_width = 3;  // Frame Width

hole_radius = .125 * conv_in_to_mm; // 1/8 in radius

label_height = 1;
label_width = .25 * conv_in_to_mm; // 1/4 in


// Derived Constants
grid_size = 1 * conv_in_to_mm; // 1 inch grid
frame_length = grid_size + (frame_width * 2); // Frame Length
label_length = frame_length - (hole_radius * 2) - (frame_width * 3); // 1/2 in
top_frame_width = hole_radius * 2 + frame_width * 2;

// echo("frame_length (width inches)", frame_length * conv_mm_to_in);
// echo("frame_length (width inches)", (frame_length + frame_width * 2) * conv_mm_to_in);

union() {
	difference(){
		frame();
		hole();
		label();
	}
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

module hole() {
	height = frame_height * 2;
	h_x = frame_width + hole_radius;
	h_y = frame_length + frame_width;
	color("MediumTurquoise") {
		translate([h_x, h_y, -1])
			cylinder(r=hole_radius, h=height, $fn=60);
	}
}

module label() {
	label_x = frame_length - frame_width - label_length;
	label_y = frame_length;
	color("SlateGray") {
		translate([label_x, label_y, 1.25])
			cube([label_length, label_width, label_height]);
	}
}


