# mkx

- [Installation](#installation)
  - [Repo Clone](#repo-clone)
  - [Homebrew](#homebrew)
- [Formerly _mksh_](#formerly-mksh)
- [Tests](#tests)

```
mkx 3.0.0

USAGE: mkx [-bhsvx] [-i <interpreter>] [-t <template>] <scriptfile>

Make new shell script executable file from template.

OPTIONS:

	-b        Only write a bare script with only the shebang line, without template.
	          If output file already exists, make it executable.

	-h        Show this help screen.

	-i        Specify interpreter in shebang line. Implies -b.

	-s        Use /bin/sh as interpreter. Implies -b.

	-t        Specify template file. If not specified, uses 'default'.

	-v        Show script name and version number.

```

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
