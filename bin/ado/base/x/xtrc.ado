*! version 1.10.0  21jun2018
program define xtrc, eclass byable(onecall) prop(xt xtbs mi)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun xtrc, panel mark(I OFFset) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xtrc `0'"'
		exit
	}

	if replay() {
                if "`e(cmd)'" != "xtrc" {
			error 301
		}
		if _by() {
			error 190
		}
                Display `0'
                exit
        }
        `BY' Estimate `0'
	version 10: ereturn local cmdline `"xtrc `0'"'
end

program define Estimate, eclass byable(recall) sort
        version 6.0, missing

        #delimit ;
        syntax [varlist(fv)] [if] [in] 
                        [, I(varname) T(varname) noCONstant OFFset(varname) 
                        Level(cilevel) BETAs VCE(passthru) *] ;
        #delimit cr
	if "`s(fvops)'" == "true" | _caller() >= 11 {
		local vv : di "version " string(max(11,_caller())) ", missing:"
	}

	_get_diopts diopts, `options'
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	_vce_parse, opt(CONVENTIONAL):, `vce'
	local vcetype = cond("`r(vce)'" != "", "`r(vce)'", "conventional")

        _xt, i(`i') t(`t')
        local ivar "`r(ivar)'"
        local tvar "`r(tvar)'"

        if "`offset'" != "" {
                tempvar ovar
                confirm var `offset'
		local ostr "`offset'"
                gen double `ovar' = `offset'
                local oarg "offset(`ovar')"
        }
        
        local level "level(`level')"

	/* Parsing complete, mark sample now */

	marksample touse
	markout `touse' `offset' `t' 
	markout `touse' `ivar', strok

        quietly {
		if `fvops' {
			local rmcoll "version 11: _rmcoll"
			local fvexp expand
		}
		else	local rmcoll _rmcoll
		tokenize `varlist'
                local dep "`1'"
		local depname "`1'"
                mac shift
                local ind "`*'"
                noi `rmcoll' `ind' if `touse', `constan' `fvexp'
                local ind "`r(varlist)'"
                local p : word count `ind'

		local rhs = `p'
		if "`constan'" == "" { local rhs = `rhs'+1 }

                tempvar t T
                sort `touse' `ivar' 
                by `touse' `ivar': gen `c(obs_t)' `t' = _n if `touse'
                by `touse' `ivar': gen `c(obs_t)' `T' = _N if `touse'

		count if `touse' 
		local nobso = r(N)

		by `touse' `ivar' : replace `touse' = 0 if `T'[_N] <= `rhs'
		replace `T' = . if `touse'==0

		count if `touse' 
		local nobs = r(N)

		if `nobs' < `nobso' {
			noi di as text "Note: " as res  `nobso'-`nobs' /*
				*/ as text " obs. dropped (panels too small)"
		}
		if `nobs' == 0 {
			error 2000
		}

		tempvar g  
		egen `g' = group(`ivar') if `touse'
		summ `g' if `touse'
		local ng = r(max)     

                summarize `T' if `touse' & `ivar'!=`ivar'[_n-1], meanonly
                local ng = r(N)
                local g1 = r(min)
                local g2 = r(mean)
                local g3 = r(max)

		if "`oarg'" != "" {
			replace `ovar' = `dep'-`ovar'
			local dep "`ovar'"
		}
		
		if c(max_matdim) < `ng' {
			error 915
		}
		
/* Going to use individual temp matrices for the variances
   because otherwise I would need to vec and then unvec
   each one every time I need to use it.  Matrix returned
   to user, though, is Ng * (k^2)
*/
		tempname xtx v1 bbar sig1 tmp vs bt bols bcheck bomit
		mat `bols' = J(`ng', `rhs', 0)
		`vv' ///
		_regress `dep' `ind' if `touse' & `g'==1, `constan' optsweep
		if _caller() >= 11 {
			mat `bomit' = get(_b)
			_ms_omit_info `bomit'
			mat `bomit' = r(omit)
		}
		mat `tmp' = get(_b)
		local colstr : copy local ind
		if "`constan'" == "" {
			local colstr `"`colstr' _cons"'
		}
		mat `bols'[1, 1] = `tmp'
		version 11: mat colnames `bols' = `colstr'
		mat `v1' = get(VCE)
		mat `vs' = syminv(`v1')
		mat `bt' = `vs' * `bols'[1, 1...]'
		mat `sig1' = `bols'[1, 1...]' * `bols'[1, 1...]
		mat `bbar' = `bols'[1, 1...]
		local i = 2
		while `i' <= `ng' {
			tempname v`i' 
			`vv' ///
			_regress `dep' `ind' if `touse' & `g'==`i', ///
				`constan' optsweep
			if _caller() >= 11 {
				mat `bcheck' = get(_b)
				_ms_omit_info `bcheck'
				if mreldif(`bomit', r(omit)) > 0 {
					ErrOut
				}
			}
			mat `bols'[`i', 1] = get(_b)
			mat `bbar' = `bbar' + `bols'[`i', 1...]
			mat `tmp' = `bols'[`i', 1...]' * `bols'[`i', 1...]
			mat `sig1' = `sig1' + `tmp'
			mat `v`i'' = get(VCE)
			mat `tmp' = syminv(`v`i'')
			mat `vs' = `vs' + `tmp'
			mat `tmp' = `tmp' * `bols'[`i', 1...]'
			mat `bt' = `bt' + `tmp'
			local i = `i' + 1
		}
		mat `vs' = syminv(`vs')
		mat `bt' = `vs' * `bt'
		local ngg = 1/`ng'
		mat `bbar' = `bbar' * `ngg'
		tempname sig sig2 
		mat `sig2' = `bbar' ' * `bbar'
		mat `sig2' = `sig2' * `ng'
		mat `sig' = `sig1' - `sig2'
		local ngg = 1/(`ng'-1)
		mat `sig' = `sig' * `ngg'

		tempname den w1 bm tmp2
		mat `w1' = `sig' + `v1'
		mat `w1' = syminv(`w1')
		mat `den' = `w1'
		mat `bt' = `bt' '
		mat `tmp' = `bols'[1, 1...] - `bt'
		mat `tmp2' = syminv(`v1')
		mat `bm' = `tmp' * `tmp2'
		mat `bm' = `bm' * `tmp''
		local i 2
		while `i' <= `ng' {
			tempname w`i'
			mat `w`i'' = `sig' + `v`i''
			mat `w`i'' = syminv(`w`i'')
			mat `den' = `den' + `w`i'' 
			mat `tmp' = `bols'[`i', 1...] - `bt'
			mat `tmp2' = syminv(`v`i'')
			mat `tmp2' = `tmp' * `tmp2'
			mat `tmp2' = `tmp2' * `tmp''
			mat `bm' = `bm' + `tmp2'
			local i = `i'+1
		}
		local k = colsof(`bols')
		local chival = `bm'[1,1]
		local df = `k'*(`ng'-1)
		local chiprob = chiprob(`df',`chival')

		tempname vce
		mat `den' = syminv(`den')
		mat `vce' = `den'

		local i 1
		while `i' <= `ng' {
			mat `w`i'' = `den' * `w`i''
			local i = `i'+1
		}

		mat drop `den'
		tempname beta
		mat `beta' = `w1' * `bols'[1, 1...]'
		local i 2
		while `i' <= `ng' {
			mat `den' = `w`i'' * `bols'[`i', 1...]'
			mat `beta' = `beta' + `den'
			local i = `i'+1
		}

		/* Now get the panel-specific betas */

		tempname bps sigi zerob
		mat `bps' = J(`ng', `rhs', 0)
		version 11: mat colnames `bps' = `colstr'
		mat `sigi' = syminv(`sig')
		// needed because versions>=11 keep base categories for FV's
		// in the variance matrices, so there will be zeros along
		// main diagonal of syminv() of variance matrices by 
		// construction.
		if _caller() >= 11 {
			mat `zerob' = J(`rhs', 1, 1)
			mat `zerob' = `bomit'*`zerob'
			sca `zerob' = trace(`zerob')
		}
		else {
			sca `zerob' = 0
		}
		loc i = 1
		while `i' <= `ng' {
			tempname rr_`i' sumz
			capture mat `rr_`i'' = syminv(`v`i'')
			sca `sumz' = diag0cnt(`rr_`i'')
			if `sumz' > `zerob' { // Rare singular matrix problem
				mat `rr_`i'' = J(`rhs', `rhs', .)
				mat `bps'[`i', 1] = J(1, `rhs', .)
			}
			else {
				mat `bps'[`i', 1] = ///
					(syminv(`sigi' + `rr_`i''')* ///
					(`sigi'*`beta' + `rr_`i''* ///
					  `bols'[`i', 1...]'))'
			}
			loc i = `i' + 1
		}
		/* Assemble var[b_i] */
		tempname amat imina vps
		mat `vps' = J(`ng', `rhs'^2, 0)
		loc i = 1
		while `i' <= `ng' {
			if `bps'[`i', 1] < . {
				mat `amat' = syminv(`sigi' + `rr_`i'')*`sigi'
				mat `imina' = I(`k') - `amat'
				mat `vps'[`i', 1] = vec(`vce' + ///
					`imina'*(`v`i'' - `vce')*`imina'')'
			}
			else {
				mat `vps'[`i', 1] = J(1, `rhs'^2, .)
			}
			loc i = `i' + 1
		}
		
		mat `beta' = `beta' '
		version 11: mat colnames `beta' = `colstr'
		version 11: mat colnames `vce' = `colstr'
		version 11: mat rownames `vce' = `colstr'
		est post `beta' `vce', obs(`nobs') depname(`depname') /*
			*/ esample(`touse') buildfvinfo
		_post_vce_rank
		est mat Sigma `sig'
		capture test `ind', min `constan'
		if _rc == 0 {
			est scalar chi2 = r(chi2)
			est scalar df_m = r(df)
		}
		else    est scalar df_m = 0
		est scalar g_min  = `g1'
		est scalar g_avg  = `g2'
		est scalar g_max  = `g3'
		est scalar N_g = `ng'
		est scalar chi2_c = `chival'
		est scalar df_chi2c = `df'
		est local vce "`vcetype'"
		est local title "Random-coefficients regression"
		est local chi2type "Wald"
		est local offset "`ostr'"
		est local depvar "`depname'"
		est local ivar "`ivar'"
		est local tvar "`tvar'"
		est local marginsnotok GRoup(passthru) STDP
		est local predict "xtrc_p"
		est local cmd "xtrc"
		est matrix beta_ps `bps'
		est matrix V_ps `vps'
	}
	Display, `level' `betas' `diopts'
end

program define Display
        version 6.0, missing
	syntax [, Level(cilevel) BETAs *]

	_get_diopts diopts, `options'
	_crcphdr
	_coef_table, level(`level') `diopts'
	di in gr "Test of parameter constancy:    " /*
		*/ "chi2(" in ye e(df_chi2c) in gr ") = " /*
		*/ in ye %8.2f e(chi2_c) /*
		*/ in gr _col(59) "Prob > chi2 = " /*
		*/ in ye %6.4f chiprob(e(df_chi2c),e(chi2_c))
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	if `cil' == 2 {
		local spaces "     "
	}
	else if `cil' == 4 {
		local spaces "   "
	}
	else {
		local spaces "  "
	}
	version 8, missing
        if ("`betas'" != "") {
                di
                di _col(25) "Group-specific coefficients"
                di as text "{hline 78}"
                di as text _col(21) ///
`"Coef.   Std. Err.      z    P>|z|`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
                di as text "{hline 13}{c TT}{hline 64}"
                tempname se b v pval cv junkb junkv junkvec
                mat `b' = e(beta_ps)
                mat `v' = e(V_ps)
                sca `cv' = invnorm(1 - ((100-`level')/100)/2)
                loc names : colnames `b'
                loc coefs : word count `names'
		loc numgrps = e(N_g)
                forvalues i = 1/`numgrps' {
                        di as text %12s "Group `i'" " {c |} "
                        di as text "{hline 13}{c +}{hline 64}"
                        mat `junkb' = `b'[`i', 1...]
			mat `junkvec' = `v'[`i', 1...]
			mat `junkv' = J(`coefs', `coefs', 0)
			forvalues m = 1/`coefs' {
				forvalues n = 1/`coefs' {
					mat `junkv'[`m', `n'] = ///
					   `junkvec'[1,`m'+(`n'-1)*`coefs']
				}
			}
                        forvalues j = 1/`coefs' {
                                loc col = 17
                                loc name : word `j' of `names'
                                di as text ///
%12s abbrev("`name'",12) " {c |}" as result _col(`col') %9.7g `junkb'[1,`j'] _c
                                loc col = `col' + 11
                                sca `se' = sqrt(`junkv'[`j', `j'])
                                if (`se' > 0 & `se' < .) {
                                        di as res _col(`col') %9.7g `se' ///
                                                "   " _c
                                        di as result %6.2f ///
                                                `junkb'[1, `j']/`se' ///
                                                "   " _continue
                                        sca `pval' = ///
                                        2*(1 - norm(abs(`junkb'[1, `j']/`se')))
                                        di as result %5.3f `pval' "    " _c
                                        di as result ///
%9.7g (`junkb'[1,`j'] - `cv'*`se') "   " _continue
                                        di as result ///
%9.7g (`junkb'[1,`j'] + `cv'*`se') _continue
                                        di   
                                }
                                else {
                                        di as text _col(36) ///
".        .       .            .           ."
                                }
                        }
                        if (`i' < `numgrps') {
                                di as text "{hline 13}{c +}{hline 64}"
                        }
                        else {
                                di as text "{hline 13}{c BT}{hline 64}"
                        }
                }
        }



end

program ErrOut

	di in red "variables dropped due to collinearity. " _c
	di in red "xtrc requires that you be able to fit " 
	di in red "OLS regression to each panel without " _c
	di in red "dropping variables due to collinearity."

	exit 498

end

exit
