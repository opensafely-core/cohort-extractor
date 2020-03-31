*! version 1.0.0  27apr2011
program u_mi_estimate_check_using, sclass
	version 12

	args miestfile cmdname norestore

	//check file existence
	qui estimates describe using `"`miestfile'"'
	local Nest `r(nestresults)'

	// get full filename
	_getfilename `"`miestfile'"'
	if (strpos(r(filename)),".")==0 {
		local ext .ster
	}
	local fname `"`r(filename)'`ext'"'

	if ("`norestore'"=="") {
		tempname esthold
		_estimates hold `esthold', restore nullok
	}
	qui estimates use `"`miestfile'"', number(`Nest')
	local rc_mi `e(rc_mi)'
	local firstm : list posof "0" in rc_mi
	if (`Nest'<3 | !`firstm' | `"`e(mi)'"'!="mi" | `"`e(m_mi)'"'=="" | ///
		`"`e(rc_mi)'"'=="" | `"`e(cmd_mi)'"'=="") {
		mata: _mi_estimate_using_errors(`"`fname'"',"`cmdname'")
	}

	sret clear
	sret local fname	`"`fname'"'
	sret local N_est	"`Nest'"
	sret local m_mi		"`e(m_mi)'"
	sret local rc_mi	"`e(rc_mi)'"
	sret local cmdname	"`e(cmd_mi)'"
	sret local firstm	"`firstm'"
end
