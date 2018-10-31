package(default_visibility = ["//visibility:public"])

platform(
    name = "linux-x86_64",
    constraint_values = [
        "@bazel_tools//platforms:linux",
        "@bazel_tools//platforms:x86_64",
    ],
)

platform(
    name = "osx-x86_64",
    constraint_values = [
        "@bazel_tools//platforms:osx",
        "@bazel_tools//platforms:x86_64",
    ],
)

platform(
    name = "windows-x86_64",
    constraint_values = [
        "@bazel_tools//platforms:windows",
        "@bazel_tools//platforms:x86_64",
    ],
)

# Target platform config_settings.
config_setting(
    name = "linux-target",
    constraint_values = [
        "@bazel_tools//platforms:linux",
    ],
)

config_setting(
    name = "osx-target",
    constraint_values = [
        "@bazel_tools//platforms:osx",
    ],
)

config_setting(
    name = "windows-target",
    constraint_values = [
        "@bazel_tools//platforms:windows",
    ],
)

# Native / cross-compile config setting.
config_setting(
    name = "linux-native",
    constraint_values = [
        "@bazel_tools//platforms:linux",
    ],
    values = {
        "compiler": "linux-x86_64-clang-linux",
    },
)

config_setting(
    name = "osx-native",
    constraint_values = [
        "@bazel_tools//platforms:osx",
    ],
    values = {
        "compiler": "osx-x86_64-clang-osx",
    },
)

config_setting(
    name = "windows-native",
    constraint_values = [
        "@bazel_tools//platforms:windows",
    ],
    values = {
        "compiler": "windows-x86_64-clang-windows",
    },
)

config_setting(
    name = "cross-compile",
    values = {
        "compiler": "osx-x86_64-clang-linux",
    },
)
