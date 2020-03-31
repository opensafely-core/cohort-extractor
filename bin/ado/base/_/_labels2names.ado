*! version 1.1.2  27jan2017
program _labels2names, sclass sortpreserve
	version 9
	syntax varname(numeric) [if] [in] [,	///
		Missing				///
		noLABel				///
		stub(name)			///
		Indexfrom(integer 1)		///
		noINTegers			///
		Namelist(string)		///
		RENUMber			///
	]

	local cat `varlist'
	if "`stub'" == "" {
		local stub _name_
	}
	if "`missing'" != "" {
		local novarlist novarlist
	}
	marksample touse, `novarlist'
	quietly count if `touse'
	if r(N) == 0 {
		error 2000
	}
	local nobs1 = c(N) - r(N) + 1
	sort `touse' `cat'
	tempvar x
	quietly gen byte `x' = `cat' != `cat'[_n-1] in `nobs1'/l
	quietly replace `x' = 1 in `nobs1'
	quietly count if `x' == 1
	local n_cat = r(N)
	quietly by `touse' `cat' : replace `x' = _N

	if "`label'" == "" {
		local label : value label `cat'
		capture label list `label'
		// `label' might be an empty value label name
		if (c(rc)) local label
	}
	else	local label
	local j `indexfrom'
	forval i = 1/`n_cat' {
		local tag
		local lab
		local val
		local hasspace 0
		if "`label'" != "" {
			local lab : label `label'	///
				`=`cat'[`nobs1']'	///
				`c(namelenchar)'
			local hasspace = strpos(`"`macval(lab)'"'," ")
			capture {
				assert `hasspace' == 0
				confirm name `lab'
			}
			if !c(rc) {
				// found a valid name
				local tag `lab'
			}
			else if "`integers'" == "" {
				// found (nonnegative) integer value
				capture confirm integer number `lab'
				if !c(rc) &			///
				( ("`renumber'" != "") |	///
				  (string(`cat'[`nobs1']) == `"`lab'"') ) {
					if (`lab' >= 0) local tag `lab'
				}
			}
		}
		else {
			local val = string(`cat'[`nobs1'])
			if "`integers'" == "" {
				capture confirm integer number `val'
				if !c(rc) {
					// found (nonnegative) integer value
					if (`val' >= 0) local tag `val'
				}
			}
		}
		if "`tag'" == "" |	///
		("`tag'" != "" & `:list tag in namelist') {
			local tag `stub'`j++'
			while `:list tag in namelist' {
				local tag `stub'`j++'
			}
		}
		else	local ++j
		local namelist `namelist' `tag'
		local names `names' `tag'
		if `hasspace' {
			local labels `"`labels' `"`macval(lab)'"'"'
		}
		else	local labels `"`labels' `macval(lab)'`val'"'
		local nobs1 = `nobs1' + `x'[`nobs1']
	}

	sreturn clear
	sreturn local n_cat	`n_cat'
	sreturn local names	`names'
	sreturn local namelist	`namelist'
	local labels : list retok labels
	sreturn local labels	`"`macval(labels)'"'
	sreturn local indexfrom	`j'
end

exit
