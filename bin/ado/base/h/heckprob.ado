*! version 6.8.0  08mar2018 
program define heckprob, eclass byable(onecall) prop(svyb svyj svyr ml_score)
	if (_caller() < 13) {	
		if _by() {
			local BY `"by `_byvars'`_byrc0':"'
		}
		`BY' _vce_parserun heckprob, mark(OFFset CLuster) : `0'
		if "`s(exit)'" != "" {
			version 10: ereturn local cmdline `"heckprob `0'"'
			exit
		}
		if _caller() >= 11 {
			local vv : di "version " string(_caller()) ":"
		}
		version 6, missing

		if replay() {
			if "`e(cmd)'" != "heckprob" { error 301 }
			if _by() { error 190 }
			Display `0'
			exit
		}
		`vv' `BY' Estimate `0'
		version 10: ereturn local cmdline `"heckprob `0'"'
	}
	else {
		if _by() {
			local BY `"by `_byvars'`_byrc0':"'
		}
		`BY' _vce_parserun heckprobit, mark(OFFset CLuster) : `0'
		if "`s(exit)'" != "" {
			ereturn local cmdline `"heckprobit `0'"'
			ereturn local cmd heckprobit
			exit
		}
		if replay() {
			if _by() {
				error 190
			}
			if ("`e(cmd)'"=="heckprob") {
				Display `0'
				exit
			}
			if("`e(cmd)'"!="heckprobit" ) {
				error 301
			}
			heckprobit `0'
			exit
		}
		`BY' heckprobit `0'
		ereturn local cmdline `"heckprobit `0'"'
		ereturn local cmd heckprobit
	}
end

program define Estimate, eclass byable(recall)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	else {
		local vv "version 8.1:"
	}
	version 6, missing
				/* parse syntax */	

					/* Allow = after depvar */

	gettoken depvar 0 : 0 , parse(" =,[")
	_fv_check_depvar `depvar'
	tsunab depvar : `depvar'
	local tsnm = cond( match("`depvar'", "*.*"),		/*   
			*/ bsubstr("`depvar'",			/*
			*/        (index("`depvar'",".")+1),.),	/*
			*/ "`depvar'")
	confirm variable `tsnm'
	local depvarn : subinstr local depvar "." "_"
	gettoken equals rest : 0 , parse(" =")
	if "`equals'" == "=" { local 0 `"`rest'"' }

	syntax [varlist(numeric default=none ts fv)] [pw iw fw] [if] [in], /*
		*/ SELect(string) [ 		  			   /*
		*/ CLuster(varname) noCONstant FIRst FROM(string)	   /*
		*/ FROM0(string) Level(cilevel) NOLOg LOg 		   /*
		*/ OFFset(varname numeric ts) Robust noSKIP SCore(string)  /*
		*/ CRITTYPE(passthru) DOOPT VCE(passthru) * ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

	SelectEq seldep selind selnc seloff : `"`select'"'

	_get_diopts diopts options, `options'
	* mlopts contains `log' and `nolog', passed to -ml model-
	mlopts mlopts, `options' `log' `nolog'
	local coll `s(collinear)'
	local cns `s(constraints)'

	if `fvops' {
		if _caller() < 11 {
			local vv : di "version 11:"
		}
	}
	
	if "`weight'"  != "" { local wgt `"[`weight'`exp']"' }
	if "`cluster'" != "" { local clusopt "cluster(`cluster')" }
	if "`seloff'"  != "" { local soffopt "offset(`seloff')" }
	if "`offset'"  != "" { local offopt "offset(`offset')" }
	if "`first'"   == "" { local show1st "nocoef" }
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'"     != "" { local qui "quietly" }
        _vce_parse, argopt(CLuster) opt(Robust oim opg) old: ///
                [`weight'`exp'], `vce' `clusopt' `robust'
        local cluster `r(cluster)'
        local robust `r(robust)'
        if "`cluster'" ! = "" { local clusopt "cluster(`cluster')" }
	if "`robust'" != "" {
		/* probit does not allow iweights and robust so use crittype
		 * instead of robust option */
		if `"`crittyp'"' == "" {
			local crtype crittype("log pseudolikelihood")
		}
	}
	else	local crtype `crittyp'


					/* Check syntax errors */

	if "`constant'" != "" & "`varlist'" == "" { 
		noi di in red "must specify independent variables or "	/*
			*/ "allow constant for primary equation"
		exit 198
	}

	ChkSkip skip : "`skip'" "`robust'" "`constant'" "`varlist'" "`cns'"


					/* Process scores */

	local ct : word count `score'		/* stub -- score(stub*) */
	if `ct' == 1 {
		if bsubstr("`score'",-1,1) == "*" {
			local score = bsubstr("`score'",1,length("`score'")-1)
			local score `score'1 `score'2 `score'3 
		}
	}

	local ct : word count `score'
	if `ct' > 0 & `ct' != 3 {
		di in red "score() requires you specify 3 new variable "  /*
			*/ "names in this case"
		exit 198
	}

	if "`score'" != "" { 
		confirm new variable `score'
		local score "score(`score')" 
	}


				/* Find estimation sample */

	if "`seldep'" == "" {
		tempname seldep
		gen byte `seldep' = `depvar' < .
		local selname "select"
	}
	else local selname : subinstr local seldep "." "_"

	marksample touse, novarlist
	markout `touse' `seldep' `selind' `seloff' `cluster', strok
	marksample touse2
	markout `touse2' `depvar' `varlist' `offset'
	qui replace `touse' = 0 if `seldep' & !`touse2'


				/* Remove collinearity */

	`vv' ///
	_rmcoll `selind' `wgt' if `touse', `selnc' `coll'
	local selind "`r(varlist)'"
	if "`selind'" == "" {
		di in red "no variables remaining in selection equation"
		exit 498
	}
	`vv' ///
	_rmcoll `varlist' `wgt' if `touse' & `seldep', `constant' `coll'
	local varlist "`r(varlist)'"

				/* Only way to check for perfect pred */

	`vv' ///
	capture probit `seldep' `selind' `wgt' if `touse', `selnc' `soffopt' 
	if _rc == 2000 {
	    di as txt "selection equation:" _c
	    `vv' ///
	    probit `seldep' `selind' `wgt' if `touse', `selnc' `soffopt' 
	}
	else if _rc { 
		error _rc 
	}


				/* Check selection condition */

	qui sum `seldep' if `touse'
	if `r(N)' == `r(sum)' {
		di in red "Dependent variable never censored because of selection: "
		di in red "model simplifies to probit regression"
		exit 498
	}


				/* Get starting values, etc. */

	tempname llc b0 b0sel b00
	tempvar  nshaz 

					/* just for part of comparison LL */
					/* and to check for perfect pred */
	`qui' di in gr _n "Fitting probit model:"
	if `fvops' & `:length local cns' {
		local cns1 constr(`cns') nocnsnotes `coll'
		local cns
	}
	`vv' ///
	`qui' probit `depvar' `varlist' `wgt' if `touse' & `seldep', /*
		*/ `constant' `offopt' nocoef `crtype' `doopt' `cns1'
	scalar `llc' = e(ll)

	if "`robust'"=="" | "`from'"=="" | ("`skip'"!="" & "`from0'"=="") {
		`qui' di in gr _n "Fitting selection model:"
		`vv' ///
		`qui' probit `seldep' `selind' `wgt' if `touse',  /*
			*/ `selnc' `soffopt' `show1st' asis  `crtype' /*
			*/ iter(`=min(1000,c(maxiter))') `cns1' `doopt'
		mat `b0sel' = e(b)
		mat coleq `b0sel' = `selname'
		if "`robust'" == "" { scalar `llc' = `llc' + e(ll) }

		qui predict double `nshaz', xb
		qui replace `nshaz' = normd(`nshaz') / normprob(`nshaz')
	}

	if "`robust'" == "" {
		`qui' di in gr _n "Comparison:    log likelihood = " /*
			*/ in ye %10.0g `llc' 
	}

	if "`constant'" == "" { 
		tempname one
		gen byte `one' = 1 
	}

	if "`skip'" != "" & "`from0'" == "" {
		`qui' di in gr _n "Fitting constant-only starting values:"
		`vv' ///
		`qui' probit `depvar' `one' `nshaz' `wgt' 	/*
			*/ if `touse' & `seldep', 		/*
			*/ noconstant `offopt' nocoef asis `crtype' /*
			*/ iter(`=min(1000,c(maxiter))') `doopt'
		MkB0 `b00' : `b0sel' `nshaz'
		local from0 "`b00', copy"
	}

	if "`from'" == "" {
		`qui' di in gr _n "Fitting starting values:"
		`vv' ///
		`qui' probit `depvar' `varlist' `one' `nshaz' `wgt'	/*
			*/ if `touse' & `seldep', 			/*
			*/ noconstant `offopt' nocoef asis `crtype'	/*
			*/ iter(`=min(1000,c(maxiter))') `doopt' `cns1'
		MkB0 `b0' : `b0sel' `nshaz'
		local colna : colna `b0'
		if "`one'" != "" {
			local colna : subinstr local colna "`one'" "_cons"
		}
		`vv' ///
		matrix colna `b0' = `colna'
		local from "`b0', copy"
		local dim =	`:list sizeof varlist' +	///
				(`:list sizeof constant'==0) +	///
				`:list sizeof selind' +		///
				(`:list sizeof selnc'== 0) + 1
		local cb = colsof(`b0')
		if `:length loc cns' & `:length loc coll' & `dim' != `cb' {
			tempname T a C
			local colna
			foreach v of local varlist {
				local colna "`colna' `depvarn':`v'"
			}
			if !`:list sizeof constan' {
				local colna "`colna' `depvarn':_cons"
			}
			foreach v of local selind {
				local colna "`colna' `selname':`v'"
			}
			if !`:list sizeof selnc' {
				local colna "`colna' `selname':_cons"
			}
			local colna "`colna' athrho:_cons"
			_b_post0 `colna'
			`vv' ///
			makecns `cns'
			matcproc `T' `a' `C'
			_b_fill0 `b0' `"`colna'"'
			mat `b0' = `b0'*`T'
			mat `b0' = `b0'*`T'' + `a'
		}
	}

	`vv' ///
	qui _regress `seldep' `wgt' if !`seldep' & `touse'
	local N_cens = e(N)


				/* ML estimation */


	if "`skip'" != "" {
		`qui' di in gr _n "Fitting constant-only model:"

		`vv' ///
		capture noi ml model lf heckp_lf 			/*
		*/ (`depvarn': `depvar' = , `offopt')			/*
		*/ (`selname': `seldep' = `selind', `selnc' `soffopt')	/*
		*/ /athrho						/*
		*/ `wgt' if `touse' , waldtest(0)			/*
		*/ collinear missing max nooutput nopreserve		/*
		*/ init(`from0') search(off)  `mlopts' `crittyp'   /*
		*/ nocnsnotes

		if _rc == 1400 & "`from'" == "`b0', copy" {
			di as txt "note:  default initial values "	/*
			*/ "infeasible; starting from B=0"

			`vv' ///
			ml model lf heckp_lf				/*
			*/ (`depvarn': `depvar' = , `offopt')		/*
			*/ (`selname': `seldep' = `selind', `selnc' `soffopt')/*
			*/ /athrho					/*
			*/ `wgt' if `touse' , waldtest(0)		/*
			*/ collinear missing max nooutput nopreserve	/*
			*/ init(/athrho=0) search(off)  `mlopts'	/*
			*/ `crittyp' nocnsnotes
		}
		else if _rc { 
			error _rc 
		}

		local continu "continue"
	}
	local diparm diparm(athrho, tanh label("rho"))

	`qui' di in gr _n "Fitting full model:"
	`vv' ///
	capture noi ml model lf heckp_lf 				 /*
		*/ (`depvarn': `depvar' = `varlist', `offopt' `constant') /*
		*/ (`selname': `seldep' = `selind', `selnc' `soffopt')	 /*
		*/ /athrho						 /*
		*/ if `touse' `wgt',					 /*
		*/ collinear missing max nooutput nopreserve		 /*
		*/ title(Probit model with sample selection)		 /*
		*/ `score' `robust' `clusopt'				 /*
		*/ init(`from') search(off) `continu'  `mlopts'	 /*
		*/ `crittyp' `diparm'

	if _rc == 1400 & "`from'" == "`b0', copy" {
		di as txt "note:  default initial values "		 /*
		*/ "infeasible; starting from B=0"

		`vv' ///
		ml model lf heckp_lf 					 /*
		*/ (`depvarn': `depvar' = `varlist', `offopt' `constant') /*
		*/ (`selname': `seldep' = `selind', `selnc' `soffopt')	 /*
		*/ /athrho						 /*
		*/ if `touse' `wgt',					 /*
		*/ collinear missing max nooutput nopreserve		 /*
		*/ title(Probit model with sample selection)		 /*
		*/ `score' `robust' `clusopt'				 /*
		*/ init(/athrho=0) search(off) `continu'  `mlopts'	 /*
		*/ `diparm'
	} 
	else if _rc { 
		error _rc 
	}


				/* Saved results */

	if "`robust'" == "" {		/* test of independent equations */
		est scalar ll_c = `llc'
		est scalar chi2_c = abs(-2*(e(ll)-e(ll_c)))
		est local chi2_ct "LR"
	}
	else {
		qui test [athrho]_cons = 0 
		est scalar chi2_c = r(chi2)
		est local chi2_ct "Wald"
	}
	est scalar p_c = chiprob(1, e(chi2_c))
	qui _diparm athrho, tanh
	est scalar rho = r(est)
	tokenize `e(depvar)'
	if bsubstr("`2'", 1, 2) == "__" { est local depvar `1' }
	est scalar k_aux = 1
	est hidden scalar N_cens = `N_cens'
	est scalar N_nonselected = `N_cens'
	est scalar N_selected = e(N) - `N_cens'
	est local predict "heckpr_p"
	est local cmd "heckprob"
	est local marginsnomarkout PSel XBSel
	Display , level(`level') `diopts'

end



/* process the selection equation
	[depvar =] indvars [, noconstant offset ]
*/

program define SelectEq
	args seldep selind selnc seloff colon sel_eqn

	gettoken dep rest : sel_eqn, parse(" =")
	gettoken equal rest : rest, parse(" =")

	if "`equal'" == "=" { 
		_fv_check_depvar `dep'
		tsunab dep : `dep'
		c_local `seldep' `dep' 
	}
	else	local rest `"`sel_eqn'"'
	
	local 0 `"`rest'"'
	syntax [varlist(numeric default=none ts fv)] 	/*
		*/ [, noCONstant OFFset(varname numeric) ]

	if "`s(fvops)'" == "true" {
		c_local fvops 1
	}
	if "`varlist'" == "" {
		di in red "no variables specified for selection equation"
		exit 198
	}

	c_local `selind' `varlist'
	c_local `selnc' `constant'
	c_local `seloff' `offset'
end


/* handle -noskip- option */

program define ChkSkip
	args newskip colon skip robust const indvars cns

	c_local `newskip' `skip'

	if "`skip'" != "" {
		if "`robust'" != "" {
			di as txt "model LR test inappropriate with " /*
				*/ "robust covariance estimates,"
			local skip
		}
		if "`const'" != "" {
			di as txt "model LR test inappropriate with " /*
				*/ "noconstant option,"
			local skip
		}
		if "`indvars'" == "" {
			di as txt "model LR test inappropriate with " /*
				*/ "constant-only model,"
			local skip
		}
		if "`robust'" != "" {
			di as txt "model LR test inappropriate with " /*
				*/ "constraints,"
			local skip
		}
		if "`skip'" == "" {
			di as txt "    option skip ignored and " /*
				*/ "performing Wald test instead"
		}
	}

	c_local `newskip' `skip'

end


/* make a Beta_0 matrix of initial values */

program define MkB0
	args b0 colon b0sel hazvar

	tempname athrho

	mat `b0' = e(b)
	mat coleq `b0' = `e(depvar)'
	local k = colsof(`b0')

	scalar `athrho' = _b[`hazvar']
	scalar `athrho' = max(min(`athrho',.85), -.85)
	scalar `athrho' = 0.5 * log((1+`athrho') / (1-`athrho'))

	matrix `athrho' = scalar(`athrho')
	matrix colna `athrho' = athrho:_cons

	mat `b0' = `b0'[1,1..`k'-1] , `b0sel' , `athrho'
end


program define Display
	syntax [, Level(cilevel) *]

	_get_diopts diopts, `options'
	_crcshdr
	version 9: ml display , noheader level(`level') nofootnote `diopts'

	if "`e(vcetype)'" != "Robust" { 
		local testtyp LR
	}
	else    local testtyp Wald
	di in gr  "`testtyp' test of indep. eqns. (rho = 0):" /*
		*/ _col(38) "chi2(" in ye "1" in gr ") = "   /*
		*/ in ye %8.2f e(chi2_c) 		     /*
		*/ _col(59) in gr "Prob > chi2 = " in ye %6.4f e(p_c)
	_prefix_footnote
	exit e(rc)
end

