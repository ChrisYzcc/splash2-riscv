PLATFORM=native
PROGRAM=barnes
NTHREADS=1
USAGE="normal"

while getopts "p:rhn:u:" opt; do
    case "$opt" in
        p) PROGRAM=$OPTARG ;;
        r) PLATFORM=rv64 ;;
        n) NTHREADS=$OPTARG ;;
        u) USAGE=$OPTARG ;;
        h) echo "Usage: $0 [-p program] [-r] [-v version] [-h]"
           echo "  -p program   : specify the program to run, default: barnes"
           echo "  -r           : set platform to rv64"
           echo "  -n threads   : specify the number of threads, default: 1"
           echo "  -u usage     : set usage: normal, profiling, checkpoint. default: normal \\n \
                    normal: normal execution; \\n \
                    profiling: for profiling; \\n \
                    checkpoint: for checkpointing."
           echo "  -h           : display this help message"
           exit 0 ;;
    esac
done

# Check USAGE mode
if [ "$USAGE" != "normal" ] && [ "$USAGE" != "profiling" ] && [ "$USAGE" != "checkpoint" ]; then
    echo "\033[31m[ERROR] Unknown usage mode: $USAGE\033[0m"
    exit 1
fi

export PLATFORM
export NTHREADS
export USAGE

echo "============================================================================"
echo "  Running Target  : ${PROGRAM}"
echo "  Threads         : ${NTHREADS}"
echo "  Platform        : ${PLATFORM}"
echo "  USAGE           : ${USAGE}"
echo "============================================================================"

cd ${PROGRAM}
./run.sh
cd ..

echo "============================================================================"
echo "  Finished Running Target : ${PROGRAM}"
echo "============================================================================"