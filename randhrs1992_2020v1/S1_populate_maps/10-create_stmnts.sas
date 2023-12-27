options mprint;


libname _libmap  "&prj_path\&dir_name\maps" access="readonly";
libname _stmnts  "&prj_path\&dir_name\10-stmts" access="readonly";


* Local macros loaded;
filename macros "&prj_path\&dir_name\_macros";
%include macros(zzz_xlsx_include);
%zzz_xlsx_include;


/*=== Execution starts =====*/


/* ===== Macro `_project_setup` executed  ===== */;
%_project_setup;

%macro create_stmnts(table);
%if (%upcase(table) = RLONG or %upcase(table) = HLONG) %then %do;
 %let waves_count = 15;
 %let waves_list = hrs_wave1-hrs_wave15;
%end;

%let mapx = _libmap.&table._map;

data &table._stmnts;
   set &mapx;
   length cmnt $200;
   length c1 $1;
   array _waves_list{*} $45   &waves_list;
   array _stmnt_list{*} $100  stmnt1-stmnt&waves_count;
   c1 = substr(strip(name), 1,1);
   if c1 =":" then stype1 = 1; else stype1 =2;
   
   if stype1 =2 then do;
   
   if dispatch ne
   
   
   
run;

%mend  create_stmnts;


endsas;


 ods listing close;
 ods html  path =     "&prj_path\&dir_name" (URL=NONE)
           file =     "05-updated_maps-body.html"
           contents = "05-updated_maps-contents.html"
           frame =    "05-updated_maps-frame.html"
 ;

