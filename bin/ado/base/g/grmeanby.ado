*! version 1.4.3  16feb2015  
program define grmeanby, sort
	version 6, missing
	if _caller() < 8 {
		grmeanby_7 `0'
		exit
	}

	syntax varlist [if] [in] [aw fw],	///
		SUmmarize(varname)		///
		[				///
		MEDian				///
		*				///
		]
	
	_get_gropts , graphopts(`options')
	local options `"`s(graphopts)'"'

	if "`median'"=="" {
		local sumopts
		local sumres "r(mean)"  /* result found after -summ- */
		local ttlhead "Means"
	}
	else {
		local sumopts ", detail"
		local sumres "r(p50)"   /* result found after -summ- */
		local ttlhead "Medians"
	}

	tempvar touse x mean lbl grp strv id mine wgt
	mark `touse' [`weight'`exp'] `if' `in'

quietly {
	gen `x' = . 
	gen `mean' = . 
	gen str10 `lbl' = ""
	gen `c(obs_t)' `id'=_n
	tokenize `varlist'
	local o 1
	local i 1

	if "`weight'"!="" {
		gen `wgt' `exp' if `touse'
		local weight "[`weight'=`wgt']"
		local ttlhead = "Weighted " + /* 
			*/ lower(bsubstr(`"`ttlhead'"',1,1)) + /* 
			*/ bsubstr(`"`ttlhead'"',2,.)
	}

	while "``i''"!="" {
		local vl ``i''
		local xlabels `"`xlabels' `i' `"`vl'"'"'

		egen `grp'=group(``i'') if `touse'
		local t : type ``i''
		if bsubstr("`t'",1,3)=="str" {
			gen str8 `strv' = ``i''
		}
		else {
			local t : value label ``i''
			if "`t'"=="" {
				gen str10 `strv'=string(``i'')
			}
			else	decode ``i'', gen(`strv') maxlength(8)
		}
		sum `grp'
		local maxg=r(max)
		local j 1
		while `j'<=`maxg' {
			if `o'+1>_N {
				error 1001
			}
			sum `summari' `weight' if `grp'==`j' `sumopts'
			replace `mean' = `sumres' if `id'==`o'
			replace `x'=`i' if `id'==`o'
			gen `mine'=1 if `grp'==`j'
			sort `mine'
			replace `lbl'=`strv'[1] if `id'==`o'
			drop `mine' 
			local o=`o'+2
			local j=`j'+1
		}
		drop `strv' `grp'
		capture label drop `strv'
		local i=`i'+1
	}
	sort `x' `mean'
	replace `mean'=-`mean'
	sort `x' `mean'
	replace `mean'=-`mean'
	sum `summari' `weight' if `touse'==1 `sumopts'
	local yline=`sumres'
} // quietly

	local title `"`ttlhead' of `summari'"'
	local t : variable label `summari'
	if "`t'"!="" {
		local title `"`title', `t'"'
	}

	local max = `i'-.5
	gsort -`x'
	version 8: graph twoway				///
	(connected `mean' `x',				///
		connect(ascending)			///
		mlabels(`lbl')				///
		title(`"`title'"')			///
		ytitle("")				///
		xtitle("")				///
		yline(`yline')				///
		ylabels(, nogrid)			///
		xlabels(`xlabels', nogrid)		///
		xscale(range(.5 `max'))			///
		`options'				///
	)						///
	// blank
end
