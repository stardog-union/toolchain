package(default_visibility = ["//visibility:public"])
load(":toolchain_config.bzl", "windows_cc_toolchain_config")

WINDOWS_CC_TOOLCHAINS = [
    ("x64_windows", ":c++14-windows-x86_64-local-vs")
]

cc_toolchain_suite(
    name = "c++14",
    toolchains = dict(WINDOWS_CC_TOOLCHAINS),
)

# General Windows toolchain.
cc_toolchain(
    name = "c++14-windows-x86_64-local-vs",
    toolchain_identifier = "c++14-windows-x86_64-local-vs",
    toolchain_config = ":c++14-windows-x86_64-local-vs-config",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
)

toolchain(
    name = "c++14-windows-x86_64-local-vs-toolchain",
    exec_compatible_with = [
        "@bazel_tools//platforms:x86_64",
        "@bazel_tools//platforms:windows",
    ],
    target_compatible_with = [
        "@bazel_tools//platforms:x86_64",
        "@bazel_tools//platforms:windows",
    ],
    toolchain = ":c++14-windows-x86_64-local-vs",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

windows_cc_toolchain_config(
    name = "c++14-windows-x86_64-local-vs-config",
    cpu = "x64_windows",
    compiler = "msvc-cl",
    # cc_dialect = "c++14",
)

filegroup(name = "empty")

cc_library(
    name = "malloc",
)
