*! version 1.4.0  08mar2018
program define heckoprobit, eclass byable(onecall) ///
		properties(svyb svyj svyr bayes)
	version 13.0
	local vv : di "version " string(_caller()) ":"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun heckoprobit, mark(OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 12: ereturn local cmdline `"heckoprobit `0'"'
		exit
	}

	version 12
	if replay() {
		if "`e(cmd)'" != "heckoprobit" { 
			error 301 
		}
		if _by() { 
			error 190 
		}
		Display `0'
		exit
	}
	`vv' `BY' Estimate `0'
	ereturn local cmdline `"heckoprobit `0'"'
	ereturn local cmd "heckoprobit"
end

program define Estimate, eclass byable(recall)
	version 13.0
	local vv : di "version " string(_caller()) ":"
	gettoken depvar 0 : 0 , parse(" =,[")
	fvexpand `depvar'
	if "`r(fvops)'" == "true" {
		di as err "dependent variable may not be a factor variable"
		exit 198
	}
	tsunab depvar : `depvar'
	local tsname = cond( match("`depvar'", "*.*"), 		///
		bsubstr("`depvar'",(index("`depvar'",".")+1),.),	///
		"`depvar'")
	confirm variable `tsname'
	
	local depname : subinstr local depvar "." "_"
	gettoken equals rest : 0 , parse(" =")
	if "`equals'" == "=" { 
		local 0 `"`rest'"' 
	}
	syntax [varlist(numeric default=none ts fv)] 	///
		[pw iw fw] [if] [in], 			///
		SELect(string) [			///
		FROM(string)				///
		OFFset(varname numeric ts)		///
		VCE(passthru)				///
		Robust					/// ndoc
		CLuster(varname)			/// ndoc
		Level(cilevel) 				///
		FIRst					///
		NOLOg LOg				///
		noHEADer				///
		noFOOTnote				///
		moptobj(passthru)			/// not documented
		* 					///
		]

	SelectEq seldep selind selnc seloff : `"`select'"'
	//selnc - noconstant for select()
	//seloff - offset for select()
	
	if "`varlist'" == "" {
		di as err "no variables specified for outcome equation"
		exit 198
	}

	_get_diopts diopts options, `options'
	mlopts mlopts, `options'
	local coll `s(collinear)'
	local cns constraint(`s(constraints)')

	if "`first'" == "" {
		local show1st "nocoef"
	}
	if "`weight'" != "" { 
		local wgt `"[`weight'`exp']"' 
	}
	if "`cluster'" != "" { 
		local clusopt "cluster(`cluster')" 
	}
	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" != "" { 
		local qui "quietly" 
	}
	if "`offset'" != "" { 
		local offopt "offset(`offset')" 
	}
	if "`seloff'" != "" { 
		local soffopt "offset(`seloff')" 
	}
        _vce_parse, argopt(CLuster) opt(Robust oim opg) old: ///
                `wgt', `vce' `clusopt' `robust'
	local vceopt `r(vceopt)'
        local robust `r(robust)'

	if "`seldep'" == "" {
		tempname seldep
		gen byte `seldep' = `depvar' < .
		local selname "select"
	}
	else local selname : subinstr local seldep "." "_"
	
	marksample touse, novarlist
	markout `touse' `seldep' `selind'
	marksample touse2
	markout `touse2' `depvar' `varlist' `offset'
	qui replace `touse' = 0 if `seldep' & !`touse2'

	// check collinearity
	qui capture _rmcoll `seldep' `selind' `wgt' if `touse', ///
		`coll' `selnc' probit `soffopt'
	if _rc {
		di as txt "selection equation:" _c
		_rmcoll `seldep' `selind' `wgt' if `touse', ///
			`coll' probit `soffopt'
	}
	local vars `r(varlist)'
	gettoken lhs selind : vars

	qui capture _rmcoll `depvar' `varlist' `wgt' if `touse' & `seldep', ///
		oprobit `coll' `offopt'
	if _rc {
		di as txt "outcome equation:" _c
		_rmcoll `depvar' `varlist' `wgt' if `touse', ///
		oprobit `coll' `offopt'		
	}
	local vars `r(varlist)'
	gettoken lhs varlist : vars
	tempname cat 
        matrix `cat' = r(cat)
        local ncat = r(k_cat)
        if (`ncat' == 1) {
                error 148
        }
        local ncut = `ncat' - 1
	global CUT_PTS ""
        forval i = 1/`ncut' {
                local cuts "`cuts' /cut`i'"
        }

	qui _regress `seldep' `wgt' if !`seldep' & `touse'
	local N_cens = e(N)

	// starting values
	
	tempname b0 bb bcut bbsel athrho ll_c

	// oprobit model if selected	
	di as txt _n "Fitting oprobit model:"

	`vv' ///
	oprobit `depvar' `varlist' `wgt' if `touse' & `seldep' 	///
		,nocoef `offopt' `cns' nocnsnotes `coll' `vceopt' `mllog'
	local out_N_cd = e(N_cd)
	// if complete determination and missing standard errors, 
	// we have a problem
	// will display the note below output table
	
	mat `bb' = e(b) // contains cutpoints
	local cols = colsof(`bb')
	mat `bcut' = `bb'[1,(`cols'-(`e(k_cat)'-2))..`cols']
	mat `bb' = `bb'[1,1..(`cols'-(`e(k_cat)'-1))]
        matrix `b0' = nullmat(`b0'), `bb'
	scalar `ll_c' = e(ll) 

	// probit model of selection	
	di as txt _n "Fitting selection model:"
	probit `seldep' `selind' `wgt' if `touse',  	///
		asis  `show1st' `selnc' `soffopt' `cns'		///
		`coll' nocnsnotes `vceopt' `mllog'
	local sel_N_cdf = e(N_cdf)
	local sel_N_cds = e(N_cds)
	// if complete determination and missing standard errors, 
	// we have a problem
	// will display the note below output table


	mat `bbsel' = e(b)
        matrix `b0' = nullmat(`b0'), `bbsel'
	if "`robust'" == "" { 
		scalar `ll_c' = `ll_c' + e(ll) 
		di as txt _n "Comparison:    log likelihood = " ///
		 as res %10.0g `ll_c' 
	}
		
	// athrho
	matrix `athrho' = J(1,1,0)
	if _caller() < 15 {
		matrix colna `athrho' = athrho:_cons	
	}
	else {
		matrix colna `athrho' = /athrho
	}
        matrix `b0' = nullmat(`b0'), `bcut', `athrho'
	if "`from'" == "" {
	        local from `b0', copy
		local initsearch init(`from') search(off)
	}
	else {
		local initsearch init(`from') search(on)
	}

	// ML estimation 
	local diparm diparm(athrho, tanh label("rho"))
	di as txt _n "Fitting full model:"
	nobreak {
		mata: heckoprob_init("inits","`seldep'","`ncut'", ///
			"`ncat'","`cat'","`touse'")
	}
	capture noisily break {
		`vv' ///
		noi ml model lf2 heckop_lf2()				///
		(`depname': `depvar' = `varlist', noconstant `offopt')	///
		(`selname': `seldep' = `selind', `selnc' `soffopt')	///
		`cuts' /athrho						///
		if `touse' `wgt',					///
		title(Ordered probit model with sample selection)	///
		`initsearch' max missing `nooutput' `cns' 		///
		`mllog' `mlopts' `diparm' `coll'			///
		`vceopt' nopreserve userinfo(`inits') `moptobj'
	}	
	local erc = _rc
        capture mata: rmexternal("`inits'")
        if (`erc') {
                exit `erc'
        }
	ereturn repost, buildfvinfo ADDCONS
	ereturn local marginsok		default		///
					pmargin		///
					p1		///
					p0		///
					pcond1		///
					pcond0		///
					psel		///
					xb		///
					xbsel
	ereturn hidden local marginsnomarkout PSel XBSel

	ereturn local marginsnotok	stdp stdpsel

	forval i = 1/`ncat' {
		local j = `cat'[1,`i']
		local mdflt `mdflt' predict(pmargin outcome(`j'))
	}
	ereturn local marginsdefault `"`mdflt'"'
	ereturn local predict "heckopr_p" 
	ereturn local properties `e(properties)'
	ereturn local technique `e(technique)'
	ereturn local user `e(user)'
	ereturn local ml_method `e(ml_method)'
	ereturn local which `e(which)'
	ereturn local opt `e(opt)'
	ereturn local vcetype `e(vcetype)'
	ereturn local vce `e(vce)'
	
		
	if "`robust'" == "" {		/* test of independent equations */
		ereturn scalar ll_c = `ll_c'
		ereturn scalar chi2_c = abs(-2*(e(ll)-e(ll_c)))
		ereturn local chi2_ct "LR"
	}
	else {
		qui test _b[/athrho] = 0 
		ereturn scalar chi2_c = r(chi2)
		ereturn local chi2_ct "Wald"
	}
	
	ereturn local  chi2type `e(chi2type)'
	ereturn local offset2 `e(offset2)'
	ereturn local offset1 `e(offset1)'
	ereturn local clustvar `e(clustvar)'	
	ereturn local title "Ordered probit model with sample selection"
	ereturn local wexp = "`exp'"
	ereturn local wtype `e(wtype)'
	if ("`selname'" == "select") {
		ereturn local depvar `depvar'
	}
	else {
		ereturn local depvar `e(depvar)'
	}

	
	ereturn scalar p_c = chi2tail(1, e(chi2_c))
	`vv' ///
	qui _diparm athrho, tanh
	ereturn hidden local marginsprop addcons
	ereturn scalar rho = r(est)
	ereturn scalar k_aux = 1 + `ncut'
	ereturn hidden scalar N_unc  = e(N) - `N_cens'
	ereturn hidden scalar N_cens = `N_cens'
	ereturn scalar N_selected  = e(N) - `N_cens'
	ereturn scalar N_nonselected = `N_cens'

	ereturn matrix cat = `cat', copy
	ereturn hidden local edepvar `depvar'
	if ("`selname'" != "select") {
		ereturn hidden local eseldep `seldep'
	}
	ereturn hidden local encut `ncut'
	ereturn hidden local encat `ncat'
	ereturn hidden local eselind `selind'
	ereturn hidden scalar sel_N_cdf = `sel_N_cdf'
	ereturn hidden scalar sel_N_cds = `sel_N_cds'
	ereturn hidden scalar out_N_cd = `out_N_cd'
	
	ereturn scalar N = e(N)
	if (e(N_cens) != .) {
		ereturn hidden scalar N_cens = e(N_cens)
		ereturn scalar N_nonselected = e(N_cens)
	}
	if (e(N_cd) != .) {
		ereturn scalar N_cd = e(N_cd)
	}	
	ereturn scalar k_cat = `ncat'
        ereturn scalar k = e(k)
        ereturn scalar k_eq = e(k_eq)
        ereturn scalar k_eq_model = e(k_eq_model)
        ereturn scalar k_aux = e(k_aux)
        ereturn scalar k_dv = e(k_dv)
	ereturn scalar df_m = e(df_m)
        ereturn scalar ll = e(ll)
        ereturn scalar ll_c = e(ll_c)
	if (e(N_clust) != .) {
		ereturn scalar N_clust = e(N_clust)
	}	
        ereturn scalar chi2 = e(chi2)
	ereturn scalar chi2_c = e(chi2_c)
	ereturn scalar p_c =  e(p_c)
        ereturn scalar p = e(p)
        ereturn scalar rho = e(rho)
        ereturn scalar rank = e(rank)
        ereturn scalar ic = e(ic)
        ereturn scalar rc = e(rc)  
        ereturn scalar converged = e(converged)

	di _n
	Display , level(`level') `diopts' `header' `footnote'
end



/* process the selection equation
	[depvar =] indvars [, noconstant offset ]
*/

program define SelectEq
	args seldep selind selnc seloff colon sel_eqn

	gettoken dep rest : sel_eqn, parse(" =")
	gettoken equal rest : rest, parse(" =")

	if "`equal'" == "=" { 
		fvexpand `dep'
		if "`r(fvops)'" == "true" {
			di as err "dependent variable may not be a factor variable"
			exit 198
		}
		tsunab dep : `dep'
		c_local `seldep' `dep' 
	}
	else	local rest `"`sel_eqn'"'
	
	local 0 `"`rest'"'
	syntax [varlist(numeric default=none ts fv)] 	///
		[, noCONstant OFFset(varname numeric) ]

	if "`varlist'" == "" {
		di as err "no variables specified for selection equation"
		exit 198
	}

	c_local `selind' `varlist'
	c_local `selnc' `constant'
	c_local `seloff' `offset'
end

program define Display
	syntax [, 		///
		noHEADer 	///
		noFOOTnote 	///
		Level(cilevel) 	///
		*		///
		]

	_get_diopts diopts, `options'
	if "`header'"=="" {
		_crcshdr
	}
	version 12: ml display , noheader level(`level') nofootnote `diopts'
	if "`e(vcetype)'" != "Robust" { 
		local testtyp LR
	}
	else    local testtyp Wald
	if "`footnote'" == "" {
		di in gr  "`testtyp' test of indep. eqns. (rho = 0):" 	///
			_col(38) "chi2(" in ye "1" in gr ") = "   	///
			in ye %8.2f e(chi2_c) 		     		///
			_col(59) in gr "Prob > chi2 = " 		///
			in ye %6.4f e(p_c)
		if (e(out_N_cd) > 0) {
			local e =  e(out_N_cd)
			di as text `e' ///
			" outcome observations completely determined."
		}
		if (e(sel_N_cds) > 0 | e(sel_N_cdf) > 0) {
			local ef = e(sel_N_cdf)
			local es = e(sel_N_cds)
			di as text `ef' " failures and " `es' ///
			" successes for selection completely determined"
		}
		if (e(out_N_cd)+e(sel_N_cds)+e(sel_N_cdf) != 0) {
			di as text "Standard errors questionable."
		}
	}
	exit e(rc)
end
exit
