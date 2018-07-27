#!/bin/csh

#PBS -N run_scm_0110_chem_emis
#PBS -q big

#PBS -l nodes=1:ppn=1
#PBS -l walltime=100:00:00
#PBS -o /home/wjd/WRF_scm/scripts/run_scm_0110_model_ACM2_chem_emis.log
#PBS -j oe

set echo ON
set BASEDIR = /home/wjd/WRF_scm/scripts
set INPUTDIR = $BASEDIR/../em_scm_xy
set MODELDIR = /home/wjd/model/WRFV3.8.1_aod_chem_emission_v2
set casename = "0110_12Z_model_ACM2_chem_EXCH_emis_noinitial"
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

set file = "wrfout_d01_2013-01-10_12"
set infile = ${file}":00:00"

#=============================
# prepare forcing files 
#=============================
# modify date in forcing_file.cdl
#ncl make_scm_forcing.ncl
ln -sf $INPUTDIR/input/force_ideal_0110_12Z.nc force_ideal.nc

#=============================
# prepare wrfinput files
#=============================
# need input_soil input_sounding
ln -sf $INPUTDIR/input/input_soil_bj2013winter_20130110_12Z_model.txt   input_soil_bj2013winter
ln -sf $INPUTDIR/input/input_sounding_bj20130110_12Z.txt                input_sounding_bj2013winter
ln -sf $INPUTDIR/input_cloud.txt                                        input_cloud.txt
ln -sf $INPUTDIR/input_cloud_layer_high_cloud.txt               input_cloud_layer.txt
ln -sf $INPUTDIR/input_asmaer.txt					input_asmaer.txt
ln -sf $INPUTDIR/input_aodfrac_uniform.txt                                       input_aodfrac.txt

#-- cope namelist
ln -sf $INPUTDIR/namelist.input.bj.0110_12Z_ACM2_chem_emis namelist.input

ln -sf $MODELDIR/main/ideal.exe ideal.exe
#ideal.exe >& ideal.log
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

#foreach jdayin("1" "30" "60" "90" "120" "150" "180")
#foreach jdayin("30" "60")
#foreach jdayin("1" "30" "60" "90" "120" "150" "180")
foreach jdayin("1")
#foreach emis("0.0008" "0.0016" "0.004" "0.008" "0.016" "0.04" "0.08")
#foreach emis("0.0016" "0.004" "0.008" "0.016" "0.04" "0.08")
#foreach emis("0")
foreach emis("0.001" "0.002" "0.003" "0.004" "0.005" "0.006" "0.007" "0.008" "0.009" "0.01" "0.011" "0.012" "0.013" "0.014" "0.015" "0.016" "0.017" "0.018" "0.019" "0.02" "0.021" "0.022" "0.023" "0.024" "0.025" "0.026" "0.027" "0.028" "0.029" "0.03" "0.031" "0.032" "0.033" "0.034" "0.035" "0.036" "0.037" "0.038" "0.039" "0.04" "0.041" "0.042" "0.043" "0.044" "0.045" "0.046" "0.047" "0.048" "0.049" "0.05" "0.051" "0.052" "0.053" "0.054" "0.055" "0.056" "0.057" "0.058" "0.059" "0.06" "0.061" "0.062" "0.063" "0.064" "0.065" "0.066" "0.067" "0.068" "0.069" "0.07" "0.071" "0.072" "0.073" "0.074" "0.075" "0.076" "0.077" "0.078" "0.079" "0.08" "0.081" "0.082" "0.083" "0.084" "0.085" "0.086" "0.087" "0.088" "0.089" "0.09" "0.091" "0.092" "0.093" "0.094" "0.095" "0.096" "0.097" "0.098" "0.099" "0.1")
#foreach aodin("0.0" "0.2" "0.5" "0.7" "1.0" "2.0" "3.0" "4.0" "5.0" "6.0")
#foreach aodin("0.0" "0.1" "0.2" "0.3" "0.4" "0.5" "0.6" "0.7" "0.8" "0.9" "1.0" "1.1" "1.2" "1.3" "1.4" "1.5" "1.6" "1.7" "1.8" "1.9" "2.0" "2.1" "2.2" "2.3" "2.4" "2.5" "2.6" "2.7" "2.8" "2.9" "3.0")
#foreach aodin("0.0" "0.1" "0.2" "0.3" "0.4" "0.5" "0.6" "0.7" "0.8" "0.9" "1.0" "1.1" "1.2" "1.3" "1.4" "1.5" "1.6" "1.7" "1.8" "1.9" "2.0" "2.1" "2.2" "2.3" "2.4" "2.5" "2.6" "2.7" "2.8" "2.9" "3.0" "3.1" "3.2" "3.3" "3.4" "3.5" "3.6" "3.7" "3.8" "3.9" "4.0" "4.1" "4.2" "4.3" "4.4" "4.5" "4.6" "4.7" "4.8" "4.9" "5.0" "5.1" "5.2" "5.3" "5.4" "5.5" "5.6" "5.7" "5.8" "5.9" "6.0" "10.0" "15.0" "20.0")

foreach aodin("0.0")
#foreach ssa("1.0","0.99","0.98","0.97","0.96","0.95","0.94","0.93","0.92","0.91","0.90")
#foreach ssa("0.80" "0.85" "0.90" "0.95")
 foreach ssa("0.85")
foreach qc_in("0.0")
foreach asmaerin("0.65")
#foreach bc_tconc("10" "20" "30" "40" "50" "60" "70" "80" "90" "100" "110" "120" "130" "140" "150" "160" "170" "180" "190" "200" "210" "220" "230" "240" "250" "260" "270" "280" "290" "300" "310" "320" "330" "340" "350" "360" "370" "380" "390" "400")
foreach bc_tconc("0")
if ( -f input_jday.txt ) rm -f input_jday.txt

#-------------------------
# prepare input files
#-------------------------
cat << End_Of_Inputaod  > input_bc_tconc.txt
$bc_tconc

End_Of_Inputaod

echo $bc_tconc

cp -f $INPUTDIR/wrfinput_d01 wrfinput_d01
ln -sf $INPUTDIR/modify_wrf_input.ncl .
ncl modify_wrf_input.ncl
#ln -sf /home/cwei/projs/BJ2013_Winter_Haze/em_scm_xy/wrfinput_d01_2013011012Z_ACM2_codctrl wrfinput_d01
cp -f wrfinput_d01 wrfinput_d01_2013011012Z_ACM2_codctrl

cat << End_Of_Inputjday  > input_jday.txt
$jdayin

End_Of_Inputjday

echo $jdayin

if ( -f input_emis.txt ) rm -f input_emis.txt

cat << End_Of_Inputaod  > input_emis.txt
$emis

End_Of_Inputaod

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

wrf.exe >& check_j${jdayin}_emis${emis}_bctconc${bc_tconc}_ssa${ssa}.log

#-- rename output files

set outfile = ${file}"Z_${casename}_j${jdayin}_emis${emis}_bctconc${bc_tconc}_qc${qc_in}_ssa${ssa}"
cp $infile $outfile

echo "end of case"

end
end
end
end
end
end
end

