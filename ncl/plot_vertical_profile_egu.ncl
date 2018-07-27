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

ncase      = 2
nvar       = 2
;nlayer     = 59
nlayer     = 35

;-- comparing diffrent cases
jday       = "j1"
jdayin     = (/jday,jday/)
aod        = "aod0.0"
aodin      = (/aod,aod/)
casenames  = (/"output_0110_12Z_model_ACM2_aod_layer1_8_intense","0110_12Z_model"/)
sdays      = (/"01","10"/)

;-- comparing diffrent input from the same case
;jdayin     = (/"j1","j1","j1","j1"/)
;aodin      = (/"aod0.0","aod0.0","aod0.0","aod0.0"/)
;casename   = "0101_12Z_model"
;casenames  = (/casename,casename,casename,casename/)
;sdays      = (/"01","01","01","10"/)

varnames   = (/"th","QVAPOR"/)
unit   = (/"(degree)","(kg/kg)"/)
selectedts = 0  ; for UTC19z, ts=11,35; for 12z, ts =18,42
localtime = "6Z"    ; 0 = 20Z

pltType = "png"
casecolors = (/"blue","red"/)


;************************************************
; read in data
;************************************************
 filenames = new((/ncase/),"string")
 do icase = 0,ncase-1
   filenames(icase) = "output/output_"+casenames(icase)+"/wrfout_d01_2013-01-"+sdays(icase)+"_12Z_"+casenames(icase)+"_"+jdayin(icase)+"_"+aodin(icase)+".nc"
 end do
 
 files     = addfiles (filenames,"r")
 ListSetType (files, "join")  
 
 data = new((/nvar,ncase,nlayer/),float)
 z = new((/ncase,nlayer/),float)
 do ivar = 0,nvar-1
   datatmp  = wrf_user_getvar(files,varnames(ivar),-1)
   data(ivar,0:ncase-1,0:nlayer-1) = datatmp(0:ncase-1,selectedts,0:nlayer-1,0,0)   
 end do
   
 height  = wrf_user_getvar(files,"height",-1)                 ; height(bottom_top)
 print(height)
 printVarSummary(height)
 z(0:ncase-1,0:nlayer-1) = height(0:ncase-1,selectedts,0:nlayer-1,0,0)
  
         
;************************************************
; plotting parameters
;************************************************
do ivar = 0,nvar-1 
 pltname = "vertical_"+varnames(ivar)+"_initial_egu"
 wks   = gsn_open_wks (pltType,pltname)                  ; open workstation
 print(pltname)

 res                   = True                      ; plot mods desired

 res@xyDashPattern = 0               ; Make curves all solid
 res@xyMarkLineMode = "Lines"    ; Markers *and* lines
 res@xyLineColors = casecolors  ; different colors
 
 
 res@tiMainString      = ""      ; add title
;  res@lbLabelAutoStride     = True            ; let NCL determine label spacing

   
;  res@tiMainString       = filename
  res@tiXAxisString      = varnames(ivar)+unit(ivar)
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
 res@xyExplicitLegendLabels = (/"0101","0110"/)

 plot  = gsn_csm_xy (wks,data(ivar,0:ncase-1,0:nlayer-1),z,res) ; create plot

end do
end
