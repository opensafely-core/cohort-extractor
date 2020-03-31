*! version 1.1.0  02mar2004
program define _vectparse, rclass
	version 8.2 
	
	capture syntax , [	///
		None		///
		RConstant	///
		Constant	///
		RTrend		///
		Trend		///
		]

	gettoken opt right:0 , parse(", ")

	if _rc > 0 {
		di as err "{cmd:trend(`right')} is not a valid trend "	///
			"specification"
		exit 198	
	}

	local ptrends "none rconstant constant rtrend trend"

	local cnt 0
	foreach pt of local ptrends {
		if "``pt''" != "" {
			local ++cnt
			local select "`pt'"
		}
	}


	if `cnt' == 0 {
		ret local trend "constant"
		exit
	}

	if `cnt' > 1 {
		di as err "{cmd:trend(`right')} is not a valid trend "	///
			"specification"
		exit 198	
	}
	
	ret local trend "`select'"

end

