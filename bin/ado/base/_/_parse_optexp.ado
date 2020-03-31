*! version 1.0.1  03feb2015
program define _parse_optexp
				// _parse factor-like expansion of a list
	gettoken tomac 0 : 0
	gettoken colon 0 : 0

	syntax [anything(equalok name=rest)] [ , N(integer 20) ]

	local ondots 0
	local last "."
	forvalues i = 1/`n' {
		gettoken tok rest : rest , parse(" .")
		if "`tok'" == "=" | `ondots' {
			local tok `last'
		}
		else {
			if "`tok'" == "." {
				if "`rest'" == ".." | "`rest'" == "..." {
					local ondots 1
					local tok `last'
				}
				else {
				    if bsubstr("`rest'",1,1) != " " {
					di as error `"`tok'`rest' not allowed"'
					exit 198
				    }
				}
			}
		}

		local last `tok'
		local list `list' `tok'
	}

	c_local `tomac' `list'
end
