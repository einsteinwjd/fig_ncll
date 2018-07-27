#!/bin/csh

set echo ON
@ i = 1
foreach cities("BJ" "NJ" "ZZ")
setenv CITY ${cities}
foreach day_str("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25")
setenv Day ${day_str}
#setenv Day_end ${day_end}
echo $Day
#setenv Day_end = ${day_end[$i]}

sed "s/SDAY/$Day/g; s/CITY/${cities}/g"  run_scm_chem.temple.inputPM2.5.csh > ./run/run_scm_multidays_chem_profile_${cities}_$Day.csh 
#sed "s/eday/$day_end[$i]/g"  ./test/namelist.input.tmp > ./test/namelist.input.201701${Day}  

qsub ./run/run_scm_multidays_chem_profile_${cities}_$Day.csh

@ i = $i + 1

end
end
