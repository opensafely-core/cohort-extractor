*! version 1.0.0  11dec2014

program define power_cmd_trend_parse
	version 14
	syntax [anything], [ test * ]

	_power_trend_test_parse `anything', `options'

	c_local lhs `"`s(lhs)'"'
	c_local rest `"`s(rhs)'"'
end

program define _power_trend_test_parse, sclass
	syntax [anything(name=args)], pssobj(string) [ * ]
	local 0, `options'

	mata: st_local("solvefor", `pssobj'.solvefor)
	if "`solvefor'" == "esize" {
		di as err "{p}Effect-size computation is not available for " ///
			"{bf:power trend}{p_end}"
		exit 198
	}

	if ("`solvefor'"=="n") local sflab sample size
	else local sflab `solvefor'

	_pss_chk_multilist `args', option(exposure probabilities) range(>0 <1)

	local nlevels = `s(nlevels)'
	forvalues i=1/`nlevels' {
		local nlist `s(numlist`i')'
		local k : list sizeof nlist
		if (`k'>1) local plist `"`plist' (`nlist')"'
		else local plist `"`plist' `nlist'"'
	}

	_pss_syntax SYNOPTS : multitest
	syntax, [ `SYNOPTS' EXPOSure(string) CONTINuity SHOWMATrix ///
		ONESIDed * ]

	if ("`continuity'"!="") local rhs cc

	/* parse/validate options grweights() npercell() n#()- n()	*/
	local options `"`options' n(`n') npergroup(`npergroup')"'
	local options `"`options' grweights(`grweights') `nfractional'"'
	_pss_chk_multisample `nlevels' 2 levels `solvefor' : `"`options'"'

	local options `r(options)'
	local which `r(which)'
	local rhs "`rhs' `r(nlist)'"
	if ("`which'"!="" & "`which'"!="n") local ninfo `which'
	else local ninfo balanced

	if "`solvefor'" == "n" {
                _pss_chk_iteropts, `options' pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'

		if "`options'"!="" & "`onesided'"!="" {
			di as err "{p}iteration options are only allowed " ///
				"for the two-sided test when " ///
				"computing sample size{p_end}"
			exit 198
		}
	}
	else if "`options'" != "" {
		_pss_error iteroptsnotallowed , `options' ///
			txt(when computing `sflab')

		_pss_error optnotallowed "`options'" 
	}
	if "`exposure'" != "" {
		_pss_chk_multilist `exposure', option({bf:exposure()}) ///
			nlevels(`nlevels')
		forvalues i=1/`nlevels' {
			local xlist `"`xlist' expos`i'(`s(numlist`i')')"'
		}
		local rhs `"`rhs' `xlist'"'
	}
	local single 1
	local arg_all `plist'
	forvalues i=1/`nlevels' {

		gettoken arg`i' arg_all : arg_all, match(par)
		local kp1`i' : list sizeof arg`i'
		if (`kp1`i''>1) local single 0
	}
	if (`single' == 1) {
		tempname eps pi
		scalar `eps' = 1e-6
		local npz 0
		forvalues i=1/`nlevels' {
			if `i' > 1 {
				scalar `pi' = `arg`i''-`arg`=`i'-1''
				local npz = `npz' + (abs(`pi')<`eps')
			}
		}
		if `npz' == `nlevels'-1 {
			di as err "{p}invalid trend probabilities " ///
			"{bf:`args'}; the differences are less than 1e-6{p_end}"
			exit 498	
		}
	}
	sreturn local lhs `"`plist'"'
	sreturn local rhs `"`rhs'"'
	if ("`showmatrix'" == "showmatrix") local showmatrix = "showmatrices"
	/* initialize the number of levels in pss_trend_test object	*/
	mata: `pssobj'.initonparse(`nlevels',"`exposure'"!="","`ninfo'", ///
				"`showmatrix'", ("`continuity'" !=""))
end
