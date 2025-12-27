BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

echo "Running radix..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/radix -p${NTHREADS} -r1024 -n262144 -m524288
cd ${BENCH_DIR}