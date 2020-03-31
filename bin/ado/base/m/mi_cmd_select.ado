*! version 1.0.2  17sep2019

/* -------------------------------------------------------------------- */
					/* mi select			*/
/*
	mi select init [, fast]                (returns r(priorcmd))
	mi select <#>
	
	How to use -mi select-:

	    First, initialize

		preserve
		mi select init [, fast] 
		local priorcmd "`r(priorcmd)'"

	    Then, in a loop or otherwise, select the appropriate data:


		`priorcmd'
		mi select <#>			(0 <= <#> <= _dta[_mi_M])

	    You can access the datasets sequentially, or randomly

	Internal, technical documentation:
	    characteristic use
		_dta[_mi_marker]	select
		_dta[_mi_style]		{wide|mlong|flong|flongsep|bad}
		_dta[_mi_m]             (wide only)
		plus standard

*/

program mi_cmd_select, rclass
	version 11

	/* ------------------------------------------------------------ */
						/* mi init		*/
	gettoken subcmd 0 : 0, parse(" ,")
	if ("`subcmd'"=="init") {
		mi_select_init `0'
		return local priorcmd "`r(priorcmd)'"
		exit
	}
	/* ------------------------------------------------------------ */
						/* mi <#>		*/

	confirm integer number `subcmd'
	if (`subcmd'>=0 & `subcmd'<=`_dta[_mi_M]') {
		if ("`_dta[_mi_marker]'"=="select") {
			mi_reselect_`_dta[_mi_style]' `subcmd'
		}
		else {
			mi_select_`_dta[_mi_style]' `subcmd'
		}
		capture sort `_dta[_TStvar]' `_dta[_TSpanel]'
		exit
	}

	/* ------------------------------------------------------------ */
						/* error		*/
	di as smcl as err ///
	"{bf:mi select `m'}:  {it:m} (imputation number) out of range"
	exit 110
end


program mi_select_init, rclass
	u_mi_assert_set

	syntax [, FAST]
	mi_select_init_`_dta[_mi_style]' "`fast'"
	return local priorcmd "`r(priorcmd)'"
end



/*
	mi_select_init_wide {fast}

		mi_select_wide       used when -fast- not specified
		mi_reselect_wide     used when -fast- specified
*/

program mi_select_init_wide, rclass
	args fast

	if ("`fast'"!="") {
		char _dta[_mi_marker]  "select"
		char _dta[_mi_style]   "wide"
		char _dta[_mi_m]       0
		return local priorcmd  ""
		drop _mi_miss
		mata: mi_typeof_mi_id("typ")
		qui gen `typ' _mi_id = _n
	}
	else {
		return local priorcmd  "restore, preserve"
	}
end

program mi_select_wide
	args m

	nobreak {
		char _dta[_mi_marker]   "select"
		char _dta[_mi_style]    "bad"
	}

	tempvar tvar
	mata: u_mi_wide_swapvars(`m', "`tvar'")

	local M  `_dta[_mi_M]'
	forvalues i=1(1)`M' {
		capture drop _`i'_*
	}
	drop _mi_miss
	mata: mi_typeof_mi_id("typ")
	qui gen `typ' _mi_id = _n
end


program mi_reselect_wide		
	args m

	tempvar tvar
	mata: u_mi_wide_swapvars(`_dta[_mi_m]', "`tvar'")	// swap back
	mata: u_mi_wide_swapvars(`m', "`tvar'")			// swap forward
	char _dta[_mi_m] `m'
end

local SS	string scalar
local SR	string rowvector
local RS	real scalar
version 11
mata:
void mi_typeof_mi_id(`SS' macname)
{
	`RS'	N

	N = st_nobs()
	st_local(macname, (N<=100 ? "byte" : (N<=32740 ? "int" : "long")))
}

end

/*
	mi_select_init_mlong {fast}

		mi_select_mlong    is used whether or not -fast-
*/

program mi_select_init_mlong, rclass
	args fast

	return local priorcmd "restore, preserve"
end

program mi_select_mlong
	args	m

	quietly {
		keep if ((_mi_m==0 & _mi_miss==0) | _mi_m==`m')
		drop _mi_miss _mi_m
	}
	char _dta[_mi_marker] select
	char _dta[_mi_style]  bad 
end

program mi_reselect_bad
	di as smcl as err ///
		"forgotten {cmd:restore, preserve} before {bf:mi select}"
	exit 198
end



/*
	mi_select_init_flong {fast}

		mi_select_flong    is used whether or not -fast-
*/

program mi_select_init_flong, rclass
	args fast

	return local priorcmd "restore, preserve"
end

program mi_select_flong
	args	m

	quietly {
		keep if _mi_m==`m'
		drop _mi_miss _mi_m
	}
	u_mi_zap_chars
	char _dta[_mi_marker]   select
	char _dta[_mi_substyle] bad 
end


/*
	mi_select_init_flongsep {fast}

		mi_reselect_flong    is used whether or not -fast-
*/

program mi_select_init_flongsep, rclass
	args fast

	return local priorcmd ""
	char _dta[_mi_marker]   select
	char _dta[_mi_style]    flongsep
end


program mi_select_flongsep
	args	m

	di as smcl as err "forgotten {bf:mi select init} before {bf:mi select}"
	exit 198
end


program mi_reselect_flongsep
	args	m

	local name   `_dta[_mi_name]'
	local M      `_dta[_mi_M]'
	if (`m') {
		qui use _`m'_`name', clear 
	}
	else {
		qui use `name', clear
		qui drop _mi_miss
	}
	char _dta[_mi_marker]  select
	char _dta[_mi_style]   flongsep
	char _dta[_mi_name]    `name'
	char _dta[_mi_M]       `M'
end


program mi_select_
	di as smcl as err "{bf:mi select} used out of context"
	exit 119
end
