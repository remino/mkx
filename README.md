mkx
===

- [Formerly _mksh_](#formerly-mksh)

```
mkx 2.0.0

Usage: mkx [-bhvx] [-i interpreter] scriptfile

Make new shell script executable file from template.

Options:

	-b        Only write a bare script with only the shebang line, without template.
	          If output file already exists, make it executable.
	          Implied when called script is invoked as 'mkx'.

	-h        Show this help screen.

	-i        Specify interpreter in shebang line. Implies -b.

	-v        Show script name and version number.

	-x        Synonym of -b.

```

## Formerly _mksh_

As the name _mksh_ is more commonly associated with the [MirBSD Korn Shell](https://www.mirbsd.org/mksh.htm), this repo has been renamed from _mksh_ to _mkx_. The same goes for the namesake script within.

Invoking `mksh` with `mkx` used to be the equivalent of `mksh -b` or `mksh -i <interpreter>`. But the with this name change, `mkx` was now made to work like `mksh`.
