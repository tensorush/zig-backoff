## :lizard: :raised_back_of_hand: **zig backoff**

[![CI][ci-shd]][ci-url]
[![LC][lc-shd]][lc-url]

### Zig implementation of the [exponential backoff algorithm](https://en.wikipedia.org/wiki/Exponential_backoff).

### :rocket: Usage

1. Add `backoff` as a dependency in your `build.zig.zon`.

    <details>

    <summary><code>build.zig.zon</code> example</summary>

    ```zig
    .{
        .name = "<name_of_your_package>",
        .version = "<version_of_your_package>",
        .dependencies = .{
            .backoff = .{
                .url = "https://github.com/tensorush/zig-backoff/archive/<git_tag_or_commit_hash>.tar.gz",
                .hash = "<package_hash>",
            },
        },
    }
    ```

    Set `<package_hash>` to `12200000000000000000000000000000000000000000000000000000000000000000`, and Zig will provide the correct found value in an error message.

    </details>

2. Add `backoff` as a module in your `build.zig`.

    <details>

    <summary><code>build.zig</code> example</summary>

    ```zig
    const backoff = b.dependency("backoff", .{});
    exe.addModule("Backoff", backoff.module("Backoff"));
    ```

    </details>

<!-- MARKDOWN LINKS -->

[ci-shd]: https://img.shields.io/github/actions/workflow/status/tensorush/zig-backoff/ci.yaml?branch=main&style=for-the-badge&logo=github&label=CI&labelColor=black
[ci-url]: https://github.com/tensorush/zig-backoff/blob/main/.github/workflows/ci.yaml
[lc-shd]: https://img.shields.io/github/license/tensorush/zig-backoff.svg?style=for-the-badge&labelColor=black
[lc-url]: https://github.com/tensorush/zig-backoff/blob/main/LICENSE.md
