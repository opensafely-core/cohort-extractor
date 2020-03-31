*! version 1.0.3  13feb2015

program define _pss_chk_multilist, sclass
	version 13.0
	syntax [ anything(name=args) ], option(string) [ levels(string) ///
		nlevels(integer 0) range(passthru) integer sum1 nm1 ]

	/* multiple calls, must clear sreturn				*/
	/* sum1 : specifies that args must sum to 1, may give		*/
	/*  	 nlevels-1 args						*/
	/* nm1  : specifies that there can only be nlevels-1 args	*/
	sreturn clear
	if ("`levels'"=="") local levels levels

	if (`nlevels'<0) {
		/* negative values sets the minimum number of levels	*/
		/* allowed						*/
		local minlev = -`nlevels'
		/* count the number of levels				*/
		local nlevels = 0
	}
	else local minlev = 2

	local j = 0
	local sum1 = ("`sum1'"!="")
	local nm1 = ("`nm1'"!="")
	local k : list sizeof args
	local ismat = 0
	if `k' == 1 {
		cap confirm name `args'
		local ismat = !c(rc)
	}
	if !`ismat' {
		local matspec : subinstr local args "\" "\", count(local ismat)
	}
	if `ismat' {
		tempname arg1
		_pss_chk_matspec `"`option'"' "missing" : `"`args'"'
		mat `arg1' = r(mat)
		if (!`nlevels') {
			local nlevels = colsof(`arg1')
			if (`nlevels'==1) local nlevels = rowsof(`arg1')
			if `nlevels' < `minlev' {
				di as err "{p}invalid `option'; must "  ///
				 "have at least `minlev' `levels', but " ///
				 "`nlevels' were found{p_end}"
				exit 503
			}
		}
		local j = 1
	}
	else {
		while ("`args'" != "") {
			gettoken arg`++j' args : args, match(par)
		}
	}
	local narg = `j'

	if `narg' == 1 {
		cap numlist "`arg1'"
		if c(rc) {
			/* check for matrix				*/
			Matrix2Numlists "`option'" "`arg1'" `nlevels'     ///
				`minlev' "`levels'" "`range'" "`integer'" ///
				"`sum1'" "`nm1'"
			exit
		}
	}
	if `nlevels' {
		local nlevels1 = `nlevels'-1
		if `sum1' {
			if `narg'!=`nlevels' & `narg'!=`nlevels1' {
				di as err "{p}invalid `option': expected "  ///
				 "`nlevels1' or `nlevels' values or "       ///
				 "{help numlist}s in parentheses, but got " ///
				 "`narg'; there are `nlevels' `levels'"{p_end}"
				exit (122+(`narg'>`nlevels'))
			}
		}
		else if `nm1' {
			if `narg' != `nlevels1' {
				di as err "{p}invalid `option': expected " ///
				 "`nlevels1' values or {help numlists} "   ///
				 "in parentheses, but got `narg'{p_end}"
				exit (122+(`narg'>`nlevels1'))
			}
		}
		else if `narg' != `nlevels' {
			di as err "{p}invalid `option': expected `nlevels' " ///
			 "values or {help numlist}s in parentheses, but " ///
			 "got `narg'{p_end}"
			exit (122+(`narg'>`nlevels'))
		} 
	}
	else {
		local nlevels = `narg'
		if `nlevels' < `minlev' {
			di as err "{p}invalid `option': at least `minlev' " ///
			 "`levels' are required{p_end}"
			exit 122
		}
	}
	if ("`integer'"!="") local extra " integers"
	if ("`range'"!="") local extra1 " in `range'"
	forvalues j=1/`narg' {
		cap numlist "`arg`j''", `range' `integer'
		local rc = _rc
		if `rc' == 121 {
			di as err "{p}invalid `option': `nlevels' values " ///
			 "or {help numlist}s enclosed in parentheses "     ///
			 "expected{p_end}"
			exit `rc'
		}
		if `rc' { 
			di as err "{p}invalid `option'; elements not " ///
			 "`extra'`extra1'{p_end}"
			exit `rc'
		}
		local nlist `"`r(numlist)'"'

		sreturn local numlist`j' `"`nlist'"'
	}
	sreturn local nlevels = `nlevels'
end


program define Matrix2Numlists, sclass
	args option matname nlevels minlev levels range integer sum1 nm1

	local 0, matname(`matname')
	cap syntax, matname(name)
	if `c(rc)' {
		if (`nlevels') local nlab "`nlevels' "
		di as err "{p}invalid `option' specification; `nlab'" ///
		 "values, multiple {help numlist}s enclosed in "      ///
		 "parentheses, or matrix name is required{p_end}"
		exit 198
	}
	cap mat list `matname'
	local rc = c(rc)
	if `rc' {
		di as err "{p}invalid `option': matrix {bf:`matname'} not " ///
		 "found{p_end}"
		exit 111
	}

	tempname m0
	local c = colsof(`matname')
	local r = rowsof(`matname')
	if `c' == 1 {
		local c = rowsof(`matname')
		local r = 1
		mat `m0' = `matname''
	}
	else mat `m0' = `matname'

	if `nlevels' > 0 {
		/* # levels known, checking -nratio-, -sratio-, 	*/
		/*    or grweights					*/
		local nlevels1 = `nlevels'-`sum1'-`nm1'
		if (`sum1') local extra " or `nlevels1'"
		local nlev = `nlevels'
		if (`nm1') local nlev = `nlevels1'
		else local nlev = `nlevels'
			
		if `c'!=`nlev' & `c'!=`nlevels1' {
			/* matname could be a tempname, do not use	*/
			di as err "{p}invalid `option': matrix must " _c

			if `r' == 1 {
				di as err "be of length `nlev'`extra'; " _c
			}
			else di as err "have `nlevels'`extra' columns; " _c

			di as err "there are `nlevels' `levels'{p_end}"
			exit 503
		}
	}
	else if `c' < `minlev' {
		di as err "{p}invalid `option'; must have at least " ///
		 "`minlev' `levels', but `c' were found{p_end}"
		exit 503
	}
	else local nlevels = `c'

	tempname pi
	forvalues i=1/`r' {
		local r0 = 0
		forvalues j=1/`c' {
			scalar `pi' = `m0'[`i',`j']
			if missing(`pi') {
				/* variable length numlists		*/
				continue
			}
			local `++r0'
		}
		if !`r0' {
			di as err "{p}invalid `option'; row `i' contains " ///
			 "all missing values{p_end}"
			exit 504
		}
	}
	forvalues j=1/`c' {
		local r0 = 0
		local nlist
		forvalues i=1/`r' {
			scalar `pi' = `m0'[`i',`j']
			if missing(`pi') {
				/* variable length numlists		*/
				continue
			}
			local `++r0'
			local nlist `"`nlist' `=`pi''"'
		}
		if !`r0' {
			local ls = length("`levels'")
			local lev `levels'
			if (bsubstr("`lev'", `ls',1)=="s") {
				local lev = bsubstr("`lev'",1,`--ls')
			}
			di as err "{p}invalid `option'; `lev' (column) " ///
			 "`j' contains all missing values{p_end}"
			exit 504
		} 
		if "`range'"!="" | "`integer'"!="" {
			cap numlist "`nlist'", `range' `integer'
			local rc = c(rc)
			if `rc' { 
				if ("`integer'"!="") local extra " integers"
				if ("`range'"!="") local extra1 " in `range'"
				di as err "{p}invalid `option'; elements " ///
				 "not`extra'`extra1'{p_end}"
				exit `rc'
			}
			local nlist `r(numlist)'
		}
		else local nlist : list retokenize nlist

		sreturn local numlist`j' `"`nlist'"'
	}
	sreturn local nlevels = `nlevels'
end
exit
