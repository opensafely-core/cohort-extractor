*! version 1.0.0  27jun2013

program define _pss_chk_matrix, sclass
	version 13.0
	syntax anything(name=args), option(string) [ COV MISsing ///
		range(string) integer ]

	sreturn clear

	local j = 0

	while ("`args'" != "") {
		gettoken arg`++j' args : args, match(par)
	}
	local narg = `j'

	if `narg' != 1 {
		di as err "{p}invalid `option': only one matrix "	///
			"can be specified{p_end}"
		exit 198 
	}
	local mat `arg1'

	cap mat list `mat' 
	if (_rc) {
		di as err "invalid `option': matrix not found"
		exit 111
	}
	local nrows = rowsof(`mat')
	local ncols = colsof(`mat')
		
	if "`missing'" == "" {
 		// check missing values
		if (matmissing(`mat')==1) {
			local option : subinstr local option " " "-", all
			di as err "{p}`option' matrix contains missing " ///
			 "values{p_end}"
			exit 504
		}
	}	
	if `"`cov'"' != "" { 
		/* check validation for cov matrix 			*/
		if !issymmetric(`mat') { 
			local option : subinstr local option " " "-", all
			di as err "{p}`option' matrix must be symmetric{p_end}"
			exit 505		
		}	
		cap _checkpd `mat', matname("`mat'") check(pd)
		if (_rc) {
			local option : subinstr local option " " "-", all
			di as err "{p}`option' matrix must be positive " ///
			 "definite{p_end}"
			exit 506
		}
	}
	if "`integer'"!="" | "`range'"!="" {
		forvalues i=1/`nrows' {
			forvalues j=1/`ncols' {
				local list `"`list' `=`mat'[`i',`j']'"'
			}
		}
		if "`range'"!="" {
			local range range(`range') 
			local extra1 " in `range'"
		}
		cap numlist `"`list'"', `range' `integer'
		local rc = c(rc)
		if (`rc') {
			if ("`integer'"!="") local extra " integers"

			local option : subinstr local option " " "-", all
			di as err "{p}invalid `option' matrix: elements " ///
			 "must be`extra'`extra1'{p_end}"
			exit `rc'
		}
	}
	sreturn	local nrows = `nrows'
	sreturn local ncols = `ncols'
end

exit
