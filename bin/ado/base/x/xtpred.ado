*! version 1.3.0  18nov1998
program define xtpred
* touched by jwh 
	version 6.0
	if "`e(cmd)'" != "xtreg" { error 301 }

	if "`e(model)'"=="fe" {
		ffxpred `*'
	}
	else if "`e(model)'"=="re" {
		rfxpred `*'
	}
	else {
		di in red "last estimates not  xtreg, fe  or  xtreg, re"
		exit 301
	}
end


program define ffxpred
	version 4.0

	local varlist "req new max(1)"
	local options "All E Stdp U UE Xb Xbu"
	tempvar res
	parse "`*'"
	rename `varlist' `res'

	local nopt = ("`e'"!="") + ("`ue'"!="") + ("`stdp'"!="") /*
		*/ + ("`u'"!="") + ("`xb'"!="") +  ("`xbu'"!="") 

	if `nopt'>1 { error 198 } 
	if `nopt'==0 { local xb "xb" }

	tempvar XB U smpl STDP


	if "`e'"!="" {
		quietly {
			ffxpred double `XB', xb `all'
			ffxpred double `U', u `all'
		}
		label var `res' "e[`e(ivar)',t]"
		qui replace `res' = `e(depvar)' - `XB' - `U'
		rename `res' `varlist'
		exit
	}

	if "`ue'"!="" {
		quietly ffxpred double `XB', xb `all'
		label var `res' "u[`e(ivar)'] + e[`e(ivar)',t]"
		qui replace `res' = `e(depvar)' - `XB'
		rename `res' `varlist'
		exit
	}

	qui gen byte `smpl' = e(sample)
	if "`all'"=="" {
		local touse "`smpl'"
	}
	else	local touse 1

	if "`stdp'"!="" {
		qui _predict double `STDP' if `touse', stdp
		label var `res' "s.e. of prediction"
		qui replace `res' = `STDP'
		rename `res' `varlist'
		exit
	}

	if "`u'"!="" {
		sort `e(ivar)' `smpl' 
		quietly {
			_predict double `XB' if `smpl', xb 	/* sic */
			by `e(ivar)' `smpl': gen double `U' = /*
				*/ sum(`e(depvar)')/_n-sum(`XB')/_n if `smpl'
			by `e(ivar)' `smpl': replace `U' = `U'[_N] /* sic */
			label var `res' "u[`e(ivar)']"
			replace `res' = `U'
			rename `res' `varlist'
		}
		exit
	}
	if "`xb'"!="" {
		quietly _predict double `XB' if `touse', xb
		label var `res' "Xb"
		qui replace `res' = `XB'
		rename `res' `varlist'
		exit
	}
	if "`xbu'"!="" {
		quietly _predict double `XB' if `touse', xb
		quietly ffxpred double `U', u `all'
		label var `res' "Xb + u[`e(ivar)']"
		qui replace `res' = `XB' + `U'
		rename `res' `varlist'
		exit
	}
	di in red "ffxpred program bug"
	exit 9998
end


program define rfxpred
	version 4.0

	local varlist "req new max(1)"
	local options "All E Stdp U UE Xb Xbu"
	tempvar res
	parse "`*'"
	rename `varlist' `res'

	local nopt = ("`e'"!="") + ("`ue'"!="") + ("`stdp'"!="") /*
		*/ + ("`u'"!="") + ("`xb'"!="") +  ("`xbu'"!="") 

	if `nopt'>1 { error 198 } 
	if `nopt'==0 { local xb "xb" }

	tempvar XB U smpl STDP


	if "`e'"!="" {
		quietly {
			rfxpred double `XB', xb `all'
			rfxpred double `U', u `all'
		}
		label var `res' "e[`e(ivar)',t]"
		qui replace `res' = `e(depvar)' - `XB' - `U'
		rename `res' `varlist'
		exit
	}

	if "`ue'"!="" {
		quietly rfxpred double `XB', xb `all'
		label var `res' "u[`e(ivar)'] + e[`e(ivar)',t]"
		qui replace `res' = `e(depvar)' - `XB'
		rename `res' `varlist'
		exit
	}

	qui gen byte `smpl' = e(sample)
	if "`all'"=="" {
		local touse "`smpl'"
	}
	else	local touse 1

	if "`stdp'"!="" {
		qui _predict double `STDP' if `touse', stdp
		label var `res' "s.e. of prediction"
		qui replace `res' = `STDP'
		rename `res' `varlist'
		exit
	}

	if "`u'"!="" {
		qui _predict double `XB' if `smpl', xb		/* sic */
		sort `e(ivar)' `smpl'
		if e(Tcon)==0 {
			tempvar ratio
			qui by `e(ivar)' `smpl': gen double `ratio' = /*
			*/ scalar(e(sigma_u)^2/(_N*e(sigma_u)^2+e(sigma_e)^2)) if `smpl'
		}
		else {
			tempname ratio
			scalar `ratio' = /*
			*/ scalar(e(sigma_u)^2/(e(Tbar)*e(sigma_u)^2+e(sigma_e)^2))
		}
		quietly {
			by `e(ivar)': gen double `U' = /*
			*/ `ratio'*sum(`e(depvar)'-`XB') if `smpl'
			by `e(ivar)': replace `U' = `U'[_N] if `touse' /* sic */
			label var `res' "u[`e(ivar)']"
			replace `res' = `U'
			rename `res' `varlist'
		}
		exit
	}
	if "`xb'"!="" {
		quietly _predict double `XB' if `touse', xb
		label var `res' "Xb"
		qui replace `res' = `XB'
		rename `res' `varlist'
		exit
	}
	if "`xbu'"!="" {
		quietly _predict double `XB' if `touse', xb
		quietly rfxpred double `U', u `all'
		label var `res' "Xb + u[`e(ivar)']"
		qui replace `res' = `XB' + `U'
		rename `res' `varlist'
		exit
	}
	di in red "rfxpred program bug"
	exit 9998
end
