%macro import_xlsx_map (table);
%put ===>  Macro `import_xlsx_map` STARTS for table &table;
%let tmp = &xlsx_path\&xlsx_name..xlsx;
%put tmp := &tmp;
%let mapx = &table._map;
%put mapx :=&mapx;

proc import 
    out=_temp_ 
    datafile="&tmp" 
    dbms=xlsx
    replace;
    sheet = "&mapx";   
    getnames=YES;
run;
quit;

/*=== Increase length of selected variables ==== */
/* - clength variable */
proc sql noprint;
alter table _temp_
  modify clength char(5) format = $5.,
         wave_pattern char(40) format = $40.,
         wave_summary char(40) format = $40.,
         dispatch char(100) format = $100.;
         
quit;

%if %upcase(&table) = RSSI %then %do;
proc sql noprint;
alter table _temp_
  modify
 %do i=1 %to 10;
    RSSI_E&i char(40) format = $40.,
 %end;
    RSSI_E11 char(40) format = $40.;
quit;
%end;

%if (%upcase(&table) = RLONG or %upcase(&table) = HLONG)  %then %do;
proc sql noprint;
alter table _temp_
  modify
 %do i=1 %to 14;
    hrs_wave&i char(40) format = $40.,
 %end;
    hrs_wave15 char(40) format = $40.;
quit;
%end;


data _temp_;
  set _temp_;
  file print;
  if _n_= 1 then put "===> Table &table is sanitized";
run;

%sanitize_temp_(clength);
%sanitize_temp_(dispatch);
%sanitize_temp_(wave_pattern);
%sanitize_temp_(wave_summary);

data _libmap0.&mapx.0 (label = "Map &mapx.0 (initial version) created from &xlsx_name..xlsx on &sysdate");
 set _temp_;
 if dispatch = "=" then dispatch = "=?"; 
run;

%put --- Macro `import_xlsx_map` EXIT (table =&table);
%put; 

%mend import_xlsx_map;

