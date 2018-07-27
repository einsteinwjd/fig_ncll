load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func.ncl"
begin
;======================================================================
;define the resource for plot
;======================================================================
;......................................................................
;panel resource
;......................................................................
  pnres                            = True
  pnres@gsnPanelYWhiteSpacePercent = 3
  pnres@gsnPanelXWhiteSpacePercent = 3
;......................................................................
;common propertities for xy plot
;......................................................................
  res                              = True
  res@gsnDraw                      = False
  res@gsnFrame                     = False
  res@xyMarkLineMode               = "Lines"
  res@xyDashPattern                = 0
  res@xyLineThicknesse             = 1.5
;......................................................................
; resources for "left" variable
;......................................................................
  resL                             = res
  resL@xyLineColor                 = "ForestGreen"
  resL@xyLineThicknessF            = 1.5
  resL@tiXAxisFontColor            = resL@xyLineColor
  resL@tiYAxisSide                 = "Left"
  resL@tiXAxisSide                 = "Bottom"
  resL@tiXAxisString               = "Heating rate (K/s)"
  resL@trXMinF                     = -0.001
  resL@trXMaxF                     = 0.001
;......................................................................
; resources for "right" variable
;......................................................................
  resR                             = res                      
  resR@tiYAxisSide                 = "Right"
  resR@tiXAxisSide                 = "Top"
  resR@tiXAxisString               = "Temperature (C)"
  resR@xyLineColor                 = "NavyBlue"
  resR@xyDashPattern               = 2              ; Dashed line for 2nd curve
  resR@xyLineThicknessF            = 2.0
  resR@tiXAxisFontColor            = resR@xyLineColor
  resR@tmYRFormat                  = "f"            ; Remove trailing zeros from labels


;======================================================================
  ncase      =  8 
  casenames  = (/"0101_12Z_ACM2_aod","0110_12Z_model_ACM2_aod", "0101_12Z_ACM2_aod",       "0101_12Z_ACM2_aod",\
                 "0101_12Z_ACM2_aod","0101_12Z_ACM2_high_cloud","0101_12Z_ACM2_high_cloud","0101_12Z_ACM2_high_cloud"/)
  aod        = "aod0.0"
  aodin      = (/ aod,    aod,   "aod1.0",      "aod2.0",      "aod3.0",      "qc1E-4",      "qc2E-4",       "qc5E-4"/)
  sdays      = (/"01",   "10",   "01",          "01",          "01",          "01",          "01",           "01"/)
  labels     = (/"0101", "0110", "0101_aod1.0", "0101_aod2.0", "0101_aod3.0", "0101_cod6.7", "0101_cod13.3", "0101_cod33"/)
  jday       = "j1"
  jdayin     = (/ jday,   jday,   jday,          jday,          jday,          jday,          jday,          jday,         jday/)
  filenames  = new((/ncase/),"string")

  varsL      = (/"RTHRATSW", "RTHRATLW"/)          
  nvarsL     = 2
  unitsL     = (/"K s-1",    "K s-1"/)
  titlesL    = (/"avg",      "avg"/)
  stridesL   = (/1e-6,        1e-6/)
  varsR      = (/"tc"/)      
  nvarsR     = 1
  unitsR     = (/"C"/)
  titlesR    = (/"avg"/)
  stridesR   = (/1e-6/)
;======================================================================
  case_base          = "/home/wjd/WRF_scm/data/WRF-SCM/output_0101_12Z_ACM2_aod/wrfout_d01_2013-01-01_12Z_0101_12Z_ACM2_aod_j1_aod0.0_qc0.0"  ;!changed by Lisa, 2017/06/20
  fdata_base         = addfile(case_base+".nc","r") ;!changed by Lisa, 2017/06/20
  times              = wrf_user_getvar(fdata_base,"Times",-1)
  dims1              = dimsizes(times)
  nt                 = dims1(0)
  ch_x              = charactertostring(times(:,8:9)) ;+"~C~"+charactertostring(times(:,11:12))
;-------------------------------------------------------------------------------------------------- 
  figname            = "./graph_cross/SSA0.85/profile"
  wks                = gsn_open_wks ("pdf", figname)  ; send graphics to PNG file
  do it = 0,nt-1
     plotL1          = new(ncase,graphic)
     plotL2          = new(ncase,graphic)
     plotR           = new(ncase,graphic)
     do icase = 0,ncase-1
        if (casenames(icase) .ne. "0101_12Z_ACM2_high_cloud") then
            filenames(icase) = "output/output_"+casenames(icase)+"/wrfout_d01_2013-01-"+\
                                sdays(icase)+"_12Z_"+casenames(icase)+"_"+jdayin(icase)+"_"+aodin(icase)+"_qc0.0_ssa0.85"
        else
            filenames(icase) = "output/output_"+casenames(icase)+"/wrfout_d01_2013-01-"+\
                                sdays(icase)+"_12Z_"+casenames(icase)+"_"+jdayin(icase)+"_"+aodin(icase)
        end if
        fname0               = filenames(icase)
        fdata0               = addfile(fname0+".nc","r")

        hgt                  = wrf_user_getvar(fdata0,"z",0)
        dims3                = dimsizes(hgt)
        nz                   = dims3(0)
        ny                   = dims3(1)
        nx                   = dims3(2)
;print(hgt(:,0,0))
        varpL                = new((/nvarsL,2,nz/),float)
        varpR                = new((/nvarsR,nz/),float)
        do ivar = 0,nvarsR-1
           v0  := wrf_user_getvar(fdata0,varsR(ivar),-1)
printVarSummary(v0)
           varpR(ivar,:)     = v0(it,:,0,0)
        end do
        do ivar = 0,nvarsL-1
           v0  := fdata0->$varsL(ivar)$
printVarSummary(v0)
           varpL(ivar,0,:)     = v0(it,:,0,0)
           varpL(ivar,1,:)     = varpR(0,:)
        end do

        resL@xyDashPattern               = 2
       
        plotL1(icase)        = gsn_csm_x2y(wks,varpL(0,0,:),varpL(0,1,:),hgt(:,0,0),resL,resR)
        lnres                   = True
        lnres@gsLineColor       = resL@xyLineColor
        lnres@gsLineThicknessF  = resL@xyLineThicknessF
        lnres@gsLineDashPattern               = 6
        dum0                 = gsn_add_polyline(wks,plotL1(icase),varpL(1,0,:),hgt(:,0,0),lnres)
     end do
     gsn_panel(wks,(/plotL1/),(/2,4/),True)
  end do
 end

