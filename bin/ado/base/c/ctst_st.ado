*! version 1.0.13  23feb2015  
program define ctst_st /* varlist, strata(varlist) */, rclass
	version 6.0, missing
	st_is 2 analysis
	syntax varlist [if] [in] [, STrata(varlist) noTitle ]

	if `"`strata'"'!="" {
		local stopt `"strata(`strata')"'
	}
	local by `"`varlist'"'

	tempfile lister
	tempvar touse g
	st_smpl `touse' `"`if'"' `"`in'"' `"`varlist'"' `"`strata'"'

	preserve 
	local w : char _dta[st_wv]

	quietly { 
		keep if `touse'
		keep `by' `_dta[st_id]' _t _t0 _d  `w' `strata' _st
		if `"`w'"'=="" {
			local w 1
		}

		sort `by'
		by `by': gen `c(obs_t)' `g'=1 if _n==1
		replace `g'=sum(`g')
		local ng = `g'[_N]
		save `"`lister'"'

		local i 2
		while `i'<= `ng' {
			tempvar gm
			gen byte `gm'=`g'==`i'
			local vlist `"`vlist' `gm'"'
			local i = `i' + 1 
		}
		capture stcox `vlist', `stopt' estimate
		if _rc { 
			if _rc!=2000 & _rc!=2001 { error _rc }
			local dof 0 
			local chi2 0
		}
		else {
			local dof = e(df_m)
			local chi2 = e(chi2)
		}

		tempvar op n d

		local N = _N
		expand 2 
		gen byte `op' = 3/*add*/ in 1/`N'
		replace _t  = _t0 in 1/`N'
		drop _t0
		local N = `N' + 1
		replace `op' = cond(_d==0,2/*cens*/,1/*death*/) in `N'/l

		if `"`strata'"'!="" {
			local bystr `"by `strata':"'
		}

		sort `strata' _t  `op' `by'

		`bystr' gen double `n' = sum(cond(`op'==3,`w',-`w'))
		by `strata' _t: gen `d' = sum(`w'*(`op'==1))

		local i 1
		while `i' <= `ng' { 
			tempvar ni di
			`bystr' gen double `ni' = /*
			*/ sum(cond(`g'==`i', cond(`op'==3,`w',-`w'), 0))
			by `strata' _t: gen double `di' = /* 
			*/ sum(cond(`g'==`i', `w'*(`op'==1), 0))
			local nlist `"`nlist' `ni'"'
			local dlist `"`dlist' `di'"'
			local i = `i' + 1 
		}
		by `strata' _t: keep if _n==_N
		tempvar newn
		`bystr' gen double `newn' = `n'[_n-1]
		drop `n' 
		rename `newn' `n'

		local i 1
		while `i' <= `ng' {
			local ni : word `i' of `nlist'
			`bystr' gen double `newn' = `ni'[_n-1] if _n>1
			drop `ni' 
			rename `newn' `ni'
			local i = `i' + 1
		}
		drop if `d'==0

		tempname u w w0
		mat `u' = J(1,`ng',0)
		mat `w' = J(1,`ng',0)
		mat `w0' = J(1,`ng',0)
		tempvar wi
		local i 1
		while `i' <= `ng' {
			local ni : word `i' of `nlist'
			local di : word `i' of `dlist'
			if `i'!=1 { 
				local bi : word `i' of 1 `vlist'
				mat `u'[1,`i'] = _b[`bi']
			}
			else	mat `u'[1,`i'] = 0
			gen double `wi' = sum((`ni'*`d')/`n')
			mat `w'[1,`i'] = `wi'[_N]
			drop `wi'
			summ `di', meanonly
			mat `w0'[1,`i'] = r(sum)
			local i = `i'+1
		}
		tempname mean ttl
		mat `mean' = `u' * `w' '
		mat `ttl' = J(`ng',1,1)
		mat `ttl' = `w' * `ttl'
		scalar `mean' = `mean'[1,1]/`ttl'[1,1]
		local i 1
		while `i' <= `ng' { 
			mat `u'[1,`i'] = exp(`u'[1,`i'] - `mean')
			local i = `i' + 1
		}
	}

	quietly { 
		use `"`lister'"', clear 
		by `by': keep if _n==1
		keep `g' `by'
		sort `g'
		tempvar grp X
		gen str50 `grp' = "" 
		local second 0
		parse `"`by'"', parse(" ")
		while `"`1'"' != "" {
			if `second' { 
				local abbrev = abbrev(`"`1'"',8)
				local ttl `"`ttl', `abbrev'"'
				local abbrev
				replace `grp' = `grp' + ", "
			}
			else {
				if `"`2'"'=="" {
					local ttl = abbrev(`"`1'"',12)
				}
				else 	local ttl = abbrev(`"`1'"',8)
				local second 1
			}
			local ty : type `1'
			if bsubstr(`"`ty'"',1,3)=="str" { 
				replace `grp' = `grp' + /*
				*/ trim(udsubstr(trim(`1')),1,30)
			}
			else {
				local vlab : value label `1'
				if `"`vlab'"' != "" { 
					decode `1', gen(`X') maxlen(30) 
					replace `grp' = `grp' + trim(`X')
					drop `X'
				}
				else	replace `grp' = `grp'+trim(string(`1'))
			}
			mac shift
		}
		compress `grp'
	}
	local len1 = udstrlen(`"`ttl'"')
	local ty : type `grp'
	local len2 = bsubstr(`"`ty'"',4,.)
	if ("`len2'"=="L") {
		local len2 = 20 
	}
	local len = max(`len1', `len2', 5) + 1

	Title `"`title'"' `"`strata'"'

        di in smcl in gr _n _col(`len') /*
		*/ " {c |}   Events         Events       Relative"
	local pad = `len' - `len1'
	if `"`strata'"'=="" { 
		local dup "   expected" 
		local ranks " hazard"
	}
	else {
		local dup "expected(*)"
		local ranks "hazard(*)"
	}
	di in smcl in gr `"`ttl'"' /*
		*/ _skip(`pad') `"{c |}  observed    `dup'      `ranks'"'
	di in smcl in gr "{hline `len'}{c +}{hline 38}"

	local wt : char _dta[st_wt]
	if `"`wt'"'=="pweight" {
		local fmt "%10.2f"
	}
	else	local fmt "%10.0g"

	local sum 0
	local i 1 
	local gstr = bsubstr("`:type `grp''", 1, 3) == "str"
	while `i' <= _N { 
		if (`gstr') {
			local x : di udsubstr(`grp'[`i'], 1, 255)
		}
		else {
			local x = `grp'[`i']
		}
		local pad = `len' - udstrlen(`"`x'"')
		di in smcl in gr `"`x'"' _skip(`pad') "{c |}" in ye /* 
			*/ `fmt' `w0'[1,`i'] "     " %10.2f `w'[1,`i'] /*
			*/ "   " %10.4f `u'[1,`i']
		local sum = `sum' + `w0'[1,`i']
		local i = `i' + 1
	}
	di in smcl in gr "{hline `len'}{c +}{hline 38}"
        local pad = `len' - 5
	di in smcl in gr "Total" _skip(`pad') "{c |}" in ye /* 
			*/ `fmt' `sum' "     " %10.2f `sum' /* 
			*/ "   " %10.4f 1

	if `"`strata'"' != "" {
		di in gr _n `"(*) sum over calculations within `strata'"'
	}

	local pad = `len' + 7
	/* double save in r() and S_# */
	ret scalar df = `dof'
	ret scalar chi2 = `chi2'
	ret local by `"`by'"'
	global S_1 `"`by'"'
	global S_5 `dof'
	global S_6 `chi2'
	local pad1 = max(`pad' - (return(df)>=10) - 5, 1)
	if `"`e(vcetype)'"'=="Robust" {
		local chttl "Wald chi2"
	}
	else	local chttl "  LR chi2"

	di _n in gr _col(`pad1') `"`chttl'(`return(df)') = "' /*
		*/ in ye %10.2f `chi2'
	di in gr _col(`pad') "Pr>chi2 = " in ye %10.4f chiprob(`dof',`chi2')
end

program define Title /* <title mark> <strata> */
	local title `"`1'"'
	local strata `"`2'"'

	if `"`title'"' == "" {
		if `"`strata'"'=="" {
			di in smcl _n(2) in gr /*
*/ "{title:Cox regression-based test for equality of survival curves}" 
		}
		else	di in smcl _n(2) in gr /*
*/ "{title:Stratified Cox regression-based test for equality of survival curves}"
	}
end
exit

