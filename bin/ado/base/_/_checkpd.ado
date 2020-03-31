*! version 1.0.1  28jul2009
program _checkpd, rclass
	version 9
	
	#del ;
	syntax 	anything(name=C), 
		matname(str) 
	[	
		check(str) 
		forcepsd
		tol(numlist max=1 >0)
		report(str)
	] ;
	#del cr
	
	if (`"`check'"' == "") & (`"`forcepsd'"' == "") {
		dis as err "nothing to do" 
		exit 198
	}
	else if `"`forcepsd'"' != "" { 
		local check
	}	
	
	confirm matrix `C' 
	if "`tol'" == "" { 
		local tol 1e-8
	}	
	
// spectral decomposition, with ordered eigenvalues

	tempname A L Ev Tol
	
	matrix symeigen `L' `Ev' = `C'  
	
// count eigenvalues

	scalar `Tol' = abs(`tol' * `Ev'[1,1])

	local n = colsof(`C')
	local nneg   = 0
	local nnzero = 0
	local npzero = 0 
	forvalues i = 1/`n' {
		if (`Ev'[1,`i'] < -`Tol') {
			local ++nneg
		}
		else if (`Ev'[1,`i'] < 0) {
			local ++nnzero
		}	
		else if (`Ev'[1,`i'] <= `Tol') {
			local ++npzero
		}	
	}	
	local npos = `n' - `nneg' - `nnzero' - `npzero' 

// perform checks

	if "`check'" == "psd" { 
		// none of the eigenvalues should be really negative
		if `nneg' > 0 {
			dis as err "`matname' not positive (semi)definite"
			Report "`report'" `Ev' /// 
			         `nneg' `nnzero' `npzero' `npos' 
			exit 506
		}
	}	
	else if "`check'" == "pd" { 
		// all eigenvalues should be really positive
		if `npos' < `n' {
			dis as err "`matname' not positive definite"
			Report "`report'" `Ev' /// 
			         `nneg' `nnzero' `npzero' `npos' 
			exit 506
		}
	}	
	else if "`check'" != "" { 
		dis as err "option check() invalid" 
		exit 198
	}	

// fix matrix 
//   in msg we ignore small-negative ev's.
//   these may easily reappear in matrix multiplication!

	if "`forcepsd'" != "" { 
		if `nneg' + `nnzero' > 0 {
			if `nneg'==1 { 
				dis as txt "1 negative eigenvalue (" ///
				    `Ev'[1,`n'] ") found and replaced by 0"
			}				    
			else if `nneg'==2 { 
				dis as txt "2 negative eigenvalues (" ///
				    `Ev'[1,`=`n'-1'] "," `Ev'[1,`n'] ///
				    ") found and replaced by 0"
			}
			else if `nneg'>2 {
				dis as txt "`nneg' negative eigenvalues in" ///
				    " range [" `Ev'[1,`n'] "," /// 
				    `Ev'[1,`=`n'-`nneg'+1'] "] " /// 
				    "found and replaced by 0"
			}

			forvalues i = 1/`n' { 
				matrix `Ev'[1,`i'] = max(0,`Ev'[1,`i'])
			}
			
			matrix `A' = `L' * diag(`Ev') * `L'' 
		}
		else {
			matrix `A' = `C' 
		}	
	}
	else {
		matrix `A' = `C' 
	}	
	
// return results

	return scalar nneg   = `nneg' 
	return scalar nnzero = `nnzero' 
	return scalar npzero = `npzero' 
	return scalar npos   = `npos' 
	
	return matrix L  = `L' 
	return matrix Ev = `Ev' 
	return matrix C  = `A' 
end


program Report 
	args report Ev nneg nnzero npzero npos 
	
	if "`report'" == "counts" { 
		Line `nneg'   "(.,-Tol)"
		Line `nnzero' "[-Tol,0)"
		Line `npzero' "[0,Tol]"
		Line `npos'   "(Tol.)"
	}
	else if "`report'" == "detail" { 
		dis
		matlist `Ev', rowtitle(Eigenvalues) noheader 
	}	
end


program Line
	args n txt
	if `n' > 0 { 
		dis as err "`n' " plural(`n',"eigenvalue") ///
		    " in the range `txt'"
	}
end	
