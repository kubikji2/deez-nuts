# Deez Nutz - bolts, nuts, screws and threads OpenSCAD repository

Bolts, nuts and screws, and the holes for them, from the name of their standard and a descriptor such as `"M3x20"`, the way you would say it. The dimensions come from the standards (M2 to M12, M2.5 included), and every table names its sources. Built on solidpp (a git submodule in `solidpp/`).

```openscad
include <deez-nuts/deez-nuts.scad>

difference()
{
    cubepp([20, 20, 12], align="z");
    // a socket head bolt sunk into the top, a nut trap with a side slot at the bottom
    translate([0, 0, 12]) bolt_hole("M3x16", "DIN912", align=DN_ALIGN_TOP, hh_off=2);
    translate([0, 0, 2]) nut_hole("M3", "DIN934", s_off=15);
}
```

`deez-nuts.scad` includes everything once, solidpp too, so `cubepp`, `cylinderpp` and the other solidpp modules are available in your design. The files in `bolts/`, `nuts/` and `screws/` are not meant to be included on their own.

## Standards

| kind  | standard    | also accepted                      | constant                     | sizes      | length in the descriptor |
|-------|-------------|------------------------------------|------------------------------|------------|--------------------------|
| bolt  | `DIN912`    | `ISO4762`                          | `DN_BOLT_SOCKET_HEAD`        | M2 - M12   | shaft                    |
| bolt  | `DIN933`    |                                    | `DN_BOLT_HEX_HEAD`           | M2 - M12   | shaft                    |
| bolt  | `ISO4017`   |                                    |                              | M2 - M12   | shaft                    |
| bolt  | `DIN7380-1` | `ISO7380-1`, `ISO7380`, `DIN73801` | `DN_BOLT_BUTTON_HEAD`        | M2.5 - M12 | shaft                    |
| bolt  | `ISO7380-2` | `DIN7380-2`                        | `DN_BOLT_FLANGE_BUTTON_HEAD` | M3 - M12   | shaft                    |
| bolt  | `DIN7991`   |                                    | `DN_BOLT_COUNTERSINK`        | M3 - M12   | total (with the head)    |
| bolt  | `ISO10642`  |                                    |                              | M2 - M12   | total (with the head)    |
| bolt  | `DIN84A`    | `DIN84`                            | `DN_BOLT_SLOTTED_HEAD`       | M2 - M10   | shaft                    |
| bolt  | `ISO1207`   |                                    |                              | M2 - M10   | shaft                    |
| screw | `DIN7505`   | `LUXPZ` (deprecated)               | `DN_SCREW_POZIDRIV`          | 3 - 6      | total (with the head)    |
| nut   | `DIN934`    |                                    | `DN_NUT_REGULAR`             | M2 - M12   |                          |
| nut   | `ISO4032`   |                                    |                              | M2 - M12   |                          |
| nut   | `DIN439`    | `DIN439B`, `DIN439-2`              | `DN_NUT_THIN`                | M2 - M12   |                          |
| nut   | `ISO4035`   |                                    |                              | M2 - M12   |                          |
| nut   | `DIN985`    |                                    | `DN_NUT_NYLOCK`              | M2 - M12   |                          |
| nut   | `ISO10511`  |                                    |                              | M3 - M12   |                          |
| nut   | `DIN562`    |                                    | `DN_NUT_SQUARE`              | M2 - M10   |                          |

- The names are case-insensitive, and spaces, dashes, dots and underscores are ignored: `"ISO 4762"`, `"iso4762"` and `"DIN-912"` all work.
- Where a DIN standard and its ISO successor differ, each has its own table: e.g. the hex heads and nuts of M10 and M12 (17 and 19 across the flats in DIN, 16 and 18 in ISO), the heights of `DIN934` and `ISO4032` nuts from M5, the larger countersunk heads of `ISO10642`. `ISO4762` and `ISO7380-1` have the same values as their DIN names. `ISO7380-1` and `ISO7380-2` (with a flange) replaced the old `DIN 7380`, so the DIN names are accepted for both (`DIN7380` alone means the button head without the flange).
- Sizes outside a standard come from a manufacturer and are marked in the table: `DIN7380-1` M2.5, `DIN985` M2 and M2.5.
- `DIN7505` (chipboard screws, e.g. the universal Pozidriv wood screws) is withdrawn, and the screws follow the manufacturers' drawings; check your screws.

## Descriptors

- Bolts and screws: `"M<d>x<length>"`, e.g. `"M3x20"`, `"M2.5x10"` (case-insensitive, `"m3X20"` works too). The length is measured as the standard does: under the head, or the total length for countersunk heads (see the table).
- Nuts: a number (`3`), `"M3"`, or the descriptor of the bolt (`"M3x20"`): a nut for the bolt M3x20.

## Tolerances

The standards give most dimensions as a range. The tables keep `[min, nominal, max]`, and `$dn_tolerance` selects the value: `DN_TOLERANCE_MIN`, `DN_TOLERANCE_NOMINAL` or `DN_TOLERANCE_MAX`.

- Parts (`bolt`, `screw`, `nut`) and the `get_*` functions use the nominal values by default.
- Holes (`bolt_hole`, `screw_hole`, `nut_hole`) use the maxima by default: the hole fits the largest part the standard allows, and `clearance` only compensates the printing.
- Setting `$dn_tolerance` (globally or for one call) overrides both:

```openscad
$dn_tolerance = DN_TOLERANCE_NOMINAL;                                   // everything, holes too
bolt("M3x16", "DIN912", $dn_tolerance=DN_TOLERANCE_MAX);                // the largest bolt
```

Where the standard gives one value (e.g. the maximum head height of a countersunk head), that value is used for all three.

## Modules

```openscad
bolt(descriptor, standard, align, visual, zet)
bolt_hole(descriptor, standard, align, sh_off, hh_off, clearance, eps, zet, teardrop)
screw(descriptor, standard, align, visual, zet)
screw_hole(descriptor, standard, align, sh_off, hh_off, clearance, eps, zet, teardrop)
nut(d, standard, align, visual, zet)
nut_hole(d, standard, align, s_off, h_off, clearance, h_clearance, zet, teardrop)
```

| argument      | meaning                                                                                                                         |
|---------------|---------------------------------------------------------------------------------------------------------------------------------|
| `align`       | the point at z = 0: `DN_ALIGN_BOTTOM` (default), `DN_ALIGN_MIDDLE` or `DN_ALIGN_TOP`                                            |
| `zet`         | the axis, as in solidpp: `"z"` (default), `"x"` or `"y"`; the head points towards +`zet`                                        |
| `visual`      | details for pictures (the socket at the hex key size, the slot, the Pozidriv recess, the hole of a nut, the insert of `DIN985`) |
| `clearance`   | added on every side of the hole (default 0.1); for hex nuts it is measured across the flats                                     |
| `h_clearance` | the clearance of a nut hole along its axis (default `clearance`)                                                                |
| `sh_off`      | extends the hole of the shaft beyond its end                                                                                    |
| `hh_off`      | extends the hole of the head above it (to sink the head)                                                                        |
| `s_off`       | a side slot of the nut hole towards +x, to insert the nut from the side                                                         |
| `h_off`       | an access hole below the nut hole                                                                                               |
| `teardrop`    | holes printable without supports when horizontal in the printed part, see below                                                 |

The parts are illustrative: the heads and nuts follow the dimensions of their standard, with approximate details the standards do not fix (a dome on button heads, a rounded top edge on socket and cheese heads, the 30 deg chamfer on the corners of hex heads and nuts). The holes stay simple: a cylinder for the shaft and one for the head, a hexagon for hex heads, a cone for countersunk heads, and the shape of the nut for nut holes.

For bolts and screws, `DN_ALIGN_BOTTOM` puts the end of the shaft at z = 0, `DN_ALIGN_MIDDLE` the bottom of the head and `DN_ALIGN_TOP` the top of the head; for nuts, the bottom, the middle or the top of the nut.

### Teardrops

A hole that lies horizontally in the printed part sags at the top. `teardrop` gives the round parts of a bolt or screw hole (the shaft, a round head, a countersunk head) a teardrop cross-section with its tip upwards; a hex nut hole is turned so that a corner points upwards.

- `teardrop=true`: the tip points to +Z (the hole must be horizontal: `zet="x"` or `"y"`).
- `teardrop="Y"` (any face letter `x`, `X`, `y`, `Y`, `z`, `Z` across the hole): the tip points that way. Use it when the part is printed in another orientation than it is modelled, e.g. a vertical hole (`zet="z"`) of a part printed lying on its side.
- Hexagonal heads keep their shape; square nuts ignore it.

### Functions

`get_bolt_head_diameter(descriptor, standard, is_circumscribed)`, `get_bolt_head_height(descriptor, standard)`, `get_screw_head_diameter(...)`, `get_screw_head_height(...)`, `get_nut_diameter(d, standard, is_circumscribed)` and `get_nut_height(d, standard)` return the sizes with `$dn_tolerance` applied (undef for an unknown standard or size). `is_circumscribed=true` gives the diameter across the corners of a hexagon or a square, `false` the width across the flats. The height of a nut with an insert is its total height.

## Adding a standard

Each standard is one file in `bolts/`, `nuts/` or `screws/` with one record, e.g.:

```openscad
DN_DIN912 = dn_standard(
    name = "DIN912", kind = "bolt", shape = "socket", length = "shaft",
    aliases = ["ISO4762"],
    sizes = [
    //   d       dk (head diameter)        k (head height)        s (socket)  t (socket depth, min)
        [ 3.0, [[ 5.32,  5.50,  5.68],   [ 2.86,  3.00,  3.00],    2.5,        1.3]],
        ...
    ],
    source = ["https://..."]);
```

- `shape` decides the geometry and the columns of `sizes` (see `standards.scad`): bolts and screws `"socket"`, `"button"`, `"cheese"`, `"countersunk"` with `[dk, k, drive, depth]`, `"button-flange"` with `[dc, k, s, t, dk, c]`, `"hex"` with `[s, k]`, `"countersunk-z"` with `[dk, k, pz]`; nuts `"hex"` and `"square"` with `[s, m]`, `"hex-insert"` with `[s, h, m]`.
- A dimension is a number or `[min, nominal, max]`; an unknown detail (only for the drive columns) is `undef`.
- Include the file in `deez-nuts.scad` and add the record to the list in `bolts.scad`, `nuts.scad` or `screws.scad`; `tests/test_standards.scad` checks every record.

## Deprecated

The modules, functions and tables of the single standards (`DIN912_bolt`, `DIN934_nut_hole`, `DIN933_get_head_diameter`, `DIN912_DIC`, ...) still work and echo their replacement, e.g. `DIN912_bolt(descriptor, ...) -> use bolt(descriptor, "DIN912", ...)`. The standard `"LUXPZ"` is now `"DIN7505"`.

## Tests

- `tests/test_*.scad`: assert-based tests of the descriptors, the standards and the records; run e.g. `openscad -o /tmp/out.echo tests/test_standards.scad`, the last line must be `ECHO: "ALL TESTS PASSED"`.
- `tests/gallery_*.scad`: every standard in every size, and the holes cut into blocks; render them (F6) to check that every part is a valid manifold.
