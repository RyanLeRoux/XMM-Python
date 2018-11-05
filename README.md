# XMM-Python

### Author: Ryan Le Roux
### Email: ryanleroux@live.co.za

Automated Bash and Python scripts that allow for reduction of ODFs (Orignal Data Files) obtained from the XMM observatory. Developed on Ubuntu 16.04 with Python 3.6. While the scripts may be strictly limited to the software and platform that it was developed on, it may be applied to any dataset obtained from the XMM archive.

# Reducing of XMM data to obtain event lists

In order to use the automated bash scripts to reduce XMM data, it is first required that HEASOFT and SAS are installed. HEASOFT can be downloaded [here](https://heasarc.gsfc.nasa.gov/lheasoft/install.html), and SAS can be downloaded [here](https://www.cosmos.esa.int/web/xmm-newton/sas-download). These scripts work with Ubuntu 16.04 and HEASOFT 6.24, cross compatibility has not been tested.
There is a single bash script (.sh file) that must be run in order to produce event lists, once that has been created, the other python scripts may be run. Before running any of these scripts, it is important to first state the directory layout, as these scripts are directory dependent. 

## Downloading XMM data

Archival XMM data can be downloaded [here](http://nxsa.esac.esa.int/nxsa-web/#search). Once the correct dataset has been found, download the ODF to a new directory. The ODFs are stored within a zipped file. Unzip these files to a new folder called 'ODF'. 

In order to correctly run the bash scripts, the user must be in the parent directory of the ODF file (for example, if the ODF files are in the directory `/home/user/xray/dataset/ODF/`, then the terminal must be in the directory `/home/user/xray/dataset/`). From this parent directory, begin by running the `xrr.sh` script, this is explained in the following section. 

# Producing event lists & images from the ODFs using xrr.sh

## How to run the script

It is recommended that these script files are stored in another directory, just for simplicity (for example, these could be stored in `/home/user/xray/scripts/`, this directory will be used as an example). To run the xrr script, the terminal must be set to the parent directory of the ODF folder, then simply enter `bash /home/user/xray/scripts/xrr.sh`.

It is required that the `HEADAS` and `SAS` directories are exported in the `.bashrc` file. This is explained when installing the `HEADAS` and `SAS` software, and is added by the user.

## Script procedure

The script follows the same procedure found on the [SAS data analysis thread](https://www.cosmos.esa.int/web/xmm-newton/sas-threads). 

### Initializing software

It begins by intialising HEASOFT and SAS, followed by exporting the ODF folder as `export SAS_ODF = /path/to/ODF`. A `work` folder in the same parent directory to the `ODF` folder is created to store any new files produced by the script.

### Creating calibration files

A calibration file (named `ccf.cif`) is created by using the command `cifbuild`, this cif file is then exported as `SAS_CCF = /path/to/ccf.cif`. Followed by this, a `.SAS` file is created (the filename can be any combination of letters or numbers, depending on the dataset), regardless of the filename, it is exported as `SAS_ODF = /path/to/###.SAS`. 

## Producing event lists from ODFs

Once these calibration files have been created, event lists may be produced. For the MOS1 and MOS2 cameras, the command `emproc` is used, and for the PN camera, the command `epproc` is used. These commands create several files which are stored within the `work` directory. The event lists that are created all contain the name `ImagingEvt`, and also contain the words `MOS1`, `MOS2` or `PN` for the MOS1, MOS2 or PN camera, respectively. These event lists are then renamed as `mos1.fits`, `mos2.fits` and `pn.fits` for the MOS1, MOS2 or PN camera, respectively.

## Cleaning event lists of high energy flaring

As detailed in [this thread](https://www.cosmos.esa.int/web/xmm-newton/sas-thread-epic-filterbackground), a high energy light curve is extracted from each event list, which is then plotted (using the `dsplot` command) for the user to find the base count rate, and to also identify any flaring that may have occured. 

In the case of high energy flaring, the user must record the base count rate (in counts/s) before the flaring occured, for each camera (keep record of this value to reference in the future). The terminal will then ask the user to input this count rate. As a reference, in the [same thread](https://www.cosmos.esa.int/web/xmm-newton/sas-thread-epic-filterbackground) listed above, it states that the average count rate for the MOS cameras should be less than or equal to 0.35 counts/second, and 0.4 counts/second for the PN camera. 

In the case where no high energy flaring can be seen (usually indicated by a steady count rate over time), simply record a value slightly larger than the base count rate (example: if the count rate hovers between 0.35 and 0.36, simply input 0.37, as then no data points will be removed).

After the user has inserted the appropriate values, `gtiset` files will be created for each camera. These files are used to create cleaned event lists, by removing data points that exceed the count rate which was set by the user. The cleaned event lists are labelled `mos1_clean.fits`, `mos2_clean.fits` and `pn_clean.fits` for the MOS1, MOS2 or PN camera, respectively. These files will be used for any data analysis, such as creating images, detecting source locations, extracting spectra, etc.

## Creating images from the cleaned event lists

There are 5 x-ray bands that is commonly used, these are:
- 0.2 - 0.5 keV (band 1)
- 0.5 - 1.0 keV (band 2)
- 1.0 - 2.0 keV (band 3)
- 2.0 - 4.5 keV (band 4)
- 4.5 - 12 keV (band 5)

Images are created for each band, for each camera. A 'full' image is also created for each image (which contain the all counts in all bands). It is advised that band 1 in the PN camera be set to 0.3 - 0.5 keV. 

## Extracting source locations

The task `edetect_chain` is performed (more information on this task can be found [here](https://www.cosmos.esa.int/web/xmm-newton/sas-thread-src-find)).

