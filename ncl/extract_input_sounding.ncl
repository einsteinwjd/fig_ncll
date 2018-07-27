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
 outfile = "./test/input_sounding_bj20130110_12Z.txt"
 
 file1 = "/exports/home/cwei/projs_data/BJ2013_Winter_Haze/output/output_v351_"+case1+"/wrfout_d03_2013-01-10_00:00:00"
 f1    = addfile (file1+".nc","r")

 times  = wrf_user_getvar(f1,"times",-1)
 print(times)

 x = 23
 y = 23
 ndata = 27
  
; tsk  = f1->TSK(12,23,23)
; print(tsk)

; tmn  = f1->TMN(12,23,23)
; print(tmn)

; zsoil = f1->ZS(12,:)
; print(zsoil)

; tslb    = f1->TSLB(12,:,23,23)                                   ; get data   
; print(tslb)

; smois   = f1->SMOIS(12,:,23,23)                                   ; get data   
; print(tslb)

 pres = wrf_user_getvar(f1,"p",-1)
 print(pres(12,:,x,y))

 h = wrf_user_getvar(f1,"z",-1)
 print(h(12,:,x,y))

 tc = wrf_user_getvar(f1,"tc",-1)
 print(tc(12,:,x,y))

 dwptc = wrf_user_getvar(f1,"td",-1)
 print(dwptc(12,:,x,y))

 rh = wrf_user_getvar(f1,"rh",-1)
 print(rh(12,:,x,y))

 QVAPOR = f1->QVAPOR * 1000 ; g/kg
 print(QVAPOR(12,:,x,y))

 wd = rh
 sknt = rh

 th     = wrf_user_getvar(f1,"th",-1) 
 print(th(12,:,x,y))
 
 thte  = th
 thtv  = th 

 data  = new( ndata, "string")

; data(0) = "0.0" 
; data(0) = data(0) + sprintf("%9.1f ",tsk)
; data(0) = data(0) + sprintf("%9.1f ",tmn)

 do n= 0 , ndata-1  
   print(n) 
   data(n) = sprintf("%9.1f",pres(12,n,x,y) )  
   data(n) = data(n) + sprintf("%9.0f", h(12,n,x,y))
   data(n) = data(n) + sprintf("%9.1f", tc(12,n,x,y))
   data(n) = data(n) + sprintf("%9.1f", dwptc(12,n,x,y))
   data(n) = data(n) + sprintf("%9.0f", rh(12,n,x,y))
   data(n) = data(n) + sprintf("%9.2f", QVAPOR(12,n,x,y))
   data(n) = data(n) + sprintf("%9.0f", wd(12,n,x,y))
   data(n) = data(n) + sprintf("%9.0f", sknt(12,n,x,y))
   data(n) = data(n) + sprintf("%9.1f", th(12,n,x,y))
   data(n) = data(n) + sprintf("%9.1f", thte(12,n,x,y))
   data(n) = data(n) + sprintf("%9.1f", thtv(12,n,x,y))
 end do
       
 asciiwrite (outfile, data)

end
