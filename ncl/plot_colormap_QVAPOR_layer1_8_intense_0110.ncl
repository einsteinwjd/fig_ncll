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

ssavalues = (/"ssa0.80", "ssa0.85", "ssa0.90", "ssa0.95", "ssa1.00"/)
;ssavalue = "ssa0.90"
 casename   = "0110_12Z_model_ACM2_aod_layer1_8_intense_new"
; casename   = "0110_12Z_model_ACM2_aod_layer1_8_intense_YSU"
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
  reslonc@cnFillMode              = "CellFill"
;  reslonc@cnSmoothingOn             = False
  
;  reslonc@cnSmoothingDistanceF      = .005
  reslonc@cnFillPalette             = "NCV_blue_red"  ;WhiteYellowOrangeRed" ;"MPL_Reds"
;  reslonc@cnFillPalette             = "NCV_jet"  ;WhiteYellowOrangeRed" ;"MPL_Reds"
;  reslonc@cnFillPalette             = "MPL_OrRd"
;  reslonc@gsnSpreadColors           = True
;  reslonc@gsnSpreadColorStart       = 2
;  reslonc@gsnSpreadColorEnd         = 250

;  reslonc@pmLabelBarHeightF         = 0.06
;  reslonc@pmLabelBarWidthF          = 0.6
;  reslonc@lbLabelFontHeightF        = 0.013
;  reslonc@lbAutoManage              = False
;  reslonc@lbLeftMarginF             = 0.2
;  reslonc@lbRightMarginF            = 0.2   
;  reslonc@lbTopMarginF              = 0.2  
;  reslonc@lbLabelOffsetF            = 0.15
;  reslonc@lbLabelStride             = 2
;  reslonc@lbBoxMinorExtentF         = 0.4
;  reslonc@lbTitleOn                 =  True                ; turn on title
;  reslonc@lbTitleString             = "K s-1"
;  reslonc@lbTitlePosition           = "Right"              ; title position
  reslonc@lbTitleFontHeightF        = .025                ; make title smaller
  reslonc@lbTitleFont               = "times-roman"        
  reslonc@lbTitleDirection          = "Across"             ; title direction
  reslonc@tmXBLabelFontHeightF = 0.025
  reslonc@tiXAxisFontHeightF = 0.035
        reslonc@tmXBMode                  = "Explicit"
;........................................
  res           =True
  res@gsnDraw    = False
  res@gsnFrame   = False
  res@xyMonoLineThickness = False
  res@xyMarkLineMode=  "Lines"
  res@xyDashPattern =   0
  res@xyLineColor   =  "black"
  res@xyLineThicknesses= 10
  res@tmXBMode                  = "Explicit"
  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "Top"               ; Change location of 
;  res@pmLegendParallelPosF   = .2                  ; move units right
  res@pmLegendOrthogonalPosF = -0.14                ; move units down
  res@pmLegendWidthF         = 0.6                 ; Change width and
  res@pmLegendHeightF        = 0.2                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = 0.5                 ; label font height
;  res@lgLineLabelFont        = "times-roman"
  res@xyExplicitLegendLabels = (/"PBL height"/)         ; create explicit labels
;  res@lbTitleFont               = "times-roman"  
  res@tiMainFont                 = "times-roman"
     res@tiMainFont                = "times-roman"
     res@tiXAxisFont               = "times-roman"
     res@tiYAxisFont               = "times-roman"
     res@lgLabelFont               = "times-roman"
     res@tmXBLabelFont             = "times-roman"
     res@tmYLLabelFont        = "times-roman"
     res@tmXBLabelFontHeightF = 0.35
     
     res@tmYLLabelFontHeightF = 0.35
;    res@cnSmoothingOn         =  True
;     res@pmLegendFont        = "times-roman"
;-------------------------------------------------------------------------------------------------
;  casenames  = (/"0101_12Z_ACM2_aod_layer1_115","0110_12Z_model_ACM2_aod_layer1_15","0101_12Z_ACM2_aod_layer1_115","0101_12Z_ACM2_aod_layer1_115","0101_12Z_ACM2_aod_layer1_115","0101_12Z_ACM2_high_cloud","0101_12Z_ACM2_high_cloud","0101_12Z_ACM2_high_cloud"/)
  aod        = "aod0.0"
  aodin_tmp  = fspan(0.0,6.0,61)
  aodin      = sprintf("%3.1f",aodin_tmp)
  ncase      = dimsizes(aodin)
  
  filenames = new((/ncase/),"string")
 
  vars              = (/"QVAPOR","QVAPOR"/)          
  nvars             = 2
  units             = (/"T (C)",  "   QV~C~(kg kg~S~-1~N~)"/)
  titles            = (/"avg",    "avg"/)
  strides           = (/1,     1/)
  sdays      = (/"01","10","01","01","01","01","01","01"/)
  sday       = "10"
  labels     = (/"0101", "0110", "0101_aod1.0", "0101_aod2.0", "0101_aod3.0", "0101_cod6.6", "0101_cod13.3","0101_cod33"/)
  jdays      = (/"j1", "j30", "j60", "j90", "j120", "j150", "j180"/)
;  jday       = "j1"
;  jdayin     = (/jday,jday,jday,jday,jday,jday,jday,jday,jday/)


;  case_aod          = "cloud1.0"  ;!!!!!!
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0110_12Z_model_ACM2_high_cloud/wrfout_d01_2013-01-10_12Z_0110_12Z_model_ACM2_high_cloud_j1_cloud1E-4"
;  case_aod          = "aod0.0"  ;!!!!!!
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0101_12Z_model_ACM2_aod/wrfout_d01_2013-01-01_12Z_0101_12Z_model_ACM2_aod_j1_"+case_aod+"_qc0.0"
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0101_12Z_ACM2_aod/wrfout_d01_2013-01-01_12Z_0101_12Z_ACM2_aod_j1_"+case_aod+"_qc0.0"
  case_base          = "/home/wjd/WRF_scm/data/WRF-SCM/output_"+casename+"/wrfout_d01_2013-01-10_12Z_0110_12Z_model_ACM2_aod_layer1_8_intense_new_j1_aod0.0_qc0.0_ssa1.00"  ;!changed by Lisa, 2017/06/20
  fdata_base         = addfile(case_base+".nc","r") ;!changed by Lisa, 2017/06/20 
  do ijday = 0,0
  jday = jdays(ijday)
;  do issa  = 0,4
  do issa  = 4,4
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


  fdata0            = addfile(fname0+".nc","r")

  hgt_tmp           = wrf_user_getvar(fdata0,"z",0)
  dims3             = dimsizes(hgt_tmp)
;  print(dims3(0))
  hgt               = new(dims3,float)
;  printVarSummary(hgt)
  hgt(0,:,:)            = 0
  hgt(1:dims3(0)-1,:,:)    = hgt_tmp(0:dims3(0)-2,:,:)
  print(hgt)
  nz                = dims3(0)
  ny                = dims3(1)
  nx                = dims3(2)
;print(hgt(:,0,0))
  times             = wrf_user_getvar(fdata0,"Times",-1)
  dims2             = dimsizes(times)
  nt                = dims2(0)
  ch_x              = charactertostring(times(:,11:12)); +"~C~"+charactertostring(times(:,11:12))

  pblh              = fdata0->PBLH(:,0,0)/1000

  vartsver          = new((/nvars,nz,nt/),float)
;  wks               = gsn_open_wks ("pdf", figname)  ; send graphics to PNG file

  plot              = new(nvars,graphic)
  plot_pblh         = new(nvars,graphic)

  do ivar = 0,nvars-1
  figname = "./graph_cross/"+casename+"/QVAPOR/"+vars(ivar)+"_diff_"+sday+"_12Z_"+casename+"_"+jday+"_"+aodin(icase)+"_"+ssavalue
;   figname = "./graph_cross/"+casename+"/"+vars(ivar)+"_"+sday+"_12Z_"+casename+"_"+jday+"_"+aodin(icase)+"_"+ssavalue

   pltType = "png"
   pltType@wkWidth = 2500   ;!changed by lisa, 2017/06/21
   pltType@wkHeight = 2500  ;!changed by lisa, 2017/06/21
   wks   = gsn_open_wks (pltType,figname)                  ; open workstation

     if(ivar.eq.0) then
;        v0 := wrf_user_getvar(fdata0,"QVAPOR",-1)-wrf_user_getvar(fdata_base,"QVAPOR",-1)
;         v0 := wrf_user_getvar(fdata0,"QVAPOR",-1)  
         v0 := fdata0->QSNOW-fdata_base->QSNOW
     else
        v0 := fdata0->QVAPOR-fdata_base->QVAPOR
;         v0 := fdata0->QVAPOR
     end if
     do iz = 0,nz-1
        vartsver(ivar,iz,:)  = v0(:,iz,0,0)
     end do

     sta_avg                 = avg(vartsver(ivar,:,:))

;     reslonc@tiMainString             := vars(ivar)+"("+units(ivar)+")~C~"+titles(ivar)+":"+sta_avg
     reslonc@tiXAxisString             = "Time"
     reslonc@cnLevelSelectionMode      = "ExplicitLevels" ; use explicit levels
     if(ivar.eq.0) then
        reslonc@cnLevels                 := strides(ivar)*ispan(260,275,1)
     else
        reslonc@cnLevels                 := 0.005/20/50*ispan(-20,20,2)
     end if
     reslonc@lbOrientation = "vertical"
     reslonc@sfYArray                  = hgt(:,0,0)/1000
     reslonc@trYMaxF                   = 1.0
;     reslonc@trYMinF		       = 0.0
     reslonc@tiMainFont	               = "times-roman"
     reslonc@tiXAxisFont               = "times-roman"
     reslonc@tiYAxisFont               = "times-roman"
     reslonc@lbLabelFont               = "times-roman"
     reslonc@tmXBLabelFont             = "times-roman"
     reslonc@tmYLLabelFont       = "times-roman"
;     reslonc@                    = "times-roman"
;     reslonc@                    = "times-roman"


;     reslonc@trXMinF                   = 6.0
;     reslonc@trXMaxF                   = 30.0
;     reslonc@gsnYAxisIrregular2Linear  = True
;     reslonc@tmXBValues               := ispan(0,23+12,6)
;     reslonc@tmXBLabels               := (/"-6","0","6","12","18","24"/);ch_x(ispan(0,23,4))
;     reslonc@lbTitleString             = units(ivar)                ; title string
;     res@tmXBValues               := ispan(0,23+12,6)
;     res@tmXBLabels               := (/"-6","0","6","12","18","24"/) ;ch_x(ispan(0+12,23,4))
;print(nt)
;print(res@tmXBValues)
;print(res@tmXBLabels)
     plot(ivar)      =gsn_csm_contour(wks,vartsver(ivar,:,4:28),reslonc)
     plot_pblh(ivar) =gsn_xy(wks,ispan(0,nt-1,1),pblh(4:28),res)
     overlay(plot(ivar),plot_pblh(ivar))
  end do
;  gsn_panel(wks,(/plot/),(/1,2/),True)
  pres = True
  maximize_output(wks,pres)
      else
      print(fname0 + " not exit")
      continue
      end if

  end do
  end do
  end do
 end

