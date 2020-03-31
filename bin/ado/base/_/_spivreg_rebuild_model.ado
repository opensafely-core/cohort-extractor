*! version 1.0.1  16mar2017
// this program is called only by spivreg_impact to rebuild the spreg gs2sls or
// spivreg model, it is the user's responsibility to remove the external mata
// objects specified in spreg, mlopt 
//
// Please use the following codes to remove the mata objects
//	capture mata : rmexternal("`spreg'")
//	capture mata : rmexternal("`mlopt'")
//	capture drop `spreg'*

program _spivreg_rebuild_model
	version 15.0
	syntax if , spreg(string)	///
		mlopt(string)		///
		touse(string)


	mark `touse' `if'
	
	local cmdline `e(cmdline)'	
	local cmd `e(cmd)' `e(estimator)'
	local model_spec : list cmdline - cmd

	_spivreg_parse `spreg' `mlopt', touse(`touse') : `model_spec'
end
