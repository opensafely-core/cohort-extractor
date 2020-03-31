*! version  1.1.8  23sep2004
program define pergram_7
	version 6.0, missing
	syntax varname(ts) [if] [in] [, GENerate(string) /*
                */ L2title(string) T1title(string) YLIne(string) /*
                */ T2title(string) /*
                */ XLAbel(string) YLAbel(string) RLAbel(string) /*
                */ Symbol(string) Connect(string) Pen(string) /*
                */ noGRAPH *]

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

		local intval = `_dta[_TSitrvl]'
		tempvar chk
		gen `chk' = `tvar' - `tvar'[_n-1]
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

		capture local vlab : var label `varlist'
		if `"`vlab'"' == "" {
			local vlab "`varlist'"
		}


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

                if "`xlabel'" == "" {
                        local xlab "xlabel(0,.1,.2,.3,.4,.5)"
                }
                else {
                        local xlab "xlabel(`xlabel')"
                }
                if "`ylabel'" == "" {
                        local ylab "ylabel(-6,-4,-2,0,2,4,6)"
                }
                else {
                        local ylab "ylabel(`ylabel')"
                }
                if "`rlabel'" == "" {
                        local rlab "rlabel(-6,-4,-2,0,2,4,6)"
                }
                else {
                        local rlab "rlabel(`rlabel')"
                }
                if `"`t1title'`t2title'"' == "" {
                        local t1title "Sample spectral density function"
                        local t2title "evaluated at the natural frequencies"
                }
                if `"`l2title'"' == "" {
                        local l2title "Log Periodogram"
                }
                if "`symbol'" == "" {
                        local sym "s(o)"
                }
                else {
                        local sym "s(`symbol')"
                }
                if "`connect'" == "" {
                        local con "c(l)"
                }
                else {
                        local con "c(`connect')"
                }
                if "`yline'" == "" {
                        *local yline "yline(0)"
                }
                else {
                        local yline "yline(`yline')"
                }
		label var `pg' "`vlab'"
		label var `omega' "Frequency"
	}

	if "`graph'" == "" {
		gr `pg' `omega' if `omega' <= .50 & `touse', /*
			*/ t1title("`t1title'") /*
			*/ t2title("`t2title'") /*
			*/ l2title("`l2title'") /*
			*/ `ylab' `xlab' `rlab' `sym' `con' `yline' /*
			*/ `options'
	}

	if "`generate'" != "" {
		format `orig' %10.0g
		label var `orig' "Log periodogram for `varlist'"
		rename `orig' `generate'
	}
end
