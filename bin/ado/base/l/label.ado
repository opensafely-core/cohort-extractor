*! version 1.0.1  13dec2018
program label
	version 10.0
	local vv : display "version " string(_caller()) ", missing:"
	
	gettoken val : 0
	if (strpos("`val'", "val") > 0 ) {
		gettoken val 0 : 0 
		syntax anything [, nofix]
		if "`fix'" != "" {
			local fix  ", nofix"
		}
		gettoken var rest : anything  
		while `"`rest'"' != "" {
			gettoken lab rest : rest 
			local label "`lab'"
		}
		local vlist : list anything - lab
		if "`lab'" == "."  {
			local lab ""
		}
		foreach var of varlist `vlist' {
			 `vv' _label `val' `var' `lab' `fix'
		}
	}
	else {
		`vv' _label `macval(0)'
	}
end
