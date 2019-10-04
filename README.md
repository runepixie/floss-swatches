Floss Swatches
==============

This project contains source files for 3D printed swatches for making floss color samples for use with cross-stitch and embroidery.

### Contents

* `distro.sh` -- This is a Bash script to auto-generate STL files based on the contents of `distro/dmc-swatches/id-list.txt` and potentially other ID lists as well.
* `distro/dmc-swatches/id-list.txt` -- The file in `distro/dmc-swatches` directory contains the full D.M.C. floss color ID list (at the time of this writing) grouped by product line and the line's subgroups if any.
* `floss-swatch-blank-10x10-10ct.scad` -- This the OpenSCAD source file for a swatch with a blank label area for you to put your own (sticky?) labels in based on a 10&times;10 grid at 10 stitches per inch. These swatches should fit in most floss holder sized containers.
* `floss-swatch-blank-14x14-10ct.scad` -- This is another OpenSCAD source file for blank label swatch based on the more popular 14&times;14 grid but at 10 stitches per inch. These swatches will not fit in most floss holder sized containers.
* `floss-swatch-blank-14x14-14ct.scad` -- This should probably be forgotten. Needs to be tested on higher resolution 3D printer than 100 microns. Holes currently only usable by brownies, Finders, and possibly exceptionally talented house elves.
* `floss-swatch-blank-no-grid-1in.scad` -- This is a source file like the others above but has no grid. For the abstractionists and minimalists among you. Actually a <abbr title="work in progress">WIP</abbr> intended to be the start of a system to frame actual cloth.
* `floss-swatch-template-10x10-10ct.scad` -- This is the OpenSCAD file used as a template for generating the STL files with the IDs from `distro/dmc-swatches/id-list.txt`.
* `Justfile` -- The automation file I use for testing and remembering how I did something. :angel:
* `lib.scad` -- This is an OpenSCAD library I created for sharing common code between the different source files above.
* `README.md` -- This file. :smiley:

**NOTE:** All swatches have a hole for usage with a metal ring, hooks, etc.

### Justfile

This is my (RuneImp's) choice over using `make` to facilitate automation and creating distributions. I use [just][] which is such a great command runner in the style of make! But without the many issues associated with using one of the many, many different versions of make. I can barely express the love I have for such tools. I highly recommend it!




[just]: https://github.com/casey/just


