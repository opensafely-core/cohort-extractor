*! version  1.3.2  01dec2006
program define pergram
	version 6.0, missing
	if _caller() < 8 {
		pergram_7 `0'
		exit
	}

	syntax varname(ts) [if] [in] [, GENerate(string) noGRAPH *]

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	marksample touse

	_ts tvar panelvar `if' `in', sort onepanel
	markout `touse' `tvar'

	if "`generate'" != "" {
		capture gen byte `generate' = 0
		if _rc {
			di in red "generate() should name one new variable"
			exit 198
		}
		capture drop `generate'
	}

quietly {
	tempvar  pg xr xi omega xm chk newv
	tempname R0

	gen double `newv' = `varlist'

	tempname intval
	if "`: char _dta[_TSdelta]'" != "" {
		scalar `intval' = `: char _dta[_TSdelta]'
	}
	else {
		scalar `intval' = 1
	}
	tempvar chk
	gen double `chk' = `tvar' - `tvar'[_n-1]
	replace `chk' = `intval' in 1
	replace `chk' = . if `touse'==0
	count if `chk' != `intval' & `touse'
	if r(N) {
		noi di in red "time series may not have gaps"
		exit 198
	}
	drop `chk'
	

	summ `newv' if `touse'
	gen double `xm' = `newv'-r(mean) if `touse'
	scalar `R0' = r(Var)*(r(N)-1)
	local n = r(N)


	fft `xm' if `touse', gen(`xr' `xi')
	gen double `pg' = log( (`xr'^2+`xi'^2)/(`R0') ) if `touse'
	if "`generate'" != "" {
		tempvar orig
		gen double `orig' = `xr'^2 + `xi'^2 if `touse'
	}
	replace `pg' = -6 if `pg' < -6 & `touse'
	replace `pg' =  6 if `pg' >  6 & `touse'
	gen double `omega' = (sum(1)-1)/`n' if `touse'

	format `pg' `omega' %-5.2f

	local ttl "Sample spectral density function"
	local note "Evaluated at the natural frequencies"
	local yttl "Log Periodogram"
	capture local vlab : var label `varlist'
	if "`vlab'" == "" {
		local vlab "`varlist'"
		local yttl "`yttl' of `vlab'"
	}
	else {
		local yttl `"`"`vlab'"' `"`yttl'"'"'
	}
	label var `pg' "`vlab'"
	label var `omega' "Frequency"

} // quietly

	if "`graph'" == "" {
		version 8: graph twoway			///
		(connected `pg' `omega'			///
			if `touse' & `omega' <= .5,	///
			yaxis(1 2)			///
			ylabels(-6(2)6, axis(1))	///
			ylabels(-6(2)6, axis(2))	///
			ytitle(`yttl')			///
			ytitle(`""', axis(2))		///
			xlabels(0(.1).5)		///
			title(`"`ttl'"')		///
			note(`"`note'"')		///
			legend(nodraw)			/// no legend
			`options'			///
		)					///
		|| `plot' || `addplot'			///
		// blank
	}

	if "`generate'" != "" {
		format `orig' %10.0g
		label var `orig' "Log periodogram for `varlist'"
		rename `orig' `generate'
	}
end
