load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def google_repos():
    http_archive(
        name = "boringssl",
        # Use github mirror instead of https://boringssl.googlesource.com/boringssl
        # to obtain a boringssl archive with consistent sha256
        sha256 = "534fa658bd845fd974b50b10f444d392dfd0d93768c4a51b61263fd37d851c40",
        strip_prefix = "boringssl-b9232f9e27e5668bc0414879dcdedb2a59ea75f2",
        urls = [
            "https://storage.googleapis.com/grpc-bazel-mirror/github.com/google/boringssl/archive/b9232f9e27e5668bc0414879dcdedb2a59ea75f2.tar.gz",
            "https://github.com/google/boringssl/archive/b9232f9e27e5668bc0414879dcdedb2a59ea75f2.tar.gz",
        ],
        patches = [Label("//third_party/google:boringssl-windows-constraints.patch")],
        patch_args = ["-p1"],
    )
    http_archive(
        name = "com_googlesource_code_re2",
        strip_prefix = "re2-main",
        urls = ["https://github.com/google/re2/archive/main.zip"],
    )

    # Googletest https://google.github.io/googletest/
    http_archive(
        name = "com_google_googletest",
        urls = ["https://github.com/google/googletest/archive/main.zip"],
        strip_prefix = "googletest-main",
    )

    # Abseil https://abseil.io/
    http_archive(
        name = "com_google_absl",
        urls = ["https://github.com/abseil/abseil-cpp/archive/master.zip"],
        strip_prefix = "abseil-cpp-master",
    )

    # Protobuf toolchain
    http_archive(
        name = "com_google_protobuf",
        urls = [
            "https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protobuf-all-3.17.3.tar.gz",
            #"https://github.com/protocolbuffers/protobuf/archive/main.zip",
        ],
        #strip_prefix = "protobuf-main",
        strip_prefix = "protobuf-3.17.3",
    )

    # gRPC
    http_archive(
        name = "com_github_grpc_grpc",
        sha256 = "ec19657a677d49af59aa806ec299c070c882986c9fcc022b1c22c2a3caf01bcd",
        strip_prefix = "grpc-1.45.0",
        urls = ["https://github.com/grpc/grpc/archive/refs/tags/v1.45.0.tar.gz"],
        patches = [Label("//third_party/google:grpc-windows-constraints.patch")],
        patch_args = ["-p1"],
    )
