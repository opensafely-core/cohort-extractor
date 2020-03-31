*! version 1.4.25  22nov2016
program xttobit_8, eclass byable(onecall)
        version 6, missing
	if replay() {
                if "`e(cmd)'" != "xttobit" { error 301 }
		if _by() { error 190 }
                Display `0'
                exit
        }
	if _by() {
        	by `_byvars'`_byrc0': Estimate `0'
	}
        else	Estimate `0'
end

program Estimate, eclass byable(recall) sort
	#delimit ;
	syntax [varlist] [if] [in] [iweight] 
			[, I(varname) RE FE PA noSKIP noCONstant tobit
			OFFset(varname num) FROM(string) Quad(int 12) 
			Level(passthru) LL(string) UL(string) noLOg *] ;
	#delimit cr

	mlopts mlopt, `options'

	xt_iis `i'
	local ivar "`s(ivar)'"

	if "`offset'" != "" {
		tempvar ovar
		gen double `ovar' = `offset'
		local oarg "offset(`ovar')"
	}

	if "`fe'" != "" {	
		di in red "Fixed-effects model not available"
		exit 198
	}
	if "`pa'" != "" {	
		di in red "Population-averaged model not available"
		exit 198
	}

        if `quad' < 4 | `quad' > 30 {
                di in red "number of quadrature points must be between 4 and 30"

                exit 198
        }

	quietly {
                /* NOTE:  VERY VERY VERY carefully mark the sample
                        Remember that there are two dependent variables
                        where one of them could be missing to denote
                        censoring.
                */

		tempvar touse
		mark `touse' `if' `in' [`weight'`exp']
		markout `touse' `ovar'
		markout `touse' `ivar', strok

		tokenize `varlist'
		local depn "`1'"
		tempvar dep1 dep2
		gen double `dep1' = `depn'
		gen double `dep2' = `depn'
		if "`ll'" != "" {
			replace `dep1' = .    if `depn' <= `ll'
			replace `dep2' = `ll' if `depn' <= `ll'
			local llopt `"`ll'"'
		}
		else {
			local ll = .
		}
		if "`ul'" != "" {
			replace `dep2' = .    if `depn' >= `ul'
			replace `dep1' = `ul' if `depn' >= `ul'
			local ulopt `"`ul'"'
		}
		else {
			local ul = .
		}
		count if `dep1' > `dep2' & `dep1'<. & `dep2'<. 
		if r(N) > 0 {
			di in red "ll() must be less than ul()"
			exit 198
		}

		replace `touse' = 0 if `dep1'>=. & `dep2'>=. 
		mac shift 
		local ind "`*'"
		markout `touse' `ind'

		/* Sample is now set */


		count if `touse'
                if `quad' > r(N) {
                        noi di in red "number of quadrature points " /*
                                */ "must be less than or equal to " /*
                                */ "number of obs"
                        exit 198
                }

		if "`constan'`from'" != "" {
			local skip ""
		}
		noi _rmcoll `ind' if `touse', `constan' 
		local ind "`r(varlist)'"
		local p : word count `ind' 
		tempname zero
		mat `zero' = J(1,`p',0)

                if "`log'" == "" { local lll "noisily" }
                else             { local lll "quietly" }


                local k 1
                while `k' <= `p' {
                        local wrd : word `k' of `ind'
                        local names "`names' `depn':`wrd'"
                        local k = `k'+1
                }

		local suse "sigma_u:_cons sigma_e:_cons"
		if "`constan'" == "" {
			local names  `names' `depn':_cons `suse'
		}
		else {
			local names  `names' `suse'
		}

                if "`from'" != "" {
                        local arg `from'
                        tempname from
                        noi _mkvec `from', from(`arg') colnames(`names') /*
                                */ error("from()")
                }

		tempname beta beta0
		if "`from'" == "" & "`tobit'" != "" {
			`lll' di in gr _n "Fitting comparison model:"
			`lll' intreg `dep1' `dep2' `ind' /*
				*/ if `touse', `oarg' nodisplay `constan'
			local llprob = e(ll)  
			mat `beta' = e(b)
			local j = colsof(`beta')
			local se = `beta'[1,`j']
			local jm1 = `j'-1
		}
		if "`from'" != "" {
			mat `beta' = `from'
                        local refine "norefine"
			noi di
		} 
		else {
                        `lll' di in gr _n "Obtaining starting values for " /*
                                */ "full model:" _n
                        `lll' xtreg `depn' `ind' if `touse', /*
                                */ i(`ivar') mle nodisp skip `constan'
                        mat `beta' = e(b)
		}


                tempvar T
                sort `touse' `ivar'
                if "`weight'" != "" {
                        tempvar wv
                        gen double `wv' `exp'
                        _crcchkw `ivar' `wv' `touse'
                        drop `wv'
                }
                by `touse' `ivar': gen `c(obs_t)' `T' = _N if `touse'
                summarize `T' if `touse' & `ivar'!=`ivar'[_n-1], meanonly
                local ng = r(N)
                local g1 = r(min)
                local g2 = r(mean)
                local g3 = r(max)

                if "`skip'" != "" {
                        tempvar ys
                        gen double `ys' = (`dep1'+`dep2')/2
                        replace `ys' = `dep1' if `dep1'<. & `ys'>=.
                        replace `ys' = `dep2' if `dep2'<. & `ys'>=.
                        `lll' di in gr _n "Obtaining starting values for " /*
                                */ "constant-only model:" _n
                        `lll' xtreg `ys' if `touse', i(`ivar') mle nodisp skip
                        mat `beta0' = e(b)
                }


		tempvar w
		if "`weight'" == "" {
			gen double `w' = 1 if `touse'
		}
		else {
			gen double `w' `exp' if `touse'
		}

		tempvar cvar
		gen byte `cvar' = 1 if `dep1'==`dep2'
		replace `cvar' = 2 if `dep1'>=. & `dep2'<.
		replace `cvar' = 3 if `dep1'<. & `dep2'>=.
		replace `cvar' = 4 if `dep1'<. & `dep2'<. & `dep1'<`dep2'
		replace `cvar' = 0 if `touse' == 0
		count if `dep1' > `dep2' & `cvar' == 4 
		if r(N) {
			di in red "`dep1' must be less or equal to `dep2'"
			exit 198
		}
                count if `touse' & `cvar' == 1
                local N_c1 = r(N)
                count if `touse' & `cvar' == 2
                local N_c2 = r(N)
                count if `touse' & `cvar' == 3
                local N_c3 = r(N)
		
		sort `touse' `ivar' `cvar' `dep1' `dep2' `ind'
		tempvar p
		gen `c(obs_t)' `p' = _n*`touse'
		summ `p' if `touse', meanonly
		local j0 = r(min)
		local j1 = r(max)
		local ca "cvar(`cvar')"
	}
	if "`skip'" != "" {
		`lll' di in green _n "Fitting constant-only model:" _n
		_XTRENORM `dep1' `dep2' in `j0'/`j1', i(`ivar') /*
			*/ w(`w') `oarg' /*
			*/ nodisplay b(`beta0') quad(`quad') /*
			*/ `options' intreg `ca' `log' `refine' 
		local ll0 = e(ll)
		local llarg ll_0(`ll0') 
	}
	`lll' di in green _n "Fitting full model:" _n
	_XTRENORM `dep1' `dep2' `ind' in `j0'/`j1', /*
		*/ i(`ivar') w(`w') `oarg' /*
		*/ b(`beta') quad(`quad') `options' intreg /*
		*/ `ca' `log' `llarg' `refine' `constan'
	est local cmd
	est local r2_p
	est local offset
	est local intmethod "ghermite"
	est local distrib "Gaussian"
	est local title   "Random-effects tobit regression"
        est local wtype   "`weight'"
        est local wexp    "`exp'"
	est local depvar  "`depn'"
	est local ivar    "`ivar'"
	est scalar n_quad = `quad'
        est scalar N_g    = `ng'
        est scalar g_min  = `g1'
        est scalar g_avg  = `g2'
        est scalar g_max  = `g3'
        est scalar N_c1   = `N_c1'
        est scalar N_c2   = `N_c2'
        est scalar N_c3   = `N_c3'
	est hidden scalar censtable = 1

        tempname b v

        mat `b' = e(b)
        mat `v' = e(V)
        local nc1 = colsof(`b')
        local nc = `nc1'-1
        local su = `b'[1,`nc']
        if `su' < 0 {
                mat `b'[1,`nc'] = -`su'
                local i 1
                while `i' < `nc' {
                        mat `v'[`i',`nc'] = -`v'[`i',`nc']
                        mat `v'[`nc',`i'] = `v'[`i',`nc']
                        local i = `i'+1
                }
                mat `v'[`nc',`nc1'] = -`v'[`nc',`nc1']
                mat `v'[`nc1',`nc'] = `v'[`nc',`nc1']
        }
        local nc = `nc1'
        local se = `b'[1,`nc']
        if `se' < 0 {
                mat `b'[1,`nc'] = -`se'
                local i 1
                while `i' < `nc' {
                        mat `v'[`i',`nc'] = -`v'[`i',`nc']
                        mat `v'[`nc',`i'] = `v'[`i',`nc']
                        local i = `i'+1
                }
        }
        mat colnames `b' = `names'
        mat colnames `v' = `names'
        mat rownames `v' = `names'
        est post `b' `v', noclear dep(`depn')
        if "`llprob'" != "" {
                est scalar ll_c   = `llprob'
		est scalar chi2_c = cond([sigma_u]_b[_cons]<1e-5, 0, /*
                        */ abs(-2*(e(ll_c)-e(ll))))
                est local chi2_ct "LR"
        }
        else {
                qui test [sigma_u]_cons = 0
                est scalar chi2_c  = r(chi2)
                est local chi2_ct  "Wald"
        }
        est scalar sigma_u = [sigma_u]_b[_cons]
        est scalar sigma_e = [sigma_e]_b[_cons]
        est scalar rho = e(sigma_u)^2/(e(sigma_u)^2+e(sigma_e)^2)
	est local offset1  "`offset'"
	if `"`llopt'"' != "" {
		est local llopt `"`llopt'"'
	}
	if `"`ulopt'"' != "" {
		est local ulopt `"`ulopt'"'
	}
	est local predict "tobit_p"
	est local cmd	  "xttobit"
        DispTbl, `level'
	DispLR
end
	
program Display
	DispTbl `0'
	DispLR
end


program DispTbl
	syntax [, Level(cilevel)]

	tempname b
	mat `b' = e(b)
	local su = [sigma_u]_b[_cons]
	local se = [sigma_e]_b[_cons]
	local bb = `su'^2/(`su'^2+`se'^2)
        _crcphdr
        est di, first plus level(`level')
        _diparm sigma_u, level(`level')
        _diparm sigma_e, level(`level')
	di in gr in smcl "{hline 13}{c +}{hline 64}"
        _diparm sigma_u sigma_e, label(rho) func(@1^2/(@1^2+@2^2)) /*
                */ der( 2*@1*(@2/(@1^2+@2^2))^2 -2*@2*(@1/(@1^2+@2^2))^2 ) /*
                */ ci(probit)
	di in gr in smcl "{hline 13}{c BT}{hline 64}"
end


program DispLR
        if "`e(ll_c)'" == "" {
                *di in green "Wald test of sigma_u=0:             " _c
                *di in green "chi2(" in ye "1" in gr ") = " /*
                        */ in ye %8.2f e(chi2_c) _c
                *di in green "    Prob > chi2 = " in ye %6.4f /*
                        */ chiprob(1,e(chi2_c))
        }
        else {
        	_lrtest_note_xt, msg("LR test of sigma_u=0")
        }

        di
	censobs_table e(N_c1) e(N_c2) e(N_c3)
        if e(N_cd) < . {
                if e(N_cd) > 1 { local s "s" }
                di in gr _n /*
                */ "(note: `e(N_cd)' completely determined panel`s')"
        }
end
exit
