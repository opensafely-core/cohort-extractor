*! version 1.1.1  04feb2016
* extract mlogit estimates with specific varnames

program _getmlogitcoef, rclass
	version 10.0

	syntax [varlist(fv default=none)] [, eqs(string) noCONStant ]

	if ("`e(cmd)'" != "mlogit") exit 322
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else local vv : di "version " string(_caller()) ":"
		fvexpand `varlist'
		local varlist "`r(varlist)'"
	}
	tempname b b1
	mat `b' = e(b)
	if `"`e(opt)'"' != "" {
		local neq = e(k_eq)
		tempname b0
		forval i = 1/`neq' {
			if `i' != e(ibaseout) {
				matrix `b0' = nullmat(`b0'), `b'[1,"#`i':"]
			}
		}
		matrix drop `b'
		matrix rename `b0' `b'
	}
	local eq : coleq `b', quoted
	local eq : list uniq eq
	local keq : word count `eq'
	if "`eqs'" != "" {
		if `:word count `eqs'' != `keq' {
			/* programmer error 	*/
			di as err "_getmlogitcoef: equation lists are not " ///
			 "the same length"
			exit 498
		}
	}
	local mvars : colnames `b'
	local mvars : list uniq mvars
	local kvar1 : word count `varlist'
	local kvar : word count `mvars'
	local names `varlist'
	if "`constant'" == "" {
		if `:list posof "_cons" in mvars' {
			local `++kvar1'
			local names `names' "_cons" 
		}
		else local constant noconstant
	}
	mat `b1' = J(1,`keq'*`kvar1',0)

	local eqs1
	forvalues i=1/`keq' {
		local j = (`i'-1)*`kvar1' 
		local l = (`i'-1)*`kvar' 
		if ("`eqs'"!="") local eqi : word `i' of `eqs'

		foreach v of local varlist {
			local k : list posof "`v'" in mvars
			local `++j'
			if `k' > 0 {
				mat `b1'[1,`j'] = `b'[1,`l'+`k']
			}
			if ("`eqi'"!="") local eqs1 `eqs1' `eqi'
		}
		if "`constant'" == "" {
			mat `b1'[1,`++j'] = `b'[1,`l'+`kvar']
			if ("`eqi'"!="") local eqs1 `eqs1' `eqi'
		}
		local names1 `names1' `names'
	}

	`vv' mat colnames `b1' = `names1'
	if ("`eqs1'"!="") mat coleq `b1' = `eqs1'

	return matrix b = `b1'
end

exit
