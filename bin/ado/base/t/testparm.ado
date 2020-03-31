*! version 3.2.5  24jan2015
program testparm
	version 8.2
	local caller : display string(_caller())
	local version "version `caller':"

	syntax varlist(fv ts) [, EQuation(str) Equal ///
				 DF(numlist max=1 >0) noSVYadjust SMALL ]

	if `"`small'"'!= "" {
		if `"`e(cmd)'"'!="mixed" | `"`e(dfmethod)'"'=="" {
			di as err "{p}option {bf:small} is allowed only if " ///
			  "option {bf:dfmethod()} was used with the " ///
			  "{bf:mixed} command during estimation{p_end}"
			exit 198
		}
	}

	if `"`small'"'!="" & "`df'" != "" {
		di as err "{p}option {bf:small} may not be combined with " ///
			"option {bf:df()}"
	}

	if `"`equation'"' != "" {
		local eqtxt [`equation']
		local eqopt eq(`equation')
	}
	else if "`e(cmd)'" == "mlogit" {
		if e(ibaseout) == 1 {
			local eqopt eq(#2)
		}
	}

	_ms_extract_varlist `varlist', `eqopt' noomit nofatal
	local VARLIST `"`r(varlist)'"'

	// check that variables in model
	foreach v of local VARLIST {
		capture `version' test `eqtxt' `v', notest
		if (_rc==0) {
			local ourlist `ourlist' `v'
		}
	}
	if "`ourlist'" == "" {
		di as err "{p 0 0 2}"
		di as err "no such variables;{break}"
		di as err "the specified varlist does not identify"
		di as err "any testable coefficients"
		if "`equation'" != "" {
			di as err "from equation(`equation')"
		}
		di as err "{p_end}"
		exit 111
	}

	// check svyadjust
	is_svy
	local is_svy `r(is_svy)'

	if `is_svy' & inlist(`"`e(vce)'"', "bootstrap", "sdr") {
		if missing(e(df_r)) & "`df'" == "" {
			local svyadjust nosvyadjust
		}
	}

	if !`is_svy' & "`svyadjust'" != "" {
		di as err "option {bf:nosvyadjust} is allowed only " ///
			"with survey data"
		exit 198
	}

	if "`df'" != "" local dfopt df(`df')

	// test coefs all zero

	if "`equal'" == "" {
		if "`eqtxt'" != "" {
			if "`dfopt'"!="" | "`svyadjust'" != "" {
				`version' test `eqtxt': `ourlist', ///
							`dfopt' `svyadjust'
			}
			else `version' test `eqtxt': `ourlist', `small'
		}
		else{
			if "`dfopt'"!="" | "`svyadjust'" != "" {
				`version' test `ourlist', `dfopt' `svyadjust'
			}
			else `version' test `ourlist', `small'
		}
		exit
	}

	// test coefs all equal

	tokenize "`ourlist'"
	if "`2'" == "" {
		error 102 // too few variables
	}

	if `caller' < 8 {
		local lhs "`1'"
		mac shift
		qui `version' test `eqtxt'`1' = `eqtxt'`lhs', notest
		mac shift
		while "`1'" != "" {
			qui `version' test `eqtxt'`1' = `eqtxt'`lhs', ///
				acc notest
			mac shift
		}
		`version' test
	}
	else {
		local lhs "`1'"
		mac shift
		local tests (`eqtxt'`1' = `eqtxt'`lhs')
		mac shift
		while "`1'" != "" {
			local tests `tests' (`eqtxt'`1' = `eqtxt'`lhs')
			mac shift
		}
		if "`dfopt'"!="" | "`svyadjust'" != "" {
			`version' test `tests', `dfopt' `svyadjust'
		}
		else `version' test `tests', `small'
	}

end
exit
