*! version 1.2.3  12feb2010
program define _tsma, sortpreserve rclass 
	version 8.0

/* syntax is _tsma type new old,touse(byte varname) 
		[ a0(number) backward(numlist)  forward(numlist) ]
	
	default is a0()=1 and backward() and forward() are empty, this 
		would just reproduce the original series for the touse() 
		sample
*/
	
	gettoken vars left : 0 , parse(",") 
	tokenize `vars'
	local type "`1'"
	local newvar "`2'"
	local oldvar "`3'"

	if "`type'" == "" {
		di as err "type not specified"
		exit 198
	}
	if "`oldvar'" == "" {
		di as err "old variable not specified"
		exit 198
	}
	if "`newvar'" == "" {
		di as err "new variable not specified"
		exit 198
	}

	local 0 "`left'"
	syntax , touse(varlist) [ * ] 

	qui tsset, noquery
	qui count if `touse'==1
	local N = r(N)
	local insmp2 = int(.5*(`N'))

	local 0 "`left'"
	syntax , touse(varlist) [  a0(real 1) /*
		*/ backward(numlist) /*
		*/ forward(numlist) ]
	
	local terms : word count `backward'
	if `terms' > `insmp2' {
		di as err "too many lagged terms in smoother"
		exit 198
	}
	
	local terms : word count `forward'
	if `terms' > `insmp2' {
		di as err "too many forward terms in smoother"
		exit 198
	}

	local 0 "`type' `newvar', oldvar(`oldvar')" 
	syntax newvarname , oldvar(varname)  

	tempvar  ob ob1 obN
	
	
/* check that data is tsset */

	qui tsset, noquery
	local tvar `r(timevar)'

	if "`r(panelvar)'" != "" {
		local pvar "`r(panelvar)'"
		local byp " by `pvar': "
		local panel "panel"
	}

	sort `pvar' `tvar'

	tempvar sum scale 

	qui gen double `sum' = cond(missing(`oldvar'),0, /*
		*/ `a0'*`oldvar') /* if `touse'  */

	qui gen double `scale' = cond(missing(`oldvar'),0,`a0') /*
		*/ /* if `touse' */

	local bc : word count `backward'
	local i 1
	foreach b of local backward {
		local li = `bc' - `i' + 1
		qui `byp' replace `sum' = `sum' + `b' * /*
			*/ cond(missing(l`li'.`oldvar'),0,/*
			*/ l`li'.`oldvar' ) /* if `touse'*/

		qui `byp' replace `scale' = `scale' + /* 
			*/ cond( missing(l`li'.`oldvar'), 0 , `b' )

		ret scalar wlag`li' = `b'	
		local i = `i' + 1	
	}	

	local i 1

	foreach f of local forward {
		qui `byp' replace `sum' = `sum' + `f' * /*
			*/ cond(missing(f`i'.`oldvar'),0,/*
			*/ f`i'.`oldvar' ) /* if `touse' */
	
		qui `byp' replace `scale' = `scale' + /* 
			*/ cond( missing(f`i'.`oldvar'), 0 , `f' )

		ret scalar wlead`i' = `f'	
		local i = `i' + 1	
	}	

	qui gen `typlist' `varlist' = `sum'/`scale'

	ret scalar w0 = `a0'

	ret scalar N = `N'
	ret local timevar `tvar'
	ret local panelvar `pvar'
end

