*! version 1.1.7  15oct2019
program define var_p, sortpreserve
	version 8.0
	syntax newvarname [if] [in] , [Residuals XB /*
		*/ STDP EQuation(string)]

	qui tsset, noquery
	
	marksample touse, novarlist

	if "`e(cmd)'" != "var" {
		di as err "{bf:var_p} only works after {bf:var}"
		exit 198
	}

	local nstats : word count `residuals' `xb' `stdp'
	if `nstats' > 1 {
		di as err "more than one statistic specified"
		exit 198
	}

	if "`residuals'`xb'`stdp'" == "" {
		local xb "xb"
		di as txt "(option {bf:xb} assumed; fitted values)"
	}

	if "`equation'" != "" {
		local eq "equation(`equation') "
	}
	else {
		local equation "#1"
		local eq "equation(#1)"
	}	
		

	if "`xb'" != "" {
		_predict `typlist' `varlist' if `touse' , `eq'
		exit
	}

	if "`residuals'" != "" {
		tempvar xb
		qui _predict double `xb' if `touse' , `eq'
		
		Depname depname : `equation'
		if "`depname'" == "" {
			di as error "`equation' is not a valid equation name"
			exit 198
		}	

		gen `typlist' `varlist' = `depname' - `xb' if `touse'
		label variable `varlist' "Residuals"
		exit
	}

	if "`stdp'" != "" {
		_predict `typlist' `varlist' if `touse' , stdp `eq'
		exit
	}

	/* if here then option specified is not recognized */

	di as error "`*' not recognized "
	exit 198
end

program define Depname	  /* <depname> : <equation name or number> */
	args	depname		/*  macro to hold dependent variable name
		*/  colon	/*  ":"
		*/  eqopt	/*  equation name or #number */


	if bsubstr("`eqopt'",1,1) == "#" {
		local eqnum =  bsubstr("`eqopt'", 2,.)
		local dep : word `eqnum' of `e(depvar)'
		c_local `depname' `dep'
		exit
	}

		
	local eqlist "`e(eqnames)'"
	local deplist "`e(depvar)'"
	local i 1
	while "`dept'" == "" & "`eqlist'" != "" {
		gettoken eqn eqlist : eqlist
		if "`eqn'" == "`eqopt'" {
			local dept : word `i' of `deplist'
			c_local `depname' `dept'
		}
		local i = `i' + 1
	}

end
