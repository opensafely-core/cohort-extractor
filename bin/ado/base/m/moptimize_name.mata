*! version 1.0.1  31jul2013
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'
findfile moptimize_include.mata
quietly include `"`r(fn)'"'

mata:

/* These routines return the names of items set by the user.  They are
 * typically called to retrieve the name of Stata variables, but will also
 * return the name of Mata global objects if they were set instead.
 */

string scalar moptimize_name_evaluator(`MoptStruct' M)
{
	if (strlen(M.st_user)) {
		return(M.st_user)
	}
	return(nameexternal(optimize_init_evaluator(M.S)))
}

string scalar moptimize_name_depvar(`MoptStruct' M, real scalar idx)
{
	mopt__check_depvaridx(idx, .)
	if (idx <= M.ndepvars) {
		if (strlen(M.st_depvars[idx])) {
			return(M.st_depvars[idx])
		}
		return(nameexternal(M.depvars[idx]))
	}
	return("")
}

string rowvector moptimize_name_depvars(`MoptStruct' M)
{
	real	scalar		i
	string	rowvector	names

	names = J(1, M.ndepvars, "")
	for (i=1; i<=M.ndepvars; i++) {
		names[i] = moptimize_name_depvar(M, i)
	}
	return(names)
}

string scalar moptimize_name_eq_offset(`MoptStruct' M, real scalar eq)
{
	mopt__check_eqnum(eq, .)
	if (eq <= M.neq) {
		if (! M.eqexposure[eq]) {
			if (strlen(M.st_eqoffset[eq])) {
				return(M.st_eqoffset[eq])
			}
			return(nameexternal(M.eqoffset[eq]))
		}
	}
	return("")
}

string scalar moptimize_name_eq_exposure(`MoptStruct' M, real scalar eq)
{
	mopt__check_eqnum(eq, .)
	if (eq <= M.neq) {
		if (M.eqexposure[eq]) {
			if (strlen(M.st_eqoffset[eq])) {
				return(M.st_eqoffset[eq])
			}
			return(nameexternal(M.eqoffset[eq]))
		}
	}
	return("")
}

string scalar moptimize_name_by(`MoptStruct' M)
{
	if (strlen(M.st_by)) {
		return(M.st_by)
	}
	return(nameexternal(M.by))
}

string scalar moptimize_name_svy_stage_units(`MoptStruct' M, real scalar i)
{
	return(optimize_name_svy_stage_units(M.S, i))
}

string scalar moptimize_name_svy_stage_strata(`MoptStruct' M, real scalar i)
{
	return(optimize_name_svy_stage_strata(M.S, i))
}

string scalar moptimize_name_svy_stage_fpc(`MoptStruct' M, real scalar i)
{
	return(optimize_name_svy_stage_fpc(M.S, i))
}

string scalar moptimize_name_svy_weights(`MoptStruct' M)
{
	return(optimize_name_svy_weights(M.S))
}

string scalar moptimize_name_svy_poststrata(`MoptStruct' M)
{
	return(optimize_name_svy_poststrata(M.S))
}

string scalar moptimize_name_svy_subpop(`MoptStruct' M)
{
	return(optimize_name_svy_subpop(M.S))
}

string scalar moptimize_name_svy_cluster(`MoptStruct' M)
{
	return(optimize_name_svy_stage_units(M.S, 1))
}

string scalar moptimize_name_weight(`MoptStruct' M)
{
	if (strlen(M.st_wvar)) {
		return(M.st_wvar)
	}
	return(M.wname)
}

end
