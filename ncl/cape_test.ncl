load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c

begin

  case    = "0101_12Z_ACM2_aod_layer1_15_intense"
  dirin   = "output/output_"+case+"/"
  dirout  = "./"

  prefix  = "wrfout_d01_2013-01-01_12Z_"+case+"_j"

      finname = dirin + prefix + "1" + "_aod1.0"+"_qc0.0_ssa0.85"
      f2pmd2 = 44
;      print(finname)   ; for debug
      if (isfilepresent(finname))
        fin  = addfile(finname + ".nc", "r")
      else
      print(finname + " not exit")
      end if
      cape                = wrf_user_getvar(fin,"cape_3d",-1)
      printVarSummary(cape)

end
