*! version 1.1.9  17mar2005
program define bstat_7, rclass
	version 6.0, missing
	local varlist `"opt ex"'
	local if `"opt"'
	local in `"opt"'
	local options `"Stat(string) Level(cilevel) TItle(str)"'
	parse

/* Check stuff if stat() specified. */

	tempname sobs

	if `"`stat'"'!="" { /* redo parse: one variable required with stat() */
		local varlist `"req ex max(1)"'
		local if `"opt"'
		local in `"opt"'
		local options `"Stat(string) Level(cilevel) TItle(str)"'
		parse
		capture scalar `sobs' = `stat'
		if _rc {
			di in red `"stat() invalid"'
			exit 198
		}
	}

/* Mark/markout. */

	tempvar touse
	mark `touse' `if' `in'

/* Print header. */

	if `"`title'"' == "" {
		local title "Bootstrap statistics"
	}	
	local spaces
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local spaces ""
	if `cil' == 2 {
		local spaces "   "
	}
	else if `cil' == 4 {
		local spaces " "
	}
	di _n in smcl in gr `"`title'"' _n(2) /*
	*/ `"Variable {c |}   Reps   Observed       Bias   Std. Err."' /*
	*/ `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'

/* If stat(), do the one variable then exit. */

	if `"`stat'"'!="" {
		OneBstat `touse' `varlist' `sobs' `level'
	}
	else { /* Step through varlist and get stat from char. */

		parse `"`varlist'"', parse(" ")

		local i 1
		while `"``i''"'!="" {
			local stat : char ``i''[bstrap]
			capture scalar `sobs' = `stat'
			if _rc {
				di in red `"estimates of observed "' /*
				*/ `"statistic for ``i'' not found"'
				exit 111
			}
			OneBstat `touse' ``i'' `sobs' `level'
			local i = `i' + 1
		}
	}
	return add

/* Print footer. */

	di in smcl in gr "{hline 9}{c BT}{hline 67}"
	di in gr _col(31) `"N = normal, P = percentile, BC = bias-corrected"'
end

program define OneBstat, rclass
	args touse x sobs level

	tempname sd z1 z2

/* Summarize `x'. */

	quietly {
		qui summarize `x' if `touse'
		local n = r(N)

		local bias = r(mean) - `sobs'
		scalar `sd' = sqrt(r(Var))

/* Compute bias-corrected percentiles. */

		local eps = 1e-7*max(`sd',abs(`sobs'))

		count if `x'<=`sobs'+`eps' & `touse'

		if r(N) > 0 & r(N) < `n' {
			scalar `z1' = invnorm(r(N)/`n')
			scalar `z2' = invnorm((100 + `level')/200)

			local p1 = 100*normprob(2*`z1' - `z2')
			local p2 = 100*normprob(2*`z1' + `z2')

			capture _pctile `x' if `touse', p(`p1', `p2')
			if _rc {
				local bc1 `"."'
				local bc2 `"."'
			}
			else {
				local bc1 = r(r1)
				local bc2 = r(r2)
			}
		}
		else {
			local bc1 `"."'
			local bc2 `"."'
		}

/* Compute percentiles. */

		local p1 = (100 - `level')/2
		local p2 = (100 + `level')/2

		_pctile `x' if `touse', p(`p1', `p2')

		local p1 = r(r1)
		local p2 = r(r2)

/* Compute normal CI. */

		scalar `z1' = invt(`n'-1, `level'/100)
		local n1 = `sobs' - `z1'*`sd'
		local n2 = `sobs' + `z1'*`sd'
	}

/* Save results. */

	ret scalar ub_bc = `bc2'
	ret scalar lb_bc = `bc1'
	ret scalar ub_p = `p2'
	ret scalar lb_p = `p1'
	ret scalar ub_n = `n2'
	ret scalar lb_n = `n1'
	ret scalar se = `sd'
	ret scalar bias = `bias'
	ret scalar stat = `sobs'
	ret scalar reps = `n'
	global S_1 `return(reps)'
	global S_2 `return(stat)'
	global S_3 `return(bias)'
	global S_4 `return(se)'
	global S_5 `return(lb_n)'
	global S_6 `return(ub_n)'
	global S_7 `return(lb_p)'
	global S_8 `return(ub_p)'
	global S_9 `return(lb_bc)'
	global S_10 `return(ub_bc)'

/* Print results. */

	local c = 9 - length(`"`x'"')

	di in smcl in gr "{hline 9}{c +}{hline 67}"
	di in smcl in gr _col(`c') `"`x'"' " {c |}" in ye %7.0g `n' _s(2) /*
	*/ %9.0g `sobs' _s(2) %9.0g `bias' _s(2) %9.0g `sd' _s(3) /*
	*/ %9.0g `n1'  _s(1) %9.0g `n2'  in gr `"  (N)"'
	di in smcl in gr _col(10) `"{c |}"' in ye _col(54) %9.0g `p1'  _s(1) /*
	*/ %9.0g `p2'  in gr `"  (P)"'
	di in smcl in gr _col(10) `"{c |}"' in ye _col(54) %9.0g `bc1' _s(1) /*
	*/ %9.0g `bc2' in gr `" (BC)"'
end
