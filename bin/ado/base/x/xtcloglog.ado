*! version 2.13.0  21jun2018
program define xtcloglog, eclass byable(onecall) prop(xt xtbs mi)
	version 6, missing
	local XT_VV : display "version " string(_caller()) ", missing: "
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`XT_VV' `by' _vce_parserun xtcloglog, panel mark(I OFFset): `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xtcloglog `0'"'
		exit
	}

        if replay() {
                if "`e(cmd)'" != "xtcloglog" & "`e(cmd2)'" != "xtcloglog" & /*
		*/ "`e(cmd)'" != "xtclog" & "`e(cmd2)'" != "xtclog" {
                        error 301
                }
		if _by() { error 190 }
		if (_caller() < 9) {
			xtcloglog_8 `0'
			exit
		}
                Display `0'
                exit `e(rc)'
        }

	local cmdline : copy local 0
	syntax varlist(fv) [if] [in] [iweight fweight pweight] [, RE PA	///
		INTPoints(int 12) Quad(int 12) *]
	
	/* version 6 so local macros restricted to 7 characters */
	if `intpoin' != 12 {
		if `quad' != 12 {
			di as err "intpoints() and quad() may not be specified together"
			exit(198)
		}
		local options `re' `pa' `options' quad(`intpoin')
		if "`pa'"!="" {
			di as err "option intpoints() not allowed"
			exit 198
		}
	}
	else{
		if "`pa'" !="" {
			if `quad'!=12 {
				di as err "option quad() not allowed"
				exit 198
			}
			local options `re' `pa' `options'
		}
		else {
			local options `re' `options' quad(`quad')
		}
	}

	if (_caller() < 9) {
		`XT_VV' `by' xtcloglog_8 `varlist' `if' `in' 	///
			[`weight'`exp'], `options'
	}
	else {
		if _caller() >= 11 {
			local vv : di "version " string(_caller()) ":"
		}
		local front `varlist' `if' `in' [`weight'`exp']
		local 0 , `options'
		syntax [, RE FE PA *]
		local c = _caller()
		if "`fe'" != "" {	
			di in red "Fixed-effects model not available"
			exit 198
		}
		if "`re'" != "" & "`pa'" != "" {
			di in red "Choose only one of re and pa"
			exit 198
		}
		if "`pa'" != "" {
			`vv' ///
			`by' Estimate_pa `front',  ///
				`pa' `options'
		}
		else	`vv' `by' Estimate_re `front', ///
				`re' `options' call(`c')
		version 10: ereturn local cmdline `"xtcloglog `cmdline'"'
	}
end

program define Estimate_pa, eclass byable(recall)
	version 6, missing
	local xtset : sortedby
	syntax [varlist(fv)] [if] [in] [iweight fweight pweight] /*
		*/ [, PA Level(passthru) *]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11 
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
	}
	marksample touse
	markout `touse' `offset'
	`vv' ///
	xtgee `varlist' if `touse' [`weight'`exp'], /*
		*/ fam(binomial) link(cloglog) rc0 `level' `options'
	est local model "pa"
	est local predict xtcloglog_pa_p
	if e(rc) == 0 | e(rc) == 430 {
		est local estat_cmd ""	// reset from xtgee command
		if "$OLDCALL" != "" {
			est local cmd2 "xtclog"
		}
		else {
			est local cmd2 "xtcloglog"
		}
	}
	error e(rc)
end

program define Estimate_re, eclass byable(recall) sort
	version 6, missing
	#delimit ;
	syntax [varlist(fv)] [if] [in] [iweight fweight pweight] 
			, call(real) [RE I(varname) noCONstant 
			noSKIP/*undoc*/ LRMODEL EForm
			OFFset(varname numeric) FROM(string) Quad(int 12) 
			noREFINE Level(passthru) NOLOg LOg INTMethod(string)
			vce(passthru) Robust CLuster(passthru) doopt ASIS
			*] ;
	#delimit cr
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11 
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local negh negh
		local fvexp expand
	}
	else {
		local vv "version 8.1:"
	}
	
	local 0_orig : subinstr local 0 "asis" "", word
	
	_get_diopts diopts options, `options'
	
	tempvar isort
	gen `c(obs_t)' `isort' = _n

	if `call'<10.0 {
		if `"`intmeth'"'=="" {
			local intmeth aghermite
		}
	}
	
	local madapt madapt
	if "`intmeth'" != "" {
		local len = length("`intmeth'")
		if "`intmeth'" != bsubstr("ghermite",1,max(2,`len')) & 	///
			"`intmeth'" != bsubstr("aghermite",1,max(3,`len')) & ///
			"`intmeth'" != bsubstr("mvaghermite",1,max(2,`len')) {
			di as err "intmethod() invalid -- " ///
				as inp "`intmeth'" as err " not allowed"
			exit(198)
		}
		if "`intmeth'" == bsubstr("aghermite",1,max(3,`len')) {
			local madapt
			local intmeth aghermite
		}
		if "`intmeth'" == bsubstr("ghermite",1, max(2,`len')) {
			local stdquad stdquad
			local madapt
		} 
	}
	
						/* mark sample		*/ 
	marksample touse
	markout `touse' `offset'
	_xt, i(`i')
	local ivar "`r(ivar)'"
	markout `touse' `ivar', strok

	if "`offset'" != "" {
		tempvar ovar
		qui gen double `ovar' = `offset' if `touse'
		local oarg "offset(`ovar')"
	}

	if _caller()<13 {
		local vceopt opt(OIM) old
	}
	else {
		local vceopt "opt(OIM Robust) argopt(Cluster)"
	}
	
	if "`weight'" == "fweight" | "`weight'" == "pweight" {
		noi di in red /*
		*/ "`weight' not allowed in random-effects case"
		exit 101
        }
        
	_vce_parse, `vceopt' : [`weight'`exp'], `vce' `robust' `cluster'
	if "`r(robust)'`r(cluster)'" != "" {
		local vceerr `r(vceopt)'
		local clust `r(cluster)'
		if "`weight'" != "" {
di in smcl "{bf}{err}`weight'{sf}s not allowed with random-effects models and {bf}{err}`vceerr'"
exit 198
		}
		if "`clust'"=="" {
			local clust `ivar'
		}
		else {
			_xtreg_chk_cl2 `clust' `ivar' `touse'
		}
		local crittyp crittype(log pseudolikelihood)
		if "`intmeth'" == "aghermite" {
di in smcl "{bf}{err}intmethod(`intmeth'){sf} not allowed with random-effects models and {bf}{err}`vceerr'"
exit 198
		}
	}

	mlopts mlopt rest, `options'
	local coll `s(collinear)'
	local constr `s(constraints)'
	if `"`rest'"'!="" {
		di in red `"`rest' invalid"'
		exit 198
	}

	tokenize `varlist'
	local dep "`1'"
	_fv_check_depvar `dep'
	local depstr : subinstr local dep "." "_"
	mac shift
	local ind "`*'"

	if "`lrmodel'" != "" {
		_check_lrmodel, `skip' `constan' constraints(`constr') ///
			options(`cluster' `robust' `pa') indep(`ind')
		local skip noskip
	}	
	if "`skip'" == "" {
		local skip  "skip"
	}
	else    local skip

        if `quad' < 4 | `quad' > 195 {
                di in red /*
		*/ "number of quadrature points must be between 4 and 195"
                exit 198
        }

					/* parsing complete */

	quietly {
		count if `touse'
		local nobs = r(N)
                if `quad' > r(N) {
                        noi di in red "number of quadrature points " /*
                                */ "must be less than or equal to " /*
                                */ "number of obs"
                        exit 198
                }

		if `fvops' & "`asis'" == "" {
			noisily `vv' ///
			_rmcoll `dep' `ind' if `touse', noskipline ///
				`constan' `coll' `fvexp' logit touse(`touse')
			local ind "`r(varlist)'"
			gettoken dep ind : ind
		}
		else {
			`vv' ///
			noi _rmcoll `ind' if `touse', `constan' `coll' `fvexp'
			local ind "`r(varlist)'"
		}
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
			if _caller() < 15 {
				local names "`names' `dep':_cons lnsig2u:_cons"
			}
			else {
				local names "`names' `dep':_cons /lnsig2u"
			}
			local p = `p' + 1
		}
		else {
			if _caller() < 15 {
				local names "`names' lnsig2u:_cons"
			}
			else {
				local names "`names' /lnsig2u"
			}
			local skip "skip"
		}
		if "`ind'" == "" { local skip "skip" } 

		if "`from'" != "" {
			local arg `from'
			tempname from
			`vv' ///
			noi _mkvec `from', from(`arg') colnames(`names') /*
				*/ error("from()")
		}

		if "`clust'" != "" {
			noi _xt_check_cns, cns(`constr') names(`names') `vce'
		}

		tempvar T
                sort `touse' `ivar' `isort'
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
		
		local mllog `log' `nolog'
		_parse_iterlog, `log' `nolog'
		local log "`s(nolog)'"		
                local lll = cond("`log'"!="", "quietly", "noisily")

		tempname beta rho
		if "`from'" == "" {
			`lll' di in gr _n "Fitting comparison model:"
			`vv' ///
			`lll' cloglog `dep' `ind' if `touse' [`weight'`exp'], /*
				*/ `oarg' asis `constan' nodisplay /*
				*/ `mlopt' `doopt' `vce'`robust'`cluster' /*
				*/ `mllog'
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
			local refine "norefine"
			noi di 
		}
		version 11: ///
		mat colnames `beta' = `ind' _cons
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
		
		if "`stdquad'"=="" {
			tempvar shat hh
			generate double `shat' = 1
			generate double `hh' = 0
			/* set global with shat variable for adapquad */
			global XTC_shat `shat'
			/* set global with hh variable for adapquad */
			global XTC_hh `hh'
			global XTC_noadap 
		}
		else {
			global XTC_noadap noadap
		}
		global XTC_quad `quad'
		tempvar qavar qwvar
		qui gen double `qavar' = .
		qui gen double `qwvar' = .
		global XTC_qavar `qavar'
		global XTC_qwvar `qwvar'
		global XTC_madapt `madapt'
		tempname lnf
		scalar `lnf' = .
		global XTC_lnf `lnf'
		sort `touse' `ivar' `isort'
		tempvar p
		gen `c(obs_t)' `p' = _n if `touse'
		summ `p' if `touse', meanonly
		local j0 = r(min)
		local j1 = r(max)
		drop `p'

                if "`log'" == "" { local lll "noisily" }
                else             { local lll "quietly" }
	}
	_GetQuad, avar(`qavar') wvar(`qwvar') quad(`quad')
	tempname rhov
        if "`skip'" == "" {
		qui cloglog `dep' if `touse' [`weight'`exp'], /*
			*/ `oarg' asis `doopt'
		tempname beta0
		mat `beta0' = (e(b),0)

                `lll' di in green _n "Fitting constant-only model:" _n
		/// Calculate logF (by panel) to prevent underflow
		quietly{
			if _caller() < 15 {
				mat colnames `beta0' = `dep':_cons lnsig2u:_cons
			}
			else {
				mat colnames `beta0' = `dep':_cons /lnsig2u
			}
			tempvar xb sn
			gen double `sn' = 1 if `dep'!=0 & `touse'
			replace `sn' = -1 if `dep'==0 & `touse'
			mat score `xb' = `beta0' if `touse', eq(`dep')
			tempvar logFc
			gen double `logFc' = log((`sn'==1) -`sn'* exp(-exp(`xb'))) if `touse'
			bys `touse' `ivar': replace `logFc' = `logFc' + `logFc'[_n-1] if _n>1 & `touse'
			bys `touse' `ivar': replace `logFc' = `logFc'[_N] if `touse'
			global XTC_logF `logFc'
			if "`stdquad'"!="" {
				drop `xb' `sn'
			}
		}
		/// done

		if `"`refine'"' != `"norefine"' {
			`lll' _GetRho `dep' in `j0'/`j1', ivar(`ivar') ///
				w(`w') rho(`rhov') b(`beta0') `oarg'   ///
				avar(`qavar') wvar(`qwvar') quad(`quad') ///
				cloglog logF(`logFc') `crittyp'
		}
		if "`stdquad'"=="" & "`madapt'"=="" {
			`lll' _GetAdap `dep' in `j0'/`j1', i(`ivar') w(`w') ///
			`oarg' shat(`shat') hh(`hh') b(`beta0') 	///
			`constan' cloglog logF(`logFc')
		}
		if "`madapt'"!="" {
			tempvar lnfv
			qui gen double `lnfv' = .
			tempname g negH
			/* Calling the log likelihood calculator will get the
			   adaptive quadrature parameters shat and hh */
			_XTLLCalc `dep'  in `j0'/`j1', xbeta(`xb')      ///
				w(`w') lnf(`lnfv') b(`beta0') g(`g')    ///
				negH(`negH') quad($XTC_quad)            ///
				ivar(`ivar')  todo(0) `madapt' cloglog  ///
				avar(`qavar') wvar(`qwvar')             ///
				shat(`shat') hh(`hh') logF(`logFc')
		}
		if "`hh'" != "" {
			/// modify logFc for this information
			quietly {
				drop `logFc'
				replace `xb' = `xb' + `hh' if `touse'
				gen double `logFc' = log((`sn'==1) -    ///
					`sn'*exp(-exp(`xb'))) if `touse'
				bys `touse' `ivar': replace `logFc' =   ///
					`logFc' + `logFc'[_n-1]         ///
					if _n>1 & `touse'
				bys `touse' `ivar': replace `logFc' =   ///
					`logFc'[_N] if `touse'
				global XTC_logF `logFc'
				drop `xb' `sn'
			}
		/// done
		}
		`vv' ///
		`lll' ml model d2 xtcloglog_d2 (`dep'=) /lnsig2u [iw=`w']   ///
		        in `j0'/`j1', init(`beta0', copy) `mllog' max     ///
			`options' search(off) nopreserve nocnsnotes `negh' ///
			`crittyp'
                `lll' di in green _n "Fitting full model:" _n
		local options `options' continue
        }
	else if "`llprob'" != "" {
                `lll' di in green _n "Fitting full model:" _n
	}
	global XTC_madapt `madapt' /* could be changed from cons. only model */
	scalar `lnf' = . /* could be changed from cons. only model */
	/// Calculate logF (by panel) used to prevent underflow
	quietly {
		tempvar xb sn
		gen double `sn' = 1 if `dep'!=0 & `touse'
		replace `sn' = -1 if `dep'==0 & `touse'
		mat score `xb' = `beta' if `touse', eq(`dep')
		if "`offset'"!="" {
			replace `xb' = `xb' + `offset' if `touse'
		}
		tempvar logF
		gen double `logF' = log((`sn'==1) - `sn'*exp(-exp(`xb'))) if `touse'
		bys `touse' `ivar': replace `logF' = `logF' + `logF'[_n-1] if _n>1 & `touse'
		bys `touse' `ivar': replace `logF' = `logF'[_N] if `touse'
		global XTC_logF `logF'
		if "`stdquad'"!="" {
			drop `xb' `sn'
		}
	}
	/// done
	if `"`refine'"' != `"norefine"' {
		 `lll' _GetRho `dep' `ind' in `j0'/`j1', ivar(`ivar') 	///
		 	w(`w') rho(`rhov') b(`beta') `oarg' avar(`qavar') ///
			wvar(`qwvar') quad(`quad') cloglog logF(`logF') ///
			`crittyp'
	}
	if "`stdquad'"=="" & "`madapt'"=="" {
		`lll' _GetAdap `dep' `ind' in `j0'/`j1', shat(`shat') ///
		 hh(`hh') cloglog ivar(`ivar') b(`beta') `constan'    ///
		`oarg' logF(`logF')
	}
	if "`madapt'" != "" {
		tempvar lnfv
		qui gen double `lnfv' = .
		tempname g negH
		/* Calling the log likelihood calculator will get the
		   adaptive quadrature parameters shat and hh */
		_XTLLCalc `dep' `ind' in `j0'/`j1', xbeta(`xb') w(`w')  ///
			lnf(`lnfv') b(`beta') g(`g') negH(`negH')       ///
			quad($XTC_quad) ivar(`ivar') `constan' todo(0)  ///
			`madapt' cloglog avar(`qavar') wvar(`qwvar') ///
			shat(`shat') hh(`hh') logF(`logF')
	}
	if "`hh'" != "" {
		/// modify logF for this information
		quietly {
			drop `logF'
			replace `xb' = `xb' + `hh' if `touse'
			gen double `logF' = log((`sn'==1) -     ///
				`sn'*exp(-exp(`xb'))) if `touse'
			bys `touse' `ivar': replace `logF' = `logF' +   ///
				`logF'[_n-1] if _n>1 & `touse'
			bys `touse' `ivar': replace `logF' = `logF'[_N] ///
				if `touse'
			global XTC_logF `logF'
			drop `xb' `sn'
		}
		/// done

	}
	`vv' ///
	`lll' ml model d2 xtcloglog_d2 (`depstr':`dep' = `ind',    ///
		`constan' `oarg') 	///
	        /lnsig2u [iw=`w'] in `j0'/`j1', init(`beta', copy) ///
		`mllog' max `options' search(off) nopreserve `negh' ///
		collinear missing `crittyp'
					
	if _caller() < 11 {
		tempname cns
		capture mat `cns' = get(Cns)
		if _rc==0 {
			est matrix constraint = `cns'
		}
	}
	
	if "`clust'" != "" {
		if "`xtset'" != "" {
			sort `xtset'
		}
		local 0 `0_orig'
		syntax [varlist(ts fv)] [if] [in] [iweight fweight pweight] [,*]
		local 0_orig `varlist' if `touse' [`weight'`exp'], `options'
		`vv' _xt_robust cloglog `0_orig' relevel(`ivar') indeps(`ind')
		if "`clust'" !=" `ivar'" {
			capture drop `T'
			qui sort `touse' `clust'
			qui by `touse' `clust': gen `c(obs_t)' `T' = _N if `touse'
			qui summarize `T' if `touse' & `clust'!=`clust'[_n-1]
			est scalar N_clust = r(N)
		}
	}

	_b_pclass PCDEF : default
	_b_pclass PCAUX : aux
	tempname pclass
	matrix `pclass' = e(b)
	local dim = colsof(`pclass')
	matrix `pclass'[1,1] = J(1,`dim',`PCDEF')
	matrix `pclass'[1,`dim'] = `PCAUX'
	est hidden matrix b_pclass `pclass'

	est local cmd
	est local r2_p
	est scalar n_quad  = `quad'
	est local intmethod "mvaghermite"
	if `"`madapt'"'=="" {
       		est local intmethod "aghermite"
	}
        if "`stdquad'" !="" {
		est local intmethod "ghermite"
	}
	est local distrib "Gaussian"
        est local title   "Random-effects complementary log-log model"
	est local wtype  "`weight'"
	est local wexp   `"`exp'"'
        est scalar N_g    = `ng'
        est scalar g_min  = `g1'
        est scalar g_avg  = `g2'
        est scalar g_max  = `g3'
        tempname b v
        mat `b' = e(b)
	version 11: ///
        mat colnames `b' = `names'
	if _caller() < 11 {
        	mat `v' = e(V)
		version 11: ///
        	mat colnames `v' = `names'
		version 11: ///
        	mat rownames `v' = `names'
        	est post `b' `v', depname(`dep') noclear buildfvinfo
	}
	else {
		est repost b=`b', rename buildfvinfo
	}
	if "`llprob'" != "" {
		est scalar ll_c    = `llprob'
		est scalar chi2_c  = cond(_b[/lnsig2u]<=-14, 0, /*
			*/ abs(-2*(e(ll_c)-e(ll))))
		est local chi2_ct  "LR"
	}
        est scalar sigma_u = exp(.5*_b[/lnsig2u])
        *est scalar rho    = e(sigma_u)^2 / (1 + e(sigma_u)^2) 
        est scalar rho    = e(sigma_u)^2 / (_pi^2/6 + e(sigma_u)^2)
	est local ivar "`ivar'"
	est local clustvar "`clust'"
	est local offset1 "" /* undo from ml model */
	est local offset  "`offset'"
	est local model "re"
	est local predict "xtcloglog_re_p"
	est scalar k_aux = 1
	local i 0
	est hidden local diparm`++i' lnsig2u, label("sigma_u") /*
		*/ function(exp(.5*@)) /*
		*/ derivative(.5*exp(.5*@))
	est hidden local diparm`++i' lnsig2u, label("rho") /*
		*/ function(exp(@)/(_pi^2/6+exp(@))) /*
		*/ derivative((_pi^2/6*exp(@))/((_pi^2/6+exp(@))^2))
	if "$OLDCALL" != "" {
		est local cmd "xtclog"
	}
	else {
		est local cmd "xtcloglog"
	}
	est hidden local covariates "`ind'"
	est hidden local constant "`constan'"
	est hidden local family1 bernoulli
	est hidden local link1 cloglog
	est hidden scalar cons = "`constan'" == ""
	if _caller() > 14 {
		est local marginsdefault predict(pr)
	}

        DispTbl, `level' `eform' `diopts'
	DispLR
	
        global XTC_madapt
        global XTC_noadap
        global XTC_qavar
        global XTC_qwvar
        global XTC_quad
        global XTC_shat
        global XTC_hh
	global XTC_logF
	global XTC_lnf
end
	
program define Display
	if "`e(cmd)'" == "xtgee" {
		noi xtgee `0'
		exit
	}
	DispTbl `0'
	DispLR
end


program define DispTbl
	syntax [, Level(cilevel) EForm *]
	_get_diopts diopts, `options'
        _crcphdr
        _coef_table, level(`level') `eform' `diopts' notest
end


program define DispLR

	if "`e(ll_c)'" != "" & "`e(vce)'" != "robust" {
		_lrtest_note_xt, msg("LR test of rho=0")
	}

	if e(N_cd) < . {
		if e(N_cd) > 1 { local s "s" }
		di in gr _n /*
		*/ "Note: `e(N_cd)' completely determined panel`s'"
	}
end
