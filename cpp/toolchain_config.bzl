"""cc_toolchain configuration selection"""

load(":linux_toolchain_config.bzl", "configure_linux_toolchain")
load(":linux_osx_cross_toolchain_config.bzl", "configure_linux_osx_cross_toolchain")
load(":windows_clang_toolchain_config.bzl", "configure_windows_clang_toolchain")
load(":windows_msvc_toolchain_config.bzl", "configure_windows_msvc_toolchain")

def _selector(ctx):
    if (ctx.attr.cpu == "darwin" and ctx.attr.compiler == "linux-osx-cross"):
        return configure_linux_osx_cross_toolchain(ctx)
    elif (ctx.attr.cpu == "linux-x86_64"):
        # Covers all Linux non-cross-compiling toolchains.
        return configure_linux_toolchain(ctx)
    # elif (ctx.attr.cpu == "darwin"):
    #     return configure_osx_toolchain(ctx)
    # elif (ctx.attr.cpu == "freebsd"):
    #     toolchain_identifier = "local_freebsd"
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "clang-vc2019"):
        return configure_windows_clang_toolchain(ctx)
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "msvc-cl"):
        return configure_windows_msvc_toolchain(ctx)
    # elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_mingw"):
    #     toolchain_identifier = "local_windows_mingw"
    # elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64"):
    #     toolchain_identifier = "local_windows_msys64"
    # elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64_mingw64"):
    #     toolchain_identifier = "local_windows_msys64_mingw64"
    # elif (ctx.attr.cpu == "armeabi-v7a"):
    #     toolchain_identifier = "stub_armeabi-v7a"
    # elif (ctx.attr.cpu == "x64_windows_msvc"):
    #     toolchain_identifier = "vc_14_0_x64"
    else:
        fail("Toolchain for cpu '{}' and compiler '{}' not configured".format(ctx.attr.cpu, ctx.attr.compiler))

cc_toolchain_config = rule(
    implementation = _selector,
    attrs = {
        "cpu": attr.string(mandatory = True),
        "compiler": attr.string(mandatory = True),
        "cc_dialect": attr.string(mandatory = True),
    },
    provides = [CcToolchainConfigInfo],
    executable = True,
)
