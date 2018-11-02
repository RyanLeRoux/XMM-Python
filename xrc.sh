#! /bin/bash

# Author: Ryan Le Roux
# Email: ryanleroux@live.co.za

# XRAY CUT SCRIPT
# Cuts the data at given thresholds and produces gti files

# MUST BE IN work DIRECTORY

. $HEADAS/headas-init.sh #Initialize HEASOFT
echo 'HEASOFT initialized'
. $SAS/setsas.sh #Initialize SAS

# Export ccf.cif file
export SAS_CCF=$(pwd)/ccf.cif

# Export .SAS file
export SAS_ODF=$(pwd)/$(ls *.SAS)

#--------------------------------------------------------------
# Find the threshold for the flaring and cut everything above that:

# MOS1
echo 'Insert cut off vales for m1:'
read m1 #Read in user input
tabgtigen table=mos1_rate.fits gtiset=gtiset_mos1.fits timecolumn=TIME expression='(RATE<='$m1')'

# MOS2:
echo 'Insert cut off vales for m2:'
read m2
tabgtigen table=mos2_rate.fits gtiset=gtiset_mos2.fits timecolumn=TIME expression='(RATE<='$m2')'

# PN:
echo 'Insert cut off vales for pn:'
read pn
tabgtigen table=pn_rate.fits gtiset=gtiset_pn.fits timecolumn=TIME expression='(RATE<='$pn')'
