*! version 1.3.3  30nov2011
program define _rmdcoll, rclass
	version 8, missing

	syntax varlist(fv ts) [in] [if] [fw iw aw pw]  [,	///
		NOCOLlin NORMCOLL COLLinear noConstant EXPand ]
	if "`s(fvops)'" == "true" | _caller() >= 11 {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local expand expand
	}
	else	local expand

	if "`nocollin'" != "" {
		local normcoll normcoll
	}

        tempvar touse
        mark `touse' [`weight'`exp'] `if' `in'

					/* weights */
	if "`weight'" ~= "" {
		tempvar w
		qui gen double `w'  `exp' if `touse'
		local wgt [`weight'=`w']
	}
	else 	local wgt

	gettoken yvar xvars: varlist
	if "`xvars'" == "" {
		exit
	} 

	tempname hldname c b
	if "`e(cmd)'" != "" {
		_est hold `hldname', restore
	}

					/* normcoll option */
	if "`normcoll'" == "" {
		`vv' ///
		_rmcoll `xvars' `wgt' if `touse', `constant' `collinear' ///
			`expand'
		local xvars "`r(varlist)'"
		local varlist "`yvar' `xvars'"
		return local varlist "`xvars'"
		if "`r(k_omitted)'" != "" {
			return scalar k_omitted = `r(k_omitted)'
		}
		if "`xvars'" == "" {
			exit
		} 
	}

				/* y xs of full rank? */ 
	`vv' ///
	qui _rmcoll `yvar' `xvars' `wgt' if `touse', ///
		`constant' `collinear' `expand'
	local result "`r(varlist)'"
	local equal : list varlist === result
	if `equal' {
		exit
	}
					/* select the largest abs value */

	`vv' ///
	qui reg `yvar' `xvars' `wgt' if `touse', `constant' 
	mat `b'= e(b)
	local i 1 
	local cmax abs(`b'[1,1])	
	scalar `c'=colsof(`b')
 	while `++i' < = `c' {
		if abs(`b'[1,`i']) > `cmax' {
			local cmax abs(`b'[1,`i'])
		}
	}

	if `cmax' == 0 {
		di as err "{p 0 4}"
		di as err "`yvar' is constant and zero"
		di as err "{p_end}"
 		exit 459	
	}

					/* get the varnames */

	local names: colnames `b'
	local i 0
	foreach name of local names {
		if  abs(`b'[1,`++i']) > `cmax' * 1e-5 {
			local cnames `cnames' `name'
		}
	}

					/* display error message , exit */
	di as err "{p 0 4}"
	di as err "`yvar' collinear with"
	di as err "`cnames'"
	di as err "{p_end}"
 	exit 459	
end
