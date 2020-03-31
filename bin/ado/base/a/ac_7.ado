*! version 1.2.8  09feb2015
program define ac_7
/*
   -ac- requires

   1.  N >= 2,

   2.  lags() <= N - 1.

   If lags() not specified, by default lags() = max(1, min(int(N/2) - 2, 40)).

   This default was chosen because -pac- requires lags() <= int(N/2) - 2.
*/
	version 6, missing
	if _caller()<6 {
		capture which bl_ac
		if _rc {
			di in red "You have set version " _caller()
			di in red "ac was not a command of Stata " _caller()
			exit 199
		}
		bl_ac `0'
		exit
	}

	syntax varname(ts) [if] [in] /*
	*/ [, LAGs(int -999) GENerate(string) Level(int $S_level) /*
	*/ B1title(string) B2title(string) YLIne(string) /*
	*/ XLAbel(string) YLAbel(string) RLAbel(string) /*
	*/ Symbol(string) Connect(string) Pen(string) /*
	*/ L1title(string) T1title(string) FFT NEEDLE noGRAPH *]

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

	quietly {
		tempvar xm tmp ac pse
		tempname R0

		summarize `varlist' if `touse'
		scalar `R0' = r(Var)*(r(N)-1)
		local n = r(N)
		if `n' == 0 { error 2000 }
		if `n' == 1 { error 2001 }

		if `lags' == -999 {
			local lags = max(1,min(int(`n'/2)-2,40))
		}
		else if `lags' >= `n' {
			di in red "lags() too large; must be less than " `n'
			exit 498
		}
		else if `lags' <= 0 {
			di in red "lags() must be greater than zero"
			exit 498
		}

		gen double `xm' = `varlist'-r(mean) if `touse'
					/* done with r() from summarize */

		tsreport if `touse' & `varlist'<.

		if r(N_gaps) > 0 {
			if r(N_gaps) > 1 {
				noi di in blu "(note: time series has " /*
				*/ r(N_gaps) " gaps)"
			}
			else	noi di in blu "(note: time series has 1 gap)"
		}

		if "`fft'"!="" {
			preserve
			keep if `touse'
			local new = _N + `lags'
			local op1 = _N + 1
			set obs `new'
			replace `xm' = 0 in `op1'/l
			replace `tvar' = /*
			*/ `tvar'[_n-1] + `_dta[_TSitrvl]' in `op1'/l
			sort `tvar'

			tempvar zr zi fhat
			cap noi fft `xm', gen(`zr' `zi')
			if _rc {
				if _rc==1 { error 1 }
				di in red "with the fft option specified"
				exit _rc
			}
			gen double `fhat' = (`zr'^2+`zi'^2)/`n'
			drop `zr' `zi'
			fft `fhat', gen(`zr' `zi')
			replace `zr' = `zr'*(`n'+`lags')/`n'
			gen double `ac' = `zr'/`zr'[1]
			replace `ac' = `ac'[_n+1]
			replace `ac' = . if _n > `lags'
			gen double `tmp' = sum(`ac'^2)
			gen double `pse' =  sqrt((1 /*
			*/ + cond(_n>1,2*`tmp'[_n-1],0))/`n')
			drop in `op1'/l
		}
		else {
			gen double `tmp' = . in 1
			gen double `ac'  = . in 1
			gen double `pse' = 1/sqrt(`n') in 1
			local i 1
			while `i' <= `lags' {
				replace `tmp' = `xm'*L`i'.`xm'
				summarize `tmp', meanonly
				replace `ac' = r(sum)/`R0' in `i'

				if `i' > 1 {
					local im1 = `i' - 1
					replace `tmp' = `ac'^2 in 1/`im1'
					summarize `tmp' in 1/`im1', meanonly
					replace `pse' = /*
					*/ sqrt((1+2*r(sum))/`n') in `i'
				}
				local i = `i' + 1
			}
		}
	}

	if "`graph'"=="" { /* produce graph */
		quietly {
			tempvar obs mse
			tempname zz
			gen `c(obs_t)' `obs' = _n in 1/`lags'
			scalar `zz' = invnorm((100+`level')/200)
			replace `pse' = `zz'*`pse' in 1/`lags'
			gen double `mse' = -`pse' in 1/`lags'
		}

		format `ac' `pse' `mse' %-5.2f

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
			local b1title "Correlogram"
		}
		if `"`b2title'"'=="" {
			local b2title "Lag"
		}
		if `"`l1title'"'=="" {
			local l1title "Autocorrelations of `varlist'"
		}
		if `"`t1title'"'=="" {
			local t1title /*
		*/ "Bartlett's formula for MA(q) `level'% confidence bands"
		}
                if `"`symbol'"'=="" {
			if "`needle'"!="" {
				local sym "s(oii..)"
			}
			else	local sym "s(o..)"
                }
                else	local sym `"s(`symbol')"'

                if `"`connect'"'=="" {
			if "`needle'"!="" {
				local con "c(.||ll)"
			}
			else	local con "c(lll)"
                }
                else	local con `"c(`connect')"'

                if `"`pen'"'=="" {
			if "`needle'"!="" {
				local pen "pen(22211)"
			}
			else	local pen "pen(211)"
                }
                else	local pen `"pen(`pen')"'

                if `"`yline'"'=="" {
                        local yline "yline(0)"
                }
                else	local yline `"yline(`yline')"'

		if "`needle'"!="" {
			tempvar zero
			qui gen byte `zero' = 0 in 1/`lags'
			local args `ac' `ac' `zero' `pse' `mse'
		}
		else	local args `ac' `pse' `mse'

		gr7 `args' `obs' in 1/`lags', /*
		*/ b1title(`"`b1title'"') b2title(`"`b2title'"') /*
		*/ l1title(`"`l1title'"') t1title(`"`t1title'"') /*
		*/ `ylab' `xlab' `rlab' `sym' `con' `pen' `yline' /*
		*/ `options'
	}

	if "`generate'"!="" {
		rename `ac' `generate'
		format `generate' %10.0g
		label var `generate' "Autocorrelations of `varlist'"

		if "`fft'"!="" {
			quietly {
				keep `generate'
				tempfile ttt
				save `"`ttt'"'
				restore
				merge using `"`ttt'"'
				drop _merge
				tsset `tvar'
			}
		}
	}
end




