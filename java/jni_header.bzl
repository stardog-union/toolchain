def _impl(ctx):
    output_filename = ctx.outputs.output.path
    classnames = []
    for src in ctx.files.srcs:
        path = src.path.replace(ctx.attr.path_prefix, "", maxsplit=1)
        path = path.replace("\\", "/")
        if path.startswith("/") and ctx.attr.path_prefix != "":
            path = path[1:]

        extension_index = path.rfind(".java")
        if extension_index == -1:
            fail("Could not parse filename '{}' as a Java filename".format(src.path))

        path_separator_index = path.rfind("/")

        classname = path[:extension_index]
        classname = classname.replace("/", ".")
        classnames.append(classname)

            
    classnames_string = " ".join(classnames)
    if ctx.attr.path_prefix != "":
        classpath_string = ctx.attr.path_prefix
    else:
        classpath_string = "."

    ctx.actions.run_shell(
        inputs = ctx.files.srcs,
        outputs = [ctx.outputs.output],
        progress_message = "Generating JNI header %s" % output_filename,
        command = "javah -o {} -classpath {} {}".format(output_filename, classpath_string, classnames_string), 
    )


jni_header = rule(
    implementation = _impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "Java srcs with native method declarations",
        ),
        "output": attr.output(
            mandatory = True,
            doc = "Generated header filename",
        ),
        "path_prefix": attr.string(
            doc = "Path prefix to use to find the base directory in the classpath",
            default = "",
        ),
    },
)
