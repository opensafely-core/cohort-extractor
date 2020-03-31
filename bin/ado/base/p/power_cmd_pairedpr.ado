*! version 1.0.0  05jun2013
program power_cmd_pairedpr
	version 13

	syntax [anything] [, test * ]
	local type `test'
	pss_pairedpr_`type' `anything', `options'
end

program pss_pairedpr_test
	
	_pss_syntax SYNOPTS : onetest
	syntax [anything] , 	pssobj(string)		/// 
			[ 	`SYNOPTS'		///
				diff(string)		///
				ratio(string)		///
				CORR(string)		///
				ORatio(string)		///
				RRisk(string)		///
				PRDIScordant(string)	///
				SUM(string)		///
				effect(string)		///
				*			///
			]
 
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything

	mata: st_local("solvefor", `pssobj'.solvefor)

	// handle effect
	if ("`arg1'"!="" & "`arg2'"!="") local nargs 2
	else if ("`arg1'"!="" & "`arg2'"=="") local nargs 1
	else local nargs 0
	_pss_pairedpr_parseeffect effect : `"`effect'"' `nargs' ///
		"`diff'" "`ratio'" "`rrisk'" "`oratio'" "`corr'" "`solvefor'"

	local prd `prdiscordant'

	if ("`arg1'"=="") {
		local arg1 .
	}
	if ("`arg2'"=="") {
		local arg2 .
	}
	if ("`corr'"=="") {
		local corr .
	}
	if ("`prd'"=="") {
		local prd .
	}
	if ("`sum'"=="") {
		local sum .
	}
	if ("`ratio'"=="") {
		local ratio .
	}
	if ("`diff'"=="") {
		local diff .
	}
	if ("`oratio'"=="") {
		local oratio .
	}
	
	if ("`rrisk'"=="")	{
		local rrisk .
	}
	mata:   `pssobj'.init(	`alpha', "`power'", "`beta'", "`n'",	///
				`arg1',`arg2', `corr', `prd', `ratio',	///
				`diff', `oratio', `rrisk', `sum');	///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
