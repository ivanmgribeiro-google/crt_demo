# Compiler Repository Toolkit Demonstration

This repository demonstrates how to use the
[Compiler Repository Toolkit](https://github.com/cfrantz/crt).

## Configuration

- [`.bazelrc`](.bazelrc) - In order to enable toolchain resolution,
  this file must contain the following line:
  ```
  build --incompatible_enable_cc_toolchain_resolution
  ```

- [`WORKSPACE.bazel`](WORKSPACE.bazel) - Your workspace file needs to
  load the `crt` repository and its dependencies.  It must also register
  the toolchains you want to use.
  ```python
  load("@crt//config:registration.bzl", "crt_register_toolchains")
  crt_register_toolchains(
      # Choose the toolchains you want:
      arm = True,
      win64 = True,
  )

  ```

- Building software is controlled by constraints.  `cc_library` and
  `cc_binaries` can be restricted to certain platforms by use of the
  `target_compatible_with` attribute.  In order to build software
  targeted at a particular platform, you can invoke `bazel` with the
  `--platforms` flag:

  ```console
  bazel build //some:label --platforms=@crt//platforms/arm:cortex_m
  ```

- Platform targets can also be defined using a _transition_.  Transitions
  cause bazel to evaluate the dependency graph _as if_ a certain configuration
  were defined.  For example, the `target_platform` rule evaluates the
  build graph as if `--platforms` were set to a particular value.

  For example, to build a target for `cortex_m`:
  ```python
  target_platform(
      name = "rule-name",
      platform = "@crt//platforms/arm:cortex_m",
      target = "label to a binary artifact",
  )
  ```

- Targets can be executed under a emulation with the `runner` rule.  The
  `runner` rule is also a transition rule: it declares the target platform
  and the execution configuration for that platform.

  For example:
  ```python
  runner(
      name = "demo",
      binary = ":sieve",
      platform = "@crt//platforms/arm:cortex_m",
      exec_config = "@crt//platforms/arm:qemu",
  )
  ```
