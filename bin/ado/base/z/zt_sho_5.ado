*! version 5.0.0
program define zt_sho_5
	version 5.0

	zt_is_5
	local set : char _dta[st_show]
	if "`set'" != "" { 
		exit
	}

	if "`1'"=="noshow" { exit }

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_w]

	di

	di _col(5) in gr "failure time:  " in ye "`t'"

	if "`t0'"!="" {
		di _col(7) in gr "entry time:  " in ye "`t0'"
	}
	if "`d'"!="" {
		di _col(3) in gr "failure/censor:  " in ye "`d'"
	}

	if "`id'"!="" {
		di _col(15) in gr "id:  " in ye "`id'"
	}

	if "`w'"!="" {
		di in gr _col(11) "weight:  " in ye "`w'"
	}
end
