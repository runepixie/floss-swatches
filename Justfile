
DISTRO_NAME := 'floss-swatch'

alias ver := version

@_default:
	just _term-wipe
	just --list


# Export all supported formats
@build file='floss-swatch-blank-14x14-14ct' args='':
	just _term-wipe
	# just _build_scad_to_csg_to_all "{{file}}" "{{args}}"
	# just _export "{{file}}" "{{args}}"
	just _export_all "{{file}}" "{{args}}"


# Build all formats from all SCAD files
build-all args='':
	#!/bin/sh
	just _term-wipe
	for file in *.scad; do
		base_name="$(basename "${file}" .scad)"
		# echo "${base_name}"
		just _export_all "${base_name}" "{{args}}"
	done

# Build CSG and STL formats from all SCAD files
build-all-stl args='':
	#!/bin/sh
	just _term-wipe
	for file in *.scad; do
		base_name="$(basename "${file}" .scad)"
		# echo "${base_name}"
		just build-stl "${base_name}" "{{args}}"
	done

# Export CSG and STL formats
@build-stl file='floss-swatch-blank-14x14-14ct' args='':
	echo "Building {{file}}.scad"
	printf "SCAD -> CSG"
	time openscad -o formats/{{file}}.csg {{args}} {{file}}.scad

	printf "\nCSG -> STL"
	time openscad -o formats/{{file}}.stl {{args}} formats/{{file}}.csg

@_export file args='.3mf':
	# printf "\nSCAD -> 3MF"
	# time openscad -o formats/{{file}}.3mf {{args}} floss-swatch-blank-14x14.scad
	# printf "\nSTL -> 3MF (exporter.scad)"
	# time openscad -o formats/{{file}}.3mf {{args}} exporter.scad
	# printf "\nSTL -> 3MF (empty.scad)"
	time openscad -D 'import("formats/{{file}}.stl")' -o formats/{{file}}{{args}} empty.scad
	# echo "\nSTL -> 3MF (var.scad)"
	# time openscad -D 'cli_imp="formats/{{file}}.stl"' -o formats/{{file}}.3mf {{args}} var.scad
	# time openscad -D 'cli_imp="floss-swatch-blank-14x14.stl"' -o formats/floss-swatch-blank-14x14.3mf var.scad

# SCAD -> 3MF
# real    1m23.493s
# user    1m22.250s
# sys     0m0.610s

# STL -> 3MF (exporter.scad)
# real    0m22.868s
# user    0m22.349s
# sys     0m0.151s

# Export All 3D Formats
@_export_all file args:
	just _term-wipe
	printf "SCAD -> CSG"
	time openscad -o formats/{{file}}.csg {{args}} {{file}}.scad

	printf "\nCSG -> STL"
	time openscad -o formats/{{file}}.stl {{args}} formats/{{file}}.csg

	printf "\nSTL -> 3MF (empty.scad)"
	# time openscad -D 'import("formats/{{file}}.stl")' -o formats/{{file}}.3mf {{args}} empty.scad
	just _export "{{file}}" ".3mf {{args}}"

	printf "\nCSG -> AMF"
	time openscad -o formats/{{file}}.amf {{args}} formats/{{file}}.csg

	printf "\nSTL -> AMF (empty.scad)"
	just _export "{{file}}" ".amf {{args}}"
	printf "\nAMF -> Zipped AMF\n"
	time zip -9 formats/{{file}}.zip.amf formats/{{file}}.amf

	printf "\nCSG -> AST"
	time openscad -o formats/{{file}}.ast {{args}} formats/{{file}}.csg

	printf "\nSTL -> AST (empty.scad)"
	just _export "{{file}}" ".ast {{args}}"

	printf "\nCSG -> NEF3"
	time openscad -o formats/{{file}}.nef3 {{args}} formats/{{file}}.csg

	printf "\nSTL -> NEF3 (empty.scad)"
	just _export "{{file}}" ".nef3 {{args}}"

	printf "\nCSG -> NEFDBG"
	time openscad -o formats/{{file}}.nefdbg {{args}} formats/{{file}}.csg

	printf "\nSTL -> NEFDBG (empty.scad)"
	just _export "{{file}}" ".nefdbg {{args}}"

	printf "\nCSG -> OFF"
	time openscad -o formats/{{file}}.off {{args}} formats/{{file}}.csg

	printf "\nSTL -> OFF (empty.scad)"
	just _export "{{file}}" ".off {{args}}"

	printf "\nOFF -> 3MF (empty.scad)"
	time openscad -D 'import("formats/{{file}}.off")' -o formats/{{file}}.3mf empty.scad

	printf "\nAMF -> 3MF (empty.scad)"
	time openscad -D 'import("formats/{{file}}.amf")' -o formats/{{file}}.3mf empty.scad


# Roughly 11 minutes
_build_scad_to_csg_to_all file args:
	just _term-wipe
	echo "SCAD -> CSG"
	time openscad -o formats/{{file}}.csg {{args}} {{file}}.scad

	echo "CSG -> 3MF"
	time openscad -o formats/{{file}}.3mf {{args}} formats/{{file}}.csg
	echo "CSG -> AMF"
	time openscad -o formats/{{file}}.amf {{args}} formats/{{file}}.csg
	echo "AMF -> Zipped AMF"
	time zip -9 formats/{{file}}.zip.amf formats/{{file}}.amf
	echo "CSG -> AST"
	openscad -o formats/{{file}}.ast {{args}} formats/{{file}}.csg
	@# openscad -o formats/{{file}}.dxf {{args}} formats/{{file}}.csg
	@# openscad -o formats/{{file}}.echo {{args}} formats/{{file}}.csg
	@# openscad -o formats/{{file}}.nef3 {{args}} formats/{{file}}.csg
	@# openscad -o formats/{{file}}.nefdbg {{args}} formats/{{file}}.csg
	echo "CSG -> OFF"
	time openscad -o formats/{{file}}.off {{args}} formats/{{file}}.csg
	
	@# openscad -o formats/{{file}}.svg {{args}} formats/{{file}}.csg
	@# openscad -o formats/{{file}}.term {{args}} formats/{{file}}.csg

# Roughly 22 minutes
_build_scad_to_all file args:
	just _term-wipe
	echo "SCAD -> 3MF"
	time openscad -o formats/{{file}}.3mf {{args}} {{file}}.scad
	echo "SCAD -> AMF"
	time openscad -o formats/{{file}}.amf {{args}} {{file}}.scad
	echo "SCAD -> Zipped AMF"
	time zip -9 formats/{{file}}.zip.amf {{file}}.amf
	echo "SCAD -> AST"
	openscad -o formats/{{file}}.ast {{args}} {{file}}.scad
	echo "SCAD -> CSG"
	time openscad -o formats/{{file}}.csg {{args}} {{file}}.scad
	# openscad -o formats/{{file}}.dxf {{args}} {{file}}.scad
	# openscad -o formats/{{file}}.echo {{args}} {{file}}.scad
	# openscad -o formats/{{file}}.nef3 {{args}} {{file}}.scad
	# openscad -o formats/{{file}}.nefdbg {{args}} {{file}}.scad
	echo "SCAD -> OFF"
	time openscad -o formats/{{file}}.off {{args}} {{file}}.scad
	echo "SCAD -> STL"
	time openscad -o formats/{{file}}.stl {{args}} {{file}}.scad
	# openscad -o formats/{{file}}.svg {{args}} {{file}}.scad
	# openscad -o formats/{{file}}.term {{args}} {{file}}.scad

	# openscad -o formats/{{file}}.3mf -o {{file}}.amf -o {{file}}.csg -o {{file}}.off -o {{file}}.stl {{args}} {{file}}.scad


# Build Distro
distro:
	#!/bin/sh
	just _term-wipe
	distro_ver=`just version`
	# distro_path="distro/thingiverse/{{DISTRO_NAME}}-v${distro_ver}"
	# distro_files="${distro_path}/files"
	# distro_images="${distro_path}/images"
	# mkdir -p "${distro_files}"
	# mkdir -p "${distro_images}"
	# cp formats/*.{3ds,ai,amf,blend,brd,cdr,dae,doc,docx,dxf,eps,epsi,gif,jpg,obj,pdf,ply,png,ps,scad,sch,stl,svg,thing,txt,x3d} "${distro_files}/"
	# cp images/*.png "${distro_images}/"
	# cp README.md "${distro_path}/README.txt"
	# cp version "${distro_path}/version.txt"

	# just _distro_build "${distro_path}" "3ds ai amf blend brd cdr dae doc docx dxf eps epsi gif jpg obj pdf ply png ps scad sch stl svg thing txt x3d" ".txt" ".txt"
	just _distro_build_thingiverse "${distro_ver}"

_distro_build_thingiverse distro_ver:
	#!/bin/sh
	distro_path="distro/thingiverse/{{DISTRO_NAME}}-v{{distro_ver}}"
	formats="3ds ai amf blend brd cdr dae doc docx dxf eps epsi gif jpg obj pdf ply png ps scad sch stl svg thing txt x3d"

	# echo "Deleting distro/thingiverse"
	# rm -rf "distro/thingiverse"

	distro_files="${distro_path}/files"
	distro_images="${distro_path}/images"
	mkdir -p "${distro_files}"
	mkdir -p "${distro_images}"

	for ext in ${formats}; do
		cp *.${ext} "${distro_files}/" 2>/dev/null
		if [ $? -eq 0 ]; then
			echo "Copying *.${ext} -> ${distro_files}"
		fi
	done
	for ext in ${formats}; do
		cp formats/*.${ext} "${distro_files}/" 2>/dev/null
		if [ $? -eq 0 ]; then
			echo "Copying formats/*.${ext} -> ${distro_files}"
		fi
	done

	echo "Copying images/*.{jpg,png} -> ${distro_images}/"
	cp images/*.{jpg,png} "${distro_images}/"
	cp README.md "${distro_path}/README.txt"
	cp version "${distro_path}/version.txt"
	just _dirzip "${distro_path}"


_dirzip path:
	#!/bin/sh
	base_name="$(basename "{{path}}")"
	base_path="$(dirname "{{path}}")"
	if [ ${#base_path} -eq 0 ]; then
		base_path=.
	fi
	echo "DirZip: {{path}}"
	# echo "  dirzip path: {{path}}"
	# echo "    base_name: '${base_name}'"
	# echo "    base_path: '${base_path}'"
	cd "${base_path}"
	ditto -ck --keepParent --zlibCompressionLevel 9 --norsrc --noqtn --nohfsCompression "${base_name}" "${base_name}.zip"


# Save out PNG image
@image file='floss-swatch-blank-14x14-14ct' args='--imgsize 2048,1536 --autocenter':
	just _term-wipe
	mkdir images
	# --viewall
	# BeforeDawn
	# Cornfield
	# DeepOcean
	# Metallic
	# Monotone
	# Nature
	# Solarized
	# Starnight
	# Sunset
	# Tomorrow
	# Tomorrow 2 (not available?)
	# Tomorrow Night

	# openscad -o {{file}}.png {{args}} {{file}}.scad # Same as specifying Cornfield
	# openscad -o {{file}}-BeforeDawn.png {{args}} --colorscheme BeforeDawn {{file}}.scad
	# openscad -o {{file}}-Cornfield.png {{args}} --colorscheme Cornfield {{file}}.scad # default
	# openscad -o {{file}}-DeepOcean.png {{args}} --colorscheme DeepOcean {{file}}.scad
	# openscad -o {{file}}-Metallic.png {{args}} --colorscheme Metallic {{file}}.scad
	# openscad -o {{file}}-Monotone.png {{args}} --colorscheme Monotone {{file}}.scad
	# openscad -o {{file}}-Nature.png {{args}} --colorscheme Nature {{file}}.scad
	# openscad -o {{file}}-Solarized.png {{args}} --colorscheme Solarized {{file}}.scad
	# openscad -o {{file}}-Starnight.png {{args}} --colorscheme Starnight {{file}}.scad
	# openscad -o {{file}}-Sunset.png {{args}}-Sunset --colorscheme Sunset {{file}}.scad # Pretty but broken formating
	# openscad -o {{file}}-Tomorrow.png {{args}} --colorscheme Tomorrow {{file}}.scad
	# # openscad -o "{{file}}-Tomorrow 2.png" {{args}} --colorscheme "Tomorrow 2" {{file}}.scad # Not available?
	# openscad -o "{{file}}-Tomorrow Night.png" {{args}} --colorscheme "Tomorrow Night" {{file}}.scad

	openscad -o "images/{{file}}.png" {{args}} --colorscheme "Tomorrow Night" {{file}}.scad
	# oxipng --strip all -Z --out "images/{{file}}.oxi-z.png" "images/{{file}}.png"
	# oxipng --strip all --out "images/{{file}}.oxi.png" "images/{{file}}.png"
	oxipng --strip all "images/{{file}}.png"


# Terminal Buffer Wiper
_term-wipe:
	#!/bin/sh
	if [[ ${#VISUAL_STUDIO_CODE} -gt 0 ]]; then
		clear
	elif [[ ${KITTY_WINDOW_ID} -gt 0 ]] || [[ ${#TMUX} -gt 0 ]] || [[ "${TERM_PROGRAM}" = 'vscode' ]]; then
		printf '\033c'
	elif [[ "$(uname)" == 'Darwin' ]] || [[ "${TERM_PROGRAM}" = 'Apple_Terminal' ]] || [[ "${TERM_PROGRAM}" = 'iTerm.app' ]]; then
		osascript -e 'tell application "System Events" to keystroke "k" using command down'
	elif [[ -x "$(which tput)" ]]; then
		tput reset
	elif [[ -x "$(which reset)" ]]; then
		reset
	else
		clear
	fi


# Release Version
version:
	#!/bin/sh
	if [ '{{os()}}' == 'windows' ]; then
		TYPE version
	else
		cat version
	fi

