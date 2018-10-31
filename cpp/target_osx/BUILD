package(default_visibility = ["//visibility:public"])

EXEC_ARCHS = [
    "k8",
]

CC_TOOLCHAINS = [(
    cpu + "|compiler",
    ":cc-compiler-" + cpu,
) for cpu in EXEC_ARCHS]

cc_toolchain_suite(
    name = "toolchain",
    toolchains = dict(CC_TOOLCHAINS),
)

alias(
    name = "target_osx",
    actual = ":toolchain",
)

[
    cc_toolchain(
        name = "cc-compiler-" + cpu,
        all_files = ":compiler_deps",
        compiler_files = ":compiler_deps",
        cpu = cpu,
        dwp_files = ":empty",
        dynamic_runtime_libs = [":empty"],
        linker_files = ":compiler_deps",
        objcopy_files = ":empty",
        static_runtime_libs = [":empty"],
        strip_files = ":empty",
        supports_param_files = 0,
    )
    for cpu in EXEC_ARCHS
]

[
    toolchain(
        name = "cc-toolchain-" + cpu,
        exec_compatible_with = [
            "@bazel_tools//platforms:linux",
        ],
        target_compatible_with = [
            "@bazel_tools//platforms:osx",
        ],
        toolchain = ":cc-compiler-" + cpu,
        toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
    )
    for cpu in EXEC_ARCHS
]

filegroup(
    name = "compiler_deps",
    srcs = [":wrappers"] + [":empty"],
)

filegroup(
    name = "empty",
    srcs = [],
)

filegroup(
    name = "wrappers",
    srcs = [
        "ar_wrapper.sh",
        "cc_wrapper.sh",
    ],
)

# Misc required rules.
cc_library(
    name = "malloc",
)

cc_library(
    name = "stl",
)
