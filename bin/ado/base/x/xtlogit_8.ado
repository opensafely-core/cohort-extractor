*! version 2.7.10  16feb2015
program define xtlogit_8, eclass byable(onecall)
	global XT_VV : display "version " string(_caller()) ", missing:"	
	version 6.0, missing
	if replay() {
                if "`e(cmd)'" != "xtlogit" & "`e(cmd2)'" != "xtlogit" {
                        error 301
                }
		if _by() { error 190 }
                Display `0'
                exit `e(rc)'
        }
	if _by() {
        	by `_byvars'`_byrc0': Estimate `0'
	}
        else	Estimate `0'
	cap mac drop XT_VV
end

program define Estimate, eclass byable(recall) sort

	#delimit ;
	syntax [varlist] [if] [in] [iweight fweight pweight]
		[, I(varname) RE FE PA noCONstant noSKIP OR
		   OFFset(varname numeric) FROM(string) Quad(int 12)
		   noREFINE Level(passthru) noLOg noDISplay * ] ;
	#delimit cr

	if length("`fe'`re'`pa'") > 2 {
		di in red "Choose only one of fe, re, and pa"
		exit 198
	}


	marksample touse
	markout `touse' `offset'
	xt_iis `i'
	local ivar "`s(ivar)'"
	markout `touse' `ivar', strok

	/*
		Population Averaged model
	*/

	if "`pa'" != "" {
		if "`offset'" != "" {
			local offarg "offset(`offset')"
		}
		if "`from'" != "" {
			local farg   "from(`from')"
		}
		if "`i'"!="" {
			local i "i(`i')"
		}
		if "`or'"!="" {
			local eform "eform"
		}
		xtgee `varlist' if `touse' [`weight'`exp'], /*
			*/ fam(binomial) rc0 `farg' `level' /*
			*/ link(logit) `i' `options' `log' `offarg' /*
			*/ `constan' `eform' `display'

		if e(rc) == 0 | e(rc) == 430 {
			est local estat_cmd ""	// reset from xtgee
			est local cmd2 "xtlogit"
		}
		error e(rc)
		exit
	}

	/*
		parsing for random effects and fixed effects
	*/

        if "`weight'" == "fweight" | "`weight'" == "pweight" {
                noi di in red "`weight' not allowed"
                exit 101
        }

        if "`skip'" == "" | "`from'" != "" {
                local skip  "skip"
        }
        else    local skip

	mlopts mlopt rest, `options'
	if `"`rest'"'!="" {
		di in red `"`rest' invalid"'
		exit 198
	}

        if `quad' < 4 | `quad' > 30 {
                di in red /*
		*/ "number of quadrature points must be between 4 and 30"
                exit 198
        }
						/* parsing complete */

	/*
		Fixed effects
	*/

        if "`fe'" != "" {
                if "`offset'" != "" {
                        local offarg "offset(`offset')"
                }
		local nvar : word count `varlist'
		if `nvar' <= 1 {
			error 102
		}
                $XT_VV clogit `varlist' if `touse' [`weight'`exp'] , /*
			*/ group(`ivar') /*
                        */ `options' `offarg' `log' nodisplay
                quietly {
                        tempvar T touse
                        gen byte `touse' = e(sample)
                        sort `touse' `ivar'
                        by `touse' `ivar': gen `c(obs_t)' `T' = _N if `touse'
                        summarize `T' if `touse' & `ivar'!=`ivar'[_n-1], detail
                }
                tempname b v
                mat `b' = e(b)
                mat `v' = e(V)
		est post `b' `v', depname(`e(depvar)') noclear
                est scalar N_g    = r(N)
                est scalar g_min  = r(min)
                est scalar g_avg  = r(mean)
                est scalar g_max  = r(max)
                est local ivar    "`ivar'"
                est local title   "Conditional fixed-effects logistic regression"
                est local cmd2    "xtlogit"

		if "`display'" == "" {
                	DispTbl, `level' `or'
                	DispLR
		}
                exit
        }

	/*
		Random effects
	*/

        if "`weight'" == "aweight" | "`weight'" == "pweight" {
                noi di in red "`weight' not allowed in random-effects case"
                exit 101
        }

	if "`offset'" != "" {
		tempvar ovar
		qui gen double `ovar' = `offset' if `touse'
		local oarg "offset(`ovar')"
	}

	quietly {
		count if `touse'
		local nobs = r(N)
                if `quad' > r(N) {
                        noi di in red "number of quadrature points " /*
                                */ "must be less than or equal to " /*
                                */ "number of obs"
                        exit 198
                }

		tokenize `varlist'
		local dep "`1'"
		mac shift
		local ind "`*'"
		noi _rmcoll `ind' if `touse', `constan'
		local ind "`r(varlist)'"
		local p : word count `ind'

                count if `dep'==0 & `touse'
                if r(N) == 0 | r(N) == `nobs' {
			di in red "outcome does not vary; remember:"
			di in red _col(35) "0 = negative outcome,"
			di in red _col(9) /*
			*/ "all other nonmissing values = positive outcome"
                        exit 2000
                }

                local k 1
                while `k' <= `p' {
                        local wrd : word `k' of `ind'
                        local names "`names' `dep':`wrd'"
                        local k = `k'+1
                }

		if "`constan'" == "" {
			local names "`names' `dep':_cons lnsig2u:_cons"
			local p = `p' + 1
		}
		else {
			local names "`names' lnsig2u:_cons"
			local skip "skip"
		}
		if "`ind'" == "" { local skip "skip" }

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
			gen double `wv' `exp' if `touse'
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

		tempname beta rho
		if "`from'" == "" {
			`lll' di in gr _n "Fitting comparison model:"
			`lll' logit `dep' `ind' if `touse' [`weight'`exp'], /*
				*/ `oarg' asis `constan' nocoef
			local llprob = e(ll)
			mat `beta' = e(b)
			mat coleq `beta' = `dep'
			local tmp = -.8
			mat `rho' = (`tmp')
			mat colnames `rho' = rho:_cons
			mat `beta' = `beta',`rho'
		}
		else {
			mat `beta' = `from'
			local skip "skip"
			local refine "norefine"
			noi di
		}
		local sna : colnames(`beta')
		local snp : word count `sna'
		if `p'+1 != `snp' {
			* Means that some predictor was dropped due to
                        * perfect prediction or user gave short from vector.
			* (in case, -asis- option should prevent)
                        if "`from'" == "" {
                                di in red "unable to identify sample"
                        }
                        else {
                                local pp1 = `p'+1
                                local nr = rowsof(`from')
                                local nc = colsof(`from')
                                di in red "`from' (`nr'x`nc') is not " _c
                                di in red "correct length " _c
                                di in red "-- should be (1x`pp1')"
                        }
                        exit 198
		}

		tempvar w
		if "`weight'" == "" {
			gen double `w' = 1 if `touse'
		}
		else {
			gen double `w' `exp' if `touse'
		}

		sort `touse' `ivar' `dep' `ind'
		tempvar p
		gen `c(obs_t)' `p' = _n if `touse'
		summ `p' if `touse', meanonly
		local j0 = r(min)
		local j1 = r(max)
		drop `p'

                if "`log'" == "" { local lll "noisily" }
                else             { local lll "quietly" }
	}
        if "`skip'" == "" {
		qui logit `dep' if `touse' [`weight'`exp'], /*
			*/ `oarg' asis
		tempname beta0
		mat `beta0' = (e(b),0)

                `lll' di in green _n "Fitting constant-only model:" _n
                _XTRENORM `dep' in `j0'/`j1', i(`ivar') w(`w') `oarg' /*
                        */ nodisplay b(`beta0') `options' /*
                        */ `clopt' logit `log' `refine'
                local ll0 = e(ll)
                local llarg "ll_0(`ll0')"
                `lll' di in green _n "Fitting full model:" _n
        }
	else if "`llprob'" != "" {
                `lll' di in green _n "Fitting full model:" _n
	}

	_XTRENORM `dep' `ind' in `j0'/`j1', i(`ivar') w(`w') `oarg' /*
		*/ b(`beta') quad(`quad') `options' logit `log' /*
		*/ `constan' `llarg' `refine'
	est local cmd
	est local r2_p
	est scalar n_quad  = `quad'
        est local intmethod "ghermite"
        est local distrib "Gaussian"
        est local title   "Random-effects logistic regression"
	est local wtype  "`weight'"
	est local wexp   `"`exp'"'
        est scalar N_g    = `ng'
        est scalar g_min  = `g1'
        est scalar g_avg  = `g2'
        est scalar g_max  = `g3'
        tempname b v
        mat `b' = e(b)
        mat `v' = e(V)
        mat colnames `b' = `names'
        mat colnames `v' = `names'
        mat rownames `v' = `names'
        est post `b' `v', depname(`dep') noclear
	if "`llprob'" != "" {
		est scalar ll_c    = `llprob'
		est scalar chi2_c  = cond([lnsig2u]_b[_cons]<=-14, 0, /*
                        */ abs(-2*(e(ll_c)-e(ll))))
		est local chi2_ct  "LR"
	}
        est scalar sigma_u = exp(.5*[lnsig2u]_b[_cons])
        est scalar rho    = e(sigma_u)^2 / ((_pi^2)/3 + e(sigma_u)^2)
	est local ivar "`ivar'"
	est local offset  "`offset'"
	est local predict "xtbin_p"
	est local cmd "xtlogit"

	if "`display'" == "" {
		DispTbl, `level' `or'
		DispLR
	}
end


program define Display
	if "`e(cmd)'" == "xtgee" {
		syntax [, OR *]
		if "`or'" != "" {
			local eform eform
		}
		noi xtgee, `options' `eform'
		exit
	}
	DispTbl `0'
	DispLR
end


program define DispTbl
	syntax [, Level(cilevel) OR]
        if "`or'" != "" { local earg "eform(OR)" }

        _crcphdr
        if "`e(cmd)'" != "clogit" { local plus "plus" }

        est display, first `plus' `earg' level(`level')

	if "`e(cmd)'" != "clogit" {
		_diparm lnsig2u, level(`level') noprob
		di in smcl in gr "{hline 13}{c +}{hline 64}"
		_diparm lnsig2u, level(`level') label("sigma_u") /*
			*/ function(exp(.5*@)) /*
			*/ derivative(.5*exp(.5*@))
		_diparm lnsig2u, level(`level') label("rho") /*
			*/ function(exp(@)/((_pi^2)/3+exp(@))) /*
			*/ derivative((_pi^2/3*exp(@))/(((_pi^2)/3+exp(@))^2))
		di in smcl in gr "{hline 13}{c BT}{hline 64}"
	}
end


program define DispLR
	if "`e(ll_c)'" != "" {
		_lrtest_note_xt, msg("LR test of rho=0")
	}

	if e(N_cd) <. {
		if e(N_cd) > 1 { local s "s" }
		di in gr _n /*
		*/ "Note: `e(N_cd)' completely determined panel`s'"
	}
end
exit

HISTORY

2.7.0  14jun2001  nodisplay option

2.6.7  04apr2001
