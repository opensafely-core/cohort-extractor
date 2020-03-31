*! version 1.0.0  22jan2008
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'

mata:

string scalar optimize_name_svy_stage_units(`OptStruct' S, real scalar i)
{
	return(robust_name_stage_units(S.R, i))
}

string scalar optimize_name_svy_stage_strata(`OptStruct' S, real scalar i)
{
	return(robust_name_stage_strata(S.R, i))
}

string scalar optimize_name_svy_stage_fpc(`OptStruct' S, real scalar i)
{
	return(robust_name_stage_fpc(S.R, i))
}

string scalar optimize_name_svy_weights(`OptStruct' S)
{
	return(robust_name_weights(S.R))
}

string scalar optimize_name_svy_poststrata(`OptStruct' S)
{
	return(robust_name_poststrata(S.R))
}

string scalar optimize_name_svy_touse(`OptStruct' S)
{
	return(robust_name_touse(S.R))
}

string scalar optimize_name_svy_subpop(`OptStruct' S)
{
	return(robust_name_subpop(S.R))
}

string scalar optimize_name_svy_cluster(`OptStruct' S)
{
	return(robust_name_stage_units(S.R, 1))
}

end
