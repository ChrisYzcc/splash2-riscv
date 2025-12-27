BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

echo "Running radiosity..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/radiosity -batch -room -p ${NTHREADS}
cd ${BENCH_DIR}