BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

# Get input files
echo "Extracting input files ..."
tar -xvf ${BENCH_DIR}/inputs/input_test.tar -C ${RUN_DIR}
echo "Completed extracting input files."
echo

ARGS="${NTHREADS} head-scaleddown4"

echo "Running Volrend..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/volrend ${ARGS}
cd ${BENCH_DIR}