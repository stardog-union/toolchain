#!/bin/bash

declare -a original_args
declare -a final_args

declare building_shared_library=0

function preprocess {
    local arg="$1"
    local -a file_args
    if [[ "$arg" =~ ^@ ]]
    then
	get_args_from_file "${arg#'@'}"
    else
	interpret_arg "${arg}"
    fi
}

function get_args_from_file {
    local filename="$1"
    while read -r line
    do
	interpret_arg "${line}"
    done < "${filename}"
}

function interpret_arg {
    local arg="$1"
    if [[ "$arg" =~ ^-shared$ ]]
    then
	building_shared_library=1
    fi

    # ld doesn't support --gc-sections.
    if [[ ! "$arg" =~ ^-Wl,--gc-sections$ ]]
    then
	original_args+=("$arg")
    fi
}

function munge_args {
    if [[ $building_shared_library = 1 ]]
    then
	final_args+=("-Wl,-undefined")
	final_args+=("-Wl,dynamic_lookup")
    fi
    final_args+=("${original_args[@]}")
}

for arg in "$@"
do
    preprocess "$arg"
done

munge_args

echo "Result: /opt/osxcross/target/bin/x86_64-apple-darwin15-clang++-libc++ ${final_args[@]}"
/opt/osxcross/target/bin/x86_64-apple-darwin15-clang++-libc++ "${final_args[@]}"
exit $?
