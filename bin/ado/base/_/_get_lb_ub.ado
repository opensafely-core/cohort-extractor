*! version 1.0.0  13jan2016
program _get_lb_ub, sclass
	version 14

	syntax , touse(varname) lvar(varname) uvar(varname) ///
		[ ///
		pr(string) e(string) ystar(string) ///
		marginal FIXEDonly ubmiss(integer 0) ///
		]

	if missing("`pr'`e'`ystar'") {
		di "{err}one of {bf:pr()}, {bf:e()}, {bf:ystar()} required"
		exit 198
	}
	
	if `"`pr'"' != "" local pred pr()
	if `"`e'"' != "" local pred e()
	if `"`ystar'"' != "" local pred ystar()
	
	local x `"`pr'`e'`ystar'"'
	gettoken lb ub : x, parse(",")
	local q : subinstr local ub `"""' "", count(local bad)
	if `bad' {
		di `"{err}option {bf:`pred'} incorrectly specified"'
		exit 198
	}
		
	local 0 `"`pr'`e'`ystar'"'
	capture syntax anything(name=lb) , *
	if _rc | `"`options'"' == "" {
		di `"{err}option {bf:`pred'} incorrectly specified"'
		exit 198
	}
	local ub `"`options'"'
	if `ubmiss' local ub "."
	
	sreturn clear
	_chkit `"`lb'"' `pred'
	local lb_var `s(x_var)'
	local lb_num `s(x_num)'
	local lb_mis `s(x_mis)'
	local lb     `s(lmt)'
	local lb_o   `s(lmt_o)'
	qui replace `lvar' = `lb_o'
	
	sreturn clear
	_chkit `"`ub'"' `pred'
	local ub_var `s(x_var)'
	local ub_num `s(x_num)'
	local ub_mis `s(x_mis)'
	local ub     `s(lmt)'
	local ub_o   `s(lmt_o)'
	qui replace `uvar' = `ub_o'

	capture assert `lvar' <= `uvar' if `touse' & ///
		!missing(`lvar') & !missing(`uvar')
	if _rc {
di "{err}option {bf:`pred'} incorrectly specified; {it:b} must be >= {it:a}"
exit 198
	}
	
	local depname `e(depvar)'
	if (`=`:list sizeof depname''>1) local depname "y"
		
	local lb_ok = `lb_num' | `lb_var'
	local ub_ok = `ub_num' | `ub_var'
	
	if `lb_mis' & `ub_mis' {
		local ttl `depname'
	}
	if `lb_mis' & `ub_ok' {
		local ttl "`depname'<`ub_o'"
	}
	if `lb_ok' & `ub_mis' {
		local ttl "`depname'>`lb_o'"
	}
	if `lb_ok' & `ub_ok' {
		local ttl "`lb_o'<`depname'<`ub_o'"
	}
	
	if !missing("`fixedonly'") local ff ", fixed portion only"
	if !missing("`marginal'") local mm "Marginal "
		
	if "`pr'" != "" local ttl "Pr(`ttl')"
	if "`e'" != "" {
		if `lb_mis' & `ub_mis' local ttl "E(`depname')"
		else local ttl "E(`depname'|`ttl')"
	}
	if "`ystar'" != "" {
		if `lb_mis' & `ub_mis' local ttl "E(`depname'*)"
		else local ttl "E(`depname'*|`ttl')"
	}
	
	sreturn local ttl `mm'`ttl'`ff'
	sreturn local lb `lb'
	sreturn local ub `ub'
	sreturn local lb_miss `lb_mis'
	sreturn local ub_miss `ub_mis'

end

program _chkit, sclass

	args x pred
	
	local lmt_o `x'
	local x_num 0
	
	capture confirm numeric variable `x'
	local x_var = !_rc
	if !`x_var' {
		capture confirm number `x'
		local rc1 = !_rc
		capture local expr = `x'
		capture confirm number `expr'
		local rc2 = !_rc
		local x_num = `rc1' | `rc2'
		if  `x_num' {
			if !`rc1' local lmt `expr'
			else	 local lmt `x'
			local x_var = !`x_var'
		}
	}
	else local lmt `x'
	
	local x_mis = ("`x'"==".")
	if `x_mis' local lmt .
	
	if !(`x_var' | `x_num' | `x_mis') {
		di "{err}option {bf:`pred'} incorrectly specified"
		exit 198
	}
	
	sreturn local x_var `x_var'
	sreturn local x_num `x_num'
	sreturn local x_mis `x_mis'
	sreturn local lmt   "`lmt'"
	sreturn local lmt_o "`x'"

end

exit

