*! version 1.4.3  01may2019
program define lincom, rclass
	version 6.0

	if "`e(prefix)'" != "svy" {
		is_svy
		if `r(is_svy)' {
			// NOTE: only used with results from the old survey
			// estimation commands that are not produced by the
			// modern -svy:- prefix mechanism

			_svylc `0'
			return add
			exit
		}
	}

	gettoken token 0 : 0, parse(",= ") bind

	while `"`token'"'!="" & `"`token'"'!="," {
		if `"`token'"' == "=" {
			di in red _quote "=" _quote /*
			*/ " not allowed in expression"
			exit 198
		}

		local formula `"`formula'`token'"'

		gettoken token 0 : 0, parse(",= ") bind
	}

	if `"`0'"'!="" {
		local 0 `",`0'"'
		syntax [,	Level(cilevel)		///
				OR			///
				IRr			///
				RRr			///
				HR			///
				SHR			///
				EForm			///
				SHOW			///
				DF(numlist max=1 >0)	///
				SMALL			///
				*			///
			]
		local nopt : word count `or' `irr' `rrr' `hr' `shr' `eform'
		if `nopt' > 1 {
			di in red "only one display option can be specified"
			exit 198
		}
		if `"`show'"' != "" {
			capture assert `"`formula'"' == ""
			local rc = _rc
			capture syntax [, SHOW ]
			local rc = `rc' + _rc
			if `rc' {
				error 198
			}
			di /* blank line */
			est display
			exit
		}
		_get_diopts diopts, `options'
	}
	else {
		local level = $S_level
		local nopt 0
	}

	if "`e(cmd)'"=="logistic" {
		local or "or"
		local nopt 1
	}

	if `"`small'"' != "" & "`e(cmd)'" != "mixed" {
		di as err ///
		"option {bf:small} is allowed only after command {bf:mixed}"
		exit 198
	}

	if "`e(cmd)'" == "mixed" {
		if `"`small'"'!= "" & "`df'" != "" {
			di as err /// 
		"option {bf:small} may not be combined with option {bf:df()}"
			exit 198
		}
	}

	if "`or'"!="" {
		local eform "eform(Odds Ratio)"
	}
	else if "`irr'"!="" {
		local eform "eform(IRR)"
	}
	else if "`rrr'"!="" {
		local eform "eform(RRR)"
	}
	else if "`hr'"!="" {
		local eform "eform(Haz. Ratio)"
	}
	else if "`shr'"!="" {
		local eform "eform(SHR)"
	}
	else if "`eform'"!="" {
		local eform "eform(exp(b))"
	}

	tempname estname x b V est se rtable

	if "`e(cmd)'"=="mixed" & `"`small'"'!= "" {
		qui test `formula' = 0, matvlc(`V') small
		if r(df_r) == . { local ddfnote 1 }
	}
	else {
		qui test `formula' = 0 , matvlc(`V')
	}

	matrix colnames `V' = (1)
	matrix rownames `V' = (1)

	if      "`r(chi2)'"!=""  { scalar `x' = r(chi2) }
	else if "`r(F)'"   !=""  { scalar `x' = r(F) }
	else                       scalar `x' = .

	if "`df'" != "" {
		local dof = `df'
	}
	else if "`r(df_r)'"!="" {
		local dof = r(df_r)
	}
	else {
		local dof = .
	}

	if `dof'!=. { local dofopt "dof(`dof')" }

	if "`e(depvar)'"!="" {
		local ndepv : word count `e(depvar)'
		if `ndepv' == 1 { local depn "depn(`e(depvar)')" }
	}

	matrix `b' = get(Rr)
	if `nopt' == 1 & `b'[1,colsof(`b')] != 0 {
		if `"`or'`irr'`rrr'"' == "" {
			local eform eform
		}
		else	local eform
		di in smcl in red /*
*/ "additive constant term not allowed with {cmd:`or'`irr'`rrr'`eform'} option"
		exit 198
	}
	matrix `b' = e(b)*`b'[1,1..(colsof(`b')-1)]' - `b'[1,colsof(`b')]
	matrix colnames `b' = (1)

	/* Display formula. */
	test `formula' = 0, notest

	/* Save values of b and V for S_# macros. */
	if "`eform'"=="" {
		scalar `est' = `b'[1,1]
		scalar `se'  = sqrt(`V'[1,1])
	}
	else {
		scalar `est' = exp(`b'[1,1])
		scalar `se'  = exp(`b'[1,1])*sqrt(`V'[1,1])
	}
	nobreak {
		estimates hold `estname'
		capture noisily break {		/* Post results. */
			est post `b' `V', `dofopt' `depn'
			di
			est di, `eform' level(`level') `diopts'
			matrix `rtable' = r(table)
		}
		local rc = _rc
		estimates unhold `estname'
		if `rc' { exit `rc' }
	}

	if "`ddfnote'" == "1" {
		version 14: di as txt "{p 0 6 2}" ///
			"Note: Small-sample inference is " ///
			"{help j_mixed_ddf:not available}.{p_end}"
	}

/* Double save in r() and S_# */

	ret scalar estimate = `est'
	ret scalar se       = `se'
	ret scalar level    = `level'
	local rows : rownames r(table)
	local variate = substr("`rows'",6,1)
	if ("`variate'" == "t") {
		ret scalar t  = `rtable'[3,1]
	}
	if ("`variate'" == "z") {
                ret scalar z  = `rtable'[3,1]
        }
        ret scalar p  = `rtable'[4,1]
        ret scalar lb = `rtable'[5,1]
        ret scalar ub = `rtable'[6,1]

	if `dof'!=. { ret scalar df = `dof' }

	global S_1 = `est'
	global S_2 = `se'
	if `dof'!=. { global S_3 `"`dof'"' }
	else	      global S_3
end
