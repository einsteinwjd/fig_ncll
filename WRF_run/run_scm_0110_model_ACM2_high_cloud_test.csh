#!/bin/csh

#PBS -N run_scm_0110_ACM2_high_cloud_test
#PBS -q big

#PBS -l nodes=1:ppn=1
#PBS -l walltime=100:00:00
#PBS -o /home/wjd/WRF_scm/scripts/run_scm_0110_model_ACM2_high_cloud_test.log
#PBS -j oe

set echo ON
set BASEDIR = /home/wjd/WRF_scm/scripts
set INPUTDIR = $BASEDIR/../em_scm_xy
set MODELDIR = $BASEDIR/../WRFV3.8.1
set casename = "0110_12Z_model_ACM2_high_cloud_test_v2"
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
ln -sf $INPUTDIR/input_cloud.txt			                input_cloud.txt
ln -sf $INPUTDIR/input_cloud_layer_high_cloud.txt                                  input_cloud_layer.txt

#-- cope namelist
ln -sf $INPUTDIR/namelist.input.bj.0110_12Z_ACM2 namelist.input

ln -sf $MODELDIR/main/ideal.exe ideal.exe
ideal.exe >& ideal.log

#ln -sf /home/cwei/projs/BJ2013_Winter_Haze/em_scm_xy/wrfinput_d01_2013011012Z_ACM2_codctrl wrfinput_d01
cp wrfinput_d01 wrfinput_d01_2013011012Z_ACM2_codctrl

#==========================================
# prepare namelist and other input files
#==========================================
cp $INPUTDIR/input_pblh.txt ./
cp $INPUTDIR/input_rhfac.txt ./

#-- copy tables
ln -sf $MODELDIR/run/*DATA* ./
ln -sf $MODELDIR/run/*TBL ./ 
ln -sf $MODELDIR/run/*formatted ./
ln -sf $MODELDIR/run/tr* ./

ln -sf $MODELDIR/main/wrf.exe wrf.exe

#foreach jdayin("1" "30" "60" "90" "120" "150" "180")
foreach jdayin("1")
#foreach aodin("0.0" "0.2" "0.5" "0.7" "1.0" "2.0" "3.0" "4.0" "5.0" "6.0")
foreach aodin("0.0")
#foreach qc_in("0.0" "1E-5" "5E-5" "1E-4" "2E-4" "5E-4" "1E-3" "2E-3" "5E-3")
foreach qc_in("1E-5" "5E-5" "1E-4")
if ( -f input_jday.txt ) rm -f input_jday.txt

#-------------------------
# prepare input files
#-------------------------

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

if ( -f input_cloud.txt ) rm -f input_cloud.txt
set qi_in = 0.0

cat << End_Of_Inputaod  > input_cloud.txt
$qc_in  $qi_in

End_Of_Inputaod

echo $qc_in

#-----------------------
# running wrf
#-----------------------                                                                      

wrf.exe >& check_j${jdayin}_aod${qc_in}.log

#-- rename output files

set outfile = ${file}"Z_${casename}_j${jdayin}_cloud${qc_in}"
cp $infile $outfile

echo "end of case"

end
end
end



