;; I have found several aligned Oz DWEL scans have incorrect zenith
;; angles. However for a plot usually one wavelength has correct zenith angle
;;while the other wavelength has incorrect ones. 
;; This is a simple script to replace the bad zenith angle data in one
;;wavelength ancillary data with the good ones in the other wavelength. 
;;
;; Zhan Li, zhanli86@bu.edu
;; Created: 2014/08/26
;; Last revision: 2014/08/26
;; 
;; INPUT:
;;   badancfile: the full file name of the ancillary data with bad zenith data
;;   goodancfile: the full file name of the ancillary data with good zenith data

pro dwel_rewrite_ancfile, badancfile, goodancfile

  compile_opt idl2
  envi, /restore_base_save_files
  envi_batch_init, /no_status_window

  ;; open the bad ancillary file
  envi_open_file, badancfile, r_fid=badancfid, /no_realize
  if badancfid eq 0 then begin
    print, 'Failed to open the file: '
    print, badancfile
    return
  endif 

  ;; read the band of waveform mean from the bad ancillary file. This is the
  ;; band we want to preserve in the corrected output file. 
  envi_file_query, badancfid, nb=nb_badanc, ns=ns_badanc, nl=nl_badanc, $
    data_type=type_badanc, dims=dims_badanc
  wfmax = envi_get_data(fid=badancfid, dims=dims_badanc, pos=5) ;; waveform max
  ;; is the band 5
  
  ;; open the good ancillary file
  envi_open_file, goodancfile, r_fid=goodancfid, /no_realize
  if goodancfid eq 0 then begin
    print, 'Failed to open the file: '
    print, goodancfile
    free_lun, badancfile
  endif 
  ;; read all bands other than waveform mean from the good ancillary file. Those
  ;;bands will replace those of the bad anc file
  envi_file_query, goodancfid, nb=nb_goodanc, ns=ns_goodanc, nl=nl_goodanc, $
    data_type=type_goodanc, dims=dims_goodanc
  if (nb_goodanc ne nb_badanc) or (ns_goodanc ne ns_badanc) or (nl_goodanc ne $
    nl_badanc) then begin
    print, 'Not match: the two input ancillary files!'
    free_lun, badancfile
    free_lun, goodancfile
    return
  endif 

  band1 = envi_get_data(fid=goodancfid, dims=dims_goodanc, pos=0)
  band2 = envi_get_data(fid=goodancfid, dims=dims_goodanc, pos=1)
  band3 = envi_get_data(fid=goodancfid, dims=dims_goodanc, pos=2)
  band4 = envi_get_data(fid=goodancfid, dims=dims_goodanc, pos=3)
  band5 = envi_get_data(fid=goodancfid, dims=dims_goodanc, pos=4)
  band7 = envi_get_data(fid=goodancfid, dims=dims_goodanc, pos=6)
  band8 = envi_get_data(fid=goodancfid, dims=dims_goodanc, pos=7)
  band9 = envi_get_data(fid=goodancfid, dims=dims_goodanc, pos=8)

  free_lun, badancfid
  openw, ofile, badancfile, /get_lun, error=text_err
  if text_err ne 0 then begin
    print, 'Failed to create the file: '
    print, badancfile
    free_lun, goodancfid
    return
  endif 

  writeu, ofile, band1
  writeu, ofile, band2
  writeu, ofile, band3
  writeu, ofile, band4
  writeu, ofile, band5
  writeu, ofile, wfmax
  writeu, ofile, band7
  writeu, ofile, band8
  writeu, ofile, band9

  free_lun, ofile

end 