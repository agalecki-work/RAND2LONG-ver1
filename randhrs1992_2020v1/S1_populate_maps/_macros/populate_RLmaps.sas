%macro populate_RLmaps(table);
%put ===> Macro `populate_RLmaps` STARTS ===;
/* Use wave variables to populate `wave_summary` and `wave_pattern` variables */
/* Macro used for RLong and Hlong tables */
%let map0 =_libmap0.&table._map0;
%let mapx =_libmap.&table._map;
%let waves_list = hrs_wave1 - hrs_wave15;
data &mapx; 
 retain name label clength format dispatch wave_summary wave_pattern;
 set &map0;
 length c1 $1;
 length wave_summary $40;
 length wave_pattern $40;
 c1 =substr(strip(name),1,1);
 if c1 ne ':' then DO;
 array _waves {*} $ &waves_list;
 length ci $30; 
 countx =0;
 do i=1 to dim(_waves);
  ci = _waves[i];
  if ci ne "" then countx+1;
 end;
 
 if countx = 0 and dispatch ="" then do;
    wave_pattern = "-- RAND var";
    wave_summary = "-- N/A";
 end;
 
 put  "---" countx =;
 
 if countx = 0 and dispatch ne "" then do;
     wave_pattern = "-- Derived var";
     wave_summary = "-- N/A";
 end;
 
 
 if countx >0 then do;
 done =0;
  wave_summary ="ooooOooooOooooO";
  wave_pattern ="";
 put "---- doi i=1 to dim(_waves)";
 do i=1 to dim(_waves);
   ci = _waves[i];
   if ci ne "" then substr(wave_summary,i,1)="x";
   if ci ne "" and i in (5,10,15) then substr(wave_summary,i,1)="X";
  
  if ci ne "" and i <10 and wave_pattern = "" and done =0 then do;
    done =1;
    substr(ci,2,1) = "?";
    wave_pattern =tranwrd(ci,"?","[w]"); 
   end;  /* if ci ..., i < 10*/
  if ci ne "" and i >=10 and wave_pattern = "" and done =0 then do;
      done =1;
      substr(ci,2,2) = "?";
      wave_pattern =tranwrd(ci,"?","[w]"); 
     end;  /* if ci ...,i>=10 */
 
  
  end; /* do i */
 
 end; /* if countx >0 */
 /*--- Wave pattern exceptions */
  if upcase(strip(name)) = "WAVE_NUMBER" then wave_pattern = "-- Num 1,2, ...";
  if upcase(strip(name)) = "INW" then wave_pattern = "INW[w]";
  if upcase(strip(name)) = "CYEAR" then wave_pattern = "-- yr#### string";
 
 END; /* if c1 ne : */

 drop i ci c1 done;
 
run;
%mend populate_RLmaps;