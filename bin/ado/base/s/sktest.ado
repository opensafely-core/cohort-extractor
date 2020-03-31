*! version 3.1.0  16jan2015
* originally by P. Royston, modified by StataCorp

program sktest, rclass
	version 10, missing

	global S_1		/* Pr(skew)		*/
	global S_2		/* Pr(Kurtosis)		*/
	global S_3		/* chi-square(2)	*/
	global S_4		/* Pr(chi2)		*/
	
	syntax varlist [if] [in] [aw fw] [, noAdjust   /// 
		noDisplay  /// undocumented
	]
	tempvar touse
	mark `touse' `if' `in' 

	if "`adjust'" ~= "noadjust" {
		local adj "adj"
	}
	else {
		local adj "   "
	}

	tempname Utest P_skew P_kurt chi2 P_chi2 n

	scalar `P_skew' = .
	scalar `P_kurt' = . 
	scalar `chi2'   = . 
	scalar `P_chi2' = .
	
	matrix `Utest'  = J(`:list sizeof varlist', 4, .)
	matrix colnames `Utest' = P_skew P_kurt chi2 P_chi2
	matrix rownames `Utest' = `varlist'
        matrix `n' = J(`:list sizeof varlist',1,.)	
	
	local i = 0	
	foreach v of local varlist { 
		local ++i
		qui summ `v' if `touse' [`weight'`exp'], detail

		local skew st_numscalar("r(skewness)")
		local kurt st_numscalar("r(kurtosis)")
	        matrix `n'[`i',1] = `r(N)'
		if `n'[`i',1] < 8 {
			local skew .
			local kurt .
		}

		mata: SKTest( `skew', /// 
			`kurt', ///
			st_numscalar("r(N)"), ///
			"`adjust'", ///
			"`P_skew'", ///
			"`P_kurt'", /// 
			"`chi2'", ///
			"`P_chi2'" )

		matrix `Utest'[`i',1] = `P_skew'
		matrix `Utest'[`i',2] = `P_kurt'
		matrix `Utest'[`i',3] = `chi2'
		matrix `Utest'[`i',4] = `P_chi2'

		// Save in scalars for backward comp */
		return scalar P_skew = `P_skew'
		return scalar P_kurt = `P_kurt' 
		return scalar chi2   = `chi2'
		return scalar P_chi2 = `P_chi2'

		// Save in globals for backward comp */
		global S_1 `return(P_skew)'
		global S_2 `return(P_kurt)'
		global S_3 `return(chi2)'
		global S_4 `return(P_chi2)'
	}
	
	if "`display'" == "" { 
	   dis _n _col(21) as txt "Skewness/Kurtosis tests for Normality" ///
	       _n _col(59) "{hline 6} joint {hline 6}"                    ///
	       _n _col( 5) "Variable {c |}        Obs  Pr(Skewness)"      ///
	                "  Pr(Kurtosis)"                                  ///
	                " `adj' chi2(2)   Prob>chi2"                      ///
	       _n          "{hline 13}{c +}{hline 63}"
	    
	   local i = 0	    
	   foreach v of local varlist {
	      local ++i
	      dis as txt %12s abbrev("`v'",12) " {c |}" /// 
	          as res _col(16) %10.0fc `n'[`i',1]  ///
			 _col(31) %5.4f `Utest'[`i',1]  ///
	                 _col(45) %5.4f `Utest'[`i',2]  ///
	                 _col(54) %9.2f `Utest'[`i',3]  ///
	                 _col(72) %6.4f `Utest'[`i',4] 
	   }	                 
	}
	
	// last test already returned in scalars
	return matrix Utest = `Utest' 
	return matrix N = `n'
end

mata: 

void SKTest( ///
	real   scalar skewness, 
	real   scalar kurtosis,
	real   scalar n,        
	string scalar adjust,
	string scalar _P_skew,  
	string scalar _P_kurt,
	string scalar _chi2,    
	string scalar _P_chi2 )
{
	real scalar delta, alpha, logn, cut, a1, b1, b2mb1, a2, b2
	real scalar Y, Beta2, W2, Z1, Eb2, Vb2, X, RBeta1, A, Z2, K2, ZC2, Z, P
	
	if (n < 8) {
		Z = Z1 = Z2 = K2 = P = . 
	}
	else {
		Y      = skewness*sqrt(((n+1)*(n+3)) / (6*(n-2))) 		
		Beta2  = (3*(n*n+27*n-70)*(n+1)*(n+3)) / 
				((n-2)*(n+5)*(n+7)*(n+9)) 
		W2     = -1 + sqrt(2*(Beta2-1))
		delta  = 1/sqrt(log(sqrt(W2))) 
		alpha  = sqrt(2/(W2-1)) 
		Z1     = delta*log(Y/alpha + sqrt((Y/alpha)^2+1)) 
	
		Eb2    = (3*(n-1)) / (n+1)
		Vb2    = (24*n*(n-2)*(n-3)) / ((n+1)^2*(n+3)*(n+5)) 
		X      = (kurtosis-Eb2) / sqrt(Vb2) 
		RBeta1 = ((6*(n*n-5*n+2))/((n+7)*(n+9)))*sqrt((6*(n+3)*(n+5)) / 
				(n*(n-2)*(n-3)))
		A      = 6+(8/RBeta1)*(2/RBeta1 + sqrt(1+4/((RBeta1)*(RBeta1)))) 
		Z2     = ((1-2/(9*A))-((1-2/A)/(1+X*sqrt(2/(A-4))))^(1/3)) / 
				sqrt(2/(9*A)) 
		K2     = Z1*Z1 + Z2*Z2 

		// Start of P Royston modification 2.
		if (adjust ~= "noadjust") {
			ZC2   = -invnormal(exp(-0.5*K2))
			logn  = log(n)
			cut   = .55*(n^.2)-.21
			a1    = (-5+3.46*logn)*exp(-1.37*logn)
			b1    = 1+(.854-.148*logn)*exp(-.55*logn)
			b2mb1 = 2.13/(1-2.37*logn)
			a2    = a1-b2mb1*cut
			b2    = b2mb1+b1
			
			if (ZC2 < -1)
				Z = ZC2
			else if (ZC2 < cut)
				Z = a1+b1*ZC2
			else 
				Z = a2+b2*ZC2
				
			P  = 1 - normal(Z)
			K2 = -2*log(P)
		}
		else {
			P  = chi2tail(2,K2)
		}
	}	

	st_numscalar( _P_skew, 2-2*normal(abs(Z1)) )
	st_numscalar( _P_kurt, 2-2*normal(abs(Z2)) )
	st_numscalar( _chi2  , K2 )
	st_numscalar( _P_chi2, P  )
}
end
exit
		/*
			modification 2.

			Empirical adjustment to chi-square(2) statistic.
			ZC2 is normal deviate corresponding to putative
			chisq(2) K2. This is adjusted to a final normal
			deviate Z, from which the P-value for the test
			is calculated as its upper tail area.

			The original chi-sq is adjusted so that the reported
			P value is the same as would be obtained from tables.
			Also the P value for kurtosis is adjusted.
		*/
