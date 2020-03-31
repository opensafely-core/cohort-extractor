*! version 1.1.3  01jun2013
program _getcovcorr, rclass
	version 8

	#del ;
	syntax  anything(name=Cin id="correlation or covariance matrix")
	[,
		NAMes(str)     // namelist; required with vectorized input
		SDS(str)       // vector of standard deviations
		MEans(str)     // vector of means
		CORrelation    // return a correlation matrix
		COVariance     // return a covariance  matrix
		SHape(str)     // shape of Cin
		FORCE          // does not enforce matching names

		check(passthru)
		forcepsd
		tol(passthru)
	];
	#del cr

	if "`correlation'" != "" & "`covariance'" != "" {
		dis as err "options correlation and covariance are exclusive"
		exit 198
	}

	Parse_shape `"`shape'"' 
	local shape `s(arg)'

	local names_opt = (`"`names'"' != "")
	if `"`names'"' != "" {
		// names implies force, i.e., use the provided names regardless
		// of what names are currently on the various matrices.
		local force force
	}

	tempname C npos Ev L
	
// turn input matrix Cin into square cov/corr matrix

	confirm matrix `Cin'
	if `:list sizeof Cin' > 1 {
		dis as err "only one matrix name expected"
		exit 198
	}
	local r = rowsof(`Cin')
	local c = colsof(`Cin')
		
	if matmissing(`Cin') {
		dis as err "matrix `Cin' has missing values"
		exit 504
	}

	if `r' == `c' {
		// square matrix
		if `r' == 1 {
			dis as err "1x1 matrix not allowed"
			exit 102
		}
		if inlist("`shape'","upper", "lower")  {
			dis as err "option shape() invalid; " ///
			    "`shape' specified, but square matrix found"
			exit 198
		}

		matrix `C' = `Cin'  
		local nvar = `r'
		if !issym(`C') {
			dis as err "matrix `Cin' not symmetric"
			exit 505
		}
	}
	else if `r' == 1 | `c' == 1 {
		// note: this is not reached with 1x1 matrix
		// vectorized triangular correlation or covariance matrix

		if "`shape'" == "" {
			dis as err "option shape() required " ///
			           "with vectorized matrix"
			exit 198
		}
		if !inlist("`shape'", "upper", "lower") {
			dis as err "option shape() invalid; " ///
			    "lower or upper expected with vectorized input"
			exit 198
		}

		if "`names'" == "" {
			dis as err "option names() required"
			exit 100
		}

		local maxrc = max(`r',`c')
		local nvar  = chop((sqrt(1+8*`maxrc')-1)/2, 1e-10)
		CheckSize `Cin' `nvar' `maxrc'

		matrix `C' = I(`nvar')
		if colsof(`Cin') == 1 {
			tempname CIN
			matrix `CIN' = `Cin''
		}
		else {
			local CIN `Cin'
		}

		if "`shape'" == "upper" {
			// upper-triangular
			local ij = 0
			forvalues i = 1 / `nvar' {
				forvalues j = `i' / `nvar'{
					matrix `C'[`i',`j'] = `CIN'[1,`++ij']
					matrix `C'[`j',`i'] = `C'[`i',`j']
				}
			}
		}
		else {
			// lower-triangular
			local ij = 0
			forvalues i = 1 / `nvar' {
				forvalues j = 1 / `i' {
					matrix `C'[`i',`j'] = `CIN'[1,`++ij']
					matrix `C'[`j',`i'] = `C'[`i',`j']
				}
			}
		}
	}
	else {
		// rectangular matrix -- invalid

		dis as err "`Cin' invalid; neither square-symmetric, nor vector"
		exit 503
	}

// verify SDS

	if `"`sds'"' != "" {
		confirm matrix `sds'
		if matmissing(`sds') {
			dis as err "matrix `sds' has missing values"
			exit 504
		}
		if rowsof(`sds')!=1 & colsof(`sds')!=1 {
			dis as err "sds() invalid; vector expected"
			exit 503
		}
		if rowsof(`sds')!=`nvar' & colsof(`sds')!=`nvar' {
			dis as err ///
			    "matrices `sds' and `Cin' are not conformable"
			exit 503
		}

		// to return SDS as properly named row vector
		tempname SDS
		if colsof(`sds') == 1 {
			matrix `SDS' = `sds''
		}
		else {
			matrix `SDS' = `sds'
		}

		forvalues i = 1 / `nvar' {
			if `SDS'[1,`i'] <= 0 {
				dis as err "sds() invalid; " ///
				    "strictly positive values expected"
				exit 198
			}
		}
	}

// verify MEANS

	if `"`means'"' != "" {
		confirm matrix `means'
		if matmissing(`means') {
			dis as err "matrix `means' has missing values"
			exit 504
		}
		if rowsof(`means')!=1 & colsof(`means')!=1 {
			dis as err "means() invalid; vector expected"
			exit 503
		}
		if rowsof(`means')!=`nvar' & colsof(`means')!=`nvar' {
			dis as err "vectors/matrices `means' and `Cin' " ///
			           "are nonconformable"
			exit 503
		}

		// to return MEANS as properly named row vector
		tempname MEANS
		if colsof(`means') == 1 {
			matrix `MEANS' = `means''
		}
		else {
			matrix `MEANS' = `means'
		}
	}

// verify names() and the row- and column names

	if "`names'" != "" {
		if `:list sizeof names' != `nvar' {
			dis as err "option names() invalid"
			dis as err "number of names in names() " ///
			    "incompatible with size of matrix"
			exit 503
		}
	}
	else {
		// only reached if square matrix
		local names : rownames `Cin'
		if "`names'"!="`:colnames `Cin''" & "`force'"=="" {
			dis as err "name conflict: row and column names " ///
			           "of `Cin' should match"
			exit 198
		}
	}

	capture confirm names `names'
	if _rc {
		dis as err "names() invalid"
		confirm names `names'
	}
	if "`:list dups names'" != "" {
		if `names_opt' {
			dis as err "option names() invalid; " ///
			           "duplicate names found"
		}
		else {
			dis as err "duplicate row names of `Cin'"
		}
		exit 503
	}

	if `"`sds'"' != "" {
		if "`names'" != "`:colnames `SDS''" {
			if "`force'" == "" {
				dis as err "name conflict: " ///
				    "names of `Cin' and `sds' should match"
				exit 198
			}
			else {
				matrix colnames `SDS' = `names'
			}
		}
		matrix rownames `SDS' = sd
	}
	if `"`means'"' != "" {
		if "`names'" != "`:colnames `MEANS''" {
			if "`force'" == "" {
				dis as err "name conflict: " ///
				    "names of `Cin' and `means' should match"
				exit 198
			}
			else {
				matrix colnames `MEANS' = `names'
			}
		}
		matrix rownames `MEANS' = mean
	}

// check diagonal elements strictly positive

	forvalues i = 1 / `nvar' {
		if `C'[`i',`i'] <= 0 {
			dis as err "`Cin' invalid; variance <= 0 found"
			exit 198
		}
	}

// determine whether C is a correlation matrix

	local iscorr = 1
	forvalues i = 1 / `nvar' {
		if `C'[`i',`i'] != 1 {
			local iscorr = 0
			continue, break
		}
	}

// verify: correlations between -1 and 1

	if `iscorr' {
	   forvalues i = 1 / `nvar' {
	      forvalues j = 1 / `=`i'-1' {
	         if !inrange(`C'[`i',`j'],-1,1) {
	            dis as err ///
	                "`Cin' invalid; correlation outside [-1,1] found"
	            exit 198
	         }
	      }
	   }
	}
	
// check that matrix is positive (semi-)definite, i.e., all eigenvalues are  
// larger (equal) zero; all tests are conducted with a tolerance proportional
// to the largest eigenvalue. eigenvalues of absolute value smaller than Tol 
// are treated as 0 (compatible with roundoff error; of course, there could 
// be a very small eigenvalue as well, but numerically, we can't really tell
// these two interpretations apart.

	if `"`check'"' == "" { 
		local check check(psd)
	}	
	_checkpd `C', matname(`Cin') `check' `forcepsd' `tol' 
	
	matrix `C'    = r(C)
	scalar `npos' = r(npos)

	// the operation above with the -forcepsd- option can create a
	// slightly nonsymmetric matrix and if diagonal elements were 1
	// (for a corr mat), they are no longer guaranteed to be 1.  We
	// fix that now if needed.
	if !issym(`C') {
		mat `C' = 0.5*(`C'+`C'')
	}
	if `iscorr' {
		matrix `C' = corr(`C')
	}

// check whether combination of options is valid

	if !`iscorr' & `"`sds'"'!="" {
		dis as err "sds() allowed only with correlation matrix"
		exit 198
	}
	if `iscorr' & "`covariance'"!="" & `"`sds'"'=="" {
		dis as err "can't transform correlation matrix into " ///
		    "covariance matrix without sds()"
		exit 198
	}

// construct required matrix/matrices

	if `iscorr' & "`covariance'"!="" {
		// it is ensured that SDS exists and is properly named
		matrix `C' = diag(`SDS') * `C' * diag(`SDS')
		local ctype covariance
	}
	else if "`correlation'" != "" {
		if !`iscorr' {
			tempname SDS
			matrix `SDS' = J(1,`nvar',1)
			forvalues i = 1/`nvar' {
				matrix `SDS'[1,`i']  = sqrt(`C'[`i',`i'])
			}
			matrix colnames `SDS' = `names'
			matrix rownames `SDS' = sd
			matrix `C' = corr(`C')
		}
		local ctype correlation
	}
	else {
		local ctype = cond(`iscorr',"correlation","covariance")
	}

	matrix rownames `C' = `names'
	matrix colnames `C' = `names'

// and return it

	return local  Cintype = cond(`iscorr', "correlation", "covariance") 
	return local  Ctype   `ctype'
	return scalar npos    = `npos' 
	
	return matrix C       = `C'
	
	if ("`SDS'"   != "")  return matrix sds   = `SDS'
	if ("`MEANS'" != "")  return matrix means = `MEANS'
end


program Parse_shape, sclass
	args arg0
	
	local 0, `arg0'
	capture syntax [, Lower Upper Full ///
	                  LLower UUpper   ] // for error messages
	if _rc { 
		dis as err "option shape() invalid: " _c 
		syntax [, Lower Upper Full LLower UUpper ]
	}	

	local arg `lower' `upper' `full' `llower' `uupper'
	if `:list sizeof arg' > 1 {
		opts_exclusive "`arg'" shape
	}

	if inlist("`arg'","llower","uupper") {
		dis as err "shape(`arg') not supported"
		exit 198
	}

	sreturn local arg `arg'
end


program CheckSize
	args Cin nvar maxrc

	if (`nvar' == round(`nvar')) {
		exit
	}	

	local n1 = floor(`nvar')
	local ntri1 = chop((`n1'*(`n1'+1))/2, 1e-10)

	local n2 = `n1'+1
	local ntri2 = chop((`n2'*(`n2'+1))/2, 1e-10)

	dis as err "the vector `Cin' has `maxrc' elements;"
	dis as err "this cannot be the upper or lower triangle of a square matrix"
	dis as err "Note: The triangle of a `n1'x`n1' matrix has `ntri1' elements."
	dis as err "      The triangle of a `n2'x`n2' matrix has `ntri2' elements."
	exit 503
end

exit
