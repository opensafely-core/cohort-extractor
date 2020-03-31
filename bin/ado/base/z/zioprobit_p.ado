*! version 1.0.2  10dec2019 
program define zioprobit_p
	version 15
	syntax [anything] [if] [in] [, SCores Outcome(string) ///
		PMargin pcond1 noOFFset XB XBInfl ///
		STDP STDPInfl ppar pnpar PJoint1 * ///
		]


	if `"`scores'"' != "" {
		tempvar touse
     		qui gen byte `touse' = 0
                qui replace `touse' = 1 `if' `in'
nobreak {
				
		mata: ziop_init("inits", 	///
		"`e(depvar)'", 		///
		"`e(ncut)'","`e(encat)'",  	///
		"e(cat)","`touse'")
		
				
		capture noisily break {
			ml score `anything' if `touse', `options' userinfo(`inits') 
						// so -equation()- is allowed
			
		}
		local rc = _rc
		capture mata: rmexternal("`inits'")
} // nobreak
		if `rc' {
			error `rc'
		}
		exit
	}
	
        local depname `e(depvar)'
	local rhs `e(rhs)'        
	tempvar xbv zg
	marksample touse
	
	if (`:list sizeof rhs') {
		qui _predict double `xbv' if `touse', eq(#1) `offset' 
		qui _predict double `zg' if `touse', eq(#2) `offset' 
	}
	else {	// Eq order will flip here
		qui _predict double `zg' if `touse', eq(#1) `offset'
		qui gen byte `xbv' = 0 if `touse'
	}
	
	local ncats = e(k_cat)
	capture _stubstar2names `anything', nvars(`ncats')

	if (_rc != 110) { 
		local alln = !_rc // 0 if too few or too many var specified
	}			  // 1 if correct num. `ncats' of var specified
	else {
		// exit with an error if variable is already defined	
		_stubstar2names `anything', nvars(`ncats')
	}
	local type  `xb' `xbinfl' `stdp' `stdpinfl' `ppar' `pmargin' ///
		`pcond1' `pnpar' `pjoint1'
        if `:word count `type'' > 1 {
        	local type : list retok type // re-list single space btw elmnts
        	di as err /// 
		  "the following options may not be combined: {bf:`type'}"
		sreturn clear
        	exit 198
        }
	
	if !`alln' { // not all `ncats' variable are specified.
		capture _stubstar2names `anything', nvars(1)
		if (_rc) {
			if ("`xb'`xbinfl'`stdp'`stdpinfl'`ppar'`pnpar'" == "") {
				MultVars `anything'
			}
			else {
				Onevar `type' `s(varlist)'			
			}
			sreturn clear
		}		
		local myopts XB XBInfl STDP STDPInfl ppar PMargin ///
			pcond1 pnpar PJoint1
	
		if ("`outcome'" == "") {
			_pred_se "`myopts'" `0'
			if `s(done)' { 
				exit 
			}

			local vtyp  `s(typ)'
			local varn `s(varn)'
			local 0 `"`s(rest)'"'
			syntax [if] [in] [, `myopts' ///
		  		noOFFset]
		}
		else {
                	syntax newvarlist(min=1 max=1 numeric) [if] [in] ///
				[, `myopts' Outcome(string) ///
			        noOFFset ]

			local vtyp `typlist'
			local varn `varlist'
		}
	
		local type  `xb'`xbinfl'`stdp'`stdpinfl'`ppar'`pnpar'
		capture assert "`outcome'" == "" if  "`type'" != ""
		if (_rc) {
			di as error ///
			`"cannot specify {bf:outcome()} with {bf:`type'}"'
			exit 198
		}
		
		local args	

		// linear predictor for equation 1 
		if "`type'" == "xb" {
			if (`:list sizeof rhs') {
				gen `vtyp' `varn' = `xbv' if `touse'
			}
			else {
				gen `vtyp' `varn' = . if `touse'
			}	
			label var `varn' "Linear prediction of `depname'"
			exit
		}
		// linear predictor for equation 2
		if "`type'" == "xbinfl" { 
			gen `vtyp' `varn' = `zg' if `touse'
			label var `varn' "Linear prediction of inflate"			
			exit
		}
	
		// standard error for equation 1
		if "`type'" == "stdp" { 
			if (`:list sizeof rhs') {
				_predict `vtyp' `varn', stdp eq(#1) `offset', if `touse'
			}
			else {
				gen `vtyp' `varn' = . if `touse'
			}	
			label var `varn' "S.E. of prediction of `depname'"
			exit
		}
	
		// Inflation standard error 
		if "`type'" == "stdpinfl" { 
			local infleq = cond(`:list sizeof rhs', "#2", "#1")
			_predict `vtyp' `varn', stdp eq(`infleq') `offset', ///
				if `touse'			
			label var `varn' "S.E. of prediction of inflate"			
			exit
		}
	
		// Probability of participation (P(sj  = 1)) 
		if "`type'" == "ppar" {
			gen `vtyp' `varn' = normal(`zg') if `touse'
			label var `varn' "Pr(participation)"			
			exit
		}
		
		// Probability of non-participation (P(sj  = 0)) 
		if "`type'" == "pnpar" {
			gen `vtyp' `varn' = normal(-`zg') if `touse'
			label var `varn' "Pr(nonparticipation)"			
			exit
		}
		// got here so it must be probability of an outcome
		if `"`outcome'"'=="" {
			// default to first outcome
			local outcome #1
		}
		//outcome is either #order, or value
		Eq `outcome'
	        local i `s(icat)'
        	local im1 = `i' - 1 // i minus 1
	        sret clear
	
		if (_rc) {
			di in smcl as err "{bf:outcome()} must be specified" ///
					    "under option {bf:pmargin}"
			exit 198
		}

		local ilist `i'
		local imlist `im1'
		local varnlist `varn'
		local vtyplist `vtyp'

	}
	else { // if stub* or k variables are specified, 
		if ("`xb'`xbinfl'`stdp'`stdpinfl'`ppar'`pnpar'" != "") {
			Onevar `type' `s(varlist)'			
		}

		local varnlist `s(varlist)'
		local vtyplist `s(typlist)'
		sreturn clear
		assert "`options'" == ""
		local ilist
		loca imlist
		forvalues i = 1/`ncats' {
			local ilist `ilist' `i'
			local im1 = `i' - 1
			local imlist `imlist' `im1'
		}

	}
	

	if ("`pcond1'`pjoint1'`pmargin'" == "")  {
		di as text ///
		"(option {bf:pmargin} assumed; " ///
		"predicted marginal probability)"
	}
	local k: word count `ilist'
	local ncut = `ncats'-1
	
	tempname cut 		
	matrix `cut' = e(b)'

	local l = rownumb(`cut', "/:cut1")
	local u = rownumb(`cut', "/:cut`ncut'")
	matrix `cut' = `cut'[`l'..`u',1]

	forvalues l =1/`k' {	
		local i: word `l' of `ilist'
		local im1: word `l' of `imlist'
		local varn: word `l' of `varnlist'
		local vtyp: word `l' of `vtyplist'
		if("`pcond1'" != "") {
			if (`i' == 1) {
				gen `vtyp' `varn' = 			 ///
					normal(`cut'[`i',1]-`xbv') 	 ///
					if `touse'
			}
			else if (`i' == `e(encat)') {
				gen `vtyp' `varn' = 			///
					normal(`xbv'-`cut'[`im1',1])	///
					if `touse'
			}
			else {
				gen `vtyp' `varn' = 		   	///
					normal(`cut'[`i',1]-`xbv') - 	///
					normal(`cut'[`im1',1]-`xbv') 	///
					if `touse'
			}
		}
		else if ("`pjoint1'"  != ""){
			if (`i' == 1) {
       	                	gen `vtyp' `varn' = 			///
					normal(`zg') * 			///
					normal(`cut'[`i',1]-`xbv') 	///
					if `touse'	               			        					 
        	        }
       	        	else if (`i'== `e(encat)') {
				gen `vtyp' `varn' = 		     	///
					normal(`zg') * 			///
					normal(`xbv'-`cut'[`im1',1]) 	///
					if `touse'
	                }
       		        else {
		        	gen `vtyp' `varn' = 		   	///
					normal(`zg') * 			///
					(normal(`cut'[`i',1]-`xbv') - 	///
					normal(`cut'[`im1',1]-`xbv')) 	///
               	        		if `touse'
		        }
		}
		else {
			if (`i' == 1) {
       	                	gen `vtyp' `varn' = 			///
					normal(-`zg') + 		///
					normal(`zg') * 			///
					normal(`cut'[`i',1]-`xbv') 	///
					if `touse'	               			        					 
        	        }
       	        	else if (`i'== `e(encat)') {
				gen `vtyp' `varn' = 		     	///
					normal(`zg') * 			///
					normal(`xbv'-`cut'[`im1',1]) 	///
					if `touse'
	                }
       		        else {
		        	gen `vtyp' `varn' = 		   	///
					normal(`zg') * 			///
					(normal(`cut'[`i',1]-`xbv') - 	///
					normal(`cut'[`im1',1]-`xbv')) 	///
               	        		if `touse'
		        }
		}
		tempname catmat
		matrix `catmat' = e(cat)
		
		local ival = `catmat'[1, `i']
		
		if ("`pcond1'`pjoint1'" == "") {
			label variable `varn' `"Pr(`depname'=`ival')"'
		}
		else if ("`pcond1'" == "") {
			label variable `varn' ///
		       `"Pr(`depname'=`ival', participation=1)"'	
		}
		else {			
		       label variable `varn' ///
		       `"Pr(`depname'=`ival'|participation=1)"'			
		}				
	}
end

// from ologit_p

// for parsing the inside of option outcome()
program define Eq, sclass
        sret clear
        local out = trim(`"`0'"')
        if bsubstr(`"`out'"',1,1)=="#" {
                local out = bsubstr(`"`out'"',2,.)
                Chk confirm integer number `out'
                Chk assert `out' >= 1
                capture assert `out' <= `e(encat)'
                if _rc {
                        di as err "there is no outcome #`out'" _n /*
                        */ "there are only `e(encat)' categories"
                        exit 111
                }
                sret local icat `"`out'"'
                exit
        }

        Chk confirm number `out'
        local i 1
        while `i' <= e(k_cat) {
                if `out' == el(e(cat),1,`i') {
                        sret local icat `i'
                        exit
                }
                local i = `i' + 1
        }

        di as err `"outcome `out' not found"'
        Chk assert 0 /* return error */
end

program define Chk
        capture `0'
        if _rc {
		local w: word 1 of `e(depvar)'
                di as err "{bf:outcome()} must either be a value of `w'," /*
                */ _n "or #1, #2, ..."
                exit 111
        }
end

program define Onevar
        gettoken option 0 : 0
        local n : word count `0'
        if `n'==1 {
		exit 
	}
        di as err "option {bf:`option'} requires that you specify 1 "
	di as err " new variable"
        error cond(`n'==0,102,103)
end


program MultVars
        syntax [newvarlist]
        local nvars : word count `varlist'
        if `nvars' == e(k_cat) {
                exit
        }
        if `nvars' != e(k_cat) {
		local ed: word 1 of `e(depvar)'
                capture noisily error cond(`nvars'<e(k_cat), 102, 103)
                di as err "{p 4 4 2}" /*
                */ "`ed' has `e(k_cat)' outcomes so you " /*
                */ "must specify `e(k_cat)' new variables, or " _n /*
                */ "you can use the {bf:outcome()} option and specify " /*
                */ "variables one at a time{p_end}"
                exit cond(`nvars'<e(k_cat), 102, 103)
        }
end

exit
