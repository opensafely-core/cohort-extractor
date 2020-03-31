*! version 1.3.6  24apr2019
program _vce_parserun, eclass byable(onecall)
	version 9
	local version : di "version " string(_caller()) ":"
	local bycall = _by()

	// syntax: <caller> [, options ] : <caller's arguments>
	_on_colon_parse `0'
	local ZERO `"`s(before)'"'
	local 0 `"`s(after)'"'

	quietly							///
	syntax [anything(equalok)] [if] [in] [fw aw pw iw] [,	///
		VCE(string asis)				///
		VCE1(string asis)				///
		LRMODEL						///
		*						///
	]

	// nothing to do, let the caller run through as usual
	if `"`vce'"' == "" {
		MYRESULT
		exit
	}
	local AFTER `"`0'"'

	local 0 `"`ZERO'"'
	syntax name(name=caller id="calling command name") [,	///
		WTYPES(string)					///
		NOBOOTstrap					///
		NOJACKknife					///
		NOOTHERvce					///
		NOTEST						///
		PANELdata					///
		STdata						///
		bootopts(string asis)				///
		jkopts(string asis)				///
		robustok					///
		multivce					///
		REQUIREDopts(namelist)				///
		NOEQLIST					///
		EQopts(passthru)			/// _eqlist.new
		EQARGopts(passthru)			///
		noNEEDVARLIST				///
		COMMONopts(namelist)			///
		MARKopts(passthru)			///
		RMCOLLopts(passthru)			///
		RMDCOLLopts(passthru)			///
		NUMDEPvars(passthru)			///
		NEEDEQUAL				///
		ALLDEPSMISsing				/// _eqlist.rmcoll
		PARentheses				/// _eqlist.rebuild
		UNPARFIRSTeq				///
		OR					///
		EQUAL					///
		UNEQUALFIRSTeq				///
		IGNORENOCONS				///
	]

	if `"`requiredopts'"' != "" {
		tempname reqopts
		.`reqopts' = ._optlist.new
		foreach req of local requiredopts {
			.`reqopts'.addopt `req', passthru
		}
	}
	if "`wtypes'" == "" {
		local wtypes fw aw pw iw
	}

	if "`paneldata'" != "" {
		local panelopt "CLuster(varname) I(varname)"
	}
	if "`stdata'" != "" {
		local stopt "CLuster(varname) SHared(varname)"
	}

	local typelist svy jackknife bootstrap
	if "`stdata'" == "" & replay() & ! _by() {
		// replay, but only if this is not a call from an -st- command
		local ecmd `e(cmd)'
		local ecmdname `e(cmdname)'
		if `"`ecmd'"' == "" {
			error 301
		}
		else if `"`ecmd'"' != "`caller'" ///
		 & `"`ecmdname'"' == "`caller'" ///
		 & `:list ecmd in typelist' {
			`ecmd' `0'
			MYRESULT exit
		}
		MYRESULT
		exit
	}
	// remove svy from the list, it is only relevant for replay and not
	// considered a "true" vce_type, for general use
	gettoken svy typelist : typelist

	if "`reqopts'" != "" {
		local REQOPTLIST `"`.`reqopts'.dumpoptions'"'
		local REQOPTNAMES `"`.`reqopts'.dumpnames'"'
	}
	local 0 `"`AFTER'"'
	quietly							///
	syntax [anything(equalok)] [if/] [in] [`wtypes'] [,	///
		VCE(string asis)				///
		VCE1(string asis)				///
		Robust						///
		NODOTS						///
		`panelopt'					///
		`stopt'						///
		`REQOPTLIST'					///
		*						///
	]
	if `:list vce === vce1' {
		local vce1
	}
	if `"`vce1'"' != "" & "`multivce'" == "" {
		di as err "option vce() specified multiple times"
		exit 198
	}
	if "`robust'" != "" & "`robustok'" == "" {
		di as err "options vce() and robust may not be combined"
		exit 198
	}
	if `"`if'"' != "" {
		local if `"if (`if')"'
	}
	if "`robust'" != "" {
		local options `"`robust' `options'"'
	}
	if "`weight'" != "" {
		local wgt [`weight'`exp']
	}
	if `"`options'"' != "" {
		local opts `"`:list retok options'"'
	}

	gettoken uvcetype vceopts : vce, parse(" ,")

	capture unabVCEtype, `uvcetype'
	// problem with -vce()-
	if c(rc) {
		di as err "invalid vce() option"
		exit c(rc)
	}
	local vcetype `s(vcetype)'

	if "`lrmodel'"!="" {
		_check_lrmodel `caller', vcetype(`vcetype')
	}

	if `"`vce1'"' != "" & "`multivce'" != "" {
		gettoken uvce1type vce1opts : vce1, parse(" ,")
		capture unabVCEtype, `uvce1type'
		// problem with -vce()-
		if c(rc) {
			di as err "invalid vce() option"
			exit c(rc)
		}
		local vce1type `s(vcetype)'
		if `:list vce1type in typelist' ///
		 | `:list vcetype  in typelist' {
			di as err ///
"options vce(`vce') and vce(`vce1') cannot be combined"
			exit 198
		}
		MYRESULT
		exit
	}

	if ! `:list vcetype in typelist' {
		if "`vcetype'" != "robust" & "`noothervce'" == "noothervce" {
			di as err "option vce(`uvcetype') not allowed"
			exit 198
		}
		MYRESULT
		exit
	}

	if `bycall' {
		di as err ///
		"the by prefix may not be used with vce(`uvcetype') option"
		exit 190
	}

	foreach opt of local REQOPTNAMES {
		if `"``opt''"' == "" {
			di as err ///
`"option `opt'() is required when option vce(`vcetype') is specified"'
			exit 198
		}
		local opts `"`opts' ``opt''"'
	}

	ParseVCErest `vceopts'
	local vceopts `"`s(vcerest)'"'
	if "`paneldata'" != "" {
		if `"`i'"' != "" {
			local opts "`opts' i(`i')"
		}
		else {
			quietly _xt
			local i `r(ivar)'
		}
		if "`cluster'" != "" {
			local opts `"`opts' cluster(`cluster')"'
			local clopt noecluster
			if `"`vcetype'"' == "bootstrap" {
				tempvar tmpcl
				local idopt group(`i') idcluster(`tmpcl')
			}
		}
		else {
			if `"`vcetype'"' == "jackknife" {
				local clopt cluster(`i')
			}
			if `"`vcetype'"' == "bootstrap" {
				tempvar tmpi
				quietly gen `:type `i'' `tmpi' = `i'
				local clopt cluster(`tmpi')
				local idopt idcluster(`i') idclustvar
			}
		}
	}
	if "`stdata'" != "" {
		local wt : char _dta[st_wt]
		if `"`wt'"' != "" & "`vcetype'" == "bootstrap" {
			di as err ///
"weights are not allowed with `caller' and vce(`vcetype')"
			exit 198
		}
		local id : char _dta[st_id]
		if "`cluster'" != "" {
			local opts "`opts' cluster(`cluster')"
			local clopt noecluster
			// note: -cluster()- and -shared()- may not both be
			// specified
			if "`id'" != "" & "`vcetype'" == "bootstrap" {
				tempvar tmpid
				local idopt idcluster(`tmpid') group(`id')
			}
		}
		else if "`shared'" != "" {
			local opts "`opts' shared(`shared')"
			if "`vcetype'" == "jackknife" {
				local clopt cluster(`shared')
			}
			if "`vcetype'" == "bootstrap" {
				tempvar tmpid
				quietly gen `:type `shared'' `tmpid' = `shared'
				local clopt cluster(`tmpid')
				local idopt idcluster(`shared')	///
					group(`id') idclustvar
			}
		}
		else if "`id'" != "" {
			if "`vcetype'" == "jackknife" {
				local clopt cluster(`id')
			}
			if "`vcetype'" == "bootstrap" {
				tempvar tmpid
				confirm var `id'
				quietly gen `:type `id'' `tmpid' = `id'
				local clopt cluster(`tmpid')
				local idopt idcluster(`id') idclustvar
			}
		}
		if "`caller'" == "stcox" {
			local opts "`opts' altvce(`vcetype')"
		}
		if inlist("`caller'", "stcrreg") {
			if "`vcetype'" == "jackknife" & "`wt'" == "iweight" {
				di as err ///
"iweights are not allowed with `caller' and vce(`vcetype')"
				exit 198
			}
		}
	}
	if `"`vcetype'"' == "jackknife" {
		if "`nojackknife'" == "nojackknife" {
			di as err ///
			"option vce(jackknife) not allowed"
			exit 198
		}
		local vceopts `"`vceopts' `notest' `jkopts' `clopt'"'
	}
	if `"`vcetype'"' == "bootstrap" {
		if "`nobootstrap'" == "nobootstrap" {
			di as err ///
			"option vce(bootstrap) not allowed"
			exit 198
		}
		local vceopts `"`vceopts' `notest' `bootopts' `clopt' `idopt'"'
	}
	if `"`:list retok opts'"' != "" {
		local opts `", `opts'"'
	}

	if "`wgt'" != "" {
		WgtMessage `wtypes' : `AFTER'
	}

	if "`noeqlist'" == "" {
		// remove collinear variables from equations, then rebuild the
		// argument in the command line
		local obj _vce_`caller'
		.`obj' = ._eqlist.new,				///
			wtypes(`wtypes')			///
			`eqopts'				///
			`eqargopts'				///
			`needvarlist'				///
			commonopts(`commonopts' VCE(passthru))	///
			`markopts'				///
			`rmcollopts'				///
			`rmdcollopts'				///
			`numdepvars'				///
			`needequal'				///
			`ignorenocons'
		.`obj'.parse `anything' `if' `in' `wgt' `opts'
		`version' .`obj'.rmcoll, `alldepsmissing'
		.`obj'.rebuild,					///
			`parentheses'				///
			`unparfirsteq'				///
			`or'					///
			`equal'					///
			`unequalfirsteq'
		local cmdline `"`s(cmdline)'"'
		classutil drop `obj'
	}
	else	local cmdline `"`anything' `if' `in' `wgt' `opts'"'

	// call the vce() prefix command
	`version' `vcetype' `vceopts' `nodots' : `caller' `cmdline'

	// fix e(ivar) for the -xt- commands
	if "`i'" != "" & `"`vcetype'"' == "bootstrap" {
		ereturn local ivar `"`i'"'
	}

	MYRESULT exit
	Check4Level `vceopts'
end

program ParseVCErest, sclass
	quietly syntax [anything(equalok)] [if] [in] [fw aw pw iw] [, *]

	local 0 : copy local anything
	if `:length local if' {
		local 0 `"`0' `if'"'
	}
	if `:length local in' {
		local 0 `"`0' `in'"'
	}
	if `:length local weight' {
		local 0 `"`0' [`weight'`exp']"'
	}
	local 0 `"`0', `options'"'
	sreturn local vcerest `"`0'"'
end

program Check4Level, sclass
	quietly syntax [anything] [if] [in] [fw aw pw iw] [, Level(cilevel) *]
	sreturn local level `level'
end

program unabVCEtype, sclass
	syntax [, BOOTstrap BStrap JACKknife JACKNife JKnife Robust * ]
	if "`bstrap'" != "" {
		local bootstrap bootstrap
	}
	if "`jknife'" != "" | "`jacknife'" != "" {
		local jackknife jackknife
	}
	local vcetype `"`jackknife' `bootstrap' `robust' `options'"'
	sreturn local vcetype `"`:list retok vcetype'"'
end

program WgtMessage
	_on_colon_parse `0'
	local wtypes `"`s(before)'"'
	local 0 `"`s(after)'"'
	syntax [anything(equalok)] [if] [in] [`wtypes'] [, *]
end

// return something to indicate an action was taken (or not), and the calling
// command can just exit (or do its normal thing)

program MYRESULT, sclass
	args exit
	sreturn local exit `"`exit'"'
end

exit
