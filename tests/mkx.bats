#!/usr/bin/env bats

teardown() {
	[ -z "$OUTPUT_FILE" ] && return 0
	[ ! -f "$OUTPUT_FILE" ] && return 0
	rm -f "$OUTPUT_FILE"
}

@test "shows version" {
	local version="$( grep VERSION ./mkx | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' )"

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
	[ "$( head -n 1 "$OUTPUT_FILE" )" = "#!/usr/bin/env bash" ]
	[ "$( wc -l < "$OUTPUT_FILE" )" -gt 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}

@test "generates script from custom template" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx -t default "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[ "$( head -n 1 "$OUTPUT_FILE" )" = "#!/usr/bin/env bash" ]
	[ "$( wc -l < "$OUTPUT_FILE" )" -gt 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}

@test "generates bare script" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx -b "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[ "$( head -n 1 "$OUTPUT_FILE" )" = "#!/usr/bin/env bash" ]
	[ "$( wc -l < "$OUTPUT_FILE" )" -eq 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}

@test "generates base script with /bin/sh as interpreter" {
	OUTPUT_FILE="$(mktemp)"
	rm -f "$OUTPUT_FILE"
	run ./mkx -s "$OUTPUT_FILE"

	[ "$status" -eq 0 ]
	[ "$( head -n 1 "$OUTPUT_FILE" )" = "#!/bin/sh" ]
	[ "$( wc -l < "$OUTPUT_FILE" )" -eq 2 ]
	[ -x "$OUTPUT_FILE" ]
	[ -f "$OUTPUT_FILE" ]
}
