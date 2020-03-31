*! version 1.7.0  15mar2018
program define frontier, eclass sort byable(onecall) prop(ml_score)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun frontier, mark(CM Uhet Vhet) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"frontier `0'"'
		exit
	}

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 8.1
	if replay() {
		if _by() {
			error 190
		}
		if "`e(cmd)'"~="frontier" {
			error 301
		}
		if _by() {
			error 190
		}
		Replay `0'
		exit
	}
	`vv' `BY' sfe `0'
	version 10: ereturn local cmdline `"frontier `0'"'
end

program define sfe, eclass sort byable(recall)
	version 8.1
	syntax varlist(fv) [fweight pweight iweight] [if] [in] 	/*
		*/ [, cm(string) noCONStant CONSTraints(string) /*
		*/ COST Distribution(string) FROM(string) 	/*
		*/ UFrom(string) Level(cilevel) 		/*
		*/ Vhet(string) Uhet(string)			/*
not documented	*/  UTransformed SCore(passthru)		/*
		*/ noDIFficult					/*
not documented	*/ Robust					/*
not documented	*/ CLuster(passthru)				/*
not documented	*/ VCE(passthru)				/*
		*/ * ]

	local vn: di string(_caller())
	if `vn'<15      local gammaparm ilgtgamma
	else            local gammaparm lgtgamma

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' {
		local vv : di "version " string(max(11,_caller())) ", missing:"
		local mm e2
		local negh negh
	}
	else {
		local mm d2
	}

	ParseDist dist : `"`distribution'"'	

	if "`dist'" != "tnormal" {
		if "`ufrom'" != "" {
			local erropt "ufrom()"
		}
		if "`utransformed'" != "" {
			local erropt "`erropt' utransformed"
		}
		if `"`cm'"' != "" {
			local erropt "`erropt' cm()"
		}
		if "`erropt'" != "" {
			AddCommas erropt : "`erropt'"
			di as err "`erropt' allowed only with " /*
				*/ "truncated-normal models"
			exit 198
		}
	}
	else {
		if "`uhet'" ~= "" {
			local erropt "uhet"
		}
		if "`vhet'" ~= "" {
			local erropt "`erropt' vhet"
		}
		if "`erropt'" != "" {
			AddCommas erropt : "`erropt'"
			di as err "`erropt' not allowed with " /*
				*/ "truncated-normal models"
			exit 198
		}
				/* -utransformed- is undocumented */
		if `"`from'"' != "" | `"`constraints'"' != "" {
			local utransformed "utransformed"
		}
	}

	if "`constant'"~="" {
		local nocns="`constant'"
	}

	if "`difficult'" == "" {
		local difficult difficult
	}

	local zhet `cm'

	foreach opt in v u z {
		if "``opt'het'" != "" {
			local `opt'opt ``opt'het'
			tokenize "``opt'opt'", parse(,)
			fvunab `opt'het : `1'
			if !`fvops' {
				local fvops = "`s(fvops)'" == "true"
			}
			if "`s(fvops)'" == "" {
		 		confirm numeric var ``opt'het'
			}

						/* noCONStant */
			if "`3'" != "" {
				local l = length(`"`3'"')
				if `"`3'"' == bsubstr("noconstant", /*
					*/ 1,max(6,`l')) {
					local `opt'nocns "noconstant"
				}
				else {
					di as err "`3' invalid"
					exit 198
				}
			}
		}
	}

	if "`cost'" != "" { 
		global S_COST=-1 
		local function "cost" 
	}
	else {
		global S_COST=1
		local function "production"
	} 

	marksample touse
						/*Parse variable list */
	gettoken lhs varlist : varlist
	_fv_check_depvar `lhs'
	if "`varlist'"=="" & "`constant'"~="" {
		error 102
	}
					/* check `lhs' not constant */
	if `fvops' {
		local rmcoll "version 11: _rmcoll"
		local rmdcoll "version 11: _rmdcoll"
	}
	else {
		local rmcoll _rmcoll
		local rmdcoll _rmdcoll
	}
	qui `rmcoll' `lhs'
	if "`r(varlist)'" != "`lhs'" {
		di as err "dependent variable cannot be constant"
		exit 198
	}

	tempvar wvar
	if "`weight'"~="" {
		gen double `wvar' `exp' if `touse'
		local wtopt "[`weight'=`wvar']"
	}
	else {
		gen byte `wvar' = 1
	}
	markout `touse' `uhet' `vhet' `zhet' `wvar'

	qui count if `touse'==1
	if r(N) == 0 {
		error 2000
	}

	_vce_parse, argopt(CLuster) opt(OIM OPG Robust) old	///
		: [`weight'`exp'], `vce' `robust' `cluster'
	local robust `r(robust)'
	local cluster `r(cluster)'
	local vce `"`r(vceopt)'"'

	_get_diopts diopts options, `options'
	mlopts mlopts, `options' const(`constraints')
	local coll `s(collinear)'
	local cns `s(constraints)'
	
					/* remove collinearity */
	cap noi `rmdcoll' `lhs' `varlist' if `touse' `wtopt', `nocns' `coll'
	if _rc {
		di as err "some independent variables " /*
			*/ "collinear with the dependent variable"
		exit _rc
	}
	local varlist `r(varlist)'
	if "`uhet'"~="" {
		local u "u" 
		cap noi `rmdcoll' `lhs' `uhet' if `touse' `wtopt',	///
			`unocns' `coll'
		if _rc {
			di as err "some variables specified in uhet() " /*
				*/ "collinear with the dependent variable"
			exit _rc
		}
		local uhet `r(varlist)' 
	}
	if "`vhet'"~="" {
		local v "v"
		cap noi `rmdcoll' `lhs' `vhet' if `touse' `wtopt',	///
			`vnocns' `coll'
		if _rc {
			di as err "some variables specified in vhet() " /*
				*/ "collinear with the dependent variable"
			exit _rc
		} 
		local vhet `r(varlist)' 
	}
	if "`zhet'"~="" {
		local z "z"
		cap noi `rmdcoll' `lhs' `zhet' if `touse' `wtopt',	///
			`znocns' `coll'
		if _rc {
			di as err "some variables specified in cm() " /*
				*/ "collinear with the dependent variable"
			exit _rc
		} 
		local zhet `r(varlist)' 
	}

	if "`ufrom'" ~= "" {
		if "`from'" ~= "" {
			noi di as err "from() cannot be " /*
				*/ "specified with ufrom()"
			exit 198
		}
		if "`constraints'" ~= "" {
			noi di as err "constraints() cannot be " /*
				*/ "specified with ufrom()"
			exit 198
		}
		if "`utransformed'" ~= "" {
			noi di as err "utransformed cannot be " /*
				*/ "specified with ufrom()"
			exit 198
		}

		cap confirm matrix `ufrom'
		if _rc {
			di as err "ufrom() must specify a matrix"
			exit 198
		}

		tempname b_u s2 btemp
		mat `b_u' = `ufrom'
		local ncol = colsof(`b_u')
					/* check dimension */
		local dim : word count `varlist'
		if "`constant'" == "" {
			local dim = `dim' + 3
		}
		else {
			local dim = `dim' + 2
		}

		if "`cm'" != "" {
			local dim_cm : word count `zhet'
			local dim = `dim' + `dim_cm' + ("`znocns'"=="")
		}
		else {
			local dim = `dim' + 1
		}

		if `dim' != `ncol' {
			di as err "ufrom() must specify a 1 x `dim' matrix"
			exit 198
		}

		mat `btemp' = `b_u'[1,1..`ncol'-2]
		scalar `s2' = exp(`b_u'[1,`ncol'])
		mat `btemp' = `btemp'/sqrt(`s2')
		mat `b_u' = `btemp', `b_u'[1,`ncol'-1], `b_u'[1,`ncol']
		local from "`b_u', copy"
	}

				/* even -noconstant- specified, there
				   will be a constant term in OLS, which
				   is -$S_COST*E(u_i) */
	`vv' ///
	qui reg `lhs' `varlist' `wtopt' if `touse'
	tempname ll0_u
	scalar `ll0_u'=e(ll)

					/* 3rd moment test */
	local nobs=e(N)
	tempvar olsres olsres2 olsres3
	tempname m2 m3 b0 m3t p_m3t
	matrix `b0'=e(b) 
	qui predict double `olsres' if `touse', res
			
				/* -summarize- does not allow pweights;
				   force weights to be iweights since
				   we only need the mean */
	qui gen double `olsres2'=`olsres'^2 if `touse' 
	qui sum `olsres2' [iw=`wvar'] if `touse', meanonly
	scalar `m2'=r(mean)

	qui gen double `olsres3'=`olsres'^3 if `touse' 
	qui sum `olsres3' [iw=`wvar'] if `touse', meanonly
	scalar `m3'=r(mean)

	scalar `m3t'=`m3'/sqrt(6*`m2'^3/`nobs')
				/* negative skewness, so one-side test */
	scalar `p_m3t' = norm($S_COST*`m3t')

					/* correct 3rd moment to be negative */
	scalar `m3'=cond($S_COST*r(sum)<0, `m3', -.0001*$S_COST)
	

				/* Use MOM to obtain starting values */
	if "`from'"!="" {
		local start "init(`from')"
	}
	else {
		tempname ou2 ov2 cons0 

		if "`dist'" == "hnormal" | "`dist'" == "tnormal"  {
			scalar `ou2' = ($S_COST*`m3'/(sqrt(2/_pi) /*
				*/ *(1-4/_pi)))^(2/3)
			scalar `ov2' = `m2' - (1-2/_pi)*`ou2'
			scalar `ov2' = cond( `ov2'>0, `ov2', .0001)

			if "`constant'" == "" {
				scalar `cons0' = _b[_cons] /*
				*/ + $S_COST*(sqrt(2/_pi))*sqrt(`ou2')
				mat `b0'[1,colsof(`b0')]=`cons0'
			}
			else {
				local cols = colsof(`b0') - 1
				mat `b0' = `b0'[1,1..`cols']
			}
		}
		if "`dist'" == "exponential" {
			scalar `ou2' =(-$S_COST*`m3'/2)^(2/3)
			scalar `ov2' = `m2' - `ou2'
			scalar `ov2' = cond( `ov2'>0, `ov2', .0001)

			if "`constant'" == "" {
				scalar `cons0' = _b[_cons] /*
				*/ + $S_COST*sqrt(`ou2')
				mat `b0'[1,colsof(`b0')]=`cons0'
			}
			else {
				local cols = colsof(`b0') - 1
				mat `b0' = `b0'[1,1..`cols']
			}
		}			

		if "`vhet'"=="" & "`uhet'"=="" {
			mat `b0'=`b0', ln(`ov2'), ln(`ou2')	
		}

		else if "`vhet'"~="" & "`uhet'"=="" {
			tempvar lnv2 g
			qui gen double `lnv2'=ln(`ov2') if `touse'

			`vv' ///
			qui regress `lnv2' `vhet' /*
				*/  `wtopt' if `touse', `vnocns'

			mat `b0'=`b0', e(b), ln(`ou2')
		}

		else if "`vhet'"=="" & "`uhet'"~="" {
			tempvar lnu2
			qui gen double `lnu2'=ln(`ou2') if `touse'
			`vv' ///
			qui reg `lnu2' `uhet' /*
				*/  `wtopt' if `touse', `unocns'

			mat `b0'=`b0', ln(`ov2'), e(b)
		}

		else if "`vhet'"~="" & "`uhet'"~="" {
			tempvar lnv2 lnu2
			tempname bv bu

			qui gen double `lnv2'=ln(`ov2') if `touse'
			`vv' ///
			qui reg `lnv2' `vhet' /*
				*/  `wtopt' if `touse', `vnocns'
			mat `bv'=e(b)
			qui gen double `lnu2'=ln(`ou2') if `touse'
			`vv' ///
			qui reg `lnu2' `uhet' /*
				*/  `wtopt' if `touse', `unocns'
			mat `bu'=e(b)

			mat `b0'=`b0', `bv', `bu'
		}

		if "`dist'" == "tnormal" {

			local nx : word count `varlist'
			if "`constant'"=="" {
				local nx = `nx' + 1
			}
			tempname bx sigmaS2 lnsigS2 gamma ltgamma mu

			scalar `mu' = 0
			scalar `sigmaS2' = `ou2' + `ov2'
			scalar `gamma' = `ou2'/`sigmaS2'
			scalar `lnsigS2' = ln(`sigmaS2')
			scalar `ltgamma' = ln(`gamma'/(1-`gamma'))

			mat `bx'=`b0'[1,1..`nx']
			if "`utransformed'" == "" {
				mat `bx'=`bx'/sqrt(`sigmaS2')
				scalar `mu' = `mu'/sqrt(`sigmaS2')
			}

			if `"`zhet'"'=="" {
				mat `b0' = `bx', `mu', `ltgamma', `lnsigS2'
			}
			else {
				local nzs : word count `zhet'
				tempname zd
				if "`znocns'"=="" {
					local nzs = `nzs'+1
					mat `zd' = J(1,`nzs',0)
					mat `zd'[1,`nzs'] = `mu'
				}
				else {
					mat `zd' = J(1,`nzs',0)
				}
				mat `b0'=`bx', `zd', `ltgamma', `lnsigS2'
			} 
		}
		local start "init(`b0', copy)"
	}

					/* Normal-Half Normal Model, default*/
	if "`dist'" == "hnormal" {
		local mlprog "fron_hn"
		local title "Stoc. frontier normal/half-normal model"
	}
						/* Normal-Exponential Model */
	if "`dist'" == "exponential" {
		local mlprog "fron_ex"
		local title "Stoc. frontier normal/exponential model"
	}
					/* Normal-Truncated Normal model */
	if "`dist'" == "tnormal" {
		if "`utransformed'" == "" {
			local mlprog "fron_tn"
			local mm d2
			if `:length local score' {
				di as err "option score not allowed"
				exit 198
			}
			if `"`robust'"' != "" {
				di as err "option {bf:vce(robust)} not allowed"
				exit 198
			}
			if `"`cluster'"' != "" {
				di as err ///
				"option {bf:vce(cluster `cluster')} not allowed"
				exit 198
			}
		}
		else {
			local mlprog "fron_tn2"
			local star "*"
		}
		local title "Stoc. frontier normal/truncated-normal model"


		`vv' ///
		ml model `mm' `mlprog' (`lhs': `lhs'=`varlist', `nocns')/*
			*/ (mu: `zhet', `znocns') 			/*
			*/ (`gammaparm': ) 				/*
			*/ (lnsigma2: ) 				/*
			*/ `wtopt' if `touse', collinear 		/* 
			*/ max miss `start' search(off) nopreserve 	/*
			*/ `mlopts' 	 				/*
			*/ title("`title'") 				/*
			*/ `difficult' `score' `negh' `vce'

		`star' UnTrans
	}
	else {
		`vv' ///
		ml model `mm' `mlprog' (`lhs': `lhs'=`varlist', `nocns')/*
			*/ (lnsig2v: `vhet', `vnocns') 			/*
			*/ (lnsig2u: `uhet', `unocns') 			/*
			*/ `wtopt' if `touse', collinear 		/* 
			*/ max miss `start' search(off) nopreserve 	/*
			*/ `mlopts' 	 				/*
			*/ title("`title'") 				/*
			*/ `difficult' `score' `negh' `vce'
	}

			/* One-sided generalized likelihood-ratio test */
	if "`ll0_u'" != "" & "`u'`v'`cns'" == "" ///
	& "`e(vcetype)'" != "Robust" {
		eret scalar ll_c = `ll0_u'
		if e(ll) < e(ll_c) {
			eret scalar chi2_c = 0
		}
		else	eret scalar chi2_c = 2*(e(ll)-e(ll_c))
	}

	if "`u'`v'" == "" & "`zhet'" == "" {
		eret scalar z = `m3t'
		eret scalar p_z = `p_m3t'
	}

	if "`dist'" != "tnormal" {
		if "`uhet'"=="" {
			eret scalar sigma_u = exp([lnsig2u]_cons/2) 
		}
		if "`vhet'"=="" {
			eret scalar sigma_v = exp([lnsig2v]_cons/2) 
		}
		eret local v_hetvar "`vhet'"
		eret local u_hetvar "`uhet'"
	}
	else {
		eret local cm "`zhet'"
		tempname s2 g
		scalar `s2' = exp([lnsigma2]_cons)
		scalar `g'  = [`gammaparm']_cons
		scalar `g'  = exp(`g')/(1+exp(`g'))
		eret scalar sigma_u = sqrt(`g'*`s2')
		eret scalar sigma_v = sqrt((1-`g')*`s2')
	}

	eret local wtype "`weight'"
	eret local wexp "`exp'"
	eret local predict "fron_p"
	eret local dist "`dist'"
	eret local function "`function'"
	eret local het "`u'`v'"
	local i 0
	if "`e(dist)'" != "tnormal" {
		if "`e(het)'" == "" {
			eret scalar k_aux = 2
			eret hidden local diparm`++i' lnsig2v, /*
				*/ func( exp(0.5*@) ) der( 0.5*exp(0.5*@) ) /*
				*/ label(sigma_v)
			eret hidden local diparm`++i' lnsig2u, /*
				*/ func( exp(0.5*@) ) der( 0.5*exp(0.5*@) ) /*
				*/ label(sigma_u)
			eret hidden local diparm`++i' lnsig2v lnsig2u, /*
				*/ func( exp(@1)+exp(@2) ) /*
				*/ der( exp(@1) exp(@2) ) label(sigma2)
			eret hidden local diparm`++i' lnsig2v lnsig2u, /*
				*/ func( sqrt(exp(@2-@1))) /*
				*/ der( -0.5*exp(0.5*@1) 0.5*exp(0.5*@2) ) /*
				*/ label(lambda) 
		}
		else if "`e(het)'" == "v" {
			eret hidden local diparm`++i' lnsig2u, /*
				*/ func( exp(0.5*@) ) der( 0.5*exp(0.5*@) ) /*
				*/ label(sigma_u)
		}	
		else if "`e(het)'" == "u" {
			eret hidden local diparm`++i' lnsig2v, /* 
				*/ func( exp(0.5*@) ) der( 0.5*exp(0.5*@) ) /* 
				*/ label(sigma_v)
		}			
	}
	else {
		if "`e(cm)'" == "" {
			eret scalar k_eq_skip = 3
			eret hidden local diparm`++i' mu
		}
		else {
			eret scalar k_eq_skip = 2
		}

		eret hidden local diparm`++i' lnsigma2
		eret hidden local diparm`++i' `gammaparm'
		eret hidden local diparm`++i' __sep__
		eret hidden local diparm`++i' lnsigma2, exp label(sigma2)
		eret hidden local diparm`++i' `gammaparm', ilogit label(gamma)
		eret hidden local diparm`++i' lnsigma2 `gammaparm', /*
			*/ func( exp(@1)*exp(@2)/(1+exp(@2)) ) /*
			*/ der( exp(@1)*exp(@2)/(1+exp(@2)) /*
			*/ exp(@1)*(exp(@2)/(1+exp(@2))/*
			*/-(exp(@2)/(1+exp(@2)))^2) ) /*
			*/ label(sigma_u2)
		eret hidden local diparm`++i' lnsigma2 `gammaparm', /*
			*/ func( exp(@1)*(1-exp(@2)/(1+exp(@2))) ) /*
			*/ der( exp(@1)*(1-exp(@2)/(1+exp(@2)))  /*
			*/ (-exp(@1))*(exp(@2)/(1+exp(@2))/*
			*/-(exp(@2)/(1+exp(@2)))^2)) /*
			*/ label(sigma_v2) 
	}

	eret local cmd "frontier"		/* last eret */

	Replay, level(`level') `diopts'
	mac drop S_COST
end


program define UnTrans, eclass

	tempname b b0 b1 V s J
	matrix `b' = e(b)
	matrix `V' = e(V)
	local dim = colsof(matrix(`b'))

	scalar `s' = `b'[1,`dim'] 		/* ln(sigmaS^2) */
	scalar `s' = exp(0.5*`s')		/* sigmaS */

					/* Compute Jacobian. */

	matrix `b1'= -0.5*`b'[1,1..`dim'-2]
	matrix `J' = (diag(J(1,`dim'-2,1/`s')), J(`dim'-2,1,0) /*
		*/, `b1'' \ J(2,`dim'-2, 0), I(2) )

				/* Untransform variance `V'. */

	mat `V' = `J''*syminv(`V')*`J'
	mat `V' = syminv(0.5*(`V' + `V''))	/* make it symmetric */

				/* Untransform coefficient vector. */

	matrix `b0' = `b'[1,1..`dim'-2]
	matrix `b0' = `s'*`b0'
	matrix `b'  = `b0', `b'[1,`dim'-1], `b'[1,`dim']

						/* Repost. */

	eret repost b=`b' V=`V'

					/* Redo Wald test. */

	if "`e(chi2type)'"=="Wald" {
		eret scalar chi2 = .
		eret scalar p = .

		_evlist

		if "`s(varlist)'"!="" {
			capture test `s(varlist)', min
			eret scalar df_m = r(df)
			eret scalar chi2 = r(chi2)
			eret scalar p = r(p)
		}
	}

end


/* ---------------------------DISPLAY------------------------------------- */

program define Replay
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	version 10: ml display, level(`level') `diopts'

						/* LR test */
	if "`e(het)'"=="" & "`e(vcetype)'" != "Robust" /*
		*/ & "`e(dist)'" != "tnormal" { 
			DispLR
	}
						/* 3rd moment test */
	if "`e(dist)'" == "tnormal" & "`e(cm)'" == "" {
		if `"`e(function)'"' == "cost" {
			local sign ">"
		}
		else {
			local sign "<"
		}
			
		di as text "H0: No inefficiency component: " _c
		di as text _col(43) "z = " as res %7.3f e(z) _c

		di _col(64) as text "Prob`sign'=z = "  /*
			*/ as result %5.3f e(p_z)
	}
end


program define DispLR

	if e(chi2_c)>=. {
		exit
	}

	tempname pval
					/* half-normal or exponential */
	if `"`e(dist)'"' ~= "tnormal" {
        	scalar `pval' = chi2tail(1, e(chi2_c))*0.5
	}

        if e(chi2_c)==0 { 
		scalar `pval'= 1 
	}

	if ((e(chi2_c) > 0.005) & (e(chi2_c)<1e+2)) /*
		*/ | (e(chi2_c)==0) {
                local fmt "%-6.2f"
        }
        else {
		local fmt "%-6.2e"
	}

	local chi : di `fmt' e(chi2_c)
	local chi = trim("`chi'")

	di as text "LR test of sigma_u=0: " ///
        	in smcl "{help j_chibar##|_new:chibar2(01) = }" ///
        	as result "`chi'" ///
        	_col(56) as text "Prob >= chibar2 = " as result %5.3f `pval'
end


/* ----------------------------------------------------------------- */

program define ParseDist
	args 	retmac 		/* local macro to hold result
	*/	colon 		/* ":" ignored 
	*/	distribution	/* distribution or family */

	local 0 ", `distribution'"
	syntax [, Hnormal Exponential Tnormal * ]

	if `"`options'"' != "" {
		di as error "distribution(`options') not allowed"
		exit 198
	}

	local wc : word count `hnormal' `exponential' `tnormal'

	if `wc' > 1 {
		di as error "distribution() invalid, only " /*
			*/ "one distribution can be specified"
		exit 198
	}

	if `wc' == 0 {
		c_local `retmac' hnormal
	}
	else	c_local `retmac' `hnormal'`exponential'`tnormal'

end

/* Given a list "cat dog lizard", the following program returns 
   "cat, dog, and lizard".  The list "cat dog" becomes "cat and dog"
*/
program define AddCommas

	args	   output	/* Destination for cleaned list
		*/ colon	/* ":"
		*/ orig		/* List of tokens to be fixed. */

	local n : word count `orig'
	tokenize `orig'
	local newlist `"`1'"'
	if `n' > 1 {
		forvalues i = 2/`=`n'-1' {
			local newlist `"`newlist', ``i''"'
		}
		if `n' > 2 {
			local comma ","
		}
		local newlist `"`newlist'`comma' and ``n''"'
	}
	
	c_local `output' `newlist'
	
end

/* ---------------------------END----------------------------------- */

