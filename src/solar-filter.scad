use <threadlib/threadlib.scad>
include <../knobs/lib_knobs.scad>

/* General */
magnet_d=7;
magnet_h=1.8;
magnet_count=6;
aperture_d=80;
aperture_h=5;

/* Front */
front_bolt_thread_d=2; // M2
front_bolt_thread_h=14;
front_bolt_head_d=4.5;
front_bolt_head_h=2;
front_h=6;
front_side_t=4;
front_base_gap_t=0.1;
front_hole_d=115; // multiple of 5 for cutting threads

/* Base */
ota_d=94;
ota_h=25;
ota_t=6;
base_w=120;
base_h=6;
ota_bolt_d=3.9; // M4
ota_bolt_count=3;
ota_bolt_offset=10;

/* Ring */
ring_id=85;
ring_od=105; // make sure front_hold_d-ring_od is big enough for the front lid
ring_h=4;

/* Base Lid */
base_lid_d=ota_d-2;
base_lid_h=ota_bolt_offset+ota_bolt_d*2;
base_lid_t=3;

/* Front Lid */
front_lid_h1=10;
front_lid_d=front_hole_d+10;
front_lid_t=2;
front_lid_h2=base_h-2; // must be smaller than base_h
front_lid_thread_expansion=1;

/* [Hidden] */
front_bolt_count=4; // probably should hard code this
ota_name="Generic";

$fn=$preview?50:200;

module cut_magnets() {
    translate([base_w/2,base_w/2,0]) 
    for (i = [0:magnet_count]) {
        rotate([0,0,i*360/magnet_count])
        translate([ring_id/2+(ring_od-ring_id)/4,0,-magnet_h])
        cylinder(d=magnet_d,h=magnet_h*2);
    }
}

module cut_ota_bolts() {
    translate([base_w/2,base_w/2,base_h+ota_h-ota_bolt_offset]) 
    for (i = [0:ota_bolt_count]) {
        rotate([0,0,i*360/ota_bolt_count])
        translate([ota_d/2-ota_t/2,0,0])
        rotate([0,90,0])
        cylinder(d=ota_bolt_d,h=ota_t*2);
    }
}

module cut_front_bolts() {
    translate([base_w/2,base_w/2,base_h/2]) 
    for (i = [0:front_bolt_count]) {
        rotate([0,0,i*360/front_bolt_count])
        translate([base_w/2+front_side_t-front_bolt_head_h,0,0])
        rotate([0,-90,0])
        union() 
        {
            translate([0,0,-1])
            cylinder(d=front_bolt_thread_d,h=front_bolt_thread_h+1);
            translate([0,0,-front_bolt_head_h*2])
            cylinder(d=front_bolt_head_d,h=front_bolt_head_h*2);
        }
    }
}

module part_base() {
    difference()
    {
        union()
        {
            // aperture
            // the top of this is z=0
            translate([base_w/2,base_w/2,-max(base_h,aperture_h)]) 
            difference()
            {
                cylinder(d=ota_d+ota_t*2,h=max(base_h,aperture_h));

                translate([0,0,-(max(base_h,aperture_h))/2])
                cylinder(d=aperture_d,h=2*max(base_h,aperture_h));
            }

            // ota sleeve
            translate([base_w/2,base_w/2,0]) 
            difference()
            {
                cylinder(d=ota_d+ota_t*2,h=ota_h);
                
                translate([0,0,-ota_h/2])
                cylinder(d=ota_d,h=2*ota_h);

            }

            // main flat bit
            translate([0,0,-max(base_h,aperture_h)])
            difference()
            {
                cube([base_w,base_w,base_h]);
            
                translate([base_w/2,base_w/2,0]) 
                translate([0,0,-(ota_h+base_h)/2])
                cylinder(d=ota_d,h=2*(ota_h+base_h));
            }
        }
        
        // cut various other bits now
        
        // magnet holes
        translate([0,0,-max(base_h,aperture_h)])
        cut_magnets();
        
        // ota bolts
        cut_ota_bolts();
        
        // front bolts
        translate([0,0,-max(base_h,aperture_h)])
        cut_front_bolts();
    }
}

module part_base_lid() {
    // the flat part is the same diameter as the ota sleeve
    translate([base_w/2,base_w/2,0])
    union()
    {
        cylinder(d=ota_d+ota_t*2,h=base_lid_t);
        
        difference()
        {
            cylinder(d=base_lid_d,h=base_lid_h);
            
            translate([0,0,-base_lid_h/2])
            cylinder(d=base_lid_d-2*base_lid_t,h=base_lid_h*2);
        }
    }
}


module part_ring() {
    difference()
    {
        translate([base_w/2,base_w/2,0]) 
        difference()
        {
            cylinder(d=ring_od,h=ring_h);
            
            translate([0,0,-ring_h/2])
            cylinder(d=ring_id,h=ring_h*2);
        }
        
        // cut magnet holes
        cut_magnets();
    }
}

module part_front() {
    difference()
    {
        // main front block
        translate([-front_side_t-front_base_gap_t,-front_side_t-front_base_gap_t,-front_h])
        cube([base_w+front_side_t*2+front_base_gap_t*2,base_w+front_side_t*2+front_base_gap_t*2,front_h+base_h]);
        
        // cut the base
        cube([base_w+front_base_gap_t*2,base_w+front_base_gap_t*2,base_h*2]);
        
        // cut the front bolts
        cut_front_bolts();
        
        // cut threads for lid, hole for aperture & magnet ring
        translate([base_w/2,base_w/2,(front_h+base_h)])
        // scale threads by front_lid_thread_expansion, use scale (%) to implement
        scale([(front_hole_d+front_lid_thread_expansion)/front_hole_d,(front_hole_d+front_lid_thread_expansion)/front_hole_d,1])
        rotate([180,0,0])
        tap(str("M",front_hole_d,"x2"), turns=10);
    }

}

module test_front_thread() {
    intersection()
    {
        part_front();

        translate([base_w/2,base_w/2,-(front_h+base_h)])
        cylinder(d=front_hole_d+front_lid_t*2+front_lid_thread_expansion,h=30);
    }
}


module part_front_lid() {
    // bolt turn=1 is about 2.5mm
    
    translate([base_w/2,base_w/2,0])
    union()
    {
        color("green")
        translate([0,0,-front_lid_h1+0.1])
        part_knurled_hex_head(
            head_d=0,
            head_h=0,
            knob_d=front_lid_d,
            knob_h=front_lid_h1,
            knurl_t=2,
            knurl_h=front_lid_h1*.7,
            knurl_count=front_lid_d*100/125
        );
        
        
        difference()
        {
            color("pink")
            translate([0,0,1.01])
            bolt(str("M",front_hole_d,"x2"), turns=front_lid_h2/2.5);
            
            cylinder(d=front_hole_d-front_lid_t*2,h=front_lid_h2*2);
        }
    }
}

module part_test() {
    z=magnet_h*4+max(ota_bolt_d, front_bolt_head_d);
    
    difference()
    {
        cube([magnet_d*2,magnet_d*2,z]);
        
        color("red")
        translate([magnet_d,magnet_d,-magnet_h])
        cylinder(d=magnet_d,h=magnet_h*2);

        color("red")
        translate([magnet_d,magnet_d,z-magnet_h])
        cylinder(d=magnet_d,h=magnet_h*2);
        
        color("red")
        translate([-ota_t,magnet_d*2/4,z/2])
        rotate([0,90,0])
        cylinder(d=ota_bolt_d,h=ota_t*4);
        
        color("red")
        translate([magnet_d*2-front_bolt_head_h,magnet_d*6/4,z/2])
        rotate([0,-90,0])
        union() 
        {
            translate([0,0,-1])
            cylinder(d=front_bolt_thread_d,h=front_bolt_thread_h+1);
            translate([0,0,-front_bolt_head_h*2])
            cylinder(d=front_bolt_head_d,h=front_bolt_head_h*2);
        }
    }
}


// front lid
translate([base_w*1.5,0,0]) part_front_lid();

// base lid
translate([0,base_w*1.5,0]) part_base_lid();

// front
translate([-base_w*1.5,-base_w*1.5,0]) part_front();

// base
translate([-base_w*1.5,0,max(base_h,aperture_h)]) part_base();

// ring
translate([-base_w/2,base_w*1.5,0]) rotate([0,180,0]) part_ring();

// test magnets and bolts
color("pink") translate([base_w/2,-base_w,0]) part_test();

// test lid thread
color("teal") test_front_thread();

union()
translate([base_w/2,base_w/2,0])
{
    color("red")
    linear_extrude(2)
    text(str(ota_name), halign="center", valign="center");

    cube([aperture_d*2/3,aperture_d/2,0.1],center=true);
}