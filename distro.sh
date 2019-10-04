#!/usr/bin/env bash

declare PATH_RE='distro\/([^/]+)\/id-list.txt'
declare starting_path="$PWD"

create_distro()
{
	# ARGUMENTS
	local list_file="$1"
	local list_name="$2"
	local base_path="$3"

	# echo "create_distro() | \$starting_path = $starting_path"

	# echo "create_distro() | \$base_path = $base_path"
	# echo "create_distro() | \$list_name = $list_name"
	echo "create_distro() | \$list_name = $list_name"
	echo

	# MAIN LOOP
	cd "$base_path"
	for path in $(/bin/ls -d *); do
		# echo "create_distro() | \$path = $path"
		echo "dirzip $path"
		dirzip "$path"
	done
	cd "$starting_path"
}

generate_stl_files()
{
	# ARGUMENTS
	local list_file="$1"
	local list_name="$2"
	local base_path="$3"

	# VARIABLES
	local -i i=0
	local LABEL_ID
	local path
	local src
	local subgroup
	local thread_line
	local trg

	# MAIN LOOP
	while IFS="" read -r LABEL_ID || [ -n "$LABEL_ID" ]
	do
		if [[ "${LABEL_ID:0:2}" == '--' ]]; then
			thread_line=$(echo "${LABEL_ID}" | tr -d "-" | tr [A-Z] [a-z] | tr ' ' '_')
			subgroup=""
		elif [[ "${LABEL_ID:0:1}" == '-' ]]; then
			# subgroup="${LABEL_ID:1}"
			subgroup=$(echo "${LABEL_ID}" | tr -d "-" | tr [A-Z] [a-z] | tr ' ' '_')
		fi
		if [[ "${LABEL_ID:0:1}" != '-' ]] && [[ ${#LABEL_ID} -gt 1 ]]; then
			stl="floss-swatch-10x10-10ct-${LABEL_ID}.stl"
			src="distro/${list_name}/${list_name}-all/$stl"
			echo "Creating $src"
			let "i += 1"

			openscad -D 'label_id="'${LABEL_ID}'"' -o "$src" floss-swatch-template-10x10-10ct.scad 2>/dev/null

			if [[ ${#subgroup} -gt 0 ]]; then
				trg="${list_name}-${thread_line}-${subgroup}"
			else
				trg="${list_name}-${thread_line}"
			fi
			path="distro/${list_name}/$trg"
			trg="${path}/$stl"
			mkdir -p "$path"
			echo "cp $src $trg"
			cp "$src" "$trg"
		fi
	done < "$list_file"
	echo "Count $i"
}

#
# MAIN LOOP
#
for list_file in $(/bin/ls -d distro/*/id-list.txt); do
	echo "MAIN LOOP | \$list_file = $list_file"
	if [[ "$list_file" =~ $PATH_RE ]]; then
		# echo "\${BASH_REMATCH[@]} = ${BASH_REMATCH[@]}"
		# echo "\${BASH_REMATCH[1]} = ${BASH_REMATCH[1]}"

		base_path="distro/${BASH_REMATCH[1]}"
		list_name="${BASH_REMATCH[1]}"
		echo "MAIN LOOP | \$base_path = $base_path"
		echo "MAIN LOOP | \$list_name = $list_name"

		generate_stl_files "$list_file" "$list_name" "$base_path"
		create_distro "$list_file" "$list_name" "$base_path"
	fi
done

#
# Generate STL Files
#
# while IFS="" read -r LABEL_ID || [ -n "$LABEL_ID" ]
# do
# 	if [[ "${LABEL_ID:0:2}" == '--' ]]; then
# 		thread_line=$(echo "${LABEL_ID}" | tr -d "-" | tr [A-Z] [a-z] | tr ' ' '_')
# 		subgroup=""
# 	elif [[ "${LABEL_ID:0:1}" == '-' ]]; then
# 		# subgroup="${LABEL_ID:1}"
# 		subgroup=$(echo "${LABEL_ID}" | tr -d "-" | tr [A-Z] [a-z] | tr ' ' '_')
# 	fi
# 	if [[ "${LABEL_ID:0:1}" != '-' ]] && [[ ${#LABEL_ID} -gt 1 ]]; then
# 		stl="floss-swatch-10x10-10ct-${LABEL_ID}.stl"
# 		src="distro/dmc-swatches/all/$stl"
# 		echo "Creating $src"
# 		let "i += 1"

# 		# openscad -D 'label_id="'${LABEL_ID}'"' -o "$src" floss-swatch-template-10x10-10ct.scad 2>/dev/null

# 		if [[ ${#subgroup} -gt 0 ]]; then
# 			trg="${thread_line}-${subgroup}"
# 		else
# 			trg="${thread_line}"
# 		fi
# 		# distro/dmc-swatches/all
# 		path="distro/dmc-swatches/$trg"
# 		trg="${path}/$stl"
# 		mkdir -p "$path"
# 		echo "cp $src $trg"
# 		cp "$src" "$trg"
# 	fi
# done < dmc-color-list.txt
# echo "Count $i"

#
# Create Distributions
#
# for path in $(/bin/ls -d formats/*/); do
# 	# echo "$path"
# 	dir_name="$(basename "$path")"
# 	echo "dirzip formats/$dir_name"
# 	cd formats
# 	dirzip "$dir_name"
# 	cd ..
# done

