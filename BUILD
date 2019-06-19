package(default_visibility = ["//visibility:public"])

constraint_setting(
    name = "linux_distro",
)

constraint_value(
    name = "generic_linux_distro",
    constraint_setting = ":linux_distro",
)

constraint_value(
    name = "centos7_distro",
    constraint_setting = ":linux_distro",
)

config_setting(
    name = "is_target_linux",
    constraint_values = [
        "@bazel_tools//platforms:linux",
    ],
)

config_setting(
    name = "is_target_generic_linux_distro",
    constraint_values = [
        ":generic_linux_distro",
        "@bazel_tools//platforms:linux",
    ],
)

config_setting(
    name = "is_target_centos7_distro",
    constraint_values = [
        ":centos7_distro",
        "@bazel_tools//platforms:linux",
    ],
)

platform(
    name = "linux",
    constraint_values = [
        "@bazel_tools//platforms:linux",
        "@bazel_tools//platforms:x86_64",
        ":generic_linux_distro",
    ],
)

platform(
    name = "centos7",
    parents = [":linux"],
    constraint_values = [
        ":centos7_distro",
    ],
)

config_setting(
    name = "is_target_osx",
    constraint_values = [
        "@bazel_tools//platforms:osx",
    ],
)

platform(
    name = "osx",
    constraint_values = [
        "@bazel_tools//platforms:osx",
        "@bazel_tools//platforms:x86_64",
    ],
)

config_setting(
    name = "is_target_windows",
    constraint_values = [
        "@bazel_tools//platforms:windows",
    ],
)

platform(
    name = "windows",
    constraint_values = [
        "@bazel_tools//platforms:windows",
        "@bazel_tools//platforms:x86_64",
    ],
)
