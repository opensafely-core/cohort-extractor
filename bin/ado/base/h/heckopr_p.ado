*! version 1.1.2  19feb2019
program define heckopr_p
	version 13.0
	syntax [anything] [if] [in] [, SCores Outcome(string) ///
		PMargin p0 p1 pcond0 pcond1 noOFFset XB XBSel ///
		STDP STDPSel PSel ///
		]
	if ("`p1'`pcond1'" != "") {
		local select 1
	}
	if ("`p0'`pcond0'" != "") {
		local select 0
	}
	if ("`pcond0'`pcond1'" != "") {
		local conditional conditional
	}
	capture assert inlist(ltrim(rtrim("`select'")),"1","0","")
	if _rc {
		di as error "{bf:select()} must be 0 or 1"
		exit 111
	}
	else {
		local select = ltrim(rtrim("`select'"))
	}
	if `"`scores'"' != "" {
		tempvar touse
     		qui gen byte `touse' = 0
                qui replace `touse' = 1 `if' `in'
		nobreak {
			if ("`e(eseldep)'" != "") {		
				mata: heckoprob_init("inits", 	///
				"`e(eseldep)'", 		///
                	        "`e(encut)'","`e(encat)'",  	///
                        	"e(cat)","`touse'")
			}
			else {
			       	tempvar seldep
   				gen byte `seldep' = `touse'
				local w: word 1 of `e(depvar)'
				markout `seldep' `w'
				mata: heckoprob_init("inits", ///
	        	        "`seldep'", "`e(encut)'","`e(encat)'",  ///
        	        	"e(cat)","`touse'")
			}
		}
		capture noisily break {
			ml_p `0' missing userinfo(`inits')
		}
		local rc = _rc
		capture mata: rmexternal("`inits'")
		if `rc' {
			error `rc'
		}
		exit
	}
        tokenize `e(depvar)'
        local depname `1'
        local selname = cond("`2'"=="", "select", "`2'")
	tempvar xbv zg
	tempname r
	marksample touse
	qui _predict double `xbv' if `touse', eq(#1) `offset' 
	qui _predict double `zg' if `touse', eq(#2) `offset' 
	if `:colnfreeparms e(b)' {
		scalar `r' = _b[/athrho]
	}
	else {
		scalar `r' = [athrho]_b[_cons]
	}
	scalar `r' = (expm1(2*`r'))/(exp(2*`r')+1)
	local ncats = e(k_cat)
	capture _stubstar2names `anything', nvars(`ncats')
	if (_rc != 110) {
		local alln = !_rc	
	}
	else {
		_stubstar2names `anything', nvars(`ncats')
	}
	local type  `xb' `xbsel' `stdp' `stdpsel' `psel' `pmargin' ///
`p0' `p1' `pcond0' `pcond1'
	local mitipo `"`type'"'
        if `:word count `type'' > 1 {
        	local type : list retok type
        	di as err "the following options may not be combined: `type'"
		sreturn clear
        	exit 198
        }
	if !`alln' {
		capture _stubstar2names `anything', nvars(1)
		if (_rc) {
			if ("`xb'`xbsel'`stdp'`stdpsel'`psel'" == "") {
				MultVars `anything'
			}
			else {
				Onevar `type' `s(varlist)'			
			}
			sreturn clear
		}		
		local myopts XB XBSel STDP STDPSel PSel PMargin

		if ("`outcome'`select'" == "") {
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
			        noOFFset PMargin ///
				p1 p0 pcond1 pcond0]
			local vtyp `typlist'
			local varn `varlist'
		}

		local type  `xb'`xbsel'`stdp'`stdpsel'`psel'
		capture assert "`outcome'" == "" if  "`type'" != ""
		if (_rc) {
			di as error ///
			`"cannot specify {bf:outcome()" with {bf:`type'}"'
			exit 198
		}
		capture assert "`select'" == "" if  "`type'" != ""
		if (_rc) {
			di as error ///
			`"cannot specify {bf:outcome()" with {bf:`type'}"'
			exit 198
		}
		local args	

		// linear predictor for equation 1 
		if "`type'" == "xb" {	
			gen `vtyp' `varn' = `xbv' if `touse'
			label var `varn' "Linear prediction of `depname'"
			exit
		}
		// linear predictor for equation 2
		if "`type'" == "xbsel" { 
			gen `vtyp' `varn' = `zg' if `touse'
			if ("`e(eseldep)'" != "") {
				label var `varn' ///
				"Linear prediction of `selname'"
			}
			else {
				label var `varn' "Linear prediction of select"
			}
			exit
		}
	
		// standard error for equation 1
		if "`type'" == "stdp" { 
			_predict `vtyp' `varn', stdp eq(#1) `offset', if `touse'
			label var `varn' "S.E. of prediction of `depname'"
			exit
		}
	
		// Selection index standard error 
		if "`type'" == "stdpsel" { 
			_predict `vtyp' `varn', stdp eq(#2) `offset', ///
				if `touse'
			if ("`e(eseldep)'" != "") {
				label var `varn' ///
				"S.E. of prediction of `selname'"
			}
			else {
        	                label var `varn' "S.E. of prediction of select"
			}
			exit
		}
	
		// Probability observed, from selection equation 
		if "`type'" == "psel" {
			gen `vtyp' `varn' = normal(`zg') if `touse'
			if ("`e(eseldep)'" != "") {
				label var `varn' "Pr(`selname')"
			}
			else {
				label var `varn' "Pr(select)"
			}
			exit
		}
	
		// got here so it must be probability outcome
		capture assert `"`outcome'"'!=""
		if (_rc) {
			// default to first outcome
			local outcome #1
		}
		//outcome is either #order, or value
		Eq `outcome'
	        local i `s(icat)'
        	local im1 = `i' - 1
	        sret clear
	
		if (_rc) {
		di in smcl as error "{bf:outcome()} must be specified" ///
					    "under option {bf:pmargin}"
			exit 198
		}
		local ilist `i'
		local imlist `im1'
		local varnlist `varn'
		local vtyplist `vtyp'
	}
	else {
		if ("`xb'`xbsel'`stdp'`stdpsel'`psel'" != "") {
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
	if ("`conditional'" != "" & "`select'" == "") {
		di as error "{bf:conditional} requires {bf:select()}"
		exit 198
	}
	local cs 	
	if ("`conditional'" != "") {
		tempvar cscale
		if (`select' == 1) {
			qui gen double `cscale' = normal(`zg') if `touse'
		}
		else {
			qui gen double `cscale' = 1-normal(`zg') if `touse'
		}
		qui replace `cscale' = . if `cscale' < 1e-10
		local cs /`cscale'
	} 
	if ("`mitipo'" == "") {
		di as text ///
		"(option {bf:pmargin} assumed; " ///
		"predicted marginal probability)"
	}
	local k: word count `ilist'
	local szg
	local sr
	if ("`select'" != "") {
		if ("`select'" == "1") {
			local szg `zg'
			local sr -`r'
		}
		else {
			local szg -`zg'
			local sr `r'
		}
	}
	if `:colnfreeparms e(b)' {
		forvalues i = 1/`e(encut)' {
			local cut`i' _b[/cut`i']
		}
	}
	else {
		forvalues i = 1/`e(encut)' {
			local cut`i' [cut`i']_b[_cons]
		}
	}
	forvalues l =1/`k' {	
		local i: word `l' of `ilist'
		local im1: word `l' of `imlist'
		local varn: word `l' of `varnlist'
		local vtyp: word `l' of `vtyplist'
		if("`select'" == "") {
			if (`i' == 1) {
				gen `vtyp' `varn' = 			///
					normal(-`xbv'+`cut`i'')		///
					if `touse'
			}
			else if (`i' == `e(encat)') {
				gen `vtyp' `varn' = 			///
					normal(`xbv'-`cut`im1'')
			}
			else {
				local j = `i' - 1
				gen `vtyp' `varn' = max(		///
					normal(-`xbv'+`cut`i'')		///
					- normal(-`xbv'+`cut`j'')	///
					,0)  if `touse'
			}
		}
		else {
			if (`i' == 1) {
       	                	gen `vtyp' `varn' = 		///
               			        (binormal(`szg', 	///
					-`xbv'+ 		///
					`cut`i'',`sr')		///
					)`cs' if `touse'
        	        }
       	        	else if (`i'== `e(encat)') {
				gen `vtyp' `varn' = 		     ///
					max(normal(`szg')-	     ///
               			        binormal(`szg', 	     ///
					-`xbv'+ 		     ///
					`cut`im1'',`sr'),0)	     ///
					`cs'	            	     ///
					if `touse'
	                }
       		        else {
				local j = `i' - 1
		        	gen `vtyp' `varn' = 		   ///
               	        		max(binormal(`szg',   	   ///
					-`xbv'+        		   ///
					`cut`i'',`sr')		   ///
                        	        - binormal(`szg', 	   ///
					-`xbv'+			   ///
					`cut`j'',`sr'),0)	   ///
					`cs' if `touse'
		        }
		}
		tempname catmat
		matrix `catmat' = e(cat)
		local ival = `catmat'[1,`i']
		if ("`select'" == "") {
			label variable `varn' `"Pr(`depname'=`ival')"'
		}
		else if (`select' == 1 & "`conditional'" == "") {
			if ("`e(eseldep)'" != "") {
				label variable `varn' ///
				`"Pr(`depname'=`ival',`selname'=1)"'
			}
			else {
		               label variable `varn' ///
                               `"Pr(`depname'=`ival',select=1)"'
			}
		}
		else if (`select' == 1 & "`conditional'" != "") {
			if ("`e(eseldep)'" != "") {
				label variable `varn' ///
				`"Pr(`depname'=`ival'|`selname'=1)"'
			}
			else {
		               label variable `varn' ///
                               `"Pr(`depname'=`ival'|select=1)"'
			}

		}
		else if (`select' == 0 & "`conditional'" == "") {
	                if ("`e(eseldep)'" != "") {
				label variable `varn' ///
	                     `"Pr(`depname'=`ival',`selname'=0)"'
			}
			else {
        	                label variable `varn' ///
	                     `"Pr(`depname'=`ival',select=0)"'
			}
		}
		else {
	                if ("`e(eseldep)'" != "") {
				label variable `varn' ///
	                     `"Pr(`depname'=`ival'|`selname'=0)"'
			}
			else {
        	                label variable `varn' ///
	                     `"Pr(`depname'=`ival'|select=0)"'
			}
		}
	}
end

// from ologit_p
program define Eq, sclass
        sret clear
        local out = trim(`"`0'"')
        if bsubstr(`"`out'"',1,1)=="#" {
                local out = bsubstr(`"`out'"',2,.)
                Chk confirm integer number `out'
                Chk assert `out' >= 1
                capture assert `out' <= `e(encat)'
                if _rc {
                        di in red "there is no outcome #`out'" _n /*
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

        di in red `"outcome `out' not found"'
        Chk assert 0 /* return error */
end

program define Chk
        capture `0'
        if _rc {
		local w: word 1 of `e(depvar)'
                di in red "outcome() must either be a value of `w'," /*
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
        di in red "option `option' requires that you specify 1 new variable"
        error cond(`n'==0,102,103)
end


program MultVars
        syntax [newvarlist]
        local nvars : word count `varlist'
        if `nvars' == e(k_eq) {
                exit
        }
        if `nvars' != e(k_cat) {
		local ed: word 1 of `e(depvar)'
                capture noisily error cond(`nvars'<e(k_cat), 102, 103)
                di in red /*
                */ "`ed' has `e(k_cat)' outcomes and so you " /*
                */ "must specify `e(k_cat)' new variables, or " _n /*
                */ "you can use the outcome() option and specify " /*
                */ "variables one at a time"
                exit cond(`nvars'<e(k_cat), 102, 103)
        }
end

program ParseNewVars, sclass
        version 9, missing
        syntax [anything(name=vlist)] [if] [in] [, * ]

        if missing(e(version)) {
                local old oldologit
        }
        _score_spec `vlist', `old'
        sreturn local varspec `vlist'
        sreturn local if        `"`if'"'
        sreturn local in        `"`in'"'
        sreturn local options   `"`options'"'
end



exit
