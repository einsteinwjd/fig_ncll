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

ncase      = 10
nvar       = 3
;nlayer     = 59
nlayer     = 35

;-- comparing diffrent cases
jday       = "j1"
jdayin     = (/jday,jday,jday,jday,jday,jday,jday,jday,jday,jday/)
aod        = "aod0.0"
aodin      = (/aod,aod,aod,aod,aod,aod,aod,aod,aod,aod/)
casenames  = (/"0101_12Z_model_ACM2","0101_12Z_q0110_ACM2","0101_12Z_t0110_ACM2","0110_12Z_q0101_ACM2","0110_12Z_model_ACM2","0110_12Z_th0101_ACM2","0109_12Z_model_ACM2","0109_12Z_q0101_ACM2","0109_12Z_q0110_ACM2","0108_12Z_model_ACM2"/)
sdays      = (/"01","01","01","10","10","10","09","09","09","08"/)

;-- comparing diffrent input from the same case
;jdayin     = (/"j1","j1","j1","j1","j1"/)
;aodin      = (/"aod0.0","aod0.0","aod0.0","aod0.0","aod0.0"/)
;casename   = "0101_12Z_model"
;casenames  = (/casename,casename,casename,casename/)
;sdays      = (/"01","01","01","10"/)

varnames   = "th"
nts        = 9
selectedts = (/0, 10, 12, 14, 16, 18, 20, 22, 23/)  ; for UTC19z, ts=11,35; for 12z, ts =18,42
localtime = (/"20Z","6Z","8Z","10Z","12Z","14Z","16Z","18Z","19Z"/)    ; 0 = 20Z

pltType = "png"
casecolors = (/"purple","green","yellow","red","black","blue","orange","darkgreen","deepskyblue","deeppink"/)


;************************************************
; read in data
;************************************************
 filenames = new((/ncase/),"string")
 do icase = 0,ncase-1
   filenames(icase) = "output/output_"+casenames(icase)+"/wrfout_d01_2013-01-"+sdays(icase)+"_12Z_"+casenames(icase)+"_"+jdayin(icase)+"_"+aodin(icase)+".nc"
 end do
 
 files     = addfiles (filenames,"r")
 ListSetType (files, "join")  
 
 data = new((/ncase,nlayer,nts/),float)
 z = new((/ncase,nlayer,nts/),float)
 do its = 0,nts-1
   datatmp  = wrf_user_getvar(files,varnames,-1)
   data(0:ncase-1,0:nlayer-1,its) = datatmp(0:ncase-1,selectedts(its),0:nlayer-1,0,0)   
   
 height  = wrf_user_getvar(files,"height",-1)                 ; height(bottom_top)
 printVarSummary(height)
 z(0:ncase-1,0:nlayer-1,its) = height(0:ncase-1,selectedts(its),0:nlayer-1,0,0)
 end do  
         
;************************************************
; plotting parameters
;************************************************

 pltname = "vertical_"+varnames+"_"+jdayin(0)+"_"+aodin(0)+"_"+ncase+"cases"
 plot = new ( nts, "graphic" )
 wks   = gsn_open_wks (pltType,pltname)                  ; open workstation
 print(pltname+"."+pltType)

 do its = 0,nts-1
  res                   = True                      ; plot mods desired
  res@gsnDraw               = False 
  res@gsnFrame              = False 

 res@xyDashPattern = 0               ; Make curves all solid
 res@xyMarkLineMode = "Lines"    ; Markers *and* lines
 res@xyLineColors = casecolors  ; different colors
 
 
 res@tiMainString      = varnames+" in "+aodin(0)+", "+jdayin(0)+" case @local "+localtime(its)      ; add title
;  res@lbLabelAutoStride     = True            ; let NCL determine label spacing

   
;  res@tiMainString       = filename
  res@tiXAxisString      = varnames
;  res@tiMainFontHeightF  = 0.025
  res@tiYAxisFontHeightF = 0.02
  
; add a legend
 res@pmLegendDisplayMode    = "Always"              ; turn on legend
 
 res@pmLegendSide           = "Top"                 ; Change location of 
 res@pmLegendParallelPosF   = .90                   ; move units right
 res@pmLegendOrthogonalPosF = -0.5                  ; more neg = down
 
 res@pmLegendWidthF         = 0.12                  ; Change width and
 res@pmLegendHeightF        = 0.25                  ; height of legend.
 res@lgLabelFontHeightF     = .02                   ; change font height
 res@lgPerimOn              = False                 ; no box around
; labels for the legend
 res@xyExplicitLegendLabels = casenames

 plot(its)  = gsn_csm_xy (wks,data(0:ncase-1,0:nlayer-1,its),z(0:ncase-1,0:nlayer-1,its),res) ; create plot
 
end do  ; its

  resP                      = True
  resP@gsnMaximize          = True            ; maximize size
  resP@gsnPanelBottom       = 0.05            ; extra space at botton for res@tiXAxisString  
  resP@txString             = "WRF-SCM: " 
  gsn_panel(wks,plot,(/3,3/),resP)
  


end
