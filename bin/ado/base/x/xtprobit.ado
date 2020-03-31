*! version 2.15.0  21jun2018
program define xtprobit, eclass byable(onecall) prop(xt xtbs mi)
	version 6.0, missing
	syntax [varlist(ts fv)] [if] [in] [iweight fweight pweight] [, RE PA ///
	INTPoints(int 12) Quad(int 12) *]
	
	if _by() {
		local myby by `_byvars'`_byrc0':
	}
	local XT_VV : display "version " string(_caller()) ", missing: "
	`XT_VV' `myby' _vce_parserun xtprobit, panel mark(I OFFset) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xtprobit `0'"'
		exit
	}
	
	/* version 6 so local macros restricted to 7 characters */
	if `intpoin' != 12 {
		if `quad' != 12 {
			di as err "intpoints() and quad() may not be specified together"
			exit(198)
		}
		if "`pa'" != "" {
			di as err "option intpoints() not allowed"
			exit 198
		}
		local options `re' `pa' `options' quad(`intpoin')
	}
	else {
		if "`pa'" != "" {
			if `quad'!=12 {
				di as err "option quad() not allowed"
				exit 198
			}
			local options `re' `pa' `options'
		}
		else {
			local options `re' `pa' `options' quad(`quad')
		}
	}

	if replay() {
                if "`e(cmd)'" != "xtprobit" & "`e(cmd2)'" != "xtprobit" {
                        error 301
                }
		if _by() { error 190 }
                Display `0'
                exit `e(rc)'
        }
	if _caller() < 9.0 {
		`XT_VV' `myby' xtprobit_8 `varlist' ///
				`if' `in' [`weight'`exp'], `options'
	}
	else {
		local c = _caller()
	       `XT_VV' ///
	       `myby' Estimate `varlist' `if' `in' [`weight'`exp'], 	///
	       		`options' call(`c')
		version 10: ereturn local cmdline `"xtprobit `0'"'
	}
end

program define Estimate, eclass byable(recall) sort
	version 6.0, missing
	local xtset : sortedby
	#delimit ;
	syntax [varlist(ts fv)] [if] [in] [iweight fweight pweight] 
			, call(real) [I(varname) RE FE PA noCONstant 
			noSKIP /*undoc*/ LRMODEL
			OFFset(varname numeric) FROM(string) Quad(int 12) 
			vce(passthru) Robust CLuster(passthru)
			noREFINE Level(passthru) NOLOg LOg INTMethod(string)
			DOOPT ASIS *] ;
	#delimit cr
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11 
	local tsops = "`s(tsops)'" == "true"
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
	
	tempvar isort
	gen `c(obs_t)' `isort' = _n

	local madapt madapt
	if "`intmeth'" != "" {
		if "`pa'" != "" {
			di as err "intmethod() not valid with option pa"
			exit(198)
		}
		local len = length("`intmeth'")
		if "`intmeth'" != bsubstr("ghermite",1,max(2,`len')) & 	///
			"`intmeth'" != bsubstr("aghermite",1,max(3,`len')) & ///
			"`intmeth'" != bsubstr("mvaghermite",1,max(3,`len')) {
			di as err "intmethod() invalid -- " ///
				as inp "`intmeth'" as err " not allowed"
			exit(198)
		}
                if "`intmeth'" == bsubstr("aghermite", 1, max(3,`len')) {
                        local madapt
                        local intmeth aghermite
                }
		if "`intmeth'" == bsubstr("ghermite",1, max(2,`len')) {
			local stdquad stdquad
			local madapt 
		} 
	}

	if `call' < 10.0 { 
		if `"`intmeth'"'=="" {
			local intmeth aghermite
			local madapt
		}
	}
	if "`fe'" != "" {	
		di in red "Fixed-effects model not available"
		exit 198
	}
	if "`re'" != "" & "`pa'" != "" {
		di in red "Choose only one of re and pa"
		exit 198
	}


					/* mark sample		*/ 
	marksample touse
	markout `touse' `offset'
	_xt, i(`i')
	local ivar "`r(ivar)'"
	markout `touse' `ivar', strok

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`pa'" != "" {
		if "`lrmodel'" != "" {
			_check_lrmodel, `skip' `constan' ///
				options(`pa')
		}
		if "`offset'" != "" {
			local offarg "offset(`offset')"
		}
		if "`from'" != "" {
			local farg   "from(`from')"
		}
		if "`i'"!="" { 
			local i "i(`i')"
		}
		xtgee `varlist' if `touse' [`weight'`exp'], /*
			*/ fam(binomial) rc0 `farg' `level' /*
			*/ link(probit) `i' `options' `mllog' `offarg' /* 
			*/ `constan' `vce' `robust' `cluster' `diopts'
		est local model "pa"
		est local predict xtlogit_pa_p
		if e(rc) == 0 | e(rc) == 430 {
			est local estat_cmd ""	// reset from xtgee
			est local cmd2 "xtprobit"
		}
		error e(rc)
		exit
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

	_get_diopts diopts options, `options'
	mlopts mlopt rest, `options'
	local coll `s(collinear)'
	local constr `s(constraints)'
	if `"`rest'"'!="" {
		di in red `"`rest' invalid"'
		exit 198
	}

	gettoken y xvars : varlist
	if "`lrmodel'" != "" {
		_check_lrmodel, `skip' `constan' constraints(`constr') ///
			options(`cluster' `robust') indep(`xvars')
		local skip "noskip"
	}
	else if ("`skip'" == "" | "`constan'" != ""){
                local skip  "skip"
        }

        if `quad' < 4 | `quad' > 195 {
                di in red /*
		*/ "number of quadrature points must be between 4 and 195"
                exit 198
        }
					/* parsing complete */



	if "`offset'" != "" {
		local oarg "offset(`offset')"
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
		_fv_check_depvar `dep'
		local depname `dep'
		local depstr : subinstr local depname "." "_"
		mac shift
		local ind "`*'"
		local indname `ind'
		if `tsops' {
			qui tsset, noquery
		}
		if `fvops' & "`asis'" == "" {
			noisily `vv' ///
			_rmcoll `dep' `ind' if `touse', noskipline ///
				`constan' `coll' `fvexp' probit touse(`touse')
			local ind "`r(varlist)'"
			gettoken dep ind : ind
		}
		else {
			noisily `vv' ///
			_rmcoll `ind' if `touse', `constan' `coll' `fvexp'
			local ind "`r(varlist)'"
		}
		local p : list sizeof ind
		if `tsops' {
			tsrevar `dep'
			local dep `r(varlist)'
			local oind : copy local ind
			fvrevar `ind', tsonly
			local ind `r(varlist)'
		}
		else {
			local oind `ind'
		}
		if `fvops' {
			if `:length local constr' {
				local cnsopt constr(`constr')
			}
			local collopt collinear `cnsopt'
		}

                count if `dep'==0 & `touse'
                if r(N) == 0 | r(N) == `nobs' {
			di in red "outcome does not vary; remember:"
			di in red _col(35) "0 = negative outcome,"
			di in red _col(9) /*
			*/ "all other nonmissing values = positive outcome"
                        exit 2000
                }

		local IND : copy local ind
		local OIND : copy local oind
                local k 1
                while `k' <= `p' {
			gettoken wrd IND : IND
                        local names "`names' `dep':`wrd'"
			gettoken wrd OIND : OIND
                        local NAMES "`NAMES' `depname':`wrd'"
                        local k = `k'+1
                }

		if _caller() < 15 {
			local lnsig2u "lnsig2u:_cons"
		}
		else {
			local lnsig2u "/lnsig2u"
		}

		if "`constan'" == "" {
			local names "`names' `dep':_cons `lnsig2u'"
			local NAMES "`NAMES' `depname':_cons `lnsig2u'"
			local p = `p' + 1
		}
		else {
			local names "`names' `lnsig2u'"
			local NAMES "`NAMES' `lnsig2u'"
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
		
                local lll = cond("`log'"!="", "quietly", "noisily")

		tempname beta rho
		if "`from'" == "" {
			`lll' di in gr _n "Fitting comparison model:"
			`vv' ///
			`lll' probit `dep' `ind' if `touse' [`weight'`exp'], /*
				*/ `oarg' asis `constan' nocoef /*
				*/ iter(`=min(1000,c(maxiter))') /*
				*/ `doopt' `collopt' `crittyp' `mllog'
			local llprob = e(ll)  
			mat `beta' = e(b)
			mat `rho' = (0)
			mat `beta' = `beta',`rho'
			local cb = colsof(`beta')
			local nn : word count `ind'
			local nn = `nn' + 2
			if "`constan'"=="noconstant" {
				local nn = `nn' - 1
			}
			if ("`constr'" != "" & "`coll'"!="" & `nn'>`cb') {
				tempname bt Vt T a C
				mat `bt' = J(1,`nn',0)
				local cnms `ind'
				if "`constan'"=="" {
					local cnms `ind' _cons
				}
				local cnms `cnms' _cons2
				`vv' ///
				mat colnames `bt' = `cnms'
				`vv' ///
				mat rownames `bt' = `dep' 
				mat `Vt' = J(`nn',`nn',0)
				`vv' ///
				mat colnames `Vt' = `cnms'
				`vv' ///
				mat rownames `Vt' = `cnms'
				est post `bt' `Vt'
				makecns `constr'
				matcproc `T' `a' `C'
				_b_fill0 `beta' "`cnms'", noeq
				mat `beta' = `beta'*`T'
				mat `beta' = `beta'*`T'' + `a'
			}
			local cb = colsof(`beta')
			forv i = 2/`cb' { /* one less than cb */
				local ceq "`ceq' `depstr'"
			}
			mat coleq `beta' = `ceq' `lnsig2u'
			mat `beta'[1,`cb'] = -.8
		}
		else {
			mat `beta' = `from'
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
		
		if "`stdquad'"=="" {
			tempvar shat hh
			generate double `shat' = 1
			generate double `hh' = 0
			/* set global with shat variable for adapquad */
			global XTP_shat `shat' 
			/* set global with hh variable for adapquad */
			global XTP_hh `hh'
			global XTP_noadap
		}
		else {
			global XTP_noadap noadap
		}
		global XTP_madapt `madapt'
		tempname lnf
		scalar `lnf' = .
		global XTP_lnf `lnf'
		global XTP_quad `quad'
		tempvar qavar qwvar
		qui gen double `qavar' = .
		qui gen double `qwvar' = .
		global XTP_qavar `qavar'
		global XTP_qwvar `qwvar'
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
        if "`skip'" == "noskip" {
		`vv' ///
		qui probit `dep' if `touse' [`weight'`exp'], /*
			*/ `oarg' asis iter(`=min(1000,c(maxiter))') /*
			*/ `doopt'
		tempname beta0
		mat `beta0' = (e(b),0)
		/// Calculate logF (by panel) used to prevent underflow
		quietly{
			`vv' ///
			mat colnames `beta0' = `dep':_cons `lnsig2u'
			tempvar xb sn
			gen double `sn' = 1 if `touse' & `dep'!=0
			replace `sn' = -1 if `touse' & `dep'==0
			mat score `xb' = `beta0' if `touse', eq(`dep')
			tempvar logFc
			gen double `logFc' = lnnormal(`sn'*`xb') if `touse'
			bys `touse' `ivar': replace `logFc' = `logFc' + ///
				`logFc'[_n-1] if _n>1 & `touse'
			bys `touse' `ivar': replace `logFc' = `logFc'[_N] ///
				 if `touse'
			global XTP_logF `logFc'
			if "`stdquad'"!="" {
				drop `xb' `sn'
			}
		}
		/// done!
                `lll' di in green _n "Fitting constant-only model:" _n
		if `"`refine'"' != `"norefine"' {
			`lll' _GetRho `dep' in `j0'/`j1', 	///
				ivar(`ivar') w(`w') rho(`rhov') 	///
				b(`beta0') `oarg' probit avar(`qavar')	///
				wvar(`qwvar') quad(`quad') logF(`logFc') ///
				`crittyp'
		}
		if "`stdquad'"=="" & "`madapt'"=="" {
			`lll' _GetAdap `dep' in `j0'/`j1', i(`ivar') 	///
			w(`w') `oarg' shat(`shat') hh(`hh') b(`beta0') 	///
			`constan' probit logF(`logFc')
		}
		if "`madapt'" != "" {
			tempvar lnfv
			qui gen double `lnfv' = .
			tempname g negH
			/* Calling the log likelihood calculator will get the
			   adaptive quadrature parameters shat and hh */
			_XTLLCalc `dep'  in `j0'/`j1', xbeta(`xb')	///
				w(`w') lnf(`lnfv') b(`beta0') g(`g')	///
				negH(`negH') quad($XTP_quad)		///
				ivar(`ivar')  todo(0) `madapt' probit	///
				avar(`qavar') wvar(`qwvar')		///
				shat(`shat') hh(`hh') logF(`logFc')
		}
		if "`hh'" != "" {
		/// modify logFc for this information
			quietly {
				drop `logFc'
				replace `xb' = `xb' + `hh' if `touse'
				gen double `logFc' = lnnormal(`sn'*`xb') ///
					if `touse'
				bys `touse' `ivar': replace `logFc' =   ///
					`logFc' + `logFc'[_n-1]         ///
					if _n>1 & `touse'
				bys `touse' `ivar': replace `logFc' =   ///
					`logFc'[_N] if `touse'
				global XTP_logF `logFc'
				drop `xb' `sn'
			}
		/// done
		}
		`vv' ///
		`lll' ml model d2 xtprobit_d2 (`dep'=) /lnsig2u [iw=`w'] ///
			in `j0'/`j1', init(`beta0', copy) `mllog' max ///
			`mlopt' search(off) nopreserve nocnsnotes `negh' ///
			`crittyp'
                `lll' di in green _n "Fitting full model:" _n
		local mlopt `mlopt' continue 
        }
	else if "`llprob'" != "" {
                `lll' di in green _n "Fitting full model:" _n
	}
	global XTP_madapt `madapt' /* could be changed from cons. only model */
	scalar `lnf' = . /* could be changed from cons. only model */
	/// Calculate logF (by panel) used to prevent underflow
	quietly{
		tempvar xb sn
		gen double `sn' = 1 if `touse' & `dep'!=0
		replace `sn' = -1 if `touse' & `dep'==0
		mat score `xb' = `beta' if `touse', eq(`depstr')
		if "`offset'"!="" {
			replace `xb' = `xb' + `offset' if `touse'
		}
		tempvar logF
		gen double `logF' = lnnormal(`sn'*`xb') if `touse'
		bys `touse' `ivar': replace `logF' = `logF' + 	///
			`logF'[_n-1] if _n>1 & `touse'
		bys `touse' `ivar': replace `logF' = `logF'[_N] if `touse'
		global XTP_logF `logF'
		if "`stdquad'"!="" {
			drop `xb' `sn'
		}
	}
	/// done!

	if `"`refine'"' != `"norefine"' {
		`lll' _GetRho `dep' `ind' in `j0'/`j1', ivar(`ivar') w(`w')  ///
			rho(`rhov') b(`beta') `oarg' probit avar(`qavar') ///
			wvar(`qwvar') quad(`quad') logF(`logF') `crittyp'
	}
	if "`stdquad'" =="" & "`madapt'"=="" {
		`lll' _GetAdap `dep' `ind' in `j0'/`j1', shat(`shat') ///
			hh(`hh') probit ivar(`ivar') b(`beta') 	      ///
			`constan' `oarg' logF(`logF')
	}
	if "`madapt'"!="" {
		tempvar lnfv
		qui gen double `lnfv' = .
		tempname g negH
		/* Calling the log likelihood calculator will get the
		   adaptive quadrature parameters shat and hh */
		_XTLLCalc `dep' `ind' in `j0'/`j1', xbeta(`xb') w(`w')	///
			lnf(`lnfv') b(`beta') g(`g') negH(`negH')	///
			quad($XTP_quad) ivar(`ivar') `constan' todo(0)	///
			`madapt' probit avar(`qavar') wvar(`qwvar')	///
			shat(`shat') hh(`hh') logF(`logF')
	}
	if "`hh'" != "" {
	 /// modify logF for this information
		quietly {
			drop `logF'
			replace `xb' = `xb' + `hh' if `touse'
			gen double `logF' = lnnormal(`sn'*`xb') if `touse'
			bys `touse' `ivar': replace `logF' = `logF' +   ///
				`logF'[_n-1] if _n>1 & `touse'
			bys `touse' `ivar': replace `logF' = `logF'[_N] ///
				if `touse'
			drop `xb' `sn'
			global XTP_logF `logF'
		}
	/// done!
	}
	`vv' ///
	`lll' ml model d2 xtprobit_d2 (`depstr':`dep' = `ind', ///
		`constan' `oarg') ///
		/lnsig2u [iw=`w'] in `j0'/`j1', init(`beta', copy) ///
		`mllog' max `mlopt' search(off) nopreserve `negh' ///
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
		`vv' _xt_robust probit `0_orig' relevel(`ivar') indeps(`oind')
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

	est local depvar "`depname'"
	est local cmd
	est local r2_p
	est scalar n_quad  = `quad'
	est local intmethod "mvaghermite"
	if `"`madapt'"' == "" {
       		est local intmethod "aghermite"
	}
        if "`stdquad'" !="" {
		est local intmethod "ghermite"
	}
	est local distrib "Gaussian"
        est local title   "Random-effects probit regression"
	est local wtype  "`weight'"
	est local wexp   `"`exp'"'
        est scalar N_g    = `ng'
        est scalar g_min  = `g1'
        est scalar g_avg  = `g2'
        est scalar g_max  = `g3'
        tempname b v
        mat `b' = e(b)
	`vv' ///
        mat colnames `b' = `NAMES'
	if _caller() < 11 {
		mat `v' = e(V)
		`vv' ///
		mat colnames `v' = `NAMES'
		`vv' ///
		mat rownames `v' = `NAMES'
		est post `b' `v', depname(`depname') noclear
	}
	else {
		_ms_op_info `b'
		if r(tsops) {
			quietly tsset, noquery
		}
		est repost b=`b', rename buildfvinfo
	}
	if "`llprob'" != "" {
		est scalar ll_c    = `llprob'
		est scalar chi2_c  = cond(_b[/lnsig2u]<=-14, 0, /*
                        */ abs(-2*(e(ll_c)-e(ll))))
		est local chi2_ct  "LR"
	}
        est scalar sigma_u = exp(.5*_b[/lnsig2u])
        est scalar rho    = e(sigma_u)^2 / (1 + e(sigma_u)^2)
	est scalar k_aux = 1
        est hidden local diparm1 lnsig2u, label("sigma_u") /*
		*/ function(exp(.5*@)) /*
		*/ derivative(.5*exp(.5*@))
        est hidden local diparm2 lnsig2u, label("rho") /*
                */ function(exp(@)/(1+exp(@))) /*
                */ derivative(exp(@)/((1+exp(@))^2))
	est local ivar "`ivar'"
	est local clustvar "`clust'"
	est local offset  "`offset'"
	est local offset1 "" /* undo from ml model */
	est local model "re"
	est local predict "xtprobit_re_p"
	est local cmd "xtprobit"
	est hidden local covariates "`oind'"
	est hidden local constant "`constan'"
	est hidden local family1 bernoulli
	est hidden local link1 probit
	est hidden scalar cons = "`constan'" == ""
	if _caller() > 14 {
		est local marginsdefault predict(pr)
	}

        DispTbl, `level' `diopts'
	DispLR
	
	global XTP_madapt
	global XTP_noadap
	global XTP_qavar
	global XTP_qwvar
	global XTP_quad
	global XTP_shat
	global XTP_hh
	global XTP_logF
	global XTP_lnf
end
	
program define Display
	if "`e(cmd)'" == "xtgee" {
		noi xtgee `0'
		exit
	}
	DispTbl `0'
	DispLR, `cnsnote'
end


program define DispTbl
	syntax [, Level(cilevel) OR *]
        if "`irr'" != "" { local earg "eform(OR)" }

	_get_diopts diopts, `options'
        _crcphdr
        _coef_table, level(`level') `diopts' notest
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
