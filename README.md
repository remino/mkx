# mkx

Make new executable shell script file from template.

Rémino Rem <https://remino.net/>, 2022-2025, ISC licence.

- [Installation](#installation)
  - [Repo Clone](#repo-clone)
  - [Homebrew](#homebrew)
- [Formerly _mksh_](#formerly-mksh)
- [Tests](#tests)

## Installation

### Repo Clone

```bash
git clone https://github.com/remino/mkx
cd mkx
./mkx
```

### Homebrew

```bash
brew install remino/remino/mkx
./mkx
```

## Usage

See the help screen or the manual page for details on how to use `mkx`:

```sh
# Help screen
mkx -h
# Manual page
man mkx
```

## Formerly _mksh_

As the name _mksh_ is more commonly associated with the
[MirBSD Korn Shell](https://www.mirbsd.org/mksh.htm), this repo has been renamed
from _mksh_ to _mkx_. The same goes for the namesake script within.

Invoking `mksh` with `mkx` used to be the equivalent of `mksh -b` or
`mksh -i <interpreter>`. But the with this name change, `mkx` was now made to
work like `mksh`.

## Tests

Tests are written in [Bats](https://bats-core.readthedocs.io/en/stable/).

To run them, install Bats and run `bats tests` in the project root directory.
