# !!! WORK IN PROGRESS

IMPORTANT: After downloading `RAND2lONG` repository locate `project_setup.sas`
file in this directory and modify `repo_name` and `repo_path` macro variables.


* Programs in this repository were written by:  Jinkyung Ha, Mohammed Kabeto, and Andrzej Galecki 



* The goal of this project is to reshape and recode RAND HRS Longitudinal File 2020 dataset from wide to long format.;
* Project has been supported by Pepper Center grant;


In this document we describe step-by-step on how to convert **RAND HRS Longitudinal File 2020** from wide format to a long format.

# Prerequisites

##  Download RAND HRS Longitudinal File 2020
 
* Download `randhrs1992_2020v1_SAS.zip` file available 
[here](https://hrsdata.isr.umich.edu/data-products/rand-hrs-longitudinal-file-2020). 
* Store `randhrs1992_2020v1.sas7bdat` and `sasfmts.sas7bdat` files in a folder of your preference.

Notes: 

* You will need to register with HRS website to access the data
* We will refer to `randhrs1992_2020v1.sas7bdat` and `sasfmts.sas7bdat` datasets
as **DATAIN** and **FORMATS_CNTLIN**, respectively.


## Prepare `randhrs1992_2020v1_map.xlsx`file with information on mapping **DATAIN** MAP_INFO` dataset

* Prepare SAS dataset referred to as **MAP_INFO** that contains information about mapping of the **DATAIN** dataset from wide to long format.
* For user covenience this dataset named `randhrs1992_2020v1_map.sas7bdat` has been already prepared.

## Prepare FCMP functions

* Prepare SAS FCMP functions needed for data conversion.
* For user covenience the FCMP code  has been already prepared and was stored in  `./usource/FCMP_src.sas` file.



