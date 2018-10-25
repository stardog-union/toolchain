#!/bin/bash

declare -a clean_args

function get_args_from_file {
    local filename="$1"
    while read -r line
    do
	clean_args+=("-Wl,${line}")
    done < "${filename}"
}

function clean {
    local arg="$1"
    local -a file_args
    if [[ "$arg" =~ ^\-Wl\,@ ]]
    then
	get_args_from_file "${arg#'-Wl,@'}"
    else
	clean_args+=("$arg")
    fi
}

for arg in "$@"
do
    clean "$arg"
done

/opt/osxcross/target/bin/x86_64-apple-darwin15-clang++-libc++ "${clean_args[@]}"
exit $?
