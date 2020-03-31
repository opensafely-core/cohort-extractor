*! version 2.10.3  16feb2015
program define xtps_ren_8, eclass /* old version of xtpoisson for -re normal- */
        version 6.0, missing
        if replay() {
                if "`e(cmd)'" != "xtpoisson" & "`e(cmd2)'" != "xtpoisson" {
                        error 301
                }
                Display `0'
		exit
        }

	Estimate `0'
end

program define Estimate, eclass
	#delimit ;
	syntax [varlist] [if] [in] [iweight aweight pweight]
			[, I(varname) Exposure(varname num) RE IRr EFORM
			Level(passthru) noCONstant SKIP noREFINE
			OFFset(varname num) FROM(string) Quad(int 12)
			noLOg GAUSSian NORMAL *] ;
	#delimit cr

	mlopts mlopt rest, `options'
	if "`rest'"!="" {
		di in red "`rest' invalid"
		exit 198
	}

	if `"`from'"'!="" | "`constan'"!="" {
		local skip "skip"
	}

        if "`weight'" == "aweight" | "`weight'" == "pweight" {
                noi di in red /*
		*/ "`weight' not allowed for fixed- and random-effects cases"
                exit 101
        }

				/* parsing complete	*/

				/* mark sample		*/

	marksample touse
	markout `touse' `offset' `exposur'
	xt_iis `i'
	local ivar "`s(ivar)'"
	markout `touse' `ivar', strok


        if "`eform'" != "" { local irr "irr" }
        local disparg "`level' `irr'"

	if "`normal'" != "" {
		local gaussia "Gaussian"
	}

	tempvar ovar
	if "`offset'" != "" {
		qui gen double `ovar' = `offset'
		local oarg "offset(`ovar')"
		local offstr "`offset'"
	}
	else    qui gen byte `ovar' = 0

	if "`exposur'"' != "" {
		if "`offset'"!="" {
			version 11: ///
			di in red "may not specify both {cmd:exposure()} " ///
				"and {cmd:offset()}"
			exit 198
		}
		capture drop `ovar'
		qui gen double `ovar' = ln(`exposur')
		local oarg "offset(`ovar')"
		local offstr "ln(`exposur')"
	}

	quietly {
		tokenize `varlist'
		local dep "`1'"
		mac shift
		local ind "`*'"
		count if `dep' < 0 & `touse'
		if r(N) {
			noi di in red _n "`dep'<0 in `r(N)' obs."
			exit 459
		}

		count if `touse'
		local nobs = r(N)
		if `quad' < 4 | `quad' > 30 {
			di in red "number of quadrature points " /*
				*/ "must be between 4 and 30"
			exit 198
		}
		if `quad' > r(N) {
			noi di in red "number of quadrature points " /*
				*/ "must be less than or equal to " /*
				*/ "number of obs"
			exit 198
		}

		noi _rmcoll `ind' if `touse', `constan'
		local ind "`r(varlist)'"
		local p : word count `ind'

		if "`ind'" == "" & "`constan'" != "" {
			noi di in red "must have at least one covariate"
			exit 198
		}

                local k 1
                while `k' <= `p' {
                        local wrd : word `k' of `ind'
                        local names "`names' `dep':`wrd'"
                        local k = `k'+1
                }
		if "`constan'" == "" {
			local names "`names' `dep':_cons lnsig2u:_cons"
		}
		else {
			local names "`names' lnsig2u:_cons"
		}

		if "`constan'" == "" {
			local p = `p' + 1
		}

                if "`from'" != "" {
                        local arg `from'
                        tempname from
                        noi _mkvec `from', from(`arg') colnames(`names') /*
                                */ error("from()")
                }

                tempvar T
                sort `touse' `ivar'
                if "`weight'" != "" {
                        tempvar wv
                        qui gen double `wv' `exp' if `touse'
                        _crcchkw `ivar' `wv' `touse'
                        drop `wv'
                }
                by `touse' `ivar': gen `c(obs_t)' `T' = _N if `touse'
                summarize `T' if `touse' & `ivar'!=`ivar'[_n-1], meanonly
                local ng = r(N)
                local g1 = r(min)
                local g2 = r(mean)
                local g3 = r(max)

                local lll = cond("`log'"!="", "quietly", "noisily")

		local title "Random-effects Poisson regression"
		if "`gaussia'" == "" {
			local distr "Gamma"
			local theta "/invln_a"
		}
		else {
			local distr "Gaussian"

		}

		tempname beta rho
		if "`from'" == "" {
			`lll' di in gr _n "Fitting comparison Poisson model:"
			`lll' poisson `dep' `ind' [`weight'`exp'] /*
				*/ if `touse', /*
				*/ `oarg' `constan' nodisplay
			local llprob = e(ll)
			mat `beta' = e(b)
			mat coleq `beta' = `dep'

			mat `rho' = (-.2)
			mat colnames `rho' = rho:_cons
			mat `beta' = (`beta',`rho')
		}
		else {
			mat `beta' = `from'
                        local refine "norefine"
			noi di
		}
		local sna : colnames(`beta')
		local snp : word count `sna'
		local pp1 : word count `names'
		if `pp1' != `snp' {
			* Means that some predictor was dropped
			* because user gave short from vector.
			if "`from'" == "" {
				di in red "unable to identify sample"
			}
			else {
				local nr = rowsof(`from')
				local nc = colsof(`from')
				di in red "`from' (`nr'x`nc') is " _c
				di in red "not correct length " _c
				di in red "-- should be (1x`pp1')"
			}
			exit 198
		}
		if "`log'" == "" { local lll "noisily" }
		else             { local lll "quietly" }

		tempvar o w
		if "`weight'" == "" {
			qui gen double `w' = 1 if `touse'
		}
		else {
			qui gen double `w' `exp' if `touse'
		}

		sort `touse' `ivar' `dep' `ind'
		tempvar pp
		gen `c(obs_t)' `pp' = _n*`touse' /* if `touse' */
		summ `pp' if `touse'
		local j0 = r(min)
		local j1 = r(max)
	}
	if "`skip'" == "" & "`ind'" != "" {
		tempname beta0 rho
		qui poisson `dep' in `j0'/`j1' `wtxp', `oarg' iter(1)
		mat `beta0' = get(_b)
		mat `rho' = (-.2)
		mat `beta0' = `beta0',`rho'

		`lll' di _n in gr "Fitting constant-only model:" _n

		_XTRENORM `dep' in `j0'/`j1', i(`ivar') /*
			*/ w(`w') `oarg' b(`beta0') quad(`quad') /*
			*/ `options' poisson `log' `constan' `refine'
		local ll0 = e(ll)
		if `ll0' < 0 {
			local llarg "ll_0(`ll0')"
		}
		`lll' di in green _n "Fitting full model:" _n
	}
	else if "`llprob'" != "" {
		`lll' di in green _n "Fitting full model:" _n
	}

	_XTRENORM `dep' `ind' in `j0'/`j1', i(`ivar') w(`w') `oarg' /*
		*/ b(`beta') quad(`quad') `options' /*
		*/ poisson `log' `constan' `llarg' `refine'

	est local r2_p
	est local cmd
	est local offset
	est scalar n_quad = `quad'
        est local intmethod "ghermite"
	est local distrib "`distr'"
        est local title   "`title'"
        est local wtype  "`weight'"
        est local wexp   "`exp'"
        est scalar N_g    = `ng'
        est scalar g_min  = `g1'
        est scalar g_avg  = `g2'
        est scalar g_max  = `g3'
        tempname b v
        mat `b' = get(_b)
        mat `v' = get(VCE)
        mat colnames `b' = `names'
        mat colnames `v' = `names'
        mat rownames `v' = `names'
        mat post `b' `v', depname(`dep') noclear

	if "`llprob'" != "" {
		est scalar ll_c   = `llprob'
		est scalar chi2_c  = cond([lnsig2u]_b[_cons]<=-14, 0, /*
                        */ abs(-2*(e(ll_c)-e(ll))))
		est local chi2_ct "LR"
	}

	est scalar sigma_u = exp(.5*[lnsig2u]_b[_cons])
	*est scalar rho    = e(sigma_u)^2 / (1 + e(sigma_u)^2)

	est local ivar "`ivar'"
	est local offset /* undo from xtgee */
	est local offset1 "`offstr'"
	est local predict xtcnt_p
	est local model "re"
	est local cmd "xtpoisson"

        Display, `disparg'
end

program define Display
	syntax [, Level(cilevel) IRr]
        if "`irr'" != "" { local earg "eform(IRR)" }

        _crcphdr
        mat mlout, first plus `earg'
	_diparm lnsig2u, level(`level')
	di in smcl in gr "{hline 13}{c +}{hline 64}"
	_diparm lnsig2u, level(`level') label("sigma_u") /*
		*/ function(exp(.5*@)) /*
		*/ derivative(.5*exp(.5*@))
	*_diparm lnsig2u, level(`level') label("rho") /*
		*/ function(exp(@)/(1+exp(@))) /*
		*/ derivative(exp(@)/((1+exp(@))^2))
	di in smcl in gr "{hline 13}{c BT}{hline 64}"

	if "`e(distrib)'" != "" & "`e(ll_c)'" != "" {
		if "`e(distrib)'" == "Gaussian" {
			local msg "Likelihood-ratio test of sigma_u=0"
		}
		else {
			local msg "Likelihood-ratio test of alpha=0"
		}
		_lrtest_note_xt, msg("`msg'")
	}
        if e(N_cd) <. {
		if e(N_cd) > 1 { local s "s" }
                di in bl _n /*
		*/ "Note: `e(N_cd)' completely determined panel`s'"
        }
end

