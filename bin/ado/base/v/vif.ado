*! version 1.5.3  19feb2010
program define vif, rclass sort
	version 6.0
	syntax [, UNCentered NOSORT]
	
	local ver : di "version " string(_caller()) ", missing :"
	
	cap _isfit cons newanovaok
	local iscons = (_rc != 301)
	if `iscons' == 0 {
		if "`uncentered'" == "" {
			di as err "not appropriate after regress, nocons;"
			di as err "use option uncentered to get uncentered VIFs"
			exit 301
		}
	}
	else if _rc != 0 {
		exit _rc
	}

	if inlist("`e(prefix)'", "bootstrap", "jackknife", "svy") {
		di as err "estat vif is not allowed after `e(prefix)'"
		exit 322
	}

	tempvar touse
	qui gen byte `touse' = e(sample)

	_getrhs varlist

	local wgt	`"`e(wtype)'"'
	local exp	`"`e(wexp)'"'

	local wtexp = `""'
	if `"`wgt'"' != `""' & `"`exp'"' != `""' {
		local wtexp = `"[`wgt'`exp']"'
	}

	tokenize `varlist'
	local ovars `""'
	local i 1 
	while `"``i''"' != `""' {
		local found 0
		foreach item of local ovars {
			if "`item'" == "``i''" {
				local found 1
			}
		}
		if !`found' & _b[``i''] {
			local ovars `"`ovars' ``i'' "'
		}
		local i = `i'+1
	}
	local 0 : copy local ovars
	syntax [varlist(default=none fv ts)]
	local fvops = "`s(fvops)'" == "true"
	if `fvops' {
		if _caller() < 11 {
			local ver "version 11:"
		}
		foreach x of local 0 {
			_ms_parse_parts `x'
			if r(type) != "variable" {
				fvrevar `x'
				local orevars `orevars' `r(varlist)'
			}
			else	local orevars `orevars' `x'
		}
	}
	else	local orevars : copy local ovars

	if "`uncentered'" != "" {
		if `iscons' == 1 {
			tempvar const
			qui gen byte `const' = 1
			local ovars `"`ovars' `const' "'
			local orevars `"`orevars' `const'"'
		}
		local nocons , noconstant 
	}
	
	local nvif : list sizeof ovars

	local if        "if `touse'"

	tempname ehold vif mvif 
	scalar `mvif' = 0.0
	quietly {
		noi di
		noi di in smcl in gr /*
		*/ "    Variable {c |}       VIF       1/VIF  "
		noi di in smcl in gr "{hline 13}{c +}{hline 22}"
		local i 1
		local nv 0
		estimate hold `ehold'

		tempname nms vvv
		gen str8 `nms' = `""'
		gen `vvv' = .
		capture {
			while `i' <= `nvif' {
				gettoken dep ovars : ovars
				gettoken redep orevars : orevars

				`ver' _regress `redep' `OREVARS' `orevars' ///
					`if' `in' `wtexp' `nocons'
				replace `vvv' = 1/(1-e(r2)) in `i'
				replace `nms' = `"`dep'"' in `i'
				scalar `mvif' = `mvif'+`vvv'[`i']
				local OREVARS `OREVARS' `redep'
				local nv = `nv'+1
				local i = `i'+1
			}
			if "`uncentered'" != "" {
				if `iscons' == 1 {
					local --i
					replace `nms' = `"intercept"' in `i'
				}
			}
			* preserve
			if !`fvops' & "`nosort'" == "" {
				gsort -`vvv' `nms'
			}

			tempname b
			matrix `b' = J(1,`nv',.)
			forval i = 1/`nv' {
				matrix `b'[1,`i'] = `vvv'[`i']
				local OVARS `OVARS' `=`nms'[`i']'
			}
			`ver' matrix colna `b'  = `OVARS'
			local i 1
			while `i' <= `nv' {
				noi _ms_display, matrix(`b') el(`i') vsquish
				noi di in smcl in gr " " /*
				*/ in ye %9.2f `vvv'[`i'] /*
				*/ `"    "' in ye %8.6f 1/`vvv'[`i']
				global S_`i' = `vvv'[`i']
				ret local name_`i' = `nms'[`i']
				ret scalar vif_`i' = `vvv'[`i'] 
				local i = `i'+1
			}
			noi di in smcl in gr "{hline 13}{c +}{hline 22}"
			noi di in smcl in gr `"    Mean VIF {c |} "' /*
			*/ in ye %9.2f `mvif'/`nv'
			* restore
		}
		estimate unhold `ehold'
	}
	error _rc
end
