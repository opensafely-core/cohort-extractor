*! version 1.0.1  04jun2013
program power_cmd_pairedpr_parse
	version 13

	syntax [anything] [, test * ]
	local type `test'
	_power_pairedpr_`type'_parse `anything', `options'

end

program _power_pairedpr_test_parse

	syntax [anything(name=args)] , pssobj(string) [ ONESIDed * ]
	local 0, `options' `onesided'

	mata: st_local("solvefor", `pssobj'.solvefor)
//to check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n") {
		if ("`onesided'"=="") {
			local isiteropts 1
			local star init(string) *
		}
		else {
			local msg "sample size for a one-sided test"	
		}
	}
	else if ("`solvefor'"=="esize") {
		local isiteropts 1
		local star init(string) *
	}
	else if ("`solvefor'"=="power") {
		local msg power
	}
	if (!`isiteropts') {
		_pss_error iteroptsnotallowed , ///
			`options' txt(when computing `msg')
	}

	_pss_syntax SYNOPTS : onetest
	syntax [,	`SYNOPTS'		///
			diff(string)		///
			ratio(string)		///
			CORR(string)		///
			ORatio(string)		///
			RRisk(string)		///
			PRDIScordant(string)	///
			SUM(string)		///
			effect(string)		///	
			`star'			///
		]
	
	if (`isiteropts') {
		if ("`solvefor'"=="n") {
			local validate `solvefor'
		}
		else if ("`solvefor'"=="esize") {
			local validate df
		}
		_pss_chk_iteropts `validate', `options' init(`init') ///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}
		
	local prdiscord "`prdiscordant'"
	if (`"`prdiscord'`sum'"'!="") {
		if (`"`prdiscord'"'!="" & `"`sum'"'!="") {
			di as err "{p}{bf:prdiscordant()} can not be combined" ///
				" with {bf:sum()}{p_end}"
			exit 198	 	
		}
		local prd `prdiscord'`sum'
	}

	if (`"`corr'"'!="") {
		if (`"`prdiscord'"'!="") {
			di as err "{p}{bf:prdiscordant()} can not "
			di as err "be combined with {bf:corr()}{p_end}"
			exit 198
		}
		if (`"`sum'"'!="") {
			di as err "{p}{bf:sum()} can not "
			di as err "be combined with {bf:corr()}{p_end}"
			exit 198
		}
		local p1 "marginal proportion {it:p1+}"
		local p2 "marginal proportion {it:p+1}"
	}
	else {
		if (`"`oratio'"'!="") {
			di as err "{p}{bf:oratio()} needs to be specified " ///
				"with {bf:corr()}{p_end}"
			exit 198
		}
		if (`"`rrisk'"'!="") {
			di as err "{p}{bf:rrisk()} needs to be specified " ///
				"with {bf:corr()}{p_end}"
			exit 198
		}
		local p1 "success-failure proportion {it:p12}"
		local p2 "failure-success proportion {it:p21}"
	}

	gettoken arg1 args : args, match(par)
	gettoken arg2 args : args, match(par)
	local nargs 0
	if `"`arg1'"'!="" {
		capture numlist "`arg1'", range(>0 <1)
		if (_rc!=0) {
			di as err "{p}`p1' must be between 0 and 1{p_end}"
			exit 198
		}
		local alist1 `r(numlist)'
		local k1 : list sizeof alist1
		local ++nargs
	}
	else local k1 0

	if `"`arg2'"'!="" {
		capture numlist "`arg2'", range(>0 <1)
		if (_rc!=0) {
			di as err "{p}`p2' must be between 0 and 1{p_end}"    
			exit 198
		}
		local alist2 `r(numlist)'
		local k2 : list sizeof alist2
		local ++nargs

		if (`k1'==1 & `k2'==1) {
			if reldif(`alist1', `alist2') < 1e-10 {
				di as err "{p}`p1' is equal to `p2'; " ///
					  "this is not allowed{p_end}"
				exit 198
			}

			if (`"`corr'"'=="" & `alist1'+`alist2'>1 ) {
				di as err "{p}the sum of two discordant " ///	
					  "proportions is greater than 1; " ///
					  "this is not allowed{p_end}"
				exit 198
			}
		}
	}
	else local k2 0

	if `"`args'"'!="" {
		local ++nargs
	}

	// check arguments
	if (`nargs' >2) {
		di as err "{p}too many arguments specified;{p_end}"
		di as err "{p 4 4 2}If you are specifying multiple values, "
		di as err "remember to enclose them in parentheses.{p_end}"
		exit 198
	}

	if ("`solvefor'"=="esize") {
		if (`"`corr'`rrisk'`oratio'`diff'`ratio'"'!="") {
			di as err "{p}Options {bf:corr()}, {bf:rrisk()}, "
			di as err "{bf:oratio()}, {bf:ratio()}, and "
			di as err "{bf:diff()} are not allowed "
			di as err "with effect-size computation{p_end}"		
			exit 198
		}

		if (`nargs'!=0) {
			di as err ///
				  "{p}too many arguments specified "	///
				  "with effect-size calculation{p_end}"
			exit 198
		}
		else {
			if (`"`prd'"'=="") {
				di as err "{p}Either {bf:sum()} or "
				di as err "{bf:prdiscordant()} must be specified "
				di as err "with effect-size computation{p_end}"
				exit 198
			}
		}
	}
	else {
		if (`nargs'==2) {  // specify two arguments
			if (`"`diff'`ratio'`oratio'`prd'`rrisk'"'!="") {
				di as err "{p}Options {bf:diff()}, "
				di as err "{bf:ratio()}, {bf:oratio()}, "
				di as err "{bf:rrisk()}, {bf:prdiscordant()},"
				di as err " and {bf:sum()}"
				di as err " are not allowed when both "
				di as err " arguments are specified{p_end}"	
				exit 198
			}
		}
		else if (`nargs'==1) {	// specify one argument
			if (`"`corr'"'!="") { // specify marginal proportions
				if (`"`diff'`ratio'`oratio'`rrisk'"'!="") {
				    local nopts 0
				    if (`"`diff'"'!="") local ++nopts
				    if (`"`ratio'"'!="") local ++nopts
				    if (`"`oratio'"'!="") local ++nopts
				    if (`"`rrisk'"'!="") local ++nopts

				    if (`nopts' >1) {
					di as err "{p}only one of "
					di as err "{bf:ratio()}, {bf:diff()}, "
					di as err "{bf:oratio()}, or "
					di as err " {bf:rrisk()} is "
					di as err "allowed with "
					di as err "{bf:corr()}{p_end}"
					exit 198	
				   }
				}
				else {
				   di as err "{p}Either `p2', or one of the" ///
				       " options {bf:diff()}, {bf:ratio()}," ///
				       " {bf:rrisk()}, or {bf:oratio()}, " ///
				       "must be specified{p_end}"   
				   exit 198
				}
			}
			else { // specify one cell proportion 
				if (`"`diff'`ratio'`prd'"'!="") {
				    local nopts 0
				    if (`"`diff'"'!="") local ++nopts
				    if (`"`ratio'"'!="") local ++nopts
				    if (`"`prdiscord'"'!="") local ++nopts
				    if (`"`sum'"'!="") local ++nopts

				    if (`nopts'>1) {
					di as err "{p}only one of {bf:diff()}, "
					di as err "{bf:ratio()}, {bf:sum()}, "
					di as err "or {bf:prdiscordant()} is "
					di as err "allowed{p_end}"
					exit 198	
				    }
				}
				else {
					di as err "{p}Either `p2', or one "
					di as err "of the options {bf:diff()}, "
					di as err "{bf:ratio()}, {bf:sum()}, or"
					di as err " {bf:prdiscordant()}, "
					di as err "must be specified{p_end}"
					exit 198
				}
			}
		}
		else {  // not specify any argument
			if (`"`corr'"'!="") { // marginal
				if (`"`ratio'`rrisk'"'!="") {
					local nopts 0
					if (`"`ratio'"'!="") local ++nopts
					if (`"`rrisk'"'!="") local ++nopts
					if (`nopts'>1) {
						di as err "{p}only one of "
						di as err "{bf:rrisk()} or "
						di as err "{bf:ratio()} is "
						di as err "allowed{p_end}"
						exit 198
					}
					local rat `ratio'`rrisk'
				}

				if (`"`diff'`rat'`oratio'"'!="") {
					local nopts 0
					if (`"`diff'"'!="") local ++nopts
					if (`"`rat'"'!="") local ++nopts
					if (`"`oratio'"'!="") local ++nopts

					if (`nopts'==1) {
						if (`"`diff'"'!="") ///
							local extra ///
						"{bf:ratio()}, {bf:rrisk()}"
						if (`"`oratio'"'!="") /// 
							local extra ///
						"{bf:ratio()}, {bf:rrisk()}"
						if (`"`rat'"'!="") ///
							local extra ///
			 			"{bf:diff()}, {bf:oratio()}"
di as err ///
"{p}Either `p1', or one of the options `extra', needs to be specified{p_end}" 
						exit 198	
				    	}	
				    	else if (`nopts'>2) {
di as err "{p}Only one of the combinations,"
di as err "{bf:diff()} and {bf:ratio()}, {bf:diff()} and {bf:rrisk()}, "
di as err "{bf:oratio()} and {bf:ratio()}, {bf:oratio()} and {bf:rrisk()}, "
di as err "is allowed with {bf:corr()}{p_end}"
exit 198	
				    	}
					else if (`nopts'==2) {
						if (`"`diff'"'!="" &  ///
							`"`oratio'"'!="") {
di as err "{p}invalid combination: {bf:diff()} and {bf:oratio()};{p_end}"
di as err "{p 4 4 2}Only one of the combinations,"
di as err "{bf:diff()} and {bf:ratio()}, {bf:diff()} and {bf:rrisk()}, "
di as err "{bf:oratio()} and {bf:ratio()}, {bf:oratio()} and {bf:rrisk()}, "
di as err "is allowed with {bf:corr()}{p_end}"
exit 198	
						}
					}
				}
				else {
				di as err "{p}Both marginal proportions "  ///
					"{it:p1+} and {it:p+1} need to be " ///
					"specified;{p_end}"
				di as err "{p 4 4 2}alternatively, `p1' "  ///
					"and one of the options {bf:diff()}" ///
					", {bf:ratio()}, {bf:rrisk()}, " ///
					"{bf:oratio()} are needed{p_end}"
				exit 198
				}
			}
			else { // cell proportion
				if (`"`prd'`diff'`ratio'"'!="") {
				    local nopts 0 
				    if (`"`prd'"'!="") local ++nopts
				    if (`"`diff'"'!="") local ++nopts
				    if (`"`ratio'"'!="") local ++nopts

				    if (`nopts'==1) {
					if (`"`prd'"'!="") local extra ///
						"{bf:diff()}, {bf:ratio()}"
					if (`"`diff'"'!="") local extra ///
			"{bf:ratio()}, {bf:prdiscordant()}, or {bf:sum()}"
					if (`"`ratio'"'!="") local extra ///
			 "{bf:diff()}, {bf:prdiscordant()}, or {bf:sum()}"
di as err ///
"{p}Either `p1', or one of the options `extra', needs to be specified{p_end}" 
					exit 198	
				    }
				    else if (`nopts'>2) {
di as err "{p}Only one of the combinations, "
di as err "{bf:prdiscordant()} and {bf:diff()}, "
di as err "{bf:prdiscordant()} and {bf:ratio()}, {bf:sum()} and {bf:diff()}, "
di as err "{bf:sum()} and {bf:ratio()}, and {bf:diff()} and {bf:ratio()}, "
di as err "is allowed{p_end}"
exit 198	
				    }
				}
				else {
				    di as err "{p}Both discordant proportions " 
				    di as err "{it:p12} and {it:p21} need to "
				    di as err "be specified;{p_end}"
				    di as err "{p 4 4 2}alternatively, "	
				    di as err "`p1' and one of the options"
				    di as err " {bf:diff()}, {bf:ratio()}, "
				    di as err "{bf:sum()}, or "
				    di as err "{bf:prdiscordant()}" 
				    di as err " are needed.{p_end}"
				    exit 198
				}
			}
		}
	}

	if (`"`diff'"'!= "") {
		cap numlist `"`diff'"', range(>= -1 <= 1)
		if (_rc) {
			di as err "{p}{bf:diff()} must "	///
				"contain values between -1 and 1{p_end}" 
			exit 198
		}
		local dflist `r(numlist)'
		local n_df : list sizeof dflist
		if (`n_df'== 1) {
			if abs(`dflist') < 1e-10 {
				di as err /// 
				    "{p}invalid {bf:diff(`dflist')};{p_end}" 
				di as err "{p 4 4 2}the resulting `p2' is " ///
				    "equal to `p1'; this is not allowed{p_end}"
				exit 198
			}
		}
	}
	else local n_df 0
	if (`"`ratio'"'!="") {
		cap numlist `"`ratio'"', range(>0)
		if (_rc) {
			di as err "{p}{bf:ratio()} must "	///
				"contain positive numbers{p_end}"	
			exit 198
		}
		local ratlist `r(numlist)'
		local n_rat : list sizeof ratlist
		if (`n_rat'==1) {
			if (reldif(`ratlist', 1)< 1e-10) {
				di as err ///
				    "{p}invalid {bf:ratio(`ratlist')};{p_end}"
				di as err "{p 4 4 2}the resulting `p2' is " ///
				    "equal to `p1'; this is not allowed{p_end}"
				exit 198 
			}
		}
	}
	else local n_rat 0
	if (`"`oratio'"'!="") {
		cap numlist `"`oratio'"', range(>0)
		if(_rc) {
			di as err "{p}{bf:oratio()} must "	///
				"contain positive numbers{p_end}"
			exit 198
		}
		local orlist `r(numlist)'
		local n_or : list sizeof orlist
		if (`n_or'==1) {
			if (reldif(`orlist', 1)< 1e-10) {
				di as err ///
				    "{p}invalid {bf:oratio(`orlist')};{p_end}"
				 di as err "{p 4 4 2}the resulting `p2' is " ///
				    "equal to `p1'; this is not allowed{p_end}"
				exit 198 
			}
		}
	}
	else local n_or 0
	if (`"`rrisk'"'!="") {
		cap numlist `"`rrisk'"', range(>0)
		if(_rc) {
			di as err "{p}{bf:rrisk()} must "	///
				"contain positive numbers{p_end}"
			exit 198
		}
		local rrlist `r(numlist)'
		local n_rr : list sizeof rrlist
		if (`n_rr'==1) {
			if (reldif(`rrlist', 1)< 1e-10) {
				di as err ///
				    "{p}invalid {bf:rrisk(`rrlist')};{p_end}"
				 di as err "{p 4 4 2}the resulting `p2' is " ///
				    "equal to `p1'; this is not allowed{p_end}"
				exit 198 
			}
		}
	}
	else local n_rr 0
	if (`"`prd'"'!="") {
		if(`"`prdiscord'"'!="") {
			cap numlist `"`prdiscord'"', range(>=0 <=1)
			if(_rc) {
				di as err "{p}{bf:prdiscordant()} must " ///
				    	"contain values between 0 and 1{p_end}"
				exit 198
			}
		}
		if(`"`sum'"'!="") {
			cap numlist `"`sum'"', range(>=0 <=1)
			if(_rc) {
				di as err "{p}{bf:sum()} must "	///
					"contain values between 0 and 1{p_end}"
				exit 198
			}
		}
		local prdlist `r(numlist)'
		local n_prd : list sizeof prdlist
		if ("`solvefor'"=="esize" & `n_prd'==1 & `"`init'"'!="") {
			local rc = (`init' < -`prdlist' | `init' > `prdlist')
			if `rc' {
				di as err ///
				"{p}invalid {bf:init()}: expected a real " ///
				"between -`prdlist' and `prdlist'{p_end}"
				exit 198
			}
		}
	}
	else local n_prd 0
	if (`"`corr'"'!="") {
		cap numlist `"`corr'"', range(>=-1 <=1)
		if(_rc) {
			di as err "{p}{bf:corr()} must "	///
				"contain values between -1 and 1{p_end}"
			exit 198
		}
		local corrlist `r(numlist)'
		local n_corr : list sizeof corrlist
	}
	else local n_corr 0

	// handle error when no numlist
	if (`k1'<= 1 & `k2' <= 1 & `n_df' <= 1 & `n_rat' <= 1 & 	///
	    `n_rr' <= 1 & `n_or' <= 1 & `n_prd' <= 1 & `n_corr' <= 1    ///
		& "`solvefor'"!="esize") {
		_handle_error_no_numlist "`k1'" "`k2'" "`n_df'" "`n_rat'"  ///
			"`n_rr'" "`n_or'" "`n_prd'" "`n_corr'" "`alist1'"  ///
			"`alist2'" "`dflist'" "`ratlist'" "`rrlist'" ///
			"`orlist'" "`prdlist'" "`corrlist'" 
	}

	// handle effect()
	_pss_pairedpr_parseeffect effect : `"`effect'"' `nargs'	///
		"`diff'" "`ratio'" "`rrisk'" "`oratio'" "`corr'"	

	mata: `pssobj'.initonparse("`corr'","`prdiscord'","`sum'", 	///
				   "`diff'", "`ratio'", "`rrisk'", 	///
				   "`oratio'","`effect'")
end

program _handle_error_no_numlist
	args k1 k2 n_df n_rat n_rr n_or n_prd n_corr  ///
	     alist1 alist2 dflist ratlist rrlist orlist prdlist corrlist

	tempname p01 p10 p12 p21

	if (`n_corr'==1) {
		local p1 "marginal proportion {it:p1+}"
		local p2 "marginal proportion {it:p+1}"

	}
	else {
		local p1 "success-failure proportion {it:p12}"
		local p2 "failure-success proportion {it:p21}"
	}
	if (`n_corr'==1) {
		if (`k1'==1 & `k2'==0) {
			scalar `p10' = `alist1'
			if (`n_df'==1) scalar `p01' = `p10'+`dflist'
			else if (`n_rat'==1) scalar `p01' = `p10'*`ratlist'
			else if (`n_rr'==1)  scalar `p01' = `p10'*`rrlist'
			else if (`n_or'==1)  ///
				scalar `p01' = (`p10'*`orlist')/   ///	
					       (1-`p10'+`p10'*`orlist')
			if (`p01'>=1) {
				di as err "{p}the resulting `p2' " ///
					"is greater than or equal to 1; " ///
					"this is not allowed{p_end}" 
				exit 198
			}
			else if (`p01'<= 0) {
				di as err "{p}the resulting `p2' " ///
					"is less than or equal to 0; " ///
					"this is not allowed{p_end}" 
				exit 198
			}
		}
		else if (`k1'==0 & `k2'==0) {
			if (`n_df'==1 & `n_rat'==1) {
				scalar `p10' = `dflist'/(`ratlist'-1)
				scalar `p01' = `ratlist'*`dflist'/(`ratlist'-1)
			}
			else if (`n_df'==1 & `n_rr'==1) {
				scalar `p10' = `dflist'/(`rrlist'-1)
				scalar `p01' = `rrlist'*`dflist'/(`rrlist'-1)
			}
			else if (`n_or'==1 & `n_rr'==1) {
				scalar `p10' = (`orlist'-`rrlist')/ ///
						(`rrlist'*`orlist'-`rrlist')
				scalar `p01' = `rrlist'*(`orlist'-`rrlist')/ ///
					    	(`rrlist'*`orlist'-`rrlist')
			}
			else if (`n_or'==1 & `n_rat'==1) {
				scalar `p10' = (`orlist'-`ratlist')/ ///
						(`ratlist'*`orlist'-`ratlist')
				scalar `p01'=`ratlist'*(`orlist'-`ratlist')/ ///
					     (`ratlist'*`orlist'-`ratlist')
			}

			if (`p10'>= 1 | `p10'<= 0 | `p01'>= 1 | `p01'<= 0) {
				di as err "{p}the resulting `p1' and `p2' " ///
					    "must be between 0 and 1{p_end}"
				exit 198
			}
		}
		else if (`k1'==1 & `k2'==1) {
			scalar `p10' = `alist1'
			scalar `p01' = `alist2'
		}
		scalar `p12'= `p10'*(1-`p01')- ///
			      `corrlist'*sqrt((1-`p10')*`p10'*(1-`p01')*`p01')
		scalar `p21'= `p12'+`p01'-`p10' 
	}
	else {
		if (`k1'==1 & `k2'==1) {
			scalar `p12' = `alist1'
			scalar `p21' = `alist2'
		}
		else if (`k1'==1 & `k2'==0) {
			scalar `p12' = `alist1'
			if (`n_prd'==1) scalar `p21' = `prdlist'-`p12'
			else if (`n_df'==1) scalar `p21' = `dflist'+`p12'
			else if (`n_rat'==1) scalar `p21' = `p12'*`ratlist'	

			if (`p21'>=1) {
				di as err "{p}the resulting `p2' " ///
					"is greater than or equal to 1; " ///
					"this is not allowed{p_end}"
				exit 198
			}
			else if (`p21'<= 0) {
				di as err "{p}the resulting `p2' " ///
					"is less than or equal to 0; " ///
					"this is not allowed{p_end}"
				exit 198
			}	
		}
		else if (`k1'==0 & `k2'==0) {
			if (`n_prd'==1 & `n_df'==1) {
				scalar `p12' = (`prdlist'-`dflist')/2
				scalar `p21' = (`prdlist'+`dflist')/2 
			}
			else if (`n_prd'==1 & `n_rat'==1) {
				scalar `p12'=`prdlist'/(1+`ratlist')
				scalar `p21'=`ratlist'*`prdlist'/(1+`ratlist')
			}
			else if (`n_df'==1 & `n_rat'==1) {
				scalar `p12' = `dflist'/(`ratlist'-1)
				scalar `p21' = `ratlist'*`dflist'/(`ratlist'-1)	
			}
		}
	}
	if (`p12'>=1 | `p12'<= 0 | `p21' >=1 | `p12'<= 0) {
		di as err "{p}the resulting discordant proportions " ///
			  "{it:p12} and {it:p21} must be between 0" ///
			  " and 1{p_end}"
		exit 198
	}
	if (`p12'==`p21') {
		di as err "{p}the resulting discordant proportions" ///
		    	  " are equal; this is not allowed{p_end}" 
		exit 198
	}
	if (`p12'+`p21'>1) {
		di as err "{p}the sum of the resulting discordant " ///
		 	  "proportions must be between 0 and 1{p_end}"
		exit 198
	}

end 

