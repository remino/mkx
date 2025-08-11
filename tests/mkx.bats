#!/usr/bin/env bats

teardown() {
	if [ -n "$OUTPUT_FILE" ]; then
		rm -f "$OUTPUT_FILE"
	fi

	if [ -n "$OUTPUT_DIR" ]; then
		rm -rf "$OUTPUT_DIR"
	fi
}

@test "shows version" {
	local version="$(grep VERSION ./mkx | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')"

	run ./mkx -v

	[ "$status" -eq 0 ]
	[ "$output" = "mkx $version" ]
}

@test "shows help" {
	run ./mkx -h

	[ "$status" -eq 0 ]
	[ "${output:0:4}" = "mkx " ]
}

@test "generates script from default template" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[ "$(head -n 1 "$OUTPUT_FILE")" = "#!/usr/bin/env bash" ]
	[ "$(wc -l <"$OUTPUT_FILE")" -gt 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}

@test "generates script from custom template" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx -t default "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[ "$(head -n 1 "$OUTPUT_FILE")" = "#!/usr/bin/env bash" ]
	[ "$(wc -l <"$OUTPUT_FILE")" -gt 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}

@test "searches for template in template directory adjacent to script" {
	OUTPUT_DIR="$(mktemp -d)"
	NEW_SCRIPT="$OUTPUT_DIR/script.sh"

	cp ./mkx "$OUTPUT_DIR/mkx"
	mkdir -p "$OUTPUT_DIR/templates"
	cp -r ./lib "$OUTPUT_DIR/lib"
	cp ./templates/default.mustache "$OUTPUT_DIR/templates/custom.mustache"
	run "$OUTPUT_DIR/mkx" -t custom "$NEW_SCRIPT"

	[ "$status" -eq 0 ]
	[ "$(head -n 1 "$NEW_SCRIPT")" = "#!/usr/bin/env bash" ]
	[ "$(wc -l <"$NEW_SCRIPT")" -gt 2 ]
	[ -x "$NEW_SCRIPT" ]
	[ -f "$NEW_SCRIPT" ]
}

@test "searches for template in system share templates directory" {
	OUTPUT_DIR="$(mktemp -d)"
	NEW_SCRIPT="$OUTPUT_DIR/script.sh"

	mkdir -p "$OUTPUT_DIR/bin"
	mkdir -p "$OUTPUT_DIR/share/mkx/templates"
	cp ./mkx "$OUTPUT_DIR/bin/mkx"
	cp -r ./lib "$OUTPUT_DIR/lib"
	cp ./templates/default.mustache "$OUTPUT_DIR/share/mkx/templates/custom.mustache"
	run "$OUTPUT_DIR/bin/mkx" -t custom "$NEW_SCRIPT"

	[ "$status" -eq 0 ]
	[ "$(head -n 1 "$NEW_SCRIPT")" = "#!/usr/bin/env bash" ]
	[ "$(wc -l <"$NEW_SCRIPT")" -gt 2 ]
	[ -x "$NEW_SCRIPT" ]
	[ -f "$NEW_SCRIPT" ]
}

@test "searches for template in custom directory" {
	OUTPUT_DIR="$(mktemp -d)"
	NEW_SCRIPT="$OUTPUT_DIR/script.sh"
	MKX_TEMPLATES_DIR="$OUTPUT_DIR/my_templates"

	mkdir -p "$OUTPUT_DIR/bin"
	mkdir -p "$MKX_TEMPLATES_DIR"
	cp ./mkx "$OUTPUT_DIR/bin/mkx"
	cp -r ./lib "$OUTPUT_DIR/lib"
	cp ./templates/default.mustache "$MKX_TEMPLATES_DIR/custom.mustache"

	export MKX_TEMPLATES_DIR
	run "$OUTPUT_DIR/bin/mkx" -t custom "$NEW_SCRIPT"

	[ "$status" -eq 0 ]
	[ "$(head -n 1 "$NEW_SCRIPT")" = "#!/usr/bin/env bash" ]
	[ "$(wc -l <"$NEW_SCRIPT")" -gt 2 ]
	[ -x "$NEW_SCRIPT" ]
	[ -f "$NEW_SCRIPT" ]
}

@test "fails to generate script from non-existing template" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx -t non_existing_template "$OUTPUT_FILE"

	[ "$status" -eq 18 ]
	[ ! -f "$OUTPUT_FILE" ]
}

@test "generates bare script" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx -b "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[ "$(head -n 1 "$OUTPUT_FILE")" = "#!/usr/bin/env bash" ]
	[ "$(wc -l <"$OUTPUT_FILE")" -eq 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}

@test "generates base script with /bin/sh as interpreter" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx -s "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[ "$(head -n 1 "$OUTPUT_FILE")" = "#!/bin/sh" ]
	[ "$(wc -l <"$OUTPUT_FILE")" -eq 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}

@test "overwrites existing file when -f is set" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx -b "$OUTPUT_FILE"
	run ./mkx -b -s -f "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[ "$(head -n 1 "$OUTPUT_FILE")" = "#!/bin/sh" ]
	[ "$(wc -l <"$OUTPUT_FILE")" -eq 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}

@test "overwrites existing file when user confirms override" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx -b "$OUTPUT_FILE"
	run bash -c 'printf "y\n" | ./mkx -b -s "$0"' "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[[ "$output" == *"File exists. Overwrite?"* ]]
	[[ "$output" == *"Overwriting..."* ]]
	[ "$(head -n 1 "$OUTPUT_FILE")" = "#!/bin/sh" ]
	[ "$(wc -l <"$OUTPUT_FILE")" -eq 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}

@test "cancels overwrite when user declines" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx -b -s "$OUTPUT_FILE"
	run bash -c 'printf "n\n" | ./mkx -b "$0"' "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[[ "$output" == *"File exists. Overwrite?"* ]]
	[[ "$output" == *"Cancelled."* ]]
	[ "$(head -n 1 "$OUTPUT_FILE")" = "#!/bin/sh" ]
	[ "$(wc -l <"$OUTPUT_FILE")" -eq 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}

@test "makes existing file executable with -x" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	touch "$OUTPUT_FILE"
	chmod -w "$OUTPUT_FILE"
	run ./mkx -x "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[ -x "$OUTPUT_FILE" ]
}

@test "shows help when an invalid option is set" {
	run bash -c './mkx -h 2>/dev/null'
	local help="$output"

	run bash -c './mkx -t 2>/dev/null'
	local template_help="$output"

	[ "$status" -eq 16 ]
	[ "$help" = "$template_help" ]
}

@test "exits with the right exit code" {
	run ./mkx -h
	[ "$status" -eq 0 ]

	run ./mkx -t non_existing_template
	[ "$status" -eq 16 ]

	run ./mkx
	[ "$status" -eq 0 ]

	run ./mkx -b
	[ "$status" -eq 16 ]

	run ./mkx -s
	[ "$status" -eq 16 ]
}
