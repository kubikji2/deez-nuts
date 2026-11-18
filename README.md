# Deez Nutz - bolts, nuts, screws and threads OpenSCAD repository

Bolts, nuts and screws, and the holes for them, from the name of their standard and a descriptor such as `"M3x20"`, the way you would say it. Built on solidpp (a git submodule in `solidpp/`).

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

## Standards

| kind  | standard    | ISO name    | constant               | the length in the descriptor |
|-------|-------------|-------------|------------------------|------------------------------|
| bolt  | `DIN84A`    | `ISO1207`   | `DN_BOLT_SLOTTED_HEAD` | shaft                        |
| bolt  | `DIN933`    | `ISO4017`   | `DN_BOLT_HEX_HEAD`     | shaft                        |
| bolt  | `DIN912`    | `ISO4762`   | `DN_BOLT_SOCKET_HEAD`  | shaft                        |
| bolt  | `DIN7380-1` | `ISO7380-1` | `DN_BOLT_BUTTON_HEAD`  | shaft                        |
| bolt  | `DIN7991`   | `ISO10642`  | `DN_BOLT_COUNTERSINK`  | total (with the head)        |
| screw | `LUXPZ`     | -           | `DN_SCREW_POZIDRIV`    | total (with the head)        |
| nut   | `DIN934`    | `ISO4032`   | `DN_NUT_REGULAR`       | -                            |
| nut   | `DIN439`    | `ISO4035`   | `DN_NUT_THIN`          | -                            |
| nut   | `DIN985`    | `ISO10511`  | `DN_NUT_NYLOCK`        | -                            |
| nut   | `DIN562`    | -           | `DN_NUT_SQUARE`        | -                            |

- The names are case-insensitive, and spaces, dashes, dots and underscores are ignored: `"ISO 4762"`, `"iso4762"` and `"DIN-912"` all work.
- The ISO names use the DIN tables for now. Where the standards differ (e.g. the width across the flats of M10 and M12 hex heads and nuts), the ISO standards will get their own tables.
- The tables are being reworked to follow the standards for M2–M12; until then, check the sizes you use.

## Descriptors

- Bolts and screws: `"M<d>x<length>"`, e.g. `"M3x20"`, `"M2.5x10"` (case-insensitive, `"m3X20"` works too).
- Nuts: a number (`3`), `"M3"`, or the descriptor of the bolt (`"M3x20"`): a nut for the bolt M3x20.

## Modules

```openscad
bolt(descriptor, standard, align, visual, zet)
bolt_hole(descriptor, standard, align, sh_off, hh_off, clearance, eps, zet)
screw(descriptor, standard, align, visual, zet)
screw_hole(descriptor, standard, align, sh_off, hh_off, clearance, eps, zet)
nut(d, standard, align, visual, zet)
nut_hole(d, standard, align, s_off, h_off, clearance, h_clearance, zet)
```

| argument      | meaning                                                                                          |
|---------------|--------------------------------------------------------------------------------------------------|
| `align`       | the point at z = 0: `DN_ALIGN_BOTTOM` (default), `DN_ALIGN_MIDDLE` or `DN_ALIGN_TOP` (see below) |
| `zet`         | the axis, as in solidpp: `"z"` (default), `"x"` or `"y"`; the head points towards +`zet`         |
| `visual`      | details for pictures (the socket of `DIN912`, the hole of a nut, the nylon ring of `DIN985`)     |
| `clearance`   | added on every side of the hole (default 0.1); for hex nuts it is measured across the flats      |
| `h_clearance` | the clearance of a nut hole along its axis (default `clearance`)                                 |
| `sh_off`      | extends the hole of the shaft beyond its end                                                     |
| `hh_off`      | extends the hole of the head above it (to sink the head)                                         |
| `s_off`       | a side slot of the nut hole towards +x, to insert the nut from the side                          |
| `h_off`       | an access hole below the nut hole                                                                |

For bolts and screws, `DN_ALIGN_BOTTOM` puts the end of the shaft at z = 0, `DN_ALIGN_MIDDLE` the bottom of the head and `DN_ALIGN_TOP` the top of the head; for nuts, the bottom, the middle or the top of the nut.

The functions `get_bolt_head_diameter(descriptor, standard, is_circumscribed)`, `get_bolt_head_height(descriptor, standard)`, `get_screw_head_diameter(...)`, `get_screw_head_height(...)`, `get_nut_diameter(d, standard, is_circumscribed)` and `get_nut_height(d, standard)` return the sizes (undef for an unknown standard or size). `is_circumscribed=true` gives the diameter across the corners of a hexagon or a square, `false` the width across the flats.

## Tests

- `tests/test_*.scad`: assert-based tests of the descriptors, the standards and the tables; run e.g. `openscad -o /tmp/out.echo tests/test_utils.scad`, the last line must be `ECHO: "ALL TESTS PASSED"`.
- `tests/gallery_*.scad`: every standard in every size, and the holes cut into blocks; render them (F6) to check that every part is a valid manifold.
