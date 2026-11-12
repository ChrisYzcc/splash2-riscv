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

# Generate input file
INPUT_FILE="${RUN_DIR}/input"
INPUT_TEMPLATE="${RUN_DIR}/input.template"
echo "Generating input file ${INPUT_FILE} ..."
sed "s/NUMPROCS/$NTHREADS/g" "${INPUT_TEMPLATE}" > "${INPUT_FILE}"
echo

echo "Running water_nsquared..."
cd "${RUN_DIR}"
"${BENCH_DIR}/build/${PLATFORM}/${USAGE}/bin/water_nsquared" ${NTHREADS} < "${INPUT_FILE}"
cd "${BENCH_DIR}"
