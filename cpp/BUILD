package(default_visibility = ["//visibility:public"])
load(":toolchain_config.bzl", "cc_toolchain_config")

LINUX_CC_TOOLCHAINS = [
    ("k8", ":c++14-linux-x86_64-local-clang-3.9"),
    ("k8|centos7", ":c++14-linux-x86_64-centos7-devtoolset-7-llvm"),
    ("k8|linux-osx-cross", ":c++14-linux-x86_64-osx-cross"),
#    ("x64_windows", ":c++14-windows-x86_64-local-clang-vc2019"),
#    ("x64_windows|clang-vc2019", ":c++14-windows-x86_64-local-clang-vc2019"),
    ("x64_windows|msvc-cl", ":c++14-windows-x86_64-local-vs"),
]

cc_toolchain_suite(
    name = "c++14",
    toolchains = dict(LINUX_CC_TOOLCHAINS),
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

filegroup(name = "empty")

cc_library(
    name = "malloc",
)

# Windows with clang-vc2019
#cc_toolchain(
#    name = "c++14-windows-x86_64-local-clang-vc2019",
#    toolchain_identifier = "c++14-windows-x86_64-local-clang-vc2019",
#    toolchain_config = ":c++14-windows-x86_64-local-clang-vc2019-config",
#    all_files = ":empty",
#    compiler_files = ":empty",
#    dwp_files = ":empty",
#    linker_files = ":empty",
#    objcopy_files = ":empty",
#    strip_files = ":empty",
#)

#toolchain(
#    name = "c++14-windows-x86_64-local-clang-vc2019-toolchain",
#    exec_compatible_with = [
#        "@bazel_tools//platforms:x86_64",
#        "@bazel_tools//platforms:windows",
#    ],
#    target_compatible_with = [
#        "@bazel_tools//platforms:x86_64",
#        "@bazel_tools//platforms:windows",
#    ],
#    toolchain = ":c++14-windows-x86_64-local-clang-vc2019",
#    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
#)

#cc_toolchain_config(
#    name = "c++14-windows-x86_64-local-clang-vc2019-config",
#    cpu = "x64_windows",
#    compiler = "clang-vc2019",
#    cc_dialect = "c++14",
#)

# Windows with visual studio 2019
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

cc_toolchain_config(
    name = "c++14-windows-x86_64-local-vs-config",
    cpu = "x64_windows",
    compiler = "msvc-cl",
    cc_dialect = "c++14",
)
