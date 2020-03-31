*! version 1.1.2  17mar2010

/*
	mi extract  0  [, esample(varname #) clear]

	mi extract <#> [, esample(varname) clear]           (1 <= # <= M)
*/

program mi_cmd_extract
	version 11.0

	u_mi_assert_set

	/* ------------------------------------------------------------ */
	gettoken m 0 : 0, parse(" ,")
	if ("`m'"=="") { 
		error 198
	}
	syntax [, CLEAR ESAMPle(string)]

	capture confirm integer number `m'
	if (_rc) {
		di as err "syntax error"
		di as smcl as err "    {bf:`m'} found where {it:#} expected"
		exit 198
	}
	if (`m'<0 | `m'>`_dta[_mi_M]') {
		di as smcl as err "{it:#} ({it:m}) out of range"
		di as smcl as err ///
"    {bf:`m'} found where {it:#}, 0 <= {it:#} <= `_dta[_mi_M]', expected"
		exit 198
	}

	if (`"`esample'"' != "") {
		parse_esample esample from : `"`esample'"' `m'
	}

	if (c(changed) & "`clear'"=="") { 
		error 4
	}
	/* ------------------------------------------------------------ */

	mi_extract_`_dta[_mi_style]' `m' "`esample'" "`from'"
	capture sort `_dta[_TSpanel]' `_dta[_TStvar]'
end

program parse_esample
	args macesample macfrom  colon  input m

	local style `_dta[_mi_style]'
	if ("`style'"!="flong" & "`style'"!="flongsep") {
		local di "di as smcl as err"
		`di' "{p 0 4 2}"
		`di' "option {bf:esample()} not allowed{break}"
		`di' "{bf:esample()} allowed only with styles"
		`di' "flong and flongsep"
		`di' "{p_end}"
		exit 198
	}
	gettoken varname rest : input
	gettoken from    rest : rest
	if (strtrim(`"`rest'"')!="") {
		parse_esample_syntax_error `"`input'"' `m'
	}
	if (("`from'"=="" & `m'==0) | ("`from'"!="" & `m')) {
		parse_esample_syntax_error `"`input'"' `m'
	}

	unab varname : `varname'
	confirm numeric variable `varname'
	if (`m'==0) {
		confirm integer number `from'
		if (`from'<1 | `from'>`_dta[_mi_M]') {
			local di "di as smcl as err"
			`di' "{p 0 4 2}"
			`di' `"{bf:esample(`input')}:"'
			`di' "{it:#} out of range{break}"
			`di' "1 <= {it:#} <= `_dta[_mi_M]' required"
			`di' "{p_end}"
			exit 198
		}
	}
	else {
		local from `m'
	}
	c_local `macesample' `varname'
	c_local `macfrom'    `from'
end

program parse_esample_syntax_error
	args input m
	local di "di as smcl as err"
	`di' "{p 0 4 2}"
	`di' `"{bf:esample(`input')} invalid{break}"'
	`di' "syntax for option {bf:esample()} when using {bf:extract}"
	if (`m') {
		`di' "{it:#}, {it:#}>0, is"
		`di' "{bf:esample(}{it:varname}{bf:)}"
	}
	else {
		`di' "{bf:0} is"
		`di' "{bf:esample(}{it:varname #}{bf:)}"
	}
	`di' "{p_end}"
	exit 198
end

	
program mi_extract_wide
	args m

	local M `_dta[_mi_M]'

	nobreak {
		if (`m') {
			local vars `_dta[_mi_ivars]' `_dta[_mi_pvars]'
			quietly {
				foreach v of local vars {
					replace `v' = _`m'_`v'
				}
			}
		}
		forvalues i=1(1)`M' {
			capture drop _`i'_*
		}
		quietly drop _mi_miss
		u_mi_zap_chars
		global S_FN
	}
end

program mi_extract_mlong
	args m

	nobreak {
		if (`m'==0) { 
			qui keep if _mi_m==0
		}
		else {
			qui keep if (_mi_m==0 & _mi_miss==0) | _mi_m==`m'
		}
		qui drop _mi_miss _mi_m _mi_id 
		u_mi_zap_chars
		global S_FN
	}
end

program repost, eclass
	args var

	ereturn repost, esample(`var')
end

program mi_extract_flong
	args m esample from

	if ("`esample'"=="") {
		nobreak {
			qui keep if _mi_m==`m'
			qui drop _mi_miss _mi_m _mi_id 
			u_mi_zap_chars
			global S_FN
		}
		exit
	}
	preserve
	if (`from'==`m') {
		qui keep if _mi_m==`m' 
		qui drop _mi_miss _mi_m _mi_id 
		u_mi_zap_chars
		global S_FN
		repost `esample'
		restore, not
		exit
	}

	assert `m'==0 & `from'!=0
	quietly {
		keep if _mi_m==0 | _mi_m==`from'
		sort _mi_id _mi_m
		by _mi_id: replace `esample' = `esample'[2]
		keep if _mi_m==`m'
		drop _mi_miss _mi_m _mi_id 
		u_mi_zap_chars
		global S_FN
	}
	repost `esample'
	restore, not
end

program mi_extract_flongsep
	args m esample from

	if ("`esample'"=="") {
		nobreak {
			if (`m') {
				qui use _`m'_`_dta[_mi_name]', clear
				qui drop _mi_id
			}
			else {
				qui drop _mi_id _mi_miss
			}
			u_mi_zap_chars
			global S_FN
		}
		exit
	}

	preserve
	if (`from'==`m') {
		if (`m') {
			qui use _`m'_`_dta[_mi_name]', clear
			qui drop _mi_id
		}
		else {
			qui drop _mi_id _mi_miss
		}
		u_mi_zap_chars
		global S_FN
		repost `esample'
		restore, not
		exit
	}

	assert `m'==0 & `from'!=0
	local name `_dta[_mi_name]'
	quietly {
		use _`from'_`name', clear 
		keep _mi_id `esample'
		sort _mi_id
		capture assert _mi_id != _mi_id[_n-1]
		if (_rc) {
			error1 `_rc' `from'
		}
		tempfile fromdta 
		save "`fromdta'"

		use `name', clear 
		sort _mi_id
		capture assert _mi_id != _mi_id[_n-1]
		if (_rc) {
			error1 `=_rc' `from'
		}
		drop `esample'
		capture merge 1:1 _mi_id using "`fromdta'", ///
			assert(match) nogen sorted
		if (_rc) {
			error2 `=_rc' `from' `m'
		}

		drop _mi_id
		u_mi_zap_chars
		global S_FN
	}
	repost `esample'
	restore, not
end

program error1
	args rc m 
	if (`rc'==1) {
		exit 1
	}
	local di "di as smcl as err"
	`di' "{p 0 0 2}"
	`di' "variable _mi_id does not uniquely identify obs."
	`di' "in {it:m}=`m'"
	`di' "{p_end}"
	`di' "{p 4 4 2}"
	`di' "run {bf:mi update} and then repeat command"
	`di' "{p_end}"
	exit 459
end

program error2
	args rc from m 
	if (`rc'==1) {
		exit 1
	}
	local di "di as smcl as err"
	`di' "{p 0 4 2}"
	`di' "obs. do not match in {it:m}=`m' and {it:m}=`from'{break}"
	`di' "run {bf:mi update} and then repeat command"
	`di' "{p_end}"
	exit 459
end
	
