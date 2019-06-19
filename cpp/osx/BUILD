package(default_visibility = ["//visibility:public"])

load(":osx_archs.bzl", "OSX_TOOLS_ARCHS", "OSX_TOOLS_CONSTRAINTS")
load(":cc_toolchain_config.bzl", "osx_cc_toolchain_config")

OSX_CC_TOOLCHAINS = [(
    cpu + "|compiler",
    ":cc-compiler-" + cpu,
) for cpu in OSX_TOOLS_ARCHS] + [(
    cpu,
    ":cc-compiler-" + cpu,
) for cpu in OSX_TOOLS_ARCHS] + [
    ("k8|compiler", ":cc-compiler-darwin_x86_64"),
    ("darwin|compiler", ":cc-compiler-darwin_x86_64"),
    ("k8", ":cc-compiler-darwin_x86_64"),
    ("darwin", ":cc-compiler-darwin_x86_64"),
]

# Ideally, all of the C++14 toolchains should be in one toolchain suite, but the apple_cc_toolchain
# rule attempts to run xcode commands when the BUILD file is evaluated if the toolchain is reachable
# from the dependency graph. To keep those targets out of the dependency graph, I added this
# toolchain suite. If possible, it should be removed, and we should just use the toolchain suite in
# //cpp. This setup forces OSX users to modify their .bazelrc file to specify this target as the
# crosstool_top.
cc_toolchain_suite(
    name = "c++14",
    toolchains = dict(OSX_CC_TOOLCHAINS),
)

# OSX toolchain from Bazel standard configuration with a few minor modifications.
[
    apple_cc_toolchain(
        name = "cc-compiler-" + arch,
        all_files = ":tools",
        ar_files = ":empty",
        as_files = ":empty",
        compiler_files = ":tools",
        dwp_files = ":empty",
        linker_files = ":tools",
        objcopy_files = ":empty",
        strip_files = ":tools",
        supports_param_files = 0,
        toolchain_config = ":" + (
            arch if arch != "armeabi-v7a" else "stub_armeabi-v7a"
        ),
        toolchain_identifier = (
            arch if arch != "armeabi-v7a" else "stub_armeabi-v7a"
        ),
    )
    for arch in OSX_TOOLS_ARCHS
]

[
    osx_cc_toolchain_config(
        name = (arch if arch != "armeabi-v7a" else "stub_armeabi-v7a"),
        compiler = "compiler",
        cpu = arch,
    )
    for arch in OSX_TOOLS_ARCHS
]

[
    toolchain(
        name = "cc-toolchain-" + arch,
        exec_compatible_with = [
            # These only execute on macOS.
            "@bazel_tools//platforms:osx",
            "@bazel_tools//platforms:x86_64",
        ],
        target_compatible_with = OSX_TOOLS_CONSTRAINTS[arch],
        toolchain = ":cc-compiler-" + arch,
        toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
    )
    for arch in OSX_TOOLS_ARCHS
]

filegroup(
    name = "tools",
    srcs = [
        ":cc_wrapper",
        ":libtool",
        ":make_hashed_objlist.py",
        ":wrapped_ar",
        ":wrapped_clang",
        ":wrapped_clang_pp",
        ":xcrunwrapper.sh",
    ],
)

filegroup(
    name = "cc_wrapper",
    srcs = ["cc_wrapper.sh"],
)

filegroup(name = "empty")
