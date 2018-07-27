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
; outfile = "input_soil_bj2013winter_20130110_12Z_model_d01.txt"
 
 cities  = (/"BJ","SJZ","NJ","ZZ"/)
 ncities = dimsizes(cities)
 
 print(ncities)
 do icity = 0,ncities - 1
 outfile = "./test/input_soil_"+cities(icity)+"2013winter_20130101_12Z_model_d02.txt"

 
  file1 = "/exports/home/cwei/projs_data/BJ2013_Winter_Haze/output/output_v351_"+case1+"/wrfout_d02_2013-01-01_00:00:00"
  f1    = addfile (file1+".nc","r")

  lat2d = f1->XLAT(0,:,:)
  lon2d = f1->XLONG(0,:,:)

  time  = 11
  lat   = (/  39.9 ,    38, 32.1   , 34.7/)   ; Beijing Shijiazhuang Nanjing Zhengzhou
  lon   = (/  116.4, 114.5, 118.8  , 113.6/)

  nm = getind_latlon2d (lat2d,lon2d, lat, lon)

  print(nm)

  print(dimsizes(lat))

;  do k=0,dimsizes(lat)-1
     n = nm(:,0)
     m = nm(:,1)
;     print(lat2d(n,m)+"   "+lon2d(n,m))
;  end do

  print(n)

  printVarSummary(lat2d)
  printMinMax(lat2d, 0)
  printMinMax(lon2d, 0)

 times  = wrf_user_getvar(f1,"times",-1)
 print(times)

 printVarSummary(f1->TSK)
 print(n(0))
 print(m(0))
 
 tsk  = f1->TSK(2,n(0),m(0))

 print(tsk)

 tmn  = f1->TMN(2,n(0),m(0))
 print(tmn)

 zsoil = f1->ZS(2,:)
 print(zsoil)

 tslb    = f1->TSLB(2,:,n(0),m(0))                                   ; get data   
 print(tslb)

 smois   = f1->SMOIS(2,:,n(0),m(0))                                   ; get data   
 print(tslb)


 data  = new( 5, "string")

 data(0) = "0.0" 
 data(0) = data(0) + sprintf("%9.1f ",tsk)
 data(0) = data(0) + sprintf("%9.1f ",tmn)

 do i=1,4   
   data(i) = sprintf("%9.3f", zsoil(i-1))  
   data(i) = data(i) + sprintf("%9.1f", tslb(i-1) )
   data(i) = data(i) + sprintf("%9.3f", smois(i-1))
 end do
       
 asciiwrite (outfile, data)

end do
end
