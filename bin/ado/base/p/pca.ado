*! version 2.1.0  19apr2007
program pca, eclass byable(onecall)
	version 8

	if _caller() < 9 {
		pca_8 `0'
		exit
	}

	if replay() {
		if "`e(cmd)'" != "pca" {
			error 301
		}
		if _by() {
			error 190
		}
		pca_display `0'
		exit
	}

	if _by() {
		by `_byvars'`_byrc0' : Estimate `0'
	}
	else {
		Estimate `0'
		ereturn local cmdline `"pca `0'"'
	}
end


program Estimate, eclass byable(recall)

	#del ;
	syntax  varlist(numeric default=none)
	        [aw fw] [if] [in]
	[,
		noVCE
		VCE2(string)
		CORrelation  // default
		COVariance
		MEans
		BLanks(passthru)
		Level(passthru)
	
	// options for pcamat
	// undocumented; used to produce error messages
		n(passthru)
		NAMes(passthru)
		SHape(passthru)
		MEANS2(passthru)
		SDS(passthru)
		FORCE
		
	// other options to be transferred to pcamat	
		*
	] ;
	#del cr
	
	local display_opts `means' `blanks' `level' `vce'
	local pcamat_opts  `options'

	NotAllowed n()     `"`n'"'
	NotAllowed names() `"`names'"' 
	NotAllowed shape() `"`shape'"' 
	NotAllowed means() `"`means2'"' 
	NotAllowed sds()   `"`sds'"' 
	NotAllowed force   `"`force'"' 
	
	if "`correlation'" != "" & "`covariance'" != "" {
		dis as err "options correlation and covariance are exclusive"
		exit 198
	}
	else if "`correlation'" == "" & "`covariance'" == "" {
		local Ctype correlation
	}
	else {
		local Ctype `correlation' `covariance' 
	}		

	ParseVCE `vce2' 
	if "`s(vce)'" == "normal" { 
		local normal  normal
		local vce_arg vce(normal)
	}

	if "`weight'" != "" {
		local wght `"[`weight'`exp']"'
		if "`normal'" != "" & "`weight'" == "aweight" {
			dis as err /// 
			    "option vce(normal) not allowed with aweights"
			exit 101
		}
	}

// clean up varlist

	marksample touse
	quietly count if `touse'
	if (r(N) == 0) error 2000
	if (r(N) == 1) error 2001

	// local varlist : list uniq varlist
	foreach v of local varlist {
		quietly summ `v' if `touse', meanonly
		if r(max) > r(min) {
			local vlist `vlist' `v'
		}
		else {
			dis as txt "(`v' dropped because of zero variance)"
		}
	}
	
	if "`vlist'" == "" {
		dis as err "all variables dropped because of zero variance"
		exit 498
	}
	
	local varlist `vlist'
	local nvar : list sizeof varlist
	if `nvar' < 2 {
		error 102
	}

// create matrix to be analyzed

	tempname C nobs Means
	quietly matrix accum `C' = `varlist' if `touse' `wght' , ///
	   dev means(`Means') nocons
	matrix rownames `Means' = mean
	local nobs = r(N)
	matrix `C' = (1/(`nobs'-1)) * `C'

	if "`Ctype'" == "correlation" {
		tempname sds
		matrix `sds' = J(1,`nvar',0)
		forvalues j = 1/`nvar' {
			matrix `sds'[1,`j'] = sqrt(`C'[`j',`j'])
		}
		matrix colnames `sds' = `:colnames `C''
		matrix rownames `sds' = sd
		local sds_opt sds(`sds')
		matrix `C' = corr(`C')
	}

// actual work is performed in -pcamat-
// matrixtype() is undocumented option of -pcamat-

	pcamat `C', n(`nobs') `vce' `vce_arg' `Ctype' means(`Means') ///
	   `sds_opt' matrixtype(`Ctype') `pcamat_opts' nodisplay
	   
	if "`e(cmd)'" == "" {
		ereturn clear
		exit
	}

// extra store of e(sample), weights, ...

	ereturn repost, esample(`touse')
	ereturn local  wtype `"`weight'"'
	ereturn local  wexp  `"`exp'"'

	pca_display, `display_opts'
end


program NotAllowed
	args optname optvalue
	
	if `"`optvalue'"' != "" { 
		dis as err "option `optname' not allowed with pca" 
		exit 198
	}
end	


program ParseVCE, sclass
	local 0 ,`0' 
	syntax [, NORmal NONe ] 
	
	local arg `normal' `none' 
	if `:list sizeof arg' > 1 {
		exclusive_opts "`arg'" "vce()" 
	}
	
	sreturn clear
	sreturn local vce `arg' 
end	
exit
