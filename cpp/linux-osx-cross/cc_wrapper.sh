#!/usr/bin/env bash

declare -a original_args
declare -a final_args

declare building_shared_library=0

disallowed_args=(-Wl,--gc-sections -Wl,-no-as-needed -static-libgcc -Wl,-z,relro,-z,now -whole-archive -no-whole-archive)

function preprocess {
    local arg="$1"
    local -a file_args
    if [[ "$arg" =~ ^@(.*) || "$arg" =~ ^-Wl,@(.*) ]]
    then
	get_args_from_file "${BASH_REMATCH[1]}"
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

function is_allowed {
    local arg="$1"
    for disallowed in "${disallowed_args[@]}"
    do
	if [ "$arg" == "$disallowed" ]
	then
	    false
	    return
	fi
    done

    true
}

function interpret_arg {
    local arg="$1"
    if [[ "$arg" =~ ^-shared$ ]]
    then
	building_shared_library=1
    fi

    if is_allowed "$arg"
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

    for arg in "${original_args[@]}"
    do
	if is_allowed "$arg"
	then
	    final_args+=("$arg")
	fi
    done
}

for arg in "$@"
do
    preprocess "$arg"
done

munge_args

echo "Result: /opt/osxcross/target/bin/x86_64-apple-darwin15-clang++-libc++ ${final_args[@]}"
/opt/osxcross/target/bin/x86_64-apple-darwin15-clang++-libc++ "${final_args[@]}"
exit $?
