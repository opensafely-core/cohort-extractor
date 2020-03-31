*! version 1.0.0  03jan2005
program _prefix_getchars
	version 9
	// syntax:  exp coleq colname : <varlist>
	//
	// 	exp coleq colname are macronames to be set using c_local
	//
	// exp is a stub for exp_1, ..., exp_k, where k is the number of
	// variables in <varlist>

	_on_colon_parse `0'

	// parse macronames: exp coleq colname
	local 0 `s(before)'
	syntax namelist(min=4 max=4)
	tokenize `namelist'
	args c_exp c_coleq c_colname c_k_eexp

	// parse <varlist>
	local 0 `"`s(after)'"'
	syntax varlist

	local nvars : word count `varlist'
	local k_eexp 0
	forval i = 1/`nvars' {
		local var : word `i' of `varlist'
		c_local `c_exp'`i' `"`:char `var'[expression]'"'
		local coleq `"`coleq' `"`:char `var'[coleq]'"'"'
		local colna `colna' `:char `var'[colname]'
		if `"`:char `var'[is_eexp]'"' == "1" {
			local ++k_eexp
		}
	}
	c_local `c_coleq' `"`coleq'"'
	c_local `c_colname' `"`colna'"'
	c_local `c_k_eexp' `k_eexp'
end
exit
