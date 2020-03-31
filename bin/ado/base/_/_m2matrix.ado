*! version 1.0.4  15aug2006
program _m2matrix
	version 8

	args	T	  /// matname (output)
		type	  /// type (input)
		k	  /// # of newvarlist (input)
		A	  /// user defined content (input)
		cstorage   // Full | Upper | Lower | <empty> (input)

	capture confirm matrix `A' 		/* matname? */
	if ! _rc {				/* yes */
		matrix `T' = `A'
	}
	else {					/* no */
		capture matrix input `T' = (`A')
		if _rc {
			dis as err "`type'(`A') invalid"
			exit 198
		}
	}

	if matmissing(`T') {
		dis as err "`type'(`A') has missing values"
		exit 504
	}

	Parse_cstorage `cstorage'
	local cstorage `s(arg)'

// means and sds

	if inlist("`type'", "means", "sds") {

		if !( (colsof(`T')==`k' & rowsof(`T')== 1 ) | ///
		      (colsof(`T')== 1  & rowsof(`T')==`k') ) {
			dis as err /*
			  */ `"`k' variables specified but specified `type'(`A') is "' /*
			  */ rowsof(`T') " x " colsof(`T')
			dis as err "expected a `k'-vector"
			exit 503
		}

		// return as row vector
		if colsof(`T') == 1 {
			matrix `T' = `T''
		}

		if `"`type'"' == "sds" {
			// standard deviations nonnegative ?
			forvalues i = 1 / `k' {
				if `T'[1,`i'] < 0 {
					dis as err `"option sds(`sds') incorrectly specified"'
					dis as err "all entries should be nonnegative"
					exit 198
				}
			}
		}
		exit
	}

// corr and cov

	if inlist("`type'", "corr", "cov") {

		if (`k' == 1) {
			if (rowsof(`T') != 1) | (colsof(`T') != 1) {
				dis as err "matrix `A' should be a row or column vector"
				exit 503
			}
		}
		else if (rowsof(`T') == `k') & (colsof(`T') == `k') {
			if !inlist("`cstorage'","full","") {
				dis as err "invalid cstorage; matrix is found to be square"
				exit 198
			}
			if !issym(`T') {
				dis as err `"`type'(`A') is not symmetric"'
				exit 505
			}
		}
		else if rowsof(`T')==1 | colsof(`T')==1 {
			if "`cstorage'" == "" {
				dis as err "option cstorage() required with vectorized corr/cov matrix"
				exit 198
			}
			if "`cstorage'" == "full" {
				dis as err "option cstorage() invalid; vectorized corr/cov matrix found"
				exit 198
			}
			local vk = `k'*(`k'+1)/2
			if (colsof(`T')!=`vk') & (rowsof(`T')!=`vk') {
				dis as err "size of vector `A' invalid; `vk'-vector expected"
				exit 503
			}
			if colsof(`T') == 1 {
				matrix `T' = `T''
			}
			tempname C
			matrix `C' = I(`k')
			local ij = 0
			if "`cstorage'" == "lower" {
				forvalues i = 1/`k' {
					forvalues j = 1 / `i' {
						matrix `C'[`i',`j'] = `T'[1,`++ij']
						matrix `C'[`j',`i'] = `T'[1,`ij']
					}
				}
			}
			else {
				forvalues i = 1/`k' {
					forvalues j = `i'/`k' {
						matrix `C'[`i',`j'] = `T'[1,`++ij']
						matrix `C'[`j',`i'] = `T'[1,`ij']
					}
				}
			}
			matrix `T' = `C'
		}

		if "`type'" == "corr" {
			// correlation matrix ?
			// note: we don't test positive (semi-)definiteness here
			forvalues i = 1 / `k' {
				forvalues j = 1 / `k' {
					if (`i' == `j')  & (`T'[`i',`j'] != 1) {
						dis as err `"corr(`corr') incorrectly specified"'
						dis as err "diagonal elements should be 1"
						exit 198
					}
					else if (`i' != `j') & (abs(`T'[`i',`j']) > 1) {
						dis as err `"corr(`corr') incorrectly specified"'
						dis as err "off-diagonal elements should be in range[-1,1]"
						exit 198
					}
				}
			}
		}
		else {
			// covariance matrix
			// note: we don't test positive (semi-)definiteness
			forvalues i = 1 / `k' {
				if `T'[`i', `i'] < 0 {
					dis as err `"cov(`cov') incorrectly specified"'
					dis as err "diagonal elements should be nonnegative"
					exit 198
				}
			}
		}

		exit
	}

	dis as err "this should not happen"
	exit 9999
end


program Parse_cstorage , sclass
	local 0 ,`0'
	syntax [, Full Lower Upper]
	sreturn clear
	sreturn local arg `full' `lower' `upper'
end
exit
