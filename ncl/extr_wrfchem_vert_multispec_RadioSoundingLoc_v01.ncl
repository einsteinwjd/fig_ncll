;========================================================================
; DESC:
; (1) Extract vertical meteo parameters, according to the location of
;     radiosoudings.
; (2) Extract every 6 hours, that's the denses time gap for radio sounding
;     measurements!
;------------------------------------------------------------------------
; NOTE-1:
;------------------------------------------------------------------------
; HISTORY:
; (1) First made on June 22, 2010, at CGRER, USA.
;------------------------------------------------------------------------
; By: Y. F. Cheng
; Version: 01
;========================================================================

;= load my own ncl5.1.1 lib
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/yfc_lib/yfc_lib_v01.ncl"

begin  ; begin the NCL script

;- namelist.input -------------------------------------------------------
;========================================================================

;- radiou sounding station list
ipath_sid = "/gpfs/airsat/biogeo/biogeo/y.cheng/SHARE/4YCHEN/run_heter_noSOIL/"
iname_sid = "wyo_radiosounding_stationID_list_eastAsia.txt"
ncol_sid = 4
icol_sid = 0
icol_lat = 1
icol_lon = 2
icol_alt = 3

;- refspec
refspec = "T"

;- istart and jstart of wrfmodel
istart = 1.5
jstart = 1.5

;- input data
!caseid = "48"
domid = "03"

!ipath_wrf = "/nfs/hail/local/vol01/projects/gcarmich/yafcheng/PROJECTS/01_OlyBJ/WRF_OUTPUT/OlyBJ_3D_81kmS_c" + caseid + "/"
!ipath_wrf = "/gpfs/airsat/biogeo/biogeo/y.cheng/SHARE/4YCHEN/run_heter_noSOIL/"
ipath_wrf = "/gpfs/airsat/biogeo/home/cwei/projs/BJ2013_Winter_Haze/data/output/output_v351_1xaer_ACM2/"
iname_wrf = "wrfout_d" + domid + "_2013-01-*"
iname_wrf_e = ".nc"
;- extract every xx hour data, depending on the domian's time resolution
tintv = 1

;- total hours in one file
thours = 24

;- specname
specnum = 2
specname = (/"HONO","NO2"/)

flag_chem = (/1,1/)

;- output headline
hl_ctl = "station_id lat_degree lon_degree alt_meter control"
output_specnum = specnum
hl_odata = "Pres_hPa SLP_hPa HGT_mdl_m HGT_alt_m Temp_Cdegree Dwpt_Cdegree RH_% U_ms-1 V_ms-1 Theta_Kdegree NO2PhotolysisRate_min-1 DryPM2.5_ugm-3 AOD1 AOD2 AOD3 AOD4 WaterVapor_kgkg-1"

;- output format
ofmt_s = "f12.4"

;- output filename
opath = "./"
oname_data = "wrfchem_d" + domid + "_S"
oname_ctl = "wrfchem_d" + domid + "_ctl"
oname_e = ".dat"

;========================================================================

;- start main program ---------------------------------------------------
;========================================================================

;- read in the station id and location
station_data = readAsciiTable((ipath_sid+iname_sid),ncol_sid,"float",1)
dimnum = dimsizes(station_data)
;print(dimnum)
stationnum = dimnum(0)
delete(dimnum)

;- list input files and count how many --------------------

; Make a list of all files we are interested in by using "systemfunc"
; systemfunc executes a shell command and returns the output.
FILES = systemfunc ("ls -1 " + ipath_wrf + iname_wrf)

; count how many files with "dimsizes"
; Returns the dimension sizes of the input variable.
; The dimsizes function returns an integer array of dimension sizes for the parameter data.
; Each index in the array corresponds to the dimension number of the same value.
numFILES = dimsizes(FILES)
print("Number of input files = " + numFILES)

  
;- open the first file as the reffile
refa = addfile(FILES(0)+iname_wrf_e,"r")
refdata = refa->$refspec$
; printVarSummary(refdata)
dimnum = dimsizes(refdata)
TI = dimnum(3)
TJ = dimnum(2)
TL = dimnum(1)

NI = new(TI,double)
NJ = new(TJ,double)
NI(0) = istart
NJ(0) = jstart
do i = 1,(TI-1)
  NI(i) = NI(i-1) + 1.0
end do
delete(i)
do i = 1,(TJ-1)
  NJ(i) = NJ(i-1) + 1.0
end do
delete(i)

;- output control file
octl = new((/stationnum,(ncol_sid+1)/),float)
octl(:,0:(ncol_sid-1)) = station_data

;- loop over the stations
do istation = 0,(stationnum-1)
;** do istation = 0,0  ; for debugging

  ;- station information
  sid = station_data(istation,icol_sid)
  loclat = station_data(istation,icol_lat)
  loclon = station_data(istation,icol_lon)
  localt = station_data(istation,icol_alt)

  ; for debugging
  ; loclat = 1.0;
  ; loclon = 10.0;

  ; get i, j values of specific location
  opt = True
  opt@returnInt = False   ; Return real values (set to True for integer values - integer is default)
  loc = wrf_user_ll_to_ij (refa, loclon, loclat, opt)
  print("Location in Model (i - lon) = " + loc(0))
  print("Location in Model (j - lat) = " + loc(1))
  delete(opt)

  if (((loc(0).ge.1.0).and.(loc(0).le.(TI+1))) .and. ((loc(1).ge.1.0).and.(loc(1).le.(TJ+1)))) then
   
    octl(istation,ncol_sid) = 1

    ; loop over wrffiles
    do ifile = 0,(numFILES-1)
    ;** do ifile = 0,0   ; for debugging

    ; add file
    nc_file = addfile(FILES(ifile)+iname_wrf_e,"r")
    times = nc_file->Times
    jultimes = wrf_times_c(times, 1)/24.0 + greg2jul(1901,1,1,0)
    delete(times)

    do it = 0,(thours-1),tintv 

      ; print("HELLOOOOOO, it = " + it)

      ; prepare the output data
      odata = new((/TL,output_specnum/),float)

      kt = 0

      ; loop over species
      do ispec = 0,(specnum-1)

        flat_other = 1

        if (specname(ispec) .eq. "height") then
          terr = wrf_user_getvar(nc_file,"HGT",it)
          odata(:,(kt+1)) = linint2_points (NI,NJ,terr,True,loc(0),loc(1),0)
          height_rec = new((/TL+1/),float)
          height_rec = linint2_points (NI,NJ,terr,True,loc(0),loc(1),0)
          delete(terr)
          datatmp = wrf_user_getvar(nc_file,specname(ispec),it)
          do il = 0,(TL-1)
            ivar = datatmp(il,:,:)
            height_rec(il+1) = linint2_points (NI,NJ,ivar,True,loc(0),loc(1),0)
            ; if il .eq. 0 then
              ; print(height_rec(il))
              ; print(height_rec(il+1))
              ; print("CHECK HEIGHT!!!!!!!!!!!!!!!!!")
            ; end if
            odata(il,kt) = (height_rec(il+1)-height_rec(il))/2.0+height_rec(il)
            delete(ivar)
          end do ; end loop of il
          kt = kt + 2
          delete(datatmp)
          delete(height_rec)
          flat_other = 0
        end if   ; end if "height"
          
        if (specname(ispec) .eq. "uvmet") then
          datatmp = wrf_user_getvar(nc_file,specname(ispec),it)
          do il = 0,(TL-1)
            ivar_u = datatmp(0,il,:,:)
            ivar_v = datatmp(1,il,:,:)
            odata(il,kt) = linint2_points (NI,NJ,ivar_u,True,loc(0),loc(1),0)
            odata(il,(kt+1)) = linint2_points (NI,NJ,ivar_v,True,loc(0),loc(1),0)
            delete(ivar_u)
            delete(ivar_v)
          end do ; end loop of il
          kt = kt + 2
          delete(datatmp)
          flat_other = 0
        end if  ; end if "uvmet"

        if (specname(ispec) .eq. "slp") then
          datatmp = wrf_user_getvar(nc_file,specname(ispec),it)
          ; printVarSummary(datatmp)
          odata(:,kt) = linint2_points (NI,NJ,datatmp,True,loc(0),loc(1),0)
          kt = kt + 1
          delete(datatmp)
          flat_other = 0
        end if ; end if "slp"

        if (flat_other .eq. 1) then
          if (flag_chem(ispec) .eq. 1) .or. (isfilevar(nc_file,specname(ispec))) then
            datatmp = wrf_user_getvar(nc_file,specname(ispec),it)
          else
            datatmp = wrf_user_getvar(nc_file,refspec,it)
          end if
          ; printVarSummary(datatmp)
          do il = 0,(TL-1)
            ivar = datatmp(il,:,:)
            odata(il,kt) = linint2_points (NI,NJ,ivar,True,loc(0),loc(1),0)
            delete(ivar)
          end do ; end loop of il
          kt = kt + 1
          delete(datatmp)
        end if  ; end if others

      end do ; end loop of ispec
      delete(kt)

      ; save output data
      ; ofmt = ofmt_s
      ; do ii = 1,(output_specnum-1)
      ;  ofmt = str_concat((/ofmt,",2x",",",ofmt_s/))  ; here the inner bracket () is important, otherwise syntax error...
      ; end do;  end loop of ii
      ; delete(ii)
      ofmt = output_specnum + ofmt_s
      ; print("Output format = " + ofmt)
     
      opt_of = True
      tmp = yfc_jul2greg_to_str(jul2greg(jultimes(it)))
      opt_of@fout = opath + oname_data + sid + "_" + tmp(0) + tmp(1) + tmp(2) + tmp(3)  +oname_e  ; give the output file name
      delete(tmp)
      opt_of@title = hl_odata ; give the title line in the output file
      write_matrix (odata, ofmt, opt_of)

      delete(odata)
      delete(ofmt)
      delete(opt_of)

    end do   ; end loop it

    delete(nc_file)
    delete(jultimes)

    end do ; end loop ifile
    delete(ifile)

  else
    octl(istation,ncol_sid) = 0
    print("The current staion " + sid + " is not in the domain" + domid + "!!")
  end if  ; end if the location is within the domain

end do ; end loop over stations

; save control file
ofmt = (ncol_sid+1) + ofmt_s

opt_of = True
opt_of@fout = opath + oname_ctl + oname_e  ; give the output file name
opt_of@title = hl_ctl ; give the title line in the output file
write_matrix (octl, ofmt, opt_of)

delete(ofmt)
delete(opt_of)
delete(octl)  

;========================================================================

end  ; end the NCL script
