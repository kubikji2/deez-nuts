// deez-nuts: bolts, nuts and screws by their standard and a descriptor such as "M3x20"
// include this file (it includes everything once, solidpp too):
//     include <deez-nuts/deez-nuts.scad>

// solidpp (once for the whole library; cubepp, cylinderpp, ... are available to the design too)
include <solidpp/solidpp.scad>

// constants, utilities and the records of the standards
include <constants.scad>
include <utils.scad>
include <standards.scad>

// the geometry shared by all standards
include <basic-bolt.scad>
include <basic-nut.scad>

// the standards (one record per file)
include <bolts/DIN84A-bolt.scad>
include <bolts/ISO1207-bolt.scad>
include <bolts/DIN933-bolt.scad>
include <bolts/ISO4017-bolt.scad>
include <bolts/DIN912-bolt.scad>
include <bolts/DIN7380-1-bolt.scad>
include <bolts/DIN7991-bolt.scad>
include <bolts/ISO10642-bolt.scad>
include <nuts/DIN934-nut.scad>
include <nuts/ISO4032-nut.scad>
include <nuts/DIN439-nut.scad>
include <nuts/ISO4035-nut.scad>
include <nuts/DIN985-nut.scad>
include <nuts/ISO10511-nut.scad>
include <nuts/DIN562-nut.scad>
include <screws/DIN7505-screw.scad>

// the modules and functions of each kind
include <bolts.scad>
include <nuts.scad>
include <screws.scad>

// all standards
DN_STANDARDS = concat(DN_BOLTS, DN_NUTS, DN_SCREWS);

// the constants of the common standards, and the deprecated names
include <aliases.scad>
include <deprecated.scad>
