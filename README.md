mksh
====

```
Usage: mksh scriptfile

Make new shell script executable file from template.

Available options:

	-b        Only write a bare script with only the shebang line, without template.
	          If output file already exists, make it executable.
	          Implied when called script is invoked as 'mkx'.

	-h        Show this help screen.

	-i        Specify interpreter in shebang line. Implies -b.

	-v        Show script name and version number.

	-x        Synonym of -b.

```

