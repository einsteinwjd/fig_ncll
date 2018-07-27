load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin

  case    = "0101_12Z_model_ACM2_chem_EXCH_emis_noinitial"
  dirin   = "output/output_"+case+"/"
  dirout  = "./"
  ssavalue= "ssa0.85"
  ftable  = "table"+case+"_"+ssavalue+".nc"
  prefix  = "wrfout_d01_2013-01-01_12Z_"+case+"_j"
  
;  naod    = 10
;  njday   = 1
;  nvar    = 16

  ; for 19z, ts=11,35; for 12z, ts =18,42
  ts2pmd1 = 20
  ts2pmd2 = 44

   emiss   = (/"0.001","0.002","0.003","0.004","0.005","0.006","0.007","0.008","0.009","0.01","0.011","0.012","0.013","0.014","0.015"/)
;    emisss  = fspan(0.001,0.015,15)
;   emiss   = (/"0","0.0016","0.004","0.008","0.016","0.04","0.08"/)
;    emiss   = sprintf("%5.3f",emisss)
    print(emiss)

;  aodin   = (/0.0, 0.2, 0.5, 0.7, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0/)
;   aodin   = fspan(0.0,6.0,61)
;   naod    = dimsizes(aodin)

   aodin   = fspan(10, 400, 40)
   naod    = dimsizes(aodin)

   ntime   = 157

;   print(naod)
;  aodinn   = (/"0.0", "0.2", "0.5", "0.7", "1.0", "2.0", "3.0", "4.0", "5.0", "6.0"/)
  aodinn   = sprintf("%2.0f",aodin)
;  print(aodinn)
;  jdayin  = (/1, 30, 60, 90, 120, 150, 180/)
  jdayin  = (/1/)
  varname = (/"PBLH"/)
  nvar     = dimsizes(varname)
  njday    = dimsizes(jdayin)  
;  varinname = (/"PBLH", "PBLH", "T2", "T2", "Q2", "Q2", "SWDNB", "SWDNB", "RH2", "RH2","HFX","HFX","LU","LU"/)

  vartype = (/"float"/)
  
;  table = new((/ntime, njday, nvar/),"float")
;  table!0 = "aodin"          ; dimension name
;  table!1 = "jdayin"
;  table&aodin   = aodin      ; dimension value
;  table&jdayin  = jdayin    
  
;  system( "rm " + ftable )
;  fout   = addfile(dirout + ftable, "c")
  
;  dim_names = (/ "aodin",  "jdayin"/)
;  dim_sizes = (/ naod ,  njday  /)
;  dimUnlim = (/ False , False  /)
;  filedimdef( fout, dim_names, dim_sizes, dimUnlim )

;  filevardef( fout, varname, vartype, (/"aodin","jdayin"/) ) ; define varibles
nemis = dimsizes(emiss)
   
  do iaod = 0 ,0
    do ijday = 0, njday-1
      do iemis = 0, nemis-1
      finname = dirin + prefix + jdayin(ijday) + "_emis" + emiss(iemis) + "_bctconc0"+"_qc0.0_"+ssavalue
;      print(finname)   ; for debug
      if (isfilepresent(finname))
        fin  = addfile(finname + ".nc", "r")
      
      ;do ivar = 0, nvar-1
      ;table(iaod,ijday,ivar) = fin->$varinname(n)$(11,0,0)
      
      ; for 19z, ts=11,35; for 12z, ts =18,42
      
;      table(iaod,ijday,0) = fin->PBLH(ts2pmd1,0,0)            
;      table(iaod,ijday,1) = fin->PBLH(ts2pmd2,0,0)            
;      table(iaod,ijday,2) = fin->T2(ts2pmd1,0,0)            
;      table(iaod,ijday,3) = fin->T2(ts2pmd2,0,0)            
;      table(iaod,ijday,4) = fin->Q2(ts2pmd1,0,0)            
;      table(iaod,ijday,5) = fin->Q2(ts2pmd2,0,0)            
;      table(iaod,ijday,6) = fin->SWDNB(ts2pmd1,0,0)            
;      table(iaod,ijday,7) = fin->SWDNB(ts2pmd2,0,0)            
;      rh2       = wrf_user_getvar(fin,"rh2",-1)             ; W(Time,bottom_top_stag)
;      printVarSummary(rh2)  ; for debug
;      rh2d1 = 0.0
;      rh2d1 = rh2(ts2pmd1,0,0) *1
;      printVarSummary(rh2d1)  ; for debug
;      table(iaod,ijday,8) = rh2d1   
;      table(iaod,ijday,8) = (/ rh2(ts2pmd1,0,0) /)        
;      rh2d1 = rh2(ts2pmd2,0,0) *1
;      table(iaod,ijday,9) = rh2d1
;      table(iaod,ijday,9) = (/ rh2(ts2pmd2,0,0) /)       
;      z = ( fin->PHB(:,:,0,0) + fin->PH(:,:,0,0) ) /9.81
      ;print(z(ts2pmd1,0:4))
;      table(iaod,ijday,10) = z(ts2pmd1,1) - z(ts2pmd1,0)
;      table(iaod,ijday,11) = z(ts2pmd2,1) - z(ts2pmd2,0)
;      table(iaod,ijday,12) = fin->HFX(ts2pmd1,0,0)
;      table(iaod,ijday,13) = fin->HFX(ts2pmd2,0,0)
;      table(iaod,ijday,14) = fin->LH(ts2pmd1,0,0)
;      table(iaod,ijday,15) = fin->LH(ts2pmd2,0,0)
;      table(iaod,ijday,16) = dim_max_n(fin->PBLH(13:24,0,0),0)
;      table(iaod,ijday,17) = dim_max_n(fin->PBLH(37:48,0,0),0)
      else
      print(finname + " not exit")
      continue
      end if

      opt = True
      opt@fout = "./"+case+ "_emis" + emiss(iemis) + "_bctconc_0"+"_PBLH.txt"
;      write_matrix(fin->PBLH(:,0,0),"f8.3",opt)
      asciiwrite (opt@fout , sprintf("%8.3f", fin->PBLH ))

      end do  
    end do
  end do

  
end
