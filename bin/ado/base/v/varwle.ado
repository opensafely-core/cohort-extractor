*! version 1.2.7  07jul2005
program define varwle, rclass sort
	version 8.0

	syntax , [ESTimates(string) SEParator(integer 0)] 

	if "`estimates'" == "" {
		local estimates .
	}

	if `separator' < 0 | `separator' != int(`separator') {
		di as err "separator(`separator') invalid"
		exit 198
	}	

	tempname chi2row prow dfrow Frow dfrow df_rrow chi2 F p df /*
		*/ df df_r pest  stats
	tempvar esamp

	_estimates hold `pest', copy restore nullok varname(`esamp')	
	capture estimates restore `estimates'
	if _rc > 0 {
		di as err "cannot restore estimates(`estimates')"
		exit _rc
	}	
	
	_cknotsvaroi varwle

	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
		di as error "varwle only works after "		///
		"{help var##|_new:var} and {help svar##|_new:svar}"
		exit 198
	}

	if "`e(cmd)'" == "svar" {
		local svar _var
	}	

	local vlist "`e(endog`svar')'"
	local eqlist "`e(eqnames`svar')'"

	local cnames "`e(endog`svar')' All "

	local small `e(small)'
	local lags `e(lags`svar')'

	if "`lags'" == "" {
		di as err "lag structure not properly saved in e()"
		exit 498
	}	

	if "`svar'" != "" {
		_svar_post 
	}

	foreach i in `lags' {
		local btest ""
		foreach v1 of local eqlist {
			local ltest ""
			foreach v2 of local vlist {
				local ltest "`ltest' [`v1']L`i'.`v2' "
				local btest "`btest' [`v1']L`i'.`v2' "
			}
			qui test `ltest'

			if "`small'" == "" {
				mat `chi2row' = ( nullmat(`chi2row'),r(chi2))
				mat `prow' = ( nullmat(`prow'),r(p))
				mat `dfrow' = ( nullmat(`dfrow'),r(df))
			}
			else {
				mat `Frow' = ( nullmat(`Frow'),r(F))
				mat `prow' = ( nullmat(`prow'),r(p))
				mat `dfrow' = ( nullmat(`dfrow'),r(df))
				mat `df_rrow' = ( nullmat(`df_rrow'),r(df_r))
			}	
		}
		qui test `btest'
		if "`small'" == "" {
			mat `chi2row' = ( nullmat(`chi2row'),r(chi2))
			mat `prow' = ( nullmat(`prow'),r(p))
			mat `dfrow' = ( nullmat(`dfrow'),r(df) )
		}
		else {
			mat `Frow' = ( nullmat(`Frow'),r(F))
			mat `prow' = ( nullmat(`prow'),r(p))
			mat `dfrow' = ( nullmat(`dfrow'),r(df))
			mat `df_rrow' = ( nullmat(`df_rrow'),r(df_r))
		}	

		

		if "`small'" == "" {
			mat `chi2' = ( nullmat(`chi2') \ `chi2row' )
			mat drop `chi2row'
			mat `p' = ( nullmat(`p') \ `prow' )
			mat drop `prow'
			mat `df' = ( nullmat(`df') \ `dfrow' )
			mat drop `dfrow'
		}
		else {
			mat `F' = ( nullmat(`F') \ `Frow' )
			mat drop `Frow'
			mat `p' = ( nullmat(`p') \ `prow' )
			mat drop `prow'
			mat `df' = ( nullmat(`df') \ `dfrow' )
			mat drop `dfrow'
			mat `df_r' = ( nullmat(`df_r') \ `df_rrow' )
			mat drop `df_rrow'
		}

		local rnames "`rnames' `i' "
	}
	if "`small'" == "" {
		mat rownames `chi2' = `rnames' 
		mat rownames `p' = `rnames' 
		mat rownames `df' =  `rnames' 

		mat colnames `chi2' = `cnames' 
		mat colnames `p' = `cnames' 
		mat colnames `df' =  `cnames' 
	}
	else {
		mat rownames `F' =  `rnames' 
		mat rownames `p' = `rnames' 
		mat rownames `df' =  `rnames' 
		mat rownames `df_r' = `rnames' 

		mat colnames `F' =  `cnames' 
		mat colnames `p' = `cnames' 
		mat colnames `df' =  `cnames' 
		mat colnames `df_r' = `cnames' 
	}



	_estimates unhold `pest'
	
/* now display results */	

	local vlist2 "`eqlist' All"					

	if "`small'" == "" {
		DISP, df(`df') chi2(`chi2') p(`p') vlist(`vlist2')	///
			separator(`separator') lags(`lags')

	}
	else {
		DISPsmall, df(`df') f(`F') p(`p') dfr(`df_r')	///
			vlist(`vlist2')	separator(`separator')	///
			lags(`lags')
	}


/* now save off results */	
	if "`small'" == "" { 

		ret mat chi2 `chi2' 
		ret mat p `p'
		ret mat df `df'
	}
	else {
		ret mat F `F' 
		ret mat p `p' 
		ret mat df `df' 
		ret mat df_r `df_r' 
	}
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

	syntax , df(name) f(name) p(name) dfr(name)		///
		vlist(string) lags(numlist min=1 >=1)		///
		separator(numlist integer max = 1 >=0) 
	

	foreach mname in df f p dfr {
		CKmat ``mname''
	}

	tempname table

	.`table' = ._tab.new, col(5) separator(`separator')
	.`table'.width 	|5|	10	6	7 	10|
	.`table'.numfmt %4.0f	%8.7g	%5.0f	%6.0f	%8.4f	
	.`table'.pad 	.	1	.	.	.
	.`table'.numcolor green .	.	.	.


	local j 1
	foreach v of local vlist {
		.`table'.reset , clear(row)

		di 
		di as text "{col 4}Equation: `v'"
		.`table'.sep, top
		.`table'.titles 	"lag"		/// 1
					"F   "		/// 2
					"df"		/// 3
					"df_r"		/// 3
					"Prob > F"	//  4
		
		.`table'.sep, mid

		local r = 1	
		local scnt 0
		local j2 = 1
		foreach i in `lags' {
			.`table'.row	`i'		///
					`f'[`j2',`j']	///
					`df'[`j2',`j']	///
					`dfr'[`j2',`j']	///
					`p'[`j2',`j']
			local ++j2		
		}
		.`table'.sep, bot
		local ++j 
	}

end

program define DISP

	syntax , df(name) chi2(name) p(name) vlist(string)	///
		separator(numlist integer max = 1 >=0) 		///
		lags(numlist min=1 >=1)

	foreach mname in df chi2 p {
		CKmat ``mname''
	}

	tempname table

	.`table' = ._tab.new, col(4) separator(`separator')

	.`table'.width 	|5|	11 	6 	13|
	.`table'.numfmt %4.0f	%9.8g	%5.0f	%7.3f	
	.`table'.pad 	.	1	.	2
	.`table'.numcolor green .	.	.	


	local j 1
	foreach v of local vlist {
		.`table'.reset , clear(row)

		di 
		di as text "{col 4}Equation: `v'"
		.`table'.sep, top
		.`table'.titles 	"lag"		/// 1
					"chi2  "	/// 2
					"df"		/// 3
					"Prob > chi2"	//  4
		
		.`table'.sep, mid

		local r = 1	
		local scnt 0
		local j2 = 1
		foreach i in `lags' {
			.`table'.row	`i'			///
					`chi2'[`j2',`j']	///
					`df'[`j2',`j']		///
					`p'[`j2',`j']
			local ++j2			
		}
		.`table'.sep, bot
		local ++j 
	}

end
	
