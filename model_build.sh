#!/bin/bash

# Process stderr and prepend for log parsing
exec 2> >(trap '' INT TERM; sed 's/^/Model Build Error: /' >&2)

# General error catching & handling
set -uE -o pipefail
trap 'handleErr $?' ERR

handleErr() {
  returnCode=$1
  # Add any required cleanup & error handling/recovery
  exit $returnCode
}

# Model build starts below
conda update -n base -c defaults conda

# Create the conda environment
conda env create --no-default-packages -f environment.yml
