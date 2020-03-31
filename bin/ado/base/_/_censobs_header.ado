*! version 1.0.0  21nov2016
// also see _coef_table_header.ado and gsem_depvar_header.ado
program _censobs_header
	version 15
	/* eqpos:  position or column of the equal sign */
	args eqpos censheader

	local llopt = cond("`e(limit_l)'"=="","`e(llopt)'","`e(limit_l)'")
	local ulopt = cond("`e(limit_u)'"=="","`e(ulopt)'","`e(limit_u)'")
	local is_limits = !missing("`llopt'") & !missing("`ulopt'")
	if `is_limits' {
		_censobs_limits llopt ulopt : "`llopt'" "`ulopt'"
	}
	local col = `eqpos' - strlen("Interval-cens. ")	
	if ("`censheader'"!="") {
		di as txt _col(`=`col'-3') "Censoring of obs:"
	}
	di as txt _col(`col') "Uncensored" _col(`eqpos') "= " ///
           as res %10.0gc e(N_unc)	
	if (`is_limits') {
		di as txt "Limits: lower = " as res "`llopt'" _c
	}
	di as txt _col(`col') "Left-censored" _col(`eqpos') "= " /// 
	   as res %10.0gc e(N_lc)	
	if (`is_limits') {
		di as txt "        upper = " as res "`ulopt'" _c
	}
	di as txt _col(`col') "Right-censored" _col(`eqpos') "= " ///
	   as res %10.0gc e(N_rc)
	if (!missing(e(N_int)))	{
		di as txt _col(`col') "Interval-cens." _col(`eqpos') "= " ///
		   as res %10.0gc e(N_int)	
	}
end
