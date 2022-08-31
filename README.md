mksh
====

- [mkx](#mkx)

```
mksh 1.2.1

Usage: mksh [-bhvx] [-i interpreter] scriptfile

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

## mkx

`mksh` can be invoked as `mkx` and is aliased as such in this repo. Invoking it as `mkx` is like calling `mksh -b`, and `mkx outputfile interpreter` is like `mksh -i interpreter outputfile`.

```
mksh 1.2.1

Usage: mkx [-hv] scriptfile [interpreter]

Make new base shell script executable file.
If the file already exists, it will make it executable.

When not specified, interpreter defaults to '/bin/sh'.

Options:

	-h        Show this help screen.
	-v        Show script name and version number.

```
