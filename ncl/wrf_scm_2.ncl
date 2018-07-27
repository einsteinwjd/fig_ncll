;********************************************************
; SCM: Single Column Model
; WRF SCM: time-eta cross section.
;********************************************************
; %> ncl_filedump wrfout_SCM.nc | less
; netcdf wrfout_CSM {
; dimensions:
;        Time = UNLIMITED ; // (60 currently)
;        DateStrLen = 19 ;
;        west_east = 2 ;
;        south_north = 2 ;
;        bottom_top = 59 ;
;        bottom_top_stag = 60 ;
;        soil_layers_stag = 4 ;
;        west_east_stag = 3 ;
;        force_layers = 8 ;
;        south_north_stag = 3 ;
; [SNIP]
; 2x2 west-east/south_north values
; 3x3 west_east_stag/south_north_stag values
; 60 time steps
; 59 or 60 vertical levels
;********************************************************
; Variables are on different spatial grids. 
;
; User *must* look!
;
; float U(Time, bottom_top, south_north, west_east_stag)
; float V(Time, bottom_top, south_north_stag, west_east)
; float W(Time, bottom_top_stag, south_north, west_east)
; float PH(Time, bottom_top_stag, south_north, west_east )
;********************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin
  nl  = 1      ; arbitrary grid point index values
  ml  = 1

  nls = 1
  mls = 1
  
  pltType = "png"
  pltName = "WRF_SCM_2"
  
;********************************************************
; open file 
;********************************************************
  diri    = "./"
  fili    = "wrfout_d01_2013-01-01_19Z.winter"
;  fili    = "wrfout_d01_2013-01-01_19Z.winter_aod0"
  f       = addfile (diri+fili+".nc", "r")

;********************************************************
; Read character variable Times 
; Convert to units of "hours since" for plotting purposes
;********************************************************
  Time   = WRF_Times2Udunits_c(f->Times, 0)  ; convert to "hours since"

;********************************************************
; assign the staggard eta values as a vertical "coordinate array" for w
;********************************************************
  znw     = f->ZNW(0,:)                 ; znw(bottom_top_stag)           
  znu     = f->ZNU(0,:)                 ; znu(bottom_top)
  
  height  = wrf_user_getvar(f,"height",-1)                 ; height(bottom_top)
  printVarSummary(height)
  
;********************************************************
; Read RH(bottom_top,west_east) at nl,ml
; Read associated levels and longitudes
;********************************************************
  rhin       = wrf_user_getvar(f,"rh",-1)             ; W(Time,bottom_top_stag)
  printVarSummary(rhin)                    ; information

  rh       = rhin(:,:,nl ,mls)
  printVarSummary(rh)                    ; information
  printMinMax(rh, True)
  
  rh@units = "%"                      ; note change on units attribute

  rh&bottom_top = height(0,:,0,0)               


;********************************************************
; Read U and V and do similar things                        
;********************************************************
  qv      = f->QVAPOR(:,:,nl ,mls)           ; U(Time,bottom_top)
  tcin    = wrf_user_getvar(f,"rh",-1)           ; V(Time,bottom_top)
  tc      = tcin(:,:,nl ,mls)

  qv&bottom_top = height(0,:,0,0)                    ; associate vertical coords
  tc&bottom_top = height(0,:,0,0)
  tc@units = "C"                      ; note change on units attribute
  tc@description = "Temp"                      ; note change on units attribute

  printVarSummary(qv)                    ; info
  printMinMax(qv, True)
  printVarSummary(tc)
  printMinMax(tc, True)

;********************************************************
; Read  few perturbation variables and do similar things                        
;********************************************************
  ph      = f->PH(:,:,nl,ml)            ; PH(Time,bottom_top_stag)
  t       = f->T(:,:,nl,ml )            ; T(Time,bottom_top)

  ph&bottom_top_stag = znw              ; associate vertical coords
  t&bottom_top       = znu

  printVarSummary(ph)                    ; info
  printMinMax(ph, True)
  printVarSummary(t)
  printMinMax(t, True)

;********************************************************
; Get non-convective, convective; Calculate total precipitation
;********************************************************

  precip_exp = wrf_user_getvar(f,"RAINNC",-1)
  precip_con = wrf_user_getvar(f,"RAINC", -1)
  precip_tot = precip_exp + precip_con
  copy_VarMeta(precip_exp, precip_tot)
  precip_tot@description = "Total Precipitation"

  printVarSummary(precip_tot)
  printMinMax(precip_tot, True)

  delete(precip_exp)      ; no longer needed
  delete(precip_con)

;********************************************************
; For plot label purposes only, read the specific lat/lon point
;********************************************************
  lat       = f->XLAT(0,nl,ml)
  lon       = f->XLONG(0,nl,ml)
;********************************************************
; create plots  
; (1) A "BlWhRe" is often selected when plus/minus are of interest
; (2) The "symMinMaxPlt" procedure, located in contributed.ncl,
;     determines contour limits that are symmetric.
; (3) Use the "sprintf" function to format the title
; (4) Because the rightmost dimension will become the "x" axis
;     use NCL's "dimension reordering" to reshape
;********************************************************
  plot = new ( 5, "graphic" )
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

  plot(0)                   = gsn_csm_contour(wks, qv(bottom_top|:,Time|:),res)
  plot(1)                   = gsn_csm_contour(wks, tc(bottom_top|:,Time|:),res)
  res@trYReverse            = True            ; reverse y axis
  plot(2)                   = gsn_csm_contour(wks, t(bottom_top|:,Time|:),res)
  plot(3)                   = gsn_csm_contour(wks,ph(bottom_top_stag|:,Time|:),res)

  res@trYReverse            = False            ; reverse y axis
  res@gsnSpreadColorStart   = 18              ; user the "BlWhRe" colormap
  res@gsnSpreadColorEnd     = -1              ; for "w" ... easier for up/down
  res@tiXAxisString         = Time@units      ; label bottom axis with units attribute
  symMinMaxPlt(rh, 14, False, res)             ; contributed.ncl
  plot(4)                   = gsn_csm_contour(wks,rh(bottom_top|:,Time|:),res)

  resP                      = True
  resP@gsnMaximize          = True            ; maximize size
  resP@gsnPanelBottom       = 0.05            ; extra space at botton for res@tiXAxisString  
  resP@txString             = "WRF-SCM: "     \
                            + sprintf("%4.2f", lat)+"N  " \
                            + sprintf("%4.2f", fabs(lon))+"W" 
  gsn_panel(wks,plot,(/3,2/),resP)

;********************************************************
; Only plot precip_tot if there are values > 0.0
;********************************************************
 
  if (max(precip_tot(:,nl,ml)).gt.0.0) then
      res_prc = True
      res_prc@gsnMaximize = True
      res_prc@tiMainString= resP@txString
      plt  = gsn_csm_xy(wks, Time, precip_tot(:,nl,ml), res_prc)
  end if
end
