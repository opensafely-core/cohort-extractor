*! version 1.0.1  05nov2002
program define _hw_comp, rclass
	version 8.0

	local 0a `0'
	syntax anything, [ replace ] * 
	
	local 0 `0a'

	if "`replace'" != "" {
		syntax varname, oldvar(varname) alpha(string) beta(string) /*
		*/ a0i(string) b0i(string) firstin(string) /*
		*/ lastin(integer) [ replace]
	}
	else {
		syntax newvarname, oldvar(varname) alpha(string) beta(string) /*
		*/ a0i(string) b0i(string) firstin(string) lastin(integer)	
		

	}
	tempvar avar bvar 
	
	qui gen double `avar' = `alpha'*`oldvar'+(1-`alpha')*(`a0i' /*
		*/ + `b0i')  if _n == `firstin' 
	
	qui gen double `bvar' = `beta'*(`avar'-`a0i') /*
		*/ + (1-`beta')*`b0i' if _n == `firstin' 


	qui {
		_byobs {
			update  `avar' = cond( `oldvar' < . , /*
				*/ `alpha'*`oldvar' + 	/*
				*/ (1-`alpha')*(l.`avar'+ l.`bvar'),/*
				*/  (l.`avar' + l.`bvar' ) )
			update  `bvar' = `beta'*(`avar'-l.`avar') /*
				*/ + (1-`beta')*l.`bvar' 
		} if _n > `firstin' & _n <= `lastin'

	}

	if "`replace'" == "" {
		qui gen double `varlist' = (`a0i' + `b0i') /*
			*/ if _n == `firstin' 
	}
	else {
		qui replace `varlist' = (`a0i' + `b0i') /*
			*/ if _n == `firstin' 
	}
	qui replace `varlist' = (l.`avar' + l.`bvar') /*
		*/ if _n > `firstin' &  _n <= `lastin'

	if "`lastin'" != "" {
		ret scalar aT = `avar'[`lastin']
		ret scalar bT = `bvar'[`lastin']
	}

	
end

exit

This routine computes the in-sample non-seasonal Holt-Winters Method and
puts the filtered series into the specified variable.  The options specify
the required starting values and sample information.

