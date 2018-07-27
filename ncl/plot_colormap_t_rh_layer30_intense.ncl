load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func.ncl"
begin
  pnres=True
  pnres@gsnPanelYWhiteSpacePercent = 3
  pnres@gsnPanelXWhiteSpacePercent = 3

;-------------------------
;scenario value

ssavalues = (/"ssa0.85", "ssa0.90", "ssa0.95"/)
;ssavalue = "ssa0.90"
casename   = "0101_12Z_ACM2_aod_layer30_intense"
;-------------------------

  reslonc                           =True
  reslonc@gsnDraw                   = False
  reslonc@gsnFrame                  = False
  reslonc@gsnRightString            = ""
  reslonc@gsnLeftString             = ""
  reslonc@tiYAxisString             = "Altitude(km)"
;  reslonc@tiYAxisOffsetXF           = 0.01
  reslonc@cnLinesOn                 = False
  reslonc@cnFillOn                  = True               ; color plot desired
  reslonc@cnLineLabelsOn            = False              ; turn off contour lines
;   reslonc@cnFillMode              = "RasterFill"
  reslonc@cnSmoothingOn             = True
  reslonc@cnSmoothingDistanceF      = .005
  reslonc@cnFillPalette             = "NCV_blue_red"  ;WhiteYellowOrangeRed" ;"MPL_Reds"
;  reslonc@cnFillPalette             = "NCV_jet"  ;WhiteYellowOrangeRed" ;"MPL_Reds"
  reslonc@gsnSpreadColors           = True
  reslonc@gsnSpreadColorStart       = 2
  reslonc@gsnSpreadColorEnd         = 250

  reslonc@pmLabelBarHeightF         = 0.06
  reslonc@pmLabelBarWidthF          = 0.6
  reslonc@lbLabelFontHeightF        = 0.013
  reslonc@lbAutoManage              = False
  reslonc@lbLeftMarginF             = 0.2
  reslonc@lbRightMarginF            = 0.2   
  reslonc@lbTopMarginF              = 0.2  
  reslonc@lbLabelOffsetF            = 0.15
  reslonc@lbLabelStride             = 2
  reslonc@lbBoxMinorExtentF         = 0.4
  reslonc@lbTitleOn                 =  True                ; turn on title
  reslonc@lbTitleString             = "K s-1"
  reslonc@lbTitlePosition           = "Right"              ; title position
  reslonc@lbTitleFontHeightF        = .015                ; make title smaller
  reslonc@lbTitleDirection          = "Across"             ; title direction
;........................................
  res           =True
  res@gsnDraw    = False
  res@gsnFrame   = False

  res@xyMarkLineMode=  "Lines"
  res@xyDashPattern =   0
  res@xyLineColor   =  "green"
  res@xyLineThicknesse=1.5

;-------------------------------------------------------------------------------------------------
  casenames  = (/"0101_12Z_ACM2_aod_layer1_115","0110_12Z_model_ACM2_aod_layer1_15","0101_12Z_ACM2_aod_layer1_115","0101_12Z_ACM2_aod_layer1_115","0101_12Z_ACM2_aod_layer1_115","0101_12Z_ACM2_high_cloud","0101_12Z_ACM2_high_cloud","0101_12Z_ACM2_high_cloud"/)
  aod        = "aod0.0"
  aodin_tmp  = fspan(0.0,3.0,31)
  aodin      = sprintf("%3.1f",aodin_tmp)
  ncase      = dimsizes(aodin)
  
  filenames = new((/ncase/),"string")
 
  vars              = (/"T","RH"/)          
  nvars             = 2
  units             = (/"C",  "%"/)
  titles            = (/"avg",    "avg"/)
  strides           = (/0.1,     1/)
  sdays      = (/"01","10","01","01","01","01","01","01"/)
  sday       = "01"
  labels     = (/"0101", "0110", "0101_aod1.0", "0101_aod2.0", "0101_aod3.0", "0101_cod6.6", "0101_cod13.3","0101_cod33"/)
  jdays      = (/"j1", "j30", "j60"/)
;  jday       = "j1"
;  jdayin     = (/jday,jday,jday,jday,jday,jday,jday,jday,jday/)


;  case_aod          = "cloud1.0"  ;!!!!!!
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0110_12Z_model_ACM2_high_cloud/wrfout_d01_2013-01-10_12Z_0110_12Z_model_ACM2_high_cloud_j1_cloud1E-4"
;  case_aod          = "aod0.0"  ;!!!!!!
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0101_12Z_model_ACM2_aod/wrfout_d01_2013-01-01_12Z_0101_12Z_model_ACM2_aod_j1_"+case_aod+"_qc0.0"
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0101_12Z_ACM2_aod/wrfout_d01_2013-01-01_12Z_0101_12Z_ACM2_aod_j1_"+case_aod+"_qc0.0"
  case_base          = "/home/wjd/WRF_scm/data/WRF-SCM/output_0101_12Z_ACM2_aod/wrfout_d01_2013-01-01_12Z_0101_12Z_ACM2_aod_j1_aod0.0_qc0.0"  ;!changed by Lisa, 2017/06/20
  fdata_base         = addfile(case_base+".nc","r") ;!changed by Lisa, 2017/06/20 
  do ijday = 0,0
  jday = jdays(ijday)
  do issa  = 0,2
  do icase = 0,ncase-1
     ssavalue = ssavalues(issa)
;  case_aod          = "cloud1.0"  ;!!!!!!
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0110_12Z_model_ACM2_high_cloud/wrfout_d01_2013-01-10_12Z_0110_12Z_model_ACM2_high_cloud_j1_cloud1E-4"
;  case_aod          = "aod1.0"  ;!!!!!!
;   if (casenames(icase) .ne. "0101_12Z_ACM2_high_cloud") then
   filenames(icase) = "output/output_"+casename+"/wrfout_d01_2013-01-"+sday+"_12Z_"+casename+"_"+jday+"_aod"+aodin(icase)+"_qc0.0_"+ssavalue
;   else
;   filenames(icase) = "output/output_"+casenames(icase)+"/wrfout_d01_2013-01-"+sdays(icase)+"_12Z_"+casenames(icase)+"_"+jdayin(icase)+"_"+aodin(icase)
;   end if
  fname0            = filenames(icase)
  if (isfilepresent(fname0))
  fdata0            = addfile(fname0+".nc","r")
  figname = "./graph_cross/"+casename+"/T_RH_difference_"+sday+"_12Z_"+casename+"_"+jday+"_"+aodin(icase)+"_"+ssavalue


  fdata0            = addfile(fname0+".nc","r")

  hgt               = wrf_user_getvar(fdata0,"z",0)
  dims3             = dimsizes(hgt)
  nz                = dims3(0)
  ny                = dims3(1)
  nx                = dims3(2)
print(hgt(:,0,0))
  times             = wrf_user_getvar(fdata0,"Times",-1)
  dims2             = dimsizes(times)
  nt                = dims2(0)
  ch_x              = charactertostring(times(:,8:9)) ;+"~C~"+charactertostring(times(:,11:12))

  pblh              = fdata0->PBLH(:,0,0)/1000

  vartsver          = new((/nvars,nz,nt/),float)
  wks               = gsn_open_wks ("pdf", figname)  ; send graphics to PNG file
  plot              = new(nvars,graphic)
  plot_pblh         = new(nvars,graphic)

  do ivar = 0,nvars-1
     if(ivar.eq.0) then
        v0 := wrf_user_getvar(fdata0,"tc",-1)-wrf_user_getvar(fdata_base,"tc",-1)
     else
        v0 := wrf_user_getvar(fdata0,"rh",-1)-wrf_user_getvar(fdata_base,"rh",-1)
     end if
     do iz = 0,nz-1
        vartsver(ivar,iz,:)  = v0(:,iz,0,0)
     end do

     sta_avg                 = avg(vartsver(ivar,:,:))

     reslonc@tiMainString             := vars(ivar)+"("+units(ivar)+")~C~"+titles(ivar)+":"+sta_avg
     reslonc@tiXAxisString             = "Time"
     reslonc@cnLevelSelectionMode      = "ExplicitLevels" ; use explicit levels
     if(ivar.eq.0) then
        reslonc@cnLevels                 := strides(ivar)*ispan(-20,20,1)
     else
        reslonc@cnLevels                 := ispan(-40,40,2)
     end if
     reslonc@sfYArray                  = hgt(:,0,0)/1000
     reslonc@trYMaxF                   =5.0
;     reslonc@gsnYAxisIrregular2Linear  = True
;     reslonc@tmXBValues               := ispan(0,nt-1-4,24)
;     reslonc@tmXBLabels               := ch_x(ispan(4,nt-1,24))
     reslonc@lbTitleString             = units(ivar)                ; title string
     plot(ivar)      =gsn_csm_contour(wks,vartsver(ivar,:,:),reslonc)
     plot_pblh(ivar) =gsn_xy(wks,ispan(0,nt-1,1),pblh,res)
     overlay(plot(ivar),plot_pblh(ivar))
  end do
  gsn_panel(wks,(/plot/),(/1,2/),True)
      else
      print(fname0 + " not exit")
      continue
      end if

  end do
  end do
  end do
 end

