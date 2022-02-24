#!/bin/bash

###############
#  Paths      #
###############

huxtpath='/huxt'

snaptime=$1
huxt_savedir=$huxtpath/$2

# Input files from PFSS
pfssresults=$3

###############
#  HUXt Part  #
###############

filepath=$pfssresults'/windbound_b_pfss'$snaptime'.nc' 

cd $huxtpath'/code'

mkdir -p $huxtpath'/figures'

mkdir -p $huxt_savedir

conda run --no-capture-output -n huxt python3 ./huxt_ensembles_PFSSdemo.py $huxtpath $filepath $huxt_savedir
status=$?

if [[ $status -ne 0 ]]; then
    echo "Error in Huxt computations"
    exit 1
else  
    echo "Huxt computations finished"
fi
