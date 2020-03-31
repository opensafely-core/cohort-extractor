*! version 5.1.3  11jan2013
program xtmixed, eclass byable(onecall) prop(xt mi)
	global XTM_ver = _caller()
	global ME_QR = 0
	version 9
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if replay() {
		if "`e(cmd)'" != "xtmixed" {
			error 301
		}
		if _by() {
			error 190
		}
		_xtmixed_display `0'
		exit
	}

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	capture noisily `vv' `by' _xtmixed_estimate `0'
	local rc = _rc
	ereturn local cmdline `"xtmixed `0'"'
	capture mata: _xtm_cleanup()
	capture mac drop XTM_*
	capture mac drop ME_QR
	exit `rc'
end

