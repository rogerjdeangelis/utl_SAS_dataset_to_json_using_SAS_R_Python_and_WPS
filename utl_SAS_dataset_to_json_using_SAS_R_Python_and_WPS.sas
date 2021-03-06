SAS dataset to json using SAS R Python and WPS

  Four Solutions ( all give the same result)

    1. SAS proc json
    2. WPS proc json
    3. WPS proc R
    4. WPS proc python

github
https://tinyurl.com/y7rvptrh
https://github.com/rogerjdeangelis/utl_SAS_dataset_to_json_using_SAS_R_Python_and_WPS

see
https://tinyurl.com/ybl2uw2y
https://stackoverflow.com/questions/50248849/pass-array-into-each-object-in-json-file-proc-json-sas

Crellee profile
https://stackoverflow.com/users/6181187/crellee


INPUT
=====

SD1.HAVE total obs=8

  ID    AMOUNT    DIMENSION

  1       x           A
  1       x           B
  1       x           C
  2       y           A
  2       y           X
  3       z           C
  3       z           K
  3       z           X

EXAMPLE OUTPUT (ALL CREATE THIS)

[
  {
    "id": "1",
    "amount": "x",
    "dimension": "A"
  },
  {
    "id": "1",
    "amount": "x",
    "dimension": "B"
  },
  {
    "id": "1",
    "amount": "x",
    "dimension": "C"
  },
...]


PROCESS  (Working code)
========================

     1. SAS proc json

        proc json out='d:/json/have.json' pretty nosastags;
             export have;
        run;quit


     2. WPS proc json  (not sure prety works but I rather not use it)

        proc json out='d:/json/have.json' pretty nosastags;
             export have;
        run;quit;

     3. WPS proc R

        export(have,"d:/json/have_wps_r.json");

     4. WPS proc python (lot of options?)

        have.to_json('d:/json/have_wps_proc_python.json',orient='records', lines=True);


OUTPUT (all look like this)
===========================

   d:/json/have.json

   [{"ID":"1","AMOUNT":"x","DIMENSION":"A"}
   ,{"ID":"1","AMOUNT":"x","DIMENSION":"B"}
   ,{"ID":"1","AMOUNT":"x","DIMENSION":"C"}
   ,{"ID":"2","AMOUNT":"y","DIMENSION":"A"}
   ,{"ID":"2","AMOUNT":"y","DIMENSION":"X"}
   ,{"ID":"3","AMOUNT":"z","DIMENSION":"C"}
   ,{"ID":"3","AMOUNT":"z","DIMENSION":"K"}
   ,{"ID":"3","AMOUNT":"z","DIMENSION":"X"}]

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input id $ amount $ dimension $;
cards4;
1 x A
1 x B
1 x C
2 y A
2 y X
3 z C
3 z K
3 z X
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/

;

*
 ___  __ _ ___
/ __|/ _` / __|
\__ \ (_| \__ \
|___/\__,_|___/

;

proc json out='d:/json/have.json' pretty nosastags;
     export have;
run;


*
__      ___ __  ___
\ \ /\ / / '_ \/ __|
 \ V  V /| |_) \__ \
  \_/\_/ | .__/|___/
         |_|
;


%utl_submit_wps64('
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc json out='d:/json/have_wos_proc_json.json' pretty nosastags;
     export sd1.have;
run;quit;
');

*                      ______
__      ___ __  ___   / /  _ \
\ \ /\ / / '_ \/ __| / /| |_) |
 \ V  V /| |_) \__ \/ / |  _ <
  \_/\_/ | .__/|___/_/  |_| \_\
         |_|
;

* WPS PROC R
%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.1";
libname wrk sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.1/etc/Rprofile.site", echo=T);
library(haven);
library(rio);
have<-read_sas("d:/sd1/have.sas7bdat");
head(have);
export(have,"d:/json/have_wps_r.json");
endsubmit;
run;quit;
');

*                      __           _   _
__      ___ __  ___   / / __  _   _| |_| |__   ___  _ __
\ \ /\ / / '_ \/ __| / / '_ \| | | | __| '_ \ / _ \| '_ \
 \ V  V /| |_) \__ \/ /| |_) | |_| | |_| | | | (_) | | | |
  \_/\_/ | .__/|___/_/ | .__/ \__, |\__|_| |_|\___/|_| |_|
         |_|           |_|    |___/
;

%utl_submit_wps64("
options set=PYTHONHOME 'C:\Users\backup\AppData\Local\Programs\Python\Python35\';
options set=PYTHONPATH 'C:\Users\backup\AppData\Local\Programs\Python\Python35\lib\';
libname sd1 'd:/sd1';
proc python;
submit;
import numpy as np;
import pandas as pd;
from sas7bdat import SAS7BDAT;
have = pandas.read_sas('d:/sd1/have.sas7bdat',encoding='ascii');
have.to_json('d:/json/have_wps_proc_python.json',orient='records', lines=True);
endsubmit;
run;quit;
");


