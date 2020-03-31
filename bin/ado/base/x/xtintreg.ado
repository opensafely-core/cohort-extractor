*! version 2.13.0  21jun2018
program define xtintreg, eclass byable(onecall) prop(xt xtbs)
	version 6.0, missing
	syntax [varlist(ts fv)] [if] [in] [iweight] [, ///
		INTPoints(int 12) Quad(int 12) *]

	/* version 6 so local macros restricted to 7 characters */
	if `intpoin' != 12 {
		if `quad' != 12 {
			di as err "intpoints() and quad() may not be specified together"
			exit(198)
		}
		local options `options' quad(`intpoin')
	}
	else {
		local options `options' quad(`quad')
	}


	local myw `"[ `weight' `exp' ]"'
	local weight
	local exp
	local XT_VV : di "version " string(_caller()) ", missing: "

	if _by() {
        	local myby by `_byvars'`_byrc0':
	}
	`XT_VV' `myby' _vce_parserun xtintreg, panel mark(I OFFset): `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xtintreg `0'"'
		exit
	}

        if "`1'" == "" | "`1'" == "," {
                if "`e(cmd)'" != "xtintreg" { error 301 }
		if _by() { error 190 }
                Display `0'
                exit
        }

	local cmdline : copy local 0
	local c = _caller()
	if (_caller()< 9) {
		`XT_VV' `myby' xtintreg_8 `varlist' `if' `in'  ///
			`myw', `options'
	}
        else {
		if _caller() >= 11 {
			local vv : di "version " string(_caller()) ":"
		}
		`vv' ///
		`myby' Estimate `varlist' `if' `in' `myw', `options' call(`c')
		version 10: ereturn local cmdline `"xtintreg `cmdline'"'
	}
end

program define Estimate, eclass byable(recall) sort
	version 6.0, missing
	
	syntax [varlist(ts fv)] [if] [in] [iweight/] 		///
			, call(real) [I(varname) RE FE PA 	///
			noSKIP					/// undoc
	 		LRMODEL noREFINE intreg			///
			OFFset(varname numeric) FROM(string) Quad(int 12)  ///
			noCONstant Level(passthru) NOLOg LOg ///
				INTMethod(string) ///
			vce(passthru) Robust CLuster(passthru)	///
			*]
	if _caller() >= 15 {
		local intreg intreg
	}
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

	_get_diopts diopts options, `options' `level'
	if `"`vce'`robust'`cluster'"' != "" {
		_vce_parse, opt(OIM) old				///
			: [`weight'`exp'], `vce' `robust' `cluster'
	}

	tempvar isort
	gen `c(obs_t)' `isort' = _n

	if `call' < 10.0 {
		if `"`intmeth'"' == "" {
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
		}
		if "`intmeth'" == bsubstr("ghermite",1, max(2,`len')) {
			local stdquad stdquad
			local madapt
		} 
	}
	
	mlopts mlopt, `options'
	local coll `s(collinear)'
	local constr `s(constraints)'
	_xt, i(`i')
	local ivar "`r(ivar)'"

	if "`offset'" != "" {
		tempvar ovar
		gen double `ovar' = `offset'
		local oarg "offset(`ovar')"
	}
	if "`stdquad'"=="" {
		tempvar shat hh
		generate double `shat' = 1
		generate double `hh' = 0
		global XTI_shat `shat' /*set global with shat variable for adapquad */
		global XTI_hh `hh' /*set global with hh variable for adapquad*/
		global XTI_noadap 
	}
	else {
		global XTI_noadap noadap
	}
	tempvar qavar qwvar
	qui gen double `qavar' = .
	qui gen double `qwvar' = .
	global XTI_qavar `qavar'
	global XTI_qwvar `qwvar'
	global XTI_quad `quad'
	global XTI_madapt `madapt'
	tempname lnf
	scalar `lnf' = .
	global XTI_lnf `lnf'
	if "`fe'" != "" {	
		di in red "Fixed-effects model not available"
		exit 198
	}
	if "`pa'" != "" {	
		di in red "Population-averaged model not available"
		exit 198
	}

        if `quad' < 4 | `quad' > 195 {
                di in red "number of quadrature points must be between 4 and 195"

                exit 198
        }

	if _caller() < 15 {
		local sigu "sigma_u:_cons"
		local sige "sigma_e:_cons"
	}
	else {
		local sigu /sigma_u
		local sige /sigma_e
	}

	quietly {
		if "`weight'" != "" {
			local wtexp "[`weight'=`exp']"
		}

		/* NOTE:  VERY VERY VERY carefully mark the sample
			Remember that there are two dependent variables
			where one of them could be missing to denote
			censoring.
		*/
		
		tempvar touse
		mark `touse' `if' `in' `wtexp'
		markout `touse' `ovar'
		markout `touse' `ivar', strok

		tokenize `varlist'
		local dep1 "`1'"
		local dep1str : subinstr local dep1 "." "_"
		local dep2 "`2'"
		_fv_check_depvar `dep1' `dep2'
		local depname "`dep1' `dep2'"
		replace `touse' = 0 if `dep1'>=. & `dep2'>=. 
		mac shift 2
		local ind "`*'"
		markout `touse' `ind'
		local indnm `ind'
		if `tsops' {
			qui tsset, noquery
		}
		noisily `vv' ///
		_rmcoll `ind' if `touse', `constan' `coll' `fvexp'
		local ind "`r(varlist)'"
		local p : list sizeof ind
		if `tsops' {
			tsrevar `dep1'
			local dep1 `r(varlist)'
			tsrevar `dep2'
			local dep2 `r(varlist)'
			local oind : copy local ind
			fvrevar `ind', tsonly
			local ind `r(varlist)'
		}

		/* Sample is now set */

		count if `touse'
                if `quad' > r(N) {
                        noi di in red "number of quadrature points " /*
                                */ "must be less than or equal to " /*
                                */ "number of obs"
                        exit 198
                }

		count if `dep1' > `dep2' & `dep1' <. & `dep2' <.
                if r(N) > 0 {
                        di in red "observations with `dep1' > `dep2' " /*
				*/ "not allowed"
                        exit 198
                }

		if "`lrmodel'" != "" {
			_check_lrmodel, `skip' `constan' constr(`constr') ///
				options(`cluster' `robust') indep(`ind')
			local skip noskip
		}

                tempvar T
		tempvar cvar
		global XTI_cvar `cvar'
		gen byte `cvar' = 1 if `dep1'==`dep2'
		replace `cvar' = 2 if `dep1'>=. & `dep2'<.
		replace `cvar' = 3 if `dep1'<. & `dep2'>=.
		replace `cvar' = 4 if `dep1'<. & `dep2'<. & `dep1'<`dep2'
		replace `cvar' = 0 if `touse' == 0
		sort `touse' `ivar' `cvar' `isort'
                if "`weight'" != "" {
                        tempvar wv
                        gen double `wv' = `exp'
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
                if "`log'" == "" { local lll "noisily" }
                else             { local lll "quietly" }
		tempvar ys
		gen double `ys' = (`dep1'+`dep2')/2 if `touse' 
		replace `ys' = `dep1' if `dep1'<. & `ys'>=.
		replace `ys' = `dep2' if `dep2'<. & `ys'>=.

		tempname beta beta0
		if "`from'" == "" & "`intreg'" != "" {
			`lll' di in gr _n "Fitting comparison model:"
			`vv' ///
			`lll' intreg `dep1' `dep2' `ind' /*
				*/ if `touse' `wtexp', `oarg' /*
				*/ nodisplay `constan' `mlopt' `mllog'
			local llprob = e(ll)  
		} 
		if "`from'" == "" {
			`lll' di in gr _n "Obtaining starting values for " /*
				*/ "full model:"
			`vv' ///
			`lll' xtreg `ys' `ind' if `touse', sortst /*
				*/ i(`ivar') mle nodisp skip `constan' /*
				*/ collinear `mllog'
			mat `beta' = e(b)
			local cb = colsof(`beta')
			local nn : word count `ind'
			local nn = `nn' + 2 + ("`constan'" == "")
			if ("`constr'" != "" & "`coll'"!="" & `nn'>`cb') {
				tempname bt Vt T a C
				mat `bt' = J(1,`nn',0)
				foreach j of local ind {
					local cnms "`cnms' `ys':`j'"
				}
				if "`constan'" == "" {
					local cnms "`cnms' `ys':_cons"
				}
				local cnms "`cnms' `sigu' `sige'"
				`vv' ///
				mat colnames `bt' = `cnms'
				`vv' ///
				mat rownames `bt' = `dep'
				mat `Vt' = J(`nn',`nn',0)
				`vv' ///
				mat colnames `Vt' = `cnms'
				`vv' ///
				mat rownames `Vt' = `cnms'
				local xx : colna `bt'
				est post `bt' `Vt'
				makecns `constr'
				matcproc `T' `a' `C'
				_b_fill0 `beta' "`xx'", noeq
				mat `beta' = `beta'*`T'
				mat `beta' = `beta'*`T'' + `a'
			}
		}

		local IND : copy local ind
		local OIND : copy local oind
                local k 1
                while `k' <= `p' {
			gettoken wrd IND : IND
                        local names "`names' `dep1str':`wrd'"
			gettoken wrd OIND : OIND
                        local NAMES "`NAMES' `dep1str':`wrd'"
                        local k = `k'+1
                }
		if "`constan'" == "" {
			local names "`names' `dep1str':_cons `sigu' "
			local names "`names' `sige'"
			local NAMES "`NAMES' `dep1str':_cons `sigu' "
			local NAMES "`NAMES' `sige'"
		}
		else {
			local names "`names' `sigu' `sige'"
			local NAMES "`NAMES' `sigu' `sige'"
			local skip 
		}	

		if "`ind'" == "" | "`constan'" != "" { local skip }

                if "`from'" != "" {
                        local arg `from'
                        tempname from
			`vv' ///
                        noi _mkvec `from', from(`arg') colnames(`names') /*
                                */ error("from()")
			mat `beta' = `from'
                        local refine "norefine"
			noi di 
		}
		`vv' ///
		mat colnames `beta' = `names'


		if "`skip'" != "" {
			`lll' di in gr _n "Obtaining starting values for " /*
				*/ "constant-only model:"
			`vv' ///
			`lll' xtreg `ys' if `touse', i(`ivar') mle nodisp ///
				sortst 	`mllog' 
			mat `beta0' = e(b)
		/// Calculate logF (by panel) used to prevent underflow
			tempname se_p se
			mat `se_p' = `beta0'[1, "/sigma_e"]
			scalar `se' = `se_p'[1,1]
			tempvar xb
			matrix score `xb' = `beta0' if `touse', eq(`ys')
			tempvar logFc y2mD y1mD
			gen double `y2mD' = (`dep2' - `xb')/scalar(`se') ///
				if `touse'
			gen double `y1mD' = (`dep1' - `xb')/scalar(`se') ///
				if `touse'

			gen double `logFc' = -(`y1mD')^2/2 -            ///
				log(sqrt(2*_pi)) - log(scalar(`se'))    ///
				if `touse' & `cvar'==1
			replace `logFc' = lnnormal(`y2mD')      ///
				if `touse' & `cvar'==2
			replace `logFc' = lnnormal(-`y1mD')     ///
				if `touse' & `cvar'==3
			replace `logFc' = log(normal(`y2mD') - ///
				normal(`y1mD')) if `touse' & `cvar'==4
			replace `logFc' = 0 if missing(`logFc') & `touse'
			bys `touse' `ivar': replace `logFc' = `logFc' + ///
				`logFc'[_n-1] if _n>1 & `touse'
			bys `touse' `ivar': replace `logFc' = `logFc'[_N] ///
				if `touse'
			global XTI_logF `logFc'
			drop `y1mD' `y2mD'
			if "`stdquad'" != "" {
				drop `xb'
			}
		/// done!

		}

		tempvar w
		if "`weight'" == "" {
			gen double `w' = 1 if `touse'
		}
		else {
			gen double `w' = `exp' if `touse'
		}

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
		count if `touse' & `cvar' == 4
		local N_c4 = r(N)

		tempvar p
		gen `c(obs_t)' `p' = _n*`touse'
		summ `p' if `touse', meanonly
		local j0 = r(min)
		local j1 = r(max)
		local ca "cvar(`cvar')"
	}
	_GetQuad, avar(`qavar') wvar(`qwvar') quad(`quad')
	if "`skip'" != "" {
		`lll' di in green _n "Fitting constant-only model:"
		if "`stdquad'"=="" & "`madapt'"=="" {
			_GetAdap `dep1' `dep2' in `j0'/`j1', shat(`shat')  ///
			hh(`hh') ivar(`ivar') b(`beta0') `constan' `oarg'  ///
			intreg `ca' logF(`logFc')
		}
		if "`madapt'" != "" {
			tempvar lnfv
			qui gen double `lnfv' = .
			tempname g negH
			/* Calling the log likelihood calculator will get the
			   adaptive quadrature parameters shat and hh */
			_XTLLCalc `dep1' `dep2'  in `j0'/`j1', xbeta(`xb') ///
				w(`w') lnf(`lnfv') b(`beta0') g(`g')	///
				negH(`negH') quad($XTI_quad)		///
				ivar(`ivar')  todo(0) `madapt' intreg	///
				avar(`qavar') wvar(`qwvar') cvar(`cvar') ///
				shat(`shat') hh(`hh') logF(`logFc')
		}
		if "`hh'" != "" {
			/// modify logFc for this information
			quietly{
				drop `logFc'
				replace `xb' = `xb' + `hh'
				gen double `y2mD' = (`dep2' - `xb')/    ///
					scalar(`se') if `touse'
				gen double `y1mD' = (`dep1' - `xb')/    ///
					scalar(`se') if `touse'
				gen double `logFc' = -(`y1mD')^2/2 -    ///
					log(sqrt(2*_pi)) -              ///
					log(scalar(`se'))               ///
					if `touse' & `cvar'==1
				replace `logFc' = lnnormal(`y2mD')      ///
					if `touse' & `cvar'==2
				replace `logFc' = lnnormal(-`y1mD')     ///
					if `touse' & `cvar'==3
				replace `logFc' = log(normal(`y2mD') - ///
					normal(`y1mD')) if `touse' & `cvar'==4
				replace `logFc' = 0 if missing(`logFc') ///
					& `touse'
				bys `touse' `ivar': replace `logFc' =   ///
					`logFc' + `logFc'[_n-1]         ///
					if _n>1 & `touse'
				bys `touse' `ivar': replace `logFc' =   ///
					`logFc'[_N] if `touse'
				global XTI_logF `logFc'
				drop `xb' `y1mD' `y2mD'
			}
			/// done
		}
		`vv' ///
		`lll' ml model d2 xtintreg_d2 			           ///
			(`dep1' `dep2' = , `constan' `oarg') /sigma_u      ///
			/sigma_e [iw=`w'] in `j0'/`j1', init(`beta0', copy) ///
			maximize `mllog' `mlopt' missing search(off)	   ///
			nopreserve nocnsnotes `negh' collinear missing
		local mlopt `mlopt' continue
	}
	`lll' di in green _n "Fitting full model:" 
	global XTI_madapt `madapt' /* could be changed from cons. only model */
	scalar `lnf' = . /* could be changed from cons. only model */
	/// Calculate logF (by panel) used to prevent underflow
	quietly{
		tempname se_p se
		mat `se_p' = `beta'[1, "/sigma_e"]
		scalar `se' = `se_p'[1,1]
		tempvar xb
		matrix score `xb' = `beta' if `touse', eq(`dep1str')
		if "`offset'"!="" {
			replace `xb' = `xb' + `offset' if `touse'
		}
		tempvar logF  y2mD y1mD
		gen double `y2mD' = (`dep2' - `xb')/scalar(`se') ///
			if `touse'
		gen double `y1mD' = (`dep1' - `xb')/scalar(`se') ///
			if `touse'

		gen double `logF' = -(`y1mD')^2/2 -             ///
			log(sqrt(2*_pi)) - log(scalar(`se'))    ///
			if `touse' & `cvar'==1
		replace `logF' = lnnormal(`y2mD')       ///
			if `touse' & `cvar'==2
		replace `logF' = lnnormal(-`y1mD')      ///
			if `touse' & `cvar'==3
		replace `logF' = log(normal(`y2mD') - ///
			normal(`y1mD')) if `touse' & `cvar'==4
		replace `logF' = 0 if missing(`logF') & `touse'
			bys `touse' `ivar': replace `logF' = `logF' +   ///
			`logF'[_n-1] if _n>1 & `touse'
		bys `touse' `ivar': replace `logF' = `logF'[_N] ///
			if `touse'
		global XTI_logF `logF'
		drop `y1mD' `y2mD'
		if "`stdquad'"!=""{
			drop `xb'
		}
	}
	/// done!

	if "`stdquad'"=="" & "`madapt'"=="" {
		_GetAdap `dep1' `dep2' `ind' in `j0'/`j1', ///
		shat(`shat') hh(`hh') intreg ivar(`ivar') b(`beta') ///
		`constan' `oarg' `ca' logF(`logF')
	}
	if "`madapt'" != "" {
		tempvar lnfv
		qui gen double `lnfv' = .
		tempname g negH
		/* Calling the log likelihood calculator will get the
		   adaptive quadrature parameters shat and hh */
		_XTLLCalc `dep1' `dep2' `ind' in `j0'/`j1', xbeta(`xb')	///
			w(`w') lnf(`lnfv') b(`beta') g(`g') negH(`negH') ///
			quad($XTI_quad) ivar(`ivar') `constan' todo(0)	///
			`madapt' intreg avar(`qavar') wvar(`qwvar')	///
			shat(`shat') hh(`hh') logF(`logF') cvar(`cvar')
	}
	if "`hh'" != "" {
		/// modify logF for this information
		quietly{
			drop `logF'
			replace `xb' = `xb' + `hh' if `touse'
			gen double `y2mD' = (`dep2' - `xb')/    ///
				scalar(`se') if `touse'
			gen double `y1mD' = (`dep1' - `xb')/    ///
				scalar(`se') if `touse'
			gen double `logF' = -(`y1mD')^2/2 -     ///
				log(sqrt(2*_pi)) -              ///
				log(scalar(`se'))               ///
				if `touse' & `cvar'==1
			replace `logF' = lnnormal(`y2mD')       ///
				if `touse' & `cvar'==2
			replace `logF' = lnnormal(-`y1mD')      ///
				if `touse' & `cvar'==3
			replace `logF' = log(normal(`y2mD') - ///
				normal(`y1mD')) if `touse' & `cvar'==4
			replace `logF' = 0 if missing(`logF')   ///
				& `touse'
			bys `touse' `ivar': replace `logF' =    ///
				`logF' + `logF'[_n-1]   if _n>1 & `touse'
			bys `touse' `ivar': replace `logF' =    ///
				`logF'[_N] if `touse'
			global XTI_logF `logF'
			drop `xb' `y1mD' `y2mD'
		}
		/// done
	}
	`vv' ///
	`lll' ml model d2 xtintreg_d2 				   ///
		(`dep1' `dep2' = `ind', `constan' `oarg') /sigma_u /sigma_e ///
		[iw=`w'] in `j0'/`j1', init(`beta', copy) `mllog' maximize   ///
		`mlopt' collinear missing search(off) nopreserve `negh'

	if _caller() < 11 {
		tempname cns
		capture mat `cns' = get(Cns)
		if _rc==0 {
			est matrix constraint = `cns'
		}
	}
	est local r2_p
	est local cmd
	est local offset "`offset'"
	est local intmethod mvaghermite
	if `"`madapt'"'=="" { 
		est local intmethod "aghermite"
	}
        if "`stdquad'" !="" {
		est local intmethod "ghermite"
	}
	est local distrib "Gaussian"
	est local title   "Random-effects interval regression"
        est local wtype  "`weight'"
	if "`exp'" != "" {
		est local wexp   "=`exp'"
	}
	else {
		est local wexp ""
	}
	est scalar n_quad = `quad'
        est scalar N_g    = `ng'
        est scalar g_min  = `g1'
        est scalar g_avg  = `g2'
        est scalar g_max  = `g3'
	est scalar N_unc  = `N_c1'
	est scalar N_lc   = `N_c2'
	est scalar N_rc   = `N_c3'
	est scalar N_int  = `N_c4'
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
	`vv' ///
        mat colnames `b' = `NAMES'
	if _caller() < 11 {
		`vv' ///
        	mat colnames `v' = `NAMES'
		`vv' ///
        	mat rownames `v' = `NAMES'
        	est post `b' `v', noclear
	}
	else {
		_ms_op_info `b'
		if r(tsops) {
			quietly tsset, noquery
		}
        	est repost b=`b' V=`v', rename buildfvinfo
	}
        if "`llprob'" != "" {
		est scalar ll_c   = `llprob'
		est scalar chi2_c = cond(_b[/sigma_u]<1e-5, 0, /*
			*/ abs(-2*(e(ll_c)-e(ll))))
		est local chi2_ct  "LR"
	}
        else {
                qui test _b[/sigma_u] = 0
                est scalar chi2_c  = r(chi2)
                est local chi2_ct  "Wald"
        }

        est scalar sigma_u = _b[/sigma_u]
        est scalar sigma_e = _b[/sigma_e]
	est scalar rho = e(sigma_u)^2/(e(sigma_u)^2+e(sigma_e)^2)
	if "`ll0'" != "" {
		est scalar ll_0 = `ll0'
	}
	est scalar k_aux = 2
	local i 0
        est hidden local diparm`++i' sigma_u sigma_e, /*
		*/ label(rho) func(@1^2/(@1^2+@2^2)) /*
                */ der( 2*@1*(@2/(@1^2+@2^2))^2 -2*@2*(@1/(@1^2+@2^2))^2 ) /*
                */ ci(probit)
	est local depvar  "`depname'"
	est hidden local offset1 "`offset'"
	est local predict "xtintreg_p"
	if _caller() <= 14 { local ZERO 0 }
	est local marginsok	default			///
				XB			///
				Pr`ZERO'(passthru)	///
				E`ZERO'(passthru)	///
				YStar`ZERO'(passthru)
	est local ivar    "`ivar'"
	est local cmd     "xtintreg"

        DispTbl, `level' `diopts'
	DispLR
	global XTI_madapt
	global XTI_noadap
	global XTI_qavar
	global XTI_qwvar
	global XTI_quad
	global XTI_shat
	global XTI_hh
	global XTI_cvar
	global XTI_logF
	global XTI_lnf
end
	
program define Display
	DispTbl `0'
	DispLR, `cnsnote'
end


program define DispTbl
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	tempname b
	mat `b' = e(b)
	local su = _b[/sigma_u]
	local se = _b[/sigma_e]
	local bb = `su'^2/(`su'^2+`se'^2)
        _crcphdr
        _coef_table, level(`level') `diopts'
end


program define DispLR

        if "`e(ll_c)'" == "" {
		*di in green "Wald test of sigma_u=0:             " _c
		*di in green "chi2(" in ye "1" in gr ") = " /*
			*/ in ye %8.2f e(chi2_c) _c
		*di in green "    Prob > chi2 = " in ye %6.4f /*
			*/ chiprob(1,e(chi2_c))
	}
	else {
		_lrtest_note_xt, msg("LR test of sigma_u=0")
		di
	}

        if e(N_cd) <. {
		if e(N_cd) > 1 { local s "s" } 
                di in gr _n /*
		*/ "(note: `e(N_cd)' completely determined panel`s')"
        }
end
