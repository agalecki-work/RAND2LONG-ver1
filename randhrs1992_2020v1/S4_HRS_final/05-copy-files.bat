::: PREAMBLE starts
pushd %~dp0
:: Define `cdir`
set "cdir=%CD%"
cd %CDIR%


set "pathx=..\S2_data_tables"
echo %pathx%

:: Copy map files from \S2_data_tables\map_files folder
copy %pathx%\map_files\*_map_file.inc %CDIR%\HRS_package


:: Copy SAS formats
copy %pathx%\data\_randfmts_long.sas7bdat %CDIR%\HRS_package\data_tables

:: Copy SAS data tables 
copy %pathx%\data\*_table.sas7bdat %CDIR%\HRS_package\data_tables


timeout /t 25