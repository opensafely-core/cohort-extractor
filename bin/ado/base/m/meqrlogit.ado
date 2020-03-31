*! version 1.0.0  11jan2013
program meqrlogit, eclass byable(onecall) prop(or mi)
	
	if _caller() > 13 {
		global XTM_ver = _caller()
	}
	else 	global XTM_ver = 13
	
	global ME_QR = 1
	
	version 13

	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if replay() {
		if "`e(cmd)'" != "meqrlogit" {
			error 301
		}
		if _by() {
			error 190
		}
		_xtme_display `0'
		exit
	}

	capture noisily `by' _xtme_estimate "logistic" `0'
	local rc = _rc
	capture mata: _xtgm_cleanup_st()
	capture ml clear
	capture mac drop XTM_ver
	capture mac drop ME_QR
	if `rc' exit `rc'
	ereturn local cmdline `"meqrlogit `0'"'

end

