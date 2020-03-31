*! version 1.0.1  04mar2015
// translated and adjusted from implementation in Numerical Recipes
program minbound, rclass
	version 9
	
	#del ;
	syntax 	anything(name=func id=program) ,
		RANge(str)
	[
	   	FROM(str)
	   	ARGuments(str)
	   	TOLerance(real 1e-5)
	   	ITERate(int 100)
	   	MISSing
	   	LOg  // undocumented synonym for trace
	   	TRace
	] ;
	#del cr
	
	if "`log'" != "" {
		local trace trace
	}	
		
// constant

	tempname cgold zeps
	
	scalar `cgold' = 0.3819660 // = golden ratio (3-sqrt(5))/2
	scalar `zeps'  = sqrt(c(epsdouble))

// scratch

	tempname a ax b bx d e etemp p q r tol1 tol2
	tempname u v w x xmid fa fb fu fv fw fx
		
// range() 	

	gettoken toka range: range, match(lmac) parse(", ")
	gettoken tokb range: range, match(lmac) parse(", ")
	if `"`tokb'"'=="," {
		gettoken tokb range: range, match(lmac) parse(", ")
	}	
	if `"`range'"'!="" {
		dis as err "range() invalid"
		dis as err "unexpected text found: " `"`range'"'
		exit 198
	}	
	
	scalar `ax' = `toka'
	scalar `bx' = `tokb'
		
	if missing(`ax') {
		dis as err "range() invalid"
		dis as err "lower boundary evaluates to missing value"
		exit 198
	}	
	if missing(`bx') {
		dis as err "range() invalid"
		dis as err "upper boundary evaluates to missing value"
		exit 198
	}	
	
	if `ax' > `bx' {
		dis as err "range() invalid"
		dis as err "lowerbound larger than upperbound"
		exit 198
	}	
		
	
	Call `func' `ax' `"`arguments'"' "`missing'"
	scalar `fa' = r(fx)

	Call `func' `bx' `"`arguments'"' "`missing'"
	scalar `fb' = r(fx)
	
	scalar `a' = `ax'
	scalar `b' = `bx'
	if "`from'" != "" {
		scalar `v' = `from'
		if missing(`v') {
			dis as err "initial value is missing"
			exit 198
		}	
		if !inrange(`v',`a',`b') {
			dis as err "initial value does not satisfy bounds"
			exit 198
		}
	}
	else {
		scalar `v' = `a' + `cgold'*(`b'-`a')
	}	

// setup

	scalar `w' = `v'
	scalar `u' = `v'
	scalar `d' = 0
	scalar `e' = 0

	scalar `x' = `u'	
	Call `func' `x' `"`arguments'"' "`missing'"
	scalar `fx' = r(fx)
		
	scalar `fv' = `fx'
	scalar `fw' = `fx'
	
// iterative improvement

	if "`trace'" != "" {
		dis
	}	

	local rc = 1
	forvalues iter = 1/`iterate' {
	
		if "`trace'" != "" {
			dis as txt "Iteration " %2.0f `iter'    ///
			    as txt ":  x = " as res %12.0g `x'  ///
			    as txt "  fx = " as res %12.0g `fx' ///
			    as txt " `method'"
		}	
		
		scalar `xmid' = 0.5*(`a'+`b')
		scalar `tol1' = `zeps'*abs(`u') + (1/3)*`tolerance'
		scalar `tol2' = 2*`tol1'
		
		if abs(`u'-`xmid')<=`tol2'-0.5*(`b'-`a') {
			local rc = 0
			continue, break
		}
		
		if abs(`e')>`tol1' {
		
			// construct a trial parabola
			
			scalar `r' = (`u'-`w')*(`fx'-`fv')
			scalar `q' = (`u'-`v')*(`fx'-`fw')
			scalar `p' = (`u'-`v')*`q' - (`u'-`w')*`r'
			scalar `q' = 2*(`q'-`r')
			if (`q'> 0)  scalar `p' = -`p'
			scalar `q' = abs(`q')
			
			scalar `etemp' = `e'
			scalar `e' = `d'

			if (abs(`p')>=abs(0.5*`q'*`etemp')) ///
			 | (`p'<=`q'*(`a'-`u')) ///
			 | (`p'>=`q'*(`b'-`u')) {
			 	// parabola will not be used after all
			 	// do golden section step instead
			 	local method "(golden)"
			 	
				scalar `e' = cond(`u'>=`xmid', ///
				             `a'-`u', `b'-`u')
				scalar `d' = `cgold' * `e'
			}
			else {
				local method "(parabolic)"

				scalar `d' = `p'/`q'
				scalar `x' = `u'+`d'
				if (`x'-`a'<`tol2') | (`b'-`x'<`tol2') {
					scalar `d' = sign(`xmid'-`u') ///
					             + ((`xmid'-`u')==0)
					scalar `d' = `d' * abs(`tol1')
				}
			}
		}
		else {
			// golden section step into larger of the segments
			local method "(golden)"
			
			scalar `e' = cond(`x'>=`xmid',`a'-`u',`b'-`u')
			scalar `d'= `cgold' * `e'	
		}
		
		// avoid evaluating f() near u
		if abs(`d')>=`tol1'{
			scalar `x' = `u' + `d'
		}
		else 	scalar `x' = `u' + (sign(`d')+(`d'==0))*abs(`tol1')
		
		Call `func' `x' `"`arguments'"' "`missing'"
		scalar `fu' = r(fx)
		
		// housekeeping
		
		if `fu'<=`fx' {
			if `x'>=`u' {
				scalar `a' = `u'
			}
			else 	scalar `b' = `u'
			
			scalar `v'  = `w'
			scalar `fv' = `fw'
			scalar `w'  = `u'
			scalar `fw' = `fx'
			scalar `u'  = `x'
			scalar `fx' = `fu'
		}
		else {
			if `x'<`u' {
				scalar `a' = `x'
			}
			else	scalar `b' = `x'
			
			if (`fu'<=`fw') | (`w'==`u') {
				scalar `v'  = `w'
				scalar `fv' = `fw'
				scalar `w'  = `x'
				scalar `fw' = `fu'
			}
			else if (`fu'<=`fv') | (`v'==`u') | (`v'==`w') {
				scalar `v'  = `x'
				scalar `fv' = `fu'
			}
		}
	}	

// compare with end points

	if (`fa'<`fx') & (`fa'<=`fb') {
		scalar `x'  = `ax'
		scalar `fx' = `fa'
	}
	else if `fb'<`fx' {
		scalar `x'  = `bx'
		scalar `fx' = `fb'
	}
	
// return results

	return scalar rc = `rc'
	return scalar x  = `x'
	return scalar fx = `fx'
end	


program Call
	args func x arguments missing
	
	capture `func' `x' `arguments'
	local rc = _rc
	
	if `rc' {
		if _rc==199 {
			dis as err "command `func' not found"
		}
		else  	dis as err "failure running `func' on x = " %12.0g `x'
		exit `rc'
	}
	
	if "`missing'"=="" & missing(r(fx)) {
		dis as err "`func' returns missing on x = " %12.0g `x'
		exit 198
	}	
end
exit	
