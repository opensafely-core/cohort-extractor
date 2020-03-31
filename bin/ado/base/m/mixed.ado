*! version 1.0.4  16aug2018
program mixed, eclass byable(onecall) prop(xt mi bayes xtbs)
	version 13
	global XTM_ver = _caller()
	global ME_QR = 1
	local vv : di "version " string(_caller()) ":"
	
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if replay() {
		if "`e(cmd)'" != "mixed" {
			error 301
		}
		if _by() {
			error 190
		}
		_xtmixed_display `0'
		exit
	}
	capture noisily `vv' `by' _xtmixed_estimate `0'
	local rc = _rc
	if !`rc' {
		ereturn local cmdline `"mixed `0'"'
	}
	capture mata: _xtm_cleanup()
	capture mac drop XTM_*
	capture mac drop ME_QR
	exit `rc'
end

