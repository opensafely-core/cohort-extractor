*! version 1.0.0  17may2019
program twoway__meta_funnel_gen, rclass
	version 16
	syntax [varlist(max=2 default=none)] [if] [in] 	///
		[,					///
			THETA(string)			///
			N(integer 1)			///
			range(string)			///
			metric(string)			///
			method(string)			///
			Level(cilevel)			///
			GENerate(string asis)		///
			Contours(int 0)			///
			LOWer				///
			UPper				///
		]

	if `n' < 1 {
		di as err "option {bf:n()} requires a positive integer"
		exit 198
	}

	local nrange : list sizeof range
	if `nrange' == 2 {
		local rmin : word 1 of `range'
		local rmax : word 2 of `range'
		capture {
			confirm number `rmin'
			confirm number `rmax'
		}
		if c(rc) {
			di as err "invalid {bf:range()} option;"
			confirm number `rmin'
			confirm number `rmax'
			error 198	// [sic]
		}
	}
	else if `nrange' != 0 {
		di as err "option {bf:range()} requires two numbers"
		exit 198
	}

	local nvars : list sizeof varlist
	if `nvars' == 0 {
		local y _meta_se
		local x _meta_es
	}
	else if `nvars' == 1 {
		local y : copy local varlist
		local x _meta_es
	}
	else {
		local y : word 1 of `varlist'
		local x : word 2 of `varlist'
	}

	local ngen : list sizeof generate
	local ymin0 0
	if inlist(`"`metric'"', "", "se") {
		local metric se
		local yexp `y'
		local xexp @@
		local ymin0 1
		local n 2
	}
	else if "`metric'" == "invse" {
		local yexp 1/`y'
		local xexp 1/@@ 
	}
	else if "`metric'" == "var" {
		local yexp `y'^2
		local xexp sqrt(@@)
		local ymin0 1
	}
	else if "`metric'" == "invvar" {
		local yexp `y'^(-2)
		local xexp 1/sqrt(@@)
	}
	else if "`metric'" == "n" {
		if `ngen' == 3 {
			di as err ///
			"option {bf:contours()} not supported with metric" ///
			" {bf:n}"
			exit 198
		}
		local yexp _meta_studysize
		local n 2
	}
	else if "`metric'" == "invn" {
		if `ngen' == 3 {
			di as err ///
			"option {bf:contours()} not supported with metric" ///
			" {bf:invn}"
			exit 198
		}
		local yexp 1/_meta_studysize
		local n 2
	}
	else {
		di as err "metric {bf:`metric'} not allowed"
		exit 198
	} 

	if `"`method'"' == "" {
		local method ivariance
	}	

	if `ngen' == 3 {
		local geny1 : word 1 of `generate'
		local geny2 : word 2 of `generate'
		local genx : word 3 of `generate'
		capture {
			confirm new variable `geny1'
			confirm new variable `geny2'
			confirm new variable `genx'
		}
		if c(rc) {
			di as err ///
			"option {bf:generate()} incorrectly specified;"
			confirm new variable `geny1'
			confirm new variable `geny2'
			confirm new variable `genx'
			error 110	// [sic]
		}
	}
	else if `ngen' == 2 {
		if "`lower'`upper'" == "" {
			local n 2
		}
		local geny : word 1 of `generate'
		local genx : word 2 of `generate'
		capture {
			confirm new variable `geny'
			confirm new variable `genx'
		}
		if c(rc) {
			di as err ///
			"option {bf:generate()} incorrectly specified;"
			confirm new variable `geny'
			confirm new variable `genx'
			error 110	// [sic]
		}
	}
	else if `ngen' == 1 {
		local geny : copy local generate
		capture confirm new variable `geny'
		if c(rc) {
			di as err ///
			"option {bf:generate()} incorrectly specified;"
			confirm new variable `geny'
			error 110	// [sic]
		}
	}
	else if `ngen' != 0 {
		di as err "option {bf:generate()} incorrectly specified"
		exit 198
	}

	if "`lower'`upper'" != "" {
		opts_exclusive "`lower' `upper'"
		if `contours' == 0 {
			di as err "{p}"
			di as err "option {bf:`lower'`upper'} requires"
			di as err "option {bf:contours()}"
			di as err "{p_end}"
			exit 198
		}
		if `ngen' == 1 {
			di as err ///
			"option {bf:generate()} incorrectly specified;"
			error 102
		}
		else if `ngen' == 3 {
			di as err ///
			"option {bf:generate()} incorrectly specified;"
			error 103
		}
	}

	marksample touse		

	// Saved results

	return local method "`method'"
	return local metric "`metric'"
	return local y `"`y'"'
	return local x `"`x'"'
	if `nrange' {
		return scalar ymin = `rmin'
		return scalar ymax = `rmax'
	}
	else {
		tempname fy
		qui gen double `fy' = `yexp' if `touse'
		sum `fy', mean
		if `ymin0' {
			return scalar ymin = 0
		}
		else {
			return scalar ymin = r(min)
		}
		return scalar ymax = r(max)
	}
	sum `x', mean
	return scalar xmin = r(min)
	return scalar xmax = r(max)

	tempname info
	mata: st_matrix("`info'",	///
		_sma_iv("`x'", "`y'", "`method'", "`touse'")) 
	if "`theta'" == "" {
		return scalar theta = `info'[1,1]
	}
	else {
		return scalar theta = `theta'
	}

	if `n' == 1 {
		return scalar delta = .		// on purpose
	}
	else	return scalar delta = (return(ymax)-return(ymin))/(`n'-1)
	return scalar n = `n'

	if _N < `n' {
		return local preserve "preserve"
	}

	if `ngen' == 0 {
		exit
	}

	if `ngen' == 1 {
		if "`fy'" == "" {
			tempname fy
			qui gen double `fy' = `yexp' if `touse'
		}
		rename `fy' `geny'
		exit
	}

	if _N < `n' {
		qui set obs `n'
	}

	if `ngen' == 2 & "`lower'`upper'" == "" {
		tempname newx newy
		qui ///
		gen double `newx' = return(ymin) + return(delta)*(_n-1) in 1/2
		qui gen double `newy' = return(theta)
		label variable `newx' "Estimated Effect"
		rename `newy' `geny'
		rename `newx' `genx'
		exit
	}

	tempname z newx
	if `contours' == 0 {
		scalar `z' = invnormal((100-`level')/200)
	}
	else {
		if "`lower'`upper'" == "" {
			local denom 200
		}
		else	local denom 100
		scalar `z' = invnormal(`contours'/`denom')
	}
	qui gen double `newx' = return(ymin) in 1
	if `n' >= 2 {
		qui ///
		replace `newx' = return(ymin) + return(delta)*(_n-1) in 2/`n'
	}
	local xexp : subinstr local xexp "@@" "`newx'", all

	if "`lower'`upper'" != "" {
		if "`lower'" == "" {
			local minus "-"
		}
		tempname newy
		qui gen double `newy' = `minus' `xexp'*`z'
		label variable `newx' "`contours'% Significance"
		rename `newy' `geny'
		rename `newx' `genx'
		exit
	}

	tempname newy1 newy2
	if `contours' == 0 {
		qui gen double `newy1' = return(theta) - `xexp'*`z'
		qui gen double `newy2' = return(theta) + `xexp'*`z'
		label variable `newy1' "Pseudo `level'% CI"
		label variable `newy2' "Pseudo `level'% CI"
	}
	else {
		qui gen double `newy1' = - `xexp'*`z'
		qui gen double `newy2' = `xexp'*`z'
		label variable `newy1' "`contours'% Significance"
		label variable `newy2' "`contours'% Significance"
	}

	rename `newy1' `geny1'
	rename `newy2' `geny2'
	rename `newx' `genx'
end

exit
