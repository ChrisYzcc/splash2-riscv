BENCH_DIR="$(pwd)"
RUN_DIR=${BENCH_DIR}/build/${PLATFORM}/run

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

echo "Running ocean_ncp..."
cd ${RUN_DIR}
${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/ocean_ncp -n258 -p${NTHREADS} -e1e-07 -r20000 -t28800
cd ${BENCH_DIR}