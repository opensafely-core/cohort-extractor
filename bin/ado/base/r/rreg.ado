*! version 3.5.0  12mar2018
*  Rewrite of program contributed by
*  Lawrence C. Hamilton, 1990, University of New Hampshire
*  Author of REGRESSION WITH GRAPHICS, Belmont, Calif.: Duxbury Press
program define rreg, eclass byable(recall) sort prop(mi)
	version 6, missing
	local options "Level(cilevel)"
	if replay() {
		if "`e(cmd)'"!="rreg" { error 301 }
		if _by() { error 190 }
		syntax [, `options' *]
		_get_diopts diopts, `options'
	}
	else {
		local vv : display "version " string(_caller()) ", missing:"
		local cmdline : copy local 0
		syntax varlist(fv ts) [if] [in] [, `options' /*
			*/ NOLOg LOg Graph TOlerance(real .01) TUne(real 7) /*
			*/ Genwt(string) ITerate(integer 1000) *]
		if "`s(fvops)'" == "true" | _caller() >= 11 {
			if _caller() < 11 {
				local vv "version 11: "
			}
			local fvexp "expand"
		}
		_get_diopts diopts, `options'
		if _by() {
			_byoptnotallowed genwt() `"`genwt'"'
		}
		if `toleran' <=0 {
			di in red "tolerance() must be positive"
			exit 198
		}
		if `iterate' <=0 {
			di in red "iterate() must be positive"
			exit 198
		}
		if `tune' <= 0 {
			di in red "tune() must be positive"
			exit 198
		}
		if "`genwt'" != "" {
			confirm new variable `genwt'
		}

		tokenize `varlist'
		local lhs "`1'"
		_fv_check_depvar `lhs'
		tsunab lhs : `lhs'
		mac shift
		local rhs "`*'"
		*estimates clear

		tempvar res absdev maxd weight y oldw touse
		tempname max scale aa lambda

		local tune = `tune'*4.685/7
		_parse_iterlog, `log' `nolog'
		local log "`s(nolog)'"
		local log = cond("`log'"=="", "noisily", "*")

		mark `touse' `if' `in'
		markout `touse' `lhs' `rhs'

		`vv' _rmcoll `rhs' if `touse', `fvexp'
quietly {

		`vv' ///
		_regress `lhs' `rhs' if `touse'
	/* Omit obs with Cook's D > 1. */ 	
		_predict double `weight' if `touse', cook
		replace `touse' = 0 if `weight' > 1 & `touse'
		replace `weight' = 1 if `touse'
		`vv' ///
		_regress `lhs' `rhs' if `touse'
		_predict double `res' if `touse', residual
		sum `res' if `touse', detail
		gen double `absdev' = abs(`res'-r(p50)) if `touse'
		gen double `maxd' = 1 if `touse'
		`log' di 

		local it 1
		scalar `max' = 1
		while `max' > 5*`toleran' & `it' <= `iterate' {
			capture drop `oldw'
			rename `weight' `oldw'
			sum `absdev' if `touse', detail
			gen double `weight' = cond( 		/*
			*/	abs(`res')>2*r(p50),     	/* 
			*/	2*r(p50)/abs(`res'), 1 ) 	/*
			*/	if `touse'
			`vv' ///
			_regress `lhs' `rhs' [aw=`weight'] if `touse'
			if "`graph'"!="" {
				version 8: graph twoway		///
				(scatter `weight' `oldw' `oldw'	///
					if `touse',		///
					sort			///
					msymbol(o i)		///
					connect(i l)		///
					ytitle("New weight")	///
					xtitle("Old weight")	///
					legend(nodraw)		///
				)
			}
			drop `res'
			_predict double `res' if `touse', residual
			sum `res' if `touse', detail
			replace `absdev'= abs(`res'-r(p50)) if `touse'
			replace `maxd'=abs(`weight'-`oldw') if `touse'
			sum `maxd' if `touse', meanonly
			scalar `max' = r(max)
			`log' di in gr "   Huber iteration `it':  " /*
				*/ "maximum difference in weights = " /*
				*/ in ye `max'
			local it = `it'+1
		}

		if `max' > 5*`toleran' {
			noi di in blu "Warning: Huber iterations" /*
			*/ " did not converge in `iterate' iterations"
		}

		scalar `max' = 1
		local notyet 1
		while (`max'>`toleran' & `it'<=`iterate') | `notyet' {
			local notyet 0
			capture drop `oldw'
			rename `weight' `oldw'
			sum `absdev' if `touse', detail
			scalar `scale' = r(p50)/.6745
			gen double `weight'= /*
			*/ max(1-(`res'/(`tune'*`scale'))^2,0)^2 /* 
			*/ if `touse'
			count if `weight' != 0 & `touse'
			if r(N) == 0 {
				di as err "all weights went to zero;"
				error 2000
			}
			`vv' ///
			_regress `lhs' `rhs' [aw=`weight'] if `touse'
			if "`graph'"!="" {
				version 8: graph twoway		///
				(scatter `weight' `oldw' `oldw'	///
					if `touse',		///
					sort			///
					msymbol(o i)		///
					connect(i l)		///
					ytitle("New weight")	///
					xtitle("Old weight")	///
					legend(nodraw)		///
				)
			}
			drop `res'
			_predict double `res' if `touse', residual
			sum `res' if `touse', detail
			replace `absdev' = abs(`res'-r(p50)) /*
				*/ if `touse'
			replace `maxd'=abs(`weight'-`oldw') if `touse'
			sum `maxd' if `touse', meanonly
			scalar `max' = r(max)
			`log' di in gr "Biweight iteration `it':  " /*
			*/ "maximum difference in weights = " /*
			*/ in ye `max'
			local it = `it'+1
		}

		if `max' > `toleran' {
			noi di in blu _n "Warning: Did not converge" /*
			*/ " in `iterate' iterations"
		}

		replace `absdev' = (1-(1/`tune'^2)* /*
			*/ (`res'/`scale')^2)*(1-(5/`tune'^2)* /* 
			*/ (`res'/`scale')^2) if `touse'
		replace `absdev' = 0 /*
			*/ if abs(`res'/`scale')>`tune' & `touse'
		sum `absdev' if `touse', meanonly
		scalar `aa' = r(mean)
		scalar `lambda' = 1+((e(df_m)+1)/e(N))* /*
			*/ (1-`aa')/`aa'
		drop `absdev' `maxd' `oldw'
		_predict double `y' if `touse'
		replace `y'= `y' + /* 
		*/ (`lambda'*`scale'/`aa')*(`res'/`scale')*`weight' /*
		*/ if `touse'
		`vv' ///
		_regress `y' `rhs' if `touse', dep(`lhs')
		if "`genwt'"!="" {
			rename `weight' `genwt'
			label var `genwt' "Robust Regression Weight"
		}
		est local ll
		est local ll_0
		est local genwt `genwt'
		est local estat_cmd ""		// reset to empty
		est repost, buildfvinfo
		est local predict "rreg_p"
		est local marginsok "XB default"
		est local title "Robust regression"
		version 10: ereturn local cmdline `"rreg `cmdline'"'
		est local cmd "rreg"
		_post_vce_rank
		global S_E_cmd "`e(cmd)'"	/* double save */

} // quietly

	}

	if "`e(prefix)'" == "" {
		#delimit ;
		di _n
			in gr "Robust regression"
			in gr _col(49) "Number of obs"
			      _col(67) "= " in ye %10.0fc e(N) _n
			in gr _col(49) "F(" %3.0f e(df_m) "," %10.0f e(df_r)    
					")"
			      _col(67) "= " in ye %10.2f e(F) _n
			in gr _col(49) "Prob > F"
			      _col(67) "= " in ye %10.4f
					fprob(e(df_m), e(df_r), e(F)) _n ; 
		#delimit cr
		local head noheader
	}
	regress, `head' level(`level') `diopts'
end
exit
