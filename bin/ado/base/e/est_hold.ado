*! version 1.1.0  03feb2017
program est_hold, eclass
	version 8
	args name esample holdopt

	if "`e(cmd)'" != "" {
		capt confirm variable `esample'
		local reset = _rc==0

		if `reset' {
			tempvar touse
			qui gen byte `touse' = `esample'
			qui replace `touse' = 0 if missing(`touse')  
			local ename `"`e(_estimates_name)'"'
			ereturn repost , esample(`touse')
			ereturn hidden local _estimates_name `"`ename'"'
		}
		_est hold `name', nullok estimates varname(_est_`name') `holdopt'
		if `reset' {
			capt replace _est_`name' = `esample'
		}
	}
	else {
		_est hold `name', nullok estimates varname(_est_`name')
	}
end
