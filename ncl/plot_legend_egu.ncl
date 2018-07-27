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
  pltType = "png"
  pltName = "egu_legend"
  print(pltName)

  njday   = 7

  plot = new ( 1, "graphic" )
  wks = gsn_open_wks(pltType ,pltName)        ; ps,pdf,x11,ncgm,eps,png
  

;***********************************************
; legend resources
;***********************************************
 lgres                    = True
 lgres@lgMonoDashIndex    = True
 lgres@lgLineColors       = (/"purple","blue","green","black","yellow","orange","red"/)    ; colors for legend lines
 lgres@vpWidthF           = 0.05                   ; width of legend (NDC)
 lgres@vpHeightF          = 0.1                   ; height of legend (NDC)
 lgres@lgPerimOn          = False                 ; turn off perimeter
 lgres@lgTitleString      = "Jday"
; lgres@lgLineLabelStrings = (/" "," "," "," "," "," "," "/)             ; no labels in lines
; lgres@lgOrientation      = "Horizontal"

;**************************************************************
; Draw the legend, indicating the number of items, a label for each
; item, and the X, Y position of the legend in NDC coordinates.
;**************************************************************
 gsn_legend_ndc(wks,njday,(/"0","30","60","90","120","150","180"/) ,0.1,0.12,lgres)

  resP                      = True
  resP@gsnMaximize          = True            ; maximize size
  resP@gsnPanelBottom       = 0.05            ; extra space at botton for res@tiXAxisString  

;  gsn_panel(wks,plot,(/3,4/),resP)

  system("convert -trim "+pltName+"."+pltType+" "+pltName+".jpg")  ; trim the margin of a fig

end
