*! version 6.0.1  29jun2006
program define op_comp, rclass
	version 9

	local 1 = upper("`1'")
	local 1 : subinstr local 1 "." "", all		/* L1.2 --> L12 */

	if "`2'" != "" {
		di in red "invalid operator string `0'"
		exit 198
	}

	local opstr `1'

						/* initialize numeric returns */
	tokenize L D
	local i 1
	while "``i''" != "" {
		return local ``i'' 0
		local i = `i' + 1
	}

						/* parse the op string */
	tokenize `opstr', parse(LFSD)
	local i 1
	while "``i''" != "" {
						/* op[num], process [num,] */
		local i1 = `i' + 1
		local num = real("``i1''")
		if `num' == . { 
			local num 1 
			local shift 0
		}
		else	local shift 1

		if index("LD", "``i''") != 0 {	/* ops where [num] adds */
			return local ``i'' = `return(``i'')' + `num'
		}
		else if "``i''" == "F" {	/* "F" op, = -L		*/ 
			return local L = `return(L)' - `num'
		}
		else if "``i''" == "S" {	/* "S" op, = D if num = 1 */
			if `num' == 1 {
				return local D = `return(D)' + 1
			}
			else	{		/* insert in sort order */
				InsSort S : `num' "`return(S)'"
				return local S `S'
			}
		}
		else {				/* bad op */
			di in red "operator invalid ``i'' in `opstr'"

						/* cleanup */
			tokenize L D
			local i 1
			while "``i''" != "" {	
				return local ``i''
				local i = `i' + 1
			}
			return local S
			exit 198
		}

		local i = `i' + `shift' + 1
	}

end

program define InsSort			/* numeric list */
	args result colon item list

	if "`list'" == "" {
		c_local `result' `item'
		exit
	}

	tokenize `list'
	local done 0
	while  !`done' {
		gettoken curitem list : list
		if "`curitem'" == "" {
			local list `list'		/* trim leading " " */
			local res `res' `item' `list'
			local done 1
		}
		else if `item' <= `curitem' {
			local list `list'		/* trim leading " " */
			local res `res' `item' `curitem' `list'
			local done 1
		}
		else	local res `res' `curitem'
		local i = `i' + 1
	}

	c_local `result' `res'
end

exit

Note, returns F# as L(-#)

