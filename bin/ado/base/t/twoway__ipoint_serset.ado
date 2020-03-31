*! version 1.0.0  23oct2002
program twoway__ipoint_serset

	// Creates a serset for an ipoint view.  Runs from an immediate log.

	syntax [anything(name=ptlist)] , SERSETNAME(string) 		///
		Xnm(name) Ynm(name) [ POSnm(name) LBLnm(name) * ]

	tempvar `ynm' `xnm' `posnm' `lblnm'
	local vlist  ``ynm'' ``xnm'' ``posnm'' ``lblnm''
	local nmlist  `ynm'   `xnm'   `posnm'   `lblnm'

	local realN `c(N)'
	local N : list sizeof ptlist

	capture noisily {

		preserve ,  changed

		if `realN' < `N' {
			quietly set obs `N'
		}

		qui gen float ``ynm''   = .
		qui gen float ``xnm''   = .
		label variable ``ynm'' "`ynm'"
		label variable ``xnm'' "`xnm'"
		if "`posnm'" != "" {
			qui gen byte  ``posnm'' = .
			label variable ``posnm'' "`posnm'"
		}
		if "`lblnm'" != "" {
			qui gen str1  ``lblnm'' = ""
			label variable ``lblnm'' "`lblnm'"
		}

		local j 0
		while `++j' <= `N' & `"`ptlist'"' != `""' {
			gettoken point ptlist : ptlist

			gettoken `ynm'v    point    : point
			gettoken `xnm'v    point    : point
			gettoken `posnm'v `lblnm'v  : point
			foreach var of local nmlist {
				qui replace ``var'' = ``var'v' in `j'
			}
		}

		.`sersetname' = .serset.new `vlist' in 1/`N',  `options'
	}
	local rc = _rc

	capture {
		if `realN' < c(N) {
			qui drop in `=`realN'+1'/l
		}
		qui drop `x' `vlist'
		restore
	}
	local rc = cond(`rc' , `rc' , _rc)

	if `rc' {
		exit `rc'
	}

	.`sersetname'.sers[1].name = "`ynm'"
	.`sersetname'.sers[2].name = "`xnm'"
	local vct = 2
	if `"`posnm'"' != `""' {
		.`sersetname'.sers[`++vct'].name = "`posnm'"
	}
	if `"`lblnm'"' != `""' {
		.`sersetname'.sers[`++vct'].name = "`lblnm'"
	}
end

