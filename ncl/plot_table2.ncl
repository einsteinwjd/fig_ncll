load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin
  
  case    = "0101_12Z_model_ACM2"
  dirin   = "./"
  fin     = "table"+case+".nc"

  pltType = "png"
  pltName = "WRF_SCM_table2_"+case
  print(pltName)

  naod    = 10
  njday   = 7
  nvar    = 12
  nvarout = 2
  
;********************************************************
; open file 
;********************************************************

  f       = addfile (dirin + fin, "r")
  
  varname = (/"PBLH2pmd1", "PBLH2pmd2", "T22pmd1", "T22pmd2", "Q22pmd1", "Q22pmd2", "SWDNB2pmd1", "SWDNB2pmd2", "RH22pmd1", "RH22pmd2","dZs2pmd1","dZs2pmd2"/)
  varoutname = (/"deltaSWDNB2pmd1", "rdSWDNB2pmd1"/)
  table = new((/naod, njday, nvar/),"float")
  table!0 = "aodin"          ; dimension name
  table!1 = "jdayin"
  table!2 = "varin"
  aodin   = (/0.0, 0.2, 0.5, 0.7, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0/)
  jdayin  = (/1, 30, 60, 90, 120, 150, 180/)
  
  
  do ivar = 0, nvar-1
    
    table(:,:,ivar)  = f->$varname(ivar)$ 
  end do

  plot = new ( nvar, "graphic" )
  wks = gsn_open_wks(pltType ,pltName)        ; ps,pdf,x11,ncgm,eps,png
  gsn_merge_colormaps(wks,"amwg","BlWhRe")    ; merge color maps 
 ;gsn_draw_colormap(wks)  

  res                       = True            ; plot mods desired
  res@gsnDraw               = False 
  res@gsnFrame              = False 
 ;res@gsnMaximize           = True            ; uncomment to maximize size
  res@gsnSpreadColors       = True            ; use entire color map
  res@cnFillOn              = True            ; turn on color
  res@cnLinesOn             = False           ; turn off contour lines
  res@lbLabelAutoStride     = True            ; let NCL determine label spacing
  res@lbOrientation         = "vertical"      ; vertical label bar
  res@trYReverse            = False            ; reverse y axis

  res@gsnSpreadColorStart   = 2               ; use the "amwg" portion
  res@gsnSpreadColorEnd     = 17              ; of the merged colormap
;  res@cnSmoothingOn         = True
  res@cnFillMode              = "RasterFill"            
  
 
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

 
  do ivar = 0, nvarout-1
    data      = new((/naod, njday/),float)
    data!0 = "aodin"          ; dimension name
    data!1 = "jdayin"
    
    if (ivar.eq.0)then
      do ijday = 0, njday-1
;        data(:,ijday) = table(0, ijday, 6) - table(:, ijday, 6)
        do iaod = 0, naod-1
	  data(iaod,ijday) = table(0, ijday, 6) - table(iaod, ijday, 6)
	end do
      end do
    end if
    
    if (ivar.eq.1)then
      do ijday = 0, njday-1
;        data(:,ijday) = 1 - table(:, ijday, 6)/ table(0, ijday, 6)
        do iaod = 0, naod-1
	  data(iaod,ijday) = 1 - table(iaod, ijday, 6)/ table(0, ijday, 6)
	end do
      end do
    end if
;  printVarSummary(data) ; for debug
    
    plot(ivar)  = gsn_csm_contour(wks, data, res)
    
;    note1 = "Min:"+min(data)+",Max:"+max(data)+",Avg:"+avg(data)
    note1 = "Min:"+min(data)+",Max:"+max(data)
    txid1 = gsn_create_text(wks, note1, txres)
    annoid1 = gsn_add_annotation(plot(ivar), txid1, amres)
 
    delete(data)
  end do

  resP                      = True
  resP@gsnMaximize          = True            ; maximize size
  resP@gsnPanelBottom       = 0.05            ; extra space at botton for res@tiXAxisString  
  resP@txString             = "WRF-SCM: " + case
  gsn_panel(wks,plot,(/1,2/),resP)

end
