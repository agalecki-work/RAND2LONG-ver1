options nocenter mprint nofmterr;

libname _libmap  "&prj_path\S1_populate_maps\maps" access="readonly";

%macro _05map_file_create(table);
filename map_file "&prj_path\&dir_name\map_files\&table._map_file.inc";

%put --- Prepare `waves_count` and `waves_list` for each table;  
%if (%upcase(&table) = RLONG or %upcase(&table) = HLONG) %then %do;
 %let waves_count = 15;
 %let waves_list = hrs_wave1-hrs_wave15;
%end;

%let mapx = _libmap.&table._map; /* SAS map dataset */ 

/* Temporary wide dataset with SAS statements */
data &table._stmnts;
   set &mapx;
   length cmnt $200;
   length c1 $1;
   array _waves_list{*} $45   &waves_list;
   array _wv_list{*} $200  wv1-wv&waves_count;
   stype = 9;
   c1 = substr(strip(name), 1,1);
   if c1 =":"         then stype = 1; /* regular SAS statement */
   if stype ne 1 then do;
     if dispatch = ""   then stype = 2; /* RAND variable used */
     if dispatch in ("=", "=?") then stype = 3; /* y = ? */
   end;
run;

%traceit_print(&table._stmnts);

%mend _05map_file_create;



/*=== Execution starts =====*/


/* ===== Macro `_project_setup` executed  ===== */;

%_project_setup;
ods html;

%*macro skip;
%_05map_file_create(HLong);
%_05map_file_create(RLong);
%*_05map_file_create(Rwide);
%*_05map_file_create(Rexit);
%*mend skip;

%_05map_file_create(RSSI);
ods html close;


endsas;


 ods listing close;
 ods html  path =     "&prj_path\&dir_name" (URL=NONE)
           file =     "05-updated_maps-body.html"
           contents = "05-updated_maps-contents.html"
           frame =    "05-updated_maps-frame.html"
 ;

