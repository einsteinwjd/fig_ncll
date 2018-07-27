load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin

 cities  = (/"BJ","NJ","ZZ"/)
 ncities = dimsizes(cities)

 ndays   = 25
 iday_str = new(ndays,"string")

 do iday = 0,ndays-1
    if(iday .lt. 9) then
       iday_str_tmp = flt2string(iday+1)
       iday_str(iday)     = "0"+iday_str_tmp
    else
       iday_str(iday)     = flt2string(iday+1)
    end if
 end do

; print(iday_str)
 bc_ratios = (/"0.01","0.02","0.05","0.10","0.12","0.15","0.20"/)
 nbc_ratio = dimsizes(bc_ratios)


 do iday  = 0,ndays - 1
 do icity = 0,ncities - 1

  case    = "chem_01"+iday_str(iday)+"_12Z_"+cities(icity)
  dirin   = "output/output_"+case+"/"
  dirout  = "./tables_chem_EXCH/"
  ssavalue= "ssa0.85"
   do ibc_ratio = 0,nbc_ratio -1
   bc_ratio = bc_ratios(ibc_ratio)
  ftable  = "table_"+case+"_"+ssavalue+"_PBLH.nc"
  prefix  = "wrfout_d01_2013-01-"+iday_str(iday)+"_12Z_"+case+"_j"
 
;  naod    = 10
;  njday   = 1
;  nvar    = 16

  ; for 19z, ts=11,35; for 12z, ts =18,42
  ts2pmd1 = 18
  ts2pmd2 = 42

;  aodin   = (/0.0, 0.2, 0.5, 0.7, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0/)
;   aodin   = fspan(0.0,6.0,61)
;   naod    = dimsizes(aodin)

   aodin   = fspan(10, 500, 50)
   naod    = dimsizes(aodin)


   print(naod)
;  aodinn   = (/"0.0", "0.2", "0.5", "0.7", "1.0", "2.0", "3.0", "4.0", "5.0", "6.0"/)
  aodinn   = sprintf("%2.0f",aodin)
;  print(aodinn)
;  jdayin  = (/1, 30, 60, 90, 120, 150, 180/)
  jdayin  = (/1/)
  varname = (/"PBLH2pmd1", "PBLH2pmd2", "T22pmd1", "T22pmd2", "Q22pmd1", "Q22pmd2", "SWDNB2pmd1", "SWDNB2pmd2", "RH22pmd1", "RH22pmd2", "dZs2pmd1", "dZs2pmd2","HFX2pmd1","HFX2pmd2","LH2pmd1","LH2pmd2","PBLHmaxd1","PBLHmaxd2","BC22pmd1","BC22pmd2"/)
  nvar     = dimsizes(varname)
  njday    = dimsizes(jdayin)  
;  varinname = (/"PBLH", "PBLH", "T2", "T2", "Q2", "Q2", "SWDNB", "SWDNB", "RH2", "RH2","HFX","HFX","LU","LU"/)

  vartype = (/"float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float","float","float","float","float","float","float","float","float"/)
  
  table = new((/naod, njday, nvar/),"float")
  table!0 = "aodin"          ; dimension name
  table!1 = "jdayin"
  table&aodin   = aodin      ; dimension value
  table&jdayin  = jdayin    
  
  system( "rm " +dirout+ ftable )
  fout   = addfile(dirout + ftable, "c")
  
  dim_names = (/ "aodin",  "jdayin"/)
  dim_sizes = (/ naod ,  njday  /)
  dimUnlim = (/ False , False  /)
  filedimdef( fout, dim_names, dim_sizes, dimUnlim )

  filevardef( fout, varname, vartype, (/"aodin","jdayin"/) ) ; define varibles

   
  do iaod = 0, naod-1
    do ijday = 0, njday-1
    
      finname = dirin + prefix + jdayin(ijday) + "_bctconc" + aodinn(iaod)+"_bcratio"+bc_ratio+"_"+ssavalue
;      print(finname)   ; for debug
      if (isfilepresent(finname))
        fin  = addfile(finname + ".nc", "r")
      
      ;do ivar = 0, nvar-1
      ;table(iaod,ijday,ivar) = fin->$varinname(n)$(11,0,0)
      
      ; for 19z, ts=11,35; for 12z, ts =18,42
      
      table(iaod,ijday,0) = fin->PBLH(ts2pmd1,0,0)            
      table(iaod,ijday,1) = fin->PBLH(ts2pmd2,0,0)            
      table(iaod,ijday,2) = fin->T2(ts2pmd1,0,0)            
      table(iaod,ijday,3) = fin->T2(ts2pmd2,0,0)            
      table(iaod,ijday,4) = fin->Q2(ts2pmd1,0,0)            
      table(iaod,ijday,5) = fin->Q2(ts2pmd2,0,0)            
      table(iaod,ijday,6) = fin->SWDNB(ts2pmd1,0,0)            
      table(iaod,ijday,7) = fin->SWDNB(ts2pmd2,0,0)            
      rh2       = wrf_user_getvar(fin,"rh2",-1)             ; W(Time,bottom_top_stag)
;      printVarSummary(rh2)  ; for debug
      rh2d1 = 0.0
      rh2d1 = rh2(ts2pmd1,0,0) *1
;      printVarSummary(rh2d1)  ; for debug
;      table(iaod,ijday,8) = rh2d1   
      table(iaod,ijday,8) = (/ rh2(ts2pmd1,0,0) /)        
      rh2d1 = rh2(ts2pmd2,0,0) *1
;      table(iaod,ijday,9) = rh2d1
      table(iaod,ijday,9) = (/ rh2(ts2pmd2,0,0) /)       
      z = ( fin->PHB(:,:,0,0) + fin->PH(:,:,0,0) ) /9.81
      ;print(z(ts2pmd1,0:4))
      table(iaod,ijday,10) = z(ts2pmd1,1) - z(ts2pmd1,0)
      table(iaod,ijday,11) = z(ts2pmd2,1) - z(ts2pmd2,0)
      table(iaod,ijday,12) = fin->HFX(ts2pmd1,0,0)
      table(iaod,ijday,13) = fin->HFX(ts2pmd2,0,0)
      table(iaod,ijday,14) = fin->LH(ts2pmd1,0,0)
      table(iaod,ijday,15) = fin->LH(ts2pmd2,0,0)
      table(iaod,ijday,16) = dim_max_n(fin->PBLH(13:24,0,0),0)
      table(iaod,ijday,17) = dim_max_n(fin->PBLH(37:48,0,0),0)
      table(iaod,ijday,18) = fin->bc_a02(ts2pmd1,0,0,0)
      table(iaod,ijday,19) = fin->bc_a02(ts2pmd2,0,0,0)

      else
      print(finname + " not exit")
      continue
      end if
        
    end do
  end do

      opt = True
;      opt@fout = dirout+case+"_bc_ratio_"+bc_ratio+"_PBLH.txt"
;      opt@fout = "./"+case+"_PBLHd2.txt"
;      fmt   = "f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3"
;      write_matrix(table(:,:,16),"f8.3",opt)
 
;      opt = True
;      opt@fout = dirout+case+"_bc_ratio_"+bc_ratio+"_PBLH.txt"

	opt@fout = dirout+case+"_bc_ratio_"+bc_ratio+"_BC.txt"
;      opt@fout = "./"+case+"_BCd2.txt"
;      fmt   = "f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3"
      write_matrix(table(:,:,18),"f8.3",opt)

      opt@fout = dirout+case+"_bc_ratio_"+bc_ratio+"_BCd2.txt"
;      opt@fout = "./"+case+"_BCd2.txt"
;      fmt   = "f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3,f8.3"
      write_matrix(table(:,:,19),"f8.3",opt)

      opt@fout = dirout+case+"_bc_ratio_"+bc_ratio+"_PBLH.txt"
      write_matrix(table(:,:,16),"f8.3",opt)

      opt@fout = dirout+case+"_bc_ratio_"+bc_ratio+"_PBLHd2.txt"
      write_matrix(table(:,:,17),"f8.3",opt)
 
      
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

      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "PBLH max day1"
      varAtt@units       = "m"
      filevarattdef( fout, "PBLHmaxd1", varAtt )

      varAtt = 0
      varAtt@coordinates = "AODin JDAYin"
      varAtt@description = "PBLH max day2"
      varAtt@units       = "m"
      filevarattdef( fout, "PBLHmaxd2", varAtt )

      varAtt = 0
      varAtt@coordinates = "BCin JDAYin"
      varAtt@description = "BC @ local 2pm, day1"
      varAtt@units       = "ug/m3"
      filevarattdef( fout, "BC22pmd1", varAtt )

      varAtt = 0
      varAtt@coordinates = "BCin JDAYin"
      varAtt@description = "BC @ local 2pm, day2"
      varAtt@units       = "ug/m3"
      filevarattdef( fout, "BC22pmd2", varAtt )

      print(dirout + ftable)

end do ; bc_ratio
end do
end do
end
