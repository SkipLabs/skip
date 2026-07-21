#!/usr/bin/env bash

# intentionally using the same seed as within pg-tpch
RANDOM_SEED=1433771997
SIZING=1
(
        cd queries
        tpcgen_root=$(readlink -f ../tpch-dbgen/)
        for q in `seq 1 22`;
        do
                echo $q.sql
                DSS_QUERY=$tpcgen_root/queries/ \
                $tpcgen_root/qgen \
                -s $SIZING -r $RANDOM_SEED \
                -b $tpcgen_root/dists.dss \
                $q > $q.sql
        done
)
