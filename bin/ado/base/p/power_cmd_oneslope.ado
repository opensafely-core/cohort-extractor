*! version 1.0.0  09dec2016
program power_cmd_oneslope
	version 15

	syntax [anything] [,test * ]
	local type `test'
	pss_oneslope_`test' `anything', `options'
end

program pss_oneslope_test

	_pss_syntax SYNOPTS : onetest
	syntax [anything] , pssobj(string) 				///
    				[ 	`SYNOPTS' 		 	///
					diff(string)			///
					sdx(string)		 	///
					SDERRor(string)		 	///
					sdy(string)		 	///
					corr(string)	 		///
    					* 				///
				]
 
	gettoken arg1 anything : anything
	gettoken arg2 anything : anything

//this makes default arg1 0 when -diff()- is specified; like power onemean
	if ("`diff'"=="") local diff .
	else if ("`arg1'"=="") local arg1 0

	if ("`arg2'"=="") local arg2 .

	if ("`sdx'"=="") {
		local sdx 1
	}
	if ("`sderror'"=="" & "`sdy'"=="" &  "`corr'"=="") {
	    	local sderror 1
		local sdy .
		local corr .
	}
	if ("`sderror'"!="" & "`sdy'"=="" & "`corr'"=="") {
	    	local sdy .
		local corr .
	}
	else if ("`sderror'"=="" & "`sdy'"!="" & "`corr'"=="") {
	    	local corr .
		local sderror .
	}
	else if ("`sderror'"=="" & "`sdy'"=="" & "`corr'"!="") {
		local sderror .
	    	local sdy .
	}

	mata:   `pssobj'.init(`alpha', "`power'", "`beta'", "`n'",	///
				`arg1', `arg2', `diff', `sdx', 		///
				`sderror', `sdy', `corr');     		///
		`pssobj'.compute();					///
		`pssobj'.rresults()
end
