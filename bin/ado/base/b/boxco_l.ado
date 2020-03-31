*! version 1.1.3  25aug2009
program define boxco_l
	version 7
	`0'
end


program define RHS
	args todo b lnf

	tempname lam diff sigma sigma
	tempvar err 

	scalar `lam'=`b'[1,1]
	scalar `diff' = reldif( `lam' , 0.0)             

	tokenize $T_parm

	local i 1
	local rhs

	if `diff'<1e-10 {
		while "``i''" != "" {
			tempvar r`i'
			quietly gen double `r`i''=ln(``i'')
			local rhs `rhs' `r`i''
			local i = `i' + 1
		}
	}
	else {
		while "``i''" != "" {
			tempvar r`i'
			quietly gen double `r`i''=(``i''^`lam' -1)/`lam'
			local rhs `rhs' `r`i''
			local i = `i' + 1
		}
	}

	quietly	{
	
		capture _regress $ML_y1 $T_notr `rhs' $T_wtexp 	/*
			*/ if $ML_samp, $T_nocns
		if _rc {
			 quietly replace `lnf' = .
			 exit
		}

		matrix $T_bvec=e(b)
		if "$T_nocns" == "" {
			local names1 "$T_notr $T_parm _cons"
		}
		else {
			local names1 "$T_notr $T_parm"
		}

		matrix colnames $T_bvec=`names1'
		predict double `err', residuals
		replace `err'=`err'^2
		*summ `err' $T_wtexp if $ML_samp, meanonly 
    		*scalar `sigma'=r(mean)
		*scalar $T_sig=r(mean)
				/* use -_regress- to take iweights */
		_regress `err' $T_wtexp if $ML_samp
		scalar `sigma' = _b[_cons]
		scalar $T_sig  = _b[_cons]
	}

	quietly replace `lnf' = -.5*(1 + ln(2*_pi)+ ln(`sigma') )

end



program define ConsOnly
	args todo b lnf 

	tempname diffL theta ssq 	/* theta is theta for Lhs etc */
	tempvar err yt

	scalar `theta' = `b'[1,1] /* this is theta */
	
	scalar `diffL'=reldif( `theta', 0)
	
	quietly {
		if  (`diffL' > 1e-10 ) {
			gen double `yt'= ( $ML_y1^`theta'-1)/`theta'
		}
		else {
			gen double `yt' = ln($ML_y1)
		}
		capture _regress `yt' $T_wtexp if $ML_samp
		if _rc {
			 quietly replace `lnf' = .
			 exit
		}
		predict double `err' if $ML_samp, residuals
		replace `err'=`err'^2
		*summ `err' $T_wtexp if $ML_samp
		*scalar `ssq'=r(mean)
		_regress `err' $T_wtexp if $ML_samp
		scalar `ssq' = _b[_cons]
	}	
	quietly replace `lnf' = /*
	        */ -.5*(ln(2*_pi) +1 ) + /*
	        */  (`theta'-1)*(ln($ML_y1)) /*
	        */  -.5*(ln( `ssq') )
end


program define LHS
	args todo b lnf 

	tempname theta ssq diffL 	/* theta is theta for Lhs */
	tempvar err yt
	
	scalar `theta' = `b'[1,1] 		/* this is theta */
	scalar `diffL'=reldif( `theta', 0)

	if `diffL'> 1e-10 {
		qui gen double `yt' =( ( $ML_y1^`theta'-1)/`theta' )
	}
	else {
		qui gen double `yt' = ln( $ML_y1 )
	}

	 quietly {
		capture _regress `yt' $T_notr $T_wtexp if $ML_samp, $T_nocns
		if _rc {
			 quietly replace `lnf' = .
			 exit
		}
	
		matrix $T_bvec=e(b)
		predict double `err' if $ML_samp, residuals
		replace `err'=`err'^2
	  
		*summ `err' $T_wtexp if $ML_samp, meanonly 
		*scalar `ssq'=(r(mean) )
		*global T_sig = `ssq'
		_regress `err' $T_wtexp if $ML_samp
		scalar `ssq' = _b[_cons]
		global T_sig  = _b[_cons]
	}

	 quietly replace `lnf' = /*
	      */ -.5*(ln(2*_pi) +1 ) + (`theta'-1)*(ln($ML_y1)) /*
	      */  -.5*(ln( `ssq') )
end


program define Theta
	args todo b lnf 

	/*	theta3 is theta for Lhs
		theta4 is lambda for Rhs
	   	etc */
	tempname theta lambda ssq thetat diffR diffL
	tempvar err yt

	scalar `lambda'= `b'[1,1]
	scalar `theta' = `b'[1,2]

	scalar `diffR'=reldif( `lambda', 0)
	scalar `diffL'=reldif( `theta', 0)
	
	quietly {
		if  `diffL' > 1e-10 {
			gen double `yt' = ($ML_y1^`theta'-1)/`theta' 
		}
		else {
			gen double `yt'  =   ln($ML_y1) 
		}

		tokenize $T_parm
		if `diffR' > 1e-10 {
			local i 1
			local rhs
			while "``i''" != "" {
				tempvar r`i'
				gen double `r`i''=(``i''^`lambda' -1)/`lambda' 
	    			local rhs `rhs' `r`i''
				local i=`i' +1
			}
		}
		else {
			local i 1
			local rhs
			while "``i''" != "" {
				tempvar r`i'
				gen double `r`i'' = ln(``i'')
				local rhs `rhs' `r`i''
				local i=`i' +1
			}
		}

		capture _regress `yt' $T_notr `rhs' $T_wtexp if $ML_samp, /*
			*/ $T_nocns
		if _rc {
			 quietly replace `lnf' = .
			 exit
		}

		matrix $T_bvec=e(b)
		predict double `err' if $ML_samp, residuals
		replace `err'=`err'^2
		*summ `err' $T_wtexp if $ML_samp, meanonly 
		*scalar `ssq'=r(mean)
		*scalar $T_sig = `ssq'
		capture _regress `err' $T_wtexp if $ML_samp
		if _rc {
			 quietly replace `lnf' = .
			 exit
		}
		scalar `ssq' = _b[_cons]
		scalar $T_sig  = _b[_cons]
	}

	 quietly replace `lnf' = /*
	      */ -.5*(ln(2*_pi) +1 ) + /*
	      */  (`theta'-1)*(ln($ML_y1)) /*
	      */  -.5*(ln( `ssq') )
end

program define Lambda
	args todo b lnf 

	/*	theta is theta for Lhs
		theta4 is lambda for Rhs
	 	etc */
	tempname lambda  ssq diff
	tempvar err yt

	scalar `lambda'= `b'[1,1]
	scalar `diff'=reldif( `lambda', 0.0)

	quietly {
		if  (`diff' > 1e-12 ) {
			 gen double `yt' = ($ML_y1^`lambda' -1 )/`lambda'
			 tokenize $T_parm
			 local i 1
			 local rhs

			 while "``i''" != "" {
				 tempvar r`i'
				 gen double `r`i'' = (``i''^`lambda' -1 ) /*
					*/ /`lambda'
				 local rhs `rhs' `r`i''
				 local i=`i' +1
			 }
		}
		else {
			 gen double `yt' = ln($ML_y1)
			 tokenize $T_parm
			 local i 1
			 local rhs 

			 while "``i''" != "" {
				 tempvar r`i'
				 gen double `r`i'' = ln(``i'')
				 local rhs `rhs' `r`i''
				 local i=`i' +1
			 }
		}

		capture _regress `yt' $T_notr `rhs' $T_wtexp 	/*
			*/ if $ML_samp , $T_nocns
		if _rc {
			 quietly replace `lnf' = .
			 exit
		}

	 	matrix $T_bvec=e(b)
		predict double `err' if $ML_samp, residuals
		replace `err'=`err'^2	
		*summ `err' $T_wtexp if $ML_samp, meanonly 
		*scalar `ssq'=r(mean)
		*scalar $T_sig = `ssq'
		_regress `err' $T_wtexp if $ML_samp
		scalar `ssq' = _b[_cons]
		scalar $T_sig  = _b[_cons]
	}
	
	quietly replace `lnf' = /*
	      */ -.5*(ln(2*_pi) +1 ) + /*
	      */  (`lambda'-1)*(ln($ML_y1)) /*
	      */  -.5*(ln( `ssq') )

end
