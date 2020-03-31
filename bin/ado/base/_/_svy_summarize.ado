*! version 1.7.1  30sep2019
program _svy_summarize, eclass
	version 9
	local vv : di "version " string(_caller()) ":"

	if (!replay()) local cmdline : copy local 0
	gettoken cmd 0 : 0

	quietly syntax [anything] [if] [in] [fw pw iw aw] [, VCE(passthru) *]
	if `:length local vce' {
		`vv' `BY' _vce_parserun `cmd', noeqlist : `0'
		if "`s(exit)'" != "" {
			ereturn local cmdline `"`cmdline'"'
			exit
		}
	}

	if replay() {
		is_svysum `e(cmd)'
		if !r(is_svysum) | `"`e(cmd)'"' != `"`cmd'"' {
			error 301
		}
		if _caller() >= 13 {
			if "`e(cmd)'" == "proportion" {
				syntax [, CITYPE(string) *]
				CheckCitype `citype'
				local 0 `", `options' `r(citype)'"'
			}
		}
		_prefix_display `0'
	}
	else {
		`vv' Estimate `cmd' `0'
		ereturn local cmdline `"`cmdline'"'
	}
end

program Estimate, eclass
	version 9
	local vv : di "version " string(_caller()) ":"
	gettoken cmd 0 : 0

	local fvbase fvbase(`c(fvbase)')
	set fvbase off
	is_svysum `cmd'
	if !r(is_svysum) {
		di as err "unrecognized command: `cmd'"
		exit 199
	}
	local wt "[fw pw iw aw]"
	if inlist("`cmd'","prop","proportion") {
		local propopts NOLABel SVYRW percent
		if _caller() < 16 {
			local propopts MISSing `propopts'
		}
		local nm1 nm1			// NOT DOCUMENTED
		local type mean
		local cmd proportion
		local wt "[fw pw iw]"
	}
	else	local type `cmd'
	local typeopt type(`type')

	if "`cmd'" == "ratio" {
		ParseRatio names 0 : `0'
		local wt "[fw pw iw]"
	}
	if "`cmd'" == "total" {
		if _caller() >= 16 {
			local wt "[fw pw iw]"
		}
	}

	syntax [anything]			///
		[if] [in] `wt' [,		///
		SVY				///
		`propopts'			/// -proportion- opts
		`nm1'				///
		Level(cilevel)			/// -_prefix_display- opts
		COEFLegend			///
		SELEGEND			///
		cformat(passthru)		///
		NOLSTRETCH			///
		NOOMITted			///
		OMITted				///
		vsquish				///
		NOEMPTYcells			///
		EMPTYcells			///
		NOBASElevels			///
		BASElevels			///
		NOALLBASElevels			///
		ALLBASElevels			///
		NOFVLABel			///
		FVLABel				///
		FVWRAP(passthru)		///
		FVWRAPON(passthru)		///
		noLegend			///
		noHeader			///
		noTable				///
		over(passthru)			///
		sovar(varname numeric)		/// undocumented
		FIRSTCALL			/// undocumented
		SUBpop(passthru)		///
		STDize(varname)			///
		STDWeight(varname numeric)	///
		noSTDRescale			///
		CLuster(passthru)		///
		VCE(passthru)			///
		NOVARiance			/// undocumented
		ZEROweight			///
		NOIsily				/// ignored
		TRace				/// ignored
		noDOTS				/// ignored
		dof(passthru)			///
		CITYPE(string)			///
	]

	// Sets the following macros:
	//	s(varlist)
	//	s(fvops)
	`vv' ParseVarlist `cmd' `anything'
	local varlist `"`s(varlist)'"'

	local fvops = "`s(fvops)'" == "true"

	if "`svy'`svyrw'" == "" & `"`subpop'"' != "" {
		di as err "option subpop() not allowed"
		exit 198
	}

	// vce(linearized) is the default for -ratio-
	// vce(analytic) is the default for the others
	if "`type'" == "ratio" {
		local vcespec LINEARized
	}
	else	local vcespec ANALYTIC
	_vce_parse, argopt(CLuster) opt(`vcespec') pw(linearized) old	///
		: [`weight'`exp'], `vce' `cluster'
	local cluster `r(cluster)'
	local vce = cond("`r(vce)'" != "", "`r(vce)'", lower("`vcespec'"))

	if "`svy'" != "" & "`cluster'" != "" {
		di as err "option cluster() is not allowed with svy"
		exit 198
	}

	local subopts `"`over' `subpop'"'

	local wt	// clear -wt- for call to _svy2
	local wtype	`weight'
	local wexp	`"`exp'"'
	if "`weight'" == "fweight" {
		local wt "[iweight`exp']"
	}
	else if "`weight'" == "aweight" {
		tempvar wvar
		quietly gen double `wvar' `exp'
		local wt "[pweight=`wvar']"
	}
	else if "`weight'" != "" {
		local wt "[`weight'`exp']"
	}
	if `"`cmd'"' == "proportion" {
		local cprefix "`c(prefix)'"
		if `:list posof "_svy_mkvmsp" in cprefix' {
			local nm1 nm1
		}
	}

	if _caller() >= 13 {
		if `"`citype'`cmd'"' == "proportion" {
			local citype logit
		}
	}

	if "`citype'" != "" {
		if `"`cmd'"' != "proportion" {
			di as err "option {bf:citype()} not allowed"
			exit 198
		}
		CheckCitype `citype'
		local citype `r(citype)'
	}
	
	// check syntax
	local diopts	`coeflegend'		///
			`selegend'		///
			`cformat'		///
			`nolstretch'		///
			`noomitted'		///
			`omitted'		///
			`vsquish'		///
			`noemptycells'		///
			`emptycells'		///
			`nobaselevels'		///
			`baselevels'		///
			`noallbaselevels'	///
			`allbaselevels'		///
			`nofvlabel'		///
			`fvlabel'		///
			`fvwrap'		///
			`fvwrapon'
	_get_diopts ignore
	_get_diopts diopts, `diopts'
	local diopts : list diopts - ignore
	local diopts	level(`level')		///
			`legend'		///
			`header'		///
			`table'			///
			`citype'		///
			`percent'		///
			`diopts'

	if "`missing'" != "" {
		local novarlist novarlist
	}

	// temp matrices
	tempname b
	if "`novariance'" == "" {
		tempname V Vsrs
	}

	if "`weight'" == "iweight" | "`svy'`zeroweight'" != "" {
		local zero zeroweight
	}
	if "`stdize'" != "" || "`stdweight'" != "" {
		local stdopts ///
		stdize(`stdize') stdweight(`stdweight') `stdrescale'
	}

	marksample touse, `novarlist' `zero'
	qui count if `touse'
	if `r(N)' == 0 {
		di as err "no observations"
		exit 2000
	}

	if `fvops' {
		fvexpand `varlist' if `touse'
		local varlist `"`r(varlist)'"'
	}
	local uvarlist : copy local varlist
	if "`cmd'" != "ratio" {
		local names : copy local varlist
	}

	if "`cmd'" == "proportion" & _caller() < 16 {
		local names
		local i 0
		tempname matrow
		local matrowopt matrow(`matrow')
		if "`sovar'" != "" {
			sum `sovar', mean
			local n_over `r(max)'
			if "`over'" != "" {
				local noint noint
			}
		}
		else if "`over'" != "" {
			// make sure column names are valid names, don't even
			// allow nonnegative integers
			local noint noint

			// get the number of over groups
			tempvar subuse
			quietly _svy_subpop `touse' `subuse', ///
				`over' `subpop'
			sum `subuse', mean
			local n_over `r(max)'
			local lab : value label `subuse'
			if "`lab'" != "" {
				label drop `lab'
			}
			drop `subuse'
		}
		else	local n_over 1

		preserve, changed
		local j 1
		foreach y of local varlist {
			local ++i
			tempvar yi
			capture noisily quietly			///
				tabulate `y' `if' `in',		///
				gen(`yi') `missing' `matrowopt'
			if c(rc) {
				di as err "too many categories"
				exit `c(rc)'
			}
			unab yilist : `yi'*
			local n_tvars = `n_tvars' + `: word count `yilist''
			local vlist `vlist' `yilist'
			local n_cat : word count `yilist'
			if `n_cat' > 400 {
				// too many categories
				error 149
			}
			if "`over'" != "" {
				local namelist `plabels'
			}
			_labels2names `y' `if' `in',	///
				index(`j') `nolabel'	///
				stub(_prop_) `missing'	///
				namelist(`namelist')	///
				`noint'			///
				// blank
			local j `s(indexfrom)'
			local names`i' `s(names)'
			local plabels `plabels' `names`i''
			local label`i' `"`s(labels)'"'
			Duplicate dup `n_cat' "`y' "
			local names `names' `dup'
		}
		local rc 0
		if c(k) + (`n_over'-1)*`n_tvars' > c(max_k_current) {
			local rc 900
		}
		if `n_over'*`n_tvars' > c(maxvar) {
			local rc 902
		}
		if `n_over'*`n_tvars' > c(max_matdim) {
			local rc 915
		}
		if `rc' != 0 {
			di as err "too many categories"
			exit `rc'
		}
		local varlist `vlist'
	}

	// WARNING: do not change sort order prior to calling _svy2; the
	// -subpop()- option takes the -in- option.

	if "`svy'" == "" {
		if "`type'" == "total" {
			local typeopt type(mean)
		}
	}

	if "`sovar'" != "" {
		local sovar sovar(`sovar') `firstcall'
	}

	// Point and variance estimation
	`vv'					///
	_svy2 `varlist' `wt' `if' `in',		///
		`typeopt'			///
		`svy' `zero'			///
		touse(`touse')			///
		b(`b')				///
		`vopt'				///
		v(`V')				///
		cluster(`cluster')		///
		vsrs(`Vsrs')			///
		`subopts'			///
		`sovar'				///
		`stdopts'			///
		`dof'				///
		`fvbase'			///
		// blank
	local over_namelist	`"`r(over_namelist)'"'
	local OVER_NAMELIST	`"`r(OVER_NAMELIST)'"'

	tempname osub nsub
	matrix `osub' = r(_N)
	matrix `nsub' = r(_N_subp)
	local over_N `osub' `nsub'
	if "`svy'" != "" & "`novariance'" == "" {
		if "`r(poststrata)'`stdize'" == "" {
			if "`r(fpc1)'" != "" {
				local Vsrswr `Vsrs'_wr
			}
			if `"`subpop'`over'"' != "" {
				local Vsrssub `Vsrs'sub
				if "`r(fpc1)'" != "" {
					local Vsrssubwr `Vsrs'sub_wr
				}
			}
		}
		else {
			local Vsrs
		}
	}
	if "`svy'" == "" {
		if "`type'" == "total" {
			if "`wtype'" == "aweight" {
				srsTotal `b' `osub'
			}
			else {
				srsTotal `b' `nsub'
			}
		}
		if "`novariance'" == "" {
			if "`wtype'" != "pweight" & "`cluster'" == "" {
				matrix drop `V'
				if "`over'" == "" {
					local V `Vsrs'
				}
				else {
					local V `Vsrs'sub
				}
				if "`cmd'" != "mean" & "`wtype'" != "iweight" {
					local Vsrs
				}
			}
			else if "`over'" != "" {
				local Vsrs `Vsrs'sub
			}
			if "`type'" == "total" {
				if "`wtype'" == "aweight" {
					CompTvar `V' `osub'
				}
				else {
					CompTvar `V' `nsub'
				}
			}
			if "`cmd'`nm1'" == "proportion" ///
			 & inlist("`wtype'","","fweight","iweight") {
				if "`cluster'" == "" {
					AdjV4prop `V' `osub' `nsub'
				}
				else if "`Vsrs'" != "" {
					AdjV `Vsrs' `osub' `nsub'
				}
			}
			else if inlist("`wtype'","fweight","iweight") {
				if "`cluster'" == "" {
					AdjV `V' `osub' `nsub'
				}
				else if "`Vsrs'" != "" {
					AdjV `Vsrs' `osub' `nsub'
				}
			}
		}
		if "`cmd'" == "proportion" {
			tempname freq
			mata: st_matrix("`freq'",	///
				st_matrix("`b'") :*	///
				st_matrix("`nsub'"))
		}
	}

	if _caller() >= 16 {
		LabelMatrices ///
			`b' `V' `Vsrs' `Vsrssub' `Vsrswr' `Vsrssubwr' ///
			`over_N' : `names' : `over_namelist'
		local fvops 1
	}
	else if "`cmd'" != "proportion" {
		LabelMatrices15 ///
			`b' `V' `Vsrs' `Vsrssub' `Vsrswr' `Vsrssubwr' ///
			`over_N' : `names' : `over_namelist'
	}
	else {
		LabelMatrices2 ///
			`b' `V' `Vsrs' `Vsrssub' `Vsrswr' `Vsrssubwr' ///
			`over_N' : `names' : `plabels' : `over_namelist'
	}
	if "`cmd'" == "proportion" {
		tempname error
		matrix `error' = r(error)
		local dim = colsof(`error')
		forval i = 1/`dim' {
			if `error'[1,`i'] != 3 & `b'[1,`i'] == 0 {
				matrix `error'[1,`i'] = 1
			}
		}
	}
	if _caller() >= 16 & "`V'" != "" {
		if "`cmd'" != "proportion" {
			tempname error
			matrix `error' = r(error)
			local dim = colsof(`error')
		}
		forval i = 1/`dim' {
			if `error'[1,`i'] == 0 {
				if `b'[1,`i'] == 0 {
					if `V'[`i',`i'] == 0 {
						matrix `error'[1,`i'] = 5
					}
				}
			}
		}
	}

	local dim : list sizeof over_namelist
	local DIM : list sizeof OVER_NAMELIST
	if `dim' < `DIM' & c(emptycells) == "keep" {
		local mlist	`osub'		///
				`nsub'		///
				`freq'		///
				`V'		///
				`Vsrs'		///
				`Vsrssub'	///
				`Vsrswr'	///
				`Vsrssubwr'
		// `b' and `error' are special cases
		mata: _svy_summarize_resize()
	}

	if `fvops' {
		local XTRA buildfvinfo noHmat
	}

	ereturn post `b' `V',		///
		dof(`r(df_r)')		///
		obs(`r(N)')		///
		esample(`touse')	///
		`XTRA'
	_r2e

	ereturn hidden local depvar = proper("`cmd'")
	ereturn local novariance "`novariance'"
	ereturn local nolabel `"`nolabel'"'
	ereturn local marginsnotok _ALL
	ereturn hidden local predict _no_predict
	ereturn local varlist `uvarlist'
	if "`svy'" != "" {
		ereturn local estat_cmd svy_estat
	}
	else	ereturn local estat_cmd estat_vce_only
	if "`cmd'" == "ratio" {
		ereturn local namelist	`names'
	}
	if "`error'" != "" {
		ereturn matrix error	`error'
	}
	if `:list sizeof plabels' {
		ereturn local namelist	`:list retok plabels'
		forval i = 1/`:word count `uvarlist'' {
			ereturn local label`i' `"`label`i''"'
		}
	}

	if `fvops' & `"`e(V)'"' == "matrix" {
		mata: _svy_summarize_fix_empty()
	}

	if _caller() >= 16 {
		ereturn hidden scalar version = 2
		if "`cmd'" != "ratio" {
			PostMargDims
		}
	}
	// else e(version) is missing

	local k_eq : coleq e(b)
	local k_eq : list uniq k_eq
	local k_eq : word count `k_eq'
	ereturn scalar k_eq = `k_eq'
	if inlist("`cmd'", "proportion", "ratio") {
		ereturn hidden scalar k_eform = 0
	}
	ereturn matrix _N `osub'
	if "`svy'" != "" {
		if "`Vsrs'" != "" {
			ereturn matrix V_srs `Vsrs'
			if "`Vsrssub'" != "" {
				ereturn matrix V_srssub `Vsrssub'
			}
			if "`Vsrswr'" != "" {
				ereturn matrix V_srswr `Vsrswr'
			}
			if "`Vsrssubwr'" != "" {
				ereturn matrix V_srssubwr `Vsrssubwr'
			}
		}
		ereturn matrix _N_subp	`nsub'
		ereturn local vce	linearized
		ereturn local vcetype	Linearized
		ereturn local title = ///
			"Survey: " + proper("`cmd'") + " estimation"
		if "`cmd'" == "ratio" {
			local n_names : word count `names'
			local j 0
			forval i = 1/`n_names' {
				local name : word `i' of `names'
				local num : word `++j' of `uvarlist'
				local den : word `++j' of `uvarlist'
				local myargs ///
					`"`myargs' (`name':`num'/`den')"'
			}
		}
		else	local myargs `uvarlist'
		if "`over'" != "" {
			local oopt `", `over' `missing'"'
		}
		else	local oopt `", `missing'"'
		local command `"`cmd' `myargs'`oopt'"'
		ereturn local command `"`:list retok command'"'
		ereturn local cmdname	`cmd'
		ereturn local prefix	svy
	}
	else {
		if "`cmd'" == "mean" {
			if "`Vsrs'" != "" &	///
			 ( "`wtype'" == "pweight" | "`cluster'" != "" ) {
				ereturn hidden matrix V_srs `Vsrs'
				if "`Vsrssub'" != "" {
					ereturn hidden matrix V_srssub `Vsrssub'
				}
			}
			if inlist("`wtype'", "fweight", "iweight") {
				ereturn matrix _N_subp	`nsub'
			}
			else	ereturn local _N_subp
		}
		else	ereturn local _N_subp
		if "`wtype'" != "" {
			ereturn local wtype `wtype'
			ereturn local wexp `"`wexp'"'
		}
		ereturn local title = proper("`cmd'") + " estimation"
		ereturn local singleton
		ereturn local census
		ereturn local N_strata_omit
		if "`cluster'" != "" {
			ereturn local clustvar `cluster'
			ereturn local vcetype	Robust
		}
		else if "`cmd'" == "ratio" {
			ereturn local vcetype	Linearized
		}
		ereturn local vce "`vce'"
		if "`freq'" != "" {
			ereturn matrix freq `freq'
		}
	}
	if "`novariance'"=="" {
		_post_vce_rank
	}

	// hide ereturn     matrix   e(_N_strata_certain)
	// matrix   e(_N_strata_single) matrix   e(_N_strata)
	if( "`svy'" == "" & ///
		( "`cmd'" == "mean" | "`cmd'" == "proportion" | ///
		| "`cmd'" == "ratio" | "`cmd'" == "total") ) {

		tempname copy_N_strata_certain copy_N_strata_single copy_N_strata

		matrix `copy_N_strata_certain' = e(_N_strata_certain)
		ereturn hidden matrix	_N_strata_certain = `copy_N_strata_certain'
		matrix `copy_N_strata_single' = e(_N_strata_single)
		ereturn hidden matrix	_N_strata_single = `copy_N_strata_single'
		matrix `copy_N_strata' = e(_N_strata)
		ereturn hidden matrix	_N_strata = `copy_N_strata'

	}

	if _caller() >= 16 {
		if "`e(prefix)'`cmd'" == "mean" {
			quietly noi mean_estat_sd
			if "`r(sd)'" == "matrix" {
				tempname sd
				matrix `sd' = r(sd)
				ereturn matrix sd `sd'
			}
		}
	}

	// post this very last
	ereturn local cmd `cmd'

	_prefix_display, `diopts'
end

program ParseVarlist, sclass
	version 16

	sreturn clear
	gettoken cmd 0 : 0
	if _caller() < 16 | "`cmd'" == "ratio" {
		syntax [varlist(numeric)]
		sreturn local varlist `"`varlist'"'
	}
	else if "`cmd'" == "proportion" {
		_fvonlyparse `0'
		sreturn local varlist `"`r(varlist)'"'
		sreturn local fvops `"`r(fvops)'"'
	}
	else {	// cmd is mean or total
		syntax [varlist(numeric fv)]
		sreturn local varlist `"`varlist'"'
		// s(fvops) set by -syntax-
	}
end


program srsTotal
	args b nsub

	matrix `b' = `b'*diag(`nsub')
end

program CompTvar
	args V nsub
	// adjustment for -total- estimator
	tempname c
	matrix `c' = diag(`nsub')
	matrix `V' = `c'*`V'*`c'
end

program AdjV
	args V osub nsub

	local dim = colsof(`osub')
	tempname c
	matrix `c' = J(`dim',`dim',0)
	forval i = 1/`dim' {
	    if `nsub'[1,`i'] > 1 {
		matrix `c'[`i',`i'] = sqrt((`osub'[1,`i']-1)/(`nsub'[1,`i']-1))
	    }
	    else {
		matrix `c'[`i',`i'] = 0
	    }
	}
	matrix `V' = `c'*`V'*`c'
end

program AdjV4prop
	args V osub nsub

	local dim = colsof(`osub')
	tempname c
	matrix `c' = J(`dim',`dim',0)
	forval i = 1/`dim' {
	    if `nsub'[1,`i'] {
		matrix `c'[`i',`i'] = sqrt((`osub'[1,`i']-1)/(`nsub'[1,`i']))
	    }
	}
	matrix `V' = `c'*`V'*`c'
end

program ParseRatio
	_on_colon_parse `0'
	tokenize `s(before)'
	args c_names c_0

	local 0 `s(after)'
	syntax anything(name=spec id="ratio specification")	///
		[if] [in] [fw pw iw] [, * ]

	local myif `if'
	local myin `in'
	local myoptions `options'

	if "`weight'" != "" {
		local wt [`weight'`exp']
	}

	gettoken speci spec : spec, parse("()") match(par)

	if "`par'" == "" & `"`spec'"' != "" {
		di as err ///
		"parentheses are required for multiple ratio specifications"
		exit 198
	}

	local spec `"(`speci')`spec'"'
	local i 0
	while `"`spec'"' != "" {
		local ++i
		gettoken speci spec : spec, parse(" ()") match(par)
		if "`par'" == "" {
			di as err ///
"parentheses are required for multiple ratio specifications"
			exit 198
		}
		gettoken name speci : speci, parse(":")
		if `"`speci'"' != "" {
			confirm name `name'
			gettoken colon ratio : speci, parse(":")
		}
		else {
			local ratio `name'
			local name _ratio_`i'
		}
		local 0 : subinstr local ratio "/" " ", all count(local c)
		if `c' > 1 {
			di as err "invalid ratio specification: too many '/'"
			exit 198
		}
		if `c' == 1 {
			gettoken var1 ratio : ratio, parse(" /")
			gettoken slash var2 : ratio, parse(" /")
			if "`slash'" != "/" {
				di as err ///
				"invalid ratio specification: '/' misplaced"
				exit 198
			}
			local 0 `var1' `var2'
		}
		syntax varlist(min=2 max=2)
		local vlist `vlist' `varlist'
		local names `names' `name'
	}

	c_local `c_names' `names'
	c_local `c_0' `vlist' `myif' `myin' `wt', `myoptions'
end

program LabelMatrices
	_on_colon_parse `0'
	local mats	`"`s(before)'"'
	_on_colon_parse	`s(after)'
	local nlist	`s(before)'
	local olist	`s(after)'		// no quotes to trim spaces

	if "`olist'" == "" {
		local stripe `nlist'
	}
	else {
		foreach n of local nlist {
			foreach o of local olist {
				local stripe `stripe' `n'@`o'
			}
		}
	}

	foreach m of local mats {
		matrix colname	`m' = `stripe'
		if rowsof(`m') == colsof(`m') {
			matrix rowname	`m' = `stripe'
		}
	}
end

program LabelMatrices15
	_on_colon_parse `0'
	local mats	`"`s(before)'"'
	_on_colon_parse	`s(after)'
	local names	`s(before)'
	local labels	`s(after)'		// no quotes to trim spaces

	if "`labels'" == "" {
		local labels `names'
		local names _
	}
	local nvars : word count `names'
	local nlabs : word count `labels'
	local nlist
	foreach var of local names {
		Duplicate dup `nlabs' "`var' "
		local nlist `nlist' `dup'
	}
	Duplicate labels `nvars' "`labels' "

	foreach m of local mats {
		matrix coleq	`m' = `nlist'
		matrix colname	`m' = `labels'
		if rowsof(`m') == colsof(`m') {
			matrix roweq	`m' = `nlist'
			matrix rowname	`m' = `labels'
		}
	}
end

program LabelMatrices2
	_on_colon_parse `0'
	local mats	`"`s(before)'"'
	_on_colon_parse	`s(after)'
	local names	`s(before)'
	_on_colon_parse `s(after)'
	local plabels	`s(before)'
	local labels	`"`s(after)'"'

	if trim(`"`labels'"') != "" {
		local n_over : word count `labels'
		local n_cat : word count `names'
		forval i = 1/`n_cat' {
			local uname : word `i' of `plabels'
			Duplicate propi `n_over' `"`uname' "'
			local nlist `nlist' `propi'
		}
		local pnames `names'
		local names `nlist'
		Duplicate labels `n_cat' `"`labels' "'
	}
	else	local labels `plabels'
	foreach m of local mats {
		matrix coleq	`m' = `names'
		matrix colname	`m' = `labels'
		if rowsof(`m') == colsof(`m') {
			matrix roweq	`m' = `names'
			matrix rowname	`m' = `labels'
		}
	}
end

program MakeDeff, eclass
	args Vsrs Vsrswr
	tempname f V deff deft

	if "`e(poststrata)'`e(stdize)'" != "" {
		exit
	}

	matrix `V' = vecdiag(e(V))
	local dim = colsof(`V')
	matrix `deff' = `V'
	matrix `deft' = `V'
	if "`Vsrswr'" != "" {
		local Vdeft `Vsrswr'
	}
	else	local Vdeft `Vsrs'

	forval i = 1/`dim' {
		scalar `f' = `V'[1,`i']/`Vsrs'[`i',`i']
		matrix `deff'[1,`i'] = cond(missing(`f'),0,`f')

		scalar `f' = sqrt(`V'[1,`i']/`Vdeft'[`i',`i'])
		matrix `deft'[1,`i'] = cond(missing(`f'),0,`f')
	}

	ereturn matrix V_srs	= `Vsrs'
	if "`Vsrswr'" != "" {
		ereturn matrix V_srswr	= `Vsrswr'
	}
	ereturn matrix deff	= `deff'
	ereturn matrix deft	= `deft'
end

program Duplicate
	args c_lmac n string
	if `n' > 400 {
		while `n' > 400 {
			local dup2 : di _dup(400) `"`string'"'
			local dup `"`dup' `dup2'"'
			local n = `n' - 400
		}
		if `n' > 0 {
			local dup2 : di _dup(`n') `"`string'"'
			local dup `"`dup' `dup2'"'
		}
		c_local `c_lmac' `"`dup'"'
	}
	else {
		c_local `c_lmac' : di _dup(`n') `"`string'"'
	}
end

program CheckCitype, rclass
	syntax [anything(name=citype)] [, UNADJusted]
	
	local k : list sizeof citype
	if `k' == 0 {
		local citype logit
	}
	if `k' > 1 {
		di as err `"option {bf:citype()} invalid"'
		di as err "only one CI type is allowed"
		exit 198
	}
	local 0 , `citype'
	syntax [, logit NORMal wald wilson exact AGRESti JEFFreys *]
	if !missing(`"`options'"') {
		di as err `"invalid {bf:citype()} option;"'
		di as err `"{bf:`citype'} is not a recognized CI type"'
		exit 198
	}

	if inlist("`citype'","wald","normal","logit") {
		if "`unadjusted'" != "" {
			di as err "option {bf:unadjusted} not " ///
				"allowed with {bf:`citype'} confidence interval"
			exit 198
		}
	}

	return local citype "citype(`citype',`unadjusted')"
end

program PostMargDims, eclass
	_b_term_info
	local k = r(k_terms)
	forval i = 1/`k' {
		if "`r(level`i')'" == "matrix" {
			local colna : colna r(level`i')
			local dims : list dims | colna
		}
	}
	local dims : list uniq dims
	local _CONS _cons
	local dims : list dims - _CONS
	if `k' > 1 {
		local dims `dims' _term
	}
	ereturn hidden local marg_dims `"`dims'"'
end

mata:

void _svy_summarize_resize()
{
	string	vector	nlist
	real	scalar	ndim
	string	vector	olist
	real	scalar	odim
	real	scalar	dim
	string	scalar	mname
	string	matrix	oldms
	string	matrix	newms
	string	scalar	spec
	real	scalar	i
	real	scalar	j
	real	scalar	pos
	string	scalar	tmp
	real	vector	colnumb
	real	matrix	oldX
	real	matrix	newX
	string	vector	mlist

	nlist	= tokens(st_local("names"))
	ndim	= cols(nlist)
	olist	= tokens(st_local("OVER_NAMELIST"))
	odim	= cols(olist)
	dim	= ndim*odim

	mname	= st_local("b")
	oldms	= st_matrixcolstripe(mname)
	newms	= J(dim,2,"")
	pos	= 0
	for (i=1; i<=ndim; i++) {
		for (j=1; j<=odim; j++) {
			pos++
			spec = sprintf("%s@%s", nlist[i], olist[j])
			newms[pos,2] = spec
			colnumb = st_matrixcolnumb(mname, newms[pos,])
			if (missing(colnumb)) {
				(void) _msparse(spec, 1)
				newms[pos,2] = spec
			}
		}
	}

	tmp = st_tempname()
	st_matrix(tmp, J(1,dim,0))
	st_matrixcolstripe(tmp, newms)
	colnumb = st_matrixcolnumb(tmp, oldms)

	// resize b
	oldX = st_matrix(mname)
	newX = st_matrix(tmp)
	newX[colnumb] = oldX
	st_matrix(mname, newX)
	st_matrixcolstripe(mname, newms)

	// resize error
	mname = st_local("error")
	if (mname != "") {
		oldX = st_matrix(mname)
		newX = J(1,dim,1)
		newX[colnumb] = oldX
		st_matrix(mname, newX)
	}

	mlist	= tokens(st_local("mlist"))
	j	= cols(mlist)
	for (i=1; i<=j; i++) {
		mname = mlist[i]
		oldX = st_matrix(mname)
		if (rows(oldX) == 1) {
			newX = J(1,dim,0)
			newX[colnumb] = oldX
			st_matrix(mname, newX)
			st_matrixcolstripe(mname, newms)
		}
		else {
			newX = J(dim,dim,0)
			newX[colnumb,colnumb] = oldX
			st_matrix(mname, newX)
			st_matrixcolstripe(mname, newms)
			st_matrixrowstripe(mname, newms)
		}
	}
}

void _svy_summarize_fix_empty()
{
	string	matrix	stripe
	real	matrix	info
	real	vector	b	
	real	vector	v	
	real	vector	error	
	real	vector	codes	
	real	scalar	dim
	real	scalar	i
	string	scalar	cmd
	real	scalar	rc
	real	scalar	check
	real	scalar	k
	real	scalar	j
	real	scalar	lev

	stripe	= st_matrixcolstripe("e(b)")
	info	= st_matrixcolstripe_fvinfo("e(b)")
	b	= st_matrix("e(b)")
	v	= st_matrix("e(V)")
	error	= st_matrix("e(error)")
	codes	= (0,5,6,7)

	dim = cols(error)
	for (i=1; i<=dim; i++) {
		if (b[i] != 0) {
			continue
		}
		if (v[i,i] != 0) {
			continue
		}
		if (info[i+1,2] != 0) {
			if (st_local("cmd") != "ratio") {
				continue
			}
		}
		cmd = sprintf("_ms_parse_parts %s", stripe[i,2])
		rc = _stata(cmd)
		if (rc) exit(rc)
		check = 0
		if (st_global("r(type)") == "factor") {
			check = 1
		}
		else if (st_global("r(type)") == "interaction") {
			k = st_numscalar("r(k_names)")
			for (j=1; j<=k; j++) {
				lev = _b_get_scalar(sprintf("r(level%f)",j),.)
				if (lev != .) {
					check = 1
					break
				}
			}
		}
		if (check) {
			if (anyof(codes, error[i])) {
				error[i] = 1
			}
			if (error[i] == 1) {
				if (st_local("cmd") == "ratio") {
					info[i+1,2] = 0
				}
			}
		}
	}
	if (st_local("cmd") == "ratio") {
		st_matrixcolstripe_fvinfo("e(b)", info)
	}
	st_matrix("e(error)", error)
}

end

exit
