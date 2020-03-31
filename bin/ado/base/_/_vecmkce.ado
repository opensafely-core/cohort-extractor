*! version 1.0.1  25apr2004
program define _vecmkce 
	version 8.2

	syntax [namelist] [if] [in],  [ allowdrop ]

	_ckvec _vecmkce

	marksample touse
	
	local r =e(k_ce)

	if "`allowdrop'" != "" {
		forvalues i=1/`r' {
			capture confirm new variable _ce`i'	
			if _rc > 0 {
				drop _ce`i'
			}
		}	
	}

	if "`namelist'" == "" {
		forvalues i=1/`r' {
			predict double _ce`i' if `touse' , ce eq(#`i') keepce
		}	
	}
	else {
		local cnt : word count `namelist'
		if `cnt' != `r' {
			di as err "number of variable names specified "	///
				"in call to _vecmkce is not equal to "	///
				"the rank"
			exit 498	
		}

		forvalues i=1/`r' {
			local vname : word `i' of `namelist'
			capture confirm new variable `vname'
			if _rc > 0 {
				di as err "`vname' already exists"
				di as err "{cmd:_vecmkce} cannot put "	///
					"cointegrating equation `i' "	///
					"in the variable `vname'"
				exit 498
			}	
			predict double `vname' if `touse' , ce eq(#`i')
		}	
	}
end

exit

syntax [list_of_new_variable_names] [if] [in], allowdrop

	if no list of new variable names is specified, then _vecmkce puts the 
	estimated cointegrating equations into _ce1, _ce2, .. , _ce{rank}
	over the requested sample

	if a list of new variable names is specified, then _vecmkce puts the 
	estimated cointegrating equations into the specified list of variables
	over the requested sample

        allowdrop specifies that _vecmkce should drop any variables called
        _ce1,.._ce{\it r} if they already exist.  _vecmkce does NOT preserve
	the data.  Thus, _vecmkce OVERWRITES any _ce1,..,_ce{\it r} in memory
	if no other variable list is specified.

