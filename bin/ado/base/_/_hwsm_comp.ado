*! version 1.0.2  15aug2006
program define _hwsm_comp, rclass 
	version 8.0

	local 0a `0'
	syntax anything, [ replace ] * 
	
	local 0 `0a'

	if "`replace'" != "" {
		syntax varname, oldvar(varname) alpha(string)		/*
			*/ beta(string) gamma(string) sn0(varname)	/*
			*/ a0i(string) b1i(string) firstin(integer) 	/*
			*/ mvar(varname) period(integer) 		/*
			*/ lastin(integer) 				/*
			*/ [ pvar(varname) tvar(varname) Normalize	/*
			*/  snt(string) replace ]
	
	}
	else{
		syntax newvarname, oldvar(varname) alpha(string)	/*
			*/ beta(string) gamma(string) sn0(varname)	/*
			*/ a0i(string) b1i(string) firstin(integer) 	/*
			*/ mvar(varname) period(integer)		/*
			*/ lastin(integer) 				
	
		tempvar snt
	}
	
	tempvar a0 b1 oldvar2
	qui gen double `oldvar2' = `oldvar' in `firstin'/`lastin'

	
	qui gen double `a0' = `alpha'*(`oldvar2'/`sn0')+(1-`alpha') /*
		*/ *(`a0i' + `b1i')  if _n == `firstin' 
	
	qui gen double `b1' = `beta'*(`a0'-`a0i') + (1-`beta')*`b1i' /*
		*/ if _n == `firstin' 

	qui gen double `snt' = `gamma'*(`oldvar2'/`a0') + 	/*
		*/ (1-`gamma')*`sn0' if _n == `firstin' 
	
	_byobs {
		update `oldvar2' = cond(`oldvar2'<., `oldvar2', /*
			*/ (l.`a0' + l.`b1')*`sn0' ) 
			
		update  `a0' = `alpha'*(`oldvar2'/`sn0') + /*
			*/ (1-`alpha')*(l.`a0' + l.`b1')
	
		update  `b1' = `beta'*(`a0'-l.`a0') + (1-`beta')*l.`b1' 

		update  `snt' = `gamma'*(`oldvar2'/`a0') + /* 
			*/ (1-`gamma')*`sn0' 	

	} if _n > `firstin' & `mvar' == 1 


	_byobs {

		update `oldvar2' = cond(`oldvar2'<., `oldvar2', /*
			*/ (l.`a0' + l.`b1')*L`period'.`snt' )
			
		update  `a0' = `alpha'*(`oldvar2'/L`period'.`snt') /*
			*/ + (1-`alpha')*(l.`a0'+ l.`b1')
	
		update  `b1' = `beta'*(`a0'-l.`a0') + (1-`beta')*l.`b1' 

		update  `snt' = `gamma'*(`oldvar2'/`a0') /*
			*/ + (1-`gamma')*L`period'.`snt' 	


	} if `mvar' > 1 & _n <= `lastin' & _n >= `firstin' + `period'
	

	if "`replace'" != "" {
		qui replace `varlist' = (`a0i' + `b1i')*`sn0' /*
			*/ if _n == `firstin' 
	}
	else {
		qui gen double `varlist' = (`a0i' + `b1i')*`sn0' /*
			*/ if _n == `firstin' 
	}
	qui replace `varlist' = (l.`a0' + l.`b1')*`sn0' /*
		*/ if _n > `firstin' & `mvar' ==1 & _n <= `lastin'
	qui replace `varlist' = (l.`a0' + l.`b1')*L`period'.`snt' /*
		*/ if  `mvar' > 1 & _n <= `lastin' & _n > `firstin'

	if "`normalize'" != "" {
		local years = (`lastin'-`firstin'+1)/`period'
		if `years' < int(`years') {
			local years = int(`years') + 1
		}
		qui sum `snt' if `mvar' == `years'
		qui replace `snt' = `snt'/r(mean) if `mvar' == `years'

		return scalar a0T = `a0'[`lastin']*r(mean)
		return scalar b1T = `b1'[`lastin']*r(mean)
	}
	else {
		return scalar a0T = `a0'[`lastin']
		return scalar b1T = `b1'[`lastin']
	}

end

exit

This computes a the in-sample Holt-winters multiplicative smoothed series.
The smoothed series is placed in the specified variable, the options specify
the required starting values, year, period, and sample information.

Normalize option computes the series in which seasonal terms are normalized to
have mean 1.  Note that this is computed via a simple transform of the
nonnormalized snt series.

