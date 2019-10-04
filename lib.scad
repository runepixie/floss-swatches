/*
 * Constants
 */
CONVERT_INCHES_TO_MILLIMETERS = 25.4;
CONVERT_MILLIMETERS_TO_INCHES = 0.0393701;

/*
 * Functions
 */
function convertInchesToMillimeters(inches) = inches * CONVERT_INCHES_TO_MILLIMETERS;
function convertMillimetersToInches(millimeters) = millimeters * CONVERT_MILLIMETERS_TO_INCHES;

/*
 * Modules
 */
module grid_rect(grid_x=25.4, grid_y=25.4, lines_x=10, lines_y=10, line_wx=1.2, line_wy=1.2, base="SteelBlue") {
	line_area_x = lines_x * line_wx;
	void_area_x = grid_x - line_area_x;
	void_offset_x = void_area_x / (lines_x + 1) + line_wx;
	
	line_area_y = lines_y * line_wy;
	void_area_y = grid_x - line_area_x;
	void_offset_y = void_area_y / (lines_y + 1) + line_wy;

	color(base) {
		offset_y = void_offset_y - line_wy;
		end_y = void_offset_y * lines_y;
		for(i = [offset_y:void_offset_y:end_y]){ 
		    translate([0, i, 0])
		    	cube([grid_y, line_wy, line_wy]);
		}

		offset_x = void_offset_x;
		end_x = void_offset_x * (lines_x + 0);
		for(i = [offset_x:void_offset_x:end_x]){ 
		    rotate(a=90, v=[0, 0, 1])
		    	translate([0, -i, 0])
		    		cube([grid_x, line_wx, line_wx]);
		}
	}
}

module grid_square(grid_size=25.4, line_count=10, line_width=1.2, base="SteelBlue") {
	line_area_x = line_count * line_width;
	void_area_x = grid_size - line_area_x;
	void_offset_x = void_area_x / (line_count + 1) + line_width;
	
	line_area_y = line_count * line_width;
	void_area_y = grid_size - line_area_x;
	void_offset_y = void_area_y / (line_count + 1) + line_width;

	color(base) {
		offset_y = void_offset_y - line_width;
		end_y = void_offset_y * line_count;
		for(i = [offset_y:void_offset_y:end_y]){ 
		    translate([0, i, 0])
		    	cube([grid_size, line_width, line_width]);
		}

		offset_x = void_offset_x;
		end_x = void_offset_x * line_count;
		for(i = [offset_x:void_offset_x:end_x]){ 
		    rotate(a=90, v=[0, 0, 1])
		    	translate([0, -i, 0])
		    		cube([grid_size, line_width, line_width]);
		}
	}
}

module hole(dim_r=10, dim_h=20, faces=30, pos_x=0, pos_y=0, pos_z=0, base="MediumTurquoise") {
	difference() {
		children();
		color(base) {
			translate([pos_x, pos_y, pos_z])
				cylinder(r=dim_r, h=dim_h, $fn=faces);
		}
	}
}

module label_inset(dim_x=10, dim_y=20, dim_z=0, pos_x=0, pos_y=0, pos_z=0, base="SlateGray") {
	difference() {
		children();
		color(base) {
			translate([pos_x, pos_y, pos_z])
				cube([dim_x, dim_y, dim_z]);
		}
	}
}