load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin

  case    = "0101_12Z_ACM2_aod_ssa"
  dirin   = "output/output_"+case+"/"
  dirout  = "./"
  ftable  = "table"+case+".nc"
  prefix  = "wrfout_d01_2013-01-01_12Z_"+case+"_j"
  
  naod    = 7
  nssa    = 16
  njday   = 1
  nvar    = 16

  ; for 19z, ts=11,35; for 12z, ts =18,42
  ts2pmd1 = 18
  ts2pmd2 = 42
    
  aodin   = (/0.0, 0.2, 0.5, 0.7, 1.0, 2.0, 3.0/)
  aodinn   = (/"0.0", "0.2", "0.5", "0.7", "1.0", "2.0", "3.0"/)
  ssain   = (/0.85, 0.86, 0.87, 0.88, 0.89, 0.90, 0.91, 0.92, 0.93, 0.94, 0.95, 0.96, 0.97, 0.98, 0.99, 1.0/)
  ssainn   = (/"0.85", "0.86", "0.87", "0.88", "0.89", "0.90", "0.91", "0.92", "0.93", "0.94", "0.95", "0.96", "0.97", "0.98", "0.99", "1.0"/)

  jdayin  = (/1/)
  varname = (/"PBLH2pmd1", "PBLH2pmd2", "T22pmd1", "T22pmd2", "Q22pmd1", "Q22pmd2", "SWDNB2pmd1", "SWDNB2pmd2", "RH22pmd1", "RH22pmd2", "dZs2pmd1", "dZs2pmd2","HFX2pmd1","HFX2pmd2","LH2pmd1","LH2pmd2"/)
;  varinname = (/"PBLH", "PBLH", "T2", "T2", "Q2", "Q2", "SWDNB", "SWDNB", "RH2", "RH2"/)

  vartype = (/"float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float"/)
  
  table = new((/naod, nssa, nvar/),"float")
  table!0 = "aodin"          ; dimension name
  table!1 = "ssain"
  table&aodin   = aodin      ; dimension value
  table&ssain  = ssain    
  
  system( "rm " + ftable )
  fout   = addfile(dirout + ftable, "c")
  
  dim_names = (/ "aodin",  "ssain"/)
  dim_sizes = (/ naod ,  nssa  /)
  dimUnlim = (/ False , False  /)
  filedimdef( fout, dim_names, dim_sizes, dimUnlim )

  filevardef( fout, varname, vartype, (/"aodin","ssain"/) ) ; define varibles

   
  do iaod = 0, naod-1
    do ijday = 0, njday-1
      do issa = 0, nssa-1
      finname = dirin + prefix + jdayin(ijday) + "_aod" + aodinn(iaod) + "_qc0.0_ssa"+ssainn(issa)
;      print(finname)   ; for debug
      fin  = addfile(finname + ".nc", "r")
      
      ;do ivar = 0, nvar-1
      ;table(iaod,ijday,ivar) = fin->$varinname(n)$(11,0,0)
      
      ; for 19z, ts=11,35; for 12z, ts =18,42
      
      table(iaod,issa,0) = fin->PBLH(ts2pmd1,0,0)            
      table(iaod,issa,1) = fin->PBLH(ts2pmd2,0,0)            
      table(iaod,issa,2) = fin->T2(ts2pmd1,0,0)            
      table(iaod,issa,3) = fin->T2(ts2pmd2,0,0)            
      table(iaod,issa,4) = fin->Q2(ts2pmd1,0,0)            
      table(iaod,issa,5) = fin->Q2(ts2pmd2,0,0)            
      table(iaod,issa,6) = fin->SWDNB(ts2pmd1,0,0)            
      table(iaod,issa,7) = fin->SWDNB(ts2pmd2,0,0)            
      rh2       = wrf_user_getvar(fin,"rh2",-1)             ; W(Time,bottom_top_stag)
;      printVarSummary(rh2)  ; for debug
      rh2d1 = 0.0
      rh2d1 = rh2(ts2pmd1,0,0) *1
;      printVarSummary(rh2d1)  ; for debug
;      table(iaod,issa,8) = rh2d1   
      table(iaod,issa,8) = (/ rh2(ts2pmd1,0,0) /)        
      rh2d1 = rh2(ts2pmd2,0,0) *1
;      table(iaod,issa,9) = rh2d1
      table(iaod,issa,9) = (/ rh2(ts2pmd2,0,0) /)       
      z = ( fin->PHB(:,:,0,0) + fin->PH(:,:,0,0) ) /9.81
      ;print(z(ts2pmd1,0:4))
      table(iaod,issa,10) = z(ts2pmd1,1) - z(ts2pmd1,0)
      table(iaod,issa,11) = z(ts2pmd2,1) - z(ts2pmd2,0)
      table(iaod,issa,12) = fin->HFX(ts2pmd1,0,0)
      table(iaod,issa,13) = fin->HFX(ts2pmd2,0,0)
      table(iaod,issa,14) = fin->LH(ts2pmd1,0,0)
      table(iaod,issa,15) = fin->LH(ts2pmd2,0,0)

      end do     
    end do
  end do
  
      
;  printVarSummary(table) ; for debug
  
  do ivar = 0, nvar-1
    fout->$varname(ivar)$  = table(:,:,ivar)
  end do
  
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "PBLH @ local 2pm, day1"
      varAtt@units       = "m"
      filevarattdef( fout, "PBLH2pmd1", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "PBLH @ local 2pm, day2"
      varAtt@units       = "m"
      filevarattdef( fout, "PBLH2pmd2", varAtt )

      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "RH2 @ local 2pm, day1"
      varAtt@units       = "%"
      filevarattdef( fout, "RH22pmd1", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "RH2 @ local 2pm, day2"
      varAtt@units       = "%"
      filevarattdef( fout, "RH22pmd2", varAtt )

      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "Q2 @ local 2pm, day1"
      varAtt@units       = "kg kg-1"
      filevarattdef( fout, "Q22pmd1", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "Q2 @ local 2pm, day2"
      varAtt@units       = "kg kg-1"
      filevarattdef( fout, "Q22pmd2", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "SWDNB @ local 2pm, day1"
      varAtt@units       = "W m-2"
      filevarattdef( fout, "SWDNB2pmd1", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "SWDNB @ local 2pm, day2"
      varAtt@units       = "W m-2"
      filevarattdef( fout, "SWDNB2pmd2", varAtt )
          
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "T2 @ local 2pm, day1"
      varAtt@units       = "K"
      filevarattdef( fout, "T22pmd1", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "T2 @ local 2pm, day2"
      varAtt@units       = "K"
      filevarattdef( fout, "T22pmd2", varAtt )
      
      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "dZs @ local 2pm, day1"
      varAtt@units       = "m"
      filevarattdef( fout, "dZs2pmd1", varAtt )

      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
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
      
      print(dirout + ftable)

end
