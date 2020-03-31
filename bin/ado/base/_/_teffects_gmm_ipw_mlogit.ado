*! version 1.0.0  23may2013

program define _teffects_gmm_ipw_mlogit
	version 13
	syntax varlist if, at(name) tvars(varlist) tlevels(string)       ///
		tvarlist(varlist) stat(string) ipw(name) control(string) ///
		[ treated(string) derivatives(varlist) prlist(namelist) ]

	local att = ("`stat'"=="att")
	local kvar : list sizeof tvarlist
	local klev : list sizeof tlevels
	local kpar = (`klev'-1)*`kvar'
	/* programmer error						*/
	if (colsof(`at')!=`kpar') error 503

	tempvar den p xb
	tempname bx b0 mp

	qui gen double `den' = 1 `if'
	local i2 = 0
	forvalues j=1/`klev' {
		if ("`prlist'"=="") tempvar p`j'
		else local p`j' : word `j' of `prlist'

		local lev : word `j' of `tlevels'
		if `lev' == `control' {
			local jc = `j'
			continue
		}
		local i1 = `i2' + 1
		local i2 = `i2' + `kvar'
		mat `bx' = `at'[1,`i1'..`i2']
		mat colnames `bx' = `tvarlist'
		mat score double `p`j'' = `bx' `if'
		qui replace `p`j'' = exp(`p`j'') `if'
		qui replace `den' = `den' + `p`j'' `if'
	}
	
	qui gen double `p`jc'' = 1/`den' `if'
	/* ATE & ATT `tj' is the constant term, a full vector of ones	*/
	local tj : word `jc' of `tvars'
	qui gen double `p' = `p`jc'' `if' & `tj'
	local i = 0
	forvalues j=1/`klev' {
		if `j' == `jc' {
			continue
		}
		local tj : word `j' of `tvars'
		qui replace `p`j'' = `p`j''/`den' `if'
		qui replace `p' = `p`j'' `if' & `tj'
		local r : word `++i' of `varlist'
		qui replace `r' = `tj'-`p`j'' `if'
	}
	qui replace `p' = max(`p',c(epsdouble)) `if'

	if `att' {
		local tr : list posof "`treated'" in tlevels
		qui gen double `ipw' = `p`tr''/`p' `if'
	}
	else qui gen double `ipw' = 1/`p' `if'

	summarize `ipw' `if', meanonly
	scalar `mp' = r(mean)
	qui replace `ipw' = `ipw'/`mp' `if'

	if ("`derivatives'"=="") exit

	tempvar dp pp

	qui gen double `dp' = .
	local kpar = `kpar' + `klev'
	local k = `klev'
	if `att' {
		/* macro tr, index of the treated, set above		*/
		forvalues j=1/`klev' {
			local lev : word `j' of `tlevels'
			if `lev' == `control' {
				local jc = `j'
				continue
			}
			local tj : word `j' of `tvars'
			if `lev' == `treated' {
				qui replace `dp' = ///
					cond(`tj',0,-`p`tr''/`p'/`mp') `if'
			}
			else {
				qui replace `dp' = ///
					cond(`tj',`p`tr''/`p'/`mp',0) `if'
			}
			forvalues i=1/`kvar' {
				local dk : word `++k' of `derivatives'
				local vi : word `i' of `tvarlist'
				qui replace `dk' = `dp'*`vi' `if'
				summarize `dk' `if', meanonly

				qui replace `dk' = -`dk'+ ///
					`p`tr''*r(mean)/`mp'/`p' `if'
			}
		}
	}
	else {
		qui gen double `pp' = `p'^2 `if'

		forvalues j=1/`klev' {
			local lev : word `j' of `tlevels'
			if `lev' == `control' {
				local jc = `j'
				continue
			}
			local tj : word `j' of `tvars'
			qui replace `dp' = cond(`tj',`p`j''*(1-`p`j''), ///
				 -`p`j''*`p') `if'
			qui replace `dp' = `dp'/`pp'/`mp' `if'
			forvalues i=1/`kvar' {
				local dk : word `++k' of `derivatives'
				local vi : word `i' of `tvarlist'
				qui replace `dk' = `dp'*`vi' `if'
				summarize `dk' `if', meanonly

				qui replace `dk' = -`dk'+r(mean)/`mp'/`p' `if'
			}
		}
	}
	local k = `kpar'
	forvalues j=1/`klev' {
		if `j' == `jc' {
			continue
		}
		local k = `k' + `klev'
		forvalues l=1/`klev' {
			if `l' == `jc' {
				continue
			}
			if `l' == `j' {
				qui replace `dp' = -`p`j''*(1-`p`j'') `if'
			}
			else {
				qui replace `dp' = `p`j''*`p`l'' `if' 
			}
			forvalues i=1/`kvar' {
				local dk : word `++k' of `derivatives'
				local vi : word `i' of `tvarlist'
				qui replace `dk' = `dp'*`vi' `if'
			}
		}
	}	
end
exit
