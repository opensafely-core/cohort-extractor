*! version 1.0.4  08jul2004
program define _getvarcns, eclass
	version 8.0

	
	if "`e(cmd)'" != "svar"  & "`e(cmd)'" != "var" {
		di as err "_getvarcns only works after svar or var"
		exit 198
	}

	if "`e(cmd)'" == "svar" {
		local svar _var
	}	

	if "`exog'" != "" {
		local exog `e(exog`svar')'
	}

	tempname pest b v Cns
	tempvar samp

	_estimates hold `pest', copy restore nullok varname(`samp')
	if "`svar'" != "" {
	
		global T_VARcnslist 

		mat `b' = e(b_var)
		mat `v' = e(V_var)
		mat `Cns' = e(Cns_var)

		eret post `b' `v' `Cns'
	}	
	mat dispCns, r

	local k = r(k)

	global T_VARcnslist2 
	forvalues i = 1/`k' {
		global T_VARcnslist2 "$T_VARcnslist2:`r(cns`i')'"
		local rcns`i' `r(cns`i')'
	}	

	forvalues i = 1/`k' {
		local cnsi `rcns`i''
		constraint free
		local freei = r(free)
		constraint define `freei' `cnsi'
		local cnslist "`cnslist' `freei'"
	}

	capture _est unhold `pest'
	global T_VARcnslist `cnslist'

end

exit
syntax _getvarcns

	returns in $T_VARcnslist
            list of integers that correspond to temporary constraints that
            are identical to the ones imposed on the estimated var
	returns in $T_VARcnslist2
	    the colon separated list constraints imposed
	
	use the constraints in $T_VARcnslist to perform estimation with
	the same constraints 

        it is the caller's job to drop the constraints when done, these are
        temporary constraints.

	

