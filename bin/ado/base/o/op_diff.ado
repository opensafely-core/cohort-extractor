*! version 6.0.0    06jan1999
program define op_diff, rclass
	args L1 D1 S1 L2 D2 S2

				/* handle errors */
	if "`7'" != "" {
		mac shift 6
		di in red `"invalid "`*'", "'
		di in red `"syntax for op_diff is -op_diff L1# D2# "S3#""' /*
			*/ `" L2# D2# "S2#"-"'
		exit 198
	}

	tokenize L1 D1 L2 D2
	local i 1
	while "``i''" != "" {
		if "```i'''" != "" {
			capture confirm integer number ```i'''
			if _rc {
				di in red "invalid compiled operator, " /*
					*/ `"``i'' = "```i'''" is non-integer"'
				exit 198
			}
		}
		local i = `i' + 1
	}
	tempname sil
	capture mat input `sil' = ( `S1' )
	if _rc {
		di in red "invalid compiled operator, " /*
			*/ `"S1 = "`S1'" contains non-integer values"'
		exit 198
	}
	capture mat input `sil' = ( `S2' )
	if _rc {
		di in red "invalid compiled operator, " /*
			*/ `"S2 = "`S2'" contains non-integer values"'
		exit 198
	}

	
				/* perform subtraction */
	Subtract S : "`S1'" "`S2'"
	return local S `S'

	Subtract S : "`S2'" "`S1'"
	return local Sinverse `S'
	
	return local L = 0`L1' - 0`L2'
	return local D = 0`D1' - 0`D2'

	local bool = "`return(Sinverse)'" == "" & `return(D)' >= 0
	return local nested `bool'
	local bool = `return(L)' < 0
	return local hasF `bool'
end

/*  Remove all tokens in dirt from full    */
 *  Returns "cleaned" full list in cleaned 
 *  To be removed twice from list, a token must appear twice in dirt */

program define Subtract   /* <cleaned> : <full> <dirt> */
	args	    cleaned     /*  macro name to hold cleaned list
		*/  colon	/*  ":"
		*/  full	/*  list to be cleaned 
		*/  dirt	/*  tokens to be cleaned from full */
	
	tokenize `dirt'
	local i 1
	while "``i''" != "" {
		local full : subinstr local full "``i''" "", word 
		local i = `i' + 1
	}

	tokenize `full'				/* cleans up extra spaces */
	c_local `cleaned' `*'       
end

