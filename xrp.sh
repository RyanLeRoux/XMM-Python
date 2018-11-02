#! /bin/bash

# Author: Ryan Le Roux
# Email: ryanleroux@live.co.za

# XRAY PROCEDURE
# Creates cleaned event lists (excluding background flaring events)
# and produces images in the 5 different energy bands, as well as an
# image across all bands
# Runs edetect_chain which obtains the various source locations

# MUST BE IN work DIRECTORY

. $HEADAS/headas-init.sh #Initialize HEASOFT
echo 'HEASOFT initialized'
. $SAS/setsas.sh #Initialize SAS

# Export ccf.cif file
export SAS_CCF=$(pwd)/ccf.cif

# Export .SAS file
export SAS_ODF=$(pwd)/$(ls *.SAS)

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

