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

ncase      = 1
nvar       = 4
nlayer     = 59
;nlayer     = 35

;-- comparing diffrent cases
jday       = "j1"
;jdayin     = (/jday,jday,jday,jday/)
;aod        = "aod0.0"
;aodin      = (/aod,aod,aod,aod/)
;casenames  = (/"0101_12Z_model","0101_12Z_q0110","0101_12Z_t0110","0110_12Z_model"/)
;sdays      = (/"01","01","01","10"/)
tconc2pm       = 10

;-- comparing diffrent input from the same case
jdayin     = (/"j1","j1","j1","j1"/)
aodin      = (/"0","180","190","200","210","220","230","240","250"/)
;casename   = "0110_12Z_model_ACM2_aod_layer1_8_intense_new"
casename   = "0110_12Z_model_ACM2_chem_EXCH_uniform"
casenames  = (/casename,casename,casename,casename/)
sday       = "10"
ssavalue   = "0.85"
sdays      = (/sday,sday,sday,sday/)

 varnamess   = (/"th","rh","QVAPOR","bc_a02"/)
Xmins      = (/262,40,0.0012,0/)
Xmaxs      = (/276,100,0.0024,300/)

; varnames  = "th"
nts        = 9
selectedts = (/0, 10, 12, 14, 16, 18, 20, 22, 23/)  ; for UTC19z, ts=11,35; for 12z, ts =18,42
localtime = (/"20Z","6Z","8Z","10Z","12Z","14Z","16Z","18Z","19Z"/)    ; 0 = 20Z

pltType = "png"
casecolors = (/"purple","green","yellow","red"/)


;************************************************
; read in data
;************************************************
 filenames = new((/ncase/),"string")
 pltname   = new((/ncase/),"string")
 do ivar  = 0,nvar - 1
 varnames = varnamess(ivar)
 do iaod  = 0,3
 do icase = 0,ncase - 1
   filenames(icase) = "output/output_"+casenames(icase)+"/wrfout_d01_2013-01-"+sday+"_12Z_"+casename+"_"+jday+"_bctconc"+aodin(iaod)+"_qc0.0_ssa"+ssavalue
;   pltname(icase)  = "vertical_"+varnames+"_"+jdayin(0)+"_"+casename+"_aod_"+aodin(icase)
   
 end do
 
 files     = addfiles (filenames+".nc","r")
; ListSetType (files, "join")  
 printVarSummary(files)
 
 data = new((/nlayer,nts/),float)
 z = new((/nlayer,nts/),float)
 do its = 0,nts-1
   if(ivar.eq.3) then
;   print(ivar)
;   datatmp  = files->th
   datatmp  = wrf_user_getvar(files,varnames,-1)*tconc2pm

   else
   datatmp  = wrf_user_getvar(files,varnames,-1)
   end if
;   printVarSummary(datatmp(selectedts(its),0:nlayer-1,0,0));
;   printVarSummary(data(0:nlayer-1,its));
   data(0:nlayer-1,its) = datatmp(selectedts(its),0:nlayer-1,0,0)   
   
 height  = wrf_user_getvar(files,"height",-1)                 ; height(bottom_top)
 printVarSummary(height)
 z(0:nlayer-1,its) = height(selectedts(its),0:nlayer-1,0,0)
 end do  
         
;************************************************
; plotting parameters
;************************************************
; do icase = 1,ncase - 1
; print(aodin(icase))
 pltname = "./vertical_plot/"+casename+"/vertical_"+varnames+"_"+jdayin(0)+"_"+casename+"_bctconc"+aodin(iaod)+"_ssa_"+ssavalue
;  end do
 plot = new ( nts, "graphic" )
 wks   = gsn_open_wks (pltType,pltname)                  ; open workstation
 print(pltname)

 do its = 0,nts-1
  res                   = True                      ; plot mods desired
  res@gsnDraw               = False 
  res@gsnFrame              = False 

 res@xyDashPattern = 0               ; Make curves all solid
 res@xyMarkLineMode = "Lines"    ; Markers *and* lines
 res@xyLineColors = casecolors  ; different colors
 
 
 res@tiMainString      = varnames+" in "+jdayin(0)+" case @local "+localtime(its)      ; add title
;  res@lbLabelAutoStride     = True            ; let NCL determine label spacing

   
;  res@tiMainString       = filename
  res@tiXAxisString      = varnames
;  res@tiMainFontHeightF  = 0.025
  res@tiYAxisFontHeightF = 0.02

;  res@tmYLMode   = "Explicit"			; explicitly set the Y-axis labels
;  res@tmYLValues = (/0,50,100,200,500,1000,1500,2000,2500,3000/)
;  res@tmYLLabels = "" + res@tmYLValues
;  res@trYLog     = True		; use a logarithmic coordinate system for the Y-axis
  
; add a legend
 res@pmLegendDisplayMode    = "Always"              ; turn on legend
 
 res@pmLegendSide           = "Top"                 ; Change location of 
 res@pmLegendParallelPosF   = .90                   ; move units right
 res@pmLegendOrthogonalPosF = -0.5                  ; more neg = down
 
 res@pmLegendWidthF         = 0.12                  ; Change width and
 res@pmLegendHeightF        = 0.25                  ; height of legend.
 res@lgLabelFontHeightF     = .02                   ; change font height
 res@lgPerimOn              = False                 ; no box around
 res@trXMinF                = Xmins(ivar)
 res@trXMaxF                = Xmaxs(ivar)
; labels for the legend
 res@xyExplicitLegendLabels = aodin

 plot(its)  = gsn_csm_xy (wks,data(0:15,its),z(0:15,its),res) ; create plot
; end do
end do  ; its

  resP                      = True
  resP@gsnMaximize          = True            ; maximize size
  resP@gsnPanelBottom       = 0.05            ; extra space at botton for res@tiXAxisString  
  resP@txString             = "WRF-SCM: " +casename
  gsn_panel(wks,plot,(/3,3/),resP)
  end do 
  end do

end
