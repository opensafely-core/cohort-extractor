*! version 1.0.4  08oct2010
program twoway__lfit_serset

	// Creates a serset for a fit view.  Runs from an immediate log.

	syntax , SERSETNAME(string) X(string) Y(string) TOUSE(string)	///
		 [ PREDOPTS(string) REGOPTS(string) ATOBS(integer 0)	///
		 POINTS(integer 2) MIN(string) MAX(string)		///
		 XTRANS(string) MOREVARS(string) WEIGHT(string)		///
		 LEVEL(real `c(level)') STD(string) ]

	tempname esthold
	_estimates hold `esthold' , nullok restore
	
	local x_is_ts = ( strpos(`"`x'"', ".") > 0 )

	local x0 `x'
	if `"`xtrans'"' != `""' {
		tempvar regx
		VarTrans `x' `regx' `"`xtrans'"'
	}
	else if !`atobs' & `x_is_ts' {
		tempvar regx
		VarTS `regx' : `x'
		local x `regx'
	}
	else {
		local regx `x'
	}


	capture regress `y' `regx' [`weight'] if `touse' , `regopts'
	local rc = c(rc)
	if `rc' {
		di as txt "(note:  regress could not fit model)"
		if `rc' != 2000 {
			error `rc'
		}
		tempvar yhat
		quiet gen `yhat' = .
		local ylist `yhat'
		if "`std'" != "" {
			tempvar lcl ucl
			qui gen `lcl' = .
			qui gen `ucl' = .
			label variable `lcl' "`level'% CI"
			label variable `ucl' "`level'% CI"
			local ylist `ylist' `lcl' `ucl'

		}
		.`sersetname' = .serset.new `ylist' `x' `morevars'	///
			if `touse', `.omitmethod' `options' nocount
		if "`std'" != "" {
			.`sersetname'.sers[2].name = "lower_limit"
			.`sersetname'.sers[3].name = "upper_limit"
		}
		.`sersetname'.sort `x'
		.`sersetname'.sers[1].name = "`y'"
		exit
	}

	tempname touse2
	qui gen byte `touse2' = `touse' & e(sample)

	capture noisily nobreak {

		if ! `atobs' {
			tempvar holdx
			local realN `c(N)'
			preserve ,  changed
			_gs_x_create , points(`points') x(`x')		///
				       min(`"`min'"') max(`"`max'"')	///
				       holdx(`holdx') touse(`touse2')
			local touse2 _n <= `points'
			if `"`xtrans'"' != `""' {
				capture drop `regx'
				VarTrans `x' `regx' `"`xtrans'"'
			}
		}

		tempvar yhat
		qui predict `yhat' if `touse2' , `predopts'
		local ylist `yhat'

		if "`std'" != "" {
			tempvar se lcl ucl
			tempname tval
			scalar `tval' = invttail(e(df_r), ((100-`level')/200))
			qui predict `se' if `touse2' , `std'
			qui gen `lcl' = `yhat' - `tval' * `se' if `touse2'
			qui gen `ucl' = `yhat' + `tval' * `se' if `touse2'
			label variable `lcl' "`level'% CI"
			label variable `ucl' "`level'% CI"

			local ylist `ylist' `lcl' `ucl'
		}

		.`sersetname' = .serset.new `ylist' `x' `morevars'	///
			if `touse2', `.omitmethod' `options' nocount

		if "`std'" != "" {
			.`sersetname'.sers[2].name = "lower_limit"
			.`sersetname'.sers[3].name = "upper_limit"
		}

		if `x_is_ts' {					// TS operated X
			local normx : tsnorm `x0', varname
			local i = 2 + ("`std'" != "")*2
			.`sersetname'.sers[`i'].name = "`normx'"
		}

	}
	local rc = _rc

	if ! 0`atobs' {
		capture {
			if `realN' < c(N) {
				qui drop in `=`realN'+1'/l
			}
			qui drop `x' `ylist'
			rename `holdx' `x'
			restore
		}
		local rc = cond(`rc' , `rc' , _rc)
	}

	if `rc' {
		exit `rc'
	}

	.`sersetname'.sort `x'
	.`sersetname'.sers[1].name = "`y'"

end


program VarTrans
	args v vtmp trans

	local trans : subinstr local trans "X" "`v'" , all
	qui gen double `vtmp' = `trans'
end

program VarTS
	gettoken tvar  0 : 0
	gettoken colon x : 0

	qui gen double `tvar' = `x'

	fvunab xu : `x'
	gettoken ts var : xu , parse(.)
	gettoken unused var : var , parse(.)
	local vlab : variable label `var'
	if `"`macval(vlab)'"' != `""' {
		label variable `tvar' `"`macval(vlab)', `ts'"'
	}
	else {
		label variable `tvar' `"`ts'.`var'"'
	}
end

