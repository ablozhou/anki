"""
Dependencies required to build Anki.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def register_repos():
    "Register required dependency repos."

    # bazel
    ##########

    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
        ],
    )

    # rust
    ########

    # native.local_repository(
    #     name = "rules_rust",
    #     path = "../rules_rust",
    # )

    maybe(
        http_archive,
        name = "rules_rust",
        strip_prefix = "rules_rust-f0cdcedc2a68ffdb3048a8510b380e64eb9a1d72",
        urls = [
            "https://github.com/bazelbuild/rules_rust/archive/f0cdcedc2a68ffdb3048a8510b380e64eb9a1d72.zip",
        ],
        sha256 = "cc14a14ca5df2dd52f7d8b1a545f11cb42e9fae7861b4d5b83e883a8cc0f96bd",
    )

    # maybe(
    #     http_archive,
    #     name = "rules_rust",
    #     strip_prefix = "rules_rust-anki-2021-12-20",
    #     urls = [
    #         "https://github.com/ankitects/rules_rust/archive/refs/tags/anki-2021-12-20.zip",
    #     ],
    #     sha256 = "c9300cb1d1eddc5b85d5ced35f4c332b08afc7a439d2b75e696d3282b80677af",
    # )

    # python
    ##########

    # native.local_repository(
    #     name = "rules_python",
    #     path = "../rules_python",
    # )

    maybe(
        http_archive,
        name = "rules_python",
        sha256 = "a30abdfc7126d497a7698c29c46ea9901c6392d6ed315171a6df5ce433aa4502",
        strip_prefix = "rules_python-0.6.0",
        url = "https://github.com/bazelbuild/rules_python/archive/0.6.0.tar.gz",
    )

    # javascript
    ##############

    # maybe(
    #     http_archive,
    #     name = "build_bazel_rules_nodejs",
    #     urls = [
    #         "file:///c:/anki/release.tar.gz",
    #         "file:///Users/dae/Work/code/dtop/release.tar.gz",
    #     ],
    # )

    # when updating, remember to update pinned versions in package.json
    maybe(
        http_archive,
        name = "build_bazel_rules_nodejs",
        sha256 = "2644a66772938db8d8c760334a252f1687455daa7e188073f2d46283f2f6fbb7",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/4.6.2/rules_nodejs-4.6.2.tar.gz"],
    )

    maybe(
        http_archive,
        name = "rules_nodejs",
        sha256 = "f596117040134b9497a1049efe7a785924b4ff22557669780a0fa37e22b827bd",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/4.6.2/rules_nodejs-core-4.6.2.tar.gz"],
    )

    # sass
    ############

    # native.local_repository(
    #     name = "io_bazel_rules_sass",
    #     path = "../rules_sass",
    # )

    maybe(
        http_archive,
        name = "io_bazel_rules_sass",
        strip_prefix = "rules_sass-d0cda2205a6e9706ded30f7dd7d30c82b1301fbe",
        urls = [
            "https://github.com/bazelbuild/rules_sass/archive/d0cda2205a6e9706ded30f7dd7d30c82b1301fbe.zip",
        ],
        sha256 = "640ad20f878a6656968e35f35343359446db91a773224ddf52ae110f1e48bb20",
    )

    # translations
    ################

    core_i18n_repo = "anki-core-i18n"
    core_i18n_commit = "e24ab511f18ae3cd438b429c2f8b55385f3ee00f"
    core_i18n_zip_csum = "ed5e9333e6a4c2285645d68bc9a07ba54b4528caca602e31f1984be6fbd1db5b"

    qtftl_i18n_repo = "anki-desktop-ftl"
    qtftl_i18n_commit = "9443c1f496c278983c59d537a172b2aeefcbd744"
    qtftl_i18n_zip_csum = "3403da11d508011ec3c0014494243b3fc4b9b4cfdaf3673b3917b4c80b53ecc5"

    i18n_build_content = """
filegroup(
    name = "files",
    srcs = glob(["**/*.ftl"]),
    visibility = ["//visibility:public"],
)
exports_files(["l10n.toml"])
"""

    maybe(
        http_archive,
        name = "rslib_ftl",
        build_file_content = i18n_build_content,
        strip_prefix = core_i18n_repo + "-" + core_i18n_commit,
        urls = [
            "https://github.com/ankitects/{}/archive/{}.zip".format(
                core_i18n_repo,
                core_i18n_commit,
            ),
        ],
        sha256 = core_i18n_zip_csum,
    )

    maybe(
        http_archive,
        name = "extra_ftl",
        build_file_content = i18n_build_content,
        strip_prefix = qtftl_i18n_repo + "-" + qtftl_i18n_commit,
        urls = [
            "https://github.com/ankitects/{}/archive/{}.zip".format(
                qtftl_i18n_repo,
                qtftl_i18n_commit,
            ),
        ],
        sha256 = qtftl_i18n_zip_csum,
    )

    # binary bundle
    ################

    maybe(
        http_archive,
        name = "pyoxidizer",
        sha256 = "9f7951473d88c7989dc80199146f82020226a3b2425474fd33b6bcbd8fdd1b1c",
        urls = [
            # when changing this, the commit hash needs to be updated in qt/bundle/Cargo.toml
            "https://github.com/ankitects/PyOxidizer/archive/refs/tags/anki-2021-12-08.tar.gz",
        ],
        strip_prefix = "PyOxidizer-anki-2021-12-08",
        build_file_content = " ",
    )

    maybe(
        http_archive,
        name = "bundle_extras_linux_amd64",
        build_file_content = " ",
        urls = [
            "https://github.com/ankitects/anki-bundle-extras/releases/download/anki-2022-02-09/qt-plugins-linux-amd64.tar.gz",
        ],
        sha256 = "cbfb41fb750ae19b381f8137bd307e1167fdc68420052977f6e1887537a131b0",
    )

    maybe(
        http_archive,
        name = "audio_win_amd64",
        build_file_content = " ",
        urls = [
            "https://github.com/ankitects/anki-bundle-extras/releases/download/anki-2022-02-09/audio-win-amd64.tar.gz",
        ],
        sha256 = "0815a601baba05e03bc36b568cdc2332b1cf4aa17125fc33c69de125f8dd687f",
    )

    maybe(
        http_archive,
        name = "protobuf_wheel_mac_arm64",
        build_file_content = " ",
        urls = [
            "https://github.com/ankitects/anki-bundle-extras/releases/download/anki-2022-02-09/protobuf-wheel-mac-arm64.tar",
        ],
        sha256 = "401d1cd6d949af463b3945f0d5dc887185b27fa5478cb6847bf94f680ea797b4",
    )

    maybe(
        http_archive,
        name = "audio_mac_amd64",
        build_file_content = " ",
        urls = [
            "https://github.com/ankitects/anki-bundle-extras/releases/download/anki-2022-05-26/audio-mac-amd64.tar.gz",
        ],
        sha256 = "ecbb3c878805cdd58b1a0b8e3fd8c753b8ce3ad36c8b5904a79111f9db29ff42",
    )

    maybe(
        http_archive,
        name = "audio_mac_arm64",
        build_file_content = " ",
        urls = [
            "https://github.com/ankitects/anki-bundle-extras/releases/download/anki-2022-05-26/audio-mac-arm64.tar.gz",
        ],
        sha256 = "f6c4af9be59ae1c82a16f5c6307f13cbf31b49ad7b69ce1cb6e0e7b403cfdb8f",
    )

    maybe(
        http_archive,
        name = "pyqt6.3_mac_bundle_amd64",
        build_file_content = " ",
        urls = [
            "https://github.com/ankitects/anki-bundle-extras/releases/download/anki-2022-09-21/pyqt6.3-mac-amd64.tar.gz",
        ],
        sha256 = "252922cfc2c5848d50ef90a903eed43545ef66b189db791bbe621704ef58bcf1",
    )

    maybe(
        http_archive,
        name = "pyqt6.3_mac_bundle_arm64",
        build_file_content = " ",
        urls = [
            "https://github.com/ankitects/anki-bundle-extras/releases/download/anki-2022-09-21/pyqt6.3-mac-arm64.tar.gz",
        ],
        sha256 = "5c30f6952b498bb0df31ca23bd3b35e09ea732df528f70df454580b495ecbdfd",
    )

    maybe(
        http_archive,
        name = "pyqt5.14_mac_bundle_amd64",
        build_file_content = " ",
        urls = [
            "https://github.com/ankitects/anki-bundle-extras/releases/download/anki-2022-02-09/pyqt5.14-mac-amd64.tar.gz",
        ],
        sha256 = "474951bed79ddb9570ee4c5a6079041772551ea77e77171d9e33d6f5e7877ec1",
    )
