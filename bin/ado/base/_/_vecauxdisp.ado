*! version 1.2.0  04jun2009
program define _vecauxdisp
	version 8.2

	syntax , estmat(string) 		///
		[ 				///
		Level(cilevel) 			///
		noIDtest			///
		noCNSReport			///
		*				///
		]

	_get_diopts diopts, `options'
	if "`estmat'" != "beta" & "`estmat'" != "pi" 			///
		& "`estmat'" != "mai" & "`estmat'" != "alpha" {
		di as err "`estmat' is not a valid set of estimates "	///
			"to display"
		exit 198	
	}


	if "`estmat'" != "pi" {
		local estname `estmat'
	}
	else {
		local estname  Pi
	}

	if "`e(cmd)'" != "vec" {
		di as err "Estimates table for `estmat' cannot be "	///
			"displayed after {cmd:vec}"
		exit 498
	}


// get constraint and identification information

	local rank    = e(k_ce)
	local endog   "`e(endog)'"
	local eqnames "`e(eqnames)'"

	if "`e(bconstraints)'" != "" {
		local bcns "`e(bconstraints)'" 
		local tmp : subinstr local bcns ":" ":", all 	///
			count(local nbcns)
	}
	else {
		local bcns "johansen"
		local nbcns = e(k_ce)
	}

	local beta_iden = e(beta_iden)
	local df_lr     = e(df_lr)

	if `beta_iden' == 0 {
		local iden "underidentified"
	} 
	else {
		if `df_lr' > 0 & `df_lr' < . {
			local iden "overidentified"
			local chi2_res = e(chi2_res)
		}
		else {
			local iden "exactly identified"
		}
	}

	tempname oldest b V
	tempvar  samp0
	
	capture	_estimates hold `oldest', restore copy varname(`samp0')
	if _rc > 0 {
		di as err "cannot store current e() results for vec"
		exit 498
	}

	mat `b' = e(`estmat')
	mat `V' = e(V_`estmat')


	ereturn post `b' `V', depname(`estname')
	if "`estmat'" == "beta" {
		di as txt "Cointegrating equations"
		DISPmodt `endog', rank(`rank') mname(beta)
		di as txt _n "Identification:  beta is `iden'" _n
		BCNSdisp , bcns(`bcns') rank(`rank')  nbcns(`nbcns') ///
			`cnsreport'
		
	}	

	if "`estmat'" == "alpha" {
		di as txt "Adjustment parameters"
		DISPmodt `eqnames', rank(`rank') mname(alpha)
	}

	if "`estmat'" == "pi" {
		di as txt "Impact parameters"
		DISPmodt `eqnames', rank(`rank') mname(pi)
	}

	if "`estmat'" == "mai" {
		di as txt "Moving average impact parameters"
	}

	ereturn display , level(`level') `diopts'

	_estimates unhold `oldest'
	
end

program define DISPmodt

	syntax anything(name=vlist), 		///
		mname(string)			///
		[				///
		rank(numlist max=1 integer)	///
		]

	if "`mname'" == "beta" {
		local upper `rank'
	}
	else if "`mname'" == "alpha" | "`mname'" == "pi" {
		local upper : word count `vlist'

	}
	else {
// should never be here but exit cleanly if get here	
		exit
	}	

	tempname table

	.`table' = ._tab.new, col(4) lmargin(0)
	.`table'.width		17	8	11	7
	.`table'.numfmt		.	%6.0f	%9.8g	%7.4f
	.`table'.pad		.	.	.	.
	.`table'.strcolor	green	.	.	.
	.`table'.strfmt		%-16s	.	.	.
	.`table'.titlefmt	%-16s	.	.	.
	di
	.`table'.titles		"Equation"	/// 1
				"Parms"		/// 2
				"chi2   "	/// 3
				" P>chi2"	//  4

	.`table'.sep, top
	forvalues i = 1(1)`upper' {
		if "`mname'" == "beta" {
			qui test [_ce`i']:`vlist'
			local eqn "_ce`i'"
		}
		else {
			local eqn : word `i' of `vlist'
			qui test [`eqn']
		}

		local val = chi2tail( e(df_m`i'), e(chi2_`i')) 
		local var : word `i' of `vlist'
		local var = abbrev("`var'", 16)
		.`table'.row	"`eqn'"	///
				r(df)		///
				r(chi2)		///
				r(p)	
	}
	.`table'.sep, bot
end

program define BCNSdisp
	syntax , bcns(string) rank(integer) nbcns(integer) [noCNSReport]

	if `rank' > 1 {
		local mys s
	}	
	else {
		local mys 
	}

	if "`bcns'" == "johansen" {
di as txt "{col 18}Johansen normalization restriction`mys' imposed"
	}
	else if "`cnsreport'" == "" {
		local i 1
		while "`bcns'" != "" {
			gettoken next bcns:bcns , parse(":")
			if "`next'" != ":" {
di as txt " (" %2.0f `i' ")" as res "{col 8}`next'"
local ++i
			}
		}
	}

end

exit
