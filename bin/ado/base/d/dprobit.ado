*! version 3.3.0  28feb2015
program define dprobit, eclass byable(recall)
	version 6.0, missing
	// replication based -vce()- types are not allowed
	_vce_parserun dprobit, nojackknife noboot : `0'
	local options `"Level(cilevel) CLAssic AT(string) DEBUG(string)"'
	if !replay() {
		local cmdline : copy local 0
		syntax varlist(min=2) [if] [in] [fw pw aw] /*
			*/ [, `options' CLUster(varname) SCore(passthru) *]
		if _by() {
			_byoptnotallowed score() `"`score'"'
		}

		if ((_caller() > 9) & ("`weight'" == "aweight")) {
			/* Version 9.1 and later does not allow aweights */
			di as err "aweight not allowed"
			exit 101
		}

		marksample touse
		markout `touse' `cluster', strok

		tokenize `varlist'
		local lhs `"`1'"'

		if `"`at'"'!="" { 
			qui mat list `at'
		}

		local sweight = cond("`weight'"=="pweight","aweight","`weight'")


				/* 
					touse:  sample
					tosumm:  lhs mapped to 0/1
				*/
		tempvar tosumm
		tempname b x


		if "`cluster'" != "" { 
			local cluster "cluster(`cluster')"
		}

		probit `varlist' [`weight'`exp'] if `touse', /*
			*/ nocoef `cluster' `score' `options'
		if e(N)==0 | e(N)>=. { exit 2000 }

* e(ll), e(N), e(df_m), e(chi2), e(r2_p), etc. are obtained from -probit- call

		mat `b' = e(b)
		local varlist : colnames(`b')
		local i : word count `varlist'
		tokenize `varlist'
		if `"``i''"' != "_cons" { 
			di in red `"may not drop constant"'
			exit 399
		}
		local `i'
		local varlist `"`*'"'
		
					/* check if drops from sample	*/
		quietly replace `touse'=0 if !e(sample)

				/* obtain Xb evaluation at means, f(Xb) */
		quietly gen byte `tosumm'=`lhs'!=0 if `touse'
		quietly summ `tosumm' [`sweight'`exp'] if `touse'
		est scalar pbar = r(mean)
		matrix `x' = get(mns) * `b''
		est scalar xbar = `x'[1,1]
		if "`e(offset)'" != "" { 
			qui summ `e(offset)' if `touse'
			est scalar offbar = r(mean)
			est scalar xbar = e(xbar) + r(mean)
		}
		else	est scalar offbar = 0

				/* mark the dummies 			*/
		local i 1 
		while `"``i''"'!="" {
			capture assert ``i''==0 | ``i''==1 if `touse'
			if _rc==0 { est local dummy `"`e(dummy)' 1"' }
			else 	  { est local dummy `"`e(dummy)' 0"' }
			local i = `i' + 1
		}
		est local dummy `"`e(dummy)' 0"'
				
				/* save other info			*/
		est local wtype `"`weight'"'
		est local wexp `"`exp'"'


		/* double save in S_E_<stuff> and e()  */
		scalar S_E_pbar = e(pbar)
		scalar S_E_xbar = e(xbar)
		global S_E_dum `e(dummy)'
		global S_E_vl `"`lhs' `varlist'"'
		global S_E_if `"`if'"'
		global S_E_in `"`in'"'
		global S_E_wgt `e(wtype)'
		global S_E_exp `e(wexp)'
		global S_E_ll `e(ll)'
		global S_E_nobs `e(N)'
		global S_E_mdf `e(df_m)'

		version 10: ereturn local cmdline `"dprobit `cmdline'"'
		est local cmd "dprobit"
		global S_E_cmd "dprobit"
		/* see farther down for saving of e(at) and S_E_at  */
		/* also see e(dfdx) and e(se_dfdx) */
	}
	else {
		if `"`e(cmd)'"' != "dprobit" { error 301 } 
		if _by() { error 190 }
		syntax [, `options']
	}

	tempname mns b V Vhat v xb fxb c s ll ul z Z 

	scalar `Z' = invnorm(1-(1-`level'/100)/2)

	mat `b' = e(b)
	mat `V' = e(V)

	if `"`at'"'!="" { 
		if colsof(`b')==colsof(matrix(`at')) { 
			if `at'[1,colsof(`b')] != 1 { 
				di in red `"`at':  last (_cons) element not 1"'
				exit 598
			}
			mat `mns' = `at'
		}
		else if colsof(`b')-1 == colsof(matrix(`at')) { 
			mat `mns' = nullmat(`at'),1
		}
		else { 
			di in red `"`at':  conformability error"' 
			exit 503
		}
		local ttl `"    x"'
	}
	else {
		mat `mns' = get(mns) 
		local ttl `"x-bar"'
	}

	if `"`debug'"'!="" {
		capture matrix drop `debug'
		local debug `"Debug `debug'"'
	}
	else	local debug `"*"'

				/* begin replay logic		*/

	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.)
	di _n in gr `"Probit regression, reporting marginal effects"' /*
		*/ _col(57) `"Number of obs ="' /*
		*/ in ye %7.0f e(N)
	di in gr _col(57) `"`e(chi2type)' chi2("' in ye e(df_m) /*
		*/ in gr `")"' _col(71) /*
		*/ `"="' in ye %7.2f e(chi2)
	di in gr _col(57) `"Prob > chi2   ="' in ye /*
		*/ %7.4f chiprob(e(df_m),e(chi2))
	di in gr `"`crtype' = "' in ye %10.0g e(ll) /*
		*/ _col(57) in gr `"Pseudo R2"' _col(71) `"="' /*
		*/ in ye %7.4f e(r2_p) _n


	if inlist("`e(prefix)'","bootstrap","jackknife") {
		local msg1 "Replications based on"
		local msg2 "Replications based on"
	}
	else {
		local msg1 "Std. Err. adjusted for"
		local msg2 "Standard errors adjusted for"
	}
	if "`e(clustvar)'" != "" & !missing(e(N_clust)) {
		local nclust = string(e(N_clust), "%12.0fc")
		version 10: di as txt ///
"{ralign 78:(`msg1' {res:`nclust'} clusters in `e(clustvar)')}"
	}
	else if "`e(clustvar)'" != "" {
		version 10: di as txt ///
"{ralign 78:(`msg2' clustering on `e(clustvar)')}"
	}
	di in smcl in gr "{hline 9}{c TT}{hline 68}"

        if `"`e(vcetype)'"'!="" {
		di in smcl in gr _col(10) "{c |}" _col(26) `"`e(vcetype)'"'
	}

	if `"`classic'"'!="" {
		local cons `"_cons"'
	}
	_evlist
	tokenize `e(depvar)' `s(varlist)' `cons'
	sret clear

	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local spaces "    "
	local postspc "   "
	if `cil' == 4 {
		local spaces "   "
		local postspc "  "
	}
	else if `cil' == 5 {
		local spaces "  "
		local postspc "  "
	}	
	di in smcl in gr /*
		*/ %8s abbrev("`1'",8) " {c |}" _col(17) `"dF/dx"' _col(25) /*
		*/ `"Std. Err."' _col(40) `"z"' _col(45) `"P>|z|"' /*
		*/ _col(55) `"`ttl'"' /*
	*/ _col(62) `"[`spaces'`=strsubdp("`level'")'% C.I.`postspc']"' _n /*
		*/ "{hline 9}{c +}{hline 68}"

	Vhatdiag `mns' `b' `V' -> `Vhat'

	mat `xb' = `mns'*`b''
	scalar `xb' = `xb'[1,1] + e(offbar)
	scalar `fxb' = normd(`xb')

	local lhs `"`1'"'
	mac shift

	tempname dfdx se_dfdx
	local i 1
	while `"``i''"'!="" {
		local isdum : word `i' of `e(dummy)'
		if `isdum' & `"`classic'"'=="" {
			local anydum "true"
			local star `"*"'
			scalar `c' = /*
			*/ normprob(`xb'+(1-`mns'[1,`i'])*_b[``i'']) - /*
			*/ normprob(`xb'-(`mns'[1,`i'])*_b[``i'']) 
			vdummy `i' `mns' `b' `V' -> `v'
		}
		else {
			scalar `c' = _b[``i'']*`fxb'
			scalar `v' = `Vhat'[1,`i']
			local star `" "'
		}
		scalar `s' = sqrt(`v')
		scalar `ll' = `c'-`Z'*`s'
		scalar `ul' = `c'+`Z'*`s'
		scalar `z' = _b[``i'']/_se[``i'']

		di in smcl in gr %8s abbrev("``i''",8) /*
			*/ "`star'{c |}  " in ye /*
			*/ %9.0g `c' `"  "' /*
			*/ %9.0g `s' `" "' /*
			*/ %8.2f `z'  `"  "' /*
			*/ %6.3f 2*normprob(-abs(`z')) `"  "' /* 
			*/ %8.0g `mns'[1,`i'] `"  "' /*
			*/ %8.0g `ll' `" "' /*
			*/ %8.0g `ul'
		mat `dfdx' = nullmat(`dfdx') , `c'
		mat `se_dfdx' = nullmat(`se_dfdx') , `s'

		`debug' `c' `s' `z' `mns'[1,`i'] `ll' `ul'
		local i=`i'+1
	}
	if "`e(offset)'"!="" { 
		di in smcl in gr %8s "`e(offset)'" " {c |}   (offset)"
	}

	di in smcl in gr "{hline 9}{c +}{hline 68}" _n /*
		*/ `"  obs. P {c |}  "' in ye %9.0g e(pbar)
	di in smcl in gr `" pred. P {c |}  "' in ye %9.0g normprob(e(xbar)) /*
		*/ in gr `"  (at x-bar)"'
	if `"`at'"'!="" {
		est scalar at = normprob(`xb')
		scalar S_E_at = e(at)
		di in smcl in gr `" pred. P {c |}  "' in ye %9.0g /* 
		*/ e(at) in gr `"  (at x)"'
	}
	else	capture scalar drop S_E_at

	di in smcl in gr "{hline 9}{c BT}{hline 68}"
	if `"`anydum'"'==`"true"' {
		di in gr /*
		*/ `"(*) dF/dx"' /*
		*/ `" is for discrete change of dummy variable from 0 to 1"'
	}
	di in gr in smcl "{p 4 0 0}" ///
`"z and P>|z| correspond to the test of the underlying coefficient being 0"'

     _prefix_footnote

     tempname B
     matrix `B' = e(b)
     local names : colfullnames `B'
     if "`classic'" == "" {
             local names : subinstr local names "_cons" "", word
     }
     mat colnames `dfdx' = `names'
     mat colnames `se_dfdx' = `names'

     est mat dfdx `dfdx'
     est mat se_dfdx `se_dfdx'
end


program define Vhatdiag /* mns b V -> res */
	args xbar b V ARROW res

	tempname tmp dgdb

	local k = colsof(`V')

	mat `tmp' = `xbar'*`b'' + e(offbar)
	mat `dgdb' = normd(`tmp'[1,1]) * ( I(`k') - `tmp'[1,1]*`b''*`xbar' )
	mat `res' = vecdiag(`dgdb'*`V'*`dgdb'')

end


program define vdummy /* i mns b V -> res */
	args i mns b V ARROW res

	tempname x xb fxb Delp Vhat
	mat `x' = `mns'
	mat `x'[1,`i']=1
	mat `xb' = `x'*`b'' + e(offbar)
	scalar `fxb' = normd(`xb'[1,1])
	mat `Delp' = `fxb' * `x'

	mat `x'[1,`i']=0
	mat `xb' = `x'*`b'' + e(offbar)
	scalar `fxb' = normd(`xb'[1,1])
	mat `xb' = `fxb'*`x' 
	mat `Delp' = `Delp' - `xb'

	mat `Vhat' = `Delp'*`V'*`Delp''
	scalar `res' = `Vhat'[1,1]
end

		     /*  1    2    3   4      5          6    7 */
program define Debug /* name  `c' `s' `z' `mns'[1,`i'] `ll' `ul' */
	local name `"`1'"'
	local c = `2'
	local s = `3'
	local z = `4'
	local m = `5' 
	local l = `6'
	local u = `7'
	tempname row
	mat `row' = (`c',`s',`z',`m',`l',`u')
	mat `name' = nullmat(`name') \ `row'
end
exit

Dummies

        Dp = F(x2*b) - F(x1*b)

        d(Dp)/db = f(x2*b)*x2 - f(x1*b)*x1

        Vhat(Dp) = [d(Dp)/db)]' V [d(Dp)/db]


Continuous 

        p = F(x*b)

        dp/dx = f(x*b)*x = g(b)

        dg/db = f'(x*b)b'x + f(x*b)I

        Vhat  = [dg/db] V [dg/db]'
