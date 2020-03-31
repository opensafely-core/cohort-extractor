*! version 1.0.0  20jan2015
program define gr_close
	version 14
	local f0 `0'
	gettoken pattern : 0, parse(" ,")
	local npats = 0
	local potnamelist
	if `"`pattern'"' != "" & `"`pattern'"' != "," {
		local pattern1 `pattern'
		local potnamelist `potnamelist' `pattern1'
		local npats = 1
		gettoken pattern 0 : 0, parse(" ,")
		while `"`pattern'"' != "" & `"`pattern'"' != "," {
			local npats = `npats' + 1
			local pattern`npats' `pattern'
			local potnamelist `potnamelist' `pattern`npats''
			gettoken pattern 0 : 0, parse(" ,")
		}
		if "`pattern'" == "," {
			local 0 , `0'
		}
	}	
	else {
		local pattern1
		local potnamelist 
		local npats = 1
	}

	local alllist _all
	local justall: list alllist == potnamelist 
	capture confirm name `potnamelist'
	local justnames = !_rc
	capture syntax
	local hasopts = _rc
	if "`potnamelist'" == "" & ! `hasopts' {
		local justall 1
		local f0 _all
	}
	capture syntax
	if `justall' | `justnames' | `hasopts' {
		gr_close_namelist `f0'
		exit
	}

	local grlist 
	forvalues i = 1/`npats' {
		if `"`pattern`i''"' == "_all" {
			qui graph dir, memory
		}
		else {
			qui graph dir `pattern`i'', memory
		}
		local grlist `grlist' `r(list)'
	}
	local grlist: list uniq grlist
	gr_close_namelist `grlist'
end
exit
