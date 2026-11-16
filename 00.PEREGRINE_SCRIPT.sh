#!/bin/bash


#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --mem=64GB
#SBATCH --time=2-00:05

# Activate the bagel4 Conda environment before submitting this script.
PROGRAMDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTDIR="${RESULTDIR:-$PROGRAMDIR/tmp}"
DATADIR="${DATADIR:-$PROGRAMDIR/test_in}"

mkdir -p "$RESULTDIR"
perl "$PROGRAMDIR/bagel4_wrapper.pl" -s "$RESULTDIR" -query "$DATADIR" -r '*.fna'
