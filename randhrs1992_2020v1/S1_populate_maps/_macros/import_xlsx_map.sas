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
         wave_pattern char(40) format = $40.;
quit;


%put --- sanitize_clength STARTS ---;
data _temp_;
 set _temp_;
 c1 = "*";
 if clength ne "" then do;
   c1 = substr(clength,1,1);
   put clength =  c1=;
   if c1 = ":" then clength = substr(clength,2);
 end;

 if clength ne "" then do;
   c1 = substr(clength,1,1);
   put clength =  c1=;
   if c1 = "`" then clength = substr(clength,2);
 end;
 drop c1;
run;
%put --- sanitize_clength ENDS ---;
%put;

%put --- sanitize_dispatch STARTS ---;
data _temp_;
 set _temp_;
 c1 = "*";
 if dispatch ne "" then do;
   c1 = substr(dispatch,1,1);
   if c1 = ":" then dispatch = substr(dispatch,2);
 end;

 if dispatch ne "" then do;
   c1 = substr(dispatch,1,1);
   if c1 = "`" then dispatch = substr(dispatch,2);
 end;
 drop c1;
run;
%put --- sanitize_dispatch ENDS ---;
%put;

%put --- sanitize wave_pattern STARTS ---;
data _temp_;
 set _temp_;
 c1 = "*";
 if wave_pattern ne "" then do;
   c1 = substr(wave_pattern,1,1);
   put wave_pattern=  c1=;
   if c1 = ":" then wave_pattern = substr(wave_pattern,2);
 end;

 if wave_pattern ne "" then do;
   c1 = substr(wave_pattern,1,1);
   put wave_pattern =  c1=;
   if c1 = "`" then wave_pattern = substr(wave_pattern,2);
 end;
 drop c1;
run;
%put --- sanitize_wave_pattern ENDS ---;
%put;

%put --- sanitize wave_summary STARTS ---;
data _temp_;
 set _temp_;
 c1 = "*";
 if wave_summary ne "" then do;
   c1 = substr(wave_summary,1,1);
   put wave_summary=  c1=;
   if c1 = ":" then wave_summary = substr(wave_summary,2);
 end;

 if wave_summary ne "" then do;
   c1 = substr(wave_summary,1,1);
   put wave_summary =  c1=;
   if c1 = "`" then wave_summary = substr(wave_summary,2);
 end;
 drop c1;
run;
%put --- sanitize_wave_summary ENDS ---;
%put;


data _libmap1.&mapx.0 (label = "Map Table &mapx created from &xlsx_name..xlsx on &sysdate");
 set _temp_;
run;

%put --- Macro `import_xlsx_map` EXIT (table =&table);
%put; 

%mend import_xlsx_map;

