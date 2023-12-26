%macro import_xlsx_maps_info;
       import_xlsx_maps_info
%let xlsx_fpath = &xlsx_path/&xlsx_name..xlsx;
proc import 
    out=_temp_ 
    datafile="&xlsx_fpath" 
    dbms=xlsx
    replace;
    sheet = "Maps_info";   
    getnames=YES;
run;


%mend import_xlsx_maps_info;
