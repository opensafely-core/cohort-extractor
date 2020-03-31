*! version 1.0.0  06jul2004
program define _cknotsvaroi
	version 8.2

	syntax anything(id="cmd name" name=cmdname)

	if "`e(cmd)'" == "svar" & e(oid_df) >= 1 {
		di as err "{cmd:`cmdname'} may not be used after "	///
			"fitting an overidentified SVAR model"
		di as err "{p 0 4 4}to get these statistics for the "	///
			"underlying VAR, fit it with {cmd:var}, then "	///
			"run {cmd:`cmdname'}{p_end}"
		exit 498	
	}

end

