<div align="center">

# asdf-volta [![Build](https://github.com/chudnyi/asdf-volta/actions/workflows/build.yml/badge.svg)](https://github.com/chudnyi/asdf-volta/actions/workflows/build.yml) [![Lint](https://github.com/chudnyi/asdf-volta/actions/workflows/lint.yml/badge.svg)](https://github.com/chudnyi/asdf-volta/actions/workflows/lint.yml)


[volta](https://docs.volta.sh/guide/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add volta
# or
asdf plugin add volta https://github.com/chudnyi/asdf-volta.git
```

volta:

```shell
# Show all installable versions
asdf list-all volta

# Install specific version
asdf install volta latest

# Set a version globally (on your ~/.tool-versions file)
asdf global volta latest

# Now volta commands are available
volta -v
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/chudnyi/asdf-volta/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Dmitriy Chudnyi](https://github.com/chudnyi/)
