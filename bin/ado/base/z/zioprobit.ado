*! version 1.1.0  14mar2018
program zioprobit, properties(svyb svyj svyr bayes) eclass byable(onecall) 
	version 15
	
	if _by() {
		local by `"by `_byvars'`_byrc0':"'
	}
	
	qui syntax [anything] [if] [in] [fw iw pw], [INFlate(string) *]
	if `"`inflate'"' == "_cons" {
		`by' _vce_parserun zioprobit, mark(OFFset CLuster) : `0'
	}
	else {
		`by' _vce_parserun zioprobit, mark(INFlate OFFset CLuster) : `0'
	}
	
	if "`s(exit)'" != "" {
		ereturn local cmdline `"zioprobit `0'"'	
		exit
	}
	if replay() {
		if `"`e(cmd)'"' != "zioprobit"  error 301 
		if _by()  error 190 
		Display `0'
		if (e(vuong) <.) {
			DiVuong 
		}
		exit
	}
	else {
		`by' Estimate `0'
		ereturn local cmdline `"zioprobit `0'"'
	}
end

program Display
	syntax 	[,					///
		notable					///
		noHeader				///
		NOCOEF					///
		*]				// Display options

						// parse display options
	_get_diopts diopts rest, `options'
	OptionCheck, extra_option(`rest')
	
	if "`nocoef'" != "" {
		local table notable
		local header noheader
	}
						// coef table
	_prefix_display, notest showeq `table' `header' `diopts'
end

// Vuong test footnote
program define DiVuong
	if ((e(vuong) > 0.005) & (e(vuong)<1e5)) | (e(vuong)==0) {
  		local fmt "%8.2f"
        }
        else    local fmt "%8.2e"
	
	local stat : di `fmt' e(vuong)
	local stat = trim("`stat'")
	local msg "Vuong test of zioprobit vs. oprobit:"
	local k = strlen("`msg'") + 2
	
	di as txt "`msg'" /*
		*/ _col(`k') as txt "z = " as res "`stat'" /*
		*/ _col(64) as txt "Pr > z = " /*
		*/ _col(73) as res %6.4f normal(-e(vuong))
	local v The Vuong test is not appropriate for testing
	local v `v' {help j_vuong##_new:zero-inflation}
	di in smcl as text "{p 0 4 2}Warning: `v'.{p_end}" 
end

program Estimate, byable(recall) eclass 
	syntax varlist(fv) [if] [in]		///
		[fw iw pw],			///
		INFlate(string) [		///
		VUONG				///
		OFFset(varname numeric)		/// - offset for eq1
		VCE(passthru)			///
		Robust				/// 
		CLuster(varname)		/// 
		Level(cilevel)			///
		FROM(string)			///
		TECHnique(passthru)      	///
		LTOLerance(passthru)		///
		TOLerance(passthru)		///
		notable				///
		noHEADer			///
		SEED(string)			/// - UNDOCUMENTED
		moptobj(passthru)		///
		forcevuong *			///
	]
	

	gettoken lhs rhs : varlist
	_fv_check_depvar `lhs'

	_get_diopts diopts options, `options'
	local diopts `diopts' level(`level')
	
	local vceopt =	`:length local vce'		|		///
	   		`:length local weight'		|		///
	   		`:length local cluster'		|		///
	   		`:length local robust'
	
	if "`cluster'" != "" { 
		local clusopt "cluster(`cluster')" 
	}
	if `vceopt' {
		_vce_parse, argopt(CLuster) opt(OIM OPG Robust) old	///
			: [`weight'`exp'], `vce' `robust' `clusopt'
		local cluster `r(cluster)'
		local robust `r(robust)'	
		local vce
		if "`cluster'" != "" {
			local clustvar `r(cluster)'
			local vce vce(cluster `r(cluster)')
		}
		else if "`robust'" != "" {
			local vce vce(robust)
		}
		else if "`r(vce)'" != "" {
			local vce vce(`r(vce)')
		}
		local vceopt `r(vceopt)'
	}
	
	mlopts mlopts, `options' `vce' `technique' `ltolerance' `tolerance'
	local coll `s(collinear)'
	local cns `s(constraints)'

	if ( "`cluster'`robust'`cns'" != "" ) & ("`forcevuong'" != "") {
		di in smcl as err "{p 0 6 0 }The Vuong " /*
		*/ "statistic cannot be computed with {bf:constraints()}, " /*
		*/ "{bf:vce(cluster)}, or {bf:vce(robust)}{p_end}"
		exit 499
	}
		
	ParseInflEq inflate nc offs2 : `"`inflate'"'

	if "`weight'" != "" {
		local wgt "[`weight'`exp']"
		if ( "`weight'" != "fweight" ) & ("`forcevuong'" != "") {
			di as err "option {bf:forcevuong} may not be specified " _c
			di as err "with {bf:`weight'}s" 
		exit 499
		}
	}
	if "`offset'" != "" {
		local offopt "offset(`offset')"
	}
	if "`offs2'" != "" {
		local offopt2 "offset(`offs2')"
	}
	
	marksample touse
	markout `touse' `cluster', strok
	markout `touse' `inflate' `offset' `offs2'	
	
	tempname cat 
	if "`rhs'" != "" {
		_rmcoll `lhs' `rhs' if `touse' `wgt' , oprobit ///
			 `coll' expand noskipline
		local vars "`r(varlist)'"
		gettoken lhs rhs : vars

		matrix `cat' = r(cat)
		local ncat = r(k_cat)
	}
	else {	
		if "`offset'" != "" {
			di as err "option {bf:`offopt'} is not " _c
			di as err "allowed when no independent variables " _c
			di as err "are specified"
			exit 198
		}
		qui oprobit `lhs' if `touse' `wgt'
		matrix `cat' = e(cat)
		local ncat = e(k_cat)
	}
		
	_rmcoll `inflate' if `touse' `wgt' , `nc' `coll' expand
	local inflate "`r(varlist)'"
	
	if `ncat' == 1 {
		di as err "outcome variable {bf:`lhs'} does not vary, " _c
		di as err "always equal to " `cat'[1,1]
		exit 459
	}
	local n_cut = `ncat'-1
	forvalues i=1(1)`n_cut' {
		local cut_eq "`cut_eq' /cut`i'"
	}

	if "`forcevuong'" != "" {
qui {
		tempvar xb_o pr_o 
					// extracting cuts from coef vect b
		tempname cut_o		
						
		oprobit `lhs' `rhs' `wgt' if `touse', `offopt'
		mat `cut_o' = e(b)'

		local l = rownumb(`cut_o', "/:cut1")
		local u = rownumb(`cut_o', "/:cut`n_cut'")
		matrix `cut_o' = `cut_o'[`l'..`u',1] 
		
		if `:list sizeof rhs' {
			_predict double `xb_o' if `touse', xb 
		}
		else {
			gen byte `xb_o' = 0 if `touse'
		}
}
	}
	if "`vuong'" != "" {
		di in smcl as err "{p}"
		di in smcl as err "Vuong test is not appropriate for "
		di in smcl as err ///
			"testing {help j_vuong##_new:zero-inflation}."
		di in smcl as err ///
		"  Specify option {bf:forcevuong} to perform the test anyway."
		di in smcl as err "{p_end}"
		exit 498
	}
	else if "`forcevuong'" != "" {
		local vuong vuong
	}

	if `"`from'"' == "" {
		if "`seed'" == "" {
			qui oprobit `lhs' `rhs' `wgt' if `touse', `offopt'
			
			tempname b0
			mat `b0' = get(_b)
			local initopt init(`b0', skip)
		}
		else {		
			StartingValues if `touse', depvar(`lhs')   ///
				indep(`rhs') infl_indep(`inflate') ///
				infl_nocon(`nc') wt(`wgt') seed(`seed')

			tempname b0
			mat `b0' = r(b0)
			local initopt init(`b0')
		}

	}
	else {
		local initopt `"init(`from')"'	
	}

	if `:list sizeof rhs' {
		local xb (`lhs': `lhs' = `rhs', noconstant `offopt')
		local zg (inflate: `inflate', `offopt2' `nc')
		local ncut = `n_cut'
	}
	else {
		local xb (inflate: `inflate', `offopt2' `nc') 
		local zg (cut1: `lhs' =, `offopt')
		gettoken drop cut_eq : cut_eq
		local ncut = `n_cut'-1
	}

nobreak {

		mata: ziop_init("inits","`lhs'","`ncut'", ///
			"`ncat'","`cat'","`touse'")

	capture nois break {
		ml model lf2 ziop_lf2() 				///
			`xb' 						///
			`zg' 						///
			`cut_eq' 			   		///
			`wgt' if `touse',		   		///
			title(Zero-inflated ordered probit model) 	///
			`mlopts'					///
			`initopt'					///
			`vceopt'					///
			collinear					///
			nopreserve					///
			userinfo(`inits')				///
			missing						///	
			search(off)					///
			maximize `moptobj'
	}	

	local erc = _rc
	capture mata: rmexternal("`inits'")

} // nobreak

	if (`erc') {
		exit `erc'
	}
	
	qui { 
		if "`weight'" != "fweight" {
			count if `touse' & `lhs'==0
			local nzero = r(N)
		
		} 
		else {
			summ `dep' `wgt' if `touse' & `lhs'==0, meanonly
			local nzero = r(N)
		}
	}
	ereturn scalar N_zero = `nzero'
	

						// Needed when main equation
						// does not include a constant
						// by default.	
	if "`rhs'" == "" {
		tempname b
		matrix `b' = e(b)
		local colna : colfullna `b'
		local colna : subinstr local colna "cut1:_cons" "/cut1"
		matrix colna `b' = `colna'
		ereturn repost b=`b', rename buildfvinfo ADDCONS
		ereturn scalar k_eq_model = 0
	}
	else 	ereturn repost, buildfvinfo ADDCONS

	
	if "`vuong'" != "" {
qui {
		tempvar xb zg phiz pr_z mi
					// extracting cuts from coef vect b
		tempname cut 		
		matrix `cut' = e(b)'
 
		local l = rownumb(`cut', "/:cut1")
		local u = rownumb(`cut', "/:cut`n_cut'")
		matrix `cut' = `cut'[`l'..`u',1]
		
		if "`rhs'" != "" {
			_predict double `xb' if `touse', xb eq(#1) 
			_predict double `zg' if `touse', xb eq(#2)
		}
		else {
			_predict double `zg' if `touse', xb eq(#1)
			gen byte `xb' = 0 if `touse'
		}
		gen double `phiz' = normal(`zg') if `touse'
	
		gen double `pr_z' = normal(-`zg') + ///
		 `phiz'*normal(`cut'[1,1]-`xb') if `lhs'==`cat'[1,1] & `touse'
		gen double `pr_o' = normal(`cut_o'[1,1]-`xb_o') ///
			if `lhs'==`cat'[1,1] & `touse'

		forvalues i=2(1)`n_cut' {
			local j = `i' - 1
			replace `pr_z' = `phiz'*(normal(`cut'[`i',1]-`xb') - ///
				normal(`cut'[`j',1]-`xb')) 		     ///
				if `lhs'==`cat'[1,`i'] & `touse'
			replace `pr_o' = normal(`cut_o'[`i',1]-`xb_o') -    ///
				normal(`cut_o'[`j',1]-`xb_o') 		     ///
				if `lhs'==`cat'[1,`i'] & `touse'
		}
		
		local t = `n_cut'+1
		replace `pr_z' = `phiz'*normal(`xb'-`cut'[`n_cut',1]) ///
		   if `lhs'==`cat'[1,`t'] & `touse'
		replace `pr_o' = normal(`xb_o'-`cut_o'[`n_cut',1]) ///
		   if `lhs'==`cat'[1,`t'] & `touse'
		gen double `mi'=ln(`pr_z'/`pr_o') if `touse'
		
		tempname N meanm stdm V2
		
		summ `mi' if `touse'
		scalar `N'=r(N)
		scalar `meanm'=r(mean)
		scalar `stdm'=sqrt( r(Var) )

		scalar `V2'=( sqrt(`N') * `meanm')/`stdm' 
		ereturn scalar vuong = `V2'  
		
}		
	} 

	ereturn matrix cat = `cat',copy
		
	_b_pclass PCDEF : default		// prevent a z-test on /cuti
	_b_pclass PCAUX : aux
	tempname pclass
	matrix `pclass' = e(b)
	local dim = colsof(`pclass')
	matrix `pclass'[1,1] = J(1,`dim',`PCDEF')
	local pos = colnumb(`pclass', "/cut1")
	matrix `pclass'[1,`pos'] = J(1,`n_cut',`PCAUX')
	ereturn hidden matrix b_pclass `pclass'
	
	ereturn local title "Zero-inflated ordered probit regression"
	ereturn local cmdline zioprobit `0'
	ereturn local predict "zioprobit_p"
	ereturn hidden local marginsprop addcons
	ereturn local marginsok default ///
				pmargin ///
				pr	///
				pjoint1 ///
				pcond1  /// 
				xb 	///
				xbinfl  ///
				ppr
	ereturn local marginsnotok "stdp stdpinfl"

	forval i = 1/`ncat' {
                local j = `cat'[1,`i']
                local mdflt `mdflt' predict(pmargin outcome(`j'))
        }
        ereturn local marginsdefault `"`mdflt'"'
	ereturn scalar k_aux	  = `n_cut'
	ereturn scalar k_cat	  = `ncat'
	ereturn local cmd "zioprobit"
						// Needed for postestimation
						// in program -Eq-
	ereturn hidden local encat = `ncat'							
 	ereturn hidden local rhs = "`rhs'"
	ereturn hidden local ncut = `ncut'
	
	Display, `table' `header' `diopts'
	if "`vuong'" != "" {
		DiVuong
	}
	ml_footnote

end

program ParseInflEq
        args inflate nc offs2 colon inflopt
        _parse comma lhs rhs : inflopt

        if (`"`lhs'"'=="_cons") { // constant-only model
                local 0 `rhs'
                cap noi syntax [, OFFset(string) noCONstant]
                if _rc {
                        di as err "in option {bf:inflate()}"
                        exit 198
                }
                if ("`offset'"!="") {
                        di as err "option {bf:inflate()}: invalid syntax"
                        di as err "{p 4 4 2}Option {bf:offset()} is not allowed"
                        di as err "with the constant-only inflation model."
                        di as err "{p_end}"
                        exit 198
                }
                if ("`constant'"!="") {
                        di as err "option {bf:inflate()}: invalid syntax"
                        di as err "{p 4 4 2}Option {bf:noconstant} is not"
                        di as err "allowed with the constant-only inflation"
                        di as err "model.{p_end}"
                        exit 198
                }
                c_local `inflate' ""
                c_local `nc' ""
                c_local `offs2' ""
                exit
        }

        local 0 `lhs'
        cap noi syntax varlist(numeric fv)
        if _rc {
                di as err "{p 4 4 2}Numeric {varlist} or {bf:_cons}"
                di as err "is required in option {bf:inflate()}.{p_end}"
                exit _rc
        }

        local 0 `rhs'
        cap noi syntax [, OFFset(varname numeric) noCONstant]
        if _rc {
                di as err "in option {bf:inflate()}"
                exit 198
        }

        c_local `inflate' "`lhs'"
        c_local `nc' "`constant'"
        c_local `offs2' "`offset'"
end


program StartingValues, rclass
	syntax [if] [,			///
		depvar(string)		///
		indep(string)		///
		infl_indep(string)	///
		infl_nocon(string)	///
		wt(string) 		///
		seed(string) ]
	
	tempvar inflate
	tempname b0_1 b0_2 b0


	preserve
	qui keep `if'

	mata: _r_latent("`depvar'", "`seed'")


	capture qui probit `inflate' `infl_indep'  `wt', `infl_nocon'
	if _rc == 2000 {
		di as err "insufficient number of observations"
		exit _rc
	}
	else if _rc {
		exit _rc
	}	
	matrix `b0_1' = e(b)


	qui oprobit `depvar' `indep'   `wt'

	restore
	matrix `b0_2' = e(b)
	matrix `b0' = (`b0_2',`b0_1')

	local stripe : colfullnames `b0'
	local stripe : subinstr local stripe "`inflate'" "inflate", all
	mat colnames `b0' = `stripe'

	return matrix b0 = `b0'
end

version 15
mata:	

void _r_latent(string scalar vname, string scalar seed)
{
	real colvector r, idx, rand, y, J
	real scalar m, n, rstar, seed0
	
	y = st_data(.,vname)

	m = rows(y)
	J = uniqrows(y)

	r = (y:>J[1])
	seed0 = strtoreal(seed)
	rseed(seed0)
	rand = rbinomial(m,1,1,0.5)

	idx = selectindex(y:==J[1] :& rand:== 0)
	n = rows(idx)
  	r[idx] = J(n,1,1)

	rstar = st_addvar("byte",st_local("inflate"))
	st_store(., rstar, r)
}
end

program  OptionCheck
	syntax , [extra_option(string)]
	if `"`extra_option'"'!="" {
		di as err `"option {bf:`extra_option'} not allowed"'
		exit 198
	}
end
exit



