*! version 1.1.1  12mar2011
program factormat, eclass
	local vv : di "version " string(_caller()) ":"
	version 9

	if replay() {
		// replay using factor
		if "`e(cmd)'" != "factor" {
			dis as err "factor estimation result not found"
			exit 301
		}
		factor `0'
		exit
	}
	
	EstimateMatrix "`vv'" `0'
	ereturn local cmdline `"factormat `0'"'
end


program EstimateMatrix, eclass
	gettoken vv 0 : 0
	#del ;
	syntax  anything(name=Cin id="correlation or covariance matrix"),
		n(numlist max=1 integer >= 1)
	[
		CORrelation // undocumented, but allowed (default/only choice)
		COVariance  // undocumented; to display err msg
		SHape(passthru)
		NAMes(passthru)
		SDS(passthru)
		MEAns(passthru)

		FORCEPSD
		FORCE           // undocumented option
		TOL(passthru)   // undocumented
		*               // options for factor
	] ;
	#del cr

	// purpose of sds() and means() is to pass along the std dev and means
	// so that -predict- can use the information.  They do not affect
	// -factormat- directly.

	local opts `options'
	
	if "`covariance'" != "" {
		dis as err "factor analysis of a covariance matrix " ///
		           "is currently not supported"
		exit 198
	}
	
// get moment statistics

	_getcovcorr `Cin' , correlation `names' `shape'	`sds' `means' /// 
	    `force' check(psd) `forcepsd'  `tol' 

	if r(npos) < 2 { 
		dis as err "too few positive eigenvalues to continue" 
		exit 506
	}	
		
	tempname C
	matrix `C' = r(C)
	local names : colnames `C'
	local Ctype `r(Ctype)'
	if "`r(sds)'" == "matrix" {
		tempname sds
		matrix `sds' = r(sds)
	}
	if "`r(means)'" == "matrix" {
		tempname means
		matrix `means' = r(means)
	}

// create a dataset with pseudo-data (in unit variables)
		
	capture noisily {

		quietly {
			if `n' == c(N) {
				capture confirm new var `names'
				local addvar = _rc==0
			}
			if "`addvar'" != "1" {
				preserve
				drop _all
				quietly set obs `n'
				local clear clear
			}
			corr2data `names' , corr(`C') n(`n') /// 
			   double `clear'
		}
		
		// and use the variable-based factor command
		factor `names' , `opts' cmatname(`Cin') callver("`vv'")
	}
	
	nobreak {
		local rc = _rc
		if "`addvar'" == "1" {
			foreach v of local names {
				capture drop `v'
			}
		}
		if "`means'" != "" { 
			ereturn matrix means = `means' , copy
		}
		if "`sds'" != "" { 
			ereturn matrix sds = `sds' , copy
		}
		exit `rc'
	}
end
exit
