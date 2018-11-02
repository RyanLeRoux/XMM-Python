#! /bin/bash

# Author: Ryan Le Roux
# Email: ryanleroux@live.co.za

# XRAY REDUCE
# Reduce XMM and produce event list in new directory

# MUST BE IN DIRECTORY ABOVE ODF

. $HEADAS/headas-init.sh #Initialize HEASOFT
echo 'HEASOFT initialized'
. $SAS/setsas.sh #Initialize SAS

export SAS_ODF=$(pwd)/ODF #Set SAS_ODF direcotry to current directory
echo 'exporting SAS_ODF='$(pwd)'/ODF' 

# Now make new directory to store all work files
mkdir work
cd work

echo 'Now using cifbuild to create ccf.cif file'
cifbuild #Create ccf.cif file

echo 'exporting SAS_CCF='$(pwd)'/ccf.cif'
export SAS_CCF=$(pwd)/ccf.cif #Point SAS_CCF to newly created ccf.cif file

echo 'Now using odfingest to create .SAS file'
odfingest #Create .SAS file

echo 'exporting SAS_ODF='$(pwd)'/'$(ls *.SAS)
export SAS_ODF=$(pwd)/$(ls *.SAS) #Point SAS_ODF to newly created .SAS file

#--------------------------------------------------------------

# Now can begin processing
echo 'Performing emproc...'
emproc
echo 'Performing epproc'
epproc
# The above commands will produce *MOS*ImagingEvts.ds and *PN*ImagingEvts.ds files
# Copy these as new mos1.fits, mos2.fits and pn.fits files, as these will be used 
# in future scripts (and makes life easier)
cp *MOS1*S*ImagingEvt* mos1.fits
cp *MOS2*S*ImagingEvt* mos2.fits
cp *PN*S*ImagingEvt* pn.fits

#Move all loose files to another directory
mkdir loose
mv *MOS*ds loose
mv *PN*ds loose

#--------------------------------------------------------------
#Extract high energy light curve to identify high energy flaring
#MOS1:
evselect table=mos1.fits withrateset=Y rateset=mos1_rate.fits maketimecolumn=Y timebinsize=100 makeratecolumn=Y expression='#XMMEA_EM && (PI>10000) && (PATTERN==0)'
#MOS2:
evselect table=mos2.fits withrateset=Y rateset=mos2_rate.fits maketimecolumn=Y timebinsize=100 makeratecolumn=Y expression='#XMMEA_EM && (PI>10000) && (PATTERN==0)'
#PN:
evselect table=pn.fits withrateset=Y rateset=pn_rate.fits maketimecolumn=Y timebinsize=100 makeratecolumn=Y expression='#XMMEA_EP && (PI>10000&&PI<12000) && (PATTERN==0)'

# Display light curves to look for bursts
# Store the base count/s rate to exclude events
# that exceed a certain count/s threshold
#MOS1:
dsplot table=mos1_rate.fits x=TIME y=RATE
#MOS2:
dsplot table=mos2_rate.fits x=TIME y=RATE
#PN:
dsplot table=pn_rate.fits x=TIME y=RATE


