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
  case    = "0110_12Z_model_ACM2_high_cloud"
  dirin   = "./"
  fin     = "table_cod"+case+".nc"

  pltType = "png"
  dirout  = "./plot/"+case+"/"
  plt = "cloud_table_ratio_lw"+case
  pltName = dirout + plt
  print(pltName)

  nqc_in    = 7
  njday   = 7
  nvar    = 2
;  aod     = (/0.0, 0.2, 0.5, 0.7, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0/)
;  qc_in = (/0.0, 1.0E-5, 5.0E-5, 1.0E-4, 2.0E-4, 5.0E-4, 1.0E-3, 2.0E-3, 5.0E-3/)
  qc_in = (/0.0, 1.0E-5, 5.0E-5, 1.0E-4, 2.0E-4, 5.0E-4, 1.0E-3/)
  cod = qc_in * 500 * 1000 * 0.111
;********************************************************
; open file 
;********************************************************

  f       = addfile (dirin + fin, "r")
  
  varname = (/"LWUPB2pmd1", "LWDNB2pmd1"/)
  table = new((/nqc_in, njday, nvar/),"float")
;  table!0 = "aodin"          ; dimension name
  table!0 = "cod"
  table!1 = "jdayin"
  table!2 = "varin"

         
;************************************************
; to plot multiple lines, you must put them into
; a mulidimensional array
;************************************************
 data      = new((/njday,nqc_in/),float)

  plot = new ( nvar, "graphic" )
  wks = gsn_open_wks(pltType ,pltName)        ; ps,pdf,x11,ncgm,eps,png
  

  res                       = True            ; plot mods desired
  res@gsnDraw               = False 
  res@gsnFrame              = False 
 ;res@gsnMaximize           = True            ; uncomment to maximize size
 
 res@xyDashPattern = 0               ; Make curves all solid
 res@xyMarkLineMode = "Lines"    ; Markers *and* lines
; res@xyMarkers      = (/6,11/)    ; 2 different markers
 res@xyLineColors = (/"purple","blue","green","black","yellow","orange","red"/)  ; different colors

; res@tiMainString      = "WRF-SCM: " + case      ; add title
   
  res@tiYAxisFontHeightF = 0.02
  
; add a legend
 res@pmLegendDisplayMode    = "NoCreate"              ; turn on legend
 
  txres                       = True
  txres@txPerimOn             = True
  txres@txFontHeightF         = 0.02

  txres@txBackgroundFillColor = "LightSkyBlue"
;  txres@txFont                = "helvetica-bold"
  txres@txFont                = "helvetica"

  amres = True
;  amres@amParallelPosF   = 0.5    ; This is the right edge of the plot.
;  amres@amOrthogonalPosF = 0.5    ; This is the bottom edge of the plot.
  amres@amParallelPosF   = 0.5    ; This is the right edge of the plot.
  amres@amOrthogonalPosF = 0.7    ; This is the bottom edge of the plot.

  amres@amJust           = "BottomRight"

 
  do ivar = 0, nvar-1
    table(:,:,ivar) = f->$varname(ivar)$
    do ijday = 0, njday-1
      data(ijday,:) = table(jdayin | ijday,cod | :, varin | ivar)/ table(jdayin | ijday, cod | 0, varin | ivar)
    end do
    
    
    res@tiXAxisString      = "COD"
    res@tiYAxisString      = varname(ivar)
    
    if(max(data).lt.0.01)then
      res@tmYLFormat = "0*+^e"	; use "e" symbol, don't force 0's (see documentation)
    else
      res@tmYLFormat = "0@*+^sg"
    end if

    plot(ivar)  = gsn_csm_xy (wks,cod,data,res) ; create plot

;    note1 = "Min:"+min(data)+",Max:"+max(data)
;    txid1 = gsn_create_text(wks, note1, txres)
;    annoid1 = gsn_add_annotation(plot(ivar), txid1, amres)
 
  end do

; printVarSummary(data)


  resP                      = True
  resP@gsnMaximize          = True            ; maximize size
  resP@gsnPanelBottom       = 0.05            ; extra space at botton for res@tiXAxisString  
;  resP@txString             = "WRF-SCM: " + case

;***********************************************
; legend resources
;***********************************************
 lgres                    = True
 lgres@lgMonoDashIndex    = True
 lgres@lgLineColors       = res@xyLineColors    ; colors for legend lines
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
; gsn_legend_ndc(wks,njday,(/"0","30","60","90","120","150","180"/) ,0.1,0.12,lgres)


  gsn_panel(wks,plot,(/3,4/),resP)

  system("convert -trim "+pltName+"."+pltType+" "+pltName+".jpg")  ; trim the margin of a fig

end
