/* NOTE: autoexec.sas executed */
options mprint formdlim=" ";

libname _libmap0  "&prj_path\&dir_name\maps0";

* Local macros loaded;
filename macros "&prj_path\&dir_name\_macros";
%include macros(zzz_xlsx_include);
%zzz_xlsx_include;

/* Execution starts */
%_project_setup;


%import_xlsx_maps_info;

data _libmap0.maps_info;
 set maps_info;
 length cwaves_count $3;
 cwaves_count = strip(put(waves_count, 3.));
run;

%import_xlsx_map(RLong);
%import_xlsx_map(HLong);
%import_xlsx_map(Rwide);
%import_xlsx_map(Rexit);
%import_xlsx_map(RSSI);


