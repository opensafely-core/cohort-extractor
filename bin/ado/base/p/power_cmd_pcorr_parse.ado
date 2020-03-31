*! version 1.0.0  08dec2016
program power_cmd_pcorr_parse
	version 15

	syntax [anything] [, test * ]
	local type `test'
	_power_pcorr_`test'_parse `anything', `options'

end

program _power_pcorr_test_parse

	syntax [anything(name=args)], pssobj(string) [ * ]

        local 0 , `options'
	mata: st_local("solvefor", `pssobj'.solvefor)

	// check if iteration options are allowed
	local isiteropts 0
	if ("`solvefor'"=="n" | "`solvefor'"=="esize") {
	    	local isiteropts 1
		local star init(string) *
	}
	else if ("`solvefor'"=="power") {
		local msg power
	}

	if (!`isiteropts') {
		_pss_error iteroptsnotallowed ,		///
			   `options' txt(when computing `msg')	
	}

	_pss_syntax SYNOPTS : onetest
	syntax [,       `SYNOPTS'               ///
                        NTESTed(string)         ///
                        NControl(string)        ///
                        `star'                  ///
                ]	
	if ("`onesided'"!="") {
		di as err "{p}option {bf:onesided} not allowed{p_end}"
		exit 198
	}
	if (`"`direction'"' != "") {
                di as err "{p}option {bf:direction()} not allowed{p_end}"
                exit 198
        }
	if (`isiteropts') {
		if "`solvefor'" == "n" {
			local validate `solvefor'
		}
		else if "`solvefor'" == "esize" {
			local validate r2
		}
		_pss_chk_iteropts `validate', `options' init(`init')	///
			pssobj(`pssobj')
		_pss_error optnotallowed `"`s(options)'"'
	}

		gettoken arg1 args : args, match(par)

	local nargs 0

	if `"`arg1'"'!="" {
		local ++nargs
	}
	if `"`args'"'!="" {
		local ++nargs
	}

	_pss_error argsonealttest "`nargs'" "`solvefor'"  ///
				     "pcorr" "squared partial correlation"

	if `"`arg1'"'!="" {
		cap numlist "`arg1'", range(>0 <1)
		if (_rc) {
			di as err "{p}squared partial correlation " ///
			      "must be between 0 and 1{p_end}"	
			exit 198
		}
	}

	// ntested, ncontrol, pcorr
	if (`"`ntested'"'!="") {
		cap numlist "`ntested'", range(>0) integer
		if (_rc) {
		    	di as err "{p}option "	///
				"{bf:ntested()} must contain positive "	///
				" integers{p_end}"
			exit 198
		}
		local nt `r(numlist)'
		local nt_ct : list sizeof nt
	}
	else {
		local nt 1
		local nt_ct 1
	}	
	if (`"`ncontrol'"'!="") {	
		cap numlist "`ncontrol'", range(>0) integer
		if (_rc) {
		    	di as err "{p}option "	///
				"{bf:ncontrol()} must contain positive " ///
				"integers{p_end}"
			exit 198
		}
		local nc `r(numlist)'
		local nc_ct : list sizeof nc
	}
	else {
		local nc_ct 1
		local nc 1
	}		
	
	if ("`init'"!="" & "`solvefor'"=="n" & `nc_ct'==1 & `nt_ct'==1) {
			if (`init' <= `nc' + `nt' + 1 ) {
			di as err "{p}invalid "	///
				"{bf:init(`init')}; initial sampe size " ///
				"too small{p_end}"
				exit 198
		}
	}	
	
	local is_case1  0		
	local pcorr pcorr
	mata: `pssobj'.initonparse(`is_case1', "", "`pcorr'")

end
