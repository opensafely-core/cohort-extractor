*! version 1.0.4  07feb2012
program define _me_der, rclass
	version 6 
	args 	X		/* matrix of evaluation points   
	*/	i		/* index of the matrix 	      
	*/	predopt 	/* option for predict 
	*/	lny		/* 1: ln(y); 0: y */
	preserve
	cap noi {   
		AddX `X'  					/* add obs X */
		tempname h dfdx 
		local epsf 1e-6	
		scalar `h' = (abs(`X'[1,`i'])+`epsf')*`epsf' 	/* initial h */
	
		GetH `h' `X' `i' "`predopt'" `lny'		/* choose h */
		if `h' == 0 {
			scalar `dfdx' = 0
		}
		else GetMarg `dfdx' `h' `X' `i' "`predopt'" `lny' /* get dfdx */

		return scalar dfdx = `dfdx'		/* return dfdx */
		return scalar h= `h'			/* return h    */
	}
	restore
	if _rc != 0 {
		exit _rc
	}
end

program define AddX
	args X  
	local cname : colnames `X'
	tokenize "`cname'"
	local j=1
	while "``j''" != "" {
		if "``j''" != "_cons" {
			cap confirm var ``j'' 
			local rc1 = _rc
			cap confirm new var ``j''
			local rc2 = _rc
			if `rc1' == 0 | `rc2' == 0 {
				tempvar junk
				qui gen double `junk' = `X'[1,`j'] in 1
				cap drop ``j''
				rename `junk' ``j''
			}
		}
		local j = `j' + 1
	}
end
	
program define GetH
	args	h X i predopt lny
	tempname f0 f1 X1 goal0 goal1 diff lh uh
	GetF `f0' `X' `i' "`predopt'" `lny'  			/* get f(x) */
	mat `X1' = `X'
	mat `X1'[1,`i'] = `X'[1,`i'] + `h'		
	GetF `f1' `X1' `i' "`predopt'" `lny'		/* get f(x+h) */
	scalar `diff' = abs(`f0' - `f1')		/* |f(x+h)-f(x)| */
	if `diff' == 0 {				/* df/dx == 0 */
		scalar `h' = 0
	}
	else {	

		local ep0 1e-7
		local ep1 1e-6
		scalar `goal0' = abs(`f0'+`ep0')*`ep0' 
		scalar `goal1' = abs(`f0'+`ep1')*`ep1'	

/* we want h such that goal0 < diff < goal1	*/

		local flag1 1	
		local flag2 1

		while (`diff' < `goal0' | `diff' > `goal1' ) {
			if `diff' < `goal0' {
				scalar `lh' = `h'
				local flag1 0
				if `flag2' {
					scalar `uh' = 2*`h'
				}
			}
			else {
				scalar `uh' = `h'
				local flag2 0
				if `flag1' {
					scalar `lh' = 0.5*`h'
				}
			}
			scalar `h' = (`lh'+`uh')/2
			if (`uh'-`lh') < 1e-15 {
			dis in red "fail in getting numerical derivatives"
				exit 430
			}
			mat `X1'[1,`i'] = `X'[1,`i'] + `h'
			GetF `f1' `X1' `i' "`predopt'" `lny' 
			scalar `diff' = abs(`f0' - `f1')
		}					
	}
end

program define GetF
	args f X i predopt lny
	local varlist : colnames `X'
	tempvar y  
	local iname : word `i' of `varlist'
	tempvar junk 
	qui gen double `junk' = `X'[1,`i'] in 1
	drop `iname' 
	rename `junk' `iname'
       	$T_mfver qui predict double `y' in 1, `predopt'
	if `lny' { scalar `f' = ln(`y'[1]) }
	else scalar `f' = `y'[1]
end
		
program define GetMarg
	args dydx h X i predopt lny
	tempname X1 f1 f2
	mat `X1' = `X'
	mat `X1'[1,`i'] = `X'[1,`i'] + `h'/2
	GetF `f1' `X1' `i' "`predopt'" `lny' 
	mat `X1'[1,`i'] = `X'[1,`i'] - `h'/2
	GetF `f2' `X1' `i' "`predopt'" `lny'
	scalar `dydx' = (`f1'-`f2')/`h'
end

exit

this program calculates 

	d F(X, B)
    ----------------
	 d X_i

where X_i is not a constant term.
