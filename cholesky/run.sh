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

INPUT_FILE="${RUN_DIR}/tk14.O"

echo "Running Cholesky..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/cholesky -p${NTHREADS} < ${INPUT_FILE}
cd ${BENCH_DIR}