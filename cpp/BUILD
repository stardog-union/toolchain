package(default_visibility = ["//visibility:public"])

cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "k8|linux-x86_64-clang-linux": ":cc-compiler-linux-x86_64-local",
        "k8": ":cc-compiler-linux-x86_64-local",
        "darwin|osx-x86_64-clang-osx": ":cc-compiler-osx-x86_64-local",
        # TODO(james): One of these is correct. Remove the other.
        "k8|osx-x86_64-clang-linux": ":cc-compiler-osx-x86_64-linux",
        "darwin|osx-x86_64-clang-linux": ":cc-compiler-osx-x86_64-linux",
    },
)

alias(
    name = "cpp",
    actual = ":toolchain",
)

cc_toolchain(
    name = "cc-compiler-linux-x86_64-local",
    all_files = ":compiler_deps",
    compiler_files = ":compiler_deps",
    cpu = "k8",
    dwp_files = ":empty",
    dynamic_runtime_libs = [":empty"],
    linker_files = ":compiler_deps",
    objcopy_files = ":empty",
    static_runtime_libs = [":empty"],
    strip_files = ":empty",
    supports_param_files = 1,
    toolchain_identifier = "linux-x86_64-clang-local"
)

toolchain(
    name = "cc-toolchain-linux-x86_64-local",
    exec_compatible_with = [
        "@bazel_tools//platforms:linux",
    ],
    target_compatible_with = [
        "//:linux-x86_64",
    ],
    toolchain = ":cc-compiler-linux-x86_64-local",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

apple_cc_toolchain(
    name = "cc-compiler-osx-x86_64-local",
    all_files = ":tools-osx-x86_64-local",
    compiler_files = ":tools-osx-x86_64-local",
    cpu = "darwin_x86_64",
    dwp_files = ":empty",
    dynamic_runtime_libs = [":empty"],
    linker_files = ":tools-osx-x86_64-local",
    objcopy_files = ":empty",
    static_runtime_libs = [":empty"],
    strip_files = ":tools-osx-x86_64-local",
    supports_param_files = 0,
    toolchain_identifier = "osx-x86_64-clang-local"
)

toolchain(
    name = "cc-toolchain-osx-x86_64-local",
    exec_compatible_with = [
        "@bazel_tools//platforms:osx",
    ],
    target_compatible_with = [
        "//:osx-x86_64",
    ],
    toolchain = ":cc-compiler-osx-x86_64-local",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

filegroup(
    name = "tools-osx-x86_64-local",
    srcs = [
        ":cc_wrapper",
        ":libtool",
        ":make_hashed_objlist.py",
        ":wrapped_clang",
        ":wrapped_clang_pp",
        ":wrapped_ar",
        ":xcrunwrapper.sh",
    ],
)

filegroup(
    name = "cc_wrapper",
    srcs = ["cc_wrapper.sh"],
)

# Cross-compile from Linux to OSX.
cc_toolchain(
    name = "cc-compiler-osx-x86_64-linux",
    all_files = ":linux_to_osx_compiler_deps",
    compiler_files = ":linux_to_osx_compiler_deps",
    cpu = "k8",
    dwp_files = ":empty",
    dynamic_runtime_libs = [":empty"],
    linker_files = ":linux_to_osx_compiler_deps",
    objcopy_files = ":empty",
    static_runtime_libs = [":empty"],
    strip_files = ":empty",
    supports_param_files = 0,
    toolchain_identifier = "osx-x86_64-clang-linux"
)

toolchain(
    name = "cc-toolchain-target-osx-x86_64-linux",
    exec_compatible_with = [
        "@bazel_tools//platforms:linux",
    ],
    target_compatible_with = [
        "//:osx-x86_64",
    ],
    toolchain = ":cc-compiler-osx-x86_64-linux",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

filegroup(
    name = "linux_to_osx_compiler_deps",
    srcs = [
        "linux_to_osx_ar_wrapper.sh",
        "linux_to_osx_cc_wrapper.sh",
    ] + [":empty"],
)

# General utilities.
# TODO(james): Determine which of these are really needed.
cc_library(
    name = "malloc",
)

cc_library(
    name = "stl",
)

filegroup(
    name = "compiler_deps",
    srcs = glob(["extra_tools/**"]) + [":empty"],
)

filegroup(
    name = "empty",
    srcs = [],
)
