*! version 1.2.0  19mar2019
program define churdle, eclass byable(onecall) properties(svyb svyj svyr)
	version 14

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
        }
	
        `BY' _vce_parserun churdle, noeqlist jkopts(eclass): `0'
        
	if "`s(exit)'" != "" {
                ereturn local cmdline `"churdle `0'"'
                exit
        }

        if replay() {
		if `"`e(cmd)'"' != "churdle" { 
                        error 301
                }
                else if _by() { 
                        error 190 
                }
                else {
                        Display `0'
                }
                exit
        }
        `vv' ///
        `BY' Estimate `0'
        ereturn local cmdline `"churdle `0'"'
	
end

program define Estimate, eclass byable(recall)
        
	local estimator : word 1 of `0'
	local 0 : subinstr local 0 "`estimator'" ""
	CheckEstimator `estimator'
	local estimator `=s(estimator)'

	syntax varlist(numeric fv) [if] [in]                                 ///
			[fweight pweight iweight],                           ///
			SELect(string)				             ///
			[ 		                                     ///
			het(string)	                                     ///
			noCONstant                                           ///
			CONSTraints(string)			             ///
			vce(string)				             ///
			Level(cilevel)				             ///
			NOLOg LOg					     ///
			TRace                                                ///
			GRADient                                             ///
			showstep                                             ///
			HESSian                                              ///
			SHOWTOLerance                                        ///
			TOLerance(real 1e-6)                                 ///
			LTOLerance(real 1e-7)                                ///
			NRTOLerance(real 1e-5)                               ///
			TECHnique(string)                                    ///
			ITERate(integer 16000)                               ///
			NONRTOLerance                                        ///
			from(string)                                         ///
			DIFficult                                            ///
			UL(string)                                           ///
			LL(string)                                           ///
			churdlesvy					     ///
			moptobj(string)					     /// not documented
			*				                     ///
			]


	// Getting options and invalid display options
	
	_get_diopts diopts other, `options'
	qui cap Display, `diopts' `other'
	
	if _rc==198 {
		Display, `diopts' `other'
	}

	// Getting Started
			
	marksample touse
	tempvar N

	qui count if `touse'
	local N = r(N) 

	///// Get y, x, selection vars, and weight, constant, ul, and ll //////

	gettoken yvar varlist: varlist 

	tempvar n y

	_fv_check_depvar `yvar'

	// To treat exponential as an option keeping with the old code 

	if "`estimator'"=="exponential" {
		local exponential something
	}
	else {
		local exponential = ""
	}

	if "`weight'" != "" {
		local wgt [`weight' `exp']
	}

	local wtype "`weight'"
	local wexp  "`exp'"
	
	gettoken peso pesos: exp            // weights for optimize
	fvexpand `varlist' if `touse'

	local varlist = r(varlist)

	if "`constant'" == "" {
		local noconsm = 0
	}
	else {
		local noconsm = 1
	}
	
	if ("`varlist'"=="." & `noconsm'==1) {
		display as error "too few variables specified"
		exit 102
	}

	// Parsing upper and lower bounds 

	local llim  = real("`ll'")
	local ulim  = real("`ul'")
	local sllim = "`ll'"
	local sulim = "`ul'"
	local strll = 0
	local strul = 0
	local isnll = 0
	local isnul = 0


	if (`llim' == . & `"`sllim'"' != "") {
		cap fvexpand `sllim' if `touse'
		local rc = _rc
		
		if `rc' {
			display as error "when specifying {bf:ll()}"
			fvexpand `sllim' if `touse'
		}
		
		local strll = 1
	}

	if (`ulim' == . & `"`sulim'"' != "") {
		cap fvexpand `sulim' if `touse'
		local rc = _rc
		
		if `rc' {
			display as error "when specifying {bf:ul()}"
			fvexpand `sulim' if `touse'
		}

		local strul = 1
	}


	if (`llim'==. & `ulim' == . & "`exponential'" =="" & 		     ///
	    `"`sllim'"' == "" & `"`sulim'"' == "") {
		display as error "must specify at least one of {bf:ll()}"    ///
		    " or {bf:ul()}"
		exit 198
	}

	if ("`ul'" == "" & "`ll'" == "" & "`exponential'" ==""){
		display as error "must specify at least one of {bf:ll()} "   ///
		    "or {bf:ul()}"
		exit 198
	}

	if ("`ll'" == "" & "`exponential'" !=""){
		display as error "must specify {bf:ll()} with"               ///
		    " {bf:churdle exponential}"
		exit 198
	}

	if "`ul'" != "" & "`exponential'" !="" {
		display as error 					     ///
		"{bf:ul()} inconsistent with {bf:churdle exponential}"
		exit 198
	}


	if ("`ul'" == "" & "`ll'" != "") {
		if (`llim' == . & `strll' == 0) {
			display as error "invalid {bf:ll()}"
			exit 198
		}
		
		local bound   = 1
		
		if `strll'==0 {
			local isnll   = 1
		}
	}

	if ("`ul'" != "" & "`ll'" == "") {
		if (`ulim' == . & `strul'==0 ) {
			display as error "invalid {bf:ul()}"
			exit 198
		}
		
		local bound   = 2
		
		if `strul'==0 {
			local isnul   = 1
		}
	}

	if ("`ul'" != "" & "`ll'" != "") {
		local bound   = 3
		
		if (`ulim' == . & `strul'==0) {
			display as error "invalid {bf:ul()}"
			exit 198
		}
		
		if (`llim' == . & `strll' == 0) {
			display as error "invalid {bf:ll()}"
			exit 198
		}
		
		if ((`llim' >= `ulim') & `strul'==0 & `strll'==0 ) {
			display as error "{bf:ul()} must be greater" ///
			" than {bf:ll()}"
			exit 198
		}
		
		if `strul'==0 {
			local isnul   = 1
		}
		
		if `strll'==0 {
			local isnll   = 1
		}
		
	}

	if "`exponential'" !="" {
		local bound = 1
	}
 
	Selects `select'
	local svars = "`s(vars)'"
	local scons = "`s(cons)'"
	local shet  = "`s(het)'"
	local sfrom = `"`s(from)'"' 

	if "`scons'" == "" {
		local sconsm = 0
	}
	else {
		local sconsm = 1
	}

	qui fvexpand `svars'
	local fvom = r(fvops)
	qui _rmcoll `svars' `wgt', `scons'
	local svars1 = r(varlist)
	local rkomits = r(k_omitted)
	fvexpand `svars1' if `touse'
	local svars1 = r(varlist)
	counting_omits, variables(`svars1')
	local comits = r(comits)
	if (`rkomits' > 0 & `comits'>0){
		display as text _newline "for {bf:select()}"
		_rmcoll `svars' `wgt', `scons'
		local scols = r(varlist)
	}
	else {
		local scols = "`svars1'"
	}

	if "`varlist'"!="." {
		qui fvexpand `varlist'
		local fvom = r(fvops)
		qui _rmcoll `varlist' `wgt', `constant'
		local xvars = r(varlist)
		local rkomits = r(k_omitted)
		fvexpand `xvars' if `touse'
		local xvars = r(varlist)
		counting_omits, variables(`xvars')
		local comits = r(comits)
		if (`rkomits' > 0 & `comits'>0){
			display as text _newline "for {bf:`yvar'}"	
			_rmcoll `varlist' `wgt', `constant'
			local xvars = r(varlist)
			fvexpand `xvars' if `touse'
			local xvars = r(varlist)
		}
	}


	/* Getting the parameter estimates for the selection variable into Mata.
	Also, here I am using what is already in probit and   hetprobit to detect
	potential problems with the specification of the selection model*/

	tempvar   selection_ll selection_ul
	tempname  gamma vg vgl vgu CST CSTu CSTl gammal gammau mgammal       ///
		      mgammau vcemu vceml mgamma

	local cs1 = 0
	local csb = 0 

	local nvce: list sizeof vce

	preserve 

	if "`shet'" == "" {
		cap drop selection_ll 
		cap drop selection_ul		
		if `bound' == 1 {
			qui generate byte selection_ll =                     /// 
			    (`yvar'> float(`ll'))  
		}

		if `bound' == 2 {
			qui generate byte selection_ul =                     /// 
			    1 - (`yvar'<float(`ul'))  
		}

		if `bound' == 3 {
			qui generate byte selection_ll =                     /// 
			    (`yvar'>float(`ll'))  
			qui generate byte selection_ul =                     /// 
			    1 - (`yvar'<float(`ul'))  
		}

		local svars "`svars1'"
		
		if `bound' == 1 {		
			if `strll' == 1 {
                                local PROBIT    probit          ///
                                                selection_ll    ///
                                                `svars'         ///
                                                `ll'            ///
                                                `wgt'           ///
                                                if `touse',     ///
                                                `scons'
                        }
			else {
                                local PROBIT    probit          ///
                                                selection_ll    ///
                                                `svars'         ///
                                                `wgt'           ///
                                                if `touse',     ///
                                                `scons'
                        }
                        capture `PROBIT'
                        if (_rc == 430) {
                                error 430
                        }
                        if (_rc == 2000) {
                                sum selection_ll, meanonly
                                if r(min) == r(max) {
                                        di as err ///
                                        "for {bf:select()} and {bf:ll()}," ///
					" selection outcome does not vary"
                                        exit 2000
                                }
                                // [sic] should not be possible
                                di as err "invalid selection model;"
                                error 2000
                        }
                        if (_rc!=0) {
                                di as err "for {bf:select()} and {bf:ll()},"
                                `PROBIT'
                                exit _rc
                        }
                }

		if `bound' == 2 {
			if `strul' == 1 {		
				local PROBIT 	probit		///
						selection_ul 	///
						`svars'		///
						`ul'		///
						`wgt'		///
						 if `touse',	///
						 `scons' 
			}
			else {		
				local PROBIT 	probit		///
						selection_ul 	///
						`svars'		///
						`wgt'		///
						 if `touse',	///
						 `scons' 
			}			
                        capture `PROBIT'
                        if (_rc == 430) {
                                error 430
                        }
                        if (_rc == 2000) {
                                sum selection_ul, meanonly
                                if r(min) == r(max) {
                                        di as err ///
                                        "for {bf:select()} and {bf:ul()}," ///
					" selection outcome does not vary"
                                        exit 2000
                                }
                                // [sic] should not be possible
                                di as err "invalid selection model;"
                                error 2000
                        }
                        if (_rc!=0) {
                                di as err "for {bf:select()} and {bf:ul()},"
                                `PROBIT'
                                exit _rc
                        }
                }

		if `bound' == 3 {	
			if `strul' == 1 {		
				local PROBIT 	probit		///
						selection_ul 	///
						`svars'		///
						`ul'		///
						`wgt'		///
						 if `touse',	///
						 `scons' 
			}
			else {		
				local PROBIT 	probit		///
						selection_ul 	///
						`svars'		///
						`wgt'		///
						 if `touse',	///
						 `scons' 
			}			
                        capture `PROBIT'
                        if (_rc == 430) {
                                error 430
                        }
                        if (_rc == 2000) {
                                sum selection_ul, meanonly
                                if r(min) == r(max) {
                                        di as err ///
                                        "for {bf:select()} and {bf:ul()}," ///
					" selection outcome does not vary"
                                        exit 2000
                                }
                                // [sic] should not be possible
                                di as err "invalid selection model;"
                                error 2000
                        }
                        if (_rc!=0) {
                                di as err "for {bf:select()} and {bf:ul()},"
                                `PROBIT'
                                exit _rc
                        }

			matrix `gammau'  = e(b)
			local csku       = e(k)
			matrix `mgammau' = `gammau'
			
			if `strll' == 1 {
                                local PROBIT    probit          ///
                                                selection_ll    ///
                                                `svars'         ///
                                                `ll'            ///
                                                `wgt'           ///
                                                if `touse',     ///
                                                `scons'
                        }
			else {
                                local PROBIT    probit          ///
                                                selection_ll    ///
                                                `svars'         ///
                                                `wgt'           ///
                                                if `touse',     ///
                                                `scons'
                        }
                        capture `PROBIT'
                        if (_rc == 430) {
                                error 430
                        }
                        if (_rc == 2000) {
                                sum selection_ll, meanonly
                                if r(min) == r(max) {
                                        di as err ///
                                        "for {bf:select()} and {bf:ll()}," ///
					" selection outcome does not vary"
                                        exit 2000
                                }
                                // [sic] should not be possible
                                di as err "invalid selection model;"
                                error 2000
                        }
                        if (_rc!=0) {
                                di as err "for {bf:select()} and {bf:ll()},"
                                `PROBIT'
                                exit _rc
                        }

			matrix `gammal'  = e(b)
			local cskl       = e(k)
			matrix `mgammal' = `gammal'
			matrix  `mgamma' = (`mgammal', `mgammau')						
		}
	}
	else {
		cap drop selection_ll 
		cap drop selection_ul
		if `bound' == 1 {
			qui generate byte selection_ll = (`yvar'>float(`ll'))  
		}

		if `bound' == 2 {
			qui generate byte selection_ul = 1 -(`yvar'<float(`ul'))  
		}

		if `bound' == 3 {
			qui generate byte selection_ll = (`yvar'>float(`ll'))  
			qui generate byte selection_ul = 1 -(`yvar'<float(`ul'))  
		}

		local svars "`svars1'"
		
		qui _rmcoll `shet' `wgt'
		local shetdos = r(varlist)
		local rkomits = r(k_omitted)
		fvexpand `shetdos' if `touse'
		local shetdos = r(varlist)
		counting_omits, variables(`shetdos')
		local comits = r(comits)
		
		if (`rkomits' > 0 & `comits'>0) {
			display as text _newline "for {bf:sel( , het())},"
			_rmcoll `shet' `wgt'
			local shet = r(varlist)
			fvexpand `shet' if `touse'
			local shetvars = r(varlist)
		}
		else {
			local shetvars "`shetdos'"
		}
		
		if `bound' == 1 {
			if `strll' == 1 {
				local HETPROB	hetprobit	///
						selection_ll	///
						`svars'		///
						`ll'		///
						`wgt'		///
						if `touse',	///
						`scons'		///
						het(`shetvars')	///
						iterate(100)
			}
			else {
				local HETPROB	hetprobit	///
						selection_ll	///
						`svars'		///
						`wgt'		///
						if `touse',	///
						`scons'		///
						het(`shetvars')	///
						iterate(100)
			}
			capture `HETPROB'
			if (_rc == 430) {
                                error 430
                        }
                        capture `HETPROB'
                        if (_rc == 430) {
                                error 430
                        }
                        if (_rc == 2000) {
                                sum selection_ll, meanonly
                                if r(min) == r(max) {
                                        di as err
                                        "selection outcome does not vary"
                                        exit 2000
                                }
                                // [sic] should not be possible
                                di as err "invalid selection model;"
                                error 2000
                        }
                        if (_rc!=0) {
                                di as err "for {bf:select()} and {bf:ll()},"
                                `HETPROB'
                                exit _rc
                        }

		}
		if `bound' == 2 {
			if `strul' == 1 {
				local HETPROB	hetprobit	///
						selection_ul	///
						`svars'		///
						`ll'		///
						`wgt'		///
						if `touse',	///
						`scons'		///
						het(`shetvars')	///
						iterate(100)
			}
			else {
				local HETPROB	hetprobit	///
						selection_ul	///
						`svars'		///
						`wgt'		///
						if `touse',	///
						`scons'		///
						het(`shetvars')	///
						iterate(100)
			}
			capture `HETPROB'
			if (_rc == 430) {
                                error 430
                        }
                        capture `HETPROB'
                        if (_rc == 430) {
                                error 430
                        }
                        if (_rc == 2000) {
                                sum selection_ul, meanonly
                                if r(min) == r(max) {
                                        di as err
                                        "selection outcome does not vary"
                                        exit 2000
                                }
                                // [sic] should not be possible
                                di as err "invalid selection model;"
                                error 2000
                        }
                        if (_rc!=0) {
                                di as err "for {bf:select()} and {bf:ul()},"
                                `HETPROB'
                                exit _rc
                        }
		}

		if `bound' == 3 {
			if `strul' == 1 {
				local HETPROB	hetprobit	///
						selection_ul	///
						`svars'		///
						`ll'		///
						`wgt'		///
						if `touse',	///
						`scons'		///
						het(`shetvars')	///
						iterate(100)
			}
			else {
				local HETPROB	hetprobit	///
						selection_ul	///
						`svars'		///
						`wgt'		///
						if `touse',	///
						`scons'		///
						het(`shetvars')	///
						iterate(100)
			}
			capture `HETPROB'
			if (_rc == 430) {
                                error 430
                        }
                        capture `HETPROB'
                        if (_rc == 430) {
                                error 430
                        }
                        if (_rc == 2000) {
                                sum selection_ul, meanonly
                                if r(min) == r(max) {
                                        di as err
                                        "selection outcome does not vary"
                                        exit 2000
                                }
                                // [sic] should not be possible
                                di as err "invalid selection model;"
                                error 2000
                        }
                        if (_rc!=0) {
                                di as err "for {bf:select()} and {bf:ul()},"
                                `HETPROB'
                                exit _rc
                        }

			matrix `gammau'  = e(b)
			local csku       = e(k)
			matrix `mgammau' = `gammau'
			
			if `strll' == 1 {
				local HETPROB	hetprobit	///
						selection_ll	///
						`svars'		///
						`ll'		///
						`wgt'		///
						if `touse',	///
						`scons'		///
						het(`shetvars')	///
						iterate(100)
			}
			else {
				local HETPROB	hetprobit	///
						selection_ll	///
						`svars'		///
						`wgt'		///
						if `touse',	///
						`scons'		///
						het(`shetvars')	///
						iterate(100)
			}
			capture `HETPROB'
			if (_rc == 430) {
                                error 430
                        }
                        capture `HETPROB'
                        if (_rc == 430) {
                                error 430
                        }
                        if (_rc == 2000) {
                                sum selection_ll, meanonly
                                if r(min) == r(max) {
                                        di as err
                                        "selection outcome does not vary"
                                        exit 2000
                                }
                                // [sic] should not be possible
                                di as err "invalid selection model;"
                                error 2000
                        }
                        if (_rc!=0) {
                                di as err "for {bf:select()} and {bf:ll()},"
                                `HETPROB'
                                exit _rc
                        }

			matrix `gammal'  = e(b)
			local cskl       = e(k)
			matrix `mgammal' = `gammal'
			matrix `mgamma'  = (`mgammal', `mgammau')
		}
	}

	restore

	if `bound' == 1 {
		qui generate byte `selection_ll' = (`yvar'>float(`ll')) 
		matrix `gamma'  = e(b)
		local csk       = e(k)
		matrix `mgamma' = `gamma'
	}

	if `bound' == 2 {
		qui generate byte `selection_ul' = 1 - (`yvar'<float(`ul'))  
		matrix `gamma'  = e(b)
		local  csk      = e(k)
		matrix `mgamma' = `gamma'
	}

	if `bound' == 3 {
		qui generate byte `selection_ll' = (`yvar'>float(`ll'))  
		qui generate byte `selection_ul' = 1 - (`yvar'<float(`ul'))  
		local csk = `cskl' + `csku'
	}

	////////////// Parsing options used for optimization //////////////////


// 1. Linear, exponential, or heteroskedastic 


	if "`exponential'" !="" {
		local model = 1
		local modelo Exponential
	}
	else {
		local model = 2
		local modelo Linear
	}

	local zeta = 0 

	if "`het'" !="" {
		Selects `het'
		local zvars = "`s(vars)'"
			
		qui _rmcoll `zvars' `wgt'
		local zvars2 = r(varlist)
		local rkomits = r(k_omitted)
		fvexpand `zvars2' if `touse'
		local zvars2 = r(varlist)
		counting_omits, variables(`zvars2')
		local comits = r(comits)
		
		if (`rkomits' > 0 & `comits'>0) {
			display as text _newline                             ///
			    "for {bf:het()}"
			_rmcoll `zvars' `wgt'
			local zvars "`zvars2'"
			local zeta: list sizeof zvars
		}
		else {
			local zvars "`zvars2'"
			local zeta: list sizeof zvars
		}
	}

	if (`model'>1 & `zeta'>0) {
		local model = 3
		local modelo Linear
	}

	if (`model'==1 & `zeta'>0) {
		local model = 4
		local modelo Exponential
	}

	if (`model'==1 & "`shet'"!="") {
		local model = 5
		local modelo Exponential
	}

	if (`model'==2 & "`shet'"!="") {
		local model = 6
		local modelo Linear
	}
	if (`model'==3 & "`shet'"!="") {
		local model = 7
		local modelo Linear
	}
	if (`model'==4 & "`shet'"!="") {
		local model = 8
		local modelo Exponential
	}


// 2. Iterate
		
	if  `iterate' < 0 {
		display as error "{bf:iterate()} must be a nonnegative integer"
		exit 125
	}


// 3. Tolerance, ltolerance, nrtolerance
		
	if `nrtolerance' < 0 {
		display as error "{bf:nrtolerance()} should be nonnegative"
		exit 125
	}
	  
	if `tolerance' < 0 {
		display as error "{bf:tolerance()} should be nonnegative"
		exit 125
	} 
	
	if `ltolerance' < 0 {
		display as error "{bf:ltolerance()} should be nonnegative"
		exit 125
	} 

//  4. Tracelevel options
		

	if "`showstep'" != "" {
		local step = 1
	}
	else {
		local step = 0
	}

	if "`gradient'" != "" {
		local grad = 1
	}
	else {
		local grad = 0
	}

	if "`hessian'" != "" {
		local hess = 1
	}
	else {
		local hess = 0
	}

	if "`trace'" != "" {
		local trace = 1
	}
	else {
		local trace = 0
	}

	if "`showtolerance'" != "" {
		local showtol = "on"
	}
	else {
		local showtol = "off"
	}
	if "`nonrtolerance'" != "" {
		local  nonrtol = "on"
	}
	else {
		local  nonrtol = "off"
	}

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" != "" {
		local  nolog = 1
	}
	else {
		local  nolog = 0
	}


//  5. Technique
		
	if "`technique'" == "" {
		local technique = "nr"
	}

	local techs nr dfp bfgs bhhh
	local check: list techs & technique

	if "`check'" == "" {		
		local tecnicas = "nr, dfp, bfgs, or, bhhh"
		display as error "{bf:technique()} `technique'"              ///
		    " not found; only one of `tecnicas' is allowed"
		exit 111
	}

//  6. Difficult

	if "`difficult'" != "" {
		local difficult = "hybrid"
	}
	else {
		local difficult = "m-marquardt"
	}

//  7. From and initial values

	tempname beta theta strp thetafrom
	tempvar resid err 
	
	local sx: list sizeof xvars 
	local sk    = `sx' + abs(`noconsm' -1) + 1 

	fvexpand `scols' if `touse'
	local scols = r(varlist)

	if ((`model' == 1 | `model' == 5) & `"`from'"' == "") {
		tempvar yzip 
		
		if `strll' == 0 {
			generate double `yzip' = max(`yvar' - `ll', 0)
		}
		else {
			generate double `yzip' = `yvar'
		}
		
		qui cap zip `yzip' `xvars' `wgt', inf(`scols') `constant'    ///
		    iterate(40)
		
		local rc = _rc
		
		if `rc' == 459 {
			display as error "dependent variable has negative "  ///
			    "values" 
			exit 459
		}
		
		if `rc' {
			display as error "could not obtain initial values"
			exit 480
		}
		
		display _skip(1)
		matrix `beta'   = e(b) 
		matrix `beta'   = `beta'[1, 1..`sk'-1]
		matrix `theta'  = (`beta', 1)
		local modelo Exponential
	}

	if ((`model' == 2 | `model' == 6) & `"`from'"' == ""){
		qui truncreg `yvar' `xvars' `wgt', `constant' ul(`ul')       ///
		    ll(`ll') iterate(0)
		
		display _skip(1)
		matrix `beta'  = e(b) 
		matrix `theta' = `beta'
		local modelo Linear
	}


	if ((`model' == 3 | `model' == 7) & `"`from'"' == "") {		
		qui truncreg `yvar' `xvars' `wgt', `constant' ul(`ul')       ///
		    ll(`ll') iterate(0)
		display _skip(1)
		
		matrix `beta'       = e(b)
		qui predict double `resid', residuals
		qui replace `resid' = ln(sqrt(`resid'*`resid'))
		qui reg `resid' `zvars', noconstant
		matrix `err'        = e(b)
		matrix `theta'      = (`beta'[1,1..`sk'-1], `err')
		local modelo Linear
	}

	if ((`model' == 4 | `model' == 8) & `"`from'"' == "") {
		tempvar resid err yzip
		if `strll' == 0 {
			generate double `yzip' = max(`yvar' - `ll', 0)
		}
		else {
			generate double `yzip' = `yvar'
		}
		
		qui cap zip `yzip' `xvars' `wgt', inf(`scols') `constant'    ///
		    iterate(100)
		    
		local rc = _rc
		
		if `rc' == 459 {
			display as error                                     ///
			    "dependent variable has negative values" 
			exit 459
		}
		
		if `rc' {
			display as error "could not obtain initial values"
			exit 480
		}
		
		display _skip(1)
		matrix `beta'       = e(b)
		matrix `beta'       = `beta'[1, 1..`sk'-1]
		qui predict double `resid', stdp
		qui replace `resid' = (sqrt(`resid'*`resid'))
		qui reg `resid' `zvars', noconstant
		matrix `err'        = e(b)
		matrix `theta'      = (`beta', `err')
		local modelo Exponential
	}
	
	// Getting ll_0
 
	tempname lltheta llbeta llsig llgammal llgammaul
	
	if "`exponential'" !="" {
	
		if `"`from'"' != "" {
			tempvar yzip 
			
			if `strll' == 0 {
				generate double `yzip' = `yvar' - `ll'
			}
			else {
				generate double `yzip' = `yvar'
			}
		}
		
		qui poisson `yzip'
		matrix `llbeta'    = e(b)
		matrix `llbeta'    = `llbeta'[1,1]
		qui probit `selection_ll' `wgt' if `touse'
		matrix `llgammal'  =  e(b)
		matrix  `llgammaul' = 0   
		matrix `lltheta'   = (`llbeta', 1)
		local llmodel      = 1
	}
	else {
		if `bound'==1{
			qui truncreg `yvar' `wgt', ul(`ul') ll(`ll') iterate(0)
			matrix `llbeta'    = e(b)
			matrix `llbeta'    = `llbeta'[1,1]
			qui probit `selection_ll' `wgt' if `touse'
			matrix `llgammal'  =  e(b) 
			matrix `llgammaul' = 0   
			matrix `lltheta'   = (`llbeta', 1)
		}
		if `bound'==2{
			qui truncreg `yvar' `wgt', ul(`ul') ll(`ll') iterate(0)
			matrix `llbeta'    = e(b)
			matrix `llbeta'    = `llbeta'[1,1]
			qui probit `selection_ul' `wgt' if `touse'
			matrix `llgammaul' =  e(b) 
			matrix `llgammal'  = 0  
			matrix `lltheta'   = (`llbeta', 1)
		}
		if `bound'==3{
			qui truncreg `yvar' `wgt', ul(`ul') ll(`ll') iterate(10)
			matrix `llbeta'   = e(b)
			matrix `llbeta'    = `llbeta'[1,1]
			qui probit `selection_ul' `wgt' if `touse'
			matrix `llgammaul'=  e(b)
			qui probit `selection_ll' `wgt' if `touse'
			matrix `llgammal' =  e(b)
			matrix `lltheta'   = (`llbeta', 1)	
		}
		
		local llmodel = 2
	}
	
	tempname loglike0
	local svynum =0
	if ("`c(prefix)'"=="svy" & "`churdlesvy'"=="") {
		local svynum = 1 
	}

	cap qui mata: _CHURDLE_ll0(`llmodel', "`lltheta'","`llgammal'",    ///
		"`llgammaul'", "`yvar'", "`touse'", "`pesos'", "`weight'", ///
		`bound', "`ul'", "`ll'", `strll', `strul', "`loglike0'",   ///
		`svynum')

	local rc = _rc

	if `rc' {
		local loglike0 = .
	}
	//////////////////////// Parsing vce options ///////////////////////////

	if `nvce' == 0 {
		local var = 1
		local clust = ""
		local tvce oim
	}
	
	if ("`vce'"=="oim") {
		local nvce = 0
		local var = 1
		local clust = ""
	}

	if (`nvce' == 1) {
		cap qui Variance , `vce'
		
		if _rc!=0 { 		
			display as error "invalid {bf:vce()} option"
			exit _rc
		}
		
		local var  = r(var)
		local clust = ""
		local tvce robust
		local type Robust
	}

	if `nvce' == 2 {		
		local cluster: word 1 of `vce'
		local clustervar: word 2 of `vce'
		tempvar cuentasclust 
		Clusters `clustervar', `cluster'
		local clust  = e(clustervar)
		local clust2 =  e(clustervar)
		capture local sclust = string(`clust')
		if _rc!=0 {
			tempvar clust 
			encode `clustervar', generate(`clust')
		}
		quietly egen `cuentasclust' = group(`clustervar')
		quietly sum `cuentasclust' if `touse'
		local cuentasclusts = r(max)
		local var = e(var)
		local tvce cluster
		local type Robust
	}

	if  ("`weight'" == "pweight") {
		local var   = 2
		local clust = ""
		local tvce robust
		local type Robust
	}
	
	////////////////////// Estimation and Table Elements ///////////////////


	tempname b V parm v1 v2 mgammaf mgammalf mgammauf converge vm1	///
	    vm2 V_modelbased loglike gammast gammastl gammastu rknum	///
	    iterlog kmod kmod0 

	_new_wi, variables(`xvars')
	local newwi = r(cuenta)
	local wi : list sizeof xvars
	local si : list sizeof scols
	local shi: list sizeof shetvars

	// Generating Equation Stripes 

	local shvgm = 0

	if `model'> 4 {
		local shvgm = 1
	}

	tempname mgammaf1 mgammalf1 mgammauf1 theta2 mgammaff
	
	if `"`from'"' != "" {
		tempname theta 
	
		_mkvec `thetafrom', from(`from') error("from()")
		local dfrom = s(k)
		local sx: list sizeof xvars 
		
		if (`zeta'== 0) {
			local sk    = `sx' + `zeta' + abs(`noconsm' -1) + 1 
		}
		else{
			local sk    = `sx' + `zeta' + abs(`noconsm' -1) 
		}
		
		local skf = `sk' + `csk'
		
		if `skf' != `dfrom' {
			di as smcl as err "{bf:from()} dimensions incorrect"
			di as smcl as txt "{p 4 4 2}"
			di as smcl as err "The dimension of the regressors and"     
			di as smcl as err "variance parameters of the latent" 
			di as smcl as err "variable model"
			di as smcl as err "and the selection model should be"
			di as smcl as err "`skf' not `dfrom'."
			di as smcl as err "{p_end}"
			exit 121
		}
		
		local  colstheta = colsof(`thetafrom')

		if `bound'==1 {
			matrix `mgammaff'  = `thetafrom'[1, `sk'+1..`colstheta']
			matrix `mgammalf' = `mgammaff'	
			matrix `mgammauf' = 0
		}
		
		if `bound'==2 {
			matrix `mgammaff'  = `thetafrom'[1, `sk'+1..`colstheta']
			matrix `mgammalf' = 0	
			matrix `mgammauf' = `mgammaff'
		}
		
		if `bound'== 3 {
			matrix `mgammalf' = `thetafrom'[1, `sk'+1..`sk'+`cskl']
			matrix `mgammauf' =                                 ///
			    `thetafrom'[1, `sk'+`cskl'+1..`colstheta']
			matrix `mgammaff'  = (`mgammalf', `mgammauf')			
		}

		mata: _CHURDLE_newstripes2("`theta2'", "`mgammalf1'",        ///
		    "`mgammauf1'", "`mgammaf1'", `sk', `zeta', `csk', `shi', ///
		    "`thetafrom'", `bound', `model')

		matrix `theta'    = `theta2'
		matrix `mgammaf'  = `mgammaf1'
		matrix `mgammalf' = `mgammalf1'
		matrix `mgammauf' = `mgammauf1'
	}	
	else {
		if (`bound' == 1 & `strll'==0) {			
			mata:_CHURDLE_ctobit(`sconsm', `si', `cs1', `ll', 0, ///
			    "`mgamma'", "`mgammalf1'")		    
			matrix `mgammalf' = `mgammalf1'
		}

		if (`bound' == 1 & `strll'==1) {
			mata: _CHURDLE_vargamma(`sconsm', `si', 0,          /// 
			    "`mgamma'", `shvgm', "`mgammalf1'")		    
			matrix `mgammalf' = `mgammalf1'
		}

		if (`bound' == 2 & `strul'==0) {		
			mata: _CHURDLE_ctobit(`sconsm', `si', `cs1', `ul',   ///
			    1, "`mgamma'", "`mgammauf1'")
			
			matrix `mgammauf' = `mgammauf1'
		}

		if (`bound' == 2 & `strul'==1) {
			mata: _CHURDLE_vargamma(`sconsm', `si', 1,          ///
			    "`mgamma'", `shvgm', "`mgammauf1'")

			matrix `mgammauf' = `mgammauf1'
		}

		if (`bound' == 3 & `strll'==0 & `strul'==0) {
			mata: _CHURDLE_ctobit(`sconsm', `si', `csb',         ///
			    `ll', 0, "`mgammal'", "`mgammalf1'")

			mata: _CHURDLE_ctobit(`sconsm', `si', `cs1', `ul',   ///
			    1, "`mgammau'", "`mgammauf1'")
			
			matrix `mgammauf' = `mgammauf1'
			matrix `mgammalf' = `mgammalf1'
		}

		if (`bound' == 3 & `strll'==1 & `strul'==0) {
			mata: _CHURDLE_vargamma(`noconsm', `si', 0,          ///
			    "`mgammal'", `shvgm', "`mgammalf1'")
			    
			matrix `mgammalf' = `mgammalf1'
			
			mata: _CHURDLE_ctobit(`sconsm', `si', `cs1', `ul',   ///
			    1, "`mgammau'", "`mgammauf1'")
			    
			matrix `mgammauf' =  `mgammauf1'
		}

		if (`bound' == 3 & `strll'==0 & `strul'==1) {
			mata: _CHURDLE_vargamma(`noconsm', `si', 1,          ///
			    "`mgammau'", `shvgm', "`mgammauf1'")
			
			matrix `mgammauf' = `mgammauf1'

			mata: _CHURDLE_ctobit(`sconsm', `si', `csb', `ll',   ///
			    0, "`mgammal'", "`mgammalf1'")
			    
			matrix `mgammalf' = `mgammalf1'
		}

		if (`bound' == 3 & `strll'==1 & `strul'==1) {
			mata: _CHURDLE_vargamma(`sconsm', `si', 1,          ///
			    "`mgammau'", `shvgm', "`mgammauf1'")
			    
			mata: _CHURDLE_vargamma(`sconsm', `si', 0,          ///
			    "`mgammal'", `shvgm', "`mgammalf1'")
			
			matrix `mgammauf' = `mgammauf1'
			matrix `mgammalf' = `mgammalf1'
		}

		if `bound'==1 {
			matrix `mgammauf' = 0
		}

		if `bound'==2 {
			matrix `mgammalf' = 0
		}
	}

	if (`zeta'== 0) {
		local sx: list sizeof xvars 
		local sk    = `sx' + `zeta' + abs(`noconsm' -1) + 1
	}
	else { 
		local sx: list sizeof xvars 
		local sk    = `sx' + `zeta' + abs(`noconsm' -1)
	}
				
	local cskf = `sk' + `csk'

	mat `b' = J(1, `cskf', 0)
	mat `V' = J( `cskf', `cskf',0)
	mat `V_modelbased' = `V'
	
	Stripes, wi(`wi') zeta(`zeta') xvars("`xvars'") zvars("`zvars'")     ///
	    yvar("`yvar'") scols(`scols') bound(`bound') si(`si')            ///
	    model(`model') shi(`shi') shetvars("`shetvars'")                 ///
	    exponential("`exponential'") constant("`constant'") 	     ///
	    scons("`scons'")

	local stripe      = "`s(vars)'"
	local eqlatentchi = "`s(ltchi)'"
	
	_b_post0 `stripe'

	mat `b' = e(b)
	mat `V' = e(V)

	mat colnames `b' = `stripe' 
	mat colnames `V' = `stripe'
	mat rownames `V' = `stripe'
			
	if `nvce'> 0 { 
		mat colnames `V_modelbased' = `stripe' 
		mat rownames `V_modelbased' = `stripe'
	}  

	local hascnt = 0 
	if "`constraints'" == "" {	
		local C = 1
	}
	else {
		tempname Cns
		makecns `constraints'
		cap matrix `Cns' = get(Cns)
		local C st_matrix("`Cns'")
		local hascnt = 1 
	}

	if _rc {
		local Cns = ""
		local C = 1	
	}
	
	local consmod = 0
	
	if "`xvars'"=="" {
		local consmod = 1
	}

	mata: _CHURDLE_GetEstimates(`model', `iterate', `tolerance',         ///
	    `ltolerance', `nrtolerance', `step',`grad', `hess', `trace',     ///
	    "`nonrtol'", "`technique'", "`difficult'", "`showtol'", `nolog', ///
	    "`theta'", "`mgammalf'", "`mgammauf'", "`yvar'", "`xvars'",      ///
	    "`scols'", "`zvars'", `C', `var', "`clust'", "`touse'",          ///
	    `noconsm', `sconsm', "`shetvars'", "`pesos'", "`weight'",        ///
	    `bound', "`ul'", "`ll'", `strll', `strul', "`b'", "`V'",         ///
	    "`vm1'", "`converge'", "`loglike'", "`rknum'", "`iterlog'",	     ///
	    `consmod', `svynum', "`kmod0'") 

	tempname betatest vartest stripes varmodel

	mata: _CHURDLE_newstripes("`stripe'", "`b'", "`V'", "`betatest'",    ///
	    `wi', `si', `zeta', `shi', `noconsm', `sconsm', `bound',         ///
	    "`vartest'", "`varmodel'", "`vm1'") 
	    	
	_b_post0 `stripes'
	
	if "`constraints'" != "" {
		tempname Cns
		makecns `constraints', nocnsnotes
		cap matrix `Cns' = get(Cns)
		local C st_matrix("`Cns'")
	}

	if _rc {
		local Cns = ""
	}
	scalar `kmod' = 0
	if (`model'==1|`model'==2) {
		scalar `kmod' = colsof(`betatest')
	}
	if (`model'==5) {
		scalar `kmod' = colsof(`betatest') - `kmod0' 			
	}
	if (`model'==6 & `bound'<3) {
		scalar `kmod' = colsof(`betatest') - `kmod0'  
	}
	if (`model'==6 & `bound'==3) {
		scalar `kmod' = colsof(`betatest') - `kmod0' 		
	}
	if ((`svynum'==0) & ///
		(`model'==1| `model'==2|`model'==5|`model'==6)) {	
		if (`model'==1|`model'==2) {
			scalar `kmod' = colsof(`betatest')
		}
		if (`model'==5) {
			scalar `kmod' = colsof(`betatest') - `kmod0' 			
		}
		if (`model'==6 & `bound'<3) {
			scalar `kmod' = colsof(`betatest') - `kmod0'  
		}
		if (`model'==6 & `bound'==3) {
			scalar `kmod' = colsof(`betatest') - `kmod0' 		
		}
		if ("`churdlesvy'"=="") {
			mata: _CHURDLE_newsigma("`kmod'", "`betatest'",	 ///
				"`vartest'", "`varmodel'", `hascnt')
		}
	}
	
	matrix colnames `betatest' = `stripes' 
	matrix rownames `vartest'  = `stripes' 
	matrix colnames `vartest'  = `stripes' 
	matrix rownames `varmodel' = `stripes' 
	matrix colnames `varmodel' = `stripes' 

	if ("`wtype'"!="pweight") {
		qui summarize `touse' if `touse'==1 `wgt'
		local N = r(N)
	}
	else {
		qui mean `touse' if `touse'==1 `wgt'
		local N = e(N)	
	}

	//////////////////// Coefficient Table and Ereturn /////////////////////

	ereturn post `betatest' `vartest' `Cns', esample(`touse') obs(`N')   ///
	    buildfvinfo

	_post_vce_rank, checksize
	ereturn local vce "`tvce'"
	ereturn local clustvar "`clust2'"
	ereturn local vcetype "`type'"
	ereturn local cmdline churdle `0'
	ereturn local model "`modelo'"
	ereturn local title "Cragg hurdle regression"
	ereturn local depvar "`yvar'"
	ereturn hidden local xvars  "`xvars'"
	ereturn hidden local scols  "`scols'"
	ereturn hidden local zvars  "`zvars'"
	ereturn hidden scalar kmod  = `kmod'
	ereturn hidden local pesos  "`pesos'"
	ereturn hidden local weight "`weight'"
	ereturn hidden local shetvars "`shetvars'"
	ereturn local wtype "`wtype'"
	ereturn local wexp  "`wexp'"
	ereturn local technique "`technique'"
	ereturn local which     "max"
	ereturn local opt       "optimize"
	ereturn scalar N         = `N'
	ereturn scalar converged = `converge'
	ereturn scalar ll        = `loglike'
	ereturn scalar ll_0      = `loglike0'
	ereturn matrix ilog      = `iterlog'
	ereturn scalar df_m      = `newwi'
	
	if "`cuentasclusts'" != "" {
		ereturn scalar N_clust  = `cuentasclusts'
	}
	
	ereturn hidden scalar nmodel    = `model'
	ereturn hidden scalar bound     = `bound'
	ereturn hidden scalar hlatent   = `zeta'
	ereturn hidden local stripes   "`stripes'"
	ereturn hidden scalar noconsm   = `noconsm'
	ereturn hidden scalar sconsm    = `sconsm'
	ereturn hidden scalar consmod   = `consmod'
	ereturn hidden scalar csk       = `csk'
	if `bound'==3 {
		ereturn hidden scalar cskl      = `cskl'
	}
	ereturn hidden scalar shi	= `shi'
	ereturn local predict "churdle_p"
	ereturn local marginsnotok "stdp Residuals"
	ereturn hidden local llimit "`ll'"    
	ereturn hidden local ulimit "`ul'"
	eret local estimator "`estimator'"

	ereturn scalar r2_p = 1 - e(ll)/e(ll_0)
	
	if `nvce' == 0 {
		ereturn scalar k_eq_model = 1
		ereturn scalar chi2    =  2*(e(ll)-e(ll_0))
		ereturn local chi2type = "LR"
		ereturn hidden local crittype "log likelihood"
	}
	
	if `nvce' > 0 {
		if "`eqlatentchi'"=="" {
			ereturn scalar k_eq_model = 1
			local chisq               = r(chi2)
			ereturn scalar chi2       =  .
			ereturn local chi2type    = "Wald"
			ereturn hidden local crittype "log pseudolikelihood"	
		}
		else {
			qui test `eqlatentchi'
			ereturn scalar k_eq_model = 1
			local chisq               = r(chi2)
			ereturn scalar chi2       =  `chisq'
			ereturn local chi2type    = "Wald"
			ereturn hidden local crittype "log pseudolikelihood"
		}
	}
	ereturn hidden local hascnt = `hascnt'
	ereturn scalar p         =  chi2tail(e(df_m), e(chi2))

	if (`nvce' > 0 | "`tvce'"=="robust"){
		ereturn matrix V_modelbased `varmodel' 
	}
	
	if (`zeta'==0 & "`exponential'"=="") {
		ereturn hidden local diparm1 lnsigma, exp label("/sigma")
	}
	
	if (`zeta'==0 & "`exponential'"!="") {
		ereturn hidden local diparm1 lnsigma, exp label("/sigma")
	}
	
	ereturn local cmd "churdle"
	
	
	Display, bmatrix(e(b)) vmatrix(e(V)) level(`level') `other' `diopts'		

end


///////////////// Auxiliary Programs Used by Hurdle ////////////////////


program define Display
	syntax [, bmatrix(passthru) vmatrix(passthru) *]

	_get_diopts diopts other, `options'
	local myopts `bmatrix' `vmatrix'
		
	if "`other'"!=""{
		display "{err}option `other' not allowed"
		exit 198
	}
		
	_coef_table_header
	display ""
	_coef_table,  `diopts' `myopts' notest
	ml_footnote
end


program define Selects, sclass
	syntax varlist(numeric fv), [noCONstant het(string) from(string)]

	sreturn local vars  = "`varlist'"
	sreturn local cons  = "`constant'"
	sreturn local het   = "`het'"
	sreturn local from = `"`from'"'

end

program define _new_wi, rclass
	syntax, [variables(string)]
	
	local k: list sizeof variables
	local cuenta = `k'
	forvalues i=1/`k' {
		local x: word `i' of `variables'
		_ms_parse_parts `x'	
		local b = r(omit)	
		if (`b'>0) {
			local cuenta = `cuenta' - 1
		}
	}
	return local cuenta = `cuenta'
end

program counting_omits, rclass
	syntax, variables(string)
	
	local k: list sizeof variables
	local comits = 0 
	forvalues i=1/`k' {
		local x: word `i' of `variables'
		_ms_parse_parts `x'
		local b = r(omit)
		local a = r(op)
		if (`b'>0 & "`a'"=="o") {
			local comits = `comits' + 1
		}
	}
	return local comits = `comits'
end

program define Variance, rclass
	syntax , Robust

	return scalar var = 2
end

program define Clusters, eclass
	syntax varname, CLuster

	gettoken 0:0, parse(",")
	ereturn local clustervar "`0'"
	ereturn scalar var = 3
end

program CheckEstimator, sclass
	args input

	if ("`input'" == "linear" | "`input'" == "linea" |                   ///
	    "`input'" == "line" | "`input'" == "lin" ) {
		sreturn local estimator "linear"
		exit
	}
	
	if ("`input'" == "exponential"| "`input'" == "exponentia"|           ///
	    | "`input'" == "exponenti"| "`input'" == "exponent"|             ///
	    "`input'" == "exponen"| "`input'" == "expone"|                   ///
	    "`input'" == "expon"|"`input'" == "expo"|"`input'" == "exp") {
		sreturn local estimator "exponential"
		exit
	}
	
	di as error "`input' not a valid estimator"
	exit 198
		
end


program define Stripes, sclass
	syntax,							     ///
		[	                                             ///
		wi(integer 1) 					     ///
		zeta(integer 1)                                      ///
		xvars(string)                                        ///
		zvars(string)                                        ///
		yvar(string)                                         ///
		scols(string)                                        ///
		bound(integer 1)                                     ///
		si(integer 1)                                        ///
		model(integer 1)                                     ///
		shi(integer 1)                                       ///
		shetvars(string)                                     ///
		exponential(string)	                             ///
		constant(string)                                     ///
		scons(string)                                        ///
		]

	local eqlatent    = ""
	local eqlatentchi = ""

	forvalues i=1/`wi' {
		local eqw: word `i' of `xvars'
		local eqlatent    = "`eqlatent' `yvar':`eqw'" 
		local eqlatentchi = "`eqlatentchi' [`yvar']`eqw'" 
	}

	local sigmac = ""

	if `zeta'== 0 & "`exponential'" =="" {
		local sigmac = "lnsigma:_cons"
	}

	if `zeta'== 0 & "`exponential'" !="" {
		local sigmac = "lnsigma:_cons"
	}

	local eqselectul = ""
	local eqselectll = ""


	if `bound' == 1 {	
		forvalues i=1/`si' {
			local eqs: word `i' of `scols'
			local eqselectll = "`eqselectll' selection_ll:`eqs'" 
		}
	}

	if `bound' == 2 {
		forvalues i=1/`si' {
			local eqs: word `i' of `scols'
			local eqselectul = "`eqselectul' selection_ul:`eqs'" 
		}
	}

	if `bound' == 3 {
		forvalues i=1/`si' {
			local eqs: word `i' of `scols'
			local eqselectll = "`eqselectll' selection_ll:`eqs'" 
			local eqselectul = "`eqselectul' selection_ul:`eqs'" 
		}
	}

	local eqhet = ""

	if (`model'==3 | `model'==4 | `model'==7 | `model'==8) {
		forvalues i=1/`zeta' {
			local eqz: word `i' of `zvars'
			local eqhet = "`eqhet' lnsigma:`eqz'" 
		}
	}


	local eqhetsll = ""
	local eqhetsul = ""

	if (`model'==5 | `model'==6 | `model'==7 | `model'==8) {
		if `bound' == 1 {
			forvalues i=1/`shi' {
				local eqzs: word `i' of `shetvars'
				local eqhetsll = "`eqhetsll' lnsigma_ll:`eqzs'" 
			}
		}
		
		if `bound' == 2 {
			forvalues i=1/`shi' {
				local eqzs: word `i' of `shetvars'
				local eqhetsul = "`eqhetsul' lnsigma_ul:`eqzs'" 
			}
		}
		
		if `bound' == 3 {
			forvalues i=1/`shi' {
				local eqzs: word `i' of `shetvars'
				local eqhetsul = "`eqhetsul' lnsigma_ul:`eqzs'"
				local eqhetsll = "`eqhetsll' lnsigma_ll:`eqzs'"  
			}
		}
	}

	if (`model'==1 | `model'==2) {
		if `bound' == 1 {
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectll' selection_ll:_cons 
			}
			
			if (("`constant'" != "") & ("`scons'" != "")) {	
				local stripe `eqlatent' `sigmac' `eqselectll'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {
				local stripe  `eqlatent' `sigmac'            ///
				    `eqselectll' selection_ll:_cons 
			}
			if (("`constant'" == "") & ("`scons'" != "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectll' 
			}
		}
		
		if `bound' == 2 {	
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectul' selection_ul:_cons 
			}
			
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe `eqlatent' `sigmac' `eqselectul'
			}
			
			if (("`constant'" != "") & ("`scons'" == "")) {
				local stripe `eqlatent' `sigmac'             ///
				    `eqselectul' selection_ul:_cons 
			}
			if (("`constant'" == "") & ("`scons'" != "")) {	
				local stripe `eqlatent' latent:_cons         /// 
				    `sigmac' `eqselectul' 
			}
		}
		
		if `bound'==3 {
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectll' selection_ll:_cons ///
				    `eqselectul' selection_ul:_cons
			}
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe `eqlatent' `sigmac' `eqselectll'///
				    `eqselectul'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {
				local stripe `eqlatent' `sigmac'             ///
				    `eqselectll' selection_ll:_cons          ///
				    `eqselectul' selection_ul:_cons
			}
			if (("`constant'" == "") & ("`scons'" != "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectll' `eqselectul' 
			}
		
		}
	}

	if (`model'==5 | `model'==6) {
		if `bound' == 1 {
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectll' selection_ll:_cons ///
				    `eqhetsll'
			}
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe `eqlatent' `sigmac'             ///
				    `eqselectll' `eqhetsll'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {
				local stripe `eqlatent' `sigmac'             ///
				    `eqselectll' selection_ll:_cons `eqhetsll'  
			}
			if (("`constant'" == "") & ("`scons'" != "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectll' `eqhetsll' 
			}
		}
		
		if `bound' == 2 {
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectul' selection_ul:_cons ///
				    `eqhetsul'
			}
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe `eqlatent' `sigmac'             ///
				    `eqselectul' `eqhetsul'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {
				local stripe `eqlatent' `sigmac'             ///
				    `eqselectul' selection_ul:_cons `eqhetsul'   
			}
			if (("`constant'" == "") & ("`scons'" != "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectul' `eqhetsul'  
			}
		}
		
		if `bound' == 3 {
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectll' selection_ll:_cons ///
				    `eqhetsll' `eqselectul'                  ///
				    selection_ul:_cons `eqhetsul'
			}
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe `eqlatent' `sigmac'             ///
				    `eqselectll' `eqhetsll' `eqselectul'     ///
				    `eqhetsul'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {

				local stripe  `eqlatent' `sigmac'            ///
				    `eqselectll' selection_ll:_cons          ///
				    `eqhetsll' `eqselectul'                  ///
				    selection_ul:_cons `eqhetsul'
			}
			if (("`constant'" == "") & ("`scons'" != "")) {
				local stripe `eqlatent' `yvar':_cons         ///
				    `sigmac' `eqselectll' `eqhetsll'         ///
				    `eqselectul' `eqhetsul' 
			}
		}
	}

	if (`model'==3 | `model'==4)  {
		if `bound' == 1 {
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectll' selection_ll:_cons
			}
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe `eqlatent' `eqhet' `eqselectll'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {
				local stripe `eqlatent' `eqhet' `eqselectll' ///
				    selection_ll:_cons
			}
			if (("`constant'" == "") & ("`scons'" != "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectll'  
			}
		}
		
		if `bound' == 2 {
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectul' selection_ul:_cons
			}
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe `eqlatent' `eqhet' `eqselectul'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {
				local stripe `eqlatent' `eqhet' `eqselectul' ///
				    selection_ul:_cons
			}
			if (("`constant'" == "") & ("`scons'" != "")) {

				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectul'  
			}
		}
		
		if `bound' == 3 {	
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectll' selection_ll:_cons          ///
				    `eqselectul' selection_ul:_cons 
			}
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe `eqlatent' `eqhet' `eqselectll' ///
				    `eqselectul'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {
				local stripe `eqlatent' `eqhet' `eqselectll' ///
				    selection_ll:_cons `eqselectul'          ///
				    selection_ul:_cons 
			}
			if (("`constant'" == "") & ("`scons'" != "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectll' `eqselectul'
			}
		}

	}

	if (`model'==7 | `model'==8)  {
		if `bound' ==  1 {
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectll' selection_ll:_cons `eqhetsll'
			}
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe `eqlatent' `eqhet' `eqselectll' ///
				    `eqhetsll'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {
				local stripe `eqlatent' `eqhet' `eqselectll' ///
				    selection_ll:_cons `eqhetsll'
			}
			if (("`constant'" == "") & ("`scons'" != "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectll' `eqhetsll'  
			}
		}
		
		if `bound' ==  2 {	
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectul' selection_ul:_cons `eqhetsul'
			}
			
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe `eqlatent' `eqhet' `eqselectul' ///
				    `eqhetsul'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {
				local stripe `eqlatent' `eqhet' `eqselectul' ///
				    selection_ul:_cons `eqhetsul'	
			}
			if (("`constant'" == "") & ("`scons'" != "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectul' `eqhetsul' 
			}
		}
		
		if `bound' ==  3 {	
			if (("`constant'" == "") & ("`scons'" == "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectll' selection_ll:_cons          ///
				    `eqhetsll' `eqselectul'                  ///
				    selection_ul:_cons `eqhetsul'
			}
			if (("`constant'" != "") & ("`scons'" != "")) {
				local stripe  `eqlatent' `eqhet'             ///
				    `eqselectll' `eqhetsll' `eqselectul'     ///
				    `eqhetsul'
			}
			if (("`constant'" != "") & ("`scons'" == "")) {

				local stripe `eqlatent' `eqhet' `eqselectll' ///
				    selection_ll:_cons `eqhetsll'            ///
				    `eqselectul' selection_ul:_cons `eqhetsul' 
			}
			if (("`constant'" == "") & ("`scons'" != "")) {
				local stripe `eqlatent' `yvar':_cons `eqhet' ///
				    `eqselectll' `eqhetsll' `eqselectul'     ///
				    `eqhetsul'  
			}
		}

	}

sreturn local vars  = "`stripe'"
sreturn local ltchi = "`eqlatentchi'"

end

