*! version 1.0.1  06jul2007
* _exactreg_tests - exact logistic/poisson regression programmers tool

program _exactreg_tests, rclass
	version 10

	syntax varlist, f(varname) yx(name) eps(name) [ terms(string) ///
		midp constant(varname) trace ]

	tempname sbt cp sc pp ps
	tempvar bt iv iv1 d m v s

	preserve
	if "`terms'" != "" {
		if ("`constant'" != "") local constopt constant(`constant')
                _parse_terms `varlist', termvars(`terms') `constopt'

                local ng = `s(ng)'
                local nind `s(nind)'
                local ind `s(ind)'
                local terms `s(terms)'
                local stripe `s(stripe)'
        }
        else {
                local ng: word count `varlist'
                forvalues i=1/`ng' {
                        local nind `nind' 1
                        local ind `ind' `i'
                }
                local stripe `varlist'
                local terms `varlist'
		if "`constant'" != ""  {
			local stripe : list stripe - constant
			local stripe `stripe' _cons
		}
        }
	mat `sc' = J(1,`ng',.z)
	mat colnames `sc' = `terms'
	mat `cp' = J(1,`ng',.z)
	mat colnames `cp' = `terms'
	mat `pp' = J(1,`ng',.z)
	mat colnames `pp' = `terms'
	mat `ps' = J(1,`ng',.z)
	mat colnames `ps' = `terms'
        local ig = 0
        local i = 1
	tempvar keep
        foreach ng of numlist `nind' {
                tokenize `ind'
                local indj

                if `++ig' > 1 {
                        restore, preserve
                }
                local termi : word `ig' of `terms'
                
		local X
                forvalues j=`i'/`=`i'+`ng'-1' {
                        local k : word `j' of `ind'
			local indj `indj' `k'
			local x : word `k' of `varlist'
			local X `X' `x'
                }
		local i = `i' + `ng'
		if ("`trace'"!="") ///
			di _n "computing conditional `tests' tests for (`X')"

		local Z : list varlist - X
		local kkeep = 0
		foreach z of local Z {
			local k : list posof "`z'" in varlist
                        if `++kkeep' == 1 {
				qui gen byte `keep' =           ///
					(abs(`z'-`yx'[1,`k'])<= ///
					abs(`yx'[1,`k'])*`eps')
			}
			else {
                        	qui replace `keep' = `keep'*(abs(`z'- ///
				 `yx'[1,`k'])<=abs(`yx'[1,`k'])*`eps')
			}
		}
                if `kkeep' {
			qui keep if `keep'
			qui drop `keep'
		}

		if _N == 1 {
			/* only one record in distribution (X | C) */
			cap drop `bt'
			cap drop `iv'
			cap drop `iv1'
			continue
		}
		summarize `f', meanonly
		scalar `sbt' = r(sum)
		qui gen double `bt' = `f'/`sbt'

                qui gen byte `iv' = 1
		local j = 0
		matrix `m' = J(1,`ng',.)
                foreach x of local X {
			local k : word `++j' of `indj'
                        qui replace `iv' = `iv'*(abs(`x'-`yx'[1,`k'])<= ///
				abs(`yx'[1,`k'])*`eps')

			summarize `x' [iw=`bt'], meanonly
			matrix `m'[1,`j'] = r(sum)
                }

		/* scores test	*/
		if ("`trace'" != "") MD `m' "m"
		qui mat accum `v' = `X' [iw=`bt'], noconstant
		qui mat `v' = `v' - `m''*`m'
		if ("`trace'" != "" ) MD `v' "v"
		qui gen double `d' = .
		mata: _exlogistic_score(`"`X'"', "`v'", "`m'", "`d'")
		Signif `d' `eps' `s' 

		qui gsort + `s' - `iv'
		qui gen byte `iv1' = sum(`iv')
		qui count if `iv1'
		local j = _N - r(N) + 1

		if "`trace'" != "" {
			local n1 = max(`j'-10,1)
			local n2 = min(`j'+10,_N)
			format `d' `bt' `s' %20.15g
			list `iv' `iv1' `d' `s' `bt' `varlist' in `n1'/`n2'
		}
		mat `sc'[1,`ig'] = `d'[`j']
		summarize `bt' if `iv1', meanonly
		mat `ps'[1,`ig'] = r(sum)
		if "`midp'" != "" {
			qui replace `iv1' = (abs(`s'[`j']-`s') <= ///
			 abs(`s'[`j'])*`eps')
			summarize `bt' if `iv1', meanonly
			mat `ps'[1,`ig'] = `ps'[1,`ig'] - r(sum)/2
		}

		if ("`trace'"!="") ///
			di %20.15g "score " `sc'[1,`ig'] "  prob " `ps'[1,`ig']

		cap drop `d'

		/* probabilities test	*/
		Signif `bt' `eps' `s'
		qui sort `s' `iv'
		qui replace `iv1' = sum(`iv')
		qui replace `iv1' = 1-`iv1'+`iv'
		qui count if `iv1'
		local j = r(N)
		if "`trace'" != "" {
			local n1 = max(`j'-10,1)
			local n2 = min(`j'+10,_N)
			format `s' %20.15g
			list `iv' `iv1' `bt' `s' `varlist' `f' in `n1'/`n2'
		}
		mat `cp'[1,`ig'] = `bt'[`j'] 
		summarize `bt' if `iv1', meanonly
		mat `pp'[1,`ig'] = r(sum)
		if ("`midp'"!="") mat `pp'[1,`ig'] = `pp'[1,`ig'] - `bt'[`j']/2

		if ("`trace'"!="") ///
			di %20.15g "prob " `cp'[1,`ig'] "  prob " `pp'[1,`ig']

		cap drop `bt'
		cap drop `iv'
		cap drop `iv1'
	}
	return mat scores = `sc'
	return mat pscores = `ps'
	return mat prob = `cp'
	return mat pprob = `pp'
	return local stripe `"`stripe'"'
	return local terms `"`terms'"'
end

program Signif
	args x eps s

	tempname digits 
	tempvar di touse

	scalar `digits' = round(log10(abs(`eps')),1)
	gen byte `touse' = (`x'>2^-1022)
	qui count if `touse'
	local N = r(N)
	if "`s'" != "`x'" {
		cap drop `s'
		qui gen double `s' = ///
			round(`x',10^(`digits'+ceil(log10(abs(`x'))))) ///
			if `touse'
		if (`N' < _N) qui replace `s' = 0 if `touse'==0
	}
	else { 
		/* confirm double variable `x'  */
		qui replace `x' = ///
			round(`x',10^(`digits'+ceil(log10(abs(`x'))))) ///
			if `touse'
		if (`N' < _N) qui replace `x' = 0 if `touse'==0
	}
end

program MD
	args mat title

	di _n "`title'" _c
	mat list `mat', noheader
end

exit
