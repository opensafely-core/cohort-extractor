*! version 2.1.0  13feb2015 
program define _gcut
	version 7, missing
	syntax newvarname(gen) =/exp [if] [in] /*
		*/ [, AT(numlist asc) Group(real 0) ICodes Label BY(string)]
	if `"`by'"' != "" {
		_egennoby cut() `"`by'"'
	}
	cap qui sum `exp', meanonly
	if _rc~=0 {
		di as err "cut`exp'invalid, variable name expected"

		exit 198
	}

	if "`at'"=="" & `group'==0 {
		di as err "one of at() or group() must be specified"
		exit 198
	}
	if  "`at'"!="" & `group'!=0 {
		di as err "cannot specify both at() and group() option"
		exit 198
	}

	tempvar touse pctile x
	qui gen `typelist' `x' = `exp'

	if "`at'" != "" {
		local n : word count `at'
		local top : word `n' of `at'
		qui replace `x' = . if `x' >= `top'
	}

	marksample touse, novarlist
	markout `touse' `x'
	if "`at'"=="" & `group'!=0 & "`icodes'"=="" {
		local icodes "icodes"
	}
	if "`label'"!="" & "`icodes'"=="" {
		local icodes "icodes"
	}
	local vlbl "$EGEN_Varname"

	local vlablen : label `vlbl' maxlength
	if `vlablen' != 0 { /* a variable label named `vlbl' already exists */
		/* we will find another name to use */
		local chop = ustrlen("`vlbl'") - 1
		local ends = "abcdefghijklmnopqrstuvwxyz0123456789" + /*
				*/ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		forvalues j = 1/62 {
			local vlbl = usubstr("`vlbl'",1,`chop') + /*
						*/ bsubstr("`ends'",`j',1)
			local vlablen : label `vlbl' maxlength
			if `vlablen' == 0 { /* we found an unused one */
				continue, break
			}
		}
	}

	if "`at'"=="" {
		qui summ `x', meanonly
		tempname extra
		scalar `extra' = r(min)
		local at  "`extra'"
		qui pctile `pctile' = `x' if `touse', nq(`group')
		local grm1 = `group' - 1
		forvalues count = 1/`grm1' {
			tempname extra
			scalar `extra' = `pctile'[`count']
			local at  "`at' `extra'"
		}
		qui summ `x' if `touse', meanonly
		tempname extra
		scalar `extra' = r(max)+1
		local at  "`at' `extra'"
	}

	local i=0
	foreach cutp of local at {
		if "`icodes'"=="" {
			qui replace `varlist' = `cutp' /*
					*/ if `x' >= `cutp' & `touse'
		}
		else {
			qui replace `varlist' = `i' /*
					*/ if `x' >= `cutp' & `touse'
		}
		if `i'>=0 & "`label'"!="" & "`icodes'" != "" {
			local code = `i' 
			local slcut = string(`cutp')
			label define `vlbl' `code' "`slcut'-", add
		}
		local i=`i'+1
	}

	if "`label'"!="" {
		label values `varlist' `vlbl'
	}
end
