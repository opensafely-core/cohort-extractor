*! version 1.1.0  07jan2015

program sem_estat_ggof, rclass
	version 12
	local ver : di "version " string(_caller()) ", missing :"

	if "`e(cmd)'"!="sem" {
		error 301
	}

	local ng = `e(N_groups)'
	if `ng' < 2  {
		di as err in smcl "{bf:estat ggof} requires multiple groups"
		exit 198
	}

	syntax [, FORmat(str)		///
		]			//

	if `"`format'"' != "" {
		local chk : display `format' 1
		local fmt `format'
	}
	else {
		local fmt %9.3f
	}
	
	`ver' mata: st_sem_estat_gof(1)
	
	local isrobust = inlist("`e(vce)'","robust","cluster")

	if "`r(gfit)'"=="matrix" {
		tempname GS
		capture mat `GS' = r(gfit)
		if !_rc {
			local format %7.0g
			if `e(N_missing)' == 0 { // SRMR
				local format `format' `fmt'
			}
			if (`e(k_oy)'+`e(k_ly)') { // CD
				local format `format' `fmt'
			}
			if !`isrobust' { //chi2
				if `e(grp_cns)' == 0 {
				  local format "`format' `fmt' %7.0g `fmt'"
				}
			}
			dis as txt _n(1) "Group-level fit statistics"
			_matrix_table `GS', format(`format')
			capture local w = `s(width)'
			if "`r(gfit_sb)'"=="matrix" {
				tempname GS_sb
				capture mat `GS_sb' = r(gfit_sb)
				if !_rc {
					local fmtsb "`fmt' %7.0g `fmt'"
					dis as txt _n(1) ///
				"Satorra-Bentler scaled fit statistics"
					_matrix_table `GS_sb', format(`fmtsb')
				}
			}
		}
		else {
			dis as txt "(nothing to do)"
		}
	}
	if `isrobust' {
		di as txt "{p 0 6 2 `w'}Note: Group-level chi-squared"	///
			" statistics are"				///
			" not reported because of pseudolikelihood.{p_end}"
	}
	else if `e(grp_cns)' == 1 {
		di as txt "{p 0 6 2 `w'}Note: Group-level chi-squared "	///
			" statistics are"				///
			" not reported because of constraints"		///
			" between groups.{p_end}"
	}
	else if "`e(chi2type_note)'" != "" {
	    if e(df_s) < e(dim_s) {
		di as txt "{p 0 6 2 `w'}Note: Group-level chi-squared"	///
			" statistics are"				///
			" not reported because the saturated model"	///
			" is not full rank.{p_end}"
	    }
	    else {
		di as txt "{p 0 6 2 `w'}Note: Group-level chi-squared"	///
			" statistics are"				///
			" not reported because the fitted model"	///
			" is not full rank.{p_end}"
	    }
	}
	if `e(N_missing)' > 0 { // SRMR
		di as txt "{p 0 6 2 `w'}Note: Group-level SRMR"		///
			" statistics are not"				///
			" reported because of missing values.{p_end}"
	}
	if (`e(k_oy)'+`e(k_ly)') == 0 { // CD
		di as txt "{p 0 6 2 `w'}Note: Group-level CD"		///
			" statistics are not"				///
			" reported because there are no endogenous"	///
			" variables.{p_end}"
	}	
	return add
	return scalar N_groups = `ng'
end

exit


