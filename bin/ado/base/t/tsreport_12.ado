*! version 6.0.7  09feb2015
program define tsreport_12, rclass
	version 6, missing

	syntax [if] [in] [, Detail List Panel Report REPORT0 ]

	marksample touse
	_ts timevar panvar, panel sort
	markout `touse' `timevar'

	* ChkSort `timevar' `panvar'

	if "`panel'" != "" & "`panvar'" != ""  {
		local bypfx "qui by `panvar': "
	}
	else    local bypfx "qui "  

	/* find gaps.  gaps are defined as places where the lagged observation
	 * is not flagged for use */

	tempname gap
	gen byte `gap' = `touse' & l.`touse' != 1
	`bypfx' replace `gap' = 0  if sum(`touse') <= 1

	qui count if `gap'
	return scalar N_gaps = r(N)

	if return(N_gaps) > 0 {
		if "`report'`report0'" != "" {
			di in gr _n "Number of gaps in sample:  " /*
				*/ in ye return(N_gaps) _c
			if "`panel'" == "" & "`panvar'" != "" {
				di in gr "   (gap count includes panel changes)"
			}
			else	di
		}

		if "`list'`detail'" != "" {
			if "`panel'" == "" & "`panvar'" != "" {
				di in gr /*
				*/ _n "Observations with preceding time gaps"
				di in gr "(gaps include panel changes)" _c
			}
			else {
				di in gr _n "Observations with preceding " /*
					*/ "time gaps" _c
			}

			tempvar recnum
			qui gen `c(obs_t)' `recnum' = _n  if `gap'
			lab var `recnum' "Record"

			if "`panvar'" != "" {
				tabdisp `recnum', cell(`panvar' `timevar'), /*
					*/ if `gap'
			}
			else {
				tabdisp `recnum', cell(`timevar'), if `gap'
			}
		}

	}
	else if "`report0'" != "" {
		di in gr _n "Number of gaps in sample:  " in ye return(N_gaps)
	}


end

exit

// not used in tsreport, but we're keeping as record
/* ChkSort, either exits with an error or returns quietly on success (data is
   properly sorted) */

program define ChkSort
	args	timevar panel

	local sortby : sortedby
	tokenize `sortby'

	if "`panel'" != "" {
		if "`panel'" != "`1'" | "`timevar'" != "`2'" {
			di in red "data not sorted for panel "  /*
				*/ "time-series"
			di in red "use -tsset- or -sort `panel' "/*
				*/ "`timevar'-"
			exit 5
		}
	}
	else if "`timevar'" != "`1'" {
		di in red "data not sorted for time-series; "  /*
			*/ "must use -tsset- or -sort `timevar'-"
		exit 5
	}
end

