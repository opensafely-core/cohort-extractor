*! version 1.0.1  29apr2004
program define var_mkcompanion
	version 8.2

	tempname temp
	
	syntax , mlag(integer) lm1(integer) eqs(integer) aname(name)	///
		bigap(name)

	capture matrix drop `bigap'

	forvalues i = 1(1)`mlag' {
		capture mat drop `temp'
		capture confirm matrix `aname'`i'
		if _rc > 0 {
			di as err "error forming companion matrix"
			di as err "coefficient matrix for lag `i' not found"
			exit 498
		}

		if colsof(`aname'`i') != `eqs' {
			di as err "error forming companion matrix"
			di as err "coefficient matrix for lag `i' "	///
				"has " colsof(`aname'`i') " columns "	///
				"instead of `eqs' columns"
			exit 498
		}
		
		if rowsof(`aname'`i') != `eqs' {
			di as err "error forming companion matrix"
			di as err "coefficient matrix for lag `i' "	///
				"has " rowsof(`aname'`i') " rows "	///
				"instead of `eqs' rows"
			exit 498
		}

		if `lm1' > 0 {
			forvalues j=1(1)`lm1' {
				if `j' == `i' {
					mat `temp'=( nullmat(`temp') /*
						*/ \ I(`eqs') )
				}
				else {
					mat `temp'=(nullmat(`temp') /*
				 		*/ \ J(`eqs',`eqs',0))
				}
			}
			mat `bigap' = (nullmat(`bigap'), (`aname'`i' \ `temp') )
		}
		else {
			mat `bigap' = `aname'`i' 
		}
	}
end	
