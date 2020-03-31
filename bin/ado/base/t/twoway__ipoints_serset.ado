*! version 1.0.1  08feb2019
program twoway__ipoints_serset

	// Creates a serset for an ipoints view.  Runs from an immediate log.

	syntax [anything(name=ptlist)] , SERSETNAME(string) [ * }

	tempvar x y pos lbl
	local vlist `x' `y' `pos' `lbl'

	local realN `c(N)'
	local N : list sizeof ptlist

	capture noisily {

		preserve ,  changed

		if `realN' < `N' {
			quietly set obs `N'
		}

		qui gen float `x'   = .
		qui gen float `y'   = .
		qui gen byte  `pos' = .
		qui gen str1  `lbl' = ""

		local j 0
		while `j' < `N' & `"`ptlist'"' != `""' {
			gettoken point ptlist : ptlist

			gettoken xv   point : point
			gettoken yv   point : point
			gettoken posv lblv  : point
			foreach var of vlist {
				qui replace ``var'' = ``var'v'
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
		rename `holdx' `x'
		restore
	}
	local rc = cond(`rc' , `rc' , _rc)

	if `rc' {
		exit `rc'
	}

	.`sersetname'.sers[1].name = "x"
	.`sersetname'.sers[2].name = "y"
	.`sersetname'.sers[3].name = "position"
	.`sersetname'.sers[4].name = "label"
end


program VarTrans
	args v vtmp trans

	local trans : subinstr local trans "X" "`v'" , all
	qui gen double `vtmp' = `trans'
end
