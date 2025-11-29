BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

echo "Running lu_cb..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/bin/lu_cb -p${NTHREADS} -n512 -b16
cd ${BENCH_DIR}