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

 cities  = (/"BJ","NJ","ZZ"/)
 ncities = dimsizes(cities)
; colors  = (/"rainbow","NCV_jet","cmocean_matter","precip3_16lev","MPL_YlOrRd"/)
 colors  = (/"rainbow","precip3_16lev"/)
 ncolors = dimsizes(colors) 
 ndays   = 25
 iday_str = new(ndays,"string")

   emiss   = (/"0.001","0.002","0.003","0.004","0.005","0.006","0.007","0.008","0.009","0.01","0.011","0.012","0.013","0.014","0.015","0.016","0.017","0.018","0.019","0.02","0.021","0.022","0.023","0.024","0.025","0.026","0.027","0.028","0.029","0.03","0.031","0.032","0.033","0.034","0.035","0.036","0.037","0.038","0.039","0.04","0.041","0.042","0.043","0.044","0.045","0.046","0.047","0.048","0.049","0.05","0.051","0.052","0.053","0.054","0.055","0.056","0.057","0.058","0.059","0.06","0.061","0.062","0.063","0.064","0.065","0.066","0.067","0.068","0.069","0.07","0.071","0.072","0.073","0.074","0.075","0.076","0.077","0.078","0.079","0.08","0.081","0.082","0.083","0.084","0.085","0.086","0.087","0.088","0.089","0.09","0.091","0.092","0.093","0.094","0.095","0.096","0.097","0.098","0.099","0.1"/)
  nemis = dimsizes(emiss)

 do iday = 0,ndays-1
    if(iday .lt. 9) then
       iday_str_tmp = flt2string(iday+1)
       iday_str(iday)     = "0"+iday_str_tmp
    else
       iday_str(iday)     = flt2string(iday+1)
    end if
 end do

; print(iday_str)

 do iday  = 0,0
 do icity = 0,0
; do iday  = 0,0
; do icity = 0,0

  
ssavalues = (/"ssa0.80", "ssa0.85", "ssa0.90", "ssa0.95", "ssa1.00"/)
;ssavalues = "ssa0.85"
 casename   = "0101_12Z_model_ACM2_chem_EXCH_emis_noinitial"
;  casename   = "0110_12Z_model_ACM2_aod_layer1_8_intense_new"
;  casename   = "01"+iday_str(iday)+"_12Z_"+cities(icity)
  print(casename)
; casename   = "0110_12Z_model_ACM2_aod_layer1_8_intense_YSU"
;-------------------------
  res                               = True
  reslonc                           =True
  reslonc@gsnDraw                   = False
  reslonc@gsnFrame                  = False
  reslonc@gsnRightString            = ""
  reslonc@gsnLeftString             = ""
  reslonc@tiYAxisString             = "Altitude (m)"
  reslonc@tiYAxisOffsetXF           = 0.02
  reslonc@cnLinesOn                 = False
  reslonc@cnFillOn                  = True               ; color plot desired
  reslonc@cnLineLabelsOn            = False              ; turn off contour lines
;   reslonc@cnFillMode              = "RasterFill"
;  reslonc@cnFillMode              = "CellFill"
;  reslonc@cnSmoothingOn             = False
  
;  reslonc@cnSmoothingDistanceF      = .005
  do icolor = 0, 0
; reslonc@cnFillPalette             =  colors(icolor)
;  reslonc@cnFillPalette             = "NCV_jet"  ;WhiteYellowOrangeRed" ;"MPL_Reds"
;  reslonc@cnFillPalette             = "MPL_OrRd"

;cmap = (/"(/ 1,1,1/)",\
;"(/  1 , 0.960784314 , 0.921568627  /)", \
;"(/  0.997752851  ,  0.928606452  ,  0.862194842  /)", \
;"(/  0.996078431  ,  0.901960784  ,  0.807843137  /)", \
;"(/  0.994743272  ,  0.876894244  ,  0.754550874  /)", \
;"(/  0.993513905  ,  0.849453763  ,  0.698355414  /)", \
;"(/  0.992156863  ,  0.815686275  ,  0.635294118  /)", \
;"(/  0.990704301  ,  0.773322484  ,  0.563416162  /)", \
;"(/  0.990250874  ,  0.726828185  ,  0.488817986  /)", \
;"(/  0.992156863  ,  0.682352941  ,  0.419607843  /)", \
;"(/  0.996542647  ,  0.643468688  ,  0.360557172  /)", \
;"(/  0.998569017  ,  0.603436839  ,  0.303090145  /)", \
;"(/  0.992156863  ,  0.552941176  ,  0.235294118  /)", \
;"(/  0.973151762  ,  0.486224378  ,  0.151937112  /)", \
;"(/  0.945098039  ,  0.411764706  ,  0.074509804  /)", \
;"(/  0.909372158  ,  0.340922763  ,  0.025407526  /)", \
;"(/  0.850980392  ,  0.282352941  ,  0.003921569  /)", \
;"(/  0.758477255  ,  0.24126104  ,  0.002805335  /)", \
;"(/  0.650980392  ,  0.211764706  ,  0.011764706  /)", \
;"(/  0.555248236  ,  0.185209549  ,  0.019743685  /)", \
;"(/  0.498039216  ,  0.152941176  ,  0.015686275  /)" \
;/)
cmap=	(/"(/1	,	1	,	1	/)",\
"(/	0.996078431	,	0.901960784	,	0.807843137	/)",\
"(/	0.99512734	,	0.882784986	,	0.761867617	/)",\
"(/	0.993661784	,	0.853156093	,	0.703001718	/)",\
"(/	0.992156863	,	0.815686275	,	0.635294118	/)",\
"(/	0.991087671	,	0.772987697	,	0.562793488	/)",\
"(/	0.990929305	,	0.72767253	,	0.489548506	/)",\
"(/	0.992156863	,	0.682352941	,	0.419607843	/)",\
"(/	0.9946251	,	0.638917093	,	0.355731124	/)",\
"(/	0.995707414	,	0.596357126	,	0.295521761	/)",\
"(/	0.992156863	,	0.552941176	,	0.235294118	/)",\
"(/	0.981610187	,	0.507364266	,	0.173468654	/)",\
"(/	0.96523886	,	0.460028959	,	0.11689023	/)",\
"(/	0.945098039	,	0.411764706	,	0.074509804	/)",\
"(/	0.922071406	,	0.363869853	,	0.052209801	/)",\
"(/	0.892356752	,	0.319518324	,	0.04359851	/)",\
"(/	0.850980392	,	0.282352941	,	0.039215686	/)",\
"(/	0.794592204	,	0.254585517	,	0.031635497	/)",\
"(/	0.72633631	,	0.232703844	,	0.02156976	/)",\
"(/	0.650980392	,	0.211764706	,	0.011764706	/)",\
"(/	0.573292133	,	0.186824888	,	0.004966565	/)",\
"(/	0.498039216	,	0.152941176	,	0.003921569	/)"\
/)						


    reslonc@cnFillPalette             = cmap
cmap2 = read_colormap_file("NCV_jet")
print(cmap2)

;  reslonc@gsnSpreadColors           = True
;  reslonc@gsnSpreadColorStart       = 2
;  reslonc@gsnSpreadColorEnd         = 250

;  reslonc@pmLabelBarHeightF         = 0.06
;  reslonc@pmLabelBarWidthF          = 0.6
  reslonc@lbLabelFontHeightF        = 0.035
;  reslonc@lbAutoManage              = False
;  reslonc@lbLeftMarginF             = 0.2
;  reslonc@lbRightMarginF            = 0.2   
;  reslonc@lbTopMarginF              = 0.2  
;  reslonc@lbLabelOffsetF            = 0.15
;  reslonc@lbLabelStride             = 2
;  reslonc@lbBoxMinorExtentF         = 0.4
  reslonc@tmYROn        =  "off"
  reslonc@tmXTOn        =  "off"
   
   lbLabelAutoManage                = True
   reslonc@lbTitleOn                = False
  reslonc@lbTitleFontHeightF        = .035                ; make title smaller
  reslonc@lbTitleFont               = "helvetica"        
;  reslonc@lbTitleDirection          = "Across"             ; title direction
  reslonc@tmXTBorderOn              = "on"
  reslonc@tmYRBorderOn		    = "on"
  res@tmXBLabelFontHeightF = 0.035
  res@tiXAxisFontHeightF = 0.035
  res@tiYAxisFontHeightF = 0.035
  res@tmYLLabelFontHeightF = 0.035
  res@tmYRLabelFontHeightF = 0.035

  reslonc@tmXBLabelFontHeightF = 0.035
  reslonc@tiXAxisFontHeightF = 0.035
  reslonc@tiYAxisFontHeightF = 0.035
  reslonc@tmYLLabelFontHeightF = 0.035
  reslonc@tmYRLabelFontHeightF = 0.035
        reslonc@tmXBMode                  = "Explicit"
;  reslonc@tmXBMajorLengthF = 0.02
  res@tmXBMinorOn = False
  res@tmYLMinorOn = False
  res@tmXBMajorOutwardLengthF = 0
  res@tmYLMajorOutwardLengthF = 0
  res@tmXBMinorOutwardLengthF = 0
  res@tmYLMinorOutwardLengthF = 0
;   reslonc@gsnStringFontHeightF = 0.03
;........................................
;  res           =True
  res@gsnDraw    = False
  res@gsnFrame   = False
  res@xyMonoLineThickness = False
  res@xyMarkLineMode=  "Lines"
  res@xyDashPattern =   0
  res@xyLineColor   =  "black"
  res@xyLineThicknesses= 10
  res@tmYROn	    =  "off"
  res@tmXTOn	    =  "off"
  res@tmXBMode                  = "Explicit"
  res@tmXTBorderOn              = "on"
  res@tmYRBorderOn              = "on"
;  res@pmLegendDisplayMode    = "Always"            ; turn on legend
  res@pmLegendSide           = "Top"               ; Change location of 
;  res@pmLegendParallelPosF   = .2                  ; move units right
;  res@pmLegendOrthogonalPosF = -0.1                ; move units down
  res@pmLegendWidthF         = 0.6                 ; Change width and
  res@pmLegendHeightF        = 0.2                ; height of legend.
  res@lgPerimOn              = False               ; turn off box around
  res@lgLabelFontHeightF     = 0.035                 ; label font height
;  res@gsnStringFontHeightF   = 0.03
;  res@lgLineLabelFont        = "helvetica"
;  res@xyExplicitLegendLabels = (/"PBL height"/)         ; create explicit labels
;  res@lbTitleFont               = "helvetica"  
  res@tiMainFont                 = "helvetica"
     res@tiMainFont                = "helvetica"
     res@tiXAxisFont               = "helvetica"
     res@tiYAxisFont               = "helvetica"
     reslonc@lgLabelFont               = "helvetica"
     res@tmXBLabelFont             = "helvetica"
     res@tmYLLabelFont        = "helvetica"
;     res@tmXBLabelFontHeightF = 0.3
     
;     res@tmYLLabelFontHeightF = 0.3
;    res@cnSmoothingOn         =  True
;     res@pmLegendFont        = "helvetica"
;-------------------------------------------------------------------------------------------------
;  casenames  = (/"0101_12Z_ACM2_aod_layer1_115","0110_12Z_model_ACM2_aod_layer1_15","0101_12Z_ACM2_aod_layer1_115","0101_12Z_ACM2_aod_layer1_115","0101_12Z_ACM2_aod_layer1_115","0101_12Z_ACM2_high_cloud","0101_12Z_ACM2_high_cloud","0101_12Z_ACM2_high_cloud"/)
  aod        = "aod0.0"
  aodin_tmp  = fspan(0.0,6.0,61)
;  aodin      = sprintf("%3.1f",aodin_tmp)
  aodin      = (/"1.0","1.2","1.3","1.5","0.8"/)
  ncase      = dimsizes(aodin)
  
  filenames = new((/ncase/),"string")
 
  vars              = (/"T","EXCH_H"/)          
  nvars             = 2
  units             = (/"T (C)",  "m~S~2~N~ s~S~-1~N~"/)
  titles            = (/"avg",    "avg"/)
  strides           = (/1,     1/)
  sdays      = (/"01","10","01","01","01","01","01","01"/)
  sday       = iday_str(iday)
  labels     = (/"0101", "0110", "0101_aod1.0", "0101_aod2.0", "0101_aod3.0", "0101_cod6.6", "0101_cod13.3","0101_cod33"/)
;  jdays      = (/"j1", "j30", "j60", "j90", "j120", "j150", "j180"/)
  jdays      = "j1"
;  jday       = "j1"
;  jdayin     = (/jday,jday,jday,jday,jday,jday,jday,jday,jday/)


;  case_aod          = "cloud1.0"  ;!!!!!!
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0110_12Z_model_ACM2_high_cloud/wrfout_d01_2013-01-10_12Z_0110_12Z_model_ACM2_high_cloud_j1_cloud1E-4"
;  case_aod          = "aod0.0"  ;!!!!!!
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0101_12Z_model_ACM2_aod/wrfout_d01_2013-01-01_12Z_0101_12Z_model_ACM2_aod_j1_"+case_aod+"_qc0.0"
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0101_12Z_ACM2_aod/wrfout_d01_2013-01-01_12Z_0101_12Z_ACM2_aod_j1_"+case_aod+"_qc0.0"
;  case_base          = "/home/wjd/WRF_scm/data/WRF-SCM/output_"+casename+"/wrfout_d01_2013-01-10_12Z_0110_12Z_model_ACM2_aod_layer1_8_intense_new_j1_aod0.0_qc0.0_ssa1.00"  ;!changed by Lisa, 2017/06/20
;  fdata_base         = addfile(case_base+".nc","r") ;!changed by Lisa, 2017/06/20 
  do ijday = 0,0
  jday = jdays(ijday)
  do issa  = 1,1
;  do issa  = 4,4
  do icase = 0,0
  do iemis = 0, nemis - 71
     ssavalue = ssavalues(issa)
     print(ssavalue);
;  case_aod          = "cloud1.0"  ;!!!!!!
;  fname0            = "/home/wjd/WRF_scm/data/WRF-SCM/output_0110_12Z_model_ACM2_high_cloud/wrfout_d01_2013-01-10_12Z_0110_12Z_model_ACM2_high_cloud_j1_cloud1E-4"
;  case_aod          = "aod1.0"  ;!!!!!!
;   if (casenames(icase) .ne. "0101_12Z_ACM2_high_cloud") then
   filenames(icase) = "output/output_"+casename+"/wrfout_d01_2013-01-"+sday+"_12Z_"+casename+"_"+jday+"_emis"+emiss(iemis)+"_bctconc0_qc0.0_ssa0.85"
;   else
;   filenames(icase) = "output/output_"+casenames(icase)+"/wrfout_d01_2013-01-"+sdays(icase)+"_12Z_"+casenames(icase)+"_"+jdayin(icase)+"_"+aodin(icase)
;   end if
  fname0            = filenames(icase)
  if (isfilepresent(fname0))
;  fdata0            = addfile(fname0+".nc","r")


  fdata0            = addfile(fname0+".nc","r")

;  hgt_tmp           = wrf_user_getvar(fdata0,"z",0)
  hgt_tmp           = wrf_user_getvar(fdata0,"z",-1)
  dims3             = dimsizes(hgt_tmp)
  print(dims3)
  printVarSummary(hgt_tmp)
  hgt               = new(dims3,float)
  printVarSummary(hgt)
  hgt(:,0,:,:)            = 0
  hgt(:,1:dims3(1)-1,:,:)    = hgt_tmp(:,0:dims3(1)-2,:,:)
;  print(hgt)
  nz                = dims3(1)
  ny                = dims3(2)
  nx                = dims3(3)
; print(hgt(:,:,0,0))
  times             = wrf_user_getvar(fdata0,"Times",-1)
  dims2             = dimsizes(times)
  nt                = dims2(0)
  ch_x              = charactertostring(times(:,11:12)); +"~C~"+charactertostring(times(:,11:12))

  pblh              = fdata0->PBLH(:,0,0)

  vartsver          = new((/nvars,nz,nt/),float)

  plot              = new(nvars,graphic)
  plot_pblh         = new(nvars,graphic)
  plot_pblh2        = new(nvars,graphic)
    dir = "./graph_cross/"+casename
    system("if ! test -d " + dir +" ; then mkdir " + dir + " ; fi")
  do ivar = 1,nvars-1
  figname = "./graph_cross/"+casename+"/test/"+vars(ivar)+"_"+sday+"_12Z_"+casename+"_"+jday+"_"+emiss(iemis)+"_"+ssavalue

   pltType = "png"
   pltType@wkWidth = 2500  
   pltType@wkHeight = 2500 
;   pltType@wkPaperHeightF = 5 * 0.3937
;  pltType@wkPaperWidthF = 5.5*0.3937
   wks   = gsn_open_wks (pltType,figname)                  ; open workstation



;     if(ivar.eq.0) then
;        v0 := wrf_user_getvar(fdata0,"th",-1)-wrf_user_getvar(fdata_base,"th",-1)
;         v0 := wrf_user_getvar(fdata0,"th",-1)  
;     else
;        v0 := fdata0->EXCH_H-fdata_base->EXCH_H
;         v0 := fdata0->EXCH_H
;     end if
	v0 = wrf_user_getvar(fdata0,vars(ivar),-1)
     do iz = 0,nz-1
        vartsver(ivar,iz,:)  = v0(:,iz,0,0)
     end do
        vartsver@_FillValue = -9999
        vartsver = where(vartsver.gt.0.015,vartsver,-0.0001);

     sta_avg                 = avg(vartsver(ivar,:,:))

;     reslonc@tiMainString             := vars(ivar)+"("+units(ivar)+")~C~"+titles(ivar)+":"+sta_avg
     reslonc@tiXAxisString             = "Time"
     reslonc@cnLevelSelectionMode      = "ExplicitLevels" ; use explicit levels
     if(ivar.eq.0) then
        reslonc@cnLevels                 := strides(ivar)*ispan(260,275,1)
     else
        reslonc@cnLevels                 := ispan(0,60,5)
     end if
     reslonc@lbLabelStride         	       = 4
     reslonc@lbOrientation = "vertical"
     reslonc@sfYArray                  = hgt(0,:,0,0)
     res@trYMaxF                   = 2500
;     reslonc@trYMinF		       = 0.0
     reslonc@tiMainFont	               = "helvetica"
     reslonc@tiXAxisFont               = "helvetica"
     reslonc@tiYAxisFont               = "helvetica"
     reslonc@lbLabelFont               = "helvetica"
     reslonc@tmXBLabelFont             = "helvetica"
     reslonc@tmYLLabelFont       = "helvetica"
     reslonc@tmXBMajorLengthF    = 0.01
     reslonc@tmXBMajorLineColor   = "Black"
;     reslonc@                    = "helvetica"
;     reslonc@                    = "helvetica"


     res@trXMinF                   = 0.0
     res@trXMaxF                   = 23.5
;     res@trXMinF                   = 0.0
;     res@trXMaxF                   = 30.0
;     reslonc@gsnYAxisIrregular2Linear  = True
;     reslonc@tmXBValues               := ispan(0,23+12,6)
;     reslonc@tmXBLabels               := (/"-6","0","6","12","18","24"/);ch_x(ispan(0,23,4))
;     reslonc@lbTitleDirection          = "Down"
      reslonc@lbTitleOn        = True                  ; turn on title
      reslonc@lbTitleString        = "K~B~h~N~ "+units(ivar) ; bar title
      reslonc@lbTitlePosition      = "Right"                           ; title location
      reslonc@lbTitleDirection     = "Across"                          ; letter angle
      reslonc@lbTitleAngleF        = 270.                               ; title angle
      reslonc@lbTitleFontHeightF   = 0.035                              ; font height
;     reslonc@lbTitlePostion            = "Right"
;     res@tmXBValues               := ispan(0,23+12,6)
;     res@tmXBLabels               := (/"-6","0","6","12","18","24"/) ;ch_x(ispan(0+12,23,4))
;print(nt)
;print(res@tmXBValues)
;print(res@tmXBLabels)
     plot(ivar)      =gsn_csm_contour(wks,vartsver(ivar,:,52:76),reslonc)
     plot_pblh(ivar) =gsn_xy(wks,ispan(0,nt-1,1),pblh(52:76),res)
     plot_pblh2(ivar) =gsn_xy(wks,ispan(0,nt-1,1),pblh(52:76),res) 
     overlay(plot_pblh(ivar),plot(ivar))
     overlay(plot_pblh(ivar),plot_pblh2(ivar))
  end do
;  end do
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
  end do
  end do
  end do
  end do
 end

