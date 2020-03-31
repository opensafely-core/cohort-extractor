*! version 3.0.10  29sep2004
program define lroc_7, rclass sortpreserve
	version 6.0, missing

	/* Parse and generate `touse', `p' (predicted probabilities),
	   and `w' (weights).
	*/
	tempvar touse p w spec sens
	lfit_p `touse' `p' `w' `0'
	local y `"`s(depvar)'"'	
	ret scalar N = `s(N)'
	global S_1 `"`return(N)'"'    /* double save */

	/* Parse other options. */
	local 0 `", `s(options)'"'
	sret clear
	syntax [, noGraph T2title(string) Symbol(string) Bands(string) /*
	*/ XLAbel(string) YLAbel(string) XLIne(string) YLIne(string) *]

	if `"`graph'"' == `""' { /* set gr7 defaults */
		if `"`symbol'"' == `""' { local symbol `"o"' }
		if `"`bands'"'  == `""' { local bands  `"10"' }
		if `"`xlabel'"' == `""' { local xlabel `"0,.25,.5,.75,1"' }
		if `"`ylabel'"' == `""' { local ylabel `"0,.25,.5,.75,1"' }
		if `"`xline'"'  == `""' { local xline  `".25,.5,.75"' }
		if `"`yline'"'  == `""' { local yline  `".25,.5,.75"' }
	}
	local old_N = _N
	capture {
		lsens_x `touse' `p' `w' `y' `sens' `spec' one

		/* Compute area under ROC curve. */
		replace `p' = sum((`spec'-`spec'[_n-1])*(`sens'+`sens'[_n-1]))
		
		return scalar area = `p'[_N]/2
		global S_2  `"`return(area)'"'    /* double save  */

		if `"`t2title'"' == `""' {
			local area : di %6.4f return(area)
			local t2title `"Area under ROC curve = `area'"'
		}

		#delimit ;
		if `"`graph'"' == `""' { ;
			replace `w' = cond(`spec'==0, 0,
				      cond(`spec'==1, 1, .)) ;
			format `sens' `w' `spec' %4.2f ;
			noi gr7 `sens' `w' `spec',
				c(ll) s(`symbol'i) border
				t2(`"`t2title'"') bands(`bands')
				xlabel(`xlabel') ylabel(`ylabel')
				xline(`xline') yline(`yline')
				`options' ;
		} ;
		noi di in gr _n 
			cond(`"`e(cmd)'"'=="probit","Probit","Logistic")
			`" model for `y'"' _n(2)
			`"number of observations = "' in yel %8.0f return(N) _n
			in gr `"area under ROC curve   = "' 
			in yel %8.4f return(area) ;
		#delimit cr
	}
	nobreak {
		local rc = _rc
		if _N > `old_N' {
			qui drop if `touse' >= .
		}
		if `rc' { error `rc' }
	}
end
