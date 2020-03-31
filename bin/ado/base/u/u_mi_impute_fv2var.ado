*! version 1.0.0  27oct2011
/*
	creates permanent indicators for factor variables  
*/
program u_mi_impute_fv2var, sclass
	version 12
	syntax varlist(fv) [if] , FVSTUB(string) ///
				[ dropfvvars ]
	marksample touse
	if ("`dropfvvars'"!="") {
		cap drop `fvstub'*
	}
	fvrevar `varlist' if `touse', stub(`fvstub')
	local vars `r(varlist)'
	cap unab fvvars : `fvstub'*
	local fvvars : list fvvars & vars
	sret local fvrevarlist	"`vars'"
	sret local fvvars	"`fvvars'"
end
