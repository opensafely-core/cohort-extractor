*! version 2.0.4  04feb2019
program asclogit_estat
	version 14

	if "`e(cmd)'" != "asclogit" {

di as err "{p}{helpb asclogit##|_new:asclogit} estimation results not found{p_end}"

		exit 301
	}

	gettoken sub rest: 0, parse(" ,")

	local lsub = length("`sub'")
	if "`sub'" == bsubstr("alternatives",1,max(3,`lsub')) {
		if "`rest'" != "" {
			di as error "invalid syntax"
			exit 198
		}
		Alternatives
	}
	else if "`sub'" == "mfx" {
		Mfx `rest'
	}
	else estat_default `0'
end

program Alternatives

	di _n as text `"{col 4}Alternatives summary for `e(altvar)'"'
	tempname table
	.`table'  = ._tab.new, col(6)
	.`table'.width |10 11 18|11 11 11|
	.`table'.sep, top
	.`table'.strcolor . . yellow . . .
	.`table'.numcolor yellow yellow . yellow yellow yellow
	.`table'.numfmt %7.0g %9.0g . %10.0g %10.0g %10.2f
	.`table'.strfmt . %39s . %6s . .
	.`table'.titles "" "Alternative" "" "Cases " "Frequency" "Percent"
	.`table'.titles "index  " "value" "label" "present" "selected" ///
		"selected"
	.`table'.sep, mid
	
	local nalt = rowsof(e(stats))
	forvalues i=1/`nalt' {
		local label = abbrev("`e(alt`i')'",17)
		.`table'.row `i' el(e(stats),`i',1) "`label'"  ///
		 	el(e(stats),`i',2) el(e(stats),`i',3)  ///
			100*el(e(stats),`i',4)
	}
	.`table'.sep,bot
end
	
program Mfx, rclass 
	syntax [if] [in], [ Level(passthru) noDISCrete VARlist(varlist) ///
		AT(passthru) k(integer 1) noWght noOFFset noEsample force ]
	/* option -nodiscrete- is obsolete for version 14+		*/

	preserve
	tempvar touse

	marksample touse
	if "`esample'" == "" {
		qui count if e(sample)
		if (r(N) > 0) qui replace `touse' = (`touse' & e(sample))
	}

	tempname model b V

	.`model' = ._asclogitmodel.new
	.`model'.eretget, touse(`touse') markout(altwise) ///
		avopts(`force')

	qui keep if `touse'
	if (_N == 0) error 2000

	mat `b' = e(b)
	mat `V' = e(V)

	.`model'.mfx `varlist', b(`b') v(`V') `at' kc(`k') `level' ///
		`discrete' `wght' `offset' `esample' 

	local k_alt = `r(k_alt)'
	local fmt `"`r(fmt)'"'
	local discrete = `r(discrete)'
	local level = round(`r(level)',.01)
	local level = bsubstr("`level'",1,min(strlen("`level'"),5))
	local ll = strlen("`level'")

	if "`offset'"=="" & "`e(offset)'"!="" {
		tempname toff
		mat `toff' = r(offset)
	}
	local disptab = 0
	local altobj `model'.altern
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
			/* return macro name cannot exceed 32 char	*/
			local altn = 0
		}
	}
	local dbase = 0
	forvalues i=1/`k_alt' {
		di in gr _n `"Pr(choice = `alt`i''|`k' selected) ="'   ///
		 _col(10) in ye %10.0g `pr`i'' 
		di in gr "{hline 13}{c TT}{hline 65}"
		di in gr "variable     {c |}" _col(18) "dp/dx" ///
		 _col(26) `"Std. Err."' _col(39) `"z"' _col(45)        ///
		 `"P>|z|"' _col(52) _c
		if `ll' == 2 {
			 di `"[    `=strsubdp("`level'")'% C.I.    ]"' ///
				_col(77) _c
		}
		else {
			 di `"[   `=strsubdp("`level'")'% C.I.  ]"' _col(77) _c
		}
		di in gr `"X"' _n "{hline 13}{c +}{hline 65}" 

		matlist `table`i'', cspec(`fmt') rspec(`rspec`i'')     ///
			border(bottom) noblank nodotz names(rows) linesize(79) 
		di in gr "{hline 13}{c BT}{hline 65}"
		if `discrete' {
			if `.`model'.version' < 14 {
				di "(*) dp/dx is for discrete change of " ///
				 "indicator variable from 0 to 1"
			}
			else {
				di "dp/dx for factor levels is the " ///
				 "discrete change from the base level"
				local dbase = 1
			}
		}
		if `altn' {
			local salt `ealt`i''
		}
		else {
			local salt = el(e(altvals),1,`i')
		}
		local ename = strtoname("`salt'")
		return matrix `ename' = `table`i''

		return scalar pr_`salt' = `pr`i''
	}
	if "`toff'" != "" {
		matlist `toff', rowtitle(offset) border(top bottom)
		return matrix offset = `toff'
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
