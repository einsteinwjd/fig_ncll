load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin

  date    = "10"
  case    = "01"+date+"_12Z_model_ACM2_chem_EXCH_uniform"
  dirin   = "output/output_"+case+"/"
  dirout  = "./txt_chem"
  ssavalue= "ssa0.85"
  ftable  = "table"+case+"_"+ssavalue+".nc"
  prefix  = "wrfout_d01_2013-01-"+date+"_12Z_"+case+"_j"
  
;  naod    = 10
;  njday   = 1
;  nvar    = 16
  varnames = (/"EXCH_H","bc_a02","PBLH","th","RTHRATSW","EXTAER2","TAUAER2"/)
  nvar     = dimsizes(varnames)
  ; for 19z, ts=11,35; for 12z, ts =18,42
  ts2pmd1 = 20
  ts2pmd2 = 44
;   emiss   = (/"0.001","0.002","0.003","0.004","0.005","0.006","0.007","0.008","0.009","0.01","0.011","0.012","0.013","0.014","0.015"/)
   emiss   = (/"0.001","0.002","0.003","0.004","0.005","0.006","0.007","0.008","0.009","0.01","0.011","0.012","0.013","0.014","0.015","0.016","0.017","0.018","0.019","0.02","0.021","0.022","0.023","0.024","0.025","0.026","0.027","0.028","0.029","0.03","0.031","0.032","0.033","0.034","0.035","0.036","0.037","0.038","0.039","0.04","0.041","0.042","0.043","0.044","0.045","0.046","0.047","0.048","0.049","0.05","0.051","0.052","0.053","0.054","0.055","0.056","0.057","0.058","0.059","0.06","0.061","0.062","0.063","0.064","0.065","0.066","0.067","0.068","0.069","0.07","0.071","0.072","0.073","0.074","0.075","0.076","0.077","0.078","0.079","0.08","0.081","0.082","0.083","0.084","0.085","0.086","0.087","0.088","0.089","0.09","0.091","0.092","0.093","0.094","0.095","0.096","0.097","0.098","0.099","0.1"/)
;emiss   = (/"0.001","0.002","0.003","0.004","0.005","0.006","0.007","0.008","0.009","0.01","0.011","0.012","0.013","0.014","0.015","0.016","0.017","0.018","0.019","0.02","0.021","0.022","0.023","0.024","0.025","0.026","0.027","0.028","0.029","0.03","0.031","0.032","0.033","0.034","0.035","0.036","0.037","0.038","0.039","0.04"/)
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
  nvar     = dimsizes(varnames)
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
do ivar = 0,nvar -1
  varname = varnames(ivar) 
  print(varname)
  do iaod = 0 ,naod - 1
    do ijday = 0, njday-1
      do iemis = 0, 0
      finname = dirin + prefix + jdayin(ijday) + "_bctconc0"+"_qc0.0_"+ssavalue
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
      
      varoutput = wrf_user_getvar(fin,varname,-1)
      varvsum   = dim_sum_n(varoutput,1)
      opt = True
      opt@fout = dirout + "/"+case + "_bctconc_"+iaod+"_"+aodinn(iaod)+"_"+varname+".txt"
;      write_matrix(fin->PBLH(:,0,0),"f8.3",opt)
;      asciiwrite (opt@fout , sprintf("%8.3f", fin->$varname$ ))
      asciiwrite (opt@fout , sprintf("%8.4e", varoutput ))
;      if (str_match(varname,"TAUAER2")) then
;      opt_vsum = True
'      opt_vsum@fout = dirout + "/"+case + "_bctconc_"+iaod+"_"+aodinn(iaod)+"_"+varname+"_vsum.txt"
'      asciiwrite (opt_vsum@fout , sprintf("%8.4e", varvsum ))
'      delete(varvsum)
;      end if
      delete(varoutput)
;      delete(varvsum)
      end do ;iemis 
    end do   ;iday
  end do     ;iaod
end do       ;ivar
  
end
