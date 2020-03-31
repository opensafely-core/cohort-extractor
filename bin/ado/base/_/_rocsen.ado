*! version 7.0.2  09feb2015
program define _rocsen, rclass
	version 6.0

	/* Parse and generate `touse', `p' (predicted probabilities),
	   and `w' (weights) when some probabilities are equal.
	*/
	tempvar touse p w sens spec
	lfit_p `touse' `p' `w' `0'
	local y "`s(depvar)'"
	return scalar N = `s(N)'
	global S_1 `s(N)'
	/* Parse other options. */
	local 0 `", `s(options)'"'
	sret clear
	syntax [,GENSPec(string) GENSEns(string) /*
	*/ GENProb(string)  Class(string) ]

	tempvar C
	gen `C'=`class'
	
	/* FIX PROBABILITIES */
	tempvar order ptemp
	sort `C'
	qui by `C':gen `c(obs_t)' `order'=1 if _n==1
	qui replace `order'=sum(`order')
	qui gen `ptemp'=`p'+0.0000001*(`order'-1)
	sort  `ptemp'
	if `"`genspec'"' != `""' { confirm new variable `genspec' }
	if `"`gensens'"' != `""' { confirm new variable `gensens' }
	if `"`gensp'"'   != `""' { confirm new variable `genprob' }
	local old_N = _N
	nobreak {
		capture noisily break {
			lsens_x `touse' `ptemp' `w' `y' `sens' `spec'
		}
		local rc = _rc

		if _N > `old_N' /*
		*/ & (`rc' | `"`genspec'`gensens'`genprob'"'==`""') {
			qui drop if `touse' == .
		}
		if `rc' { exit `rc' }
	}
	if _N > `old_N' & `"`genspec'`gensens'`genprob'"'!=`""' {
		di in blu `"obs was `old_N', now "' _N
	}
	if `"`genprob'"' != `""' {
		qui gen float `genprob' =  ///
					cond(`spec'==.,.,cond(_n>1,`p'[_n-1],1))
		qui replace `genprob' = 0 if `ptemp' == 0
		label variable `genprob' `"Probability cutoff"'
		format `genprob' %9.6f
	}
	if `"`gensens'"' != `""' {
		rename `sens' `gensens'
		format `gensens' %9.6f
	}
	if `"`genspec'"' != `""' {
		rename `spec' `genspec'
		format `genspec' %9.6f
	}
end


