// import the screws library
include <threads/threads_20161204.scad>

// smoothness of anything rounded
$fn = 300;

// millimeter to inches
mm_in_inch=25.4;

// thread parameters
thread_diameter             = 3/8;  // in inches
threads_per_inch            = 16;   // in inches
threads_length              = 1;    // in inches
thread_offset_from_bottom   = (0.1 * mm_in_inch);

// cube parameters
cube_threads_offset         = (1/4) * mm_in_inch;
cube_size                   = (thread_diameter * mm_in_inch) + cube_threads_offset;
cube_height                 = (threads_length * mm_in_inch) + thread_offset_from_bottom + 10;

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

module threadsShell () {
    cube([cube_size, cube_size, cube_height]);
}

difference() {
    threadsShell();
    
    translate([cube_threads_offset / 2, cube_threads_offset / 2, 0])
    threadsWithOffset();
}