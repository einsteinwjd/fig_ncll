load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func.ncl"
begin
  pnres=True
  pnres@gsnPanelYWhiteSpacePercent = 3
  pnres@gsnPanelXWhiteSpacePercent = 3

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
  ncase      = 8
  casenames  = (/"0101_12Z_ACM2_aod","0110_12Z_model_ACM2_aod","0101_12Z_ACM2_aod","0101_12Z_ACM2_aod","0101_12Z_ACM2_aod","0101_12Z_ACM2_high_cloud","0101_12Z_ACM2_high_cloud","0101_12Z_ACM2_high_cloud"/)
  aod        = "aod0.0"
  aodin      = (/aod, aod, "aod1.0", "aod2.0", "aod3.0", "qc1E-4", "qc2E-3", "qc5E-4"/)
  filenames = new((/ncase/),"string")
  vars              = (/"RTHRATSW","RTHRATLW"/)          
  nvars             = 2
  units             = (/"K s-1",  "K s-1"/)
  titles            = (/"avg",    "avg"/)
  strides           = (/1e-6,      1e-6/)
  sdays      = (/"01","10","01","01","01","01","01","01"/)
  labels     = (/"0101", "0110", "0101_aod1.0", "0101_aod2.0", "0101_aod3.0", "0101_cod6.7","0101_cod13.3", "0101_cod33"/)
  jday       = "j1"
  jdayin     = (/jday,jday,jday,jday,jday,jday,jday,jday/)

;-------------------------------------------------------------------------------------------------- 
  do icase = 0,ncase-1
;  case_aod          = "cloud1.0"  ;!!!!!!
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0110_12Z_model_ACM2_high_cloud/wrfout_d01_2013-01-10_12Z_0110_12Z_model_ACM2_high_cloud_j1_cloud1E-4"
;  case_aod          = "aod1.0"  ;!!!!!!
   if (casenames(icase) .ne. "0101_12Z_ACM2_high_cloud") then
   filenames(icase) = "output/output_"+casenames(icase)+"/wrfout_d01_2013-01-"+sdays(icase)+"_12Z_"+casenames(icase)+"_"+jdayin(icase)+"_"+aodin(icase)+"_qc0.0"
   else
   filenames(icase) = "output/output_"+casenames(icase)+"/wrfout_d01_2013-01-"+sdays(icase)+"_12Z_"+casenames(icase)+"_"+jdayin(icase)+"_"+aodin(icase)
   end if
  fname0            = filenames(icase)
  fdata0            = addfile(fname0+".nc","r")
  figname = "./graph_cross/"+sdays(icase)+"_12Z_"+casenames(icase)+"_"+jdayin(icase)+"_"+aodin(icase)

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
     v0  := fdata0->$vars(ivar)$
     do iz = 0,nz-1
        vartsver(ivar,iz,:)  = v0(:,iz,0,0)
     end do

     sta_avg                 = avg(vartsver(ivar,:,:))

     reslonc@tiMainString             := vars(ivar)+"("+units(ivar)+")~C~"+titles(ivar)+":"+sta_avg
     reslonc@tiXAxisString             = "Time"
     reslonc@cnLevelSelectionMode      = "ExplicitLevels" ; use explicit levels
     reslonc@cnLevels                 := strides(ivar)*ispan(-40,40,2)
     reslonc@sfYArray                  = hgt(:,0,0)/1000
     reslonc@trYMaxF                   =10.0
     reslonc@gsnYAxisIrregular2Linear  = True
;     reslonc@tmXBValues               := ispan(0,nt-1-4,24)
;     reslonc@tmXBLabels               := ch_x(ispan(4,nt-1,24))
     reslonc@lbTitleString             = units(ivar)                ; title string
     plot(ivar)      =gsn_csm_contour(wks,vartsver(ivar,:,:),reslonc)
     plot_pblh(ivar) =gsn_xy(wks,ispan(0,nt-1,1),pblh,res)
     overlay(plot(ivar),plot_pblh(ivar))
  end do
  gsn_panel(wks,(/plot/),(/1,2/),True)
  end do
 end

