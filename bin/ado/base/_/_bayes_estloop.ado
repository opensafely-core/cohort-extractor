*! version 1.0.1  04jan017
program _bayes_estloop
	version 14.0
	args torownames colon names command

	tempname hcurrent esample
	_est hold `hcurrent', restore nullok estsystem

	local i 0
	local rownames
	foreach name of local names {
		local ++i
		nobreak {
			if "`name'" != "." {
				local eqname `name'
				local diname {bf:`name'}
				est_unhold `name' `esample'
			}
			else {
				local eqname active
				local diname current
				_est unhold `hcurrent'
			}
			local rownames `rownames' `eqname'
			//skip results not from bayesmh
			if ("`e(cmd)'"!="bayesmh" & `"`e(prefix)'"' != "bayes") {
				di as err "`diname' estimation results are " ///
				          "not results from {bf:bayesmh}"
				local rc321 321
				if "`name'" != "." {
					est_hold `name' `esample'
				}
				else {
					_est hold `hcurrent', restore ///
							nullok estsystem
				}
				continue, break
			}
			//run command on current estimation results
			capture noi `command' `i'
			local rc = _rc
			if "`name'" != "." {
				est_hold `name' `esample'
			}
			else {
				_est hold `hcurrent', restore nullok estsystem
			}
		}
		if `rc' {
			exit `rc'
		}
	}
	if "`rc321'" != "" {
		exit `rc321'
	}
	c_local `torownames' "`rownames'"
end
