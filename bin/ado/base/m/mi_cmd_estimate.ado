*! version 1.0.5  02may2019
program mi_cmd_estimate
	version 11
	local version : di "version " string(_caller()) ":"
	
	// check if replay()
	cap _prefix_replay `0'
	if r(replay) {
		if "`e(mi)'" != "mi" {
			error 301
		}
		u_mi_estimate_display `0'
		exit
	}

 	query sortseed
 	local holdsseed `r(sortseed)'
	// check which specification is used
	local hold0 `"`0'"'
	_parse comma l r : 0
	
	// for -xtmixed/mixed- with weights
	local dblbar = ustrpos(`"`l'"', "||") - 1
	local l = cond(`dblbar' > 0, usubstr(`"`l'"', 1, `dblbar'), `"`l'"')

	local 0 `"`l'"'
	// parse -using- first
	syntax [anything(equalok)] [if] [in] [using] [fw aw pw iw]
	local rest `"`anything' `r'"'
	gettoken before after : rest, parse(":") bind quotes
	gettoken colon after : after, parse(":") bind quotes
	if (`"`using'"'!="") {
		if ("`colon'"==":") {
			di as err "{bf:mi estimate}: incorrect " ///
				  "specification"
			di as err "{p 4 4 2}{bf:using} and"
			di as err "{bf::} specifications"
			di as err "cannot be combined{p_end}"
			exit 198
		}
		local micmd u_mi_estimate_using
		local miclname _Mi_Combine
	}
	else {
		u_mi_assert_set
		if (`_dta[_mi_M]'<2) { 
			if (`_dta[_mi_M]'==0) { 
				di as err "no imputations"
				exit 2000
			}
			di as err "insufficient imputations"
			exit 2001
		}
		u_mi_certify_data, acceptable	// ensure mi data are acceptable
		// check struct. vars (if any)
		u_mi_sets_okay
		local 0 `"`before'"'
		syntax [anything] [, NOUPdate * ]
		if ("`noupdate'"=="") { 	// make mi data proper
			u_mi_certify_data, proper
		}
		local micmd u_mi_estimate
		local miclname _Mi_Estimate
	}
	cap noi {
		mata: u_mi_get_mata_instanced_var("miest", "__MiEst")
		`version' mata: `miest' = `miclname'()
		`version' _xeq_esthold_err `micmd' `miest' `hold0'
	}
	nobreak {
		local rc = _rc
		cap mata: mata drop `miest'
	}
 	qui set sortseed `holdsseed'	// restore sort seed
	exit `rc'
end
