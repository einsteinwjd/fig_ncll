;********************************************************
; SCM: Single Column Model
; WRF SCM: time-eta cross section.
;********************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl" ; WRF_Times2Udunits_c   
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"

begin
   ncol = 11
   
   data = readAsciiTable("input/input_sounding_bj20130101_12Z.txt", ncol, "float", 0)
   data3 = readAsciiTable("input/input_sounding_bj20130109_12Z.txt", ncol, "float", 0)

   
   printVarSummary(data)
;   ndim = dimsizes(data)
;   print(ndim)
;   print(data(:,0))
   
   data2 = readAsciiTable("input/input_sounding_bj20130110_12Z.txt", ncol, "float", 0)
;   print(data2(:,0))
   
   alt1 = data(:,1)
   alt2 = data2(:,1)
   alt3 = data3(:,1)
   th1  = data(:,8)
   th2  = data2(:,8)
   th3  = data3(:,8)
   q1   = data(:,5)
   q2   = data2(:,5)
   q3   = data3(:,5)
   
;   th0110 =  int2p (alt2,th2,alt1,1)  ; 0101_th0110
;   q0110 =  int2p (alt2,q2,alt1,1)    ; 0101_q0110
;   th0101 =  int2p (alt1,th1,alt2,1)  ; 0110_th0101
;   q0101 =  int2p (alt1,q1,alt2,1)    ; 0110_q0101

;   th0110 =  int2p (alt2,th2,alt3,1)  ; 0109_th0110
;   q0110 =  int2p (alt2,q2,alt3,1)    ; 0119_q0110
   th0101 =  int2p (alt1,th1,alt3,1)  ; 0109_th0101
   q0101 =  int2p (alt1,q1,alt3,1)    ; 0109_q0101
   
;   print(alt2)
;   data(:,8) = th0110
;   data(:,5) = q0110
;   write_matrix (data, "11f9.2", False)  ; 0101_*

;   data2(:,8) = th0101
;   data2(:,5) = q0101
;   write_matrix (data2, "11f9.2", False)  ; 0110_*

;   data3(:,5) = q0110
   data3(:,5) = q0101
   write_matrix (data3, "11f9.2", False)  ; 0109_*

end
