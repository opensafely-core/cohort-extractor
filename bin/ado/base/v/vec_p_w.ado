*! version 1.0.9  15oct2019
program define vec_p_w, sortpreserve rclass
	version 8.0

	syntax newvarname [if] [in] , [		///
		Residuals 			///
		XB				/// 
		STDP 				///
		CE 				///
		Levels				///
		EQuation(string)		///
		Usece(varlist ts numeric)	///
		Keepce				///  undocumented
		]

	qui tsset, noquery

	local tvar "`r(timevar)'"
	local stype "`r(unit1)'"

	if "`tvar'" == "" {
		di as err "dataset is not properly {help tsset}"
		exit 498
	}	
	
	marksample touse, novarlist


	_ckvec vec_p

	local nstats : word count `residuals' `xb' `stdp' `ce'

	if `nstats' > 1 {
		di as err "more than one statistic specified"
		exit 198
	}

	if e(beta_iden) == 0 {
		di as txt "Beta is not identified"
	}	

	if "`residuals'`xb'`stdp'`ce'`levels'" == "" {
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
		

	ret local usece `usece'	
	ret local keepce `keepce'	
	
	
	if "`e(seasonal)'" != "" {

		local trend "`e(trend)'"

		if "`trend'" == "none" {
			local tconstant noconstant
		}
		else {
			local tconstant 
		}
	
		_vecmksi , stype(`stype') timevar(`tvar')	///
			touse(`touse') `tconstant'

		ret local S_DROP_sindicators "`r(vlist)'"
	}

	_vecmktrend if e(sample)

	if "`ce'" != "" {
		tempname beta
		mat `beta' = e(beta)
		mat score `typlist' `varlist' = `beta' if `touse' , `eq'
		local lab "Predicted cointegrated equation"
		label variable `varlist' "`lab'"
		exit
	}

	local r =e(k_ce)

	if "`usece'" == "" {
		tempname beta
		mat `beta' = e(beta)
		forvalues i=1/`r' {
			mat score double _ce`i' = `beta' , eq(#`i')
		}	
	}
	else {
		local nce : word count `usece'
		if `nce' != `r' {
			di as err "{p}the number of cointegrating " 	///
				"equations specified in "		///
				"option {bf:usece(`usece')} " 	   	///
				"does not equal the number of "	   	///
				"cointegrating equations in the "	///
				"model{p_end}"
			exit 498	
		}
		
		forvalues i=1/`r' {
			local tmp : word `i' of `usece'
			gen double _ce`i' = `tmp'
		}	
	}

	if "`levels'" != "" {
		tempvar xb
		qui _predict double `xb' if `touse' , `eq'
		
		Depname depname : `equation'
		if "`depname'" == "" {
			di as error "{bf:`equation'} is not a valid equation name"
			exit 198
		}	

		gen `typlist' `varlist' = `xb' + L.`depname' if `touse'
		local lab "Linear prediction of level" 
		label variable `varlist' "`lab'"
		exit

	}

	if "`xb'" != "" {
		_predict `typlist' `varlist' if `touse' , `eq'
		local lab "Linear prediction of difference" 
		label variable `varlist' "`lab'"
		exit
	}

	if "`residuals'" != "" {
		tempvar xb
		qui _predict double `xb' if `touse' , `eq'
		
		Depname depname : `equation'
		if "`depname'" == "" {
			di as error "{bf:`equation'} is not a valid equation name"
			exit 198
		}	

		gen `typlist' `varlist' = D.`depname' - `xb' if `touse'
		label variable `varlist' "Residuals"
		exit
	}

	if "`stdp'" != "" {
		_predict `typlist' `varlist' if `touse' , stdp `eq'
		local lab "S.E. of predicted difference" 
		label variable `varlist' "`lab'"
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
		local dep : word `eqnum' of `e(endog)'
		c_local `depname' `dep'
		exit
	}
		
	local eqlist "`e(eqnames)'"
	local deplist "`e(endog)'"
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
