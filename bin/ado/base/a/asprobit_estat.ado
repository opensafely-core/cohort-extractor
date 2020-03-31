*! version 4.0.9  23jul2019
program asprobit_estat
	version 13

	// Note: -cmmprobit_estat- and -cmroprobit_estat- already checked e(cmd).

	if (   "`e(cmd)'" != "asmprobit"      ///
	     & "`e(cmd)'" != "asroprobit"     ///
	     & "`e(cmd)'" != "cmmprobit"      ///
	     & "`e(cmd)'" != "cmroprobit" ) { 
				
di as err "{p}{helpb asmprobit##|_new:asmprobit} or " ///
	  "{helpb asroprobit##|_new:asroprobit} "     ///
	  "estimation results not found{p_end}"
		
		exit 301
	}

	gettoken sub rest: 0, parse(" ,")

	local lsub = length("`sub'")
	if "`sub'" == bsubstr("covariance",1,max(3,`lsub')) | ///
	   "`sub'" == bsubstr("correlation",1,max(3,`lsub')) | ///
	   "`sub'" == bsubstr("facweights",1,max(4,`lsub')) {
		local which = bsubstr("`sub'",1,3)
		Covariance `which' `rest'
	}
	else if "`sub'" == bsubstr("alternatives",1,max(3,`lsub')) {
		if "`rest'" != "" {
			di as error "invalid syntax"
			exit 198
		}
		Alternatives
	}
	else if "`sub'" == "mfx" {
		Mfx `rest'
		/* clear return code					*/
		capture
	}
	else estat_default `0'
end

program Covariance, rclass
	syntax namelist(name=which id="matrix type" max=1), ///
		[FORmat(string) BORder(string) left(numlist max=1 >=0)]

	qui findfile _probitmodel_macros.ado
	qui include `"`r(fn)'"'

	tempname L V cov b
	
	if (e(i_base)<.) local bopt base(`e(i_base)')

	if "`e(cov_class)'" == "" {
		.`cov' = ._altcovmatrix.new
	}
	else {
		.`cov' = .`e(cov_class)'.new
	}
	if missing(e(mversion)) {
		local ver = cond("`e(opt)'"=="ml",1,2)
	}
	else {
		local ver = e(mversion)
	}
	if `ver' >= `PROBIT_VERSION_CM_BASE' {
		.`cov'.set_freeparm, on
	}
	else {
		.`cov'.set_freeparm, off	// default
	}
	.`cov'.eretget, `bopt'
	
	mat `b' = e(b)
	local base = 0
	if e(cholesky) {
		.`cov'.evaluate, b(`b') cholesky

		mat `V' = `.`cov'.matname'
		mat `V' = `V'*`V''
		local k = 2
	}
	else {
		.`cov'.evaluate, b(`b') 
	
		mat `V' = `.`cov'.matname'
		local k = 1
		if (!`.`cov'.structural') {
			/* factored covariance does not pivot base	*/
			if (e(i_base)<.) local base = e(i_base)
			else local k = 2
		}
	}

	local order `.`cov'.order.matname'
	
	forvalues i=`k'/`.`cov'.kalt' {
		local k = `order'[`i',1]
		if `k' == `base' {
			continue
		}
		local eq : word `k' of `e(alteqs)'
		local names `names' `eq'
	}
	matrix rownames `V' = `names'
	matrix colnames `V' = `names'
	if "`which'" == "cov" {
		local what Covariances
		matrix `V' = (`V'+`V'')*.5
		matrix `L' = `V'
		return matrix cov = `V'
		if ("`format'" == "") local format %9.0g
	}
	else if "`which'" == "cor" {
		local what Correlations
		tempname D
		matrix `D' = syminv(cholesky(diag(vecdiag(`V'))))
		matrix `L' = `D'*`V'*`D'

		matrix `L' = (`L' + `L'')*.5
		matrix `V' = `L'

		return matrix cor = `V'

		if ("`format'" == "") local format %9.4f
	}
	else {
		cap mat li r(C)
		if _rc {
			di as err "{p}{bf:estat facweights} is only " ///
			 "for models that use the "		      ///
			 "{bf:factor(}{it:#}{bf:)} option on estimation{p_end}"
			exit 198
		}
		local what Factor weights
		tempname C
		cap mat `C' = r(C)
		forvalues i=1/`=rowsof(`C')' {
				local dnames `dnames' dim`i'
		}
		mat colnames `C' = `names'
		mat rownames `C' = `dnames'
		local n = colsof(`C')
		local title title(Factor weights, C.  V = I(`n') + C'C)

		mat `L' = `C'
		return matrix C = `C'
	}
	if ("`border'" == "") local border all
	if ("`left'" == "") local left 2
	matlist `L', format(`format') border(`border') left(`left') `title'
	if !`.`cov'.structural' {
		local jj = e(i_base)
		local ab : word `jj' of `e(alteqs)'
		di `"Note: `what' are for alternatives differenced with `ab'."'
	}
end

program Alternatives, rclass

	tempname table
	.`table'  = ._tab.new, col(6)
	.`table'.width |10 11 18|11 11 11|
	.`table'.strcolor . . yellow . . .
	.`table'.numcolor . yellow . yellow yellow yellow
	.`table'.numfmt . %9.0g . %10.0g %10.0g %10.2f
	.`table'.strfmt %6s . . . . .
	di _n as text "{col 4}Alternatives summary for `e(altvar)'"
	.`table'.sep, top
	.`table'.strfmt %6s . . . . .
	if "`e(cmd)'" == "asmprobit" | "`e(cmd)'" == "cmmprobit" {
		.`table'.titles "Covariance" "Alt " "Alt " "Cases " ///
			"Frequency" "Percent"
		.`table'.titles "index  " "value" "label" "present" ///
			"selected" "selected"
		.`table'.numfmt . %9.0g . %10.0g %10.0g %10.2f
		local scale = 100
	}
	else {
		.`table'.titlefmt %10s %11s %18s %11s %~22s .
		.`table'.titles "Covariance" "Alt " "Alt " "Cases " ///
			"      Rank" ""
		.`table'.titlefmt %10s %11s %18s %11s %11s %11s
		.`table'.titlefmt . . . . . .
		.`table'.titles "index  " "value" "label" "present" ///
			"median" "mode"
		.`table'.numfmt . %9.0g . %10.0g %10.0g %10.0g
		local scale = 1
	}
	.`table'.sep, mid

	if ("`e(cmd)'" == "asmprobit" | "`e(cmd)'" == "cmmprobit") {
		local m = 100
	}
	else {
		local m = 1
	}
	
	local nalt = rowsof(e(stats))
	local k = 0
	forvalues i=1/`nalt' {
		if !`e(structcov)' & `i'==`e(i_base)' {
			local index (base)
			.`table'.strcolor green . . . . .
		}
		else {
			local index `++k'
			.`table'.strcolor yellow . . . . .
		}
		local label = abbrev("`e(alt`i')'",17)
		.`table'.row "`index'" el(e(stats),`i',1) "`label'" 	///
		 	el(e(stats),`i',2) el(e(stats),`i',3)  		///
			`m'*el(e(stats),`i',4)
	}
	.`table'.sep,bot
end
	
program Mfx, rclass
	syntax [if] [in], [ Level(passthru) noDISCrete VARlist(string) 	 ///
		AT(passthru) Rank(passthru) noWght noEsample 		 ///
		INTBurn(integer -1) INTPoints(integer 0) INTSeed(string) ///
		ANTIthetics FORCE ]

	/* undocumented options: intburn intpoint intseed antithetics force */

	local ranked = ("`e(cmd)'"=="asroprobit" | "`e(cmd)'"=="cmroprobit") 
	if !`ranked' & "`rank'"!="" {
		di as error "option rank() not allowed"
		exit 198
	}
	if "`varlist'" != "" {
		local vlist `varlist'
		while "`vlist'" != "" {
			gettoken var vlist : vlist, bind
			_ms_parse_parts `var'
			if "`r(type)'" != "variable" {
				di as err "{p}{bf:varlist()} can only " ///
				 "contain variable names{p_end}"
				exit 198
			}
		}
	}
	preserve
	tempvar touse

	marksample touse
	if "`esample'" == "" {
		qui count if e(sample)
		if (r(N) > 0) qui replace `touse' = (`touse' & e(sample))
	}
	tempname model b V
	
	if "`e(cmd)'" == "cmmprobit" {
		local modelname "asmprobit"
	}
	else if "`e(cmd)'" == "cmroprobit" {
		local modelname "asroprobit"
	}
	else {
		local modelname "`e(cmd)'"
	}

	.`model' = ._`modelname'model.new
	.`model'.eretget, touse(`touse') markout(altwise) avopts(`force')

	qui keep if `touse'
	if (_N == 0) error 2000

	mat `b' = e(b)
	mat `V' = e(V)

	.`model'.mfx `varlist', b(`b') v(`V') `at' `k' `level' `discrete' ///
		`wght' `esample' `rank' 

	local k_alt = `r(k_alt)'
	local k_p = `r(k_p)'
	local fmt `"`r(fmt)'"'
	local discrete = `r(discrete)'
	local level = round(`r(level)',.01)
	local level = bsubstr("`level'",1,min(strlen("`level'"),5))
	local ll = strlen("`level'")

	local disptab = 0
	local i = 0
	while `++i'<=`e(k_alt)' & !`disptab' {
		local eqi : word `i' of `e(alteqs)'
		local disptab = (`"`e(alt`i')'"' != "`eqi'")
	}
	if `disptab' {
		di in gr _n "Equation Name" _col(25) "Alternative"
		di in gr "{hline 50}
		forvalues i=1/`e(k_alt)' {
			local eqi : word `i' of `e(alteqs)'
			di in ye `"`=abbrev("`eqi'", 20)'"' _col(25) ///
			 "`e(alt`i')'"
		}
		di
	}
	 
	if `ranked' {
		tempname table1 pr1 ranks
		mat `table1' = r(mfx)
		scalar `pr1' = r(pr)
		local rspec1 "`r(rspec)'"
		mat `ranks' = r(outcome)

		local eqa mfx
		local l = 78
		local np = colsof(`ranks')
		local altern: rownames `ranks'
		forvalues k=1/`np' {
			local rval
			forvalues j=1/`k_alt' {
				local ai : word `j' of `altern'
				local ri = `ranks'[`j',`k']
				local rval `"`rval' `ai'=`ri'"'
			}
			local lk = strlen("`rval'")+7
			if `l'+`lk' > 78 { 
				di
				local l = 0
			}
			local l = `l' + `lk'
			di in gr `"Pr(`:list retok rval') "' _c
			if (`k' == `np') di "=" _c
			else di "+ " _c
		}
		di _col(10) in ye %10.0g `pr1' 
	}
	else {
		local altn = 1
		forvalues i=1/`k_alt' {
			local ealt`i' `r(alt_`i')'
			local j = 0
			while `++j'<=`e(k_alt)' & `"`alt`i''"'=="" {
				local eqj : word `j' of `e(alteqs)'
				if "`eqj'" == "`ealt`i''" {
					local alt`i' `"`e(alt`j')'"'
				}
			}
			tempname table`i' pr`i'

			local ename = ustrtoname("`ealt`i''")
			mat `table`i'' = r(`ename')
			scalar `pr`i'' = r(pr_`i')
			local rspec`i' "`r(rspec_`i')'"

			if strlen("`ealt`i''") > 29 {
				/* ret macro name cannot exceed 32 char	*/
				local altn = 0
			}
		}
	}
	local dbase = 0
	forvalues i=1/`k_p' {
		if !`ranked' {
			di in gr _n `"Pr(choice = `alt`i'') ="' _col(10) ///
			 in ye %10.0g `pr`i'' 
		}
		di in gr "{hline 13}{c TT}{hline 65}"
		di in gr "variable     {c |}" _col(18) "dp/dx" 	///
		 _col(26) `"Std. Err."' _col(39) `"z"' _col(45) ///
		 `"P>|z|"' _col(52) _c
		if `ll' == 2 {
			 di `"[    `=strsubdp("`level'")'% C.I.    ]"' ///
				_col(77) _c
		}
		else {
			 di `"[   `=strsubdp("`level'")'% C.I.  ]"' _col(77) _c
		}
		di in gr `"X"' _n "{hline 13}{c +}{hline 65}" 

		matlist `table`i'', cspec(`fmt') rspec(`rspec`i'') ///
			border(bottom) noblank nodotz names(rows) linesize(79) 
		di in gr "{hline 13}{c BT}{hline 65}"
		if `discrete' {
			if `.`model'.version' < 14 {
				di "(*) dp/dx is for discrete change of " ///
				 "indicator variable from 0 to 1"
			}
			else {
				local dbase = 1
				di "dp/dx for factor levels is the " ///
				 "discrete change from the base level"
			}
		}
		if `ranked' {
			return matrix mfx = `table`i''
			return scalar pr = `pr`i''
			return matrix ranks = `ranks'
		}
		else {
			if `altn' {
				local salt `ealt`i''
			}
			else {
				local salt = el(e(altvals),1,`i')
			}
			local ename = ustrtoname("`salt'")
			return matrix `ename' = `table`i''
			return scalar pr_`salt' = `pr`i''
		}
	}
	if `dbase' {
		restore
		di _n _col(5) "{ul on}variable" ///
			_col(20) "base {ul off}"
		DisplayBaseLevels, model(`model') which(as)
		DisplayBaseLevels, model(`model') which(ba)
	}
end

program define DisplayBaseLevels
	syntax, model(name) which(string)

	if "`which'" == "as" {
		local vars `.`model'.strvarnames,noomit'
		local kvars : list sizeof vars
	}
	else {
		local vars `.`model'.strbavarnames,noomit'
		local kvars : list sizeof vars
	}				

	forvalues j=1/`kvars' {
		local var : word `j' of `vars'
		local isfv = `.`model'.isfactorvar `var', which(`which')'
		if `isfv' {
			local abv = abbrev("`var'",12)
			.`model'._fv_levels `var', which(`which')
			di _col(5) "`abv'" _col(20) r(base)
		}
	}
end

exit
