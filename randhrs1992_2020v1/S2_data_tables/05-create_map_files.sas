options nocenter mprint nofmterr ls =255 ;

libname _libmap  "&prj_path\S1_populate_maps\maps" access="readonly";


* Local macros loaded;
filename macros "&prj_path\&dir_name\_macros";
%*include macros(zzz_include);
%*zzz_include;

%macro  create_stmnts0_data;

/* Temporary `_stmnt0` wide dataset with SAS statements stored in `_wv` array*/
data _stmnts0;
   retain ctype;
   set &mapx;
   *length table $40;
   length tmpci tmpi $200;
   length c1 $1;
   array _waves_list{*} $45   &waves_list;
   
   %do i =1 %to  &cwaves_count;
    length wv&i $200;
   %end;
   array _wv {&cwaves_count} wv1-wv&cwaves_count;
   length ctype $2;
   stmnt_no = _n_;
/* variable ctype created: Statement type  */

    c1 = substr(strip(name), 1, 1);
   if c1 =":"   then do; 
    select(dispatch);
      when ("") ctype = "S0"; /* regular SAS statement */
      otherwise ctype = "Sx"; /* SAS statement repeated */
    end;
  
    if ctype = "Sx" and indexc(dispatch,"?") then ctype = "S?";
   end;
   if c1 ne ":" then do;
     select(dispatch);
       when ("")        ctype = "A0"; /* RAND variable used */
       when ("=?")      ctype = "A?"; /* y = ? */
       otherwise        ctype = "AD"; /* derived variable */
     end;
   end;
   if ctype ="AD" and indexc(dispatch, "?") then ctype ="A?"; /* derived variable with ? */
 
 /* --- ctype = Sx: Based on `dispatch` populate `_waves_list` vars */
 if ctype = "Sx" then do;
  do i = 1 to dim(_waves_list);
    tmpci = _waves_list{i};
    tmpci = strip(dispatch)||strip(tmpci);
    _waves_list{i} = strip(tmpci);
   end;
 end;
 
 /* --- Based on `_waves_list` populate `_wv` variables */
 do i =1 to dim(_wv);
  tmpci = _waves_list{i};
  if ctype in ("S0", "Sx") then stmnti = strip(tmpci);  /*  tmpci  -> tmpci */ 
  if ctype = "S0" and tmpci ne "" then 
        stmnti = strip(tmpci) || " /*  " || strip(label)|| "  */";
  
  if ctype ="S?" then do;
       tmpi = strip(tmpci);
       stmnti = tranwrd(strip(dispatch), "?", tmpi);   /*  xx  -> Dis[xx]patch */
  end;
  
  if ctype in ("A0") then stmnti = strip(tmpci)    || "  /* --- RAND variable:" || strip(name)    || "  included */" ; 
  if ctype in ("AD") then stmnti = strip(name)|| strip(dispatch) || "     /* --- Derived variable  */" ; 
  if ctype in ("A?") then do;
      if tmpci ne "" then stmnti = strip(name)|| "=" || strip(tranwrd(dispatch, "=?", strip(tmpci))); 
      if tmpci = "" then stmnti = "/* Empty map cell for: "|| name || "variable wave ="|| put (i, 3.)|| "*/";    
  end;
  
  _wv{i} = stmnti;
 end;

   drop c1 tmpi tmpci;
run;

%mend create_stmnts0_data;

%macro create_stmnts_data;
proc transpose data = &table._stmnts0
                out =&table._stmnts (rename = (col1= stmnt))
                name = wave_no
                ;
var wv1 - wv&cwaves_count;
by stmnt_no;
run;

data _stmnts;
  set &table._stmnts;
  wv_no = input(substr(wave_no,3), 8.);
  if stmnt ne "";
run;
%mend create_stmnts_data;

%macro create_dictionary;
%let tbl = %upcase(&table);
%let keep1=;
%if (&tbl = RLONG or &tbl = HLONG or &tbl = RSSI) %then %let keep1= wave_pattern wave_summary; 
data _dictionary_init;
  set _stmnts0(keep= name ctype label clength format dispatch &keep1);
  if substr(ctype,1,1)= "A";
run;

data _dictionary;
  retain varnum;
  set _dictionary_init;
 varnum = _n_;
 valid_name = nvalid(name,'v7');
 if  ctype='A0' then varin =1; else varin =0;

run;

%mend create_dictionary;


%macro _05map_file_create(table);

/* Fileref to map_file: Ex. Map file  `RLong_map_file.inc` */
filename map_file "&prj_path\&dir_name\map_files\&table._map_file.inc";

libname _stmnts  "&prj_path\S2_data_tables\_05aux\&table" FILELOCKWAIT =30;


%html_content_title(&table);

ods listing close;
 ods html  path =     "&prj_path\&dir_name\_05aux\&table" (URL=NONE)
           file =     "05-create_map_files-body.html"
           contents = "05-create_map-files-contents.html"
           frame =    "05-create_map-files-frame.html"
           style     = styles.custom

;



%put --- Prepare `cwaves_count` and `waves_list` mvars for `&table` table; 
%put --- Note: Macro vars are extracted from `_maps_info` dataset;
data _tbl_;
    set _libmap.maps_info;
    tbl = strip(upcase(symget('table')));
    if upcase(table) = tbl;
run;

data _null_;
  set _tbl_;
    array vars {*} $ keys cwaves_count waves_list; 
    do i = 1 to dim(vars);
        call symputx(vname(vars{i}), vars{i});
    end;
run;
%put table := &table;
%put waves_list  := &waves_list;
%put cwaves_count := &cwaves_count;
%put keys := &keys;

%let mapx = _libmap.&table._map; /* SAS map dataset */ 

%create_stmnts0_data;

data &table._stmnts0;
   set _stmnts0;  
run;

%traceit_print(&table._stmnts0, vars= name dispatch ctype wv1 wv&cwaves_count);
/* Create  stmnts data set */
%create_stmnts_data;

proc sort data =_stmnts out= &table._stmnts;
by wv_no stmnt_no;
run;

%traceit(&table._stmnts);

%create_dictionary;
data &table._dictionary;
   set _dictionary;  
run;


%traceit(&table._dictionary);

/* --- Map file initiated ---*/
data _null_;
  file map_file;
  put "/* This is map_file `&table._map_file.inc` for `&table._table` dataset */";
  put "/* Repo name := &repo_name (version &repo_version) */";
  put "/* Project name := &prj_name */";
  put "/* Excel map: &xlsx_name..xlsx */";
  put "/* Date stamp: &sysdate  */";
  put /;
run;

/* Basic set of macros appended to `map_file` file */
%put_init_macro_stmnts;

/* Readvar2_list */

data _null_;
  file map_file mod ;
  put / '%macro readvar2_list;'; 
  put "/* List of variables to be read from input dataset */";
run;

data _null_;
  file map_file mod ;
  set _stmnts0;
  length tmpci $45;
   
  array _waves_list{*} $45   &waves_list;
  c1 = substr(ctype,1,1);
  if c1="S" then delete;
  if ctype = "A0" then delete;
  put "/*-- " name   "  --*/";
  do i =1 to  &cwaves_count;
   tmpci = strip(_waves_list{i});
   if tmpci ne '' and nvalid(tmpci,'v7')  then put tmpci; /* Expressions in tmpci not allowed */
 end;
run;


data _null_;
  file map_file mod ;
  put '%mend readvar2_list;'; 
  put;
run;




/* Macro `process_data` appended to `map_file`*/
data _null_;
  set &table._stmnts;
  file map_file mod ;
  if _n_ =1 then put "/* Macro `process_data for `&table` */";
  put stmnt ";";
run;

/* Save permanent datasets */
data _stmnts.&table._stmnts0;
  set &table._stmnts0;
run;

data _stmnts.&table._stmnts;
  set &table._stmnts;
run;

data _stmnts.&table._dict;
  set &table._dictionary;
run;


ods html close;


libname _stmnts clear;

%mend _05map_file_create;



/*=== Execution starts =====*/


/* ===== Macro `_project_setup` executed  ===== */;

%_project_setup;



%_05map_file_create(HLong);
%_05map_file_create(RLong);
%_05map_file_create(Rwide);
%_05map_file_create(Rexit);

%_05map_file_create(RSSI);



