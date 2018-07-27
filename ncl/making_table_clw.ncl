load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin

  case    = "0110_12Z_model_ACM2_high_cloud"
  dirin   = "output/output_"+case+"/"
  dirout  = "./"
  ftable  = "table"+case+".nc"
  prefix  = "wrfout_d01_2013-01-10_12Z_"+case+"_j"
  
  nqc_in    = 9
  njday   = 7
;  njday   = 1
  nvar    = 20

  ; for 19z, ts=11,35; for 12z, ts =18,42
  ts2pmd1 = 18
  ts2pmd2 = 42
    
;  aodin   = (/0.0, 0.2, 0.5, 0.7, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0/)
;  aodinn   = (/"0.0", "0.2", "0.5", "0.7", "1.0", "2.0", "3.0", "4.0", "5.0", "6.0"/)
  qc_in = (/0.0, 1.0E-5, 5.0E-5, 1.0E-4, 2.0E-4, 5.0E-4, 1.0E-3, 2.0E-3, 5.0E-3/)
  qc_inn = (/"0.0", "1E-5", "5E-5", "1E-4", "2E-4", "5E-4", "1E-3", "2E-3", "5E-3"/)
  clw = qc_in * 500
  jdayin  = (/1, 30, 60, 90, 120, 150, 180/)
;  jdayin  = (/1/)
  varname = (/"PBLH2pmd1", "PBLH2pmd2", "T22pmd1", "T22pmd2", "Q22pmd1", "Q22pmd2", "SWDNB2pmd1", "SWDNB2pmd2", "RH22pmd1", "RH22pmd2", "dZs2pmd1", "dZs2pmd2","HFX2pmd1","HFX2pmd2","LH2pmd1","LH2pmd2","LWUPB2pmd1","LWUPB2pmd2","LWDNB2pmd1","LWDNB2pmd2"/)
;  varinname = (/"PBLH", "PBLH", "T2", "T2", "Q2", "Q2", "SWDNB", "SWDNB", "RH2", "RH2"/)

  vartype = (/"float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float","float", "float", "float", "float"/)
  
  table = new((/nqc_in, njday, nvar/),"float")
  table!0 = "clw"          ; dimension name
  table!1 = "jdayin"
  table&clw   = clw      ; dimension value
  table&jdayin  = jdayin    
  
  system( "rm " + ftable )
  fout   = addfile(dirout + ftable, "c")
  
  dim_names = (/ "clw",  "jdayin"/)
  dim_sizes = (/ nqc_in ,  njday  /)
  dimUnlim = (/ False , False  /)
  filedimdef( fout, dim_names, dim_sizes, dimUnlim )

  filevardef( fout, varname, vartype, (/"clw","jdayin"/) ) ; define varibles

   
  do iqc = 0, nqc_in-1
    do ijday = 0, njday-1
    
      finname = dirin + prefix + jdayin(ijday) + "_cloud" + qc_inn(iqc)
;      print(finname)   ; for debug
      fin  = addfile(finname + ".nc", "r")
      
      ;do ivar = 0, nvar-1
      ;table(iaod,ijday,ivar) = fin->$varinname(n)$(11,0,0)
      
      ; for 19z, ts=11,35; for 12z, ts =18,42
      
      table(iqc,ijday,0) = fin->PBLH(ts2pmd1,0,0)            
      table(iqc,ijday,1) = fin->PBLH(ts2pmd2,0,0)            
      table(iqc,ijday,2) = fin->T2(ts2pmd1,0,0)            
      table(iqc,ijday,3) = fin->T2(ts2pmd2,0,0)            
      table(iqc,ijday,4) = fin->Q2(ts2pmd1,0,0)            
      table(iqc,ijday,5) = fin->Q2(ts2pmd2,0,0)            
      table(iqc,ijday,6) = fin->SWDNB(ts2pmd1,0,0)            
      table(iqc,ijday,7) = fin->SWDNB(ts2pmd2,0,0)            
      rh2       = wrf_user_getvar(fin,"rh2",-1)             ; W(Time,bottom_top_stag)
;      printVarSummary(rh2)  ; for debug
      rh2d1 = 0.0
      rh2d1 = rh2(ts2pmd1,0,0) *1
;      printVarSummary(rh2d1)  ; for debug
;      table(iqc,ijday,8) = rh2d1   
      table(iqc,ijday,8) = (/ rh2(ts2pmd1,0,0) /)        
      rh2d1 = rh2(ts2pmd2,0,0) *1
;      table(iqc,ijday,9) = rh2d1
      table(iqc,ijday,9) = (/ rh2(ts2pmd2,0,0) /)       
      z = ( fin->PHB(:,:,0,0) + fin->PH(:,:,0,0) ) /9.81
      ;print(z(ts2pmd1,0:4))
      table(iqc,ijday,10) = z(ts2pmd1,1) - z(ts2pmd1,0)
      table(iqc,ijday,11) = z(ts2pmd2,1) - z(ts2pmd2,0)
      table(iqc,ijday,12) = fin->HFX(ts2pmd1,0,0)
      table(iqc,ijday,13) = fin->HFX(ts2pmd2,0,0)
      table(iqc,ijday,14) = fin->LH(ts2pmd1,0,0)
      table(iqc,ijday,15) = fin->LH(ts2pmd2,0,0)
      table(iqc,ijday,16) = fin->LWUPB(ts2pmd1,0,0)
      table(iqc,ijday,17) = fin->LWUPB(ts2pmd2,0,0)
      table(iqc,ijday,18) = fin->LWDNB(ts2pmd1,0,0)
      table(iqc,ijday,19) = fin->LWDNB(ts2pmd2,0,0)

          
    end do
  end do
  
      
;  printVarSummary(table) ; for debug
  
  do ivar = 0, nvar-1
    fout->$varname(ivar)$  = table(:,:,ivar)
  end do
  
      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "PBLH @ local 2pm, day1"
      varAtt@units       = "m"
      filevarattdef( fout, "PBLH2pmd1", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "PBLH @ local 2pm, day2"
      varAtt@units       = "m"
      filevarattdef( fout, "PBLH2pmd2", varAtt )

      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "RH2 @ local 2pm, day1"
      varAtt@units       = "%"
      filevarattdef( fout, "RH22pmd1", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "RH2 @ local 2pm, day2"
      varAtt@units       = "%"
      filevarattdef( fout, "RH22pmd2", varAtt )

      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "Q2 @ local 2pm, day1"
      varAtt@units       = "kg kg-1"
      filevarattdef( fout, "Q22pmd1", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "Q2 @ local 2pm, day2"
      varAtt@units       = "kg kg-1"
      filevarattdef( fout, "Q22pmd2", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "SWDNB @ local 2pm, day1"
      varAtt@units       = "W m-2"
      filevarattdef( fout, "SWDNB2pmd1", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "SWDNB @ local 2pm, day2"
      varAtt@units       = "W m-2"
      filevarattdef( fout, "SWDNB2pmd2", varAtt )
          
      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "T2 @ local 2pm, day1"
      varAtt@units       = "K"
      filevarattdef( fout, "T22pmd1", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "T2 @ local 2pm, day2"
      varAtt@units       = "K"
      filevarattdef( fout, "T22pmd2", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "dZs @ local 2pm, day1"
      varAtt@units       = "m"
      filevarattdef( fout, "dZs2pmd1", varAtt )

      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "dZs @ local 2pm, day2"
      varAtt@units       = "m"
      filevarattdef( fout, "dZs2pmd2", varAtt )
     
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "HFX @ local 2pm, day2"
      varAtt@units       = "W/m"
      filevarattdef( fout, "HFX2pmd1", varAtt )

      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "HFX @ local 2pm, day1"
      varAtt@units       = "W/m"
      filevarattdef( fout, "HFX2pmd2", varAtt )

      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "LH @ local 2pm, day2"
      varAtt@units       = "W/m"
      filevarattdef( fout, "LH2pmd1", varAtt )

      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "LH @ local 2pm, day1"
      varAtt@units       = "W/m"
      filevarattdef( fout, "LH2pmd2", varAtt )

      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "LWUPB @ local 2pm, day1"
      varAtt@units       = "W m-2"
      filevarattdef( fout, "LWUPB2pmd1", varAtt )

      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "LWUPB @ local 2pm, day2"
      varAtt@units       = "W m-2"
      filevarattdef( fout, "LWUPB2pmd2", varAtt )


      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "LWDNB @ local 2pm, day1"
      varAtt@units       = "W m-2"
      filevarattdef( fout, "LWDNB2pmd1", varAtt )

      varAtt = 0
      varAtt@coordinates = "QC_in JDAYin"
      varAtt@description = "LWDNB @ local 2pm, day2"
      varAtt@units       = "W m-2"
      filevarattdef( fout, "LWDNB2pmd2", varAtt )

 
      print(dirout + ftable)

end
