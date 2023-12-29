%macro zzz_05include;

%put ===> Macro `zzz_05include` STARTS here ======;
%put --- Macros listed below will be loaded:; 

/*-- `zzz_05table_execute` */
%put  - macro `zzz_05table_execute`;
%include _macros(zzz_05table_execute);



/*-- `put_init_macro_stmnts` */
%put  - macro `put_init_macro_stmnts`;
%include _macros(put_init_macro_stmnts);



%put --- Macro `zzz_05include` ENDS here ======;
%put;
%mend zzz_05include;

