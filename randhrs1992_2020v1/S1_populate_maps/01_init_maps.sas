/* NOTE: autoexec.sas executed */
options mprint;

libname _libmap1  "&prj_path\&dir_name\maps_init";

* Local macros loaded;
filename macros "&prj_path\&dir_name\_macros";
%include macros(zzz_xlsx_include);
%zzz_xlsx_include;

/* Execution starts */
%_project_setup;


%import_xlsx_maps_info;

data maps_info2;
 set maps_info;
 length stmnt $ 200;
 stmnt = '%import_xlsx_map(' || strip(table) || ");";
run;

proc print data=maps_info2;
run;

data _null_;
 set maps_info2;
 call execute(stmnt);
run;

