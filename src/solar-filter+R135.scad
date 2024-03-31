include <solar-filter.scad>

ota_name="R135";

// by setting values here after import we override what is in the upstream model

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
front_hole_d=110;

/* Base */
ota_d=94; // measured +  1mm
ota_h=25;
ota_t=6;
base_w=120;
base_h=6;
ota_bolt_d=3.9; // M4
ota_bolt_count=3;
ota_bolt_offset=10;

/* Ring */
ring_id=85;
ring_od=105;
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
