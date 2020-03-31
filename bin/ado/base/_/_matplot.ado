*! version 1.0.1  24feb2005

program _matplot
	version 9.0

	syntax anything(id=matrix name=M) 		///
	[,						///
		noNAMes					///
		COLumns(numlist integer min=2 max=2)	///
		MATRIX					///
		*					///
	]

	if "`columns'" != "" & "`matrix'" != "" {
		display as error	///
			"options columns() and matrix may not be combined"
		exit 198
	}

	tempname m
	matrix `m' = `M'
	local nr = rowsof(`m')
	local nc = colsof(`m')
	if `nc' < 2 {
		dis as err "matrix should have at least 2 columns"
		exit 198
	}

	if "`columns'" != "" {
		local i1 : word 1 of `columns' // y
		local i2 : word 2 of `columns' // x
		if !inrange(`i1',1,`nc') | !inrange(`i2',1,`nc')  {
			dis as err "columns() invalid; index out of range"
			exit 503
		}
		if `i1' == `i2' {
			dis as err "columns() invalid; distinct values expected"
			exit 198
		}
	}
	else {
		local i1 1 // y
		local i2 2 // x
	}

	local cnames : colnames `m'
	local ytitle  ytitle(`"`:word `i1' of `cnames''"')
	local xtitle  xtitle(`"`:word `i2' of `cnames''"')

	if "`matrix'" == "" {
		if `nr' > c(N) {
			preserve
			quiet set obs `nr'
		}
		tempvar labvar pos x y
		quiet gen `x' = `m'[_n,`i2']      in 1/`nr'
		quiet gen `y' = `m'[_n,`i1']      in 1/`nr'
		quietly count if missing(`y',`x') in 1/`nr'
		local nmiss = r(N)

		if `nmiss' == `nr' {
			dis as txt "(no points to plot)"
			exit 2000
		}
		else if `nmiss' > 0 {
			dis as txt "(`nmiss' points have missing coordinates)"
		}

		if "`names'" != "nonames" {
			// create labvar
			local rnames : rownames `m'
			if `"`: list dups rnames'"' != "" {
				dis as txt "(beware: point labels not unique)"
			}
			quiet gen `labvar' = ""
			forvalues i = 1 / `nr' {
				gettoken lab rnames : rnames
				quiet replace `labvar' = `"`lab'"' in `i'
			}
			
			// assemble option for scatter
			local mlabopts mlabel(`labvar')
		}

		twoway scatter `y' `x' , ///
		   `mlabopts' `xtitle' `ytitle' `options'
	}
	else {
		tempname cols
		local col_count = colsof(`m')
		preserve
		if `nr' > c(N) {
			quietly set obs `nr'
		}
		// generate real obs so that -svmat- is always happy
		tempvar b
		quietly gen byte `b' = .
		
		svmat `m', names(`cols')
		drop `b'
		
		local i = 0
		foreach item of local cnames {
			label variable `cols'`++i' "`item'"
		}

		if "`names'" != "nonames" {
			// create labvar
			tempvar labvar
			local rnames : rownames `m'
			if `"`: list dups rnames'"' != "" {
				dis as txt "(beware: point labels not unique)"
			}
			quiet gen `labvar' = ""
			forvalues i = 1 / `nr' {
				gettoken lab rnames : rnames
				quiet replace `labvar' = `"`lab'"' in `i'
			}

			// assemble option for scatter
			local mlabopts mlabel(`labvar')
		}

		graph matrix `cols'1 - `cols'`col_count', `mlabopts' `options'
	}
end
exit
