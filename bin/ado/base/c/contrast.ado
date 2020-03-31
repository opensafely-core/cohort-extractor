*! version 1.4.0  18mar2019
program contrast
	version 12
	if replay() & "`e(cmd)'" == "contrast" {
		_marg_report `0'
		exit
	}

	if inlist("`e(cmd)'", "contrast", "pwcompare", "pwmean", ///
			"npregress", "threshold") {
		di as err ///
`"{bf:contrast} is not allowed with results from the {bf:`e(cmd)'} command"'
		exit 322
	}
	if (`"`e(_contrast_not_ok)'"'=="_ALL") {
		di as err ///
`"{bf:contrast} is not allowed with results from the {bf:`e(cmd)'} command"'
		exit 322	
	}
	_check_eclass
	if (!has_eprop(b)) {
		error 321
	}
	Contrast `0'
end

program Contrast, rclass
	local cmdline : copy local 0
	local ecmd = e(cmd)
	local matchlist margins mean proportion ratio total
	local match : list ecmd in matchlist
	if "`ecmd'" == "margins" {
		local EXTRAOPTS noATLegend
		local margN `"`e(N)'"'
	}
	if "`e(cmd)'" == "mixed" {
		local EXTRAOPTS SMALL
	}

	syntax anything(id="contrast specification") [,		///
		OVERall						///
		EQuation(passthru)				///
		ATEQuations					///
		ASBALanced					/// default
		ASOBServed					///
		lincom						///
		EMPTYCELLs(string)				///
		noestimcheck					///
		Level(cilevel)					/// diopts
		NOWALD						///
		WALD						///
		noATLEVels					///
		noSVYadjust					///
		CIeffects					///
		PVeffects					///
		NOEFFects EFFects				///
		SORT						///
		POST						///
		DF(numlist max=1 >0)				///
		`EXTRAOPTS'					///
		noREMAP						/// NODOC
		npreturn					/// NODOC
		*						///
	]

	if `"`small'"'!= "" {
		if `"`e(dfmethod)'"'=="" {
			di as err "{p}option {bf:small} is allowed only if " ///
				"option {bf:dfmethod()} was used with the " ///
				"{bf:mixed} command during estimation{p_end}"
			exit 198
		}

		if "`df'" != "" {
			di as err "{p}option {bf:df()} may not be combined" ///
				" with option {bf:small}{p_end}"
			exit 198
		}

		if "`svyadjust'" != "" {
			di as err "{p}option {bf:nosvyadjust} may not " ///
				"be combined with option {bf:small}{p_end}"
			exit 198
		}

		local is_small 1

		if ("`e(dfmethod)'"=="satterthwaite" | ///
		    "`e(dfmethod)'"=="kroger") {

			if (`e(eim)'==1) local useinfo eim
			else local useinfo oim

			preserve
			_mixed_ddf_u, ///
	 			dftypes(`e(dfmethod)') `useinfo'
			restore
		}
	}
	else local is_small 0

	if "`df'" == "" {
		local df = e(df_r)
	}

	if "`noeffects'" != "" {
		opts_exclusive "`noeffects' `effects'"
		opts_exclusive "`noeffects' `cieffects'"
		opts_exclusive "`noeffects' `pveffects'"
	}

	local equation `equation' `atequations'
	opts_exclusive "`equation'"
	opts_exclusive "`asbalanced' `asobserved'"

	local wald `nowald' `wald'
	opts_exclusive "`wald'"

	_check_eformopt `e(cmd)', eformopts(`options') soptions
	local eform `"`s(eform)'"'
	_get_mcompare, `s(options)'
	local method	`"`s(method)'"'
	local all	`"`s(adjustall)'"'
	_get_diopts diopts, `s(options)'
	local diopts	level(`level')			///
			`wald'				///
			`atlevels'			///
			`svyadjust'			///
			`cieffects'			///
			`pveffects'			///
			`noeffects'			///
			`effects'			///
			mcompare(`method' `all')	///
			`diopts'			///
			`eform'				///
			`atlegend'

	local 0 `", `emptycells'"'
	capture {
		syntax [, REWeight strict]
		opts_exclusive "`reweight' `strict'"
	}
	if c(rc) {
		di as err "invalid emptycells() option;"
		syntax [, REWeight strict]
		opts_exclusive "`reweight' `strict'"
		error 198	// [sic]
	}

	if `match' & `:length local reweight' {
		di as err "{p 0 0 2}" ///
"option emptycells(reweight) is not allowed with results from the " ///
"{bf:`ecmd'} command{p_end}"
		exit 322
	}
	if "`estimcheck'" == "" & !`match' {
		tempname H
		_get_hmat `H'
		if r(rc) {
			local H
		}
	}
	local eqns =	inlist(	`"`e(cmd)'"',	///
				`"manova"',	///
				`"mlogit"',	///
				`"mprobit"',	///
				`"mvreg"')
	local slash = "`e(prefix)'" == "" &	///
			inlist(	`"`e(cmd)'"',	///
				`"anova"',	///
				`"cnsreg"',	///
				`"manova"',	///
				`"mvreg"',	///
				`"regress"')

	// NOTE: -contrast- requires that factor level tracking is done
	// in factor variables, irregardless of the current c(fvtrack)
	// setting.  The original setting is automatically restored on
	// exit.
	set fvtrack factor

	local opts `asobserved' `lincom' `reweight' `equation'
	local anything `"`anything', `opts' `remap'"'
	
	local nplocal = 0 
	if ("`npreturn'"!="") {
		local nplocal = 1 
	}
	mata: _contrast(`df', `eqns', `slash', `match', `is_small')
	if !`:length local post' {
		tempname ehold
		_est hold `ehold', restore
	}
	PostIt `margN'
	return add
	_marg_report, `diopts'
	return add
end

program PostIt, eclass
	args margN
	tempname b
	matrix `b' = r(b)
	if "`r(V)'" == "matrix" {
		tempname V
		matrix `V' = r(V)
	}
	ereturn post `b' `V'
	ereturn hidden local predict	_no_predict
	ereturn local cmd	"contrast"
	_r2e, noclear
	local eq : coleq e(b)
	local eq : list uniq eq
	if "`eq'" != "_" {
		ereturn hidden scalar k_eform = `:list sizeof eq'
	}
	if "`margN'" != "" {
		ereturn hidden scalar N = `margN'
	}
	_marg_cm_util label
end

exit
