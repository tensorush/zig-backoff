# zig-backoff

[![CI][ci-shd]][ci-url]
[![LC][lc-shd]][lc-url]

### Zig implementation of [exponential backoff algorithm](https://en.wikipedia.org/wiki/Exponential_backoff).

### :rocket: Usage

- Add `backoff` dependency to `build.zig.zon`.

```sh
zig fetch --save https://github.com/tensorush/zig-backoff/archive/<git_tag_or_commit_hash>.tar.gz
```

- Use `backoff` dependency in `build.zig`.

```zig
const backoff_dep = b.dependency("backoff", .{
    .target = target,
    .optimize = optimize,
});
const backoff_mod = backoff_dep.module("Backoff");
<compile>.root_module.addImport("Backoff", backoff_mod);
```

<!-- MARKDOWN LINKS -->

[ci-shd]: https://img.shields.io/github/actions/workflow/status/tensorush/zig-backoff/ci.yaml?branch=main&style=for-the-badge&logo=github&label=CI&labelColor=black
[ci-url]: https://github.com/tensorush/zig-backoff/blob/main/.github/workflows/ci.yaml
[lc-shd]: https://img.shields.io/github/license/tensorush/zig-backoff.svg?style=for-the-badge&labelColor=black
[lc-url]: https://github.com/tensorush/zig-backoff/blob/main/LICENSE
