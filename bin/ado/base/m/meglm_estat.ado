*! version 1.1.3  25oct2019
program meglm_estat
	version 13
	gettoken sub rest: 0, parse(" ,")
	local lsub = length(`"`sub'"')

	if `"`sub'"' == "icc" {
		__estat_icc `rest'
		exit
	}
	if `"`sub'"' == "sd" {
		gsem_estat `0'
		exit
	}
	
	if `"`sub'"' == bsubstr("group",1,max(2,`lsub')) {
		local type group
	}
	else {
		estat_default `0'
		exit
	}
	
	if "`type'" == "group" {
		gettoken comma rest : rest, parse(",")
		if `"`comma'"' != "" {
			if `"`rest'"' != "" | `"`comma'"' != "," {
di as err "{p 0 4 2}options not allowed with subcommand group{p_end}"
			  exit 198
		 	}
		}
		`e(cmd2)', grouponly
		exit
	}
end

program __estat_icc, rclass
	syntax, [ Level(cilevel)  			///
		  NORMAL 				/// undocumented
		]
	// note: in linear mixed-effects model, covariance() option is 
	// irrelevant, as only intercept is used in each equation

	if "`e(iccok)'" == "" {
		error 321
	}

        if ("`e(ivars)'"== "") {
                di as error "{p}requested action not valid after " ///
                        "{bf:`e(cmd2)'} because there are no " ///
                        "random effects in the model{p_end}"
                exit 321
        }
	
	// levels cannot contain "_all "
	local eivars `e(ivars)'
	local cross : list posof "_all" in eivars
	// revars cannot contain R.
	local erevars `e(revars)'
	local lrevar: subinstr local erevars `"R."' `""', all		
	if length(`"`lrevar'"') != length("`e(revars)'") {
		local cross = 1
	}
	if (`cross') {
	    di "{err}{bf:estat icc} not allowed after crossed-effects models"
	    exit 321
	}
	
	// if revars without _cons is empty, then no covariates
	local erevars `e(revars)'
	local ncrevars: subinstr local erevars `"_cons"' `""', all
	local hasRcovariates : list sizeof ncrevars
	local hasFcovariates = e(k_f)
		
	// ivars without duplicates
	local ndivars : list uniq eivars
	
	// the elements we need are stored in _b[var(_cons[`w']):_cons]
	// where `w' for level `i' is the ith element of uniq e(labels)
	
	local nfparms : colnfreeparms e(b)
	local labels `e(labels)'
	local labels : list uniq labels
	local wc : list sizeof labels
	local den 0
	forvalues i = 1/`wc' {
		local w : word `i' of `labels'
		capture local x = _b[/var(_cons[`w'])]
		if _rc {
			di "{err}{p}{bf:estat icc} not allowed after" ///
				" random-effects models with random-level" ///
				" specifications that do not contain" ///
				" random intercepts{p_end}"
			exit 321
		}
		local den `den' + _b[/var(_cons[`w'])]
		local num`i' `den'
		local lev`i' : subinstr local w ">" "|", all
	}
	
	di ""

	local condintraclass = 0
	if (!`hasRcovariates' & !`hasFcovariates') {
	        di "{txt}Intraclass correlation"
	}
	else if (!`hasRcovariates') {
		di "{txt}Residual intraclass correlation"
	}
	else {
		di "{txt}Conditional intraclass correlation"
		local condintraclass = 1
	}
	
	di ""
	
	local colivar `ndivars'
	tokenize `colivar'
	local dicolivar
	// separate nlcom for each ICC, since we won't do any covariance
	// between the separate estimates
	
	// adjust denominator
	if "`e(icctype)'" == "logit" {
		local den `den' + (_pi^2)/3
	}
	else if "`e(icctype)'" == "probit" {
		local den `den' + 1
	}
	else if "`e(icctype)'" == "cloglog" {
		local den `den' + (_pi^2)/6
	}
	else { // linear
		local depvar `e(depvar)'
		local depvar : word 1 of `depvar'
		local den `den' + _b[/var(e.`depvar')]
	}
	
	// determine size for Level list
        if ("`c(lstretch)'" == "on") {
		local levelsize = 29 + c(linesize) -79
	}
	else {
		local levelsize = 29
	}
        local level = string(`level',"%9.0g")
        local plevel = `level'/100
	tempname zval b V kest sek kl ku  
        scalar `zval' = invnormal(1-.5*(1-`plevel'))

	local format %9.0g
	local formatwidth = fmtwidth("`format'")
        local left = bsubstr("`format'",2,1) == "-"
        if (`left' == 0) {
                local padit1 = 12-(`formatwidth'+1)
		local padit2 = `padit1' - 1
                local padit3 = 12-`formatwidth'
        }
        else {
                local padit1 = 2
		local padit2 = 1
                local padit3 = 3
        }
	tempname mytab
        .`mytab' = ._tab.new, col(5) lmargin(0)
	// display levels larger than levelsize
	local levellarge = 0
	forvalues i=1/`wc' {
		if(`"`relevel'"' == "`1'") {
			local irelevel = `i'
		}
                if("`dicolivar'" != "") {
                        local dicolivar `1'|`dicolivar'
                }
                else {
                        local dicolivar `1'
                }
                macro shift
        	local dicolivar`i' `dicolivar'
                if length(`"`dicolivar`i''"') > `levelsize' & ///
                 ("`irelevel'" == "" || "`irelevel'" == "`i'") {
			local levellarge = 1
		}	
	}
	forvalues i = 1/`wc' {
	        if length(`"`dicolivar`i''"') > `levelsize' & ///
                 ("`irelevel'" == "" || "`irelevel'" == "`i'") {
			local k = `wc'-`i'+2
			di `"Level `k': `dicolivar`i''"'	
		}
	}
	if `levellarge' {
		di ""
	}
	
        .`mytab' = ._tab.new, col(5) lmargin(0)
        .`mytab'.width  `levelsize'  |12  12  12    12
        .`mytab'.sep, top
        .`mytab'.pad       . `padit1'  `padit2' `padit3' `padit3'
        .`mytab'.numfmt    . `format' `format' `format' `format'
        if ("`normal'" != "") {
		local ditest = "[`=strsubdp("`level'")'% Conf. Interval]"
		local ind = length("`ditest'") - length(" Conf. Interval]")
		local normaltitle Normal-based
		forvalues is = 1/`ind' {
			local normaltitle `" `normaltitle'"'
		}
		local ind = 24 - `ind'
		.`mytab'.titlefmt  .   .  .  %`ind's     .
        	.`mytab'.titles ""                      ///
                	""       ""                  ///
	                "`normaltitle'" ""
	}
	.`mytab'.titlefmt  .   .  .  %24s     .
        .`mytab'.titles "Level"                      ///
        	"ICC"       "Std. Err."                  ///
                "[`=strsubdp("`level'")'% Conf. Interval]" ""
        .`mytab'.sep

	forvalues i = 1/`wc' {
		// `i' determines number of conditioned for numerator
		// `wc' determines number for denominator (plus residuals)
		tempname iccexp`i'
		local `iccexp`i'' (`num`i'')/(`den')
		qui nlcom (`num`i'')/(`den')
		matrix `b' = r(b)
		tempname b`i'
		scalar `b`i'' = `b'[1,1]
		matrix `V' = r(V)
		matrix colnames `b' = ICC
		matrix colnames `V' = ICC
		matrix rownames `V' = ICC
		tempname v`i'
		scalar `v`i'' = `V'[1,1]
		scalar `kest' = ln(`b`i''/(1-`b`i''))
		scalar `sek' = sqrt(`v`i'')/(`b`i''*(1-`b`i''))	
		scalar `kl' = `kest'-`zval'*`sek'
		scalar `ku' = `kest'+`zval'*`sek'
	        tempname k`i'l k`i'u
		scalar `k`i'l' = 1/(1+exp(-`kl'))
                scalar `k`i'u' = 1/(1+exp(-`ku'))
		tempname c`i'l c`i'u
		scalar `c`i'l' = `b`i''-`zval'*sqrt(`v`i'')
		scalar `c`i'u' = `b`i''+`zval'*sqrt(`v`i'')
		if ("`normal'" != "") {
			local ciest  `c`i'l' `c`i'u'
		}
		else {
			local ciest  `k`i'l' `k`i'u'
		}
		if("`irelevel'" == "" || "`irelevel'" == "`i'") {
			if(length("`dicolivar`i''") <= `levelsize') { 
				.`mytab'.row    "`dicolivar`i''"  ///
					`b`i''  sqrt(`v`i'')      ///
					`ciest'
			}		
			else {
				local k = `wc'-`i'+2
				.`mytab'.row    "Level `k'"  ///
					`b`i''  sqrt(`v`i'')      ///
					`ciest'
			}
		}
	}
        .`mytab'.sep, bottom 
	if (`condintraclass' == 1) {
		di ///
"Note: ICC is conditional on zero values of random-effects covariates."
	}
        return hidden local normal `normal'
        return scalar level = `level'
	local i = `wc'
	while `i' != 0 {
		local k = `wc'-`i'+2
		if ("`irelevel'" == "" | "`irelevel'" == "`i'") {
			return local label`k' `dicolivar`i''
			tempname ci`k'
			if ("`normal'" == "") {
				matrix `ci`k'' = (`k`i'l' , `k`i'u') 
			}
			else {
			matrix `ci`k'' = (`c`i'l' , `c`i'u') 
			}			
			matrix rownames `ci`k'' = "icc"
			matrix colnames `ci`k'' = "ll" "ul"
			return matrix ci`k' = `ci`k''
                        return scalar se`k' = sqrt(`v`i'')
                        return scalar icc`k' = `b`i''
		}
		local i = `i' - 1
	}

        local i = `wc'
        while `i' != 0 {
                local k = `wc'-`i'+2
                if ("`irelevel'" == "" | "`irelevel'" == "`i'") {
	                return hidden local iccexp`k' ``iccexp`i'''
		}
		local i = `i' - 1
	}
end	

exit

