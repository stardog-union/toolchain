def _generate_headers(ctx):
    command = "javah -o {} -classpath {} {}".format(ctx.outputs.out.path, ctx.attr.class_path, ctx.attr.class_name)
    progress_message = "Generating JNI header for class '{}' as '{}'".format(ctx.attr.class_name, ctx.outputs.out.path)

    ctx.actions.run_shell(
        inputs = ctx.files.src,
        outputs = [ctx.outputs.out],
        progress_message = progress_message,
        use_default_shell_env = False,
        command = command,
        execution_requirements = { "local": "True" },
    )

_header_generation_rule = rule(
    attrs = {
        "src": attr.label(
            allow_files = True,
            mandatory = True,
            doc = "Java srcs with native method declarations",
        ),
        "class_name": attr.string(
            mandatory = True,
        ),
        "class_path": attr.string(
            mandatory = True,
        ),
        "out": attr.output(
            mandatory = True,
        ),
    },
    implementation = _generate_headers,
)

def jni_header(name, srcs, path_prefix = "", **kargs):
    if path_prefix != "":
        if not(path_prefix.startswith("/")):
            fail("Invalid path_prefix '{}'. path_prefix must start with a '/'.".format(path_prefix))

    include_prefix = path_prefix
    path_prefix = path_prefix[1:]

    if path_prefix != "":
        class_path = path_prefix
    else:
        class_path = "."

    header_names = []
    for src in srcs:
        path = "{}/{}".format(native.package_name(), src)
        path = path.replace("\\", "/")
        path = path.replace(path_prefix, "", maxsplit=1)
        if path.startswith("/") and path_prefix != "":
            path = path[1:]

        extension_index = path.rfind(".java")
        if extension_index == -1:
            fail("Could not parse filename '{}' as a Java filename".format(src.path))

        header_name = path[:extension_index] + ".h"
        basename_index = path.rfind("/")
        if basename_index != -1:
            header_name = header_name[basename_index+1:]
        
        class_name = path[:extension_index]
        class_name = class_name.replace("/", ".")

        header_names.append(header_name)

        _header_generation_rule(
            name = "{}_{}".format(name, class_name),
            src = src,
            class_name = class_name,
            class_path = class_path,
            out = header_name,
            visibility = ["//visibility:public"],
        )

    return native.cc_library(
        name = name,
        hdrs = header_names,
        strip_include_prefix = include_prefix,
        **kargs
    )
