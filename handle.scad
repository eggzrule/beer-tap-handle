// import the screws library
include <threads/threads_20161204.scad>

// smoothness of anything rounded
$fn = 300;
// millimeter to inches
mm_in_inch=25.4;

// draw the handle 
handleWithLogo();

// draw the test cube with threads
//testCube();


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

// handle parameters
handle_height           = 80;
handle_raidus           = 10;
handle_radius_top       = 22;
handle_threads_offset   = handle_radius_top - ((thread_diameter * mm_in_inch) / 2);
module handle () {
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
            cube([(handle_radius_top * 2) - 10, (handle_radius_top * 2) - 10, 3], true);
            cylinder(
                h       = 4,
                r       = 2,
                center  = true
            );
        }
    }
}


module logo(desiredWidth) {
    /*// logo constants
    logo_length = 400;
    logo_width  = 400;
    
    scale_factor = desiredWidth / logo_width;
    scale([scale_factor, scale_factor, 0.1])
    union() {
        difference() {
            surface(
                file        = "logo/logo_3000x3000_30mm.png",
                center      = false,
                invert      = false
            );
            cube([logo_width, logo_length, 1.1], false);
        }
    }*/
    
    // logo constants
    logo_length = 100;
    logo_width  = 100;
    
    scale_factor = (desiredWidth / logo_width);
    scale([scale_factor, scale_factor, 1])
    import("logo/logo_100mm.stl", center=false);
}

module handleWithLogo() {
    // build the handle
    difference() {
        handle();
        translate([handle_threads_offset, handle_threads_offset, 0])
        threadsWithOffset();
    }
    
    // render the logo
    translate([3, handle_radius_top - 1.4, handle_height])
    rotate([90, 0, 0])
    logo((handle_radius_top * 2) - 6);
}

module testCube() {
    // cube parameters
    cube_threads_offset = (1/4) * mm_in_inch;
    cube_size           = (thread_diameter * mm_in_inch) + cube_threads_offset;
    cube_height         = (threads_length * mm_in_inch) + thread_offset_from_bottom + 10;
    
    difference() {
        cube([cube_size, cube_size, cube_height]);
        translate([cube_threads_offset / 2, cube_threads_offset / 2, 0])
        threadsWithOffset();
    }
}