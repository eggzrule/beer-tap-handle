// import the screws library
include <threads/threads.scad>

// smoothness of anything rounded
$fn = 300;

// millimeter to inches
mm_in_inch=25.4;

// parameters
thread_diameter=3/8;
threads_per_inch=16;
threads_length=1;
cube_size=((thread_diameter + (1/4)) * mm_in_inch);
cube_height=(threads_length * mm_in_inch);

// render the cylinder
rotate([180,0,0])
translate([(cube_size / 2), -(cube_size / 2), -(cube_height / 2)])
difference(){
    cube([cube_size, cube_size, cube_height], true);
    english_thread(
        diameter=thread_diameter,
        threads_per_inch=threads_per_inch,
        length=threads_length,
        internal=true
    );
}