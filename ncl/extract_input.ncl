;******************************************************
; SCM: Single Column Model
; WRF SCM: time-eta cross section.
;********************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"

begin

 case1   = "1xaer"
 outfile = "./test/input_soil_bj2013winter_20130110_12Z_model.txt"
 
 file1 = "/exports/home/cwei/projs_data/BJ2013_Winter_Haze/output/output_v351_"+case1+"/wrfout_d03_2013-01-10_00:00:00"
 f1    = addfile (file1+".nc","r")

 times  = wrf_user_getvar(f1,"times",-1)
 print(times)
 
 tsk  = f1->TSK(12,23,23)
 print(tsk)

 tmn  = f1->TMN(12,23,23)
 print(tmn)

 zsoil = f1->ZS(12,:)
 print(zsoil)

 tslb    = f1->TSLB(12,:,23,23)                                   ; get data   
 print(tslb)

 smois   = f1->SMOIS(12,:,23,23)                                   ; get data   
 print(tslb)


 data  = new( 5, "string")

 data(0) = "0.0" 
 data(0) = data(0) + sprintf("%9.1f ",tsk)
 data(0) = data(0) + sprintf("%9.1f ",tmn)

 do n=1,4   
   data(n) = sprintf("%9.3f", zsoil(n-1))  
   data(n) = data(n) + sprintf("%9.1f", tslb(n-1) )
   data(n) = data(n) + sprintf("%9.3f", smois(n-1))
 end do
       
 asciiwrite (outfile, data)

end
