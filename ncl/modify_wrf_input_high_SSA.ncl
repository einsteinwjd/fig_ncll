load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   

begin

  dirin   = "./"
  dirout  = "./"
  
  bc_tconc= asciiread("input_bc_tconc.txt",-1,"float") 
;  bc_tconc= 150 

      finname = dirin + "wrfinput_d01"
      print(finname)   ; for debug
;      tmp = systemfunc("rm "+finname)
;      tmp = systemfunc("cp ./wrfinput_d01 "+finname)
      if (isfilepresent(finname))
        fin  = addfile(finname + ".nc", "w")
      bc_frac = asciiread("input_aodfrac.txt",-1,"float")
;  print(bc_frac)
;;  update bc profile
  do ilayer = 0,dimsizes(bc_frac) -1
     fin->bc_a02(0,ilayer,:,:) = bc_tconc*bc_frac(ilayer)
  end do

  
  fin->oc_a02          = 5*fin->bc_a02
  fin->so4_a02         = 5*fin->bc_a02
  fin->no3_a02         = 3*fin->bc_a02
  fin->nh4_a02         = 2*fin->bc_a02
      
      else
      print(finname + " not exit")
      continue
      end if
      
end
