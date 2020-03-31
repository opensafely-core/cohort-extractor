*! version 1.0.0  05mar2009

program u_mi_curtime 
	version 11
	args cmd arg

	local x = tc(`c(current_date)' `c(current_time)')/1000
	if ("`cmd'"=="get") {
		c_local `arg' `x'
	}
	else if ("`cmd'"=="set") {
		char _dta[_mi_update] `x'
	}
	else {
		error 198
	}
end
