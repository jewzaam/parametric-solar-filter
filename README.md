# Solar Filter

## Requirements

- https://github.com/adrianschlatter/threadlib 

## Goals

- Minimize solar film usage for large OTA.
- Ensure film is flat over aperture.
- Ensure parts of filter cannot be easily knocked apart.
- Allow for variable printer tolerances.
- Protect solar film while filter is not in use.
- Parametric design that can accomidate any size OTA.

## Design Highlights

There are 5 parts to this model.  Starting from the OTA side:

- lid to close the filter on OTA side
- base that goes onto OTA and sets the aperture 
- ring with magnets to hold solar film
- front plate to hold everything together
- lid to close the front plate

The initial model will not address the lids.  Therefore we have 3 named parts:
- base
- ring
- front

The base provides:
- sleeve that fits over OTA
- bolt holes to attach to OTA
- aperture independent of sleeve diameter
- recesses for magnets that match with the ring
- flat square on which solar film rests
- holes for front part to bolt into so all is secure

The ring provides:
- recesses for magenets that match base
- simply holds the solar film down around the base aperture

The front provides:
- hole larger than the ring
- thicker than ring so front lid (future) can fit
- sides that overlap with base
- holes for bolts (probably M2) to attach to base

## How to Customize

Conventions:
- all related parameters start with the name of the object
- sub-categories of parts will include additional words
- underscore is used to deliniate words
- last section indicates the unit of measure (uom)
- uom `d` = diameter
- uom `id` = inner diameter
- uom `od` = outer diameter
- uom `r` = radius
- uom `h` = height (z dimension)
- uom `w` = width (x and y dimension)
- uom `t` = thickness (cylinder walls)
- uom `count` = number of instances of a part
- uom `offset` = a value relative to some other thing

Each section in the scad file has a sub-section here.

### General

1. Set diameter  and height of magnet.
2. Set number of magnets (6 works well in my opinion).
3. Decide how wide an aperture you want, set as `aperture_d`.  This needs to be less than or equal to the OTA inner diameter.
4. Set `aperture_h` to ensure there is enough material to completely block light from passing through.

### Front

1. Set `front_bolt_thread_d` to acutal diameter of bolt used to hold front to base (i.e. M2 bolt).
2. Set `front_bolt_thread_h` to at least the length of the bolt being used.  It _must_ be longer than the bolt!
3. Set `front_bolt_head_d` to _wider` than the **head** of the bolt.
4. Set `front_bolt_head_h` to at least the height of the **head** of the bolt.  It will extrude past the print if too short, but won't impact functionality.
5. Set `front_h` to at least `max(2*front_bolt_thread_d, ring_h)` else threads of the bolt may break the printed plastic or the magent ring will protrude.
6. Set `front_side_t` to a value larger than `front_bolt_head_h`.  The extra value will be the thickness of the plastic used to hold the bolt head.  Recommend at least 1 mm extra.
7. Set `front_base_gap_t` to a small value.  This will provide a small gap between the front and base parts so sanding is (ideally/hopefully) not necessary.

### Base

1. Measure outer diameter of OTA.  Add some buffer since there are bolts to secure the filter.  Set as `ota_d`.
2. Measure inner diameter of OTA.  Make sure `aperture_d` is less than or equal to the OTA inner diameter.
3. Measure height of OTA from objective end.  Set `ota_h` to a value equal to or less than this height.  This is the area that slides over the OTA, so make sure there's enough room
4. Set `ota_t` to the wall thickness for the bit that slides over the OTA.  It should be strong / thick enough for the 3 bolts that hold the filter on the OTA.
5. Set `base_w` to a value larger than `ota_d + 2*ota_t`
6. Measure diameter of bolts for OTA, set as `ota_bolt_d`.  Do not add to the actual diameter since the bolt (i.e. M4 bolt) will be threaded into the 3D print directly.
7. OPTIONAL: set number of OTA bolts with `ota_bolt_count`.  A value of 3 is recommended.
8. Set `ota_bolt_offset`, measured from the OTA side of the print.  Ensures you have control on bolt placement and can therefore easily access the bolts to use them.
9. Set `base_h` to be the same or greater than `front_h`.

### Ring

1. Set `ring_id` to a value greater than `aperture_d`.  It can be the same value, but may introduce artifacts in the light path.  Best to make it slightly larger.
2. Set `ring_od` to a value greater than `ring_id + 2*magnet_d`.
3. Set `ring_h` to something larger than `magnet_h`, perhaps `2 + magnet_h` or greater.


## How to Print

### Test Part
There is "test" part provided that allows testing:
- the magent hole on the base (printed on bottom of test)
- the magnet hole on the ring (printed on top of test)
- the OTA bolt hole
- the front bolt hole

It is recommended to print the test part first before printing the final parts.  Additionally, consider printing a cut of the OTA cylinder to verify fit of the OTA.

### Printing Tips
- Orientation: as provided, no rotation required.
- Infill: 
  - base: 100% (OTA cylinder could be lower infill if using modifiers)
  - ring: low infill, i.e. 15%
  - front: low infill, i.e. 15%
- Filament:
  - base: black, opaque
  - ring: anything
  - front: anything

## How to Assemble

1. Verify fit of the base and front parts.  If necessary, sand the base so the front will fit smoothly
1. Thread front bolts (i.e. M2) into the front holes.
2. Thread OTA bolts (i.e. M4) into the OTA holes.
3. Glue magents into holes in ring and base.  Make sure (1) the polarity is the same for each magent in each part and (2) opposite the polarity of the opposing part.
4. LET GLUE DRY COMPLETELY!  You do not want the glue to stick to the solar film.  Just wait!
5. Place base on flat surface, OTA side down.
6. Cut solar film to a square that is LARGER than the magnet ring.
7. Place solar film over the aperture hole, covering all magnets.
8. Place magnet ring over the solar film, ensuring all magnets connect with the opposing magnet.
9. Place front over the base and solar film such that the lip of the front slides over the side of the base.
10. Gently tighten bolts on the front.

### How to Use

1. Hold filter without any optics up towards the sun and verify there are NO holes in the solar film.  If damaged, DO NOT USE!!!!!!
1. Loosen OTA bolts.
1. Slide OTA hole over your OTA.
2. Tighten OTA bolts enough that filter will not easily come off.  Do not over tighten!  You could damage or mark the OTA!