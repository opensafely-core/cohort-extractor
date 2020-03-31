*! version 1.0.2  26jan2005
program define canon_8_p
	version 6, missing

	syntax newvarname [if] [in] [, Index XB STDP STDDP noOFFset /*
		*/ Equation(string) Outcome(string) /*
		*/ U V STDU STDV ]

	if `"`outcome'"'!="" { 
		if `"`equatio'"' != "" {
			error 198
		}
		local equatio `"`outcome'"'
	}

	local typ1 "`index'`xb'`stdp'`stddp'"
	local typ2 "`u'`v'`stdu'`stdv'"

	if `"`equatio'"' != "" | `"`outcome'"' != "" {
		if `"`outcome'"' != "" {
			if `"`equatio'"' != "" {
				error 198
			}
			local equatio `"`outcome'"'
			local eqname "outcome"
		}
		else	local eqname "equation"

		if "`typ2'" != "" { 
			di in red "option `eqname'() not allowed"
			error 198 
		}
		_predict `typlist' `varlist' `if' `in', /*
			*/ `typ1' equation(`equatio') `offset'
		exit
	}

	if "`typ1'" != "" { 
		di in red "option `typ1' not allowed"
		exit 198
	}

	if "`typ2'"=="u" {
		_predict `typlist' `varlist' `if' `in', xb eq(#1) `offset'
		label var `varlist' "u = X*b_1"
		exit
	}

	if "`typ2'"=="v" { 
		_predict `typlist' `varlist' `if' `in', xb eq(#2) `offset'
		label var `varlist' "v = Y*b_2"
		exit
	}

	if "`typ2'"=="stdu" { 
		_predict `typlist' `varlist' `if' `in', stdp eq(#1) `offset'
		label var `varlist' "S.E. u = X*b_1"
		exit
	}

	if "`typ2'"=="stdv" { 
		_predict `typlist' `varlist' `if' `in', stdp eq(#2) `offset'
		label var `varlist' "S.E. v = Y*b_2"
		exit
	}

	error 198
end
