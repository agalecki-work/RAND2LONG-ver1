/* NOTE: autoexec.sas executed */
options mprint;

libname _libmap  "&prj_path\&dir_name\maps";

* Local macros loaded;
filename macros "&prj_path\&dir_name\_macros";
%include macros(zzz_xlsx_include);
%zzz_xlsx_include;


%import_xlsx_maps_info;
