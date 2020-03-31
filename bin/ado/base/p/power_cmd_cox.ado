*! version 1.0.0  30oct2014
program power_cmd_cox
	version 14

	syntax [anything] [, test * ]
	local type `test'
	pss_cox_`type' `anything', `options'
end

program pss_cox_test

	_pss_syntax SYNOPTS : onetest
	syntax [anything] ,	pssobj(string) 		///
			    [	`SYNOPTS'		///
				HRatio(string)         ///
				sd(string)		///
				r2(string)		///
				FAILProb(string)  	///
				EVENTPRob(string) 	///
				WDProb(string) 		///
				effect(string)		///
			    ]
	gettoken arg2 anything : anything

	if ("`hratio'"=="") local hratio .
	if ("`arg2'"=="") local arg2 .
	if ("`sd'"=="") local sd .
	if ("`r2'"=="") local r2 .
	if ("`failprob'`eventprob'"=="") local failprob .
	if ("`wdprob'"=="") local wdprob .

	mata:   `pssobj'.init(  `alpha', "`power'", "`beta'", "`n'",	///
				`arg2', `hratio',`sd',`r2', ///
				`failprob'`eventprob', `wdprob');    	///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
