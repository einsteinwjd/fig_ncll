#!/bin/csh

#PBS -N chem_CITY_SDAY
#PBS -q big

#PBS -l nodes=1:ppn=1
#PBS -l walltime=100:00:00
#PBS -o /home/wjd/WRF_scm/scripts/log/chem_CITY_SDAY.log
#PBS -j oe

set echo ON
set BASEDIR = /home/wjd/WRF_scm/scripts
set INPUTDIR = $BASEDIR/../em_scm_xy
set MODELDIR = /home/wjd/model/WRFV3.8.1_aod_chem_v3
foreach day_str("SDAY")
setenv Day ${day_str}
set casename = "chem_01${Day}_12Z_CITY_3bin"
set outputdir = /home/wjd/nobackup/data/WRF-SCM/output_${casename}
#set outputdir = /home/cwei/
#set startmm = "01"
#set startdd = "10"
#set starthh = "12"
#set endmm = "01"
#set enddd = "13"
#set endhh = "00"
#set runhours = "60"

if ( ! -d $outputdir ) then

  mkdir $outputdir
  ln -sf $outputdir $BASEDIR

endif
cd $outputdir

set file = "wrfout_d01_2013-01-${Day}_12"
set infile = ${file}":00:00"

#=============================
# prepare forcing files 
#=============================
# modify date in forcing_file.cdl
#ncl make_scm_forcing.ncl
ln -sf $INPUTDIR/input/force_ideal_01${Day}_12Z.nc force_ideal.nc

#=============================
# prepare wrfinput files
#=============================
# need input_soil input_sounding
ln -sf $INPUTDIR/test/input_soil_CITY2013winter_201301${Day}_12Z_model_d02.txt   input_soil_bj2013winter
ln -sf $INPUTDIR/test/input_sounding_CITY201301${Day}_12Z.txt                input_sounding_bj2013winter
ln -sf $INPUTDIR/input_cloud.txt                                        input_cloud.txt
ln -sf $INPUTDIR/input_cloud_layer_high_cloud.txt               input_cloud_layer.txt
ln -sf $INPUTDIR/input_asmaer.txt					input_asmaer.txt
ln -sf $INPUTDIR/input_aodfrac_uniform_notnorm.txt                                       input_aodfrac.txt

#-- cope namelist
ln -sf $INPUTDIR/test/namelist.input.chem.CITY.201301${Day} namelist.input

ln -sf $MODELDIR/main/ideal.exe ideal.exe
ideal.exe >& ideal.log
#cp $INPUTDIR/wrfinput_d01 wrfinput_d01.nc
#ln -sf $INPUTDIR/modify_wrf_input.ncl .
#ncl modify_wrf_input.ncl 
#ln -sf /home/cwei/projs/BJ2013_Winter_Haze/em_scm_xy/wrfinput_d01_2013011012Z_ACM2_codctrl wrfinput_d01
#cp wrfinput_d01.nc wrfinput_d01_2013011012Z_ACM2_codctrl

#==========================================
# prepare namelist and other input files
#==========================================
cp -f $INPUTDIR/input_pblh.txt ./
cp -f $INPUTDIR/input_rhfac.txt ./

#-- copy tables
ln -sf $MODELDIR/run/*DATA* ./
ln -sf $MODELDIR/run/*TBL ./ 
ln -sf $MODELDIR/run/*formatted ./
ln -sf $MODELDIR/run/tr* ./

ln -sf $MODELDIR/main/wrf.exe wrf.exe

#foreach jdayin("30" "60" "90" "120" "150" "180")
#foreach jdayin("30" "60")
#foreach jdayin("1" "30" "60" "90" "120" "150" "180")
foreach jdayin("1")
foreach bc_ratio("0.05" "0.10")
#foreach aodin("0.0" "0.2" "0.5" "0.7" "1.0" "2.0" "3.0" "4.0" "5.0" "6.0")
#foreach aodin("0.0" "0.1" "0.2" "0.3" "0.4" "0.5" "0.6" "0.7" "0.8" "0.9" "1.0" "1.1" "1.2" "1.3" "1.4" "1.5" "1.6" "1.7" "1.8" "1.9" "2.0" "2.1" "2.2" "2.3" "2.4" "2.5" "2.6" "2.7" "2.8" "2.9" "3.0")
#foreach aodin("0.0" "0.1" "0.2" "0.3" "0.4" "0.5" "0.6" "0.7" "0.8" "0.9" "1.0" "1.1" "1.2" "1.3" "1.4" "1.5" "1.6" "1.7" "1.8" "1.9" "2.0" "2.1" "2.2" "2.3" "2.4" "2.5" "2.6" "2.7" "2.8" "2.9" "3.0" "3.1" "3.2" "3.3" "3.4" "3.5" "3.6" "3.7" "3.8" "3.9" "4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "5.0" "5.1" "5.2" "5.3" "5.4" "5.5" "5.6" "5.7" "5.8" "5.9" "6.0" "10.0" "15.0" "20.0")

foreach aodin("0.0")
#foreach ssa("1.0","0.99","0.98","0.97","0.96","0.95","0.94","0.93","0.92","0.91","0.90")
#foreach ssa("0.80" "0.85" "0.90" "0.95")
 foreach ssa("0.85")
foreach qc_in("0.0")
foreach asmaerin("0.65")
#foreach bc_tconc("10" "20" "30" "40" "50" "60" "70" "80" "90" "100" "110" "120" "130" "140" "150" "160" "170" "180" "190" "200")
foreach bc_tconc("0" "10" "20" "30" "40" "50" "60" "70" "80" "90" "100" "110" "120" "130" "140" "150" "160" "170" "180" "190" "200" "210" "220" "230" "240" "250" "260" "270" "280" "290" "300" "310" "320" "330" "340" "350" "360" "370" "380" "390" "400" "410" "420" "430" "440" "450" "460" "470" "480" "490" "500" "510" "520" "530" "540" "550" "560" "570" "580" "590" "600" "610" "620" "630" "640" "650" "660" "670" "680" "690" "700")
if ( -f input_jday.txt ) rm -f input_jday.txt

#-------------------------
# prepare input files
#-------------------------
cat << End_Of_Inputaod  > input_bc_tconc.txt
$bc_tconc

End_Of_Inputaod

echo $bc_tconc

#cp -f $INPUTDIR/wrfinput_d01 wrfinput_d01
ln -sf $INPUTDIR/modify_wrf_input_PM_3bin.ncl ./modify_wrf_input.ncl
ncl modify_wrf_input.ncl
#ln -sf /home/cwei/projs/BJ2013_Winter_Haze/em_scm_xy/wrfinput_d01_2013011012Z_ACM2_codctrl wrfinput_d01
cp -f wrfinput_d01 wrfinput_d01_2013011012Z_ACM2_codctrl

cat << End_Of_Inputjday  > input_jday.txt
$jdayin

End_Of_Inputjday

echo $jdayin

if ( -f input_aod.txt ) rm -f input_aod.txt
set angin = 1.2

cat << End_Of_Inputaod  > input_aod.txt
$aodin  $angin

End_Of_Inputaod

echo $aodin

if ( -f input_ssa.txt ) rm -f input_ssa.txt
#set angin = 1.2

cat << End_Of_Inputaod  > input_ssa.txt
$ssa

End_Of_Inputaod

echo $ssa

if ( -f input_bc_ratio.txt ) rm -f input_bc_ratio.txt
#set angin = 1.2

cat << End_Of_Inputaod  > input_bc_ratio.txt
$bc_ratio

End_Of_Inputaod

echo $bc_ratio


if ( -f input_cloud.txt ) rm -f input_cloud.txt
set qi_in = 0.0

cat << End_Of_Inputaod  > input_cloud.txt
$qc_in $qi_in

End_Of_Inputaod

echo $qc_in

if ( -f input_asmaer.txt ) rm -f input_asmaer.txt

cat << End_Of_Inputaod  > input_asmaer.txt
$asmaerin

End_Of_Inputaod

echo $asmaerin


#-----------------------
# running wrf
#-----------------------                                                                      

wrf.exe >& check_j${jdayin}_bctconc${bc_tconc}_ssa${ssa}.log

#-- rename output files

set outfile = ${file}"Z_${casename}_j${jdayin}_bctconc${bc_tconc}_bcratio${bc_ratio}_ssa${ssa}"
cp $infile $outfile

echo "end of case"

end
end
end
end
end
end
end
end
