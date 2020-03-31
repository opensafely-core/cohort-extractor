*! version 3.1.1  01may2018
program define pwcorr, rclass byable(recall)
	version 6, missing
	syntax [varlist(min=2 ts)] [if] [in] [aw fw] [, /* 
		*/ Bonferroni Obs Print(real -1) SIDak SIG /*
		*/ STar(real -1) LISTwise CASEwise]
	tempvar touse
	mark `touse' `if' `in' 		/* but do not markout varlist */

	if "`listwise'" != "" | "`casewise'" != "" {
		markout `touse' `varlist'
	} 

	tokenize `varlist'

	local i 1
	while "``i''" != "" { 
		capture confirm str var ``i''
		if _rc==0 { 
			di in gr "(``i'' ignored because string variable)"
			local `i' " "
		}
		local i = `i' + 1
	}
	local varlist `*'
	tokenize `varlist'
	local nvar : word count `varlist'
	if `nvar' < 2 { error 102 } 
	if `nvar' == 2 {
		gettoken v1 v2 : varlist
		qui count if `touse' & !missing(`v1',`v2')
		if r(N)==0 {
			error 2000
		}
	}
	local weight "[`weight'`exp']"
	local adj 1
	if "`bonferr'"!="" | "`sidak'"!="" {
		if "`bonferr'"!="" & "`sidak'"!="" { error 198 }
		local nrho=(`nvar'*(`nvar'-1))/2
		if "`bonferr'"!="" { local adj `nrho' }
	}
	if (`star'>=1) {
		local star = `star'/100
		if `star'>=1 {
			di in red "star() out of range"
			exit 198
		}
	}
	if (`print'>=1) {
		local print = `print'/100
		if `print'>=1 {
			di in red "print() out of range"
			exit 198
		}

	}
		
	tempname C N
	matrix `C' = J(`nvar',`nvar',.)
	matrix colna `C' = `varlist'
	matrix rowna `C' = `varlist'
	matrix `N' = J(`nvar',`nvar',0)

	if "`sig'" != "" {
		tempname sig
		matrix `sig' = J(`nvar',`nvar',0)
		matrix colna `sig' = `varlist'
        	matrix rowna `sig' = `varlist'
	}

	local rc1400 0
	local j0 1
	while (`j0'<=`nvar') {
		di
		local j1=min(`j0'+6,`nvar')
		local j `j0'
		di in smcl in gr _skip(13) "{c |}" _c
		while (`j'<=`j1') {
			di in gr %9s abbrev("``j''",8) _c
			local j=`j'+1
		}
		local l=9*(`j1'-`j0'+1)
		di in smcl in gr _n "{hline 13}{c +}{hline `l'}"

		local i `j0'
		while `i'<=`nvar' {
			di in smcl in gr %12s abbrev("``i''",12) " {c |} " _c
			local j `j0'
			while (`j'<=min(`j1',`i')) {
				cap corr ``i'' ``j'' if `touse' `weight'
				if _rc == 1400 {
					local rc1400 1
				}
				if _rc == 2000 {
                                        local c`j' = .
                                }
                                else {
                                        local c`j'=r(rho)
					matrix `C'[`i',`j'] = r(rho)
					matrix `N'[`i',`j'] = r(N)
					if (`i'!=`j') {
						matrix `C'[`j',`i'] = r(rho)
						matrix `N'[`j',`i'] = r(N)
					}
                                }
                                local n`j'=r(N)
                                if (r(rho) != . & r(rho) < 1) {
                                        local p`j'=/*
                                        */min(2*`adj'*ttail(r(N)-2,/*
                                        */ abs(r(rho))*sqrt(r(N)-2)/ /*
                                        */ sqrt(1-r(rho)^2)),1)
                                }
                                else if (r(rho)>=1 & r(rho) != .) {
                                        local p`j'=0
                                }
                                else if r(rho) == . {
                                        local p`j'= .
                                }
				if "`sidak'"!="" {
					local p`j'=min(1,1-(1-`p`j'')^`nrho')
				}
				local j=`j'+1
			}
			local j `j0'
			while (`j'<=min(`j1',`i')) {
				if `p`j''<=`star' & `i'!=`j' { 
					local ast "*" 
				}
				else local ast " "
				if `p`j''<=`print' | `print'==-1 |`i'==`j' {
					di " " %7.4f `c`j'' "`ast'" _c
				}
				else 	di _skip(9) _c
				local j=`j'+1
			}
			di
			if "`sig'"!="" {
				forvalues k = 1/`i' {
                                        matrix `sig'[`k',`k'] = 0
                                }
				di in smcl in gr _skip(13) "{c |}" _c
				local j `j0'
				while (`j'<=min(`j1',`i'-1)) {
					if `p`j''<=`print' | `print'==-1 {
						di "  " %7.4f `p`j'' _c
						matrix `sig'[`i',`j'] = `p`j''
						matrix `sig'[`j',`i'] = `p`j''
					}
					else	di _skip(9) _c
					local j=`j'+1
				}
				di
			}
			if "`obs'"!="" {
				di in smcl in gr _skip(13) "{c |}" _c
				local j `j0'
				while (`j'<=min(`j1',`i')) {
					if `p`j''<=`print' | `print'==-1 /*
					*/ |`i'==`j' {
						di "  " %7.0g `n`j'' _c
					}
					else	di _skip(9) _c
					local j=`j'+1
				}
				di
			}
			if "`obs'"!="" | "`sig'"!="" {
				di in smcl in gr _skip(13) "{c |}" 
			}
			local i=`i'+1
		}
		local j0=`j0'+7
	}

	return scalar rho = `C'[1,2]
	return scalar N = `N'[1,2]
	if "`sig'"!="" {
		return matrix sig `sig'
	}
	return matrix C `C'
	return hidden matrix Nobs `N'

	if `rc1400' {
		error 1400
	}
end
