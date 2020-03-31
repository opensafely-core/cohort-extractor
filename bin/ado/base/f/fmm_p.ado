*! version 1.0.2  30jan2017
program fmm_p, eclass
	version 15
	local vv : di "version " string(_caller()) ", missing:"
	
	if "`e(cmd)'" != "fmm" & "`e(cmd2)'" != "fmm" {
		di "{err}last estimates not found"
		exit 198
	}
	
	syntax  anything(id="stub* or newvarlist") 	///
		[if] [in] [,				///
		DENsity					///
		MARGinal				///
		*					///
	]
	
	if "`density'" != "" & "`marginal'" != "" {
		marksample touse
		
		_stubstar2names `anything', nvars(1) singleok
		local typ `s(typlist)'
		local new `s(varlist)'
		
		tempname L P
		qui predict double `L'* if `touse', likelihood
		qui predict double `P'* if `touse', classpr
		
		qui gen `typ' `new' = 0 if `touse'
		local dep : word 1 of `e(depvar)'
		label var `new' "Predicted density (`dep')"
		
		local k = rowsof(e(gclevs))
		
		forvalues i = 1/`k' {
			qui replace `new' = `new' + `L'`i'*`P'`i' if `touse'
			drop `L'`i' `P'`i'
		}
		exit
	}
	
	`vv' gsem_p `0'
		
end
exit

