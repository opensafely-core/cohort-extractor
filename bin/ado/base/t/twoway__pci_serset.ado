*! version 1.0.0  30dec2004
program twoway__pci_serset

	// Creates a serset for an pci view.  Runs from an immediate log.

	syntax [anything(name=ptlist)] , SERSETNAME(string) 		///
		Xnm(name) Ynm(name) XBnm(name) YBnm(name) 		///
		[ POSnm(name) LBLnm(name) * ]

	tempvar `ynm' `xnm' `ybnm' `xbnm' `posnm' `lblnm'
	local vlist  ``ynm'' ``xnm'' ``ybnm'' ``xbnm'' ``posnm'' ``lblnm''
	local nmlist  `ynm'   `xnm' `ybnm' `xbnm'  `posnm'   `lblnm'

	local realN `c(N)'
	local N : list sizeof ptlist

	capture noisily {

		preserve ,  changed

		if `realN' < `N' {
			quietly set obs `N'
		}

		qui gen float ``ynm''   = .
		qui gen float ``xnm''   = .
		qui gen float ``ybnm''   = .
		qui gen float ``xbnm''   = .
		label variable ``ynm'' "`ynm'"
		label variable ``xnm'' "`xnm'"
		label variable ``ybnm'' "`ybnm'"
		label variable ``xbnm'' "`xbnm'"
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
			gettoken `ybnm'v   point    : point
			gettoken `xbnm'v   point    : point
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
		qui drop `vlist'
		restore
	}
	local rc = cond(`rc' , `rc' , _rc)

	if `rc' {
		exit `rc'
	}

	.`sersetname'.sers[1].name = "`ynm'"
	.`sersetname'.sers[2].name = "`xnm'"
	.`sersetname'.sers[3].name = "`ybnm'"
	.`sersetname'.sers[4].name = "`xbnm'"
	local vct = 4
	if `"`posnm'"' != `""' {
		.`sersetname'.sers[`++vct'].name = "`posnm'"
	}
	if `"`lblnm'"' != `""' {
		.`sersetname'.sers[`++vct'].name = "`lblnm'"
	}
end

