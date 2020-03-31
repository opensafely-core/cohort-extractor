*! version 3.1.1  01oct2004
program define _grank
	version 7, missing
	syntax newvarname =/exp [if] [in] [, BY(varlist) /*
		*/ {Field|Track|Unique}  Suffix(str)]

	if ("`field'"!="") + ("`track'"!="") + ("`unique'"!="") > 1 {
		di as err "{p}only one of field, track, or unique"
		di "may be specified{p_end}"
		exit 198
	}
	if ("`by'"!="") + ("`suffix'"!="") > 1 {
		di as err "{p}by() and suffix() may not be specified together{p_end}"
		exit 198
	}
	if ("`suffix'"!="") > 0 & ("`field'"!="") + ("`track'"!="") + /*
		*/("`unique'"!="") < 1 {
		di as err "{p}suffix() allowed only with the field, track,"
		di "or unique options{p_end}"
		exit 198
	}
	local sign = 1
	if "`field'"!="" {
		local fstar = "*"
		local sign = -1
	}
	if "`track'"!="" {
		local tstar = "*"
	}
	if "`unique'"!="" {
		local ustar = "*"
	}
	if ("`field'"!="") + ("`track'"!="") + ("`unique'"!="") > 0 {
		local space " "
	}
	tempvar GRV
	quietly {
		gen double `GRV' = `sign'*(`exp') `if' `in'

		sort `by' `GRV'
		if "`by'"!="" {
			local by2 = `"by `by':"'
		}
		`by2' gen `typlist' `varlist' = _n if `GRV'<.
		`ustar' `by2' replace `varlist' = `varlist'[_n-1] /*
			*/ if `GRV'<. & `GRV'==`GRV'[_n-1]
		`ustar'`tstar'`fstar' by `by' `GRV': replace `varlist' = /*
			*/`varlist'+(_N-1)/2
		if "`by'"!="" {
			local by2 = `"by `by'"'
		}
		label var `varlist' /*
			*/ "`field'`track'`unique'`space'rank of `exp' `by2'"
		_getnewlabelname vlbl
		tempvar group
		if "`suffix'" != "" {
			local nties = 0 
			local i = 1
			while `i' <= _N {
				count if `varlist' == `i'
				if r(N) > 1 { /* there are tied ranks */
					label def `vlbl' `i' "`i'`suffix'", add
					local nties = `nties' + 1
				}
				local i = `i' + 1
			}
			if `nties' {
				label val `varlist' `vlbl'
			}
		}
	}
end
