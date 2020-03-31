*! version 1.1.2  13feb2015 
program define _mgarch_util
	version 11.1
	
	syntax anything(name=sub) [, * ]
	
	gettoken junk rest : 0, parse(", ")
	
	if `"`sub'"'=="Replay" {
		Replay `rest'
	}
	else if `"`sub'"'=="Check" {
		Check `rest'
	}
	else if `"`sub'"'=="DynamicWarning" {
		DynamicWarning `rest'
	}
	else if `"`sub'"'=="CheckHetvars" {
		CheckHetvars `rest'
	}
	else if `"`sub'"'=="CheckDist" {
		CheckDist `rest'
	}
	else {
		di `"{err}`sub' unknown subcommand"'
		exit 198
	}
        
end

program define Replay
	
	syntax [, noCNSReport * ]
	
	_get_diopts diopts, `options'
	_mgarch_coef_table_header
	if !e(converged) di "{txt}convergence not achieved"
	di
	_coef_table, `diopts' `cnsreport' showeq depname(" ")
end

program define Check

	syntax [, 						///
		depvar(varname fv ts)				///
		hasarch(numlist max=1)				///
		arch(numlist)					///
		hasgarch(numlist max=1)				///
		garch(numlist)					///
		hashet(numlist max=1)				///
		het(varlist ts fv)				///
		]
	
	if (`hasarch'==1 & "`arch'"!="") {
		di "{err}option {cmd:arch()} in equation {cmd:`depvar'} "  ///
			"cannot be specified with model-level {cmd:arch()}"
		exit 498
	}
	
	if (`hasgarch'==1 & "`garch'"!="") {
		di "{err}option {cmd:garch()} in equation {cmd:`depvar'} " ///
			"cannot be specified with model-level {cmd:garch()}"
		exit 498
	}
	
	if (`hashet'==1 & "`het'"!="") {
		di "{err}option {cmd:het()} in equation {cmd:`depvar'} "  ///
			"cannot be specified with model-level {cmd:het()}"
		exit 498
	}
	
end

program define DynamicWarning, rclass

	syntax [, stat(string) ix1(integer 0) ix2(integer 0) stub(integer 0) ]
	
	if "`stat'"=="variance" {
		return local hasop 0
		return scalar ignoredyn = 0
		exit
	}
	
	local ignoredyn 0
	local depvars `e(depvar)'
	
	if "`stat'"=="xb" local covars `e(indeps)'
	if "`stat'"=="variance" {
		local covars `e(hetvars)'
		local stub 1
	}
	
	if (`stub'==0) {
		local ix1 = 2*`ix1'-1
		local ix2 = 2*`ix'-1
		if `ix2' < 0 local ix2
		local ix `ix1' `ix2'
		tokenize "`covars'", parse(";")
		local covars ``ix1'' ``ix2''
	}
	
	local covars : subinstr local covars ";" " ", all
	
	foreach i of local covars {
		_ms_parse_parts `i'
		local haslag = strmatch("`r(ts_op)'","*L*")
		if (`haslag') local clist `clist' `r(name)'
	}
	foreach i of local depvars {
		_ms_parse_parts `i'
		local dlist `dlist' `r(name)'
	}
	local hasop : list dlist & clist
	
	if "`hasop'" == "" {
		local ignoredyn 1
		if `e(k_dv)'>1 local s s
		di as txt "(no lags of dependent variable`s' on rhs; "  ///
			"option {cmd:dynamic()} ignored)"
	}
	
	// hasop contains names of depvars that have .L operator
	
	return local hasop `hasop'
	return scalar ignoredyn = `ignoredyn'
	
end

program CheckHetvars
	
	syntax [, depvars(varlist fv ts) hetvars(string) ]
	
	local hetvars : subinstr local hetvars ";" " ", all
	local hetvars : subinstr local hetvars "_cons" "", all word
	
	foreach i of local depvars {
		_ms_parse_parts `i'
		local dep `dep' `r(name)'
	}
	
	foreach i of local hetvars {
		_ms_parse_parts `i'
		local het `het' `r(name)'
	}
	
	local hasdep : list dep & het
	local hasdep : word count `hasdep'
	if (`hasdep') {
		di "{err}dependent variables not allowed in {cmd:het()}"
		exit 498
	}

end

program CheckDist, sclass

	syntax [, dist(string) ]
	
	local estdf 1
	
	local w : word count `dist'
	if (`w'>2) {
		di "{err}may specify at most two arguments "	///
			"in {cmd:distribution()}"
		exit 198
	}
	
	local udist : word 1 of `dist'
	
	if strmatch(`"`udist'"', 		///
		bsubstr("gaussian", 1, max(3,length(`"`udist'"')))) {
		local udist 1
		local sdist "gaussian"
	}
	else if strmatch(`"`udist'"',		///
		bsubstr("normal", 1, max(3,length(`"`udist'"')))) {
		local udist 1
		local sdist "gaussian"
	}
	else if strmatch(`"`udist'"', "t") {
		local udist 2
		local sdist "t"
	}
	else if strmatch(`"`udist'"', "ged") {
		local udist 3
		local sdist "ged"
	}
	else if `"`udist'"' == "" {
		local udist 1           // default
		local sdist "gaussian"
	}
	else {
		di "{err}invalid distribution in {cmd:distribution()}"
		exit 198
	}
	
	if (`udist'==1) local estdf 0
	
	local udf : word 2 of `dist'
	
	if "`udf'" != "" {
		if (`udist'==1) {
			di "{err}cannot specify degrees of freedom or "	///
				"shape parameter with Gaussian errors"
			exit 198
		}
		
		capture confirm number `udf'
		if _rc {
			if (`udist'==2) {
				di "{err}invalid degrees of freedom "	///
					"in {cmd:distribution()}"
			}
			else if (`udist'==3) {
				di "{err}invalid shape parameter "	///
					"in {cmd:distribution()}"
			}
			exit _rc
		}
		
		if (`udist'==2 & `udf' <= 2) {
			di "{err}degrees of freedom for Student's {it:t} " ///
				"distribution must be greater than 2"
			exit 198
		}
		
		if (`udist'==3 & `udf' <= 0) {
			di "{err}shape parameter for generalized error " ///
				"distribution must be positive"
			exit 198
		}
		
		local estdf 0
	}
	
	if (`estdf') {
		if (`udist'==2) local name df
		if (`udist'==3) local name shape
	}
	
	sreturn local name `name'
	sreturn local estdf `estdf'
	sreturn local df `udf'
	sreturn local dist `udist'
	sreturn local sdist `sdist'
	
end

program define _mgarch_coef_table_header

	local crtype = ///
	    upper(bsubstr(`"`e(crittype)'"',1,1)) + bsubstr(`"`e(crittype)'"',2,.)

	if e(N_gaps) > 0 { 
		local gapcoma ","
		if e(N_gaps) == 1 {
			local gaptitl "but with a gap"
		}
		else {
			local gaptitl "but with gaps"
		}
	}
	
	di _n "{txt}`e(title)'"
	if `"`e(title2)'"' != "" di "{txt}`e(title2)'"
	
	local x1 = strtrim(`"`e(tmins)'"')
	local x2 = strtrim(`"`e(tmaxs)'"')
	local smpl1 "Sample: " "{res}`x1' -"
	if (length(`"`smpl1'"') + length(`"`x2'`gapcoma' `gaptitl'"')) < 87 {
		local smpl1 "`smpl1' `x2'`gapcoma' `gaptitl'"
	}
	else if (length(`"`smpl1'"') + length(`"`x2'`gapcoma'"')) < 87 {
		local smpl1 "`smpl1' `x2'`gapcoma'"
		local smpl2 "`gaptitl'"
	}
	else if (length(`"`x2'`gapcoma' `gaptitl'"')) < 45 {
		local smpl2 "`x2'`gapcoma' `gaptitl'"
	}
	else {
		local smpl2 "`x2'`gapcoma'"
		local smpl3 "`gaptitl'"
	}
	
	if `"`smpl3'"' != "" {
		di _n "{txt}`smpl1'"
		di _col(10) "{res}`smpl2'"
		if length(`"`smpl2'"') < 36 {
			local osmpl _col(10) "{res}`smpl3'"
		}
		else {
			di _col(10) "{res}`smpl3'"
		}
	}
	else if `"`smpl2'"' != "" {
		di _n "{txt}`smpl1'"
		if length(`"`smpl2'"') < 36 {
			di _c
			local osmpl _col(10) "{res}`smpl2'"
		}
		else {
			di _col(10) "{res}`smpl2'"
		}
	}
	else {
		if length(`"`smpl1'"') < 56 {
			local osmpl _n "{txt}`smpl1'"
		}
		else {
			di _n "{txt}`smpl1'"
		}
	}
	local x1
	local x2
	
	di `osmpl' ///
	    _col(51) "{txt}Number of obs" ///
	    _col(67) "={res}" ///
	    _col(69) %10.0gc e(N)

	if !missing(e(df_r)) {
	    local model _col(51) "{txt}F({res}" %3.0f e(df_m) "{txt},{res}" ///
	    	%6.0f e(df_r) "{txt})" _col(67) "={res}" _col(70) %9.2f e(F)
	    local pvalue _col(51) "{txt}Prob > F" _col(67) "={res}" _col(73) ///
	       %6.4f Ftail(e(df_m),e(df_r),e(F))
	}
	else {
		if "`e(chi2type)'" == "" {
			local chitype Wald
		}
		else local chitype `e(chi2type)'
		local model _col(51) `"{txt}`chitype' chi2({res}"' e(df_m) ///
		    "{txt})" _col(67) "{txt}={res}" _col(70) %9.2f e(chi2)
		local pvalue _col(51) "{txt}Prob > chi2" _col(67) "={res}" ///
		    _col(73) %6.4f chiprob(e(df_m),e(chi2))
	}
	
	if "`e(dist)'" == "gaussian" {
		local line2 as txt "Distribution: " as res "Gaussian"
	}
	else if "`e(dist)'" == "t" {
		if `e(estdf)'==0 {
			local k : di %8.3g e(usr)
			local line2 as txt "Distribution: " "{res}t(" ///
				as res trim("`k'") "{res})"
		}
		else {
			local line2 as txt "Distribution: {res}t"
		}
	}
	else if "`e(dist)'" == "ged" {
		if `e(estdf)'==0 {
			local k : di %5.4g e(usr)
			local line2 as txt "Distribution: " "{res}GED(" ///
				as res trim("`k'") "{res})"
		}
		else {
			local line2 as txt "Distribution: {res}GED"
		}
	}
	
	di `line2' `model'
	
	if "`e(ll)'" != "" {
		di "{txt}`crtype' = {res}" %9.0g e(ll) `pvalue'
	}
	else {
		di `pvalue'
	}

end
