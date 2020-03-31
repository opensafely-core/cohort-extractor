*! version 1.0.2  26jan2005
program define canon_p
	version 8.1

	syntax newvarname [if] [in] [, Index XB STDP STDDP noOFFset /*
		*/ Equation(string) Outcome(string) 		    /*
		*/ Correlation(numlist max=1 int) U V STDU STDV ]

	local corr `correlation'
	if `"`outcome'"'!="" { 
		if `"`equation'"' != "" {
			error 198
		}
		local equation `"`outcome'"'
	}
	if "`corr'"!=""&"`equation'"!="" {
di as error "options correlation and equation may not be specified together"
	}


	local typ1 "`index'`xb'`stdp'`stddp'"
	local typ2 "`u'`v'`stdu'`stdv'"

	if "`equation'"!=""&"`typ2'"!="" {
di as error "options equation and `typ2' may not be specified together, use the correlation() option instead"
		exit 198
	}
	if ("`equation'"!="")&("`typ2'"=="") {
		_predict `typlist' `varlist' `if' `in', /*
			*/ `typ1' equation(`equation') `offset'
		exit
	}
	
	if "`corr'"=="" local corr 1

	if "`typ1'" != "" { 
		di in red "option `typ1' not allowed"
		exit 198
	}
	
	if "`typ2'"=="u"|"`typ2'"=="stdu" {
		local eq = 2*(`corr'-1) + 1
	}
	else {
		local eq = 2*(`corr')
	}
	if "`typ2'"=="u" {
	capture _predict `typlist' `varlist' `if' `in', xb eq(#`eq') `offset'
		if _rc == 0 {
			label var `varlist' "u = X*b_1"
		}
		else{ 
			if _rc == 303 {
				di as err "correlation #`corr' not found"
				exit _rc
			}
			else {
		_predict `typlist' `varlist' `if' `in', xb eq(#`eq') `offset'
		/* generates error code and message as appropriate */	
			}
		}
		exit
	}

	if "`typ2'"=="v" { 
	capture _predict `typlist' `varlist' `if' `in', xb eq(#`eq') `offset'
		if _rc == 0 {
			label var `varlist' "v = Y*b_2 correlation `corr'"
		}
		else {
			if _rc == 303 {
				di as err "correlation #`corr' not found"
				exit _rc
			}
			else {
		_predict `typlist' `varlist' `if' `in', xb eq(#`eq') `offset'
		/* generates error code and message as appropriate */	
			}
		}
		exit
	}

	if "`typ2'"=="stdu" { 
capture	_predict `typlist' `varlist' `if' `in', stdp eq(#`eq') `offset'
		if _rc == 0 {
			label var `varlist' "S.E. u = X*b_1 correlation `corr'"
		}
		else {
			if _rc == 303 {
				di as err "correlation #`corr' not found"
				exit _rc
			}
			else {
	_predict `typlist' `varlist' `if' `in', stdp eq(#`eq') `offset'
	/* generates error code and message as appropriate */
			}
		}
		exit
	}

	if "`typ2'"=="stdv" { 
capture _predict `typlist' `varlist' `if' `in', stdp eq(#`eq') `offset'
		if _rc == 0 {
			label var `varlist' "S.E. v = Y*b_2 correlation `corr'"
		}
		else {
			if _rc == 303 {
				di as err "correlation #`corr' not found"
				exit _rc
			}
			else {
	_predict `typlist' `varlist' `if' `in', stdp eq(#`eq') `offset'
	/* generates error code and message as appropriate */
			}
		}
		exit
	}
	di as err "one of u, v, stdu, or stdv must be specified"
	exit 198
end
