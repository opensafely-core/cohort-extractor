*! version  1.3.0  01nov2017
program define pac_7
/*
   -pac- requires

   1.  N >= 6,

   2.  lags() <= int(N/2) - 2.

   If lags() not specified, by default lags() = min(int(N/2) - 2, 40).
*/
	version 6, missing
	if _caller()<6 {
		capture which bl_pac
		if _rc {
			di in red "You have set version " _caller()
			di in red "pac was not a command of Stata " _caller()
			exit 199
		}
		bl_pac `0'
		exit
	}

	syntax varname(ts) [if] [in] /*
	*/ [, LAGs(int -999) GENerate(string) Level(int $S_level) /*
	*/ B1title(string) B2title(string) YLIne(string) /*
	*/ XLAbel(string) YLAbel(string) RLAbel(string) /*
	*/ Symbol(string) Connect(string) Pen(string) /*
	*/ L1title(string) L2title(string) NEEDLE noGRAPH *]

        if `level' < 10 | `level' > 99 {
                di in red "level must be between 10 and 99"
                exit 198
        }
	if "`graph'"!="" {
		if `"`options'"'!="" {
			di in red `"`options' not allowed"'
			exit 198
		}
		if "`generate'"=="" {
			di in red "generate() must be specified with nograph"
			exit 198
		}
	}
	if "`generate'"!="" {
		local nword : word count `generate'
		if `nword' > 1 {
			di in red "generate() should name one new variable"
			exit 198
		}
		confirm new variable `generate'
	}

	marksample touse
	_ts tvar panelvar `if' `in', sort onepanel
	markout `touse' `tvar'

			/* hold the estimates from previous command,
			   otherwise they would be overwritten by -regress- */
        tempname ests
        cap estimates hold `ests', restore	/* -capture- since there may 
						   not be previous cmd */

	quietly {
		tempvar  xm pac svar
		tempname R0 se

		summarize `varlist' if `touse'

		local n = r(N)
		if `n' == 0 { error 2000 }
		if `n' < 6 {
			di in red "number of observations must be greater " /*
			*/ "than 5"
			exit 2001
		}

		if `lags' == -999 {
			local lags = min(int(`n'/2)-2,40)
		}
		else if `lags' > int(`n'/2)-2 {
			di in red "lags() too large; must be less than " /*
			*/ int(`n'/2)-2
			exit 498
		}
		else if `lags' <= 0 {
			di in red "lags() must be greater than zero"
			exit 498
		}
		if c(max_matdim) < `lags' + 3 {
			error 915
		}

		scalar `R0' = r(Var)*(`n'-1)
		gen double `xm' = `varlist'-r(mean) if `touse'
		gen double `pac' = . in 1
		gen double `svar' = . in 1

		tsreport if `touse' & `varlist'<.

		if r(N_gaps) > 0 {
			if r(N_gaps) > 1 {
				noi di in blu "(note: time series has " /*
				*/ r(N_gaps) " gaps)"
			}
			else	noi di in blu "(note: time series has 1 gap)"
		}

		local maxop 100
		local i 1
		while `i' <= `lags' {
			local k 1
			local args
			local diargs
			while (`k'-1)*`maxop'+1 <= `i' {
				local f = (`k'-1)*`maxop' + 1
				local e = min(`k'*`maxop',`i')
				local args `args' L(`f'/`e').`xm'
				local diargs `diargs' L(`f'/`e').`varlist'
				local k = `k' + 1
			}
			capture reg `xm' `args'
			if _rc!=2000 & _rc!=2001 {
				if _rc {
					if _rc==1 { error 1 }
					di in red "regression failed" _n /*
					*/ "failed command: regress " /*
					*/ "`varlist' `diargs'"
					error _rc
				}
				scalar `se' = .
				capture scalar `se' = _se[L`i'.`xm']
				if `se'!=0 & `se'<. {
					replace `pac' = _b[L`i'.`xm'] in `i'
					replace `svar' = /*
					*/ (e(N)-1)*e(rmse)^2/`R0' in `i'
				}
			}
			local i = `i' + 1
		}
	}

	if "`graph'"=="" { /* produce graph */
		tempvar obs tt
		qui gen `c(obs_t)' `obs' = _n  in 1/`lags'
		qui gen byte `tt' = . in 1
		label var `tt'   "`level'% conf. bands [se = 1/sqrt(n)]"
					/* `tt' is just for graph label */
		label var `pac'  "Partial autocorrelations"
		label var `svar' "Standardized variances"
		format `pac' `svar' %-5.2f

		if `"`xlabel'"'=="" {
			local xlab "xlab"
		}
		else	local xlab `"xlabel(`xlabel')"'

		if `"`ylabel'"'=="" {
			local ylab "ylabel(-1,-.75,-.50,-.25,0,.25,.50,.75,1)"
		}
		else	local ylab `"ylabel(`ylabel')"'

		if `"`rlabel'"'=="" {
			local rlab "rlabel(-1,-.75,-.50,-.25,0,.25,.50,.75,1)"
		}
		else	local rlab `"rlabel(`rlabel')"'

		if `"`b1title'"'=="" {
			local b1title "Partial Correlogram"
		}
		if `"`b2title'"'=="" {
			local b2title "Lag"
		}
		if `"`l1title'"'=="" {
			local l1title "Partial autocorrelations of `varlist'"
		}
		if `"`l2title'"'=="" {
			local l2title "and standardized residual variances"
		}
		if `"`symbol'"'== "" {
                        if "`needle'"!="" {
                                local sym "s(oiid.)"
                        }
                        else	local sym "s(od.)"
		}
		else	local sym `"s(`symbol')"'

		if `"`connect'"'=="" {
                        if "`needle'"!="" {
                                local con "c(.||.)"
                        }
                        else	local con "c(l.)"
		}
		else	local con `"c(`connect')"'

		if `"`pen'"'=="" {
                        if "`needle'"!="" {
                                local pen "pen(22231)"
                        }
                        else	local pen "pen(231)"
		}
		else	local pen `"pen(`pen')"'

		if `"`yline'"'== "" {
			local seline = invnorm((100+`level')/200)/sqrt(`n')
			local yline "yline(-`seline',0,`seline')"
		}
		else	local yline `"yline(`yline')"'

		if "`needle'" != "" {
			tempvar zero
			qui gen byte `zero' = 0 in 1/`lags'
			local args `pac' `pac' `zero' `svar' `tt'
		}
		else	local args `pac' `svar' `tt'

		gr7 `args' `obs' in 1/`lags', /*
		*/ b1title(`"`b1title'"') b2title(`"`b2title'"') /*
		*/ l1title(`"`l1title'"') l2title(`"`l2title'"') /*
		*/ `ylab' `xlab' `rlab' `sym' `con' `pen' `yline' /*
		*/ `options'
	}

	if "`generate'"!="" {
		rename `pac' `generate'
		format `generate' %10.0g
		label var `generate' "Partial autocorrelations of `varlist'"
	}
end




