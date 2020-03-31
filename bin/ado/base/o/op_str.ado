*! version 6.0.0    06jan1999
program define op_str, rclass
	args L D S

						/* errors */
	if "`4'" != "" {
		mac shift 3
		di in red `"invalid "`*'", "'
		di in red `"syntax for op_str is -op_str L# D# "S#"-"'
		exit 198
	}

	if "`L'" != "" {
		capture confirm integer number `L'
		if _rc {
di in red `"invalid compiled operator, L = "`L'" is non-integer"'
		     exit 198
		}
	}
	
	if "`D'" != "" {
		capture confirm integer number `D'
		if _rc {
di in red `"invalid compiled operator, D = "`D'" is non-integer"'
		     exit 198
		}
	}
	tempname sil
	capture mat input `sil' = ( `S' )
	if _rc {
		di in red "invalid compiled operator, " /*
			*/ `"S = "`S'" contains non-integer values"'
		exit 198
	}

						/* make op string */
	
	if 0`L' == 1 {
		local op L
	}
	else if 0`L' > 0 {
		local op L`L'
	}
	else if 0`L' == -1 {
		local op F
	}
	else if 0`L' < 0 {
		local L = -`L'
		local op F`L'
	}

	if 0`D' == 1 {
		local op `op'D
	}
	else if 0`D' > 0 {
		local op `op'D`D'
	}
	else if 0`D' < 0 {
		di in red `"D may not be negative, D = "`D'""'
		exit 198
	}

	tokenize `S'
	local i 1
	while "``i''" != "" {
		capture confirm integer number ``i''
		if _rc {
		     	di in red "invalid compiled operator, S "  /*
				*/ `"contains "``i''" which is non-integer"'
			exit 198
		}
		if ``i'' > 0 {
			local op `op'S``i''
		}
		else if ``i'' < 0 {
		     	di in red "invalid compiled operator, S "  /*
				*/ `"contains negative value "``i''""'
			exit 198
		}
		local i = `i' + 1
	}

	return local op `op'
end


exit

Note, does not look for S1's and covert to D's, this is done by op_comp and is
not checked here.  The supplied L, D, and S should be in normalized form to
get a normalized op string.
