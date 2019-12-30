workspace(name = "toolchain")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

bazelbuild_platforms_version = "master"
http_archive(
    name = "platforms",
    urls = [
        "https://github.com/bazelbuild/platforms/archive/%s.zip" % bazelbuild_platforms_version,
    ],
    strip_prefix = "platforms-%s" % bazelbuild_platforms_version,
)

register_toolchains(
    "//cpp:c++14-linux-x86_64-local-clang-3.9-toolchain",
    "//cpp:c++14-linux-x86_64-centos7-devtoolset-7-llvm-toolchain",
    "//cpp:c++14-linux-x86_64-osx-cross-toolchain",
    "//cpp:c++14-windows-x86_64-local-clang-3.9-toolchain",
)
