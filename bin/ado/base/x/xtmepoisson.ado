*! version 1.1.5  11jan2013
program xtmepoisson, eclass byable(onecall) prop(irr mi)
	global XTM_ver = _caller()
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	global ME_QR = 0
	version 10
	
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if replay() {
		if "`e(cmd)'" != "xtmepoisson" {
			error 301
		}
		if _by() {
			error 190
		}
		_xtme_display `0'
		exit
	}

	capture noisily `vv' `by' _xtme_estimate "poisson" `0'
	local rc = _rc
	capture mata: _xtgm_cleanup_st()
	capture ml clear
	capture mac drop XTM_ver
	capture mac drop ME_QR
	if `rc' exit `rc'
	ereturn local cmdline `"xtmepoisson `0'"'

end

