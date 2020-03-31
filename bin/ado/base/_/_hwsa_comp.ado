*! version 1.0.2  05nov2002
program define _hwsa_comp, rclass
	version 8.0
	local 0a `0'
	syntax anything, [ replace ] * 
	
	local 0 `0a'

	if "`replace'" != "" {
		syntax varname, oldvar(varname) alpha(string)		/*
			*/ gamma(string) a0i(string) b0i(string)   	/*
			*/ lastin(integer) snt(string) 	   		/*
			*/ firstin(integer) sn0(varname)		/*
			*/ period(integer)  beta(string) 		/*
			*/ m(varname)	/*
			*/ [ pvar(varname) Normalize replace 		/*
			*/   tvar(varname)]
	}
	else {
		syntax newvarname, oldvar(varname) alpha(string)	/* 
			*/ gamma(string) a0i(string) b0i(string)    	/*
			*/ lastin(integer) 	   	/*
			*/ firstin(integer) sn0(varname)		/*
			*/ period(integer)  beta(string) m(varname)	/*
			*/ [tvar(varname)  Normalize pvar(varname) 	/*
			*/  snt(string) ]

			if "`snt'" == "" {
				tempvar snt
			}	
				
	}

/* m() holds year variable */

	if "`normalize'" != "" & ("`tvar'" == "" ) {
		di as err "_hwsa_comp not called correctly"
		di as err "pvar() and tvar() must be specified with normalize"
		exit 498
	}

	tempvar a0 b1  sn0_m
	
	
	if "`normalize'" != "" {
		qui sum `sn0' if `m' == 1
		scalar `sn0_m' = r(mean)
		qui replace `sn0' = `sn0' - r(mean)
		scalar `a0i' = `a0i' + r(mean)
	}	
	

	qui gen double `a0' = `alpha'*(`oldvar' - `sn0')+(1-`alpha')*(`a0i' /*
		*/ + `b0i')  if _n == `firstin' 
	
	qui gen double `b1' = `beta'*(`a0'-`a0i') + (1-`beta')*`b0i' /*
			*/ if _n == `firstin' 
	qui gen double `snt' = `gamma'*(`oldvar' - `a0') + (1-`gamma')*`sn0' /*
		*/ if _n == `firstin' 
	
	tempvar oldvar2
	qui gen double `oldvar2' = `oldvar' in `firstin'/`lastin'
	
	_byobs {
		update `oldvar2' = cond(`oldvar2'<., `oldvar2', /*
			*/ (l.`a0' + l.`b1') + `sn0' ) 
			
		update  `a0' = `alpha'*(`oldvar2' - `sn0') + /*
			*/ (1-`alpha')*(l.`a0' + l.`b1')
	
		update  `b1' = `beta'*(`a0'-l.`a0') + (1-`beta')*l.`b1' 

		update  `snt' = `gamma'*(`oldvar2' - `a0') + /* 
			*/ (1-`gamma')*`sn0' 	

	} if _n > `firstin' & `m' == 1 

	_byobs {
		update `oldvar2' = cond(`oldvar2'<., `oldvar2', /*
			*/ (l.`a0' + l.`b1') + L`period'.`snt' )
			
		update  `a0' = `alpha'*(`oldvar2' - L`period'.`snt') /*
			*/ + (1-`alpha')*(l.`a0'+ l.`b1')
	
		update  `b1' = `beta'*(`a0'-l.`a0') + (1-`beta')*l.`b1' 

		update  `snt' = `gamma'*(`oldvar2' - `a0') /*
			*/ + (1-`gamma')*L`period'.`snt' 	

	} if `m' > 1 & _n <= `lastin' 


	if "`normalize'" != "" {
/* by construction, there must be period observations per year m so
 * use period to calculate within year means
 */
		sort `m' `tvar' 
		tempname sn_m Ni c0_a
		tempvar lt sntdiff
		qui by `m': gen `lt' = _n
		qui by `m': gen double `sn_m' =sum(`snt') /*
			*/ if _n >= `firstin' & _n <= `lastin'
		qui by `m': replace `sn_m' = `sn_m'[_N] / `period'
		qui replace `snt' = `snt' - `sn_m'
		
		sort `pvar' `tvar'
		
		qui gen double `sntdiff' = `sn_m' if `m'==1 
		qui replace `sntdiff' = `sn_m' - L`period'.`sn_m' if `m' >1	
		qui replace `a0'  = `a0' + L`period'.`sn_m'	/*
			*/ if `m'>1 
		qui replace `a0'  = `a0' + `sntdiff' if `lt' == 12
 		
	}

	if "`replace'" != "" {
		qui replace `varlist' = (`a0i' + `b0i') +  `sn0' /*
			*/ if _n == `firstin' 

		return scalar a0T = `a0'[`lastin']
		return scalar b1T = `b1'[`lastin']
	}
	else {
		qui gen `typlist' `varlist' = (`a0i' + `b0i') +  `sn0' /*
			*/ if _n == `firstin' 
	}

	qui replace `varlist' = (l.`a0' + l.`b1') + `sn0' /*
		*/ if _n > `firstin' & `m' ==1 
	qui replace `varlist' = (l.`a0' + l.`b1') + L`period'.`snt' /*
		*/ if  `m' > 1 & _n <= `lastin' & _n > `firstin' 
		
end

exit 

This routine computes the in-sample additive Holt-Winters method and puts
the filtered series in the specified variable.  
The options specify the required starting values, year, period and sample
information.

The Normalize option specifies that the seasonal terms in each year must sum
to 0.  Note that this is computed via a transform of the unnormalized seasonal
and a() terms.

