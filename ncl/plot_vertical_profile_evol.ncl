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
case = "01-10_12Z_0110_12Z_model"
 f      = addfile ("wrfout_d01_2013-"+case+"_j0_aod0.0"+".nc","r")
 f2     = addfile ("wrfout_d01_2013-"+case+"_j0_aod2.0"+".nc","r")
 f2     = addfile ("wrfout_d01_2013-"+case+"_j0_aod6.0"+".nc","r")
 
 spec = "rh"
 ptime  = (/0, 10, 12, 14, 16, 18, 20, 22, 24/)
 rh       = wrf_user_getvar(f,"rh",-1)             ; W(Time,bottom_top_stag)
 rhvp     = rh(11,:,0,0)                                   ; get data
 rh2       = wrf_user_getvar(f2,"rh",-1)             ; W(Time,bottom_top_stag)
 rhvp2     = rh2(11,:,0,0)                                   ; get data
; printVarSummary(pblh)   
  height  = wrf_user_getvar(f,"height",-1)                 ; height(bottom_top)
  z = height(0,:,0,0)
         
;************************************************
; to plot multiple lines, you must put them into
; a mulidimensional array
;************************************************
 data      = new((/2,59/),float)

 data(0,:) = rhvp
 data(1,:) = rhvp2
; printVarSummary(data)
;************************************************
; plotting parameters
;************************************************
 wks   = gsn_open_wks ("png","xy2")                  ; open workstation

 res                   = True                      ; plot mods desired

;
; Second plot, 2 curves.
;

 res@xyDashPattern = 0               ; Make curves all solid
 res@xyMarkLineMode = "MarkLines"    ; Markers *and* lines
 res@xyMarkers      = (/6,11/)    ; 2 different markers
 res@xyMarkerColors = (/"blue","red"/)  ; 2 different colors

 res@tiMainString      = "RH in AOD=4.0, JD=90 case"      ; add title
;  res@lbLabelAutoStride     = True            ; let NCL determine label spacing

   
;  res@tiMainString       = filename
  res@tiXAxisString      = "RH"
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
 res@xyExplicitLegendLabels = (/"wet","dry"/)

plot  = gsn_csm_xy (wks,data,z,res) ; create plot

end
