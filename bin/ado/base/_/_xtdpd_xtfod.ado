*! version 1.0.2  13feb2007
program define _xtdpd_xtfod, sortpreserve

	version 10.0

	syntax varlist(ts numeric) , 		///
		Nvarlist(namelist)		///
		touse(varname)			///
		touse2(varname)			///
		ivar(varname)			///
		tvar(varname)

	local ovarlist `varlist'

	tempvar ivar2 ct svar svart svar2 

	
	local n1 : word count `ovarlist'
	local n2 : word count `nvarlist'
	if `n1' != `n2' {
		di as err "number of new variable names is not "   ///
			"equal to the number of original variables"
		exit 498
	}

	forvalues i = 1/`n1' {
		tempvar work`i'
		local wlist `wlist' `work`i''
		local ov : word `i' of `ovarlist'
		local nv : word `i' of `nvarlist'
		confirm new variable `nv'
//		qui gen double `nv' = `ov' if `touse'
		qui gen double `nv' = `ov' if `touse2'
	}
	local varlist `nvarlist'

//	qui gen `ivar2' = 10*`ivar' + `touse'
	qui gen `ivar2' = 10*`ivar' + `touse2'

	sort `ivar2' `tvar'

	qui by `ivar2': gen double `ct' = sqrt((_N-_n)/(_N-_n+1))

	local i 1
	foreach v of local varlist {
		capture drop `svar' 
		capture drop `svar2' 
		capture drop `svart' 
		qui by `ivar2' : gen double `svar' = sum(`v') 
		qui by `ivar2' : replace `svar' = `svar'[_N]
		qui by `ivar2' : gen double `svart' = sum(`v') if _n < _N
		qui gen double `svar2' = `svar' - `svart'

		qui by `ivar2' : gen double `work`i'' = 		///
			`ct'*(`v'- `svar2'/(_N-_n)) if _n < _N

		qui by `ivar2' : replace `work`i'' = . if _n == _N
		local ++i
	}	
	sort `ivar' `tvar'
	local i 1
	foreach v of local varlist {
		qui by `ivar' : replace `v' = L.`work`i'' if _n>1
		qui replace `v' = . if !`touse'
		local ++i
	}	


end
