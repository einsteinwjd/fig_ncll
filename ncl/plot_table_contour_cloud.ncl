load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin
  
  case    = "0110_12Z_model_ACM2_high_cloud"
  dirin   = "./"
  fin     = "table"+case+".nc"

  pltType = "png"
  pltName = "WRF_SCM_table_contour"+case
  print(pltName)

  nqc_in    = 9
  njday   = 7
  nvar    = 12
  
;********************************************************
; open file 
;********************************************************

  f       = addfile (dirin + fin, "r")
  
  varname = (/"PBLH2pmd1", "PBLH2pmd2", "T22pmd1", "T22pmd2", "Q22pmd1", "Q22pmd2", "SWDNB2pmd1", "SWDNB2pmd2", "RH22pmd1", "RH22pmd2","dZs2pmd1","dZs2pmd2"/)
  table = new((/nqc_in, njday, nvar/),"float")
  table!0 = "qc_in"          ; dimension name
  table!1 = "jdayin"
  table!2 = "varin"
  
  
;  do ivar = 0, nvar-1
    
;    table(:,:,ivar)  = f->$varname(ivar)$ 
;  end do

  plot = new ( nvar, "graphic" )
  wks = gsn_open_wks(pltType ,pltName)        ; ps,pdf,x11,ncgm,eps,png
  

  res                       = True            ; plot mods desired
  res@gsnDraw               = False 
  res@gsnFrame              = False 
 ;res@gsnMaximize           = True            ; uncomment to maximize size
 
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
    data = f->$varname(ivar)$
    plot(ivar)  = gsn_csm_contour(wks, data, res)

    note1 = "Min:"+min(data)+",Max:"+max(data)
    txid1 = gsn_create_text(wks, note1, txres)
    annoid1 = gsn_add_annotation(plot(ivar), txid1, amres)
 
  end do
  printVarSummary(data)

  resP                      = True
  resP@gsnMaximize          = True            ; maximize size
  resP@gsnPanelBottom       = 0.05            ; extra space at botton for res@tiXAxisString  
  resP@txString             = "WRF-SCM: " + case
  gsn_panel(wks,plot,(/3,4/),resP)

end
