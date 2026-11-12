#!/bin/sh
set -eu

SPLASH2DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ALL="barnes cholesky fft fmm lu_cb lu_ncb ocean_cp ocean_ncp radiosity radix raytrace volrend water_nsquared water_spatial"
INPUTS=test
USAGE=normal

usage() {
    echo "Usage: $0 [-i test] [-u normal|profiling|checkpoint] [-h]"
}
while getopts "i:u:h" opt; do
    case "$opt" in
        i) INPUTS=$OPTARG ;;
        u) USAGE=$OPTARG ;;
        h) usage; exit 0 ;;
        *) usage >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))
[ "$#" -eq 0 ] || { usage >&2; exit 1; }
case "$USAGE" in
    normal|profiling|checkpoint) ;;
    *) echo "Unknown usage mode: $USAGE" >&2; exit 1 ;;
esac
[ "$INPUTS" = test ] || { echo "Unknown inputs: $INPUTS" >&2; exit 1; }

# Check everything before replacing an existing package.
for program in $ALL; do
    binary="$SPLASH2DIR/$program/build/rv64/$USAGE/bin/$program"
    [ -x "$binary" ] || {
        echo "Binary not found: $binary. Run ./build.sh -r -p all -u $USAGE first." >&2
        exit 1
    }
    if [ -d "$SPLASH2DIR/$program/inputs" ]; then
        [ -f "$SPLASH2DIR/$program/inputs/input_test.tar.gz" ] || {
            echo "Missing test inputs for $program" >&2
            exit 1
        }
    fi
done

pack_dir="$SPLASH2DIR/splash2_rv_pack"
rm -rf "$pack_dir"
mkdir -p "$pack_dir"
for program in $ALL; do
    target="$pack_dir/$program"
    mkdir -p "$target/build/rv64/$USAGE/bin"
    cp "$SPLASH2DIR/$program/build/rv64/$USAGE/bin/$program" "$target/build/rv64/$USAGE/bin/"
    if [ -d "$SPLASH2DIR/$program/inputs" ]; then
        mkdir -p "$target/inputs"
        cp "$SPLASH2DIR/$program/inputs/input_test.tar.gz" "$target/inputs/"
    fi
    cp "$SPLASH2DIR/$program/run.sh" "$target/"
done
cp "$SPLASH2DIR/run.sh" "$pack_dir/"
printf 'Package created: %s (mode: %s)\n' "$pack_dir" "$USAGE"
