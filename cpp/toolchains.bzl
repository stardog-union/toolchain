load("//cpp/osx:osx_archs.bzl", "OSX_TOOLS_ARCHS")

def cpp_register_toolchains(repo_name):
    native.register_toolchains(
        "{}//cpp:c++14-linux-x86_64-local-clang-3.9-toolchain".format(repo_name),
        "{}//cpp:c++14-linux-x86_64-centos7-devtoolset-7-llvm-toolchain".format(repo_name),
        "{}//cpp:c++14-linux-x86_64-osx-cross-toolchain".format(repo_name),
#        "{}//cpp:c++14-windows-x86_64-local-clang-vc2019-toolchain".format(repo_name),
        "{}//cpp:c++14-windows-x86_64-local-msvc-2019-toolchain".format(repo_name),
    )
    [ native.register_toolchains(
        "{}//cpp/osx:cc-toolchain-{}".format(repo_name, arch),
    ) for arch in OSX_TOOLS_ARCHS ]
