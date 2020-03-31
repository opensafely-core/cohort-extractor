*! version 2.2.1  09sep2019
program tetrachoric, rclass byable(recall)
        version 9

        #del ; 
        syntax  varlist(min=2 numeric)
                [if] [in] [fw]
        [, 
        	STATS(str) 
        	EDwards
        	Print(numlist min=1 max=1 >=0 <=1) 
        	STar(numlist  min=1 max=1 >=0 <=1) 
        	Bonferroni 
        	SIDak 
		pw 
		MATrix
		noTABle          
		POSdef
		ZEroadjust
	// undocumented
		AVAILable        // synonym for pw
		BIPROBIT 	 // undocumented
		FORmat(passthru) // ignored
	];
	#del cr

// ------------------------------------------------------- variables and sample

	local zero `zeroadjust'
	if "`available'" != "" { 
		local pw pw 
	}
	if "`pw'" != "" { 
		marksample touse, novarlist
	}
	else 	marksample touse

	local nvar : word count `varlist'
	
	if "`weight'" != "" {
		local wght "[`weight'`exp']"
	}

	quietly summ `touse' `wght' if `touse', meanonly
	local N = r(N)
	if `N' == 0 {
		error 2000
	}

// ------------------------------------------------------------ check arguments

	if "`bonferroni'"!="" & "`sidak'"!="" {
		dis as err "only one of bonferroni and sidak " ///
                           "can be specified"
		exit 198
	}
	if "`star'" == "" { 
		local star  = -1   /* pvalue never < 0, so no stars */
	}
	if "`print'" == "" {
		local print = -1
	}

 	Stats "`stats'" 
 	local stats `s(stats)' 
  	if "`stats'" == "" { 
 		local stats rho
 	}	

// -------------------------------------------------------------------- scratch 

	tempname f mdiff nneg nobs rho ase p NObs P Rho Se 

// ----------------------------------------------- check: only binary variables 

	tokenize `varlist'
	forvalues i = 1/`nvar' {
		capture assert inlist(``i'',0,1) if `touse' & !missing(``i'')
		if _rc {
			dis as err "variable ``i'' is not 0/1 coded"
			exit 198
		}
	}	

// ----------------------------------- Collect statistics in symmetric matrices

	matrix `NObs' = J(`nvar',`nvar',.)
	matrix rownames `NObs' = `varlist'
	matrix colnames `NObs' = `varlist'

	matrix `Rho' = I(`nvar')
	matrix rownames `Rho' = `varlist'
	matrix colnames `Rho' = `varlist'
	
	matrix `Se' = J(`nvar',`nvar',0)
	matrix rownames `Se' = `varlist'
	matrix colnames `Se' = `varlist'

	matrix `P' = J(`nvar',`nvar',0)
	matrix rownames `P' = `varlist'
	matrix colnames `P' = `varlist'
	
	if "`edwards'" == "" {
		local method ml
		if "`biprobit'" == "" { 
			local EstCmd TetraML
		}
		else	local EstCmd TetraML_biprobit		
	}	
	else	{
		local method Edwards
		local EstCmd TetraEdwards
	}	

	forvalues i = 1/`nvar' {

		qui tab ``i'' `wght' if `touse', matcell(`f')
		if r(N) == 0 {
			dis as err "variable ``i'' has no observations"
			exit 2000
		}
		if rowsof(`f') == 1 {
			dis as err "variable ``i'' does not vary"
			exit 198
		}
		matrix `NObs'[`i',`i'] = r(N)

		forvalues j = 1/`=`i'-1' {

			qui count if `touse' & !missing(``i'') & !missing(``j'')
			if r(N) == 0 {
				scalar `nobs' = 0
				scalar `rho'  = .
				scalar `ase'  = .
				scalar `p'    = . 
			}
			else {
				qui tab ``i'' ``j'' `wght' if `touse', /// 
				    matcell(`f') exact

				if rowsof(`f')==2 & colsof(`f')==2 & r(N)>0 { 
					scalar `nobs' = r(N)
					matrix `p'    = r(p_exact)
				
					if `"`zero'"'!="" {
						AdjustFreq `f'  
					}
					`EstCmd' `f' `rho' `ase'   
				}
				else {
					scalar `nobs' = .
					scalar `rho'  = .
					scalar `ase'  = .
					scalar `p'    = . 
				}
			}

			matrix `NObs'[`i',`j'] = `nobs' 
			matrix `NObs'[`j',`i'] = `nobs' 

			matrix    `P'[`i',`j'] = `p'
			matrix    `P'[`j',`i'] = `p'

			matrix  `Rho'[`i',`j'] = `rho'
			matrix  `Rho'[`j',`i'] = `rho'
			
			matrix   `Se'[`i',`j'] = `ase'
			matrix   `Se'[`j',`i'] = `ase'

		}
	}
	
// ----------------------------------------------- positive definiteness of Rho

	PosDef `Rho'
	
	scalar `nneg'  = r(nneg) 
	scalar `mdiff' = r(mdiff)
	
	local RhoChanged = !missing(`nneg') & (`nneg'>0) & ("`posdef'"!="") 
	if `RhoChanged' {
		matrix `Rho' = r(psdR)
		
		local tobeignored se p
		local ignored : list stats & tobeignored
		if "`ignored'" != "" { 
			dis as txt "(`ignored' ignored)" 
			local stats : list stats - ignored
		}

		if "`bonferroni'" != "" {
			dis as txt "(bonferroni ignored)"
			local bonferroni
		}	
		if "`sidak'" != "" {
			dis as txt "(sidak ignored)"
			local sidak
		}	
		if `star' != -1 {
			dis as txt "(star() ignored)" 
			local star -1
		}
		if `print' != -1 { 
			dis as txt "(print() ignored)" 
			local print -1
		}
	}

// --------------------------------------- adjust p-values for multiple testing

	if "`bonferroni'`sidak'" != "" { 
		local nrho = 0
		forvalues i = 1/`nvar' { 
			forvalues j = 1 / `=`i'-1' {
				if (`P'[`i',`j'] != .) local ++nrho
			}
		}
		
		if "`bonferroni'" != "" { 
			forvalues i = 1/`nvar' { 
				forvalues j = 1 / `=`i'-1' {
					matrix `P'[`i',`j'] = /// 
					   min(1,`nrho'*`P'[`i',`j']) 
					matrix `P'[`j',`i'] = `P'[`i',`j']
				}
			}
		}
		else if "`sidak'" != "" { 
			forvalues i = 1/`nvar' { 
				forvalues j = 1 / `=`i'-1' {
					matrix `P'[`i',`j'] = /// 
					   min(1,1-(1-`P'[`i',`j'])^`nrho')
					matrix `P'[`j',`i'] = `P'[`i',`j']
				}	
			}
		}
	}

// -------------------------------------------------------------------- output

	if "`table'" == "" { 
		if (`nvar' <= 2) & ("`matrix'" == "") {
			TwovarDisplay "`1'" "`2'" `NObs' `Rho' `Se' `P' 
		}
		else {
			MatrixDisplay "`varlist'" /// 
			   `NObs' `Rho' `Se' `P' `RhoChanged' /// 
			   `nneg' `mdiff' "`stats'" `star' `print'  
		}
	}	

// ------------------------------------------------------------- return results

	return local method `method' 

	return scalar N    = `NObs'[1,2]
	return scalar rho  = `Rho'[1,2]
	return scalar nneg = `nneg'

	return matrix Nobs = `NObs' 
	return matrix Rho  = `Rho', copy 
	return hidden matrix corr = `Rho'   // compatibility with version 1 

	if !`RhoChanged' { 
		return scalar se_rho = `Se'[1,2]
		return scalar p      = `P'[1,2]	

		return matrix Se_Rho = `Se' 
		return matrix P      = `P'  
	}
end

// ----------------------------------------------------------------------------
// Subroutines
// ----------------------------------------------------------------------------

// parses the stats() argument, returning unabbreviated arguments in the
// original order, without duplicates
program Stats, sclass
	args opts

	foreach s of local opts { 
		local 0 ,`s'
		syntax [, Obs p Rho Se]
		local stats `stats'  `obs' `p' `rho' `se' 
	}
	local stats : list uniq stats

	sreturn clear
	sreturn local stats `stats' 
end


// checks that correlations are positive definite
// optionally chopping negative eigenvalues at 0
program PosDef, rclass
	args R 

	if !issym(`R') {
		error 505
	}
	
	if matmissing(`R') {
		return scalar nneg    = .
		exit
	}	

	tempname evec eval mdiff psdR tol 

	matrix symeig `evec' `eval' = `R'

	local n = colsof(`R')	
	scalar `tol' = 0
	forvalues j = 1/`n' {
		scalar `tol' = `tol' + abs(`eval'[1,`j'])
	}
	scalar `tol' = -1e-12 * `tol'

	local nneg = 0
	forvalues j = 1/`n' {
		if (`eval'[1,`j']<`tol') local ++nneg
	}

	if `nneg' > 0 { 
		forvalues j = 1/`n' {
			if (`eval'[1,`j']<0) matrix `eval'[1,`j'] = 0
		}	
		matrix `psdR' = corr(`evec'*diag(`eval')*`evec'')
		
		scalar `mdiff' = 0
		forvalues i = 1/`n' {
			forvalues j = 1/`=`i'-1' {
				scalar `mdiff' = max( `mdiff' , ///
				  abs(`R'[`i',`j'] - `psdR'[`i',`j']))
			}
		}
		return scalar mdiff = `mdiff'
		return matrix psdR  = `psdR' 
	}
	return scalar nneg = `nneg' 
end


program AdjustFreq
	args f
	
	if ( (`f'[1,1]==0) + ///
	     (`f'[1,2]==0) + ///
	     (`f'[2,1]==0) + ///
	     (`f'[2,2]==0)) == 1 {
	    
	    if (`f'[1,1]==0) | (`f'[2,2]==0) {
	    	local d = 1 
	    }
	    else {
	    	local d = -1
	    }	
	    
	    matrix `f' = `f'+ (`d'/2)*(1,-1\-1,1)
	}
end	


// computes the ml estimator for tetrachoric correlations
// algorithm adopted from Brown (1977), Applied Statistics
//
program TetraML
	args f rho se
	
	assert rowsof(`f')==2 & colsof(`f')==2
	mata: tetra("`f'","`rho'", "`se'") 

	if (abs(`rho')==1) scalar `se' = .
end


// computes the ml estimator for tetrachoric correlations
// using the one-step Edwards estimator as initial value
//
program TetraML_biprobit
	args f rho ase

	tempname alpha b erho est nobs
	_estimates hold `est', restore null 

	if c(N) < 4 { 
		preserve
		quietly set obs 4
	}	

	tempvar y1 y2 fr	
	qui gen `y1' = mod(_n-1,2) in 1/4
	qui gen `y2' = int((_n-1)/2) in 1/4
	qui gen `fr' = .

	matrix `b' = J(1,3,.)
	matrix colnames `b' = `y1':_cons  `y2':_cons  athrho:_cons
	
	// initialize using Edwards estimator of rho
	// note that biprobit estimates in arctanh(rho) metric 
	if (`f'[1,2]==0) | (`f'[2,1]==0) {
		scalar `erho' =  0.95
	}
	else if (`f'[1,1]==0) | (`f'[2,2]==0) {
		scalar `erho' = -0.95
	}
	else {
		scalar `alpha' = ((`f'[1,1]*`f'[2,2])/ ///
		                  (`f'[1,2]*`f'[2,1]))^(_pi/4)
		scalar `erho'  = (`alpha'-1)/(`alpha'+1)
	}
		
	scalar `nobs'   = `f'[1,1]+`f'[1,2]+`f'[2,1]+`f'[2,2]
	matrix `b'[1,1] = invnormal((`f'[2,1]+`f'[2,2])/`nobs')
	matrix `b'[1,2] = invnormal((`f'[1,2]+`f'[2,2])/`nobs')
	matrix `b'[1,3] = 0.5*ln((1+`erho')/(1-`erho')) 

	// setup data

	qui replace `fr' = `f'[1,1] in 1
	qui replace `fr' = `f'[1,2] in 2
	qui replace `fr' = `f'[2,1] in 3
	qui replace `fr' = `f'[2,2] in 4

	// ml estimation with biprobit (use iweights for non-integer weights)

	capture biprobit `y1' `y2' [iw=`fr'], iter(20) from(`b') nolog
	
	if _rc == 0 { 
		scalar `rho' = e(rho)
		scalar `ase' = cond( abs(`rho') > .999, ., ///
		                 (1-`rho'^2)*_se[athrho:_cons] )
	}
	else {
		scalar `rho' = .
		scalar `ase' = . 
	}	
end


// computes Edwards' estimator for tetrachoric correlations
//
program TetraEdwards
	args f rho ase 
	assert rowsof(`f')==2 & colsof(`f')==2

	tempname alpha h
		
	if (`f'[1,2]==0) | (`f'[2,1]==0) {
		scalar `rho' = 1
		scalar `ase' = .
	}
	else if (`f'[1,1]==0) | (`f'[2,2]==0) {
		scalar `rho' = -1
		scalar `ase' = .				
	}
	else {
		scalar `alpha' = ((`f'[1,1]*`f'[2,2])/ ///
		                  (`f'[1,2]*`f'[2,1]))^(_pi/4)
		                  
		scalar `rho'   = (`alpha'-1)/(`alpha'+1)
		
		scalar `h'     = 1/`f'[1,1] + 1/`f'[1,2] + /// 
		                 1/`f'[2,1] + 1/`f'[2,2]
		                 
		scalar `ase'   = sqrt(`h') * (_pi/2) ///
		                 * (`alpha'/(`alpha'+1)^2)
	}
end


// Displays results for two variables (v1 and v2) only

program TwovarDisplay
	args v1 v2 NObs RHO SE P

	dis
	dis as txt "   Number of obs = " as res %12.0fc `NObs'[1,2]
	dis as txt " Tetrachoric rho = " as res %12.4f  `RHO'[1,2]

	dis as txt "       Std error = " as res %12.4f `SE'[1,2] 
	dis
	dis as txt "Test of Ho: " abbrev("`v1'",20) " and " ///
	    abbrev("`v2'",20) " are independent" 
	dis as txt " 2-sided exact P = " as res %12.4f `P'[1,2] 
end


// utility used by MatrixDisplay
//
program KeyLine 
	args txt 
	dis as txt "{c |}" _skip(2) `"{it: `txt'}"' _col(21) "{c |}"
end	


// Displays results for >=2 variables in matrix style
//
program MatrixDisplay
	args varlist NObs RHO SE P RhoChanged nneg mdiff stats star print 

	local nvar: word count `varlist' 
	tokenize `varlist' 

	// number of observations (if not in table)

       	if !strpos("`stats'","obs") {
           local varies = 0 
       	   if "`pw'" != "" { 
       	      forvalues i = 1/`nvar' {
       	         forvalues j = 1/`i' {
       	            if (`NObs'[`i',`j']!=`NObs'[1,2]) {
       	               local varies 1 
       	            }	
       	         }
       	      }
       	   }
           if `varies' == 0 {
	      local nobs : display %10.0fc `NObs'[1,2]
	      local nobs : list retok nobs
	      dis as txt "(obs=`nobs')"
	   }
	   else {
	      dis as txt "(obs=varies)"	
	   }
	}

	// produce a key 

	if "`stats'" != "rho" {
	   dis
	   dis as txt "{c TLC }{hline 19}{c TRC}"
	   dis as txt "{c |}" _skip(2) "Key" _col(21) "{c |}"
       	   dis as txt "{c LT }{hline 19}{c RT}"
       	   foreach s of local stats { 
       	      if ("`s'" == "rho") KeyLine "rho" 
       	      if ("`s'" == "obs") KeyLine "Number of obs" 
       	      if ("`s'" == "se" ) KeyLine "Std. error" 
       	      if ("`s'" == "p"  ) KeyLine "2-sided exact P" 
       	   }
	   dis as txt "{c BLC }{hline 19}{c BRC}"
	}

	if (`nneg' != .) & (`nneg' > 0) { 
	   dis
	   dis as txt "matrix with tetrachoric correlations is not" /// 
	              " positive semidefinite;" 
	   dis as txt "  it has " as res `nneg' /// 
	       as txt " negative " plural(`nneg',"eigenvalue") 
	   dis as txt "  maxdiff(corr,adj-corr) = " as res %7.4f `mdiff'
	   dis as txt "  (adj-corr: tetrachoric correlations" ///
	              " adjusted to be positive semidefinite)"
	}
	if (`RhoChanged') local header = "adj-corr"
	
	local start = int((c(linesize)-15)/9)-1 
	local j0 = 1
	while (`j0'<=`nvar') {
	   dis
	   local j1 = min(`j0'+`start',`nvar')

	   dis as txt "{ralign 12:`header'} {c |}" _c
	   forvalues j = `j0'/`j1' {
	      dis as txt %9s abbrev("``j''",8) _c
	   }

	   local l = 9*(`j1'-`j0'+1)
	   dis as txt _n "{hline 13}{c +}{hline `l'}"

	   forvalues i = `j0'/`nvar' {
	      local first 1
	      foreach s of local stats { 
	         if `first' { 
	            dis as txt %12s abbrev("``i''",12) " {c |} "_c
	         }
	         else dis as txt _skip(13) "{c |} " _c

	         if "`s'" == "rho" {
	            forvalues j = `j0'/`=min(`j1',`i')' {
	               if `P'[`i',`j']<=`star' & `i'!=`j' {
                          local ast "*" 
	               }
	               else local ast " "

	               if `P'[`i',`j']<=`print' | `print'==-1 | `i'==`j' {
	                  dis as res " " %7.4f `RHO'[`i',`j'] "`ast'" _c
	               }
	               else dis _skip(9) _c
	            }
	         }

	         if "`s'" == "se" {
	            forvalues j = `j0'/`=min(`j1',`i')' {
	               if `P'[`i',`j']<=`print' | `print' == -1 {
	                  dis as res " " %7.4f `SE'[`i',`j'] " " _c
	               }
	               else dis _skip(9) _c
	            }	
	         }

	         if "`s'" == "p" {
	            forvalues j = `j0'/`=min(`j1',`i'-1)' {
	               if (`P'[`i',`j']<=`print' | `print'==-1) & (`j'<`i') {
	                  dis as res " " %7.4f `P'[`i',`j'] " " _c
	               }
	               else dis _skip(9) _c
	            }	
	         }

	         if "`s'" == "obs" {
	            forvalues j = `j0'/`=min(`j1',`i')' {
	               if `P'[`i',`j']<=`print' | `print'==-1 | `i'==`j' {
	                  dis as res " " %7.0g `NObs'[`i',`j'] " " _c
	               }
	               else dis _skip(9) _c
	            }
	         }

	         dis
	         local first 0
	      }

	      if (`:word count `stats'' > 1) {
	         dis as txt _skip(13) "{c |}"
	      }
	   }

	   local j0 = `j0'+`start'+1
	}
end

// -----------------------------------------------------------------------------
// Mata implementation of maximum-likelihood 
// -----------------------------------------------------------------------------

mata:

// interface Stata <--> Mata
void function tetra( string scalar _f, string scalar _rho, string scalar _se )
{
	real scalar rho, se, ifail
	real matrix f

	pragma unset rho
	pragma unset se
	pragma unset ifail
	
	f = st_matrix(_f)
	
	_tetra(f[1,1], f[1,2], f[2,1], f[2,2], rho, se, ifail)
	
	st_numscalar(_rho, rho)
	st_numscalar(_se,  se)
}


// Computes tetrachoric correlation of frequencies 
//
//     a  b     f[1,1]   f[1,2]
//     c  d     f[2,1]   f[2,2]
//
// We adjusted the algorithm proposed by Brown (1977)
//   - we use an analytical derivative (using Plackett 1957),
//     rather than a finite difference
//   - We use Edwards estimator as initial value
//   - We use the internal Stata functions invnormal() and 
//     binormal() 

void function _tetra( real scalar a,   real scalar b,
                      real scalar c,   real scalar d,
                      real scalar rho, real scalar se, 
                      real scalar ifault ) 
{
	real scalar   alpha, dp, i, n, p, rhoprev, step, z1, z2, Z1, Z2 

	n  = a + b + c + d 
	z1 = invnormal((a+c)/n)
	z2 = invnormal((a+b)/n)
			
// special case: cells with zero frequencies

	ifault = 0;
	se     = .
	if ((a==0) | (b==0) | (c==0) | (d==0)) {
		if ((a==0) & (d==0)) {
			rho = -1;  return;
		}
		else if ((b==0) & (c==0)) {
			rho =  1;  return;
		}
		else if (abs(binormal(z1,z2,1) - (a/n)) < 1e-7) {
			rho = 1;  return;  
		}
		else if (abs(binormal(z1,z2,-1) - (a/n)) < 1e-7) {
			rho = -1;  return; 
		}
	}

// use Edwards estimator as starting value 

	if ((b==0) | (c==0)) {
		rho  =  0.95
	}
	else if ((a==0) | (d==0)) {
		rho  = -0.95
	}
	else {
		alpha = ((a*d)/(b*c))^(pi()/4)
		rho   = (alpha-1)/(alpha+1)
	}

	// Newton-Raphson solution of a/n = E(a/n) = Phi(m1,m2,rho)
	// expression of derivative of binormal() w.r.t. rho is due 
	// to Plackett (1954) 

	ifault = 1
	for (i=1; ifault==1 & i<=100; i++) { 
		rhoprev = rho
		
		p  = binormal(z1,z2,rho) - (a/n)
		dp = exp(-(z1^2 - 2*rho*z1*z2 + z2^2)/(2*(1-rho^2))) / 
		    (2*pi()*sqrt(1-rho^2))
	
		step = 1
		while (abs(rho - step*p/dp) > 1) {
			step = step/2
		}	
		rho = rho - step*p/dp
		
		if ((abs(rho - rhoprev) < 1e-8) & (abs(p) < 1e-6)) {
			ifault = 0
		}	
	}

	if (ifault != 0) {
		rho = .
		se  = .
		return
	}
	
	// ase, see Brown (1977)
	
        Z1 = normal( (z1-rho*z2)/sqrt(1-rho^2) ) - 0.5
	Z2 = normal( (z2-rho*z1)/sqrt(1-rho^2) ) - 0.5
		
	dp = exp(-(z1^2 - 2*rho*z1*z2 + z2^2)/(2*(1-rho^2))) / 
	     (2*pi()*sqrt(1-rho^2))		

	se = 0.25*(a+d)*(b+c) +
	     (a+c)*(b+d)*(Z2^2) + 
	     (a+b)*(c+d)*(Z1^2) + 
	     2*(a*d-b*c)*(Z1*Z2) - 
	     (a*b-c*d)*Z2 - 
	     (a*c-b*d)*Z1
	se = sqrt(max((0,se))) / (n^(3/2) * dp)
	
	if (abs(rho)==1) se = .
}
end

exit
