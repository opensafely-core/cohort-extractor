*! version 6.0.1 10jan1998
program define symmi    
        version 6
	preserve
	tokenize "`*'", parse(",")
	local numlist="`1'"
	local oplist="`3'"
        qui {
		tabi "`numlist'" ,replace
		if "`r(N)'"=="" {
			no di in red "no observations"
    			exit 2000
		} 	
		drop if pop==0
 		expand pop
 		noi symmetry row col, `oplist'
	}
end

