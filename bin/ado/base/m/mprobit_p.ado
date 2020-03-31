*! version 1.4.1  19sep2018
/* predict for mprobit */
program define mprobit_p
	if e(k_eq) != e(k_out) {
		mprobit_p_11 `0'
		exit
	}
        version 9

	if "`e(cmd)'" != "mprobit" {
		di as error "{p}multinomial probit estimates from" ///
	    	" {help mprobit##|_new:mprobit} " ///
		"not found{p_end}"
		exit 301
	}
	syntax anything [if] [in] [, 	///
		XB STDP Pr 		///
		Equation(string) 	///
		Outcome(string) 	///
		SCores]

	local predtype `xb' `stdp' `pr' `scores'
        local nopt : word count `predtype'
	if "`outcome'" != "" & "`equation'" != "" {
		opts_exclusive "equation() outcome()"
	}
	if "`equation'" != "" {
		local outcome "`equation'"
	}
        if `nopt' > 1 {
                di as error "{p}only one of pr, xb, stdp, or scores can be " ///
		 "specified{p_end}"
                exit 198
        }
	if "`predtype'" == "" {
		di as txt "(option {bf:pr} assumed; predicted probabilities)"
		local predtype "pr"
	}
	marksample touse, novarlist
	markout `touse' `e(indvars)' 

	if "`predtype'"=="xb" | "`predtype'"=="stdp" {
		if bsubstr("`anything'",-1,1) == "*" {
			di as err ///
"option `predtype' requires that you specify 1 new variable"
			error 103
		}
		local 0 `anything'
		syntax newvarname
		if `"`outcome'"' == "" {
			local outcome "#1"
		}

		Outcome "`outcome'" 
		local outcome = `s(outcome)'
		local eq  "`s(eq)'"
        }
	else {
		cap _stubstar2names `anything', nvars(`e(k_out)') singleok outcome
		local rc = _rc
		if `rc' == 0 {
			local varlist `s(varlist)'
			local typlist `s(typlist)'
			local nv : word count `varlist'
			if `nv' == 1 & "`outcome'" == "" {
				local outcome "#1"
			}
		}
		if `rc' {
			if `rc'==102 | `rc'==103 {
				di as error "{p}must specify " e(k_out) " new variable names, "  ///
				 "or one new variable name with the outcome() option when using " ///
				 "the pr option{p_end}"
				exit 198
			}
			error `rc'
		}
		if `nv'==1 & "`outcome'"=="" {
			local outcome "#1"
		}
		Outcome "`outcome'" 
		local outcome `"`s(outcome)'"'
	}

	tokenize `typlist'
	local type `1'
	if "`predtype'"=="xb" | "`predtype'"=="stdp" {
		if `outcome' == `e(i_base)' {
			gen `type' `varlist' = 0
		}
		else {
			qui _predict `type' `varlist' if `touse', `predtype' equation(`eq')
		}

		if ("`predtype'"=="xb") {
			label var `varlist' ///
`"Linear prediction, `e(depvar)'=`=abbrev("`e(out`outcome')'",17)'"'
		}
		else {
			label var `varlist' ///
`"Standard error of the linear prediction, `e(depvar)'=`=abbrev("`e(out`outcome')'",17)'"'
		}

		local labels : value label `e(depvar)'
	}
	else {
		if "`e(prefix)'" == "svy" {
			local pre "svy:"
		}
		if "`predtype'" == "scores" {
			if `nv' == 1 {
				if `outcome' == `e(i_base)' {
					gen `type' `varlist' = 0
					label var `varlist' ///
"equation-level score from `pre'mprobit"
					exit
				}
			}
		}

		macro drop MPROBIT_*
		global MPROBIT_NPOINTS = e(k_points)
		global MPROBIT_NALT = e(k_out)
		global MPROBIT_BASE = e(i_base)
		global MPROBIT_ALTEQS `e(outeqs)'

		tempname qx qw ehold
		mata: _mprobit_weights_roots_laguerre($MPROBIT_NPOINTS, "`qw'", "`qx'")
		global MPROBIT_QX `qx'
		global MPROBIT_QW `qw'
		global MPROBIT_TOUSE `touse'
		global MPROBIT_PROBITPARAM = e(probitparam)

		_est hold `ehold', restore copy

nobreak {
capture noisily break {

		Reduce

		if "`predtype'" == "scores" {
			unab vlist0 : *
			tempvar depvar
			tempname label
			markout `touse' `e(depvar)'

			qui egen `depvar' = group(`e(depvar)') if `touse'

			global MPROBIT_CHOICE `depvar'
			/* will generate one more score than expected */ 
			tempvar cb
			gen double `cb' = 0
			global MPROBIT_SCRS `cb'

			local nvars = `nv' - 1
			forval i = 1/`nvars' {
				tempname x
				local vlist `vlist' `x'
				local tvlist `tvlist' `type' `x'
			}

			noi ml score `tvlist' if `touse'

			local VARLIST : copy local varlist
			forval i = 1/`nv' {
				gettoken var VARLIST : VARLIST
				if `i' == e(i_base) {
					gen `type' `var' = 0 if `touse'
					label var `var' ///
"equation-level score for `e(out`i')' from `pre'mprobit"
				}
				else {
					gettoken x vlist : vlist
					rename `x' `var'
				}
			}
			order `vlist0' `varlist'
		}
		else {
			tempname b negH lnf g y
			
	 		scalar `lnf' = 0.0
			matrix `b' = e(b)
			qui gen int `y' = .
			global MPROBIT_CHOICE `y'
			local i = 0
			foreach vi of local varlist {
				confirm new variable `vi'
				tempvar `vi'`++i'
				qui gen `type' ``vi'`i'' = .
				local li : word `i' of `outcome'
				qui replace `y' = `li'

				mprobit_lf -1 `b' `lnf' `g' `negH' ``vi'`i'' 
			} 
			local i = 0
			foreach vi of local varlist {
				rename ``vi'`++i'' `vi'
				local li : word `i' of `outcome'
				label var `vi' `"Pr(`e(depvar)'==`=abbrev("`e(out`li')'",17)')"'
			}
		}

} // capture noisily break
		local rc = c(rc)

		macro drop MPROBIT_*
} // nobreak

		if (`rc') exit `rc'
	}

end

program Reduce, eclass
	tempname bi b V

	local k_xvars	= e(k_indvars) + e(const)
	local k_eq	= e(k_eq)
	local coleq : coleq e(b)
	local coleq : list uniq coleq

	local dim = `k_xvars' * (`k_eq' - 1)

	matrix `b' = e(b)
	matrix `V' = I(`dim')

	local base = e(i_base)
	if `base' == 1 {
		local i1 = `k_xvars'+1
		matrix `b' = `b'[1,`i1'...]
	}
	else if `base' == `k_eq' {
		matrix `b' = `b'[1,1..`dim']
	}
	else {
		local i0 = (`base'-1)*`k_xvars'
		local i1 = `i0' + `k_xvars' + 1
		matrix `b' = `b'[1,1..`i0'], `b'[1,`i1'...]
	}
	ereturn repost b=`b' V=`V', rename resize
end

program Outcome, sclass

	args outcomes 

	local o = trim(`"`outcomes'"')
	local nalt : word count `e(outeqs)'
	if ("`o'"=="") {
		forvalues i=1/`nalt' {
			local outcomes `"`outcomes' `i'"'
		}
		sreturn local outcome `"`outcomes'"'	
		exit
	}	
	local altlabels `"`s(names)'"'
	if bsubstr(`"`o'"',1,1) == "#" {
		local i = bsubstr(`"`o'"',2,.)
		if `i' < 0 | `i' > `nalt' {
			di as error "{p}equation #`i' does not exist; " ///
 			 "there are `nalt' equations{p_end}"
			exit 322
		}
		/* interpret eq 0 as the base equation */
		if (`i' == 0) {
			local outcome = e(i_base)
		}
		else {
			local outcome = `i'
		}

		sreturn local eq "`o'"
		sreturn local outcome = `outcome'
		exit 
	}
	/* level */
	cap confirm number `o'
	local eq = 0
	if _rc == 0 {
		forvalues i=1/`nalt' {
			if `o' == el(e(outcomes),`i',1) {
				local outcome = `i'
				local eq = `i'

				continue, break
			}
		}
		if `"`outcome'"' == "" {
			di as error "{p}`o' is not one of the outcomes{p_end}"
			exit 322
		}

		sreturn local eq  "#`eq'"
		sreturn local outcome = `outcome'
		exit
	}
	/* clear _rc */
	cap
	/* label must be the syntactic equation names generated by :	*/
	forvalues i=1/`nalt' {
		local labi : word `i' of `e(outeqs)'
		if `"`labi'"' == `"`o'"' {
			local outcome = `i'
			local eq = `i'

			continue, break
		}
	}
	if `"`outcome'"' == "" {
		di as error "{p}`o' is not one of the outcomes{p_end}"
		exit 322
	}

	sreturn local eq  "#`eq'"
	sreturn local outcome = `outcome'
end
