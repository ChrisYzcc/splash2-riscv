#!/bin/sh
set -eu

BENCH_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
RUN_DIR="${BENCH_DIR}/build/${PLATFORM}/run"

if [ ! -d "${RUN_DIR}" ]; then
    mkdir -p "${RUN_DIR}"
else
    rm -rf "${RUN_DIR}"/*
fi

# Get input files
echo "Extracting input files ..."
tar -xzf "${BENCH_DIR}/inputs/input_test.tar.gz" -C "${RUN_DIR}"
echo "Completed extracting input files."
echo

ARGS="-s -p${NTHREADS} teapot.env"

echo "Running Raytrace..."
cd "${RUN_DIR}"
"${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/raytrace" ${ARGS}
cd "${BENCH_DIR}"
