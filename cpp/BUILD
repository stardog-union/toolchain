package(default_visibility = ["//visibility:public"])

load(":linux_archs.bzl", "LINUX_TOOLS_ARCHS")
load(":osx_archs.bzl", "OSX_TOOLS_ARCHS")

CC_TOOLCHAINS = [(
    cpu + "|compiler",
    ":cc-compiler-" + cpu,
) for cpu in LINUX_TOOLS_ARCHS + OSX_TOOLS_ARCHS]

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

filegroup(
    name = "cc_wrapper",
    srcs = ["cc_wrapper.sh"],
)

cc_toolchain_suite(
    name = "toolchain",
    toolchains = dict(CC_TOOLCHAINS),
)

[
    filegroup(
        name = "osx_tools_" + arch,
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
    for arch in OSX_TOOLS_ARCHS
]

[
    cc_toolchain(
        name = "cc-compiler-" + arch,
        all_files = ":compiler_deps",
        compiler_files = ":compiler_deps",
        cpu = arch,
        dwp_files = ":empty",
        dynamic_runtime_libs = [":empty"],
        linker_files = ":compiler_deps",
        objcopy_files = ":empty",
        static_runtime_libs = [":empty"],
        strip_files = ":empty",
        supports_param_files = 1,
    )
    for arch in LINUX_TOOLS_ARCHS
]

[
    apple_cc_toolchain(
        name = "cc-compiler-" + arch,
        all_files = ":osx_tools_" + arch,
        compiler_files = ":osx_tools_" + arch,
        cpu = arch,
        dwp_files = ":empty",
        dynamic_runtime_libs = [":empty"],
        linker_files = ":osx_tools_" + arch,
        objcopy_files = ":empty",
        static_runtime_libs = [":empty"],
        strip_files = ":osx_tools_" + arch,
        supports_param_files = 0,
    )
    for arch in OSX_TOOLS_ARCHS
]

[
    toolchain(
        name = "cc-toolchain-" + arch,
        exec_compatible_with = [
            # This toolchain will only work with the local autoconfigured
            # platforms.
            "@bazel_tools//platforms:autoconfigured",
            # TODO(katre): add autodiscovered constraints for host CPU and OS.
        ],
        target_compatible_with = [
            # TODO(katre): add autodiscovered constraints for host CPU and OS.
        ],
        toolchain = ":cc-compiler-" + arch,
        toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
    )
    for arch in LINUX_TOOLS_ARCHS + OSX_TOOLS_ARCHS
]
