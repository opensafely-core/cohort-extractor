*! version 1.0.1  26may2011
program sem_estat_eqgof, rclass
	version 12
	
	if "`e(cmd)'" != "sem" { 
		error 301
	}	

	syntax [, FORmat(str) ]

	if (e(k_ly) + e(k_oy) == 0) {
		di as txt "(model has no endogenous variables)"
		exit 
	}
	local ng = `e(N_groups)'	
	if "`format'"!="" { 
		local junk : display `format' 1
		if length("`junk'") > 9 {
			di as err "invalid format;"
			di as err "width too large"
			exit 198
		}
		local fmt `format'
	}
	else {
		local fmt %9.0g
	}
	tempname nobs
	matrix `nobs' = e(nobs)

	forvalues group = 1/`ng' { 
		local hopt = cond(`group'==1, "nobefore", "")
		sem_groupheader `group', `hopt' nohline 
		
		local gg = cond(`ng'>1, "_`group'", "")
		local eqold

		tempname eqfit`gg' CD`gg'
		
		mata: st_sem_estat_eqgof(	///
			`group',		///
			"`eqfit`gg''", 		///
			"`CD`gg''")
		
		local ny      = rowsof(`eqfit`gg'')
		local vnames  : rownames `eqfit`gg''
		local eqnames : roweq    `eqfit`gg''
	
		dis _n as txt "Equation-level goodness of fit"
		dis
		dis as txt "{hline 13}{c TT}{hline 33}{c TT}{hline 30}"
		dis as txt _col(14) "{c |}" _col(28) ///
			"Variance" _col(48) "{c	|}"
		dis as txt %12s "depvars" " {c |}" 			///
			"    fitted  predicted   residual {c |}"	///
			" R-squared        mc      mc2"
		dis as txt "{hline 13}{c +}{hline 33}{c +}{hline 30}" 
		forvalues i = 1/`ny' {
			gettoken vn vnames : vnames
			local vn = abbrev("`vn'",12)
			
			gettoken eq eqnames : eqnames

			if "`eq'"!="`eqold'" {
				local eqold `eq'
				dis as res "`eq'" ///
				    as txt _col(14) "{c |}" _col(48) "{c |}" 
			}
		
			local res1 : display `fmt' `eqfit`gg''[`i',1]	
			local res2 : display `fmt' `eqfit`gg''[`i',2]	
			local res3 : display `fmt' `eqfit`gg''[`i',3]	
			local res4 : display `fmt' `eqfit`gg''[`i',4]	
			local res5 : display `fmt' `eqfit`gg''[`i',5]	
			local res6 : display `fmt' `eqfit`gg''[`i',5]^2	

			dis as txt %12s "`vn'" " {c |}" 	///
			    as res _col(16) %9s "`res1'"	///
			    as res _col(27) %9s "`res2'"	///
			    as res _col(38) %9s "`res3'"	///
			    as txt _col(48) "{c |}"		///
			    as res _col(50) %9s "`res4'"	///
			    as res _col(60) %9s "`res5'"	///
			    as res _col(70) %9s "`res6'"	
		}	
		local res : display `fmt' `CD`gg''
		dis as txt "{hline 13}{c +}{hline 33}{c +}{hline 30}" 	
		dis as txt %12s "overall" " {c |}" 			///
		    as txt _col(48) "{c |}" 				///
		    as res _col(50) %9s "`res'"
		dis as txt "{hline 13}{c BT}{hline 33}{c BT}{hline 30}" 
	
		// footnote
		dis as txt "mc  = correlation between depvar and " ///
			"its prediction"
		dis as txt "mc2 = mc^2 is the Bentler-Raykov squared multiple" ///
			" correlation coefficient"
	}

	return scalar N_groups = `ng'
	return matrix nobs = `nobs'
	forvalues group = 1/`ng' { 
		local gg = cond(`ng'>1, "_`group'", "")
		return matrix eqfit`gg' = `eqfit`gg''
		return scalar CD`gg'    = `CD`gg''
	}	
end

exit

