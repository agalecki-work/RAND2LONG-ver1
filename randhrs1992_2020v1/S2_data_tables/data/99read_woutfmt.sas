options nofmterr;
ods hmtl;
libname lib '.';
proc print data=lib.hlong_table(obs=100);
run;
ods html close;