*! version 1.2.2  17jan2019
program pwcompare
	version 12
	if replay() & "`e(cmd)'" == "pwcompare" {
		syntax [, *]
		_get_mcompare pwcompare, `options'
		local mop	`"`s(method)'"'
		local all	`"`s(adjustall)'"'
		local options	`"`s(options)'"'
		local mvs	`"`e(mcmethod_vs)'"'
		if inlist("dunnett", "`mop'", "`mvs'") & "`mop'" != "`mvs'" {
			tempname ehold
			_est hold `ehold', restore copy
			REcompare `mop' `all'
		}
		_marg_report, mcompare(`mop' `all') `options'
		exit
	}

	if ("`e(cmd)'" == "contrast"|"`e(cmd)'" == "npregress") {
		di as err ///
`"pwcompare is not allowed with results from the {bf:`e(cmd)'} command"'
		exit 322
	}
	if (`"`e(_contrast_not_ok)'"'=="_ALL") {
		di as err ///
`"pwcompare is not allowed with results from the {bf:`e(cmd)'} command"'
		exit 322	
	}
	_check_eclass
	if (!has_eprop(b)) {
		error 321
	}

	PWCompare `0'
end

program PWCompare, rclass
	local cmdline : copy local 0
	local ecmd = e(cmd)
	local matchlist pwmean pwcompare margins mean proportion ratio total
	local match : list ecmd in matchlist
	if `match' == 1 {
		local EXTRAOPTS noATLegend
	}
	if "`ecmd'" == "margins" {
		local margN `"`e(N)'"'
	}
	if "`e(cmd)'" == "mixed" {
		local EXTRAOPTS SMALL
	}

	syntax anything(id="margin specification") [,	///
		EQuation(passthru)			///
		ATEQuations				///
		ASBALanced				/// default
		ASOBServed				///
		EMPTYCELLs(string)			///
		noestimcheck				///
		Level(cilevel)				/// diopts
		CIeffects				///
		PVeffects				///
		EFFects					///
		CIMargins				///
		GROUPs					///
		SORT					///
		POST					///
		POSTTABLE				/// NODOC
		DF0					///
		DF(numlist max=1 >0)			///
		`EXTRAOPTS'				///
		*					/// method/diopts
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

	local equation `equation' `atequations'
	opts_exclusive "`equation'"
	opts_exclusive "`asbalanced' `asobserved'"

	local ditype	`groups'	///
			`cimargins'	///
			`effects'	///
			`pveffects'	///
			`cieffects'

	_check_eformopt `e(cmd)', eformopts(`options') soptions
	local eform `"`s(eform)'"'
	_get_mcompare pwcompare, `s(options)'
	local method	`"`s(method)'"'
	local all	`"`s(adjustall)'"'
	local options	`"`s(options)'"'

	_get_diopts diopts, `options'
	local diopts	`diopts'	///
			`ditype'	///
			`sort'		///
			`atlegend'	///
			`eform'		///
			level(`level')

	local 0 `", `emptycells'"'
	capture {
		syntax [, REWeight strict]
		opts_exclusive "`reweight' `strict'"
	}
	if c(rc) {
		di as err "invalid emptycells() option;"
		syntax [, REWeight strict]
		opts_exclusive "`reweight' `strict'"
		exit 198	// [sic]
	}

	if `match' & `:length local reweight' {
		di as err "{p 0 0 2}" ///
"option emptycells(reweight) is not allowed with results from the " ///
"`e(cmd)' command{p_end}"
		exit 322
	}
	if "`estimcheck'" == "" & !`match' {
		tempname H
		_get_hmat `H'
		if r(rc) {
			local H
		}
	}

	if "`method'" == "dunnett" {
		opts_exclusive "`method' `groups'"
		local dunnett dunnett
	}
	opts_exclusive "`all' `groups'"

	local eqns =	inlist( `"`e(cmd)'"',	///
				`"manova"',	///
				`"mlogit"',	///
				`"mprobit"',	///
				`"mvreg"')

	local NOEQNS duncan dunnett snk tukey
	if `:list method in NOEQNS' & `eqns' {
		local junk : subinstr local anything "_eqns" "", ///
			word count(local haseqns)
		if `haseqns' {
			di as err ///
"method `method' is not allowed with system factor '_eqns'"
			exit 198
		}
	}

	local opts `asobserved' `lincom' `reweight' `equation' `dunnett'
	local anything `"`anything', `opts'"'
	mata: _pwcompare(`df', `eqns', `match', `is_small')
	if !`:length local post' {
		tempname ehold
		_est hold `ehold', restore
	}
	PostIt `margN'
	return add
	return local level
	_marg_report, `diopts' mcompare(`method' `all')
	if "`posttable'" != "" {
		_r2e, noclear
	}
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
	ereturn local cmd	"pwcompare"
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

program REcompare, eclass
	args mcompare all

	local 0 `"`e(cmdline)'"'
	gettoken cmd 0 : 0
	syntax anything(id="margin specification") [,	///
		ATEQuations				///
		*					///
	]

	local mmethod	`"`e(margin_method)'"'
	local empty	`"`e(emptycells)'"'
	quietly	pwcompare `anything',	`atequations'	///
					`mcompare'	///
					`all'		///
					post
	ereturn local margin_method	`"`mmethod'"'
	ereturn local emptycells	`"`empty'"'
end

exit
