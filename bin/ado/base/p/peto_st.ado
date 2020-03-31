*! version 7.1.14  21feb2015
program define peto_st, rclass 
	version 6, missing

	local vv : display "version " string(_caller()) ", missing:"

	syntax varlist(min=1 max=2) [if] [in] [fw iw] [, /*
		*/ BY(varlist) CHECK Detail ID(varname) MAT(string) DINOTE /*
		*/T0(varname) noTItle STrata(varlist) TVid(varname) trend ]
	tokenize `varlist'

	if `"`by'"'==`""' { 
		di in red `"by() required"'
		exit 198 
	}

	if `"`tvid'"' != `""' {
		local id `"`tvid'"'
		local tvid
	}


	if `"`strata'"' != `""' {
		if `"`detail'"' != `""' {
			if `"`check'"' != `""' {
				tempname v V vi Vi
				local matopt `"mat(`vi' `Vi')"'
			}
			tempvar touse  sv j
			mark `touse' `if' `in' [`weight'`exp']
			markout `touse' `varlist' `t0'
			markout `touse' `by' `strata', strok
			sort `touse' `strata'
			qui {
				by `touse' `strata': /* 
				*/ gen `sv'=cond(_n==1 & `touse',1,0)
				replace `sv' = sum(`sv')
				qui gen `c(obs_t)' `j' = _n
				compress `j' `sv'
			}
			if `"`t0'"' != `""' {
				local t0opt `"t0(`t0')"'
			}
			if `"`id'"' != `""' {
				local idopt `"id(`id')"'
			}
			local nsv = `sv'[_N]
			Title `"`title'"' `"`strata'"'
			local i 1 
			while `i' <= `nsv' {
				qui sum `j' if `sv'==`i'
				local x = `strata'[r(min)]
				di _n in gr `"-> `strata' = `x'"'
				peto_st `varlist' [`weight'`exp'] /* 
				*/ if `touse' & `sv'==`i', dinote /* 
				*/ by(`by') `t0opt' `idopt' `matopt' notitle
				if `"`check'"' != `""' {
					if `i'==1 {
						mat `v' = `vi'
						mat `V' = `Vi'
					}
					else {
						mat `v' = `v' + `vi'
						mat `V' = `V' + `Vi'
					}
				}
				local i = `i' + 1
			}
			di 
			di in gr `"-> Total"'
			peto_st `varlist' [`weight'`exp'] if `touse' /*
			*/ , by(`by') `t0opt' `idopt' strata(`strata') /*
			*/ `trend' notitle
			if `"`check'"' != `""' {
				mat `V' = syminv(`V')
				mat `V' = `v'*`V'
				mat `V' = `V'*`v' '
				di `"CHECK:  "' `V'[1,1]

				global S_7 = `V'[1,1]	/* double save */
				ret add
				ret scalar chi2_chk = `V'[1,1]
			}
			exit
		}
	}

	local t1 `"`1'"'
	if `"`2'"'==`""' {
		tempvar dead
		qui gen byte `dead' = 1
	}
	else	local dead `"`2'"'

	tempvar touse
	mark `touse' `if' `in' [`weight'`exp']
	markout `touse' `t1' `dead'
	markout `touse' `by' `strata', strok

	if `"`t0'"'!=`""' & `"`id'"'!=`""' {
		local id
	}
	if `"`t0'"'==`""' & `"`id'"'==`""' {
		tempvar t0
		qui gen byte `t0' = 0
	}
	else if `"`t0'"' != `""' { 
		markout `touse' `t0'
	}
	else if `"`id'"'!=`""' {
		markout `touse' `id'
		quietly {
			sort `touse' `id' `t1'
			local ty : type `t1'
			by `touse' `id': gen `ty' `t0' = /*
				*/ cond(_n==1,0,`t1'[_n-1])
		}
		capture assert `t1'>`t0'
		if _rc {
			di in red `"repeated records at same `t1' within `id'"'
			exit 498
		}
	}

	capture assert `t1'>0 if `touse'
	if _rc { 
		di in red `"survival time `t1' <= 0"'
		exit 498
	}
	capture assert `t0'>=0 if `touse'
	if _rc { 
		di in red `"entry time `t0' < 0"'
		exit 498
	}
	capture assert `t1'>`t0' if `touse'
	if _rc {
		di in red `"entry time `t0' >= survival time `t1'"'
		exit 498
	}
	capture assert `dead'==0 if `touse'
	if _rc==0 {
		if `"`dinote'"' == "" { 
			di in red /*
			 */ `"no test possible because there are no failures"'
			exit 2000
		}
		else {
			di in green /*
			 */ `"no test possible because there are no failures"'
			exit
		}
	}
	if `"`strata'"' != "" {
		tempvar isdead
		sort `strata'
		qui by `strata': gen long `isdead' = sum(`dead')
		qui by `strata': replace `isdead' = . if _n<_N
		qui count if `isdead' == 0 & `touse'
		local n_omit = r(N)
		if `n_omit' > 0 {
			if `n_omit' == 1 {
				local endng um
			}
			else {
				local endng a
			}
			local note /*
*/ Note: `n_omit' strat`endng' omitted because of no failures
		}
	}

	preserve 

	if `"`weight'"' != `""' { 
		tempvar w 
		quietly gen double `w' `exp' if `touse'
		local wv `"`w'"'
	}
	else	local w 1

	tempfile lister
	tempvar op g n d
	quietly { 
		keep if `touse'
		tempvar S F
		`vv' sts gen `S'=ns, by(`strata')
		gen `F' = 1 - `S'
		sort `strata' `F' _t

		keep `wv' `t0' `t1' `by' `strata' `dead' `S'
		sort `by'
		by `by': gen `c(obs_t)' `g' = 1 if _n==1
		replace `g' = sum(`g') 
		local ng = `g'[_N]
		save `"`lister'"'

		local N = _N
		expand 2 
		gen byte `op' = 3/*add*/ in 1/`N'
		replace `t1' = `t0' in 1/`N'
		drop `t0'
		local N = `N' + 1
		replace `op' = cond(`dead'==0,2/*cens*/,1/*death*/) in `N'/l

		if `"`strata'"'!=`""' {
			local bystr `"by `strata':"'
		}
		sort `strata' `t1' `S' `op' `by'

		`bystr' gen double `n' = sum(cond(`op'==3,`w',-`w'))
		by `strata' `t1': gen `d' = sum(`w'*(`op'==1))

		local i 1
		while `i' <= `ng' { 
			tempvar ni di
			`bystr' gen double `ni' = /*
			*/ sum(cond(`g'==`i', cond(`op'==3,`w',-`w'), 0))
			by `strata' `t1': gen double `di' = /* 
			*/ sum(cond(`g'==`i', `w'*(`op'==1), 0))
			local nlist `"`nlist' `ni'"'
			local dlist `"`dlist' `di'"'
			local i = `i' + 1 
		}
		by `strata' `t1': keep if _n==_N
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
			gen double `wi' = sum(`S'*(`di'-(`ni'*`d'/`n')))
			mat `u'[1,`i'] = `wi'[_N]
			replace `wi' = sum((`ni'*`d')/`n')
			mat `w'[1,`i'] = `wi'[_N]
			drop `wi'
			summ `di', meanonly
			mat `w0'[1,`i'] = r(sum)
			local i = `i'+1
		}
		local i 1
		tempname V
		mat `V' = J(`ng',`ng',0)
		local i 1
		while `i' <= `ng' {
			local ni : word `i' of `nlist'
			local j 1
			while `j'<=`ng' {
				local nj : word `j' of `nlist'
				gen double `wi' = /*
				*/ sum((((`S')^2*`ni'*`d'*(`n'-`d')) / /*
				*/ (`n'*(`n'-1)) )*((`i'==`j') - `nj'/`n'))
				mat `V'[`i',`j'] = `wi'[_N]
				mat `V'[`j',`i'] = `wi'[_N]
				drop `wi'
				local j = `j'+1
			}
			local i = `i'+1
		}
	}

	if `"`mat'"' != `""' {
		tokenize `"`mat'"'
		mat `1' = `u'
		mat `2' = `V'
	}
	tempname mV mv
        mat `mV' = `V'
        mat `mv' = `u'
        /* `mV' is the covariate matrix */
        /* `mv' is Z matrix */

	mat `V' = syminv(`V')

	tempname wt
	mat `V' = `u' * `V'
	mat `V' = `V' * `u' '

	quietly { 
		use `"`lister'"', clear 
		by `by': keep if _n==1
		keep `g' `by'
		sort `g'
		tempvar grp X
		gen str50 `grp' = `""' 
		local second 0
		tokenize `by'
		while `"`1'"' != `""' {
			if `second' { 
				local abbrev = abbrev(`"`1'"',8)
				local ttl `"`ttl', `abbrev'"'
				local abbrev
				replace `grp' = `grp' + `", "'
			}
			else {
				if `"`2'"'=="" {
					local ttl = abbrev(`"`1'"',12)
				}
				else	local ttl = abbrev(`"`1'"',8)
				local second 1
			}
			local ty : type `1'
			if bsubstr(`"`ty'"',1,3)==`"str"' { 
				replace `grp' = `grp' + /*
				*/ trim(udsubstr(trim(`1'),1,30))
			}
			else {
				local vlab : value label `1'
				if `"`vlab'"' != `""' { 
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
	if `"`strata'"' != "" & `"`note'"' != "" {
		di in gr `"`note'"'
	}

        di in smcl in gr _n _col(`len') /*
		*/ `" {c |}   Events         Events        Sum of"'
	local pad = `len' - `len1'
	if `"`strata'"'==`""' { 
		local dup `"   expected"' 
		local ranks `"  ranks"'
	}
	else {
		local dup `"expected(*)"'
		local ranks `"ranks(*)"'
	}
	di in smcl in gr `"`ttl'"' _skip(`pad') /*
		*/ `"{c |}  observed    `dup'      `ranks'"'
	di in smcl in gr "{hline `len'}{c +}{hline 38}"

	local sum 0
	local i 1 
	local gstr = bsubstr("`type `grp''", 1, 3)=="str"
	while `i' <= _N { 
		if (`gstr') {
			local x : di udsubstr(`grp'[`i'], 1, 255)
		}
		else {
			local x = `grp'[`i']
		}
		local pad = `len' - udstrlen(`"`x'"')
		di in smcl in gr `"`x'"' _skip(`pad') `"{c |}"' in ye /* 
			*/ %10.0g `w0'[1,`i'] `"     "' %10.2f `w'[1,`i'] /*
			*/ `"   "' %10.0g `u'[1,`i']
		local sum = `sum' + `w0'[1,`i']
		local i = `i' + 1
	}
	di in smcl in gr "{hline `len'}{c +}{hline 38}"
        local pad = `len' - 5
	di in smcl in gr `"Total"' _skip(`pad') `"{c |}"' in ye /* 
			*/ %10.0g `sum' `"     "' %10.2f `sum' /* 
			*/ `"   "' %10.0g 0

	if `"`strata'"' != `""' {
		di in gr _n `"(*) sum over calculations within `strata'"'	
	}

	local pad = `len' + 7

	ret local by `"`by'"'
	ret scalar df = colsof(`u')-1
	ret scalar chi2 = `V'[1,1]

	global S_1 `"`return(by)'"'
	global S_5 = `return(df)'
	global S_6 = `return(chi2)'

	local pad1 = `pad' - (return(df)>=10)
	di _n in gr _col(`pad1') `"chi2(`return(df)') = "' in ye %10.2f `V'[1,1] 
	di in gr _col(`pad') `"Pr>chi2 = "' in ye %10.4f chiprob(return(df), `V'[1,1])
	if "`trend'"~="" {
		if _N<=2 {
			di in red "trend test requires 3 or more groups"
			exit 198
		}
		_sttrend `mV' `mv' `by' `pad1'  `pad'
		ret add
	}


end

program define Title /* <title mark> <strata> */
	args title strata

	if `"`title'"' == `""' {
		if `"`strata'"'==`""' {
			di in smcl _n(2) in gr /*
*/ `"{title:Peto-Peto test for equality of survivor functions}"'
		}
		else	di in smcl _n(2) in gr /*
*/ `"{title:Stratified Peto-Peto test for equality of survivor functions}"'
	}
end
exit
