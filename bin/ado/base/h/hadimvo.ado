*! version 1.3.0  19apr2007
program hadimvo, rclass
	version 6, missing
	syntax varlist [if] [in], Generate(string) [ P(real .05) ]

	tokenize `"`generat'"'
	if `"`3'"'!="" { error 198 }
	local marker `1'
	local Dvar `2'		/* may be null */
	confirm new var `marker' `Dvar'

	if (`p'>=1) { local p=`p'/100 }
	if (`p'<=0 | `p'>=1) { 
		noi di in red "p() invalid"
		exit 198
	}

	marksample touse
	tokenize `varlist'

	tempvar u new D gen

	quietly gen `gen' = 0 if `touse'
	label var `gen' `"Hadi outlier (p=`p')"'

	quietly { 
		gen `u'=uniform() if `touse'
		reg `u' `varlist' if `touse'
		if e(N)==0 | e(N)>=. { noisily error 2001 }
		local N=e(N)

		local i 1
		while `"``i''"'!="" { 
			if _b[``i'']==0 { 
				noi di in blu /*
		      */ `"(note:  ``i'' dropped because of collinearity)"'
				local `i' " "
			}
			local i=`i'+1
		}
		tokenize `*'

		if 3*(`i'-1)+1 >= `N' { 		/* i-1 = k */
			noi di in red "sample size of " `N' /* 
			*/ " <= 3k+1 (k=" `i'-1 ", 3k+1=" 3*(`i'-1)+1 ")"
			exit 2001
		}

		noi di in gr _n "Beginning number of observations:  " /* 
			*/ in ye %12.0f `N'


/*
	Define 	D_i(C,V) = (x_i-C)'inv(V)(x_i-C)

	Step 0:  initial ordering.

	Compute 	D_i(C,S) where 
			C = medians
			S = (x_i-C)'(x_i-C)/(N-1)

	Note, in regress notation, hat = x_i inv(X'X) x_i'
	Ignoring factor 1/(N-1), we regress noise on X=(x_i-C) and retrieve hat.

	Sort by D_i(C,S), set v_i=1 if i<=int(N+p+1)/2)
*/

		noi di in gr _col(15) "Initially accepted:  " _c
		local i 1
		while `"``i''"'!="" {
			tempvar new
			summ ``i'' if `touse', detail
			gen `new'=(``i'')-r(p50) if `touse'
			local newvars `"`newvars' `new'"'
			local i=`i'+1
		}
		local k=`i'-1			/* p in Hadi notation	*/

		reg `u' `newvars' if `touse', nocons
		_predict `D' if `touse', hat
		sort `D'			/* missing to end	*/
		local r = int((`N'+`k'+1)/2)

/*
	Compute D_i(C,S), where 
		C = mean of x over 1/`r' obs
		S = (x_i-C)'(x_i-C) over 1/`r' obs
*/
		drop `newvars'
		local newvars
		local i 1
		while `"``i''"'!="" {
			tempvar new
			summ ``i'' if `touse' in 1/`r'
			gen `new'=(``i'')-r(mean) if `touse'
			local newvars `"`newvars' `new'"'
			local i=`i'+1
		}
		reg `u' `newvars' if `touse' in 1/`r', nocons
		drop `D'
		_predict `D' if `touse', hat
		sort `D'			/* missing to end	*/
		local r = `k'+1
		noi di /* init accepted */ in ye %12.0f `r'

/* Step 1 */

		local half=int((`N'+`k'+1)/2)
		reg `u' `newvars' if `touse' in 1/`r', nocons
		if e(df_m)!=`k' {
			noi di in gr _col(7) ///
				"Expand because of collinearity:  " _c
			while (e(df_m)!=`k') { 
				local r = `r' + 1
				if `r'>`half' {
					#delimit ;
					noi di in red _n(2)
				"Expansion to int((n+k+1)/2)=" `half'
				" observations still results in singular" _n
			"covariance matrix (collinearity among variables)." ;
					#delimit cr 
					error 399
				}
				reg `u' `newvars' if `touse' in 1/`r', nocons
			}
			noi di in ye %12.0g `r'
		}

/* Steps 2 and 3 */
		noi di in gr _col(14) "Expand to (n+k+1)/2:  " _c
		_maked `D' `touse' `r' `u' `"`varlist'"'
		while `r'<int((`N'+`k'+1)/2) {
			local r=`r'+1
			_maked `D' `touse' `r' `u' `"`varlist'"'
		}
		noi di in ye %12.0g `r'

/* step 4 */
		local msg `"Expand,  p = `p':  "'
		local len = 36 - length(`"`msg'"')
		noi di in gr _col(`len') `"`msg'"' _c
		local cf=( 1+2/(`N'-1-3*`k')+(`k'+1)/(`N'-`k') )^2
		_maked `D' `touse' `r' `u' `"`varlist'"'
		replace `D'=(`r'-1)*`D'/`cf'

		local aon = `p'/`N'
/*
		_crcichi `aon' `k'
		local chi2 =r(chi2)
*/
		local chi2 = invchi(`k',`aon')

		while `D'[`r'+1]<`chi2' {
			if `N'==`r'+1 { 
				noi di in ye %12.0g `N'
				noi di in gr _col(15) "Outliers remaining:  " /*
					*/ in ye %12.0g 0
				ret scalar N = 0 
				if `"`Dvar'"'!="" {
					replace `D'=sqrt(`D')
					label var `D' `"Hadi distance (p=`p')"'
					rename `D' `Dvar'
				}
				rename `gen' `marker'
				exit
			}
			local r=`r'+1
			_maked `D' `touse' `r' `u' `"`varlist'"'
			replace `D'=(`r'-1)*`D'/`cf'
		}
		noi di in ye %12.0g `r'
		local r=`r'+1
		replace `gen'=1 if `touse' & `D'>=`chi2'
		count if `gen'==1
		noi di in gr _col(15) /*
		*/ "Outliers remaining:  " in ye %12.0g r(N)
		ret scalar N = r(N)
		if `"`Dvar'"'!="" {
			replace `D'=sqrt(`D')
			label var `D' `"Hadi distance (p=`p')"'
			rename `D' `Dvar'
		}
		rename `gen' `marker'
	}
end


program _maked /* D touse r lhs rhs */
	args D touse r u rhs

	capture drop `D'
	reg `u' `rhs' if `touse' in 1/`r'
	_predict `D' if `touse', hat
	replace `D'=`D'-1/e(N)
	sort `D'			/* missing to end	*/
end



exit

program _crcichi, rclass /* p df */
	tempname p xlo flo xhi fhi x f x0 fp
	scalar `p' = `1'
	local df `2'
	if (`p'>.5) { 
		scalar `xlo' = 0
		scalar `flo' = 1
		scalar `xhi' = `df'
		scalar `fhi' = chiprob(`df',`xhi')
		scalar `x'=(`xlo'+`xhi')/2
		scalar `f'=chiprob(`df',`x')
		while abs(`p'-`f') > 1e-3 { 
			if `f'>`p' { 
				scalar `xlo' = `x'
				scalar `flo' = `f'
			}
			else {
				scalar `xhi'= `x'
				scalar `fhi' = `f'
			}
			scalar `x'=(`xlo'+`xhi')/2
			scalar `f'=chiprob(`df',`x')
			* di `"x=`x' f=`f'"'
		}
		ret scalar chi2 = `x'
		exit
	}


	scalar `x' = `df' 
	scalar `x0' = . 
	while abs(`x' - `x0') > 1e-3 { 
		scalar `x0' = `x'
		scalar `f' = chiprob(`df', `x0') - `p'
		scalar `fp'= (chiprob(`df',`x0'+.01)-`p'-`f')/.01
		scalar `x' = `x' - `f'/`fp'
		* di `"x=`x'  diff = "' `x' - `x0'
	}
	ret scalar chi2 = `x'
end
