# XMM-Python

### Author: Ryan Le Roux
### Email: ryanleroux@live.co.za

Automated Bash and Python scripts that allow for reduction of ODFs (Orignal Data Files) obtained from the XMM observatory. Developed on Ubuntu 16.04 with Python 3.6. 

# Reducing of XMM data to obtain event lists

In order to use the automated bash scripts to reduce XMM data, it is first required that HEASOFT and SAS are installed. HEASOFT can be downloaded [here](https://heasarc.gsfc.nasa.gov/lheasoft/install.html), and SAS can be downloaded [here](https://www.cosmos.esa.int/web/xmm-newton/sas-download). These scripts work with Ubuntu 16.04 and HEASOFT 6.24, cross compatibility has not been tested.
There are three bash scripts (.sh file) that must be run in a specific order to produce event lists. Before running these scripts, it is important to first state the directory layout, as these scripts are directory dependent. 

## Downloading XMM data

Archival XMM data can be downloaded [here](http://nxsa.esac.esa.int/nxsa-web/#search). Once the correct dataset has been found, download the ODF to a new directory. The ODFs are stored within a zipped file. Unzip these files to a new folder called 'ODF'. 

In order to correctly run the bash scripts, the user must be in the parent directory of the ODF file (for example, if the ODF files are in the directory `~/xray/dataset/ODF/`, then the terminal must be in the directory `~/xray/dataset/`). From this parent directory, begin by running the `xrr.sh` script, this is explained in the following section. 

# Producing event lists from the ODFs using xrr.sh

## How to run the script

It is recommended that these script files are stored in another directory, just for simplicity (for example, these could be stored in `~/xray/scripts/`, this directory will be used as an example). To run the xrr script, the terminal must be set to the parent directory of the ODF folder, then simply enter `bash ~/xray/scripts/xrr.sh`.

It is required that the `HEADAS` and `SAS` directories are exported in the `.bashrc` file. This is explained when installing the `HEADAS` and `SAS` software, and is added by the user.

## Script procedure

The script follows the same procedure found on the [SAS data analysis thread](https://www.cosmos.esa.int/web/xmm-newton/sas-threads)
