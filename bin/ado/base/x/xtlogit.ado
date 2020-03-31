*! version 2.16.0  21jun2018
program define xtlogit, eclass byable(onecall) prop(or xt xtbs mi)
        local XT_VV : display "version " string(_caller()) ", missing:"
	version 6.0, missing
	if _by() {
		local myby by `_byvars'`_byrc0':
	}
	`XT_VV' `myby' _vce_parserun xtlogit, panel wtypes(iw fw pw) 	///
		mark(I OFFset) : `0'

	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xtlogit `0'"'
		exit
	}

	syntax [varlist(ts fv)] [if] [in] [iweight fweight pweight] [, ///
	RE FE PA INTPoints(int 12) Quad(int 12) *]

	local tsops = "`s(tsops)'" == "true"
	
	/* version 6 so local macros restricted to 7 characters */
	if `intpoin' != 12 {
		if `quad' != 12 {
			di as err "intpoints() and quad() may not be specified together"
			exit(198)
		}
		if "`pa'" !="" || "`fe'"!=""{
			di as err "option intpoints() not allowed"
			exit 198
		}
		local options `re' `fe' `pa' `options' quad(`intpoin')
	}
	else {
		if "`pa'" !="" || "`fe'"!="" {
			if `quad' != 12 {
				di as err "option quad() not allowed"
				exit 198
			}
			local options `re' `fe' `pa' `options'
		}
		else {
			local options `re' `fe' `pa' `options' quad(`quad')
		}
	}

	if replay() {
                if "`e(cmd)'" != "xtlogit" & "`e(cmd2)'" != "xtlogit" {
                        error 301
                }
		if _by() { error 190 }
                Display `0'
                exit `e(rc)'
        }
	if (_caller() < 9.0) {
		`XT_VV' `myby' xtlogit_8 `varlist' `if' `in' 	///
			[`weight'`exp'], `options'
	}
        else if (_caller() < 11) & "`fe'"!="" & `tsops' {
                `XT_VV' `myby' xtlogit_11 `varlist' `if' `in'    ///
                        [`weight'`exp'], `options'
        } 
	else {
		global XT_VV `XT_VV'
		local c = _caller()
		`XT_VV' ///
       		cap noi `myby' Estimate `varlist' `if' `in' [`weight'`exp'], ///
			`options' call(`c')
		local rc = _rc
		macro drop XT_VV
		if (`rc') {exit `rc'}
		version 10: ereturn local cmdline `"xtlogit `0'"'
	}
end

program define Estimate, eclass byable(recall) sort
	version 6.0, missing
	local xtset : sortedby
	#delimit ;
	syntax [varlist(ts fv)] [if] [in] [iweight fweight pweight]
		, call(real) [I(varname) RE FE PA noCONstant noSKIP/*undoc*/ 
		   LRMODEL OR
		   OFFset(varname numeric) FROM(string) Quad(int 12)
		   noREFINE Level(passthru) NOLOg LOg noDISplay 
		   vce(passthru) Robust CLuster(passthru)
		   INTMethod(string) DOOPT ASIS *] ;
	#delimit cr
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11 
	local tsops = "`s(tsops)'" == "true"
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		global XT_VV : copy local vv
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
		if "`fe'" != "" | "`pa'" != "" {
			di as err "intmethod() not valid with options fe or pa"
			exit(198)
		}
		local len = length("`intmeth'")
		if "`intmeth'" != bsubstr("ghermite",1,max(2,`len')) & 	///
			"`intmeth'" != bsubstr("aghermite",1,max(3,`len')) & ///
			"`intmeth'" != bsubstr("mvaghermite",1,max(2,`len')) {
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
	if `call'<10.0 { 
		if `"`intmeth'"'=="" {
			local intmeth aghermite
			local madapt
		}
	}

	if length("`fe'`re'`pa'") > 2 {
		di in red "Choose only one of fe, re, and pa"
		exit 198
	}

	marksample touse
	markout `touse' `offset'
	_xt, i(`i')
	local ivar "`r(ivar)'"
	markout `touse' `ivar', strok

	local dep : word 1 of `varlist'
	_fv_check_depvar `dep'
	local depname `dep'
	local ind : subinstr local varlist "`dep'" ""
	local indname `ind'

	/*
		Population Averaged model
	*/

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`pa'" != "" {
		if "`lrmodel'" != "" {
			_check_lrmodel, `skip' `constan' ///
				options(`pa') indep(`indname')
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
		if "`or'"!="" {
			local eform "eform"
		}
		
		xtgee `varlist' if `touse' [`weight'`exp'], /*
			*/ fam(binomial) rc0 `farg' `level' /*
			*/ link(logit) `i' `options' `mllog' `offarg' /*
			*/ `constan' `eform' `display' /*
			*/ `vce' `robust' `cluster' `diopts'

		est local model "pa"
		est local predict xtlogit_pa_p
		if e(rc) == 0 | e(rc) == 430 {
			est local estat_cmd ""	// reset from xtgee
			est local cmd2 "xtlogit"
		}
		error e(rc)
		exit
	}

	if "`fe'" != "" {
		local vceopt "opt(OIM)"
	}
	else {
		local vceopt "opt(OIM Robust) argopt(Cluster)"
	}
	if _caller()<13 {
		local vceopt opt(OIM) old
	}
	
	if "`weight'" == "fweight" | "`weight'" == "pweight" {
		noi di in red /*
		*/ "`weight' not allowed for fixed- and random-effects cases"
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
	
	/*
		parsing for random effects and fixed effects
	*/

	_get_diopts diopts options, `options'
	mlopts mlopt rest, `options'
	local coll `s(collinear)'
	local constr `s(constraints)'
	if `"`rest'"'!="" {
		di in red `"`rest' invalid"'
		exit 198
	}

	if "`lrmodel'" != "" {
		_check_lrmodel, `skip' `constan' constraints(`constr') ///
			options(`fe' `cluster' `robust') indep(`indname')
		local skip "noskip"
	}
        else if ("`skip'" == "" | "`constan'" != "") {
                local skip  "skip"
        }

        if `quad' < 4 | `quad' > 195 {
                di in red /*
		*/ "number of quadrature points must be between 4 and 195"
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
		if `tsops' {
			qui tsset, noquery
		}
		noisily `vv' ///
		_rmcoll `ind' if `touse', `constan' `coll' `fvexp'
		local ind "`r(varlist)'"
		local p : list sizeof ind
		if `fvops' & "`coll'" == "" {
			local collopt collinear
		}
		if `"`from'"' != "" {
			local from2 from(`from')
		}
                `vv' clogit `dep' `ind' if `touse' [`weight'`exp'] , /*
                	*/ group(`ivar') `options' `offarg' `mllog' `from2' /*
			*/ nodisplay `collopt'
		if !`fvops' {
			local p = e(df_m)
		}
                quietly {
                        tempvar T touse
                        gen byte `touse' = e(sample)
                        sort `touse' `ivar'
                        by `touse' `ivar': gen `c(obs_t)' `T' = _N if `touse'
                        summarize `T' if `touse' & `ivar'!=`ivar'[_n-1], detail
                }
                est scalar N_g    = r(N)
                est scalar g_min  = r(min)
                est scalar g_avg  = r(mean)
                est scalar g_max  = r(max)
		est local depvar "`depname'"
		est local model	  "fe"
		est local predict xtlogit_fe_p
                est local ivar    "`ivar'"
                est local title   "Conditional fixed-effects logistic regression"
                est local cmd2    "xtlogit"

		if "`display'" == "" {
                	DispTbl, `level' `or' `diopts'
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
		local oarg "offset(`offset')"
	}
	if "`stdquad'" =="" {
		tempvar shat hh 
		generate double `shat' = 1
		generate double `hh' = 0
		global XTL_shat `shat' /*set global with shat variable for adapquad*/
		global XTL_hh `hh' /*set global with hh variable for adapquad */
		global XTL_noadap
	}
	tempvar qavar qwvar
	qui gen double `qavar' = .
	qui gen double `qwvar' = .
	global XTL_quad `quad'
	global XTL_qavar `qavar'
	global XTL_qwvar `qwvar'
	if "`stdquad'"!="" {
		global XTL_noadap noadap
	}
	global XTL_madapt `madapt'
	tempname lnf
	scalar `lnf' = .
	global XTL_lnf `lnf'
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
				`constan' `coll' `fvexp' logit touse(`touse')
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
			`lll' logit `dep' `ind' if `touse' [`weight'`exp'], /*
				*/ `oarg' asis `constan' nocoef /*
				*/ iter(`=min(1000,c(maxiter))') /*
				*/ `doopt' `collopt' `crittyp' `mllog'
			local llprob = e(ll)
			mat `beta' = e(b)
			mat `rho' = (0)
			mat `beta' = `beta',`rho'
			local cb = colsof(`beta')
			local nn : word count `ind'
			local nn = `nn'+2
			if "`constan'"=="noconstant" {
				local nn = `nn' - 1
			}

			if ("`constr'" != "" & "`coll'"!="" & `nn'>`cb') {
				tempname bt Vt T a C
				mat `bt' = J(1,`nn',0)
				local cnms `ind'
				if "`constan'" =="" {
					local cnms `cnms' _cons
				}
				local cnms `cnms' _cons
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
	_GetQuad, avar(`qavar') wvar(`qwvar') quad($XTL_quad)
	tempname rhov 
        if "`skip'" == "noskip" {
		`vv' ///
		qui logit `dep' if `touse' [`weight'`exp'], /*
			*/ `oarg' asis iter(`=min(1000,c(maxiter))') /*
			*/ `doopt'
		tempname beta0
		mat `beta0' = (e(b),0)
                `lll' di in green _n "Fitting constant-only model:" _n
	/// Calculate logF (by panel) used to prevent underflow
	quietly{
		mat colnames `beta0' = `dep':_cons `lnsig2u'
		tempvar xb sn
		gen double `sn' = -1 if `dep'!=0 & `touse'
		replace `sn' = 1 if `dep'==0 & `touse'
		mat score `xb' = `beta0' if `touse', eq(`dep')
		tempvar logFc
		gen double `logFc'= log(1/(1+exp(`sn'*`xb'))) if `touse'
		bys `touse' `ivar': replace `logFc'= `logFc'+`logFc'[_n-1] if _n>1 & `touse'
		bys `touse' `ivar': replace `logFc'=`logFc'[_N] if `touse'
		global XTL_logF `logFc'
		if "`stdquad'"!="" {
			drop `xb' `sn'
		}
	}
	/// done!

		if `"`refine'"' != `"norefine"' {
			`lll' _GetRho `dep'  in `j0'/`j1', ivar(`ivar') ///
				w(`w') rho(`rhov') b(`beta0') `oarg' 	///
				avar(`qavar') wvar(`qwvar') 		///
				quad(`quad') logit logF(`logFc') `crittyp'
		}
		if "`stdquad'"=="" & "`madapt'"=="" {
			_GetAdap `dep' in `j0'/`j1', shat(`shat')	///
			hh(`hh') ivar(`ivar') b(`beta0') `constan' 	///
			`oarg' logit logF(`logFc')
		}
		if  "`madapt'" != "" {
			tempvar lnfv
			qui gen double `lnfv' = .
			tempname g negH
			/* Calling the log likelihood calculator will get the
			   adaptive quadrature parameters shat and hh */
			_XTLLCalc `dep'  in `j0'/`j1', xbeta(`xb')      ///
				w(`w') lnf(`lnfv') b(`beta0') g(`g')    ///
				negH(`negH') quad($XTL_quad)            ///
				ivar(`ivar')  todo(0) `madapt' logit	///
				avar(`qavar') wvar(`qwvar')		///
				shat(`shat') hh(`hh') logF(`logFc')
		}
		if "`hh'" != "" {
		/// modify logFc for this information
			quietly{
				drop `logFc'
				replace `xb' = `xb' + `hh' if `touse'
				gen double `logFc'=                     ///
					log(1/(1+exp(`sn'*`xb')))       ///
					if `touse'
				bys `touse' `ivar': replace `logFc'=    ///
					`logFc'+`logFc'[_n-1]           ///
					if _n>1 & `touse'
				bys `touse' `ivar': replace `logFc'=    ///
					`logFc'[_N] if `touse'
				global XTL_logF `logFc'
				drop `xb' `sn'
			}
		/// done
		}
		`vv' ///
		`lll' ml model d2 xtlogit_d2 (`dep'=) /lnsig2u [iw=`w'] ///
			in `j0'/`j1', init(`beta0', copy)  maximize    ///
			`mllog' `mlopt' search(off) nopreserve nocnsnotes ///
			`negh' `crittype'
                `lll' di in green _n "Fitting full model:" _n
		local mlopt `mlopt' continue
	}
	else if "`llprob'" != "" {
                `lll' di in green _n "Fitting full model:" _n
	}

	global XTL_madapt `madapt' /* could be changed from cons. only model */
	scalar `lnf' = . /* could be changed from cons. only model */
	/// Calculate logF (by panel) used to prevent underflow
	quietly{
		tempvar xb sn
		gen double `sn' = -1 if `dep'!=0 & `touse'
		replace `sn' = 1 if `dep'==0 & `touse'
		mat score `xb' = `beta' if `touse', eq(`depstr')
		if "`offset'"!="" {
			replace `xb' = `xb' + `offset' if `touse'
		}
		tempvar logF
		gen double `logF' = log(1/(1+exp(`sn'*`xb'))) if `touse'
		bys `touse' `ivar': replace `logF' = `logF' + `logF'[_n-1] if _n>1 & `touse'
		bys `touse' `ivar': replace `logF' = `logF'[_N] if `touse'
		global XTL_logF `logF'
		if "`stdquad'"!="" {
			drop `xb' `sn'
		}
	}
	/// done!
	
	if `"`refine'"' != `"norefine"' {
		`lll' _GetRho `dep' `ind' in `j0'/`j1', ivar(`ivar') w(`w') ///
			rho(`rhov') b(`beta') `oarg' avar(`qavar')	///
			wvar(`qwvar') quad(`quad') logit logF(`logF') `crittyp'
	}
	if "`stdquad'"=="" & "`madapt'"=="" {
		_GetAdap `dep' `ind' in `j0'/`j1', shat(`shat') hh(`hh') ///
		logit ivar(`ivar') b(`beta') `constan' `oarg' logF(`logF')
	}
	if "`madapt'"!="" {
		tempvar lnfv
		qui gen double `lnfv' = .
		tempname g negH
		/* Calling the log likelihood calculator will get the
		adaptive quadrature parameters shat and hh */
		_XTLLCalc `dep' `ind' in `j0'/`j1', xbeta(`xb') w(`w')  ///
			lnf(`lnfv') b(`beta') g(`g') negH(`negH')       ///
			quad($XTL_quad) ivar(`ivar') `constan' todo(0)  ///
			`madapt' logit avar(`qavar') wvar(`qwvar')	///
			shat(`shat') hh(`hh') logF(`logF')
	}
	if "`hh'" != "" {
	/// modify logF for this information
		quietly{
			drop `logF'
			replace `xb' = `xb' + `hh'
			gen double `logF' = log(1/(1+exp(`sn'*`xb')))   ///
				if `touse'
			bys `touse' `ivar': replace `logF' = `logF' +   ///
				`logF'[_n-1] if _n>1 & `touse'
			bys `touse' `ivar': replace `logF' = `logF'[_N] ///
				if `touse'
			global XTL_logF `logF'
			drop `xb' `sn'
		}
	/// done
	}

	`vv' ///
	`lll' ml model d2 xtlogit_d2 (`depstr':`dep' = `ind', 	///
		`constan' `oarg')	///
		/lnsig2u [iw=`w'] in `j0'/`j1' , init(`beta', copy) ///
		`mllog' maximize `mlopt' search(off) nopreserve `negh' ///
		collinear missing `crittyp'
	
	if _caller() < 11 {
		tempname cns
		capture mat `cns' = get(Cns)
		if _rc==0 {
			est matrix constraint = `cns'
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
	est local title   "Random-effects logistic regression"
	est local wtype  "`weight'"
	est local wexp   `"`exp'"'
	est scalar N_g    = `ng'
	est scalar g_min  = `g1'
	est scalar g_avg  = `g2'
	est scalar g_max  = `g3'
	tempname b v
	mat `b' = e(b)
	est local depvar "`depname'"
	`vv' mat colnames `b' = `NAMES'

	if "`clust'" != "" {
		if "`xtset'" != "" {
			sort `xtset'
		}
		local 0 `0_orig'
		syntax [varlist(ts fv)] [if] [in] [iweight fweight pweight] [,*]
		local 0_orig `varlist' if `touse' [`weight'`exp'], `options'		
		`vv' _xt_robust logit `0_orig' relevel(`ivar') indeps(`oind')
		if "`clust'" !=" `ivar'" {
			capture drop `T'
			qui sort `touse' `clust'
			qui by `touse' `clust': gen `c(obs_t)' `T' = _N if `touse'
			qui summarize `T' if `touse' & `clust'!=`clust'[_n-1]
			est scalar N_clust = r(N)
		}
	}
	
	if _caller() < 11 {
		mat `v' = e(V)
		`vv' mat colnames `v' = `NAMES'
		`vv' mat rownames `v' = `NAMES'
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
	est scalar rho    = e(sigma_u)^2 / ((_pi^2)/3 + e(sigma_u)^2)
	est local ivar "`ivar'"
	est local clustvar "`clust'"
	est local offset  "`offset'"
	est local offset1  "" /* undo from ml model */
	est local model	  "re"
	est local predict xtlogit_re_p
	est hidden local covariates "`oind'"
	est hidden local constant "`constan'"
	est hidden local family1 bernoulli
	est hidden local link1 logit
	est hidden scalar cons = "`constan'" == ""
	if _caller() > 14 {
		est local marginsdefault predict(pr)
	}

	est scalar k_aux = 1
	local i 0
	est hidden local diparm`++i' lnsig2u, label("sigma_u") /*
		*/ function(exp(.5*@)) /*
		*/ derivative(.5*exp(.5*@))
	est hidden local diparm`++i' lnsig2u, label("rho") /*
		*/ function(exp(@)/((_pi^2)/3+exp(@))) /*
		*/ derivative((_pi^2/3*exp(@))/(((_pi^2)/3+exp(@))^2))
	est local cmd "xtlogit"

	if "`display'" == "" {
		DispTbl, `level' `or' `diopts'
		DispLR
	}
	
	global XTL_madapt 
	global XTL_noadap
	global XTL_qavar
	global XTL_qwvar
	global XTL_quad
	global XTL_shat
	global XTL_hh
	global XTL_logF
	global XTL_lnf
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
	DispLR, `cnsnote'
end


program define DispTbl
	syntax [, Level(cilevel) OR *]
        if "`or'" != "" { local earg "eform(Odds Ratio)" }

	_get_diopts diopts, `options'
        _crcphdr
        _coef_table, `earg' level(`level') `diopts' notest
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
exit

HISTORY

2.7.0  14jun2001  nodisplay option

2.6.7  04apr2001
