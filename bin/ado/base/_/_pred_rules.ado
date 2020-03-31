*! version 1.2.1  31oct2017
program _pred_rules
	version 9
	syntax varname(numeric) [if/] [in] [, rules asif ]
	// no rules, or just ignore the rules
	if ("`asif'" == "asif" | "`e(rules)'" != "matrix" ///
		| el(e(rules),1,1) == 0) exit

	if `"`if'"' != "" {
		local andif `" & (`if')"'
	}

	tempname rmat
	matrix `rmat' = e(rules)
	local nr = rowsof(`rmat')
	local xvars : rowna `rmat'
	//		  1 2 3 4 5  6 7
	local relations "!= > < X X <= X" 
	forval i = 1/`nr' {
		local xvar : word `i' of `xvars'
		if !inlist(`rmat'[`i',1],1,2,3,4,6,7) {
			di as err "invalid e(rules) matrix"
			exit 322
		}
		if inlist(`rmat'[`i',1], 4, 7) {
			continue
		}
		local rel : word `=`rmat'[`i',1]' of `relations'
		local rhs `rmat'[`i',2]
		_msparse `xvar', noomit
		local xvar `"`r(stripe)'"'
		if "`rules'" == "" {
			quietly replace `varlist' = . ///
				if `xvar' `rel' `rhs' `andif' `in'
			if inlist("`rel'","<",">") {
				quietly replace `varlist' = . ///
					if `rhs' `rel' `xvar' `andif' `in'
			}
		}
		else {
			local val = cond(`rmat'[`i',3] == 0, -1e37, 1e37)
			quietly replace `varlist' = `val' ///
				if `xvar' `rel' `rhs' `andif' `in'
			if inlist("`rel'","<",">") {
				local val = -`val'
				quietly replace `varlist' = `val' ///
					if `rhs' `rel' `xvar' `andif' `in'
			}
		}
	}
end
exit
