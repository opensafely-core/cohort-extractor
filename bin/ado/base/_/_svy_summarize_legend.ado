*! version 1.1.1  05apr2011
program _svy_summarize_legend
	version 9
	args blank cmd

	if ("`cmd'"=="") {
		local cmd `e(cmd)'
	}

	SvySumLegend `cmd' `blank'
	if `"`e(over_labels)'"' != "" {
		SvySumOverLegend `s(blank)'
	}
end

program SvySumLegend, sclass
	args cmd blank
	if (!inlist("`cmd'", "ratio", "proportion")) {
		sreturn clear
		sreturn local blank `blank'
		exit
	}
	if "`cmd'" == "ratio" {
		local names `e(namelist)'
		local varlist `e(varlist)'
		forval i = 1/`:word count `names'' {
			if ("`blank'" == "") di
			local blank myblank
			local name : word `i' of `names'
			local var1 : word `=2*`i'-1' of `varlist'
			local var1 = abbrev("`var1'",23)
			local var2 : word `=2*`i'' of `varlist'
			local var2 = abbrev("`var2'",23)
			di as txt %13s abbrev(`"`name'"',12)  ": "	///
			   as res `"`var1'/`var2'"'
		}
	}
	else {
		local names `e(namelist)'
		local pvars `e(varlist)'
		local k 1
		foreach pnam of local pvars {
			local labels `"`e(label`k')'"'
			while `"`labels'"' != "" {
				gettoken name names : names
				gettoken plab labels : labels
				if `"`e(over)'"' != "" |	///
				`"`name'"' != `"`plab'"' {
					if ("`blank'" == "") di
					local blank myblank
					local name = abbrev(`"`name'"',12)
					di as txt %13s "`name'"	": "	///
					   as txt "`pnam' = "		///
					   as res `"`plab'"'
				}
			}
			local ++k
		}
	}
	if "`blank'" == "myblank" {	// add a blank line after the legend
		di
	}
	sreturn clear
	if "`blank'" != "" {
		sreturn local blank blank
	}
end

program SvySumOverLegend, sclass
	args blank
	local novervars : word count `e(over)'
	if `novervars' == 0 {
		sreturn clear
		sreturn local blank `blank'
		exit
	}
	else if `novervars' == 1 {
		local overvareq `"as txt "`e(over)' = ""'
	}
	else if `novervars' > 1 {
		if ("`blank'" == "") di
		local blank myblank
		di as txt %13s "Over" ": `e(over)'"
	}
	local names `e(over_namelist)'
	local labels `"`e(over_labels)'"'
	while `"`labels'"' != "" {
		gettoken name names : names
		gettoken lab labels : labels
		if ("`blank'" == "") di
		local blank myblank
		local name = abbrev(`"`name'"',12)
		di as txt %13s "`name'" ": " `overvareq' as res `"`lab'"'
	}
	if "`blank'" == "myblank" {	// add a blank line after the legend
		di
	}
	sreturn clear
	if "`blank'" != "" {
		sreturn local blank blank
	}
end

exit
