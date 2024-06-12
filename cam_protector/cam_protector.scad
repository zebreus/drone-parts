mounting_hole_distance = 17.5;
mounting_hole_diameter = 2;

mounting_hole_clearance_height = 5;
mounting_hole_clearance_diameter = 4;


camera_width = 19;
camera_clearance = 16;
camera_side_clearance = 13;
camera_bottom_clearance = 6;
camera_holder_width = 4;
camera_screw_diameter = 2;

base_plate_size = 5;
base_plate_height = 3;
base_plate_depth = 15;
base_plate_width = camera_width + camera_holder_width*2;

front_horn_clearance = 14;
front_horn_angle = 40;
front_horn_width = 4;



module mirror_copy(vector){
    children();
    mirror(vector)
    children();
}

difference() {
union() {
    // Base plate
difference() {
translate(-[base_plate_width,base_plate_depth,0]/2)
cube([base_plate_width,base_plate_depth,base_plate_height]);

mirror_copy([1,0,0])
translate([-mounting_hole_distance/2,0,0])
cylinder(h = base_plate_height + 1, d = mounting_hole_diameter);
}

// Arms
mirror_copy([1,0,0])
translate([-camera_width/2-camera_holder_width,-base_plate_depth/2,base_plate_height])
{difference() {
    union() {
cube([camera_holder_width, base_plate_depth, camera_clearance]);
translate([0,base_plate_depth/2,camera_clearance]) 
rotate([0,90,0])
cylinder(h= camera_holder_width, d = base_plate_depth);
translate([0,base_plate_depth/2,camera_clearance])
for(i = [front_horn_angle,0, -front_horn_angle])
rotate([i,0,0])
translate([0,-front_horn_width/2,0])
union() {
front_horn_length = front_horn_clearance * 1 / cos(i);

cube([camera_holder_width, front_horn_width, front_horn_length-front_horn_width/2]);
translate([0,front_horn_width/2,front_horn_length-front_horn_width/2]) 
rotate([0,90,0])
cylinder(h = camera_holder_width, d = front_horn_width);

}
    }
    translate([0,base_plate_depth/2,camera_clearance]) 
rotate([0,90,0])
cylinder(h= camera_holder_width, d = camera_screw_diameter);
}



}

translate([-base_plate_width/2,0,base_plate_height])
intersection() {
cube([base_plate_width, base_plate_depth/2, camera_bottom_clearance]);
rotate([-45,0,0])
cube([base_plate_width, base_plate_depth, camera_bottom_clearance*2]);
}



}
// Baseplate hole clearance
mirror_copy([1,0,0])

translate([-mounting_hole_distance/2,0,base_plate_height])
union() {
cylinder(h = mounting_hole_clearance_height, d = mounting_hole_clearance_diameter);
translate([0,0,mounting_hole_clearance_height])
sphere(r = mounting_hole_clearance_diameter/2);
}
}

$fa = $preview ? 12 : 3 ;
$fs = $preview ? 1 : 0.1 ;