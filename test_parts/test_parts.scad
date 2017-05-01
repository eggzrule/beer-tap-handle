
cubeWithSnaps();

translate([20, 0, 0])
cubeSnapInto();

module annularSnap(length_of_snap, trailing_trim_length) {
    translate([0,0,-0.01])
    hull() {
        cube([length_of_snap, 0.5, 0.51]);
        
        translate([0, 1, 0])
        cube([length_of_snap, 0.5, 0.71]);
    }
    
    translate([0, 1.5, -0.01])
    cube([length_of_snap, trailing_trim_length, 0.251]);
}

thread_diameter     = (3/8) * 25.4;  // in inches
cube_threads_offset = 3;
cube_size           = thread_diameter + cube_threads_offset;
cube_height         = 10;
module cubeWithSnaps() {
    difference() {
        cube([cube_size, cube_size, cube_height]);
        
        // left
        translate([0, 0, cube_height - 2.5])
        rotate([90, 0, 90])
        annularSnap(cube_size + 0.01, 1);
        
        // right
        translate([cube_size, cube_size, cube_height - 2.5])
        rotate([90, 0, 270])
        annularSnap(cube_size + 0.01, 1);
        
        // front
        translate([cube_size, 0, cube_height - 2.5])
        rotate([90, 0, 180])
        annularSnap(cube_size + 0.01, 1);
        
        // back
        translate([0, cube_size, cube_height - 2.5])
        rotate([90, 0, 0])
        annularSnap(cube_size + 0.01, 1);
    }
}

module cubeSnapInto() {
    my_cube_size    = (cube_size * 1.1) + 5;
    my_cube_height  = cube_height + 1;
    
    difference() {
        cube([my_cube_size, my_cube_size, my_cube_height]);
        
        translate([2.5, 2.5, 0])
        scale([1.1, 1.1, 1])
        cubeWithSnaps();
    }
}