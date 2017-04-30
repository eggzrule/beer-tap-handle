// import the screws library
include <threads/threads_20161204.scad>

// smoothness of anything rounded
$fn         = 365;
// millimeter to inches
mm_in_inch  = 25.4;

// draw the handle
//rotate([0,0,$t*360])
//translate([-handle_radius_top, -handle_radius_top, 0])
//handleWithLogo();

// draw the test cube with threads
cubeWithThreads();


// thread parameters
thread_diameter             = 3/8;  // in inches
threads_per_inch            = 16;   // in inches
threads_length              = 0.75; // in inches
thread_offset_from_bottom   = (0.1 * mm_in_inch);
module threadsWithOffset () {
    radius = (thread_diameter / 2 * mm_in_inch);
    
    union () {
        translate([
            radius,
            radius,
            (threads_length * mm_in_inch) + thread_offset_from_bottom]
        )
        rotate([0, 180, 0])
        english_thread(
            diameter            = thread_diameter,
            threads_per_inch    = threads_per_inch,
            length              = threads_length,
            internal            = true
        );
        
        translate([radius, radius, 0])
        cylinder(
            h       = thread_offset_from_bottom + 0.01,
            d       = (thread_diameter * mm_in_inch),
            center  = false
        );
    }
}

// cube parameters
cube_threads_offset = 3;
cube_size           = (thread_diameter * mm_in_inch) + cube_threads_offset;
cube_height         = (threads_length * mm_in_inch) + thread_offset_from_bottom + 10;
module cubeWithThreads() {
    difference() {
        cubeNoThreads();
        translate([cube_threads_offset / 2, cube_threads_offset / 2, 0])
        threadsWithOffset();
    }
}
module cubeNoThreads() {
    cube([cube_size, cube_size, cube_height]);
}

// handle parameters
handle_height       = 80;
handle_raidus       = 12;
handle_radius_top   = 22;
handle_cube_offset  = handle_radius_top - ((cube_size + 0.1) / 2);
module handle () {
    difference() {
        union() {
            translate([handle_radius_top, handle_radius_top, handle_height / 2])
            minkowski() {
                cylinder(
                    h       = handle_height - 2,
                    r1      = handle_raidus - 2,
                    r2      = handle_radius_top - 2,
                    center  = true
                );
                sphere(1);
            }
            
            translate([
                handle_radius_top,
                handle_radius_top + 2,
                handle_height + handle_radius_top - 3
            ])
            rotate([90,0,0])
            minkowski() {
                cube([
                    (handle_radius_top * 2) - 10,
                    (handle_radius_top * 2) - 10,
                    3],
                    true
                );
                cylinder(
                    h       = 4,
                    r       = 2,
                    center  = true
                );
            }
        }
        
        translate([handle_cube_offset, handle_cube_offset, 0])
        cubeNoThreads();
    }
}

// logo constants
logo_size   = 300;
module logo(desired_size) {
    conversion = desired_size / logo_size;
    scale([conversion, conversion, 1])
    import("logo/logo_300mm.stl");
}

module handleWithLogo() {
    union() {
        // build the handle
        handle();
        
        // render the logo
        desired_logo_size = 36;
        translate([
            3 + 1,
            handle_radius_top - 1.5 + 1,
            handle_height + 1])
        rotate([90, 0, 0])
        logo(desired_logo_size);
    }
}