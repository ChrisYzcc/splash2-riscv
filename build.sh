#!/bin/sh
set -eu

SPLASH2DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
export SPLASH2DIR
PLATFORM=native
PROGRAM=barnes
USAGE=normal
ALL="barnes cholesky fft fmm lu_cb lu_ncb ocean_cp ocean_ncp radiosity radix raytrace volrend water_nsquared water_spatial"

usage() {
    cat <<EOF_USAGE
Usage: $0 [-p program|all] [-r] [-u normal|profiling|checkpoint] [-h]
  -p program   Program to build (default: barnes)
  -r           Cross-compile for RISC-V Linux (rv64)
  -u usage     Build mode (default: normal)
  -h           Display this help
EOF_USAGE
}

while getopts "p:ru:h" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        u) USAGE=$OPTARG ;;
        h) usage; exit 0 ;;
        *) usage >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))
[ "$#" -eq 0 ] || { usage >&2; exit 1; }
case " $ALL all " in
    *" $PROGRAM "*) ;;
    *) echo "Unknown program: $PROGRAM" >&2; exit 1 ;;
esac
case "$USAGE" in
    normal|profiling|checkpoint) ;;
    *) echo "Unknown usage mode: $USAGE" >&2; exit 1 ;;
esac
export PLATFORM USAGE

if [ "$PLATFORM" = rv64 ]; then
    CROSS_COMPILE=${CROSS_COMPILE:-riscv64-linux-gnu-}
else
    CROSS_COMPILE=
fi
export CC="${CC:-${CROSS_COMPILE}gcc}"
export AR="${AR:-${CROSS_COMPILE}ar}"
export RANLIB="${RANLIB:-${CROSS_COMPILE}ranlib}"
export HOSTCC="${HOSTCC:-cc}"
export M4="${M4:-m4}"
MAKE=${MAKE:-make}
for tool in "$CC" "$AR" "$RANLIB" "$HOSTCC" "$M4" "$MAKE"; do
    command -v "$tool" >/dev/null 2>&1 || {
        echo "Required tool not found: $tool" >&2
        exit 1
    }
done

# SPLASH-2 uses GNU89 C; the hooks library needs GNU99 instead.
export CFLAGS="-O3 -g -funroll-loops -std=gnu89 ${PORTABILITY_FLAGS:-} ${CFLAGS:-}"
export LDFLAGS="-no-pie -static ${LDFLAGS:-}"
if [ "$USAGE" = profiling ]; then
    CFLAGS="$CFLAGS -DENABLE_PROFILING"
fi
if [ "$USAGE" != normal ]; then
    if [ "$PLATFORM" = rv64 ]; then
        CFLAGS="$CFLAGS -DNEMU"
    fi
    hooks_dir="$SPLASH2DIR/parsec_hooks/build/$PLATFORM/$USAGE"
    # Rebuild from source so changed flags or removed sources cannot leave stale objects.
    rm -rf "$hooks_dir"
    mkdir -p "$hooks_dir/obj"
    cp -R "$SPLASH2DIR/parsec_hooks/src/." "$hooks_dir/obj/"
    "$MAKE" -C "$hooks_dir/obj" CFLAGS="$CFLAGS -std=gnu99"
    "$MAKE" -C "$hooks_dir/obj" install
    CFLAGS="$CFLAGS -I$hooks_dir/include -DENABLE_PARSEC_HOOKS"
    LDFLAGS="$LDFLAGS -L$hooks_dir/lib -lhooks"
fi

build_program() (
    program=$1
    build_dir="$SPLASH2DIR/$program/build/$PLATFORM/$USAGE"
    printf '\nBuilding %s (%s, %s)\n' "$program" "$PLATFORM" "$USAGE"
    rm -rf "$build_dir"
    mkdir -p "$build_dir/obj"
    cp -R "$SPLASH2DIR/$program/src/." "$build_dir/obj/"

    if [ "$program" = volrend ]; then
        "$MAKE" -C "$build_dir/obj/libtiff"
        "$MAKE" -C "$build_dir/obj/libtiff" install
        export CFLAGS="$CFLAGS -Wl,--allow-multiple-definition -I$build_dir/libtiff/include"
        export LDFLAGS="$LDFLAGS -L$build_dir/libtiff/lib -ltiff"
    fi
    "$MAKE" -C "$build_dir/obj"
    "$MAKE" -C "$build_dir/obj" install
)

if [ "$PROGRAM" = all ]; then
    for program in $ALL; do
        build_program "$program"
    done
else
    build_program "$PROGRAM"
fi
printf '\nBuild completed (%s, %s).\n' "$PLATFORM" "$USAGE"
