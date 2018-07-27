load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin

  case    = "0110_12Z_model_ACM2_aod_layer1_8_intense_YSU"
  dirin   = "output/output_"+case+"/"
  dirout  = "./"
  ssavalue= "ssa0.85"
  ftable  = "table"+case+"_"+ssavalue+"_EXCH.nc"
  prefix  = "wrfout_d01_2013-01-10_12Z_"+case+"_j"
;  naod    = 10
;  nlayer   = 1
;  nvar    = 16

  ; for 19z, ts=11,35; for 12z, ts =18,42
  ts2pmd1 = 18
  ts2pmd2 = 44

;  aodin   = (/0.0, 0.2, 0.5, 0.7, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0/)
   aodin   = fspan(0.0,6.0,61)
   layerin = fspan(0,58,59)
;   layerin = flt2string(layerin_tmp)
   naod    = dimsizes(aodin)

;   print(naod)
;  aodinn   = (/"0.0", "0.2", "0.5", "0.7", "1.0", "2.0", "3.0", "4.0", "5.0", "6.0"/)
  aodinn   = sprintf("%3.1f",aodin)
;  print(aodinn)
;  layerin  = (/1, 30, 60, 90, 120, 150, 180/)
;  layerin  = (/1/)
;  varname = (/"PBLH2pmd1", "PBLH2pmd2", "T22pmd1", "T22pmd2", "Q22pmd1", "Q22pmd2", "SWDNB2pmd1", "SWDNB2pmd2", "RH22pmd1", "RH22pmd2", "dZs2pmd1", "dZs2pmd2","HFX2pmd1","HFX2pmd2","LH2pmd1","LH2pmd2","PBLHavgd1"/)
;   varname = (/"T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1", "T2pmd1","T2pmd1"/)
    varname = "EXCH2pmd1"
  nvar     = dimsizes(varname)
  nlayer    = dimsizes(layerin)  
;  varinname = (/"PBLH", "PBLH", "T2", "T2", "Q2", "Q2", "SWDNB", "SWDNB", "RH2", "RH2","HFX","HFX","LU","LU"/)
;  vartype_tmp = "float"
;  vartype = "float"
;  do i = 0,nlayer-2
;     vartype = (/vartype,vartype_tmp/)
;  end do
;  vartype = (/"float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float","float","float","float","float","float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float","float","float","float","float","float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float","float","float","float","float","float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float","float","float","float","float"/)
   vartype = "float"  
  table = new((/naod, nlayer/),"float")
  table!0 = "aodin"          ; dimension name
  table!1 = "layerin"
  table&aodin   = aodin      ; dimension value
  table&layerin  = layerin    
;  printVarSummary(table) 
 
  system( "rm " + ftable )
  fout   = addfile(dirout + ftable, "c")
  
  dim_names = (/ "aodin",  "layerin"/)
  dim_sizes = (/ naod ,  nlayer  /)
  dimUnlim = (/ False , False  /)
  filedimdef( fout, dim_names, dim_sizes, dimUnlim )

  filevardef( fout, varname, vartype, (/"aodin","layerin"/) ) ; define varibles

   
  do iaod = 0, naod-1
;    do ilayer = 0, nlayer-1
    
      finname = dirin + prefix + "1" + "_aod" + aodinn(iaod)+"_qc0.0_"+ssavalue
;      print(finname)   ; for debug
      if (isfilepresent(finname))
        fin  = addfile(finname + ".nc", "r")
      
      ;do ivar = 0, nvar-1
      ;table(iaod,ilayer,ivar) = fin->$varinname(n)$(11,0,0)
;       printVarSummary(fin->EXCH_H(ts2pmd1,:,0,0))
;       tmp = table(iaod,:)
;       printVarSummary(tmp)
       print(aodinn(iaod))
      ; for 19z, ts=11,35; for 12z, ts =18,42
       table(iaod,:) = fin->EXCH_H(ts2pmd1,0:58,0,0) 
;      table(iaod,ilayer,0) = fin->PBLH(ts2pmd1,0,0)            
;      table(iaod,ilayer,1) = fin->PBLH(ts2pmd2,0,0)            
;      table(iaod,ilayer,2) = fin->T2(ts2pmd1,0,0)            
;      table(iaod,ilayer,3) = fin->T2(ts2pmd2,0,0)            
;      table(iaod,ilayer,4) = fin->Q2(ts2pmd1,0,0)            
;      table(iaod,ilayer,5) = fin->Q2(ts2pmd2,0,0)            
;      table(iaod,ilayer,6) = fin->SWDNB(ts2pmd1,0,0)            
;      table(iaod,ilayer,7) = fin->SWDNB(ts2pmd2,0,0)            
;      rh2       = wrf_user_getvar(fin,"rh2",-1)             ; W(Time,bottom_top_stag)
;      printVarSummary(rh2)  ; for debug
;      rh2d1 = 0.0
;      rh2d1 = rh2(ts2pmd1,0,0) *1
;      printVarSummary(EXCH)  ; for debug
;      table(iaod,ilayer,8) = rh2d1   
;      table(iaod,ilayer,8) = (/ rh2(ts2pmd1,0,0) /)        
;      rh2d1 = rh2(ts2pmd2,0,0) *1
;      table(iaod,ilayer,9) = rh2d1
;      table(iaod,ilayer,9) = (/ rh2(ts2pmd2,0,0) /)       
;      z = ( fin->PHB(:,:,0,0) + fin->PH(:,:,0,0) ) /9.81
;      ;print(z(ts2pmd1,0:4))
;      table(iaod,ilayer,10) = z(ts2pmd1,1) - z(ts2pmd1,0)
;      table(iaod,ilayer,11) = z(ts2pmd2,1) - z(ts2pmd2,0)
;      table(iaod,ilayer,12) = fin->HFX(ts2pmd1,0,0)
;      table(iaod,ilayer,13) = fin->HFX(ts2pmd2,0,0)
;      table(iaod,ilayer,14) = fin->LH(ts2pmd1,0,0)
;      table(iaod,ilayer,15) = fin->LH(ts2pmd2,0,0)
;      table(iaod,ilayer,16) = dim_avg_n(fin->PBLH(13:24,0,0),0)
      else
      print(finname + " not exit")
      continue
      end if
        
;    end do
  end do
      print(dirout + ftable)
      opt = True
      opt@fout = "./"+case+"_EXCH.txt"
      fmt   = "f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3"
      write_matrix(table,"f8.3",opt)
  
      
;  printVarSummary(table) ; for debug
  
  do ivar = 0, nvar-1
    fout->$varname(ivar)$  = table(:,:)
  end do
  
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "EXCH2pmd1 @ local 2pm, day1"
      varAtt@units       = "C"
      filevarattdef( fout, "EXCH2pmd1", varAtt )
      
end
