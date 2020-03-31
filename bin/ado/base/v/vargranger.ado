*! version 1.6.3  01apr2005
program define vargranger, rclass 
	version 8.0

	syntax, [ESTimates(string) 		/*
		*/ SEParator(numlist integer >=0 max=1)]

	
	if "`estimates'" == "" {
		local estimates .
	}

	tempname results row pest 
	tempvar samp

	_estimates hold `pest', copy restore nullok varname(`samp')

	capture estimates restore `estimates'
	if _rc > 0 {
		di as err "cannot restore estimates(`estimates')"
		exit _rc
	}	
	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
		di as err "vargranger only works with estimates from "	/*
			*/ "{help var##|_new:var} or {help svar##|_new:svar}"
		exit 198
	}

	if "`e(cmd)'" == "svar" {
		local svar _var
	}	
	

	if "`separator'" == "" {
		local separator = e(neqs)
	}	

	_cknotsvaroi vargranger

	if `separator' < 0  | int(`separator') != `separator' {
		di as err "separator(`separator') invalid"
		exit 198
	}


	local lags "`e(lags`svar')'"
	local varlist "`e(endog`svar')'"
	local eqlist "`e(eqnames`svar')'"
	local small "`e(small)'"

	if "`svar'" != "" {
		_svar_post 
	}

	local j 1
	local j2 1
	di 
	foreach eqn_ts of local varlist {
		foreach var of local varlist {
			if "`eqn_ts'" != "`var'" {
				local eqn : word `j2' of `eqlist'	
				local eqnames "`eqnames' `eqn' "

				foreach i of local lags {
local gc_`j' "`gc_`j'' [`eqn']L`i'.`var'"
local gc2_`j2' "`gc2_`j2'' [`eqn']L`i'.`var'" 
				}

				local eqstripe "`eqstripe' `eqn' "
				local varstripe "`varstripe' `var' "
				local j = `j'+1	
			}	
		}
		local j2 = `j2' + 1
	}


	local neqs : word count `varlist'
	local neqsm1 = `neqs' -1
	
	local eqnst2 "`eqstripe'"
	local varst2 "`varstripe'"
	local i3 0
	local i4 0
	forvalues i = 1/`neqs' {
		forvalues i2 = 1/`neqsm1' {
			local ++i3
			local ++i4

			local gc3_`i3' " `gc_`i4'' "
			
			gettoken eqnt eqnst2:eqnst2
			gettoken vart varst2:varst2

			local eqstripe2 `eqstripe2' `eqnt'
			local varstripe2 `varstripe2' `vart'
		}
		local ++i3
		local gc3_`i3' " `gc2_`i'' "

		local eqstripe2 `eqstripe2' `eqnt'
		local varstripe2 `varstripe2' ALL
	}

	local eqnst2 "`eqstripe2'"
	local varst2 "`varstripe2'"
		
	local scnt 0
	if "`small'" == "" {

		forvalues i=1/`i3' {

			qui test `gc3_`i''
			mat `row' =( r(chi2),  r(df), r(p))
			mat `results' = ( nullmat(`results') \ `row')

		}	


		matrix colnames `results' = chi2 df p
		matrix rownames `results' = `varstripe2'
		matrix roweq `results' = `eqstripe2'

		DISP , mname(`results') separator(`separator')
	}
	else {

		forvalues i=1/`i3' {

			gettoken eqnt eqnst2:eqnst2
			gettoken vart varst2:varst2
			qui test `gc3_`i''
			mat `row' =( r(F), r(df),  r(df_r), r(p))
			mat `results' = ( nullmat(`results') \ `row')

		}	
		
		matrix colnames `results' = F df df_r p
		matrix rownames `results' = `varstripe2'
		matrix roweq `results' = `eqstripe2'

		DISPsmall , mname(`results') separator(`separator')
		
	}
	_estimates unhold `pest'
	ret matrix gstats  `results'
end


program define CKmat

	syntax name(name=mname)

	capture confirm matrix `mname'
	if _rc > 0 {
		di as err "results matrix not found"
		exit 498
	}

end

program define DISPsmall
	syntax , mname(name) separator(numlist integer max=1 >=0)

	CKmat `mname'

	local eqnst : roweq    `mname'
	local varst : rownames `mname'


	di as text "{col 4}Granger causality Wald tests"
	tempname table
	.`table' = ._tab.new, col(6) separator(`separator')

	.`table'.width		|19 		/// 1
				19| 		/// 2
				9 		/// 3
				6 		/// 4
				8 		/// 5
				10|		//  6

	.`table'.strcolor	green		/// 1
				green		/// 2
				.		/// 3 
				.		/// 4
				.		/// 5
				.		//  6

	.`table'.numfmt		.		/// 1
				.		/// 2
				%7.6g		/// 3
				%5.0f		/// 4
				%7.0f		/// 5
				%6.4f		// 6

	.`table'.pad		.		/// 1
				.		/// 2
				1		/// 3
				.		/// 4
				.		/// 5
				2		//  6


	.`table'.sep , top
	.`table'.titles	"Equation"		/// 1
			"Excluded"		/// 2 
			"F  "			/// 3
			"df"			/// 4
			"df_r"			/// 5
			"Prob > F"		//  6

	.`table'.sep , mid

	local i = 1
	foreach eqa of local eqnst {
		local vna : word `i' of `varst'

		local eqa = abbrev("`eqa'",17)
		local vna = abbrev("`vna'",17)

		.`table'.row	"`eqa'"			/// 1
				"`vna'"			/// 2
				`mname'[`i',1]		/// 3
				`mname'[`i',2]		/// 4
				`mname'[`i',3]		/// 5
				`mname'[`i',4]		//  6
					
		local ++i			

	}
	.`table'.sep , bot

end


program define DISP
	syntax , mname(name) separator(numlist integer max=1 >=0)

	CKmat `mname'

	local eqnst : roweq    `mname'
	local varst : rownames `mname'

	di as text "{col 4}Granger causality Wald tests"

	tempname table
	.`table' = ._tab.new, col(5) separator(`separator')

	.`table'.width		|19 	19| 	9 	6 	12| 
	.`table'.strcolor	green	green	.	.	.
	.`table'.numfmt		.	.	%7.6g	%5.0f	%6.3f
	.`table'.pad		.	.	1	.	2

	.`table'.sep , top
	.`table'.titles	"Equation"		/// 1
			"Excluded"		/// 2 
			"chi2 "			/// 3
			"df"			/// 4
			"Prob > chi2"		//  5
	.`table'.sep , mid


	local i = 1
	foreach eqa of local eqnst {
		local vna : word `i' of `varst'

		local eqa = abbrev("`eqa'",17)
		local vna = abbrev("`vna'",17)

		.`table'.row	"`eqa'"			/// 1
				"`vna'"			/// 2
				`mname'[`i',1]		/// 3
				`mname'[`i',2]		/// 4
				`mname'[`i',3]		//  5
					
		local ++i			

	}

	.`table'.sep , bot

end

exit

