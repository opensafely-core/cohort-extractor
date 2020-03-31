*! version 1.4.0  13jan2020
program _mixed_parsecmd, sclass
	version 9
	gettoken cmdname 0 : 0
	gettoken i 0 : 0

	// First we strip off if and in - they have already been processed
	// global weights too
	
	syntax [anything] [if] [in] [pw fw] [, * ]
	local 0 `anything', `options'

	local myopts noConstant COVariance(name) COLlinear 
	if "`cmdname'" == "xtmixed" | "`cmdname'" == "mixed" {
		local myopts `myopts' PWeight(string) FWeight(string)
	}

	gettoken lev rest : 0 , parse(":")

if 0$XTM_ver > 10 {		// As of 10.1, the colon is required
	gettoken colon rest : rest , parse(":")
	if `"`colon'"' == `":"' {
		local lev = trim("`lev'")
		if "`lev'" != "_all" {
			fvunab lev : `lev'
			confirm variable `lev'
		}
		local 0 `"`rest'"'
	    if !inlist("`cmdname'", "mixed", "xtmixed") {
		capture syntax [varlist(ts numeric default=none)] [,*]
		if _rc == 101 {
			di as err "{p 0 6 2}must use R. when specifying "
			di as err "factor variables in random-effects "
			di as err "equations{p_end}"
			exit 198
		}
	    }
	}
	else {
		if (`i' > 0)  {
			di as err "{p 0 6 2}invalid random-effects "
			di as err "specification; perhaps you omitted the "
			di as err "colon after the level "
			di as err "variable{p_end}"
			exit 198
		}
		else	      local lev
	}
}
else {				// old syntax allowing empty level variable
	if `"`lev'"' == `":"' {
		local lev _all
		local 0 `"`rest'"'
	}
	else {
		gettoken colon rest : rest , parse(":")
		if `"`colon'"' == `":"' {
			if (`"`lev'"' == `"."') {
				local lev _all
			}
			else if "`lev'" != "_all" {
				fvunab lev : `lev'
				confirm variable `lev'
			}
			local 0 `"`rest'"'
		}
		else {
			if (`i' > 0)  local lev _all
			else	      local lev
		}
	}
}

	capture syntax [varlist(ts fv numeric default=none)]		///
		       [ , `myopts' ]
	local fvops `"`s(fvops)'"'

	if _rc {						// r.varname...
	    if `i' > 0 {
		ChkNonNumeric `"`myopts'"' `0'

		syntax [anything] [ , `myopts' ]

		if 0`:list sizeof anything' != 1 {
		    di as error `"`anything' invalid level specification"'
		    exit 198
		}

		local anything0 `"`anything'"'
		local anything : subinstr local anything "*" " " , all
		if 0`:list sizeof anything' == 1 {		// r.varname
		    tokenize `"`anything'"' , parse(".")
		    if `"`=upper(`"`1'"')'"' != `"R"' | `"`4'"' != `""' {
			di as error `"`anything0' invalid random factor"'
			exit 198
		    }
		    confirm variable `3'
		    local varlist `3'
		}
		else {						// r.v1*r.v2...
		    gettoken fvar anything : anything
		    while "`fvar'" != "" {
			tokenize `"`fvar'"' , parse(".")
			if `"`=upper(`"`1'"')'"' != `"R"' | `"`4'"' != `""' {
			    di as error `"`anything0' invalid random factor"'
			    exit 198
			}
			confirm variable `3'
			local varlist "`varlist' `3'"

			gettoken fvar anything : anything
			local anything `anything'		// sic
		    }
		}
		fvunab varlist : `varlist'
	    }
	    else {
	    	syntax [varlist(ts fv numeric default=none)]		///
		       [ , `myopts' ]
	    }

	    local  isfctr 1
	}
	else local isfctr 0

	ParseCov cov : `isfctr' , `covariance'

	if !0`isfctr' & "`cov'" != "identity" & "`fvops'"=="" &		///
	     `:list sizeof varlist' + ("`constant'"=="") == 1 {
	    if `"`covariance'"' != `""' {
		if "`lev'"!="" {
		    local name "in {inp:`lev'} equation"
		}
		local msg di as text "{p 0 6} Note: single-variable random-"
		local msg `msg' "effects specification `name'; covariance "
		local msg `msg' "structure set to {inp:identity}{p_end}"		
		sreturn local msg `msg'
	    }
	    local cov identity
	}

	if `i' == 0  {					// parsing fixed level
	    if `"`lev'"' != "" {
		di as err "{p 0 4 2}level specification not allowed "
		di as err "for fixed equation{p_end}"
		exit 198
	    }
	    gettoken depname varlist : varlist
	    c_local depname `depname'
	    _fv_check_depvar `depname'

	    local cov identity

	    if "`covariance'" != "" {
		di as error						///
		"option covariance() not allowed with fixed-effects equation"
		exit 198
	    }
	    if "`collinear'" != "" {
	    	di as error						///
		"option collinear not allowed with fixed-effects equation"
		exit 198
	    }
	    if `"`pweight'"' != "" {
	    	di as error						///
		"option pweight() not allowed with fixed-effects equation"
		exit 198
	    }
	    if `"`fweight'"' != "" {
	    	di as error						///
		"option fweight() not allowed with fixed-effects equation"
		exit 198
	    }

	}

	tempvar x
        if `"`pweight'"' != "" {
	    capture gen double `x' = `pweight' 
	    if _rc {
		di as err "invalid expression in pweight()"
		exit 111
	    }
	    capture assert `x' > 0
	    if _rc {
	    	di as err "pweights must be positive"
		exit 111
	    }
	}
        if `"`fweight'"' != "" {
	    capture drop `x'
	    capture gen double `x' = `fweight' 
	    if _rc {
		di as err "invalid expression in fweight()"
		exit 111
	    }
	    capture assert `x' == int(`x')
	    if _rc {
	    	di as err "fweights must be integer-valued"
		exit 111
	    }
	    capture assert `x' > 0
	    if _rc {
	    	di as err "fweights must be positive"
		exit 111
	    }
	}

	c_local levnm_`i' `lev'
	c_local cov_`i'      `cov'
	c_local isfctr_`i'   `isfctr'
	c_local constant_`i' = cond(`isfctr', "noconstant", "`constant'")
	c_local collin_`i' "`collinear'"
	c_local varnames_`i'  `varlist'
	c_local pweight_`i' `"`pweight'"'
	c_local fweight_`i' `"`fweight'"'
end

program ParseCov
	gettoken lmac   0 : 0
	gettoken colon  0 : 0
	gettoken isfctr 0 : 0


	syntax [ , INDependent EXchangeable IDentity UNstructured * ]

	if `"`options'"' != "" {
		di as error `"`options' invalid covariance structure"'
		exit 198
	}

	local res `independent' `exchangeable' `identity' `unstructured'

	if 0`isfctr' & "`independent'`unstructured'" != "" {
	di as error							///
"`independent'`unstructured' covariance structure not allowed for factor variables"
		exit 198
	}

	if ("`res'" == "") {
		if (0`isfctr')	local res "identity"
		else		local res "independent"
	}

	c_local `lmac' `res'
end

program ChkNonNumeric
	gettoken myopts 0 : 0

	local 0 : subinstr local 0 "R." "" ,  all count(local ct)
	if (`ct' > 0)  exit					// Exit

	local 0 : subinstr local 0 "r." "" ,  all count(local ct)
	if (`ct' > 0)  exit					// Exit

	capture syntax [varlist(ts numeric default=none)] [if] [in] [, *]
	if _rc {
		di as err "invalid syntax"
		exit 198
	}

	syntax [varlist(ts numeric default=none)] [if] [in] [ , `myopts' ]

end

exit
