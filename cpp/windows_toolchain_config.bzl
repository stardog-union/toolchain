"""cc_toolchain configuration rules"""

load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "action_config",
    "artifact_name_pattern",
    "env_entry",
    "env_set",
    "feature",
    "feature_set",
    "flag_group",
    "flag_set",
    "make_variable",
    "tool",
    "tool_path",
    "variable_with_value",
    "with_feature_set",
)
load(
    "@bazel_tools//tools/build_defs/cc:action_names.bzl",
    _ASSEMBLE_ACTION_NAME = "ASSEMBLE_ACTION_NAME",
    _CLIF_MATCH_ACTION_NAME = "CLIF_MATCH_ACTION_NAME",
    _CPP_COMPILE_ACTION_NAME = "CPP_COMPILE_ACTION_NAME",
    _CPP_HEADER_PARSING_ACTION_NAME = "CPP_HEADER_PARSING_ACTION_NAME",
    _CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME = "CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME",
    _CPP_LINK_EXECUTABLE_ACTION_NAME = "CPP_LINK_EXECUTABLE_ACTION_NAME",
    _CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME = "CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME",
    _CPP_LINK_STATIC_LIBRARY_ACTION_NAME = "CPP_LINK_STATIC_LIBRARY_ACTION_NAME",
    _CPP_MODULE_CODEGEN_ACTION_NAME = "CPP_MODULE_CODEGEN_ACTION_NAME",
    _CPP_MODULE_COMPILE_ACTION_NAME = "CPP_MODULE_COMPILE_ACTION_NAME",
    _C_COMPILE_ACTION_NAME = "C_COMPILE_ACTION_NAME",
    _LINKSTAMP_COMPILE_ACTION_NAME = "LINKSTAMP_COMPILE_ACTION_NAME",
    _LTO_BACKEND_ACTION_NAME = "LTO_BACKEND_ACTION_NAME",
    _LTO_INDEXING_ACTION_NAME = "LTO_INDEXING_ACTION_NAME",
    _PREPROCESS_ASSEMBLE_ACTION_NAME = "PREPROCESS_ASSEMBLE_ACTION_NAME",
    _STRIP_ACTION_NAME = "STRIP_ACTION_NAME",
)

all_compile_actions = [
    _C_COMPILE_ACTION_NAME,
    _CPP_COMPILE_ACTION_NAME,
    _LINKSTAMP_COMPILE_ACTION_NAME,
    _ASSEMBLE_ACTION_NAME,
    _PREPROCESS_ASSEMBLE_ACTION_NAME,
    _CPP_HEADER_PARSING_ACTION_NAME,
    _CPP_MODULE_COMPILE_ACTION_NAME,
    _CPP_MODULE_CODEGEN_ACTION_NAME,
    _CLIF_MATCH_ACTION_NAME,
    _LTO_BACKEND_ACTION_NAME,
]

all_cpp_compile_actions = [
    _CPP_COMPILE_ACTION_NAME,
    _LINKSTAMP_COMPILE_ACTION_NAME,
    _CPP_HEADER_PARSING_ACTION_NAME,
    _CPP_MODULE_COMPILE_ACTION_NAME,
    _CPP_MODULE_CODEGEN_ACTION_NAME,
    _CLIF_MATCH_ACTION_NAME,
]

preprocessor_compile_actions = [
    _C_COMPILE_ACTION_NAME,
    _CPP_COMPILE_ACTION_NAME,
    _LINKSTAMP_COMPILE_ACTION_NAME,
    _PREPROCESS_ASSEMBLE_ACTION_NAME,
    _CPP_HEADER_PARSING_ACTION_NAME,
    _CPP_MODULE_COMPILE_ACTION_NAME,
    _CLIF_MATCH_ACTION_NAME,
]

codegen_compile_actions = [
    _C_COMPILE_ACTION_NAME,
    _CPP_COMPILE_ACTION_NAME,
    _LINKSTAMP_COMPILE_ACTION_NAME,
    _ASSEMBLE_ACTION_NAME,
    _PREPROCESS_ASSEMBLE_ACTION_NAME,
    _CPP_MODULE_CODEGEN_ACTION_NAME,
    _LTO_BACKEND_ACTION_NAME,
]

all_link_actions = [
    _CPP_LINK_EXECUTABLE_ACTION_NAME,
    _CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME,
    _CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME,
]

def _impl(ctx):
    if (ctx.attr.cpu == "darwin" and ctx.attr.compiler == "linux-osx-cross"):
        toolchain_identifier = "linux-osx-cross"
    elif (ctx.attr.cpu == "darwin"):
        toolchain_identifier = "local_darwin"
    elif (ctx.attr.cpu == "freebsd"):
        toolchain_identifier = "local_freebsd"
    elif (ctx.attr.cpu == "linux-x86_64"):
        toolchain_identifier = "local_linux"
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_clang"):
        toolchain_identifier = "local_windows_clang"
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_mingw"):
        toolchain_identifier = "local_windows_mingw"
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64"):
        toolchain_identifier = "local_windows_msys64"
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64_mingw64"):
        toolchain_identifier = "local_windows_msys64_mingw64"
    elif (ctx.attr.cpu == "armeabi-v7a"):
        toolchain_identifier = "stub_armeabi-v7a"
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        toolchain_identifier = "vc_14_0_x64"
    else:
        fail("Unreachable")

    if (ctx.attr.cpu == "armeabi-v7a"):
        host_system_name = "armeabi-v7a"
    elif (ctx.attr.cpu == "darwin" or
          ctx.attr.cpu == "freebsd" or
          ctx.attr.cpu == "linux-x86_64" or
          ctx.attr.cpu == "x64_windows" or
          ctx.attr.cpu == "x64_windows_msvc"):
        host_system_name = "local"
    else:
        fail("Unreachable")

    if (ctx.attr.cpu == "armeabi-v7a"):
        target_system_name = "armeabi-v7a"
    elif (ctx.attr.cpu == "darwin" or
          ctx.attr.cpu == "freebsd" or
          ctx.attr.cpu == "linux-x86_64" or
          ctx.attr.cpu == "x64_windows" or
          ctx.attr.cpu == "x64_windows_msvc"):
        target_system_name = "local"
    else:
        fail("Unreachable")

    if (ctx.attr.cpu == "armeabi-v7a"):
        target_cpu = "armeabi-v7a"
    elif (ctx.attr.cpu == "darwin"):
        target_cpu = "darwin"
    elif (ctx.attr.cpu == "freebsd"):
        target_cpu = "freebsd"
    elif (ctx.attr.cpu == "linux-x86_64"):
        target_cpu = "local"
    elif (ctx.attr.cpu == "x64_windows"):
        target_cpu = "x64_windows"
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        target_cpu = "x64_windows_msvc"
    else:
        fail("Unreachable")

    if (ctx.attr.cpu == "armeabi-v7a"):
        target_libc = "armeabi-v7a"
    elif (ctx.attr.cpu == "freebsd" or
          ctx.attr.cpu == "linux-x86_64" or
          ctx.attr.cpu == "x64_windows"):
        target_libc = "local"
    elif (ctx.attr.cpu == "darwin"):
        target_libc = "macosx"
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        target_libc = "msvcrt140"
    else:
        fail("Unreachable")

    if (ctx.attr.cpu == "x64_windows_msvc"):
        compiler = "cl"
    elif (ctx.attr.cpu == "armeabi-v7a" or
          ctx.attr.cpu == "darwin" or
          ctx.attr.cpu == "freebsd" or
          ctx.attr.cpu == "linux-x86_64"):
        compiler = "compiler"
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_clang"):
        compiler = "windows_clang"
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_mingw"):
        compiler = "windows_mingw"
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64"):
        compiler = "windows_msys64"
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64_mingw64"):
        compiler = "windows_msys64_mingw64"
    else:
        fail("Unreachable")

    if (ctx.attr.cpu == "armeabi-v7a"):
        abi_version = "armeabi-v7a"
    elif (ctx.attr.cpu == "darwin" or
          ctx.attr.cpu == "freebsd" or
          ctx.attr.cpu == "linux-x86_64" or
          ctx.attr.cpu == "x64_windows" or
          ctx.attr.cpu == "x64_windows_msvc"):
        abi_version = "local"
    else:
        fail("Unreachable")

    if (ctx.attr.cpu == "armeabi-v7a"):
        abi_libc_version = "armeabi-v7a"
    elif (ctx.attr.cpu == "darwin" or
          ctx.attr.cpu == "freebsd" or
          ctx.attr.cpu == "linux-x86_64" or
          ctx.attr.cpu == "x64_windows" or
          ctx.attr.cpu == "x64_windows_msvc"):
        abi_libc_version = "local"
    else:
        fail("Unreachable")

    cc_target_os = None

    builtin_sysroot = None

    if (ctx.attr.cpu == "darwin" or
        ctx.attr.cpu == "freebsd" or
        ctx.attr.cpu == "linux-x86_64"):
        objcopy_embed_data_action = action_config(
            action_name = "objcopy_embed_data",
            enabled = True,
            tools = [tool(path = "/usr/bin/objcopy")],
        )
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_clang"):
        objcopy_embed_data_action = action_config(
            action_name = "objcopy_embed_data",
            enabled = True,
            tools = [tool(path = "C:/Program Files (x86)/LLVM/bin/objcopy")],
        )
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_mingw"):
        objcopy_embed_data_action = action_config(
            action_name = "objcopy_embed_data",
            enabled = True,
            tools = [tool(path = "C:/mingw/bin/objcopy")],
        )
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64_mingw64"):
        objcopy_embed_data_action = action_config(
            action_name = "objcopy_embed_data",
            enabled = True,
            tools = [tool(path = "C:/tools/msys64/mingw64/bin/objcopy")],
        )
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64"):
        objcopy_embed_data_action = action_config(
            action_name = "objcopy_embed_data",
            enabled = True,
            tools = [tool(path = "C:/tools/msys64/usr/bin/objcopy")],
        )

    c_compile_action = action_config(
        action_name = _C_COMPILE_ACTION_NAME,
        implies = [
            "compiler_input_flags",
            "compiler_output_flags",
            "default_compile_flags",
            "user_compile_flags",
            "sysroot",
            "unfiltered_compile_flags",
        ],
        tools = [tool(path = "wrapper/bin/msvc_cl.bat")],
    )

    cpp_compile_action = action_config(
        action_name = _CPP_COMPILE_ACTION_NAME,
        implies = [
            "compiler_input_flags",
            "compiler_output_flags",
            "default_compile_flags",
            "user_compile_flags",
            "sysroot",
            "unfiltered_compile_flags",
        ],
        tools = [tool(path = "wrapper/bin/msvc_cl.bat")],
    )

    if (ctx.attr.cpu == "armeabi-v7a"):
        action_configs = []
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        action_configs = [c_compile_action, cpp_compile_action]
    elif (ctx.attr.cpu == "darwin" or
          ctx.attr.cpu == "freebsd" or
          ctx.attr.cpu == "linux-x86_64" or
          ctx.attr.cpu == "x64_windows"):
        action_configs = [objcopy_embed_data_action]
    else:
        fail("Unreachable")

    random_seed_feature = feature(name = "random_seed", enabled = True)

    compiler_output_flags_feature = feature(
        name = "compiler_output_flags",
        flag_sets = [
            flag_set(
                actions = [_ASSEMBLE_ACTION_NAME],
                flag_groups = [
                    flag_group(
                        flags = ["/Fo%{output_file}", "/Zi"],
                        expand_if_available = "output_file",
                        expand_if_not_available = "output_assembly_file",
                    ),
                ],
            ),
            flag_set(
                actions = [
                    _PREPROCESS_ASSEMBLE_ACTION_NAME,
                    _C_COMPILE_ACTION_NAME,
                    _CPP_COMPILE_ACTION_NAME,
                    _CPP_HEADER_PARSING_ACTION_NAME,
                    _CPP_MODULE_COMPILE_ACTION_NAME,
                    _CPP_MODULE_CODEGEN_ACTION_NAME,
                ],
                flag_groups = [
                    flag_group(
                        flags = ["/Fo%{output_file}"],
                        expand_if_available = "output_file",
                        expand_if_not_available = "output_assembly_file",
                    ),
                    flag_group(
                        flags = ["/Fa%{output_file}"],
                        expand_if_available = "output_file",
                    ),
                    flag_group(
                        flags = ["/P", "/Fi%{output_file}"],
                        expand_if_available = "output_file",
                    ),
                ],
            ),
        ],
    )

    if (ctx.attr.cpu == "linux-x86_64" and ctx.attr.compiler == "linux-osx-cross"):
        default_link_flags_feature = feature(
            name = "default_link_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-lstdc++",
                                "-lm",
                                "-lc",
                            ],
                        ),
                    ],
                ),
            ],
        )
    elif (ctx.attr.cpu == "linux-x86_64"):
        default_link_flags_feature = feature(
            name = "default_link_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-lstdc++",
                                "-lm",
                                "-lc",
                                "-Wl,-no-as-needed",
                                "-Wl,-z,relro,-z,now",
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [flag_group(flags = ["-Wl,--gc-sections"])],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
            ],
        )
    elif (ctx.attr.cpu == "freebsd"):
        default_link_flags_feature = feature(
            name = "default_link_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-lstdc++",
                                "-Wl,-z,relro,-z,now",
                                "-no-canonical-prefixes",
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [flag_group(flags = ["-Wl,--gc-sections"])],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
            ],
        )
    elif (ctx.attr.cpu == "darwin"):
        default_link_flags_feature = feature(
            name = "default_link_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-lstdc++",
                                "-undefined",
                                "dynamic_lookup",
                                "-headerpad_max_install_names",
                                "-no-canonical-prefixes",
                            ],
                        ),
                    ],
                ),
            ],
        )
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64"):
        default_link_flags_feature = feature(
            name = "default_link_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [flag_group(flags = ["-lstdc++"])],
                ),
            ],
        )
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        default_link_flags_feature = feature(
            name = "default_link_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [flag_group(flags = ["-m64"])],
                ),
            ],
        )

    if (ctx.attr.cpu == "darwin" or
        ctx.attr.cpu == "freebsd"):
        unfiltered_compile_flags_feature = feature(
            name = "unfiltered_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-no-canonical-prefixes",
                                "-Wno-builtin-macro-redefined",
                                "-D__DATE__=\"redacted\"",
                                "-D__TIMESTAMP__=\"redacted\"",
                                "-D__TIME__=\"redacted\"",
                            ],
                        ),
                    ],
                ),
            ],
        )
    elif (ctx.attr.cpu == "linux-x86_64"):
        unfiltered_compile_flags_feature = feature(
            name = "unfiltered_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-Wno-builtin-macro-redefined",
                                "-D__DATE__=\"redacted\"",
                                "-D__TIMESTAMP__=\"redacted\"",
                                "-D__TIME__=\"redacted\"",
                            ],
                        ),
                    ],
                ),
            ],
        )
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        unfiltered_compile_flags_feature = feature(
            name = "unfiltered_compile_flags",
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["%{unfiltered_compile_flags}"],
                            iterate_over = "unfiltered_compile_flags",
                            expand_if_available = "unfiltered_compile_flags",
                        ),
                    ],
                ),
            ],
        )

    supports_pic_feature = feature(name = "supports_pic", enabled = True)

    if (ctx.attr.cpu == "darwin"):
        default_compile_flags_feature = feature(
            name = "default_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-D_FORTIFY_SOURCE=1",
                                "-fstack-protector",
                                "-fcolor-diagnostics",
                                "-Wall",
                                "-Wthread-safety",
                                "-Wself-assign",
                                "-fno-omit-frame-pointer",
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-g", "-O"])],
                    with_features = [with_feature_set(features = ["dbg"])],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-g"])],
                    with_features = [with_feature_set(features = ["fastbuild"])],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-g0",
                                "-O3",
                                "-DNDEBUG",
                                "-ffunction-sections",
                                "-fdata-sections",
                            ],
                        ),
                    ],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
                flag_set(
                    actions = [
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-std=%s" % ctx.attr.cc_dialect])],
                ),
            ],
        )
    elif (ctx.attr.cpu == "linux-x86_64"):
        default_compile_flags_feature = feature(
            name = "default_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-U_FORTIFY_SOURCE",
                                "-D_FORTIFY_SOURCE=1",
                                "-fstack-protector",
                                "-Wall",
                                "-fno-omit-frame-pointer",
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-g", "-O"])],
                    with_features = [with_feature_set(features = ["dbg"])],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-g"])],
                    with_features = [with_feature_set(features = ["fastbuild"])],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-g0",
                                "-O3",
                                "-DNDEBUG",
                                "-ffunction-sections",
                                "-fdata-sections",
                            ],
                        ),
                    ],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
                flag_set(
                    actions = [
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-std=%s" % ctx.attr.cc_dialect])],
                ),
            ],
        )
    elif (ctx.attr.cpu == "freebsd"):
        default_compile_flags_feature = feature(
            name = "default_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-U_FORTIFY_SOURCE",
                                "-D_FORTIFY_SOURCE=1",
                                "-fstack-protector",
                                "-Wall",
                                "-fno-omit-frame-pointer",
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-g"])],
                    with_features = [with_feature_set(features = ["dbg"])],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-g0",
                                "-O2",
                                "-DNDEBUG",
                                "-ffunction-sections",
                                "-fdata-sections",
                            ],
                        ),
                    ],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
                flag_set(
                    actions = [
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-std=%s" % ctx.attr.cc_dialect])],
                ),
            ],
        )
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        default_compile_flags_feature = feature(
            name = "default_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-m64",
                                "/D__inline__=__inline",
                                "/DCOMPILER_MSVC",
                                "/DNOGDI",
                                "/DNOMINMAX",
                                "/DPRAGMA_SUPPORTED",
                                "/D_WIN32_WINNT=0x0601",
                                "/D_CRT_SECURE_NO_DEPRECATE",
                                "/D_CRT_SECURE_NO_WARNINGS",
                                "/D_SILENCE_STDEXT_HASH_DEPRECATION_WARNINGS",
                                "/D_USE_MATH_DEFINES",
                                "/nologo",
                                "/bigobj",
                                "/Zm500",
                                "/J",
                                "/Gy",
                                "/GF",
                                "/W3",
                                "/EHsc",
                                "/wd4351",
                                "/wd4291",
                                "/wd4250",
                                "/wd4996",
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["/DDEBUG=1", "-g", "/Od", "-Xcompilation-mode=dbg"],
                        ),
                    ],
                    with_features = [with_feature_set(features = ["dbg"])],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["/DNDEBUG", "/Od", "-Xcompilation-mode=fastbuild"],
                        ),
                    ],
                    with_features = [with_feature_set(features = ["fastbuild"])],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["/DNDEBUG", "/O2", "-Xcompilation-mode=opt"],
                        ),
                    ],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
            ],
        )
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_clang" or
          ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_mingw" or
          ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64_mingw64"):
        default_compile_flags_feature = feature(
            name = "default_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-std=%s" % ctx.attr.cc_dialect])],
                ),
            ],
        )
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64"):
        default_compile_flags_feature = feature(
            name = "default_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-std=%s" % ctx.attr.cc_dialect])],
                ),
            ],
        )

    supports_dynamic_linker_feature = feature(name = "supports_dynamic_linker", enabled = True)

    objcopy_embed_flags_feature = feature(
        name = "objcopy_embed_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ["objcopy_embed_data"],
                flag_groups = [flag_group(flags = ["-I", "binary"])],
            ),
        ],
    )

    if (ctx.attr.cpu == "darwin" or
        ctx.attr.cpu == "freebsd" or
        ctx.attr.cpu == "linux-x86_64"):
        user_compile_flags_feature = feature(
            name = "user_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["%{user_compile_flags}"],
                            iterate_over = "user_compile_flags",
                            expand_if_available = "user_compile_flags",
                        ),
                    ],
                ),
            ],
        )
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        user_compile_flags_feature = feature(
            name = "user_compile_flags",
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["%{user_compile_flags}"],
                            iterate_over = "user_compile_flags",
                            expand_if_available = "user_compile_flags",
                        ),
                    ],
                ),
            ],
        )

    if (ctx.attr.cpu == "linux-x86_64" and ctx.attr.compiler == "linux-osx-cross"):
        sysroot_flags_feature = feature(
            name = "sysroot_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                        _CPP_LINK_EXECUTABLE_ACTION_NAME,
                        _CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME,
                        _CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-isystem",
                                "/opt/jdk-8u162-macosx/include",
                                "-isystem",
                                "/opt/jdk-8u162-macosx/include/darwin",
                            ],
                        ),
                    ],
                ),
            ],
        )

    if (ctx.attr.cpu == "darwin" or
        ctx.attr.cpu == "freebsd" or
        ctx.attr.cpu == "linux-x86_64"):
        sysroot_feature = feature(
            name = "sysroot",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                        _CPP_LINK_EXECUTABLE_ACTION_NAME,
                        _CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME,
                        _CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["--sysroot=%{sysroot}"],
                            expand_if_available = "sysroot",
                        ),
                    ],
                ),
            ],
        )
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        sysroot_feature = feature(
            name = "sysroot",
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _CPP_LINK_EXECUTABLE_ACTION_NAME,
                        _CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME,
                        _CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["--sysroot=%{sysroot}"],
                            iterate_over = "sysroot",
                            expand_if_available = "sysroot",
                        ),
                    ],
                ),
            ],
        )

    if (ctx.attr.cpu == "x64_windows_msvc"):
        include_paths_feature = feature(
            name = "include_paths",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["/I%{quote_include_paths}"],
                            iterate_over = "quote_include_paths",
                        ),
                        flag_group(
                            flags = ["/I%{include_paths}"],
                            iterate_over = "include_paths",
                        ),
                        flag_group(
                            flags = ["/I%{system_include_paths}"],
                            iterate_over = "system_include_paths",
                        ),
                    ],
                ),
            ],
        )

    dependency_file_feature = feature(
        name = "dependency_file",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = [
                    _ASSEMBLE_ACTION_NAME,
                    _PREPROCESS_ASSEMBLE_ACTION_NAME,
                    _C_COMPILE_ACTION_NAME,
                    _CPP_COMPILE_ACTION_NAME,
                    _CPP_MODULE_COMPILE_ACTION_NAME,
                    _CPP_HEADER_PARSING_ACTION_NAME,
                ],
                flag_groups = [
                    flag_group(
                        flags = ["/DEPENDENCY_FILE", "%{dependency_file}"],
                        expand_if_available = "dependency_file",
                    ),
                ],
            ),
        ],
    )

    compiler_input_flags_feature = feature(
        name = "compiler_input_flags",
        flag_sets = [
            flag_set(
                actions = [
                    _ASSEMBLE_ACTION_NAME,
                    _PREPROCESS_ASSEMBLE_ACTION_NAME,
                    _C_COMPILE_ACTION_NAME,
                    _CPP_COMPILE_ACTION_NAME,
                    _CPP_HEADER_PARSING_ACTION_NAME,
                    _CPP_MODULE_COMPILE_ACTION_NAME,
                    _CPP_MODULE_CODEGEN_ACTION_NAME,
                ],
                flag_groups = [
                    flag_group(
                        flags = ["/c", "%{source_file}"],
                        expand_if_available = "source_file",
                    ),
                ],
            ),
        ],
    )

    opt_feature = feature(name = "opt")
    fastbuild_feature = feature(name = "fastbuild")
    dbg_feature = feature(name = "dbg")

    if (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64"):
        features = [
            default_compile_flags_feature,
            default_link_flags_feature,
            supports_dynamic_linker_feature,
            objcopy_embed_flags_feature,
        ]
    elif (ctx.attr.cpu == "darwin"):
        features = [
            default_compile_flags_feature,
            default_link_flags_feature,
            supports_dynamic_linker_feature,
            supports_pic_feature,
            objcopy_embed_flags_feature,
            dbg_feature,
            fastbuild_feature,
            opt_feature,
            user_compile_flags_feature,
            sysroot_feature,
            unfiltered_compile_flags_feature,
        ]
    elif (ctx.attr.cpu == "linux-x86_64" and ctx.attr.compiler == "linux-osx-cross"):
        features = [
            sysroot_flags_feature,
            default_compile_flags_feature,
            default_link_flags_feature,
            supports_dynamic_linker_feature,
            supports_pic_feature,
            objcopy_embed_flags_feature,
            dbg_feature,
            fastbuild_feature,
            opt_feature,
            user_compile_flags_feature,
            sysroot_feature,
            unfiltered_compile_flags_feature,
        ]
    elif (ctx.attr.cpu == "freebsd" or
          ctx.attr.cpu == "linux-x86_64"):
        features = [
            default_compile_flags_feature,
            default_link_flags_feature,
            supports_dynamic_linker_feature,
            supports_pic_feature,
            objcopy_embed_flags_feature,
            dbg_feature,
            fastbuild_feature,
            opt_feature,
            user_compile_flags_feature,
            sysroot_feature,
            unfiltered_compile_flags_feature,
        ]
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_clang" or
          ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_mingw" or
          ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64_mingw64"):
        features = [
            default_compile_flags_feature,
            supports_dynamic_linker_feature,
            objcopy_embed_flags_feature,
        ]
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        features = [
            default_link_flags_feature,
            random_seed_feature,
            default_compile_flags_feature,
            include_paths_feature,
            dependency_file_feature,
            user_compile_flags_feature,
            sysroot_feature,
            unfiltered_compile_flags_feature,
            compiler_output_flags_feature,
            compiler_input_flags_feature,
            dbg_feature,
            fastbuild_feature,
            opt_feature,
        ]
    elif (ctx.attr.cpu == "armeabi-v7a"):
        features = [supports_dynamic_linker_feature, supports_pic_feature]

    if (ctx.attr.cpu == "armeabi-v7a"):
        cxx_builtin_include_directories = []
    elif (ctx.attr.cpu == "darwin"):
        cxx_builtin_include_directories = ["/"]
    elif (ctx.attr.cpu == "freebsd"):
        cxx_builtin_include_directories = ["/usr/lib/clang", "/usr/local/include", "/usr/include"]
    elif (ctx.attr.cpu == "linux-x86_64" and ctx.attr.compiler == "centos7"):
        cxx_builtin_include_directories = [
            "/opt/rh/devtoolset-7/root/usr/include/c++/7",
            "/opt/rh/llvm-toolset-7/root/usr/lib64/clang/5.0.1/include",
            "/usr/include",
        ]
    elif (ctx.attr.cpu == "linux-x86_64" and ctx.attr.compiler == "linux-osx-cross"):
        cxx_builtin_include_directories = [
            "/opt/osxcross/target/SDK/MacOSX10.11.sdk/usr/include/c++/v1",
            "/opt/osxcross/target/SDK/MacOSX10.11.sdk/usr/include/machine",
            "/opt/osxcross/target/SDK/MacOSX10.11.sdk/usr/include/sys",
            "/opt/osxcross/target/SDK/MacOSX10.11.sdk/usr/include",
            "/usr/lib/llvm-3.9/lib/clang/3.9.1/include/",
            # JNI include directories.
            # TODO(james): These can be removed if we configure Bazel to use this JDK.
            "/opt/jdk-8u162-macosx/include",
            "/opt/jdk-8u162-macosx/include/darwin",
            "/usr/lib/clang/3.9.1/include",
            "/usr/lib/llvm-3.9/lib/clang/3.9.1/include/",
            "/usr/include",
        ]
    elif (ctx.attr.cpu == "linux-x86_64"):
        cxx_builtin_include_directories = [
            "/usr/lib/gcc/",
            "/usr/lib/clang/3.9.1/include",
            "/usr/lib/llvm-3.9/lib/clang/3.9.1/include/",
            "/usr/local/include",
            "/usr/include",
        ]
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_clang"):
        cxx_builtin_include_directories = ["/usr/lib/gcc/", "/usr/local/include", "/usr/include"]
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        cxx_builtin_include_directories = [
            "C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/INCLUDE",
            "C:/Program Files (x86)/Windows Kits/10/include/",
            "C:/Program Files (x86)/Windows Kits/8.1/include/",
            "C:/Program Files (x86)/GnuWin32/include/",
            "C:/python_27_amd64/files/include",
        ]
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_mingw"):
        cxx_builtin_include_directories = ["C:/mingw/include", "C:/mingw/lib/gcc"]
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64_mingw64"):
        cxx_builtin_include_directories = ["C:/tools/msys64/mingw64/x86_64-w64-mingw32/include"]
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64"):
        cxx_builtin_include_directories = ["C:/tools/msys64/", "/usr/"]
    else:
        fail("Unreachable")

    artifact_name_patterns = []

    make_variables = []

    if (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64_mingw64"):
        tool_paths = [
            tool_path(
                name = "ar",
                path = "C:/tools/msys64/mingw64/bin/ar",
            ),
            tool_path(
                name = "compat-ld",
                path = "C:/tools/msys64/mingw64/bin/ld",
            ),
            tool_path(
                name = "cpp",
                path = "C:/tools/msys64/mingw64/bin/cpp",
            ),
            tool_path(
                name = "dwp",
                path = "C:/tools/msys64/mingw64/bin/dwp",
            ),
            tool_path(
                name = "gcc",
                path = "C:/tools/msys64/mingw64/bin/gcc",
            ),
            tool_path(
                name = "gcov",
                path = "C:/tools/msys64/mingw64/bin/gcov",
            ),
            tool_path(
                name = "ld",
                path = "C:/tools/msys64/mingw64/bin/ld",
            ),
            tool_path(
                name = "nm",
                path = "C:/tools/msys64/mingw64/bin/nm",
            ),
            tool_path(
                name = "objcopy",
                path = "C:/tools/msys64/mingw64/bin/objcopy",
            ),
            tool_path(
                name = "objdump",
                path = "C:/tools/msys64/mingw64/bin/objdump",
            ),
            tool_path(
                name = "strip",
                path = "C:/tools/msys64/mingw64/bin/strip",
            ),
        ]
    elif (ctx.attr.cpu == "armeabi-v7a"):
        tool_paths = [
            tool_path(name = "ar", path = "/bin/false"),
            tool_path(name = "compat-ld", path = "/bin/false"),
            tool_path(name = "cpp", path = "/bin/false"),
            tool_path(name = "dwp", path = "/bin/false"),
            tool_path(name = "gcc", path = "/bin/false"),
            tool_path(name = "gcov", path = "/bin/false"),
            tool_path(name = "ld", path = "/bin/false"),
            tool_path(name = "nm", path = "/bin/false"),
            tool_path(name = "objcopy", path = "/bin/false"),
            tool_path(name = "objdump", path = "/bin/false"),
            tool_path(name = "strip", path = "/bin/false"),
        ]
    elif (ctx.attr.cpu == "freebsd"):
        tool_paths = [
            tool_path(name = "ar", path = "/usr/bin/ar"),
            tool_path(name = "compat-ld", path = "/usr/bin/ld"),
            tool_path(name = "cpp", path = "/usr/bin/cpp"),
            tool_path(name = "dwp", path = "/usr/bin/dwp"),
            tool_path(name = "gcc", path = "/usr/bin/clang"),
            tool_path(name = "gcov", path = "/usr/bin/gcov"),
            tool_path(name = "ld", path = "/usr/bin/ld"),
            tool_path(name = "nm", path = "/usr/bin/nm"),
            tool_path(name = "objcopy", path = "/usr/bin/objcopy"),
            tool_path(name = "objdump", path = "/usr/bin/objdump"),
            tool_path(name = "strip", path = "/usr/bin/strip"),
        ]
    elif (ctx.attr.cpu == "linux-x86_64" and ctx.attr.compiler == "centos7"):
        tool_paths = [
            tool_path(name = "ar", path = "/usr/bin/ar"),
            tool_path(name = "compat-ld", path = "/usr/bin/ld"),
            tool_path(name = "cpp", path = "/usr/bin/cpp"),
            tool_path(name = "dwp", path = "/usr/bin/dwp"),
            tool_path(name = "gcc", path = "/opt/rh/llvm-toolset-7/root/usr/bin/clang"),
            tool_path(name = "gcov", path = "/usr/bin/gcov"),
            tool_path(name = "ld", path = "/usr/bin/ld"),
            tool_path(name = "nm", path = "/usr/bin/nm"),
            tool_path(name = "objcopy", path = "/usr/bin/objcopy"),
            tool_path(name = "objdump", path = "/usr/bin/objdump"),
            tool_path(name = "strip", path = "/usr/bin/strip"),
        ]
    elif (ctx.attr.cpu == "linux-x86_64" and ctx.attr.compiler == "linux-osx-cross"):
        tool_paths = [
            tool_path(name = "ar", path = "linux-osx-cross/ar_wrapper.sh"),
            tool_path(name = "compat-ld", path = "/opt/osxcross/target/bin/x86_64-apple-darwin15-ld"),
            tool_path(name = "cpp", path = "/usr/bin/false"),
            tool_path(name = "dwp", path = "/usr/bin/false"),
            tool_path(name = "gcc", path = "linux-osx-cross/cc_wrapper.sh"),
            tool_path(name = "gcov", path = "/usr/bin/false"),
            tool_path(name = "ld", path = "/opt/osxcross/target/bin/x86_64-apple-darwin15-ld"),
            tool_path(name = "nm", path = "/opt/osxcross/target/bin/x86_64-apple-darwin15-install_name_tool"),
            tool_path(name = "objcopy", path = "/usr/bin/false"),
            tool_path(name = "objdump", path = "/opt/osxcross/target/bin/x86_64-apple-darwin15-ObjectDump"),
            tool_path(name = "ranlib", path = "/opt/osxcross/target/bin/x86_64-apple-darwin15-ranlib"),
            tool_path(name = "strip", path = "/opt/osxcross/target/bin/x86_64-apple-darwin15-strip"),
        ]
    elif (ctx.attr.cpu == "linux-x86_64"):
        tool_paths = [
            tool_path(name = "ar", path = "/usr/bin/ar"),
            tool_path(name = "compat-ld", path = "/usr/bin/ld"),
            tool_path(name = "cpp", path = "/usr/bin/cpp"),
            tool_path(name = "dwp", path = "/usr/bin/dwp"),
            tool_path(name = "gcc", path = "/usr/bin/clang-3.9"),
            tool_path(name = "gcov", path = "/usr/bin/gcov"),
            tool_path(name = "ld", path = "/usr/bin/ld"),
            tool_path(name = "nm", path = "/usr/bin/nm"),
            tool_path(name = "objcopy", path = "/usr/bin/objcopy"),
            tool_path(name = "objdump", path = "/usr/bin/objdump"),
            tool_path(name = "strip", path = "/usr/bin/strip"),
        ]
    elif (ctx.attr.cpu == "darwin"):
        tool_paths = [
            tool_path(name = "ar", path = "/usr/bin/libtool"),
            tool_path(name = "compat-ld", path = "/usr/bin/ld"),
            tool_path(name = "cpp", path = "/usr/bin/cpp"),
            tool_path(name = "dwp", path = "/usr/bin/dwp"),
            tool_path(name = "gcc", path = "osx_cc_wrapper.sh"),
            tool_path(name = "gcov", path = "/usr/bin/gcov"),
            tool_path(name = "ld", path = "/usr/bin/ld"),
            tool_path(name = "nm", path = "/usr/bin/nm"),
            tool_path(name = "objcopy", path = "/usr/bin/objcopy"),
            tool_path(name = "objdump", path = "/usr/bin/objdump"),
            tool_path(name = "strip", path = "/usr/bin/strip"),
        ]
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_clang"):
        tool_paths = [
            tool_path(name = "ar", path = "C:/mingw/bin/ar"),
            tool_path(
                name = "compat-ld",
                path = "C:/Program Files (x86)/LLVM/bin/ld",
            ),
            tool_path(
                name = "cpp",
                path = "C:/Program Files (x86)/LLVM/bin/cpp",
            ),
            tool_path(
                name = "dwp",
                path = "C:/Program Files (x86)/LLVM/bin/dwp",
            ),
            tool_path(
                name = "gcc",
                path = "C:/Program Files (x86)/LLVM/bin/clang",
            ),
            tool_path(
                name = "gcov",
                path = "C:/Program Files (x86)/LLVM/bin/gcov",
            ),
            tool_path(
                name = "ld",
                path = "C:/Program Files (x86)/LLVM/bin/ld",
            ),
            tool_path(
                name = "nm",
                path = "C:/Program Files (x86)/LLVM/bin/nm",
            ),
            tool_path(
                name = "objcopy",
                path = "C:/Program Files (x86)/LLVM/bin/objcopy",
            ),
            tool_path(
                name = "objdump",
                path = "C:/Program Files (x86)/LLVM/bin/objdump",
            ),
            tool_path(
                name = "strip",
                path = "C:/Program Files (x86)/LLVM/bin/strip",
            ),
        ]
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_mingw"):
        tool_paths = [
            tool_path(name = "ar", path = "C:/mingw/bin/ar"),
            tool_path(name = "compat-ld", path = "C:/mingw/bin/ld"),
            tool_path(name = "cpp", path = "C:/mingw/bin/cpp"),
            tool_path(name = "dwp", path = "C:/mingw/bin/dwp"),
            tool_path(name = "gcc", path = "C:/mingw/bin/gcc"),
            tool_path(name = "gcov", path = "C:/mingw/bin/gcov"),
            tool_path(name = "ld", path = "C:/mingw/bin/ld"),
            tool_path(name = "nm", path = "C:/mingw/bin/nm"),
            tool_path(name = "objcopy", path = "C:/mingw/bin/objcopy"),
            tool_path(name = "objdump", path = "C:/mingw/bin/objdump"),
            tool_path(name = "strip", path = "C:/mingw/bin/strip"),
        ]
    elif (ctx.attr.cpu == "x64_windows" and ctx.attr.compiler == "windows_msys64"):
        tool_paths = [
            tool_path(name = "ar", path = "C:/tools/msys64/usr/bin/ar"),
            tool_path(
                name = "compat-ld",
                path = "C:/tools/msys64/usr/bin/ld",
            ),
            tool_path(
                name = "cpp",
                path = "C:/tools/msys64/usr/bin/cpp",
            ),
            tool_path(
                name = "dwp",
                path = "C:/tools/msys64/usr/bin/dwp",
            ),
            tool_path(
                name = "gcc",
                path = "C:/tools/msys64/usr/bin/gcc",
            ),
            tool_path(
                name = "gcov",
                path = "C:/tools/msys64/usr/bin/gcov",
            ),
            tool_path(name = "ld", path = "C:/tools/msys64/usr/bin/ld"),
            tool_path(name = "nm", path = "C:/tools/msys64/usr/bin/nm"),
            tool_path(
                name = "objcopy",
                path = "C:/tools/msys64/usr/bin/objcopy",
            ),
            tool_path(
                name = "objdump",
                path = "C:/tools/msys64/usr/bin/objdump",
            ),
            tool_path(
                name = "strip",
                path = "C:/tools/msys64/usr/bin/strip",
            ),
        ]
    elif (ctx.attr.cpu == "x64_windows_msvc"):
        tool_paths = [
            tool_path(name = "ar", path = "wrapper/bin/msvc_link.bat"),
            tool_path(name = "cpp", path = "wrapper/bin/msvc_cl.bat"),
            tool_path(name = "gcc", path = "wrapper/bin/msvc_cl.bat"),
            tool_path(name = "gcov", path = "wrapper/bin/msvc_nop.bat"),
            tool_path(name = "ld", path = "wrapper/bin/msvc_link.bat"),
            tool_path(name = "nm", path = "wrapper/bin/msvc_nop.bat"),
            tool_path(
                name = "objcopy",
                path = "wrapper/bin/msvc_nop.bat",
            ),
            tool_path(
                name = "objdump",
                path = "wrapper/bin/msvc_nop.bat",
            ),
            tool_path(
                name = "strip",
                path = "wrapper/bin/msvc_nop.bat",
            ),
        ]
    else:
        fail("Unreachable")

    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(out, "Fake executable")
    return [
        cc_common.create_cc_toolchain_config_info(
            ctx = ctx,
            features = features,
            action_configs = action_configs,
            artifact_name_patterns = artifact_name_patterns,
            cxx_builtin_include_directories = cxx_builtin_include_directories,
            toolchain_identifier = toolchain_identifier,
            host_system_name = host_system_name,
            target_system_name = target_system_name,
            target_cpu = target_cpu,
            target_libc = target_libc,
            compiler = compiler,
            abi_version = abi_version,
            abi_libc_version = abi_libc_version,
            tool_paths = tool_paths,
            make_variables = make_variables,
            builtin_sysroot = builtin_sysroot,
            cc_target_os = cc_target_os,
        ),
        DefaultInfo(
            executable = out,
        ),
    ]

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "cpu": attr.string(mandatory = True),
        "compiler": attr.string(),
        "cc_dialect": attr.string(mandatory = True),
    },
    provides = [CcToolchainConfigInfo],
    executable = True,
)
