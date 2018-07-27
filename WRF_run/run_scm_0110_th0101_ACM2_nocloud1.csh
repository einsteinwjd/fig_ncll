#!/bin/csh

#PBS -N run_scm_0110_th0101_ACM2_nocld1
#PBS -q big

#PBS -l nodes=1:ppn=1
#PBS -l walltime=100:00:00
#PBS -o /home/wjd/WRF_scm/scripts/run_scm_0110_th0101_ACM2_nocld1.log
#PBS -j oe

set echo ON

set BASEDIR = /home/wjd/WRF_scm/scripts
set INPUTDIR = $BASEDIR/../em_scm_xy
set MODELDIR = $BASEDIR/../WRFV3.5.1
#set outputdir = /home/cwei/
set casename = "0110_12Z_th0101_ACM2_nocld1"
set outputdir = /home/wjd/nobackup/data/WRF-SCM/output_${casename}

#set startmm = "01"
#set startdd = "01"
#set starthh = "12"
#set endmm = "01"
#set enddd = "04"
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
ln -sf $INPUTDIR/input/input_soil_bj2013winter_20130110_12Z_model.txt     input_soil_bj2013winter
ln -sf $INPUTDIR/input/input_sounding_bj20130110_TH20130101_12Z.txt  input_sounding_bj2013winter

#-- cope namelist
ln -sf $INPUTDIR/namelist.input_2013011012Z_th010112Z_ACM2 namelist.input

ln -sf $MODELDIR/main/ideal.exe ideal.exe
ideal.exe >& ideal.log

#ln -sf /home/cwei/projs/BJ2013_Winter_Haze/em_scm_xy/wrfinput_d01_2013010112Z_q011012Z wrfinput_d01
cp wrfinput_d01 wrfinput_d01_2013011012Z_th010112Z

#==========================================
# prepare namelist and other input files
#==========================================
cp  $INPUTDIR/input_pblh.txt ./
cp  $INPUTDIR/input_rhfac.txt ./

#-- copy tables
ln -sf $MODELDIR/run/*DATA* ./
ln -sf $MODELDIR/run/*TBL ./ 
ln -sf $MODELDIR/run/*formatted ./
ln -sf $MODELDIR/run/tr* ./

ln -sf $MODELDIR/main/wrf.exe.nocloud1 wrf.exe

#foreach jdayin("1" "30" "60" "90" "120" "150" "180")
foreach jdayin("1")
#foreach aodin("0.0" "0.2" "0.5" "0.7" "1.0" "2.0" "3.0" "4.0" "5.0" "6.0")
foreach aodin("0.0")
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

#-----------------------
# running wrf
#-----------------------                                                                      

wrf.exe >& check_j${jdayin}_aod${aodin}.log

#-- rename output files

set outfile = ${file}"Z_${casename}_j${jdayin}_aod${aodin}"
cp $infile $outfile

echo "end of case"

end
end



