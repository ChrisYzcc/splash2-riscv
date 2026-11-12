#!/bin/sh
set -eu

SPLASH2DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PLATFORM=native
PROGRAM=barnes
NTHREADS=1
USAGE=normal
ALL="barnes cholesky fft fmm lu_cb lu_ncb ocean_cp ocean_ncp radiosity radix raytrace volrend water_nsquared water_spatial"

usage() {
    cat <<EOF_USAGE
Usage: $0 [-p program] [-r] [-n threads] [-u normal|profiling|checkpoint] [-h]
  -p program   Program to run (default: barnes)
  -r           Run the rv64 binary on a RISC-V Linux machine
  -n threads   Number of threads (default: 1)
  -u usage     Build mode (default: normal)
  -h           Display this help
EOF_USAGE
}

while getopts "p:rn:u:h" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        n) NTHREADS=$OPTARG ;;
        u) USAGE=$OPTARG ;;
        h) usage; exit 0 ;;
        *) usage >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))
[ "$#" -eq 0 ] || { usage >&2; exit 1; }
case " $ALL " in
    *" $PROGRAM "*) ;;
    *) echo "Unknown program: $PROGRAM" >&2; exit 1 ;;
esac
case "$USAGE" in
    normal|profiling|checkpoint) ;;
    *) echo "Unknown usage mode: $USAGE" >&2; exit 1 ;;
esac
case "$NTHREADS" in
    ''|*[!0-9]*|0*) echo "Thread count must be a positive integer: $NTHREADS" >&2; exit 1 ;;
esac
binary="$SPLASH2DIR/$PROGRAM/build/$PLATFORM/$USAGE/bin/$PROGRAM"
[ -x "$binary" ] || {
    echo "Binary not found: $binary. Build this program and mode first." >&2
    exit 1
}
export PLATFORM NTHREADS USAGE
printf 'Running %s (%s, %s, %s threads)\n' "$PROGRAM" "$PLATFORM" "$USAGE" "$NTHREADS"
cd "$SPLASH2DIR/$PROGRAM"
exec ./run.sh
