#!/bin/csh

set echo ON
@ i = 1
foreach cities("BJ")
setenv CITY ${cities}
foreach day_str("10")
setenv Day ${day_str}
foreach bc_ratio("0.01" "0.02" "0.03" "0.04" "0.05" "0.06" "0.07" "0.08" "0.09" "0.10" "0.11" "0.12" "0.13" "0.14" "0.15" "0.16" "0.17" "0.18" "0.19" "0.20")
#setenv Day ${day_str}

#setenv Day_end ${day_end}
echo $Day
#setenv Day_end = ${day_end[$i]}

sed "s/bcratio_input/$bc_ratio/g"  run_scm_bc_ratio_chem_profile_BJ_temple_domain2.csh  > ./run_BJ_domain2/run_scm_BJ_chem_profile_${cities}_${Day}_BC_ratio_$bc_ratio.csh 
#sed "s/eday/$day_end[$i]/g"  ./test/namelist.input.tmp > ./test/namelist.input.201701${Day}  

qsub ./run_BJ_domain2/run_scm_BJ_chem_profile_${cities}_${Day}_BC_ratio_$bc_ratio.csh

@ i = $i + 1

end
end
