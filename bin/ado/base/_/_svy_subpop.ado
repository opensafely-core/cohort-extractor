*! version 1.2.0  26jun2018
program _svy_subpop
	version 9
	local vv : di "version " string(_caller()) ":"
	syntax namelist(min=2 max=2) [,	RESAMPLING *]

	if `:length local resampling' {
		`vv' ResampleSetup `0'
	}
	else {
		`vv' SubpopSetup `0'
	}
end

program SubpopSetup, rclass
	version 9
	// touse subuse [, <options> ]
	syntax namelist(min=2 max=2) [,	///
		hasover			/// undocumented
		over(string asis)	///
		SUBpop(string asis)	///
		SRSsubpop		///
		wvar(varname numeric)	///
		STRata(varname)		///
	]
	tokenize `namelist'
	args touse genvar
	confirm numeric var `touse'
	confirm new var `genvar'
	tempvar subuse

	if `"`subpop'"' != "" {
		capture ParseSubpopOption `subpop'
		if c(rc) {
			di as err "invalid subpop() option"
			exit c(rc)
		}
		local subvar `s(varlist)'
		local if `s(if)'
		local in `s(in)'
		local subpop `subvar' `if' `in'
		if "`srssubpop'" == "" {
			local srssubpop `s(srssubpop)'
		}
	}

	if `"`over'`hasover'`subpop'"' == "" & "`srssubpop'" != "" {
		di as err ///
"{p 0 0 2}option subpop() requires a variable name or" ///
" an if expression when the srssubpop option is specified{p_end}"
		exit 198
	}

	// generate the subpop indicator variable
	mark `subuse' `if' `in'
	if `"`if'`subvar'"' != "" {
		if `"`if'"' != "" {
			gettoken if exp : if
			quietly replace `subuse' = . if (`exp') >= .
		}
		markout `touse' `subvar' `subuse'
		if "`subvar'" != "" {
			quietly replace `subuse' = 0 if `subvar' == 0
		}
	}
	quietly replace `subuse' = 0 if `touse' == 0

	if `"`over'"' != "" {
		capture noisily ParseOverOption `over'
		if c(rc) {
			di as err "invalid over() option"
			exit c(rc)
		}
		local over_nolabel `s(over_nolabel)'
		if "`srssubpop'" == "" {
			local srssubpop `s(srssubpop)'
		}
		local over `s(over)'
		if `:length local subpop' {
			tempvar otouse
			mark `otouse' if `touse'
			markout `otouse' `over'
			quietly replace `touse' = 0 if `subuse' & !`otouse'
			drop `otouse'
		}
		else {
			markout `touse' `over'
		}
		quietly replace `subuse' = 0 if !`touse'
	}

	// saved results
	return local over `over'
	return local over_nolabel `over_nolabel'
	return local subpop `"`subpop'"'
	return local srssubpop `srssubpop'

	quietly count if `touse'
	return scalar N = r(N)
	if return(N) == 0 {
		error 2000
	}

	if `"`subpop'`over'"' != "" {
		SubNotes `touse' `subuse' "`subvar'" `wvar'
		return scalar N_sub = r(N_sub)
	}
	else	return scalar N_sub = return(N)

	rename `subuse' `genvar'
	local subuse `genvar'

	// with over(), `subuse' identifies multiple subpops
	if "`over'" == "" {
		exit
	}
	if _caller() < 16 {
		GenSub15 `touse' `subuse' "`over_nolabel'" `over'
		return local over_namelist `"`r(names)'"'
		return local over_labels `"`r(labels)'"'
	}
	else {
		GenSub `touse' `subuse' `over'
		return hidden local over_namelist `"`r(names)'"'
		return hidden local OVER_NAMELIST `"`r(NAMES)'"'
	}
end

program ParseSubpopOption, sclass
	syntax [varname(default=none numeric)] [if] [in] [, SRSsubpop ]
	sreturn clear
	sreturn local varlist `varlist'
	sreturn local if `"`if'"'
	sreturn local in `"`in'"'
	sreturn local srssubpop `srssubpop'
end

program ParseOverOption, sclass
	syntax [varlist(default=none numeric)] [, NOLABel SRSsubpop ]
	sreturn clear
	sreturn local over `varlist'
	sreturn local over_nolabel `nolabel'
	sreturn local srssubpop `srssubpop'
end

program GenSub, rclass
	gettoken touse		0 : 0
	gettoken subvar		0 : 0
	tempvar sub

	local 0 : list retok 0
	capture fvexpand bn.(`:subinstr local 0 " " "#", all') if `subvar'
	if c(rc) {
		di as err "invalid over() option;"
		fvexpand bn.(`:subinstr local 0 " " "#", all') if `subvar'
		exit 452	// [sic]
	}
	local STRIPE `"`r(varlist)'"'
	foreach o of local STRIPE {
		_ms_parse_parts `o'
		if r(omit) == 0 {
			local stripe `stripe' `o'
		}
	}
	return local names `"`stripe'"'
	return local NAMES `"`STRIPE'"'

	quietly egen `sub' = group(`0') if `subvar', label
	quietly replace `subvar' = `sub' if `subvar' & `touse'
end

program GenSub15, rclass
	gettoken touse		0 : 0
	gettoken subvar		0 : 0
	gettoken nolabel	0 : 0
	tempvar sub

	local n_overvars : word count `0'
	if `n_overvars' != 1 & "`nolabel'" != "" {
		_strip_labels `0'
		local vlist `"`s(varlist)'"'
		local llist `"`s(labellist)'"'
		local nolabel
	}
	else	local renum renumber

capture noisily {

	quietly egen `sub' = group(`0') if `subvar', label
	quietly replace `subvar' = `sub' if `subvar' & `touse'

	if `n_overvars' == 1 {
		local uvar `0'
	}
	else {
		local uvar `sub'
	}

	_labels2eqnames `uvar' if `subvar',	`nolabel'	///
						`renum'		///
						integer		///
						stub(_subpop_)	///
						oldnames
	return local names	`"`r(eqlist)'"'
	return local labels	`"`r(labels)'"'
	local labels `"`r(labels)'"'

	matrix `subvar' = r(values)
	char `subvar'[_svy_subvalues] `subvar'

	local lab : value label `subvar'
	if `:length local lab' == 0 {
		local i 0
		foreach label of local labels {
			local ++i
			local vlabs `"`vlabs' `i' `"`label'"'"'
		}
		label define `subvar' `vlabs'
		label values `subvar' `subvar'
	}

} // capture noisily

	local rc = c(rc)

	if "`vlist'" != "" {
		nobreak _restore_labels `vlist', labels(`llist')
	}
	exit `rc'
end

program SubNotes, rclass
	args touse subuse subvar wvar

	quietly count if `subuse'
	return scalar N_sub = r(N)
	if return(N_sub) == 0 {
		di as err ///
"no observations in subpop() subpopulation"    _n ///
"subpop() = 1 indicates observation in subpopulation" _n ///
"subpop() = 0 indicates observation not in subpopulation"
		exit 461
	}

	if "`wvar'" != "" {
		quietly count if `subuse' != 0 & `wvar' != 0
		if r(N) == 0 {
			di as err ///
"all observations in subpop() subpopulation have zero weights"
			exit 461
		}
	}

	if "`subpop'" != "" & return(N_sub) == return(N) {
		di as txt _n ///
"Note: subpop() subpopulation is same as full population" _n ///
"      subpop() = 1 indicates observation in subpopulation" _n ///
"      subpop() = 0 indicates observation not in subpopulation"
	}

	if "`subvar'" != "" {
		quietly count if `subvar' != 1 & `subvar' != 0 & `touse'
		if r(N) > 0 {
			if "`same'"=="" {
				di as txt _n ///
"Note: subpop() takes on values other than 0 and 1" _n ///
"      subpop() != 0 indicates subpopulation"
			}
		}
	}
end

program ResampleSetup, rclass
	version 9
	// touse subuse [, <options> ]
	syntax namelist(min=2 max=2) [,	///
		RESAMPLING		/// [sic]
		over(string asis)	///
		SUBpop(string asis)	///
		SRSsubpop		///
		wvar(varname numeric)	///
		STRata(varname)		///
	]
	tokenize `namelist'
	args touse subuse
	confirm numeric var `touse'
	confirm numeric var `subuse'

	if `"`subpop'"' != "" {
		capture ParseSubpopOption `subpop'
		if c(rc) {
			di as err "invalid subpop() option"
			exit c(rc)
		}
		local subvar `s(varlist)'
		local if `s(if)'
		local in `s(in)'
		local subpop `subvar' `if' `in'
	}

	if `"`over'"' != "" {
		capture noisily ParseOverOption `over'
		if c(rc) {
			di as err "invalid over() option"
			exit c(rc)
		}
		local over_nolabel `s(over_nolabel)'
		if "`srssubpop'" == "" {
			local srssubpop `s(srssubpop)'
		}
		local over `s(over)'
	}

	// saved results
	return local over `over'
	return local subpop `"`subpop'"'

	quietly count if `touse'
	return scalar N = r(N)
	if r(N) == 0 {
		error 2000
	}

	if `"`subpop'`over'"' != "" {
		SubNotes `touse' `subuse' "`subvar'" `wvar'
		return scalar N_sub = r(N_sub)
	}
	else	return scalar N_sub = return(N)

	// with over(), `subuse' identifies multiple subpops
	if "`over'" == "" {
		exit
	}
	if _caller() < 16 {
		ResampleSub15 `touse' `subuse' "`over_nolabel'" `over'
		return local over_namelist `"`r(names)'"'
		return local over_labels `"`r(labels)'"'
	}
	else {
		ResampleSub `touse' `subuse' `over'
		return hidden local over_namelist `"`r(names)'"'
		return hidden local OVER_NAMELIST `"`r(NAMES)'"'
	}
end

program ResampleSub, rclass
	version 9
	gettoken touse		0 : 0
	gettoken subvar		0 : 0

	local 0 : list retok 0
	capture fvexpand bn.(`:subinstr local 0 " " "#", all') if `subvar'
	if c(rc) {
		di as err "invalid over() option;"
		fvexpand bn.(`:subinstr local 0 " " "#", all') if `subvar'
		exit 452	// [sic]
	}
	local STRIPE `"`r(varlist)'"'
	foreach o of local STRIPE {
		_ms_parse_parts `o'
		if r(omit) == 0 {
			local stripe `stripe' `o'
		}
	}
	return local names `"`stripe'"'
	return local NAMES `"`STRIPE'"'
end

program ResampleSub15, rclass
	version 9
	gettoken touse		0 : 0
	gettoken subvar		0 : 0
	gettoken nolabel	0 : 0

	local char : char `subvar'[_svy_subvalues]

	if `:list char == subvar' {
		local valopt values(`subvar')
	}

	local n_overvars : word count `0'
	if `n_overvars' != 1 & "`nolabel'" != "" {
		_strip_labels `0'
		local vlist `"`s(varlist)'"'
		local llist `"`s(labellist)'"'
		local nolabel
	}
	else	local renum renumber

capture noisily {

	if `n_overvars' == 1 {
		local uvar `0'
	}
	else {
		local uvar `subvar'
	}

	_labels2eqnames `uvar' if `subvar',	`nolabel'	///
						`renum'		///
						`valopt'	///
						integer		///
						stub(_subpop_)	///
						oldnames
	return local names	`"`r(eqlist)'"'
	return local labels	`"`r(labels)'"'

} // capture noisily

	local rc = c(rc)

	if "`vlist'" != "" {
		nobreak _restore_labels `vlist', labels(`llist')
	}
	exit `rc'
end

exit
