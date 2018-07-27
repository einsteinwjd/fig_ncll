;********************************************************
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
;************************************************
; read in data
;************************************************
; 2D: GRDFLX, PBLH, HFX, LH, T2, U10, V10, Q2, QFX, GLW, SWDOWN 
; 3D: water_a04, EXTAER2, PM2_5_DRY, PM10, SH2O, SMOIS, TSLB
; derived: rh, aod, netupheatflux, netSLWDNB, netSWDNB, netLWDNB,

 spec = getenv("SPEC")
 if (ismissing(spec))then
   print("Manually input spec")
   spec = "PBLH"   
 end if
 
ncase      = 10

icomp = 1
if(icomp .eq.1)
;-- comparing diffrent cases
 jday       = "j1"
 jdayin     = (/jday,jday,jday,jday,jday,jday,jday,jday,jday,jday/)
 aod        = "aod0.0"
 aodin      = (/aod,  aod, aod, aod, aod, aod, aod, aod, aod, aod/)
 casenames  = (/"0101_12Z_model_ACM2","0101_12Z_q0110_ACM2_nocloud2","0101_12Z_t0110_ACM2","0110_12Z_q0101_ACM2","0110_12Z_ACM2_nocloud2","0110_12Z_th0101_ACM2_nocloud2","0109_12Z_model_ACM2","0109_12Z_q0101_ACM2","0109_12Z_q0110_ACM2","0108_12Z_model_ACM2"/)
 tablecase  = "_"+jday+"_"+aod
 sdays      = (/"01","01","01","10","10","10","09","09","09","08"/)
 labels     = casenames
 title      = spec+" in "+tablecase+" case"
 
else

;-- comparing diffrent input from the same case
 jday       = "j1"
 jdayin     = (/jday,jday,jday,jday,jday,jday,jday/)
 aodin      = (/"aod0.0","aod0.5","aod1.0","aod2.0","aod3.0","aod4.0","aod6.0"/)
 casename   = "0101_12Z_model"
 casenames  = (/casename,casename,casename,casename,casename,casename,casename/)
 tablecase  = "_"+casename
 sday       = "01"
 sdays      = (/sday,sday,sday,sday,sday,sday,sday/)
 labels     = aodin
 title      = spec+" in "+casename+"_"+jday
end if

ilayer     = 0

pltType = "png"
casecolors = (/"purple","green","yellow","red","black","blue","orange","darkgreen","deepskyblue","deeppink"/)
casemakers = (/6,11,9,3,5,8,7,4,10,12/) 
figname = "xy2_"+ncase+"case"+tablecase+"_ACM2_nocloud2_"+spec

;************************************************
; read in data
;************************************************
 filenames = new((/ncase/),"string")
 do icase = 0,ncase-1
   filenames(icase) = "output/output_"+casenames(icase)+"/wrfout_d01_2013-01-"+sdays(icase)+"_12Z_"+casenames(icase)+"_"+jdayin(icase)+"_"+aodin(icase)+".nc"
 end do
 
 files     = addfiles (filenames,"r")
 ListSetType (files, "join")  
 
;--------------------------------------------------
; Convert this to values representing 
;   "hours since 2001-06-11 12:00:00"
;--------------------------------------------------   
 f1    = addfiles (filenames(0),"r")
 Times = f1[:]->Times
 printVarSummary(Times)   
 times = wrf_times_c( Times, 0 )

 ntimes = dimsizes(times)  
 printVarSummary(times)
  
 data = new((/ncase,ntimes/),float)

 if (spec .eq. "aod") then
   TAUAER2  = wrf_user_getvar(files,"TAUAER2",-1)
   dataraw  = TAUAER2(:,:,:,0,0)
   data     = dim_sum_n(dataraw,2)
   
 else if (spec .eq. "netupheatflux") then
   HFX    = wrf_user_getvar(files,"HFX",-1)
   LH     = wrf_user_getvar(files,"LH",-1)
   GRDFLX = wrf_user_getvar(files,"GRDFLX",-1)
   data   = HFX(:,:,0,0) + LH(:,:,0,0) + GRDFLX(:,:,0,0)   ; ??? + or -

 else if (spec .eq. "netSWDNB") then
   SWDNB    = wrf_user_getvar(files,"SWDNB",-1)
   SWUPB    = wrf_user_getvar(files,"SWUPB",-1)
   data     = SWDNB(:,:,0,0) - SWUPB(:,:,0,0)
         
 else if (spec .eq. "netLWDNB") then
   LWDNB    = wrf_user_getvar(files,"LWDNB",-1)
   LWUPB    = wrf_user_getvar(files,"LWUPB",-1)
   data     = LWDNB(:,:,0,0) - LWUPB(:,:,0,0)

 else if (spec .eq. "netSLWDNB") then
   SWDNB    = wrf_user_getvar(files,"SWDNB",-1)
   SWUPB    = wrf_user_getvar(files,"SWUPB",-1)
   LWDNB    = wrf_user_getvar(files,"LWDNB",-1)
   LWUPB    = wrf_user_getvar(files,"LWUPB",-1)
   data     = SWDNB(:,:,0,0) - SWUPB(:,:,0,0) + LWDNB(:,:,0,0) - LWUPB(:,:,0,0)

 else if (spec .eq. "qcloudsum") then
   QCLOUD  = wrf_user_getvar(files,"QCLOUD",-1)
   dataraw  = QCLOUD(:,:,:,0,0)
   data     = dim_sum_n(dataraw,2)
 else 
   datatmp  = wrf_user_getvar(files,spec,-1)
   nraw = dimsizes(dimsizes(datatmp))
   print(nraw)
   
   if (nraw .eq. 4)then     
     data(0:ncase-1,:) = datatmp(0:ncase-1,:,0,0)   
   else if (nraw .eq. 5)then
     data(0:ncase-1,:) = datatmp(0:ncase-1,:,ilayer,0,0)
   else
     print("nraw ="+nraw)
   end if
   end if

 end if
 end if
 end if
 end if
 end if
 end if

 printVarSummary(data)   

                   
;--------------------------------------------------
; The time_axis_label function adds additional
; resources to "res" to produce nicely-formatted 
; time labels on X axis. This function only works 
; if you have a time "units" recognized by the 
; cd_calendar function.
;--------------------------------------------------
  restick           = True
  restick@ttmFormat = "%N/%D %H"

         
;************************************************
; plotting parameters
;************************************************
 wks   = gsn_open_wks (pltType,figname)                  ; open workstation
 print(figname+"."+pltType)

 res                   = True                      ; plot mods desired

;
; Second plot, 2 curves.
;

 res@xyDashPattern = 0               ; Make curves all solid
 res@xyMarkLineMode = "MarkLines"    ; Markers *and* lines
 res@xyMarkers      = casemakers    ; different markers
 res@xyMarkerColors = casecolors    ; different colors

 res@tiMainString      = title      ; add title
  res@tiYAxisString      = spec

 time_axis_labels(times,res,restick)
   
;  res@tiMainString       = filename
  res@tiXAxisString      = "GMT"
;  res@tiMainFontHeightF  = 0.025
  res@tiYAxisFontHeightF = 0.02
  
; add a legend
 res@pmLegendDisplayMode    = "Always"              ; turn on legend
 
 res@pmLegendSide           = "Top"                 ; Change location of 
 res@pmLegendParallelPosF   = .80                   ; move units right
 res@pmLegendOrthogonalPosF = -0.5                  ; more neg = down
 
 res@pmLegendWidthF         = 0.12                  ; Change width and
 res@pmLegendHeightF        = 0.25                  ; height of legend.
 res@lgLabelFontHeightF     = .02                   ; change font height
 res@lgPerimOn              = False                 ; no box around
; labels for the legend
 res@xyExplicitLegendLabels = labels

plot  = gsn_csm_xy (wks,times,data,res) ; create plot
;plot  = gsn_csm_xy (wks,times,data(:,1:),res) ; create plot

end
