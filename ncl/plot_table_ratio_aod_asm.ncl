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
  case    = "0110_12Z_model_ACM2_aod_asm"
  dirin   = "./"
  fin     = "table"+case+".nc"

  pltType = "png"
  dirout  = "./plot/"+case+"/"
  plt = "egu_table_ratio_"+case
  pltName = dirout+plt
  print(pltName)

  naod    = 7
  njday   = 1
  nvar    = 2
  nasm    = 7
  aod     = (/0.0, 0.2, 0.5, 0.7, 1.0, 2.0, 3.0/)
;  asm     = (/0.85, 0.86, 0.87, 0.88, 0.89, 0.90, 0.91, 0.92, 0.93, 0.94, 0.95, 0.96, 0.97, 0.98, 0.99, 1.0/) 
;  asminn   = (/"0.85", "0.86", "0.87", "0.88", "0.89", "0.90", "0.91", "0.92", "0.93", "0.94", "0.95", "0.96", "0.97", "0.98", "0.99", "1.0"/)

   asm    = (/0.0, 0.5, 0.6, 0.65, 0.7, 0.75, 0.8/)
   asminn    = (/"0.0", "0.5", "0.6", "0.65", "0.7", "0.75", "0.8"/)



;********************************************************
; open file 
;********************************************************

  f       = addfile (dirin + fin, "r")
  
  varname = (/"SWDNB2pmd1", "PBLH2pmd1"/)
  table = new((/naod, nasm, nvar/),"float")
  table!0 = "aodin"          ; dimension name
  table!1 = "asmin"
  table!2 = "varin"

         
;************************************************
; to plot multiple lines, you must put them into
; a mulidimensional array
;************************************************
 data      = new((/nasm,naod/),float)

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
; res@xyLineColors = "MPL_Greys" ; different colors


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
    table(:,:,ivar) = f->$varname(ivar)$(0:6,:)
    do iasm = 0, nasm-1
;      data(iasm,:) = table(asmin | iasm, aodin | :, varin | ivar)/ table(asmin | iasm, aodin | 0, varin | ivar)
     data(iasm,:) = table(asmin | iasm, aodin | :, varin | ivar)/ table(asmin | iasm, aodin | 0, varin | ivar)

    end do
    
    res@tiXAxisString      = "AOD"
    res@tiYAxisString      = varname(ivar)
    
    if(max(data).lt.0.01)then
      res@tmYLFormat = "0*+^e"	; use "e" symbol, don't force 0's (see documentation)
    else
      res@tmYLFormat = "0@*+^sg"
    end if

    plot(ivar)  = gsn_csm_xy (wks,aod,data,res) ; create plot
;...........................................changed by lisa, 2017/06/21
    output_file_obs            =pltName+varname(ivar)+".txt"
    system("if [ -f "+output_file_obs+" ]; then rm "+output_file_obs+"; fi")
    write_table(output_file_obs, "w", [/"aod       ",            varname(ivar)+"_day_0",varname(ivar)+"_day_1", varname(ivar)+"_day_2", varname(ivar)+"_day_3",\
                                         varname(ivar)+"_day_4", varname(ivar)+"_day_5",varname(ivar)+"_day_6"\
                                          /], "%s %s %s %s %s %s %s %s")
    write_table(output_file_obs, "a", [/aod,                     data(0,:),             data(1,:),              data(2,:),              data(3,:),\
                                        data(4,:),               data(5,:),             data(6,:)\
                                        /],  "%15.7f %15.7f %15.7f %15.7f %15.7f %15.7f %15.7f %15.7f")
    delete(output_file_obs)

;...........................................changed by lisa, 2017/06/21
;    note1 = "Min:"+min(data)+",Max:"+max(data)
;    txid1 = gsn_create_text(wks, note1, txres)
;    annoid1 = gsn_add_annotation(plot(ivar), txid1, amres)
 
  end do

; printVarSummary(data)


;  resP                      = True
  resP			    = False
  resP@gsnMaximize          = True            ; maximize size
  resP@gsnPanelBottom       = 0.05            ; extra space at botton for res@tiXAxisString  
  resP@txString             = "WRF-SCM: " + case

;***********************************************
; legend resources
;***********************************************
 lgres                    = True
 lgres@lgMonoDashIndex    = True
 lgres@lgLineColors       = res@xyLineColors    ; colors for legend lines
 lgres@vpWidthF           = 0.05                   ; width of legend (NDC)
 lgres@vpHeightF          = 0.1                   ; height of legend (NDC)
 lgres@lgPerimOn          = False                 ; turn off perimeter
 lgres@lgTitleString      = "SSA"
; lgres@lgLineLabelStrings = (/" "," "," "," "," "," "," "/)             ; no labels in lines
; lgres@lgOrientation      = "Horizontal"

;**************************************************************
; Draw the legend, indicating the number of items, a label for each
; item, and the X, Y position of the legend in NDC coordinates.
;**************************************************************
; gsn_legend_ndc(wks,naod,asminn ,0.1,0.12,lgres)


  gsn_panel(wks,plot,(/3,4/),resP)

  system("convert -trim "+pltName+"."+pltType+" "+pltName+".jpg")  ; trim the margin of a fig

end
