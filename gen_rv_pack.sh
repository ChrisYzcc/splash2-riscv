SPLASH2DIR=$(pwd)

ALL="barnes cholesky fft fmm lu_cb lu_ncb ocean_cp ocean_ncp radiosity radix raytrace volrend water_nsquared water_spatial"

if [ ! -d "${SPLASH2DIR}/splash2_rv_pack" ]; then
    mkdir -p ${SPLASH2DIR}/splash2_rv_pack
else
    rm -rf ${SPLASH2DIR}/splash2_rv_pack/*
fi

for PROGRAM in $ALL; do
    mkdir -p ${SPLASH2DIR}/splash2_rv_pack/${PROGRAM}

    mkdir -p ${SPLASH2DIR}/splash2_rv_pack/${PROGRAM}/build/rv64
    cp -r ${SPLASH2DIR}/${PROGRAM}/build/rv64/bin ${SPLASH2DIR}/splash2_rv_pack/${PROGRAM}/build/rv64/bin
    if [ -d "${SPLASH2DIR}/${PROGRAM}/inputs" ]; then
        cp -r ${SPLASH2DIR}/${PROGRAM}/inputs ${SPLASH2DIR}/splash2_rv_pack/${PROGRAM}/inputs
    fi
    cp -r ${SPLASH2DIR}/${PROGRAM}/run.sh ${SPLASH2DIR}/splash2_rv_pack/${PROGRAM}/
done

cp -r ${SPLASH2DIR}/run.sh ${SPLASH2DIR}/splash2_rv_pack/
sed -i 's|^\./run\.sh$|/bin/sh ./run.sh|' ${SPLASH2DIR}/splash2_rv_pack/run.sh