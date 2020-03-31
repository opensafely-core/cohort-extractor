*! version 1.2.2  18feb2015
program define xtdata
	version 6, missing
	syntax [varlist] [if] [in] [, BE FE RE noDOUBLE * ]

	if ("`be'"!="")+("`fe'"!="")+("`re'"!="")>1 { 
		error 198 
	}

	if "`fe'"!="" {
		ffxdata `varlist' `if' `in', `double' `options'
		local opt "fe"
	}
	else if "`be'"!="" {
		bfxdata `varlist' `if' `in', `double' `options'
		local opt "be"
	}
	else {
		rfxdata `varlist' `if' `in', `double' `options'
		local opt "re"
	}

	if _caller() < 7 {
		local dsn = bsubstr(`"$S_FN"',-15,.)
	}
	else {
		local dsn = usubstr(`"$S_FN"',-15,.)	
	}
	label data `"xtdata, `opt'; `dsn'"'
	global S_FN
	global S_FNDATE
end



program define bfxdata /* [varlist] [if] [in], i(varname) */
	syntax [varlist] [if] [in] [, CLEAR I(string) noDOUBLE]

	_xt, i(`i')
	local ivar "`r(ivar)'"

	if "`clear'"=="" {
		quietly describe
		if r(changed)  { error 4 }
	}

	tokenize `varlist'
	local i 1
	while "``i''"!="" { 
		local typ : type ``i''
		if bsubstr("`typ'",1,3)=="str" | "``i''"=="`ivar'" { 
			local `i' " " 
		}
		local i=`i'+1
	}
	tokenize `*'
	preserve
	tempvar touse new
	quietly { 
		mark `touse' `if' `in'
		markout `touse' `*' `ivar'
		qui count if `touse'==1 
		if r(N)==0 {
			di in red "no observations"
			exit 2000
		}
		keep if `touse'
		keep `*' `ivar'
		if "`double'"=="" {
			recast double `*'
		}
		sort `ivar'
		local i 1 
		while "``i''" != "" {
			by `ivar': replace ``i'' = sum(``i'')/_n
			label values ``i''
			local i=`i'+1
		}
		by `ivar': keep if _n==_N
	}
	restore, not
end


program define ffxdata /* [varlist] [if] [in], i(varname) */
	syntax [varlist] [if] [in] [, CLEAR I(string) noDOUBLE ]

	_xt, i(`i')
	local ivar "`r(ivar)'"

	if "`clear'"=="" {
		quietly describe
		if r(changed)  { error 4 }
	}

	tokenize `varlist'
	local i 1
	while "``i''"!="" { 
		local typ : type ``i''
		if bsubstr("`typ'",1,3)=="str" | "``i''"=="`ivar'" { 
			local `i' " " 
		}
		local i=`i'+1
	}

	tokenize `*'
	preserve
	tempvar touse new mean
	tempname avg
	quietly { 
		mark `touse' `if' `in'
		markout `touse' `*' `ivar'
		qui count if `touse'==1 
		if r(N)==0 {
			di in red "no observations"
			exit 2000
		}
		keep if `touse'
		keep `*' `ivar'
		if "`double'"=="" {
			recast double `*'
		}
		sort `ivar'
		local i 1 
		while "``i''" != "" {
			summ ``i''
			scalar `avg' = r(mean)   
			by `ivar': gen double `mean' = sum(``i'')/_n
			by `ivar': replace ``i'' = ``i''-`mean'[_N] + `avg'
			label values ``i''
			drop `mean'
			local i=`i'+1
		}
	}
	restore, not
end

program define rfxdata /* [varlist] [if] [in], i(varname) ratio(#) */
	syntax [varlist] [if] [in] [, CLEAR I(string) Ratio(real -1) noDOUBLE]

	_xt, i(`i')
	local ivar "`r(ivar)'"

	if `ratio'<0 | `ratio'>=. {
		di in red "ratio() required"
		exit 198
	}

	if "`clear'"=="" {
		quietly describe
		if r(changed)  { error 4 }
	}

	confirm new variable constant

	tokenize `varlist'
	local i 1
	while "``i''"!="" { 
		local typ : type ``i''
		if bsubstr("`typ'",1,3)=="str" | "``i''"=="`ivar'" { 
			local `i' " " 
		}
		local i=`i'+1
	}
	tokenize `*'
	preserve
	tempvar touse new mean theta Ti
	quietly { 
		mark `touse' `if' `in'
		markout `touse' `*' `ivar'
		qui count if `touse'==1 
		if r(N)==0 {
			di in red "no observations"
			exit 2000
		}

		keep if `touse'
		keep `*' `ivar'
		if "`double'"=="" {
			recast double `*'
		}
		sort `ivar'

		by `ivar': gen double `Ti' = _N		/* sic, for speed */
		capture assert `Ti'==`Ti'[1] in 2/l 
		if _rc { 
			by `ivar': gen double `theta' = /* 
				*/ 1 - 1/sqrt( `Ti'*(`ratio'*`ratio')+1) if _n==_N
			sum `theta', detail
			noi di _n in smcl in gr /*
			*/ "{hline 19} theta {hline 20}" 
			noi di in gr /*
			*/ "  min      5%       median        95%      max"
			noi di in ye %6.4f r(min) %9.4f r(p5) /*
			*/ %11.4f r(p50) %11.4f r(p95) /*
			*/ %9.4f r(max) 
			by `ivar': replace `theta' = `theta'[_N]
		}
		else {
			scalar `theta' = 1 - 1/sqrt( `Ti'*(`ratio'*`ratio')+1)
			noi di in gr "(theta=" %5.4f `theta' ")"
		}
		drop `Ti'

		local i 1 
		while "``i''" != "" {
			by `ivar': gen double `mean' = sum(``i'')/_n
			by `ivar': replace ``i'' = ``i''-`theta'*`mean'[_N]
			drop `mean'
			label values ``i''
			local i=`i'+1
		}
		gen float constant = (1-`theta')
	}
	restore, not
end
