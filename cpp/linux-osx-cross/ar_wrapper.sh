#!/usr/bin/env bash

declare -a original_args
declare -a final_ar_args
declare -a final_ranlib_args

declare want_ranlib=0
declare archive_name=""
declare next_is_archive_name=0

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
    if [[ "$arg" =~ ^-s$ ]]
    then
	want_ranlib=1
    else
	if (( $next_is_archive_name ))
	then
	    archive_name="$arg"
	fi

	if [[ "$arg" =~ ^-o$ ]]
	then
	    next_is_archive_name=1
	else
	    next_is_archive_name=0
	fi

	original_args+=("$arg")
    fi
}

function munge_ar_args {
    local arg
    final_ar_args+=("rcs")
    for arg in "${original_args[@]}"
    do
	if [[ ! "$arg" =~ ^-static$ && ! "$arg" =~ ^-o$ && "$arg" != "rcsD" ]]
	then
	    final_ar_args+=("$arg")
	fi
    done
}

for arg in "$@"
do
    preprocess "$arg"
done

munge_ar_args

echo "Result: /opt/osxcross/target/bin/x86_64-apple-darwin15-ar ${final_ar_args[@]}"
/opt/osxcross/target/bin/x86_64-apple-darwin15-ar "${final_ar_args[@]}"

if [[ "$want_ranlib" = 1 ]]
then
    echo "Result: /opt/osxcross/target/bin/x86_64-apple-darwin15-ranlib ${archive_name}"
    /opt/osxcross/target/bin/x86_64-apple-darwin15-ranlib "${archive_name}"
fi

exit $?
