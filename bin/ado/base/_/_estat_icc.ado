*! version 1.0.7  11dec2015
program _estat_icc, rclass
	version 12.1
	syntax, [Level(cilevel)  ///
		NORMAL RELevel(varlist) /* undocumented
	*/	]
	// check that estat icc is appropriately used	
	// after proper command
	local ok = inlist("`e(cmd)'","xtmixed","mixed","xtmelogit","meqrlogit")
	if !`ok' {
		error 321
	}
        if ("`e(ivars)'"== "") {
                di as error "{p}requested action not valid after " ///
                        "{bf:`e(cmd)'} because there are no " ///
                        "random effects in the model{p_end}"
                exit 321
        }
	if("`relevel'" != "") {
		local w: list sizeof relevel
		if(`w' > 1) {
			di as error ///
"{bf:relevel()}: only one random level may be specified"
			exit 198
		}
		local inivars = 0
		foreach var of varlist `e(ivars)' {
			if ("`var'" == "`relevel'") {
				local inivars = 1
			}
		}
		if (`inivars' == 0) {
			di as error ///
			"level {bf:`relevel'} not found among random levels"
			exit 198
		}	
	}
	// and not after a crossed model
	// revars should not contain R.
	local cross = 0
	local erevars `e(revars)'
	local lrevar: subinstr local erevars `"R."' `""', all		
	if length(`"`lrevar'"') != length("`e(revars)'") {
		local cross = 1
	}
	// levels should not contain "_all "
	local eivars `e(ivars)'
	local livars: subinstr local eivars `"_all"' `""', all word
	if length(`"`livars'"') != length("`e(ivars)'") {
		local cross = 1
	}
	if (`cross') {
		di in smcl as error ///
		"{bf:estat icc} not allowed after crossed-effects models"
		exit 321
	}
	if "`e(cmd)'"=="xtmixed" | "`e(cmd)'"=="mixed" {
                // linear mixed-effects model
                // covariance() option is irrelevant, as only intercept
                // is used in each equation
                // but residuals() is relevant
                //      allowed         independent
                capture assert ("`e(rstructure)'" == "independent")
                if (_rc) {
                        di as error ///
                                "{p}{bf:estat icc} not allowed after" ///
	                        " random-effects models with residual" ///
                                " structures other than the " ///
				"default independent structure{p_end}"
                        exit 321
                }
                local eresopt `e(resopt)'
                local lresopt: subinstr local eresopt `"by"' `""', all
                if length(`"`lresopt'"') != length("`e(resopt)'") {
                        di as error ///
                                "{p}{bf:estat icc} not allowed after" ///
                                " random-effects models with residual" ///
	                        " structures other than the " ///
                                "default independent structure{p_end}"
                        exit 321
                }
        }

	// if revars without _cons is empty
	// then no covariates
	// otherwise
	local erevars `e(revars)'
	local ncrevars: subinstr local erevars `"_cons"' `""', all
	local ncrevars = ltrim(`"`ncrevars'"')
	local hasRcovariates = 1
	if("`ncrevars'" == "") {
		local hasRcovariates = 0
	}
	local hasFcovariates = 1
	if (e(k_f) == 1) {
		// now check that it isn't constant
		tempname bb
		matrix `bb' = e(b)		
		local bname: colfullnames `bb'
		local f: word 1 of `bname'
		if ("`f'" == "`e(depvar)':_cons") {
			local hasFcovariates = 0
		}	
	}
	else if (e(k_f) == 0) {
		local hasFcovariates = 0
	}

	// ivars without duplicates
	local ndivars
	local pf
	// level`i'	name of level
	local levelind = 1
	foreach l in `e(ivars)' {
		if ("`l'" != "`pf'") {
			local ndivars `ndivars' `l'
			local pf `l'
			local level`levelind' `l'
			local `levelind' = `levelind' + 1
		}
	}
	local nlevels: word count `ndivars'
	
	// basically expand redim and ivars
	// so that they may be used to line up revars
	local er `e(redim)'
	local wc: list sizeof er
	local er `e(ivars)'
	local wci: list sizeof er
	assert `wc' == `wci'
	local redsimsum = 0
	local efind = 1
	local nlev = 0
	local lmatlab
	local plev 
	forvalues i = 1/`wc' {
		local w: word `i' of `e(redim)'
		local lev: word `i' of `e(ivars)'
		if(`"`lev'"' != `"`plev'"') {
			local eqc 1
			local nlev = `nlev' + 1
			local plev `lev'
		}
		else {
			local eqc = `eqc' + 1
		}
		if (`w' > 0) {
			forvalues j = 1/`w' {
				local nlab`efind' = `nlev'
				local llab`efind' = `lev'
				local eq`efind' = `eqc'
				local efind = `efind' + 1
			}
		}		
	}
	local er `e(revars)'
	local wc: list sizeof er
	
	//now loop over revars, for each _constant
	//determine level and equation
	// leveleb`i' is the [XXXX]_b[_cons] needed for nlcom for level `i'
	// or 0 if there is no intercept
	// initialize leveleb`i' with this default case first
	forvalues i = 1/`nlevels' {
		local leveleb`i' 0
	}
	//now loop over revars and replace leveleb`i' as necessary
	//nlab`j' computed earlier matches the level with intercept in
	//leveleb`nlab`j''
	local alleb: colfullnames e(b)
	local tempadd
	forvalues j = 1/`wc' {
		local w: word `j' of `e(revars)'
		if ("`w'" == "_cons") {
			// use nlab`j' and eq`j' to get 
			// proper parts of e(b)
			// constant will always be last in
			// equation with lns label
			foreach word of local alleb {
				if(bsubstr(`"`word'"',1, ///
					length(`"lns`nlab`j''_`eq`j''_"')) ///
						==`"lns`nlab`j''_`eq`j''_"') {
					local tempadd =	bsubstr("`word'",1, ///
						length("`word'")- ///
						length(":_cons"))
					local tempadd [`tempadd']_b[_cons]
				}
			}
			if ("`tempadd'" != "") {
				local leveleb`nlab`j'' exp(`tempadd')^2
			}	
			local tempadd		
		}
	}
	// if any of leveleb`i' is zero
	// intercept missing from level
	forvalues i = 1/`nlevels' {
		if (`leveleb`i'' == 0) {
			di as error ///
                                "{p}{bf:estat icc} not allowed after" ///
                                " random-effects models with random-level" ///
                                " specifications that do not contain" ///
				" random intercepts{p_end}"
			exit 321
		} 
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
	
	local wc: word count `ndivars'
	local colivar `ndivars'
	tokenize `colivar' 
	local dicolivar 
	// separate nlcom for each ICC, since we won't do any covariance
	// between the separate estimates
	
	// get denominator
	local den 0
	forvalues j=1/`wc' {
		local den `den' + `leveleb`j''
	}
	if "`e(cmd)'"=="xtmelogit" | "`e(cmd)'"=="meqrlogit" {
		local den `den' + (_pi^2)/3
	}
	else if "`e(cmd)'"=="xtmixed" | "`e(cmd)'"=="mixed" {
		local den `den' + exp([lnsig_e]_b[_cons])^2
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
		local num 0
		forvalues k=1/`i' {
			local num `num' + `leveleb`k'' 
		}
		tempname iccexp`i'
		local `iccexp`i'' (`num')/(`den')
		qui nlcom (`num')/(`den')
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
