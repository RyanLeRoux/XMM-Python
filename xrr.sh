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

#--------------------------------------------------------------
# Create filtered sets using the gti files

# MOS1:
evselect table=mos1.fits withfilteredset=Y filteredset=mos1_clean.fits destruct=Y keepfilteroutput=T expression='#XMMEA_EM && gti(gtiset_mos1.fits,TIME) && (PI>150)'
# MOS2:
evselect table=mos2.fits withfilteredset=Y filteredset=mos2_clean.fits destruct=Y keepfilteroutput=T expression='#XMMEA_EM && gti(gtiset_mos2.fits,TIME) && (PI>150)'
# PN:
evselect table=pn.fits withfilteredset=Y filteredset=pn_clean.fits destruct=Y keepfilteroutput=T expression='#XMMEA_EP && gti(gtiset_pn.fits,TIME) && (PI>150)'

#--------------------------------------------------------------
#Create filtered images then move them to 'images' folder
mkdir images

# MOS1:
# 0.2-12 keV:
evselect table=mos1_clean.fits:EVENTS imagebinning='imageSize' imageset='m1_image_full.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [200:12000])&&(PATTERN in [0:12])&&(FLAG==0)'

# 0.2-0.5keV:
evselect table=mos1_clean.fits:EVENTS  imagebinning='imageSize' imageset='m1_image_b1.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [200:500])&&(PATTERN in [0:12])&&(FLAG==0)'

# 0.5-1 keV:
evselect table=mos1_clean.fits:EVENTS  imagebinning='imageSize' imageset='m1_image_b2.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [500:1000])&&(PATTERN in [0:12])&&(FLAG==0)'

# 1-2 keV:
evselect table=mos1_clean.fits:EVENTS  imagebinning='imageSize' imageset='m1_image_b3.fits'   withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [1000:2000])&&(PATTERN in [0:12])&&(FLAG==0)'

# 2-4.5 keV:
evselect table=mos1_clean.fits:EVENTS  imagebinning='imageSize' imageset='m1_image_b4.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [2000:4500])&&(PATTERN in [0:12])&&(FLAG==0)'

# 4.5-12 keV:
evselect table=mos1_clean.fits:EVENTS  imagebinning='imageSize' imageset='m1_image_b5.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [4500:12000])&&(PATTERN in [0:12])&&(FLAG==0)'

# MOS2:
# 0.2-12 keV:
evselect table=mos2_clean.fits:EVENTS imagebinning='imageSize' imageset='m2_image_full.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [200:12000])&&(PATTERN in [0:12])&&(FLAG==0)'

# 0.2-0.5keV:
evselect table=mos2_clean.fits:EVENTS  imagebinning='imageSize' imageset='m2_image_b1.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [200:500])&&(PATTERN in [0:12])&&(FLAG==0)'

# 0.5-1 keV:
evselect table=mos2_clean.fits:EVENTS  imagebinning='imageSize' imageset='m2_image_b2.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [500:1000])&&(PATTERN in [0:12])&&(FLAG==0)'

# 1-2 keV:
evselect table=mos2_clean.fits:EVENTS  imagebinning='imageSize' imageset='m2_image_b3.fits'   withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [1000:2000])&&(PATTERN in [0:12])&&(FLAG==0)'

# 2-4.5 keV:
evselect table=mos2_clean.fits:EVENTS  imagebinning='imageSize' imageset='m2_image_b4.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [2000:4500])&&(PATTERN in [0:12])&&(FLAG==0)'

# 4.5-12 keV:
evselect table=mos2_clean.fits:EVENTS  imagebinning='imageSize' imageset='m2_image_b5.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EM&&(PI in [4500:12000])&&(PATTERN in [0:12])&&(FLAG==0)'


# PN:
# 0.3-12 keV: (Single and double)
evselect table=pn_clean.fits:EVENTS imagebinning='imageSize' imageset='pn_image_full.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EP&&(PI in [300:12000])&&(PATTERN in [0:4])&&(FLAG==0)'

# 0.3-0.5keV: (Single only)
evselect table=pn_clean.fits:EVENTS  imagebinning='imageSize' imageset='pn_image_b1.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EP&&(PI in [300:500])&&(PATTERN in [0])&&(FLAG==0)'

# 0.5-1 keV:
evselect table=pn_clean.fits:EVENTS  imagebinning='imageSize' imageset='pn_image_b2.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EP&&(PI in [500:1000])&&(PATTERN in [0:4])&&(FLAG==0)'

# 1-2 keV:
evselect table=pn_clean.fits:EVENTS  imagebinning='imageSize' imageset='pn_image_b3.fits'   withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EP&&(PI in [1000:2000])&&(PATTERN in [0:4])&&(FLAG==0)'

# 2-4.5 keV:
evselect table=pn_clean.fits:EVENTS  imagebinning='imageSize' imageset='pn_image_b4.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EP&&(PI in [2000:4500])&&(PATTERN in [0:4])&&(FLAG==0)'

# 4.5-12 keV:
evselect table=pn_clean.fits:EVENTS  imagebinning='imageSize' imageset='pn_image_b5.fits' withimageset=yes xcolumn='X' ycolumn='Y' ximagebinsize=600 yimagebinsize=600 expression='#XMMEA_EP&&(PI in [4500:12000])&&(PATTERN in [0:4])&&(FLAG==0)'

#--------------------------------------------------------------
# Now run 'edetect' on all 3:

# Need to first rename the AttHk file:
# from ###AttHk.ds to AttHk.ds
cp *AttHk.ds AttHk.ds

#Make 'coords' folder to store all the coord files
mkdir coords

# MOS1:
edetect_chain imagesets='"m1_image_b1.fits" "m1_image_b2.fits" "m1_image_b3.fits" "m1_image_b4.fits" "m1_image_b5.fits"' eventsets=mos1_clean.fits:EVENTS attitudeset=AttHk.ds pimin='200 500 1000 2000 4500' pimax='500 1000 2000 4500 12000' ecf='1.734 1.746 2.041 0.737 0.145' eboxl_list='coords/m1_eboxlist_l.fits' eboxm_list='coords/m1_eboxlist_m.fits' esp_nsplinenodes=16 eml_list='coords/m1_emllist.fits' esen_mlmin=15

# MOS2:
edetect_chain imagesets='"m2_image_b1.fits" "m2_image_b2.fits" "m2_image_b3.fits" "m2_image_b4.fits" "m2_image_b5.fits"' eventsets=mos2_clean.fits:EVENTS attitudeset=AttHk.ds pimin='200 500 1000 2000 4500' pimax='500 1000 2000 4500 12000' ecf='0.991 1.387 1.789 0.703 0.150' eboxl_list='coords/m2_eboxlist_l.fits' eboxm_list='coords/m2_eboxlist_m.fits' esp_nsplinenodes=16 eml_list='coords/m2_emllist.fits' esen_mlmin=15

# PN:
edetect_chain imagesets='"pn_image_b1.fits" "pn_image_b2.fits" "pn_image_b3.fits" "pn_image_b4.fits" "pn_image_b5.fits"' eventsets=pn_clean.fits:EVENTS attitudeset=AttHk.ds pimin='300 500 1000 2000 4500' pimax='500 1000 2000 4500 12000' ecf='9.525 8.121 5.867 1.953 0.578' eboxl_list='coords/pn_eboxlist_l.fits' eboxm_list='coords/pn_eboxlist_m.fits' esp_nsplinenodes=16 eml_list='coords/pn_emllist.fits' esen_mlmin=15

#--------------------------------------------------------------
#Can now display images with overlap (individual):
srcdisplay boxlistset=coords/m1_emllist.fits imageset=m1_image_full.fits sourceradius=0.007 regionfile=coords/m1_regionfile.txt withregionfile=yes

# Wait for user input:
read -p "Press enter to continue"

srcdisplay boxlistset=coords/m2_emllist.fits imageset=m2_image_full.fits sourceradius=0.007 regionfile=coords/m2_regionfile.txt withregionfile=yes

read -p "Press enter to continue"

srcdisplay boxlistset=coords/pn_emllist.fits imageset=pn_image_full.fits sourceradius=0.007 regionfile=coords/pn_regionfile.txt withregionfile=yes

read -p "Press enter to continue"

# Can mosiac all of the 3 full images:
emosaic imagesets='m1_image_full.fits m2_image_full.fits pn_image_full.fits' mosaicedset=mosaic.ds

# But require edetect on ALL images:
edetect_chain imagesets='"m1_image_b1.fits" "m1_image_b2.fits" "m1_image_b3.fits" "m1_image_b4.fits" "m1_image_b5.fits" "m2_image_b1.fits" "m2_image_b2.fits" "m2_image_b3.fits" "m2_image_b4.fits" "m2_image_b5.fits" "pn_image_b1.fits" "pn_image_b2.fits" "pn_image_b3.fits" "pn_image_b4.fits" "pn_image_b5.fits"' eventsets='mos1_clean.fits:EVENTS mos2_clean.fits:EVENTS pn_clean.fits:EVENTS' attitudeset=AttHk.ds pimin='200 500 1000 2000 4500 200 500 1000 2000 4500 200 500 1000 2000 4500' pimax='500 1000 2000 4500 12000 500 1000 2000 4500 12000 500 1000 2000 4500 12000' ecf='1.734 1.746 2.041 0.737 0.145 0.991 1.387 1.789 0.703 0.150 9.525 8.121 5.867 1.953 0.578' eboxl_list='coords/all_eboxlist_l.fits' eboxm_list='coords/all_eboxlist_m.fits' esp_nsplinenodes=16 eml_list='coords/all_emllist.fits' esen_mlmin=15

# And then display the mosiac image:
srcdisplay boxlistset=coords/all_emllist.fits imageset=mosaic.ds

# Move all images to the 'images' file
mkdir images
mv *image* images
mv mosaic.ds images



