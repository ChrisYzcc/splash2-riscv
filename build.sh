export SPLASH2DIR=$(pwd)

PLATFORM=native
PROGRAM=barnes
ENABLE_CHECKPOINT=false

ALL="barnes cholesky fft fmm lu_cb lu_ncb ocean_cp ocean_ncp radiosity radix raytrace volrend water_nsquared water_spatial"

while getopts "p:rch" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        c) ENABLE_CHECKPOINT=true ;;
        h) echo "Usage: $0 [-p program] [-r] [-h]"
           echo "  -p program : specify the program to build, default: barnes"
           echo "  -r          : set platform to rv64"
           echo "  -c          : enable checkpoint"
           echo "  -h          : display this help message"
           exit 0 ;;
    esac
done

# Arguments to use
export CFLAGS=" -O3 -g -funroll-loops ${PORTABILITY_FLAGS}"
export CXXFLAGS="-O3 -g -funroll-loops -fpermissive -fno-exceptions ${PORTABILITY_FLAGS} -std=c++98"
export CPPFLAGS=""
export CXXCPPFLAGS=""
export LDFLAGS="-L${CC_HOME}/lib64 -L${CC_HOME}/lib -no-pie"
export LIBS=""
export EXTRA_LIBS=""

USE_STATIC=yes
if [ "$USE_STATIC" = "yes" ]; then
    export CFLAGS="${CFLAGS} -static"
    export CXXFLAGS="${CXXCPPFLAGS} -static"
    export LDFLAGS="${LDFLAGS} -static"
fi

# RISC-V Cross Compile Prefix
if [ "$PLATFORM" = "rv64" ]; then
    CROSS_COMPILE_PREFIX=riscv64-linux-gnu-
else
    CROSS_COMPILE_PREFIX=
fi

# Compilers and preprocessors
CC_HOME=/usr/bin
export CC="${CC_HOME}/${CROSS_COMPILE_PREFIX}gcc"
export CXX="${CC_HOME}/${CROSS_COMPILE_PREFIX}g++"
export CPP="${CC_HOME}/${CROSS_COMPILE_PREFIX}cpp"

# GNU Binutils
BINUTIL_HOME=/usr/bin
export LD="${BINUTIL_HOME}/${CROSS_COMPILE_PREFIX}ld"
export NM="${BINUTIL_HOME}/${CROSS_COMPILE_PREFIX}nm"
export STRIP="${BINUTIL_HOME}/${CROSS_COMPILE_PREFIX}strip"
export AR="${CC_HOME}/${CROSS_COMPILE_PREFIX}ar"
export RANLIB="${CC_HOME}/${CROSS_COMPILE_PREFIX}ranlib"

# GNU Tools
export M4=/usr/bin/m4
export MAKE=/usr/bin/make

export PLATFORM
export VERSION

# Build parsec_hook for checkpoint
if [ "${ENABLE_CHECKPOINT}" = "true" ]; then
    echo "============================================================================"
    echo "  Building Target : parsec_hooks (for checkpoint)"
    echo "  Platform        : ${PLATFORM}"
    echo "============================================================================"

    if [ ! -d "${SPLASH2DIR}/parsec_hooks/build/${PLATFORM}/obj" ]; then
        mkdir -p ${SPLASH2DIR}/parsec_hooks/build/${PLATFORM}/obj
        cp -r ${SPLASH2DIR}/parsec_hooks/src/* ${SPLASH2DIR}/parsec_hooks/build/${PLATFORM}/obj
        make -C ${SPLASH2DIR}/parsec_hooks/build/${PLATFORM}/obj
        make -C ${SPLASH2DIR}/parsec_hooks/build/${PLATFORM}/obj install

        if [ $? -ne 0 ]; then
            echo -e "\033[31m[ERROR] Build failed for parsec_hooks!\033[0m"
            exit 1
        fi
    else
        echo "  parsec_hooks already built for ${PLATFORM}, skipping."
    fi
    export CFLAGS="${CFLAGS} -I${SPLASH2DIR}/parsec_hooks/build/${PLATFORM}/include"
    export CXXFLAGS="${CXXFLAGS} -I${SPLASH2DIR}/parsec_hooks/build/${PLATFORM}/include"
    export LDFLAGS="${LDFLAGS} -L${SPLASH2DIR}/parsec_hooks/build/${PLATFORM}/lib -lhooks"
    echo "============================================================================"
    echo
fi

if [ "${PROGRAM}" = "all" ]; then
    FAILED_LIST=""
    for prog in $ALL; do
        echo "============================================================================"
        echo "  Building Target : ${prog}"
        echo "  Platform        : ${PLATFORM}"
        echo "============================================================================"
        cd ${prog}
        ./build.sh
        if [ $? -ne 0 ]; then
            echo -e "\033[31m[ERROR] Build failed for ${prog}!\033[0m"
            FAILED_LIST="$FAILED_LIST $prog"
        fi
        cd ${SPLASH2DIR}
    done

    echo "============================================================================"
    echo "  Build of all programs completed."
    echo "============================================================================"
    if [ -n "$FAILED_LIST" ]; then
        echo -e "\033[31m[ERROR] The following programs failed to build:$FAILED_LIST\033[0m"
        exit 1
    fi
    exit 0
else
    echo "============================================================================"
    echo "  Building Target : ${PROGRAM}"
    echo "  Platform        : ${PLATFORM}"
    echo "============================================================================"


    cd ${PROGRAM}
    ./build.sh
    if [ $? -ne 0 ]; then
        echo -e "\033[31m[ERROR] Build failed for ${PROGRAM}!\033[0m"
        cd ..
        exit 1
    fi
    cd ${SPLASH2DIR}

    echo "============================================================================"
    echo "  Build of ${PROGRAM} completed."
    echo "============================================================================"
fi