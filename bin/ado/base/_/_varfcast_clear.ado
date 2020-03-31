*! version 1.0.1  02dec2002
program define _varfcast_clear
	version 8
	syntax , [ all ]

	local _varfcastnames : char _dta[_varfcastnames]
	foreach v of local _varfcastnames {
		capture drop `v'
	}

	char define _dta[_varfcastnames] 

	if "`all'" != "" {
		local _varfcastprior : char _dta[_varfcastprior]
		foreach v of local _varfcastprior {
			capture drop `v'
		}
		char define _dta[_varfcastprior] 
	}
end
