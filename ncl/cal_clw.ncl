load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin

  case    = "0110_12Z_model_ACM2_high_cloud_test"
  dirin   = "output/output_"+case+"/"
  dirout  = "./"
  ftable  = "cloud_water_path"+case+".nc"
  prefix  = "wrfout_d01_2013-01-10_12Z_"+case+"_j"
  
  nqc_in    = 9
;  njday   = 7
  njday   = 1
  nvar    = 6

  ; for 19z, ts=11,35; for 12z, ts =18,42
  ts2pmd1 = 18
  ts2pmd2 = 42
    
;  aodin   = (/0.0, 0.2, 0.5, 0.7, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0/)
;  aodinn   = (/"0.0", "0.2", "0.5", "0.7", "1.0", "2.0", "3.0", "4.0", "5.0", "6.0"/)
  qc_in = (/0.0, 1.0E-5, 5.0E-5, 1.0E-4, 2.0E-4, 5.0E-4, 1.0E-3, 2.0E-3, 5.0E-3/)
  qc_inn = (/"0.0", "1E-5", "5E-5", "1E-4", "2E-4", "5E-4", "1E-3", "2E-3", "5E-3"/)
;  jdayin  = (/1, 30, 60, 90, 120, 150, 180/)
  jdayin  = (/1/)
;  varname = (/"PBLH2pmd1", "PBLH2pmd2", "T22pmd1", "T22pmd2", "Q22pmd1", "Q22pmd2", "SWDNB2pmd1", "SWDNB2pmd2", "RH22pmd1", "RH22pmd2", "dZs2pmd1", "dZs2pmd2"/)
;  varinname = (/"PBLH", "PBLH", "T2", "T2", "Q2", "Q2", "SWDNB", "SWDNB", "RH2", "RH2"/)
  varname = (/"ALT","QCLOUD"/)

;  vartype = (/"float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float"/)
 
  vartype = (/"float","float"/)
 
  table = new((/nqc_in, njday, nvar+1/),"float")
  table!0 = "qc_in"          ; dimension name
  table!1 = "jdayin"
  table&qc_in   = qc_in      ; dimension value
  table&jdayin  = jdayin    
  
  system( "rm " + ftable )
  fout   = addfile(dirout + ftable, "c")
  
  dim_names = (/ "qc_in",  "jdayin"/)
  dim_sizes = (/ nqc_in ,  njday  /)
  dimUnlim = (/ False , False  /)
  filedimdef( fout, dim_names, dim_sizes, dimUnlim )

  filevardef( fout, varname, vartype, (/"qc_in","jdayin"/) ) ; define varibles
  clw = new((/nqc_in, njday,61,59/),"float")
   
  do iqc = 0, nqc_in-1
    do ijday = 0, njday-1
    
      finname = dirin + prefix + jdayin(ijday) + "_cloud" + qc_inn(iqc)
;      print(finname)   ; for debug
      fin  = addfile(finname + ".nc", "r")
      
      ;do ivar = 0, nvar-1
      ;table(iaod,ijday,ivar) = fin->$varinname(n)$(11,0,0)
      
      ; for 19z, ts=11,35; for 12z, ts =18,42
;      table(iqc,ijday,0) = fin->QCLOUD(ts2pmd1,0,0)
;      table(iqc,ijday,1) = fin->QCLOUD(ts2pmd2,0,0)
;      table(iqc,ijday,2) = fin->ALT(ts2pmd1,0,0)
;      table(iqc,ijday,3) = fin->ALT(ts2pmd2,0,0)
      
;      table(iqc,ijday,0) = fin->PBLH(ts2pmd1,0,0)            
;      table(iqc,ijday,1) = fin->PBLH(ts2pmd2,0,0)            
;      table(iqc,ijday,2) = fin->T2(ts2pmd1,0,0)            
;      table(iqc,ijday,3) = fin->T2(ts2pmd2,0,0)            
;      table(iqc,ijday,4) = fin->Q2(ts2pmd1,0,0)            
;      table(iqc,ijday,5) = fin->Q2(ts2pmd2,0,0)            
;      table(iqc,ijday,6) = fin->SWDNB(ts2pmd1,0,0)            
;      table(iqc,ijday,7) = fin->SWDNB(ts2pmd2,0,0)            
      rh2       = wrf_user_getvar(fin,"rh2",-1)             ; W(Time,bottom_top_stag)
;      printVarSummary(rh2)  ; for debug
      rh2d1 = 0.0
      rh2d1 = rh2(ts2pmd1,0,0) *1
;      printVarSummary(rh2d1)  ; for debug
;      table(iqc,ijday,8) = rh2d1   
;      table(iqc,ijday,8) = (/ rh2(ts2pmd1,0,0) /)        
      rh2d1 = rh2(ts2pmd2,0,0) *1
;      table(iqc,ijday,9) = rh2d1
;      table(iqc,ijday,9) = (/ rh2(ts2pmd2,0,0) /)       
      z = ( fin->PHB(:,:,0,0) + fin->PH(:,:,0,0) ) /9.81

      dz = z(:,1:59)-z(:,0:58)
      print(dz(ts2pmd1,38:40))
      print(fin->ALT(ts2pmd1,38:40,0,0))
      print(fin->QCLOUD(ts2pmd1,38:40,0,0))
      print(z(ts2pmd1,38:40))
;      table(iqc,ijday,10) = z(ts2pmd1,1) - z(ts2pmd1,0)
;      table(iqc,ijday,11) = z(ts2pmd2,1) - z(ts2pmd2,0)
;      clw(iqc,ijday,:,0) = dz(:,0:58)/fin->ALT(:,0:58,0,0)*fin->QCLOUD(:,0:58,0,0)
      tmp = dz(:,0:58)*fin->QCLOUD(:,0:58,0,0)/fin->ALT(:,0:58,0,0)
      clw(iqc,ijday,:,:)=tmp
;      printVarSummary(tmp)    
    end do
  end do
;   do it = 0,60
      print(clw(0,0,ts2pmd1,40))
;   end do
      
;  printVarSummary(table) ; for debug
  
;  do ivar = 0, nvar-1
;    fout->$varname(ivar)$  = table(:,:,ivar)
;  end do
  
;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "PBLH @ local 2pm, day1"
;      varAtt@units       = "m"
;      filevarattdef( fout, "PBLH2pmd1", varAtt )
      
;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "PBLH @ local 2pm, day2"
;      varAtt@units       = "m"
;      filevarattdef( fout, "PBLH2pmd2", varAtt )

;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "RH2 @ local 2pm, day1"
;      varAtt@units       = "%"
;      filevarattdef( fout, "RH22pmd1", varAtt )
      
;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "RH2 @ local 2pm, day2"
;      varAtt@units       = "%"
;      filevarattdef( fout, "RH22pmd2", varAtt )
;
;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "Q2 @ local 2pm, day1"
;      varAtt@units       = "kg kg-1"
;      filevarattdef( fout, "Q22pmd1", varAtt )
;      
;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "Q2 @ local 2pm, day2"
;      varAtt@units       = "kg kg-1"
;      filevarattdef( fout, "Q22pmd2", varAtt )
;      
;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "SWDNB @ local 2pm, day1"
;      varAtt@units       = "W m-2"
;      filevarattdef( fout, "SWDNB2pmd1", varAtt )
;      
;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "SWDNB @ local 2pm, day2"
;      varAtt@units       = "W m-2"
;      filevarattdef( fout, "SWDNB2pmd2", varAtt )
;          
;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "T2 @ local 2pm, day1"
;      varAtt@units       = "K"
;      filevarattdef( fout, "T22pmd1", varAtt )
;      
;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "T2 @ local 2pm, day2"
 ;     varAtt@units       = "K"
 ;     filevarattdef( fout, "T22pmd2", varAtt )
 ;     
 ;     varAtt = 0
 ;     varAtt@coordinates = "QC_in JDAYin"
 ;     varAtt@description = "dZs @ local 2pm, day1"
 ;     varAtt@units       = "m"
 ;;     filevarattdef( fout, "dZs2pmd1", varAtt )
;
;      varAtt = 0
;      varAtt@coordinates = "QC_in JDAYin"
;      varAtt@description = "dZs @ local 2pm, day2"
;      varAtt@units       = "m"
 ;     filevarattdef( fout, "dZs2pmd2", varAtt )
 ;     
;     print(dirout + ftable)
;
end
