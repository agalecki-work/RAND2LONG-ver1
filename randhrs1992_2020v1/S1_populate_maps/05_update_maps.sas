/* NOTE: autoexec.sas executed */
options mprint;

libname _libmap0  "&prj_path\&dir_name\maps0" access="readonly";

libname _libmap  "&prj_path\&dir_name\maps";

* Local macros loaded;
filename macros "&prj_path\&dir_name\_macros";
%include macros(zzz_xlsx_include);
%zzz_xlsx_include;


/*=== Execution starts =====*/


/* ===== Macro `_project_setup` executed  ===== */;
%_project_setup;


 ods listing close;
 ods html  path =     "&prj_path\&dir_name" (URL=NONE)
           file =     "05-updated_maps-body.html"
           contents = "05-updated_maps-contents.html"
           frame =    "05-updated_maps-frame.html"
 ;

data _libmap.maps_info;
 set _libmap0.maps_info;
run;

%traceit_print(maps_info, libname = _libmap);
%populate_RSSI_map;   /* RSSI_map0 -> RSSI_map */
%traceit_print(RSSI_map, libname = _libmap);
%populate_RLmaps(RLong);
%traceit_print(RLong_map, libname = _libmap);
%populate_RLmaps(HLong);
%traceit_print(HLong_map, libname = _libmap);

ods html close;






