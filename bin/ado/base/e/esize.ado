*! version 1.0.6  20mar2019

program define esize, rclass byable(recall)
	version 13
	#del ; 
	syntax anything [if] [in] [,
		BY(varlist) 
		Level(cilevel) 
		UNEqual
		Welch 
		COHensd 
		HEDgesg 
		GLAssdelta 
		PBCorr 
		ALL] ;
	#del cr

	marksample touse

	if "`level'"=="" {
		local level==c(level)
	}
	
	if floor(real(`"`level'"')) < 50 {
		di in red 	///
		"{bf:level()} must be between 50 and 99.99 inclusive for {bf:esize}"
		exit 198
	}

	gettoken estype anything : anything, parse(" ")
	local lcmd = length("`estype'")
	
	// UNPAIRED VERSION
	if "`estype'" == bsubstr("unpaired", 1, max(3,`lcmd')) {
		if `"`by'"' != "" {
			di in red "may not combine {bf:esize unpaired} with option {bf:by()}"
			exit 198
		}
		if !ustrregexm(`"`anything'"', "==") {
			di as err "{it:varname1} {bf:==} {it:varname2} required"
			di as err "{p 4 4 2} To compare effect sizes for two "
			di as err "independent samples using variables, "
			di as err "specify {bf:esize unpaired} {it:varname1}" 
			di as err "{bf:==} {it:varname2}.{p_end}" 
			exit 198
		}
		gettoken var1 rest : anything, parse("=")
		gettoken eqsign var2 : rest, parse("=")
		capture confirm numeric variable `var1'
		local rc = _rc
		capture confirm numeric variable `var2'
		local rc = `rc' + _rc
		if `rc' {
			di as err "two numeric variables required"
			di as err "{p 4 4 2} To compare effect sizes for two "
			di as err "independent samples using variables, "
			di as err "specify {bf:esize unpaired} {it:varname1}" 
			di as err "{bf:==} {it:varname2}.{p_end}" 
			exit 198
		}
		#del ;
		_esizeUnpairedSub `anything' if `touse', 
			`unequal' 
			`welch' 
			`cohensd' 
			`hedgesg' 
			`glassdelta' 
			`pbcorr' 
			`all' 
			level(`level');
		#del cr
		return add
	}
	// TWO SAMPLE VERSION
	else if "`estype'" == bsubstr("twosample", 1, max(3,`lcmd')) {
		#del ; 
		_esizeTwoSample `anything' if `touse', by(`by') 
			`unequal' 
			`welch' 
			`cohensd' 
			`hedgesg' 
			`glassdelta' 
			`pbcorr' 
			`all' 
			level(`level');
		#del cr
		return add
	}
	else {
		dis as err `"unknown subcommand of {bf:esize}: `estype'"'
		exit 198
	}
end


// UNPAIRED VERSION SUBROUTINE
// ============================================================
program define _esizeUnpairedSub, rclass byable(recall)
	#del ; 
	syntax anything [if] [in] [,
		Level(cilevel)
		UNEqual
		Welch  
		COHensd 
		HEDgesg 
		GLAssdelta 
		PBCorr 
		ALL] ;
	#del cr

	marksample touse

	quietly ttest `anything' if `touse', 			///
		unpaired `unequal' `welch' level(`level')
	
	// RUN THE CALCULATIONS, DISPLAY AND RETURN SUBROUTINE
	_esize_calculations if `touse', 			///
		level(`level') `unequal' `welch'		///
		`cohensd' `hedgesg' `glassdelta' `pbcorr' `all'
	return add
end


// TWO SAMPLE VERSION SUBROUTINE
// ============================================================
program define _esizeTwoSample, rclass byable(recall)
	#del ; 
	syntax varname [if] [in] ,
		BY(varlist) [
		Level(cilevel) 
		UNEqual
		Welch 
		COHensd 
		HEDgesg 
		GLAssdelta 
		PBCorr 
		ALL] ;
	#del cr
	
	marksample touse
	
	quietly ttest `varlist' if `touse', 			///
		by(`by') `unequal' `welch' level(`level')
		
	// RUN THE CALCULATIONS, DISPLAY AND RETURN SUBROUTINE
	_esize_calculations if `touse', level(`level') 	///
		by(`by') `unequal' `welch'			///
		`cohensd' `hedgesg' `glassdelta' `pbcorr' `all'
	return add
	
end

