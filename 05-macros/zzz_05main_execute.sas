%macro zzz_05main_execute;

%put ====> Macro `zzz_05main_execute` STARTS here;
%global HRS_RAND2LONG_version traceit vars_map;
%global waves_list waves_elist waves_sel wave_max_no;

%***_usetup_mvars;




%let DATAIN_NAME =&datain;
%global map_file waves_sel  waves_sel2;
%**global xlsx_fnm map_info;
%global aux_outpath;

%let waves_sel = %upcase(&waves_sel);
%put wave_sel := &waves_sel;
%let  waves_sel2 = %sysfunc(tranwrd(%quote(&waves_sel) ,TO, :));
%put wave_sel2 := &waves_sel2;

data _MAP2Long;
 set &map_info;
run;

%macro skipit;
 ods listing close;
 
 proc template;
  define style styles.custom;
    parent=styles.HTMLBlue;
    class ContentTitle /
      just=center
      font_weight=bold
      font_size=10pt
      color=black
      background=white
      textdecoration=underline
      pretext="<h1>Table &tbl</h1>";
  end;
run; 

 ods html  path      = "&prj_path\&dir_name\&aux_out" (URL=NONE)
           file      = "05-traceit-body.html"
           contents  = "05-traceit-contents.html"
           frame     = "05-traceit-frame.html"
           style     = styles.custom
 ;
 
%*traceit(_MAP2Long);

%** html_aux_report;

/* --- Dataset `dictionary_init` created */
%create_dictionary_init; 

/*---  Create `dictionary_template` dataset ---*/


%dictionary_template;

/* --- Dataset `vars_map_init` created from _MAP2Long*/
%if (&vars_map = Y or &vars_map = E) %then %create_vars_map_init;

/*---  Create `dictionary_template` dataset with 0 rows ---*/
%dictionary_template;

/*--- Create `vars_map_template` dataset  and `waves_elist` macro variables */
%if (&vars_map = Y or &vars_map = E ) %then %vars_map_template;

/*--- Create `_dictionary` dataset */
%create_dictionary;

%_YE_block;
 

ods html close;
ods listing;

%put :::;
%let n_vout = %attrn_nlobs(_dictionary);

/* --- Map file initiated ---*/
data _null_;
  file map_file;
  put "/* This is map_file `&tbl._map_file.inc` for `&tbl._table` dataset */";
  put "/* Repo name := &repo_name (version &repo_version) */";
  put "/* Project name := &prj_name */";
  put "/* Excel map: &xlsx_name..xlsx */";
  put "/* Date stamp: &sysdate  */";
  put /;
run;



/* ===> Macro`put_init_macro_stmnts`
 appends definitions of macros listed below  to `map_file`: 
 * `label_statements`
 * `clength_statements`  
 * `format_statement
 * `create_template_longout`
 * `keepvar_list`
*/
%put_init_macro_stmnts;


%put --- vars_map := &vars_map;
%if (&vars_map = Y or &vars_map =E) %then %do;
  %put_mrg2_stmnts; /* set mrg2 */


filename map_file clear;
%end; /*if */
%put Macro `zzz_05main_execute` ends here;

%mend skipit;
%put --- Macro `zzz_05main_execute` ENDS here;
%put;

%mend zzz_05main_execute;