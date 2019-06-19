package(default_visibility = ["//visibility:public"])
load(":toolchain_config.bzl", "cc_toolchain_config")

load("//cpp/osx:osx_archs.bzl", "OSX_TOOLS_ARCHS", "OSX_TOOLS_CONSTRAINTS")
load("//cpp/osx:cc_toolchain_config.bzl", "osx_cc_toolchain_config")

LINUX_CC_TOOLCHAINS = [
    ("k8", ":c++14-linux-x86_64-local-clang-3.9"),
    ("k8|centos7", ":c++14-linux-x86_64-centos7-devtoolset-7-llvm"),
    ("k8|linux-osx-cross", ":c++14-linux-x86_64-osx-cross"),
]

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

ALL_CC_TOOLCHAINS = dict(LINUX_CC_TOOLCHAINS + OSX_CC_TOOLCHAINS)

cc_toolchain_suite(
    name = "c++14",
    toolchains = ALL_CC_TOOLCHAINS,
)

# General Linux toolchain.
cc_toolchain(
    name = "c++14-linux-x86_64-local-clang-3.9",
    toolchain_identifier = "c++14-linux-x86_64-local-clang-3.9",
    toolchain_config = ":c++14-linux-x86_64-local-clang-3.9-config",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
)

toolchain(
    name = "c++14-linux-x86_64-local-clang-3.9-toolchain",
    exec_compatible_with = [
        "@bazel_tools//platforms:x86_64",
        "@bazel_tools//platforms:linux",
        "//:generic_linux_distro",
    ],
    target_compatible_with = [
        "@bazel_tools//platforms:x86_64",
        "@bazel_tools//platforms:linux",
    ],
    toolchain = ":c++14-linux-x86_64-local-clang-3.9",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain_config(
    name = "c++14-linux-x86_64-local-clang-3.9-config",
    cpu = "linux-x86_64",
    compiler = "generic_compiler",
    cc_dialect = "c++14",
)

# CentOS 7 Linux toolchain.
cc_toolchain(
    name = "c++14-linux-x86_64-centos7-devtoolset-7-llvm",
    toolchain_identifier = "c++14-linux-x86_64-centos7-devtoolset-7-llvm",
    toolchain_config = ":c++14-linux-x86_64-centos7-devtoolset-7-llvm-config",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
)

toolchain(
    name = "c++14-linux-x86_64-centos7-devtoolset-7-llvm-toolchain",
    exec_compatible_with = [
        "@bazel_tools//platforms:x86_64",
        "@bazel_tools//platforms:linux",
        "//:centos7_distro",
    ],
    target_compatible_with = [
        "@bazel_tools//platforms:x86_64",
        "@bazel_tools//platforms:linux",
    ],
    toolchain = ":c++14-linux-x86_64-centos7-devtoolset-7-llvm",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain_config(
    name = "c++14-linux-x86_64-centos7-devtoolset-7-llvm-config",
    cpu = "linux-x86_64",
    compiler = "centos7",
    cc_dialect = "c++14",
)

# Linux to OSX cross-compiling toolchain.
cc_toolchain(
    name = "c++14-linux-x86_64-osx-cross",
    toolchain_identifier = "c++14-linux-x86_64-osx-cross",
    toolchain_config = ":c++14-linux-x86_64-osx-cross-config",
    all_files = "//cpp/linux-osx-cross:tools",
    compiler_files = "//cpp/linux-osx-cross:tools",
    dwp_files = "//cpp/linux-osx-cross:tools",
    linker_files = "//cpp/linux-osx-cross:tools",
    objcopy_files = "//cpp/linux-osx-cross:tools",
    strip_files = "//cpp/linux-osx-cross:tools",
)

toolchain(
    name = "c++14-linux-x86_64-osx-cross-toolchain",
    exec_compatible_with = [
        "@bazel_tools//platforms:x86_64",
        "@bazel_tools//platforms:linux",
    ],
    target_compatible_with = [
        "@bazel_tools//platforms:x86_64",
        "@bazel_tools//platforms:osx",
    ],
    toolchain = ":c++14-linux-x86_64-osx-cross",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

cc_toolchain_config(
    name = "c++14-linux-x86_64-osx-cross-config",
    cpu = "darwin",
    compiler = "linux-osx-cross",
    cc_dialect = "c++14",
)

# OSX toolchain from Bazel standard configuration with a few minor modifications.
[
    apple_cc_toolchain(
        name = "cc-compiler-" + arch,
        all_files = "//cpp/osx:tools",
        ar_files = ":empty",
        as_files = ":empty",
        compiler_files = "//cpp/osx:tools",
        dwp_files = ":empty",
        linker_files = "//cpp/osx:tools",
        objcopy_files = ":empty",
        strip_files = "//cpp/osx:tools",
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

filegroup(name = "empty")


cc_library(
    name = "malloc",
)
