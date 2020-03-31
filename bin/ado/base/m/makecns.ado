*! version 1.1.1  03feb2010
program makecns
	if _caller() < 11 {
		MakeCns `0'
		exit
	}
	_makecns `0'
end

program MakeCns, rclas
	version 8.0
	local vv = _caller()
	syntax [anything(name=clist id="constraint list")]	///
	[,							///
		noCNSNOTEs					///
		DIsplaycns					///
		R						///
	]

	if `"`cnsnotes'"' != "" {
		local qui quietly
	}

	// make the constraints matrix
	if (`vv' <= 8)	OldMakeCns `clist'
	else {
		`qui' MakeValidCns `clist'
		return local err `r(err)'
		local clist `r(clist)'
	}

	// print out the accepted constraints
	if `"`displaycns'`r'"' != "" {
		matrix dispCns, `r'
		if (`"`r'"' != "") return add
	}
	return local clist `clist'
end

// Syntax:
//   MakeValidCns [ clist | matname ]
//
// loop through the supplied constraint definitions, dropping those
// constraints that cause a problem;
program MakeValidCns, rclass
	local err 0
	local rc 0
	local ncns : list sizeof 0
	// check for constraint matrix
	if `ncns' == 1 {
		capture confirm matrix `0'
		if !c(rc) {
			// put `0' in `cns', and make `0' empty
			gettoken cns 0 : 0
			capture matrix makeCns `cns'
			local rc = _rc
			if `rc' {
				di in smcl as txt ///
"(note: constraint matrix '`cns'' caused error {search r(`rc')})"
			}
			else	local clist `cns'
		}
	}
	// go through each constraint number building `clist'
	if `:length local 0' {
		capture numlist "`0'"
		if !c(rc) {
			local 0 `"`r(numlist)'"'
		}
	}
	foreach cns of local 0 {
		if `ncns' > 1 {
			capture confirm integer number `cns'
			if _rc {
				di as err	///
"'" `"`cns'"' "'"				///
`" found where constraint number expected"' _n	///
`"constraint numbers and matrices may not be combined"'
				exit 7
			}
		}
		capture matrix makeCns `clist' `cns'
		local rc = _rc
		if `rc' {
			local err++
			di in smcl as txt ///
"(note: constraint number `cns' caused error {search r(`rc')})"
		}
		else	local clist `clist' `cns'
	}
	// just in case the last one failed
	if `rc' {
		matrix makeCns `clist'
	}
	return local clist `clist'
end

// this is essentially what -ml_model- did to run -matrix makeCns-
program OldMakeCns
	capture matrix makeCns `0'
	local rc = _rc
	if `rc' {
		di as err "Constraints invalid:"
		mat makeCns `0'
		exit `rc'
	}
end

exit
