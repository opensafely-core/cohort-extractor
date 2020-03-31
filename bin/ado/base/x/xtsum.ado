*! version 1.1.2  21sep2010
program xtsum, rclass byable(recall) sort
	version 6, missing
	syntax [varlist(ts)] [if] [in] [, I(varname)]
	_xt, i(`i')
	local ivar `r(ivar)'
	local tvar `r(tvar)'

	tempname N n Tbar mean sdo min max sdb sdw minb maxb minw maxw
	tempvar touse tu bv wv Ti
	mark `touse' `if' `in'

	di in smcl in gr _n "Variable" _skip(9) "{c |}" _skip(6) /*
	*/ "Mean   Std. Dev.       Min        Max {c |}    Observations" /*
	*/ _n "{hline 17}{c +}{hline 44}{c +}{hline 16}"

	sort `ivar' `tvar'
	tokenize `varlist'
	while "`1'"!="" {
		quietly {
		cap confirm string variable `1'
		local bstr = !c(rc)
		if `bstr' {
			local bstr = 1
			scalar `N'     = 0
			scalar `n'     = 0
			scalar `Tbar'  = .
			scalar `mean'  = .
			scalar `sdo'   = .
			scalar `min'   = . 
			scalar `max'   = .
			scalar `sdb'  = .
			scalar `minb' = .
			scalar `maxb' = .
			scalar `sdw'  = .
			scalar `minw' = .
			scalar `maxw' = .
			local wrd "    T"
		}
		else {
			gen byte `tu' = `touse' & `1'<.
			summ `1' if `tu'
			scalar `N' = r(N)
			scalar `mean' = r(mean)
			scalar `sdo'  = cond(`N'>1,sqrt(r(Var)),.)
			scalar `min'  = r(min)
			scalar `max'  = r(max)
			by `ivar': gen double `Ti' = /*
				*/ cond(_n==_N,sum(cond(`tu',1,0)),.)
			by `ivar': gen double `bv'= cond(_n==_N, /*
				*/ sum(cond(`tu',`1',0)) / `Ti', . )
			summ `Ti' if `tu'
			* scalar `Tbar' = cond(r(mean)>=.,0,r(mean))
			if r(min)==r(max) {	/* min == max */
				local wrd "    T"
			}
			else	local wrd "T-bar"
			drop `Ti'
			by `ivar': gen double `wv' = /*
				*/ cond(`tu',`1'-`bv'[_N], .) /* + `mean' */
		}
		} /* quietly */
		#delimit ;
		di in smcl in gr /*
			*/ abbrev("`1'",8) _col(10) "overall {c |} " in ye 
			%9.0g `mean' "  "
			%9.0g `sdo' "  "
			%9.0g `min' "  "
			%9.0g `max' in gr " {c |}" 
			_col(69) "N =" %8.0f `N' ;
		#delimit cr
		if !`bstr' {
			qui summ `bv'
			scalar `n' = r(N)
			scalar `sdb' = cond(`n'>1,sqrt(r(Var)),.) 
			scalar `minb' = r(min) 
			scalar `maxb' = r(max)
		}
		#delimit ;
		di in smcl in gr _col(10) "between {c |}" _col(31) in ye
			%9.0g `sdb' "  "
			%9.0g `minb' "  "
			%9.0g `maxb' in gr " {c |}" 
			_col(69) "n =" %8.0f `n' ;
		#delimit cr
		if !`bstr' {
			qui summ `wv'
			scalar `sdw' = cond(r(N)>1,sqrt(r(Var)),.)
			scalar `minw' = r(min) + `mean'
			scalar `maxw' = r(max) + `mean'
			scalar `Tbar' = `N'/`n'
		}
		#delimit ;
		di in smcl in gr _col(10) "within  {c |}" _col(31) in ye
			%9.0g `sdw' "  "
			%9.0g `minw' "  "
			%9.0g `maxw' in gr 
			" {c |} `wrd' =" %8.0g `Tbar' ;
		#delimit cr
		if !`bstr' {
			drop `wv' `bv' `tu'
		}
		ret scalar N     = `N'
		ret scalar n     = `n'
		ret scalar Tbar  = `Tbar'
		ret scalar mean  = `mean'
		ret scalar sd    = `sdo'
		ret scalar min   = `min' 
		ret scalar max   = `max'
		ret scalar sd_b  = `sdb'
		ret scalar min_b = `minb'
		ret scalar max_b = `maxb'
		ret scalar sd_w  = `sdw'
		ret scalar min_w = `minw'
		ret scalar max_w = `maxw'

		* double saves
		scalar S_1 = `N'
		scalar S_2 = `n'
		scalar S_3 = `Tbar'
		scalar S_4 = `mean'
		scalar S_5 = `sdo'
		scalar S_6 = `min' 
		scalar S_7 = `max'
		scalar S_8 = `sdb'
		scalar S_9 = `minb'
		scalar S_10= `maxb'
		scalar S_11 = `sdw'
		scalar S_12 = `minw'
		scalar S_13 = `maxw'

		mac shift
		if "`1'"!="" {
			di in smcl in gr _col(18) "{c |}" _col(63) "{c |}"
		}
	}
end
exit
. sum cost avgcost dcost

Variable         |      Mean   Std. Dev.       Min        Max |    Observations
-----------------+--------------------------------------------+----------------
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
longlong overall | 123456789  123456789      3.154     191.56 |     N =12345678
longlong overall |  44.44588   46.30909      3.154     191.56 |     N =12345678
         between |             44.57574     4.4645    125.584 |     n =      22
         within  |             20.41346  123456789  912345678 | T-bar =       6
