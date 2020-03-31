*! version 5.0.6  22dec1998
program define stereg, eclass
	version 6.0
	if _caller()<6 {
		ztereg_5 `0'
		exit
	}

	if replay() {
		syntax [, ESTImate noHR TR * ]
		if `"`estimat'"'==`""' {
			if `"`e(cmd2)'"' != `"stereg"' { error 301 }
			if `"`e(frm2)'"'==`"hazard"' {
				if `"`hr'"'==`""' { local hr `"hr"' }
				else local hr 
				if `"`tr'"'!=`""' { 
					di in red `"tr not allowed"'
					exit 198
				}
			}
			else 	local hr

			if `"`e(t0)'"'==`""' {
				local t0 0
			}
			else	local t0 `"`e(t0)'"'
			di _n in gr `"Exponential regression -- "' _c
			if `"`e(frm2)'"'==`"time"' {
				di in gr `"log expected-time form"'
			}
			else	di in gr `"log relative-hazard form"'
			st_hcd
			di
			ereg, `hr' `tr' `options' nohead
			exit
		}
	}

	st_is 2 analysis

	syntax [varlist(default=none)] [if] [in] [, /*
		*/ CLuster(string) CMD ESTImate noHR /*
		*/ Level(integer $S_level) Robust noSHow TIme TR * ]

	local id : char _dta[st_id]
	local w  : char _dta[st_w]
	local wt : char _dta[st_wt]
	local t0 `"t0(_t0)"'
	local d `"dead(_d)"'

	tempvar touse 
	st_smpl `touse' `"`if'"' `"`in'"' `"`cluster'"'
	markout `touse' `varlist'

	if `"`wt'"'==`"pweight"' {
		local robust `"robust"'
	}

	if `"`robust'"'!=`""' & `"`cluster'"'==`""' & `"`id'"'!=`""' {
		local cluster `"`id'"'
	}
	if `"`cluster'"'!=`""' {
		local cluster `"cluster(`cluster')"'
	}



	if `"`time'"'==`""' & `"`tr'"'==`""' {
		local time `"hazard"'
		if `"`hr'"'==`""' {
			local ehr `"hr"'
		}
		else	local ehr
	}
	else	local time

	st_show `show'

	di

	if `"`cmd'"'!=`""' {
		di _n in gr `"-> ereg _t  `varlist' `w' `if' `in', `time' `robust' `cluster' `t0' `ehr' `tr' `d' `options'"'
		exit
	}
	ereg _t  `varlist' `w' if `touse', nocoef `time' `robust' `cluster' `t0' `ehr' `d' `options'
	st_hc `touse'
	global S_E_cmd2 `"stereg"'
	est local cmd2 "stereg"
	stereg, `hr' `tr' level(`level')
end
