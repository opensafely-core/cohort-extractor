*! version 1.0.11  15oct2019
program define svar_p, sortpreserve
	version 8.0
	syntax newvarname [if] [in] , [Residuals 	/*
		*/ XB STDP EQuation(string)		/*
		*/ force ]

// force is undocumented for oi svar		

	marksample touse, novarlist

	if "`force'" == "" {
		_cknotsvaroi predict	 
	}

	qui tsset, noquery

	if "`e(cmd)'" != "svar" {
		di as err "{bf:svar_p} only works after {bf:var}"
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
		
	tempname b 
	mat `b' = e(b_var)

	if "`xb'" != "" {
		mat score `typlist' `varlist' = `b' if `touse' , `eq'
		qui count if `varlist' >=.
		if r(N) > 0 {
			local mvals = r(N)
			di as txt "(`mvals' missing values generated)"
		}
		label variable `varlist' "Linear prediction"	
		exit
	}

	if "`stdp'" != "" {
		tempname pest
		tempvar samp bt vt
		
		mat `bt' = e(b_var)
		mat `vt' = e(V_var)

		_est hold `pest', copy restore nullok varname(`samp')

		eret post `bt' `vt'
		
		_predict `typlist' `varlist' if `touse' , stdp `eq'
		_est unhold `pest'
		exit
	}

	if "`residuals'" != "" {
		tempvar xb
		qui mat score double `xb' = `b' if `touse' , `eq'
		
		Depname depname : `equation'
		if "`depname'" == "" {
			di as error "{bf:`equation'} is not a valid equation name"
			exit 198
		}	

		gen `typlist' `varlist' = `depname' - `xb' if `touse'
		label variable `varlist' "Residuals"
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
		local dep : word `eqnum' of `e(depvar_var)'
		c_local `depname' `dep'
		exit
	}

		
	local eqlist "`e(eqnames_var)'"
	local deplist "`e(depvar_var)'"
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
