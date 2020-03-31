*! version 3.2.0  08may2014
program define kappa, rclass
	version 6, missing
	syntax varlist(min=2) [if] [in]
	tempvar touse
	mark `touse' `if' `in'		/* sic, varlist not marked out */
	tokenize `varlist'
	if "`3'"=="" { 
		_crckpa2 `varlist' if `touse'
	}
	else	_crckpak `varlist' if `touse' 
	ret add  /* add the return values from either _crckpa2 or _crckpak */
end

program define _crckpak, rclass
	syntax varlist(min=2) [if] 
	tokenize `varlist'
	tempvar total false
	quietly {
		gen double `total'=0
		while "`1'"!="" { 
			capture assert `1'>=0 & `1'< . & `1'==int(`1') `if'
			if _rc { 
				noisily di in red /*
			*/ "noninteger, negative, or missing values encountered"
				exit 498
			}
			replace `total' = `total' + `1' `if'
			mac shift 
		}
		sum `total' `if' 
		local nrat = r(N)*r(mean)
		if r(min)==r(max) { 
			local m = r(mean)
			quietly count `if'
			local n = r(N)
			local sej = sqrt(2/(`n'*`m'*(`m'-1)))
		}
		else {
			local m . 
			local n . 
			local sej . 
		}
		tokenize `varlist'
		local nu 0 
		local de 0 
		local x3 0 
		gen double `false' = . 
	}
 	di in smcl in gr _n /*
 		*/ "         Outcome {c |}    Kappa          Z     Prob>Z" _n /*
		*/ "{hline 17}{c +}{hline 31}"
	while "`1'"!="" {
		qui replace `false' = `total'-`1' `if'
		qui sum `1' `if'
		local p = (r(N)*r(mean))/`nrat'
		qui _crckpa2 `1' `false' `if'
		ret scalar kappa = r(kappa)
		ret scalar z = r(z)
		local nu = `nu'+`p'*(1-`p')*return(kappa)
		local de = `de'+`p'*(1-`p')
		local x3 = `x3'+`p'*(1-`p')*(1-2*`p')
		local lbl : variable label `1'
		if length("`lbl'")>16 | "`lbl'"=="" { 
			local lbl = abbrev("`1'", 12)
		}
		local skip=16-length("`lbl'")
		if `m'>=. { 
			ret scalar z = .
			global S_5 .      /* double save in S_# and r() */
		}
		di in smcl in gr _skip(`skip') "`lbl' {c |}" in ye %10.4f /*
		*/ return(kappa) /*
		*/ %11.2f return(z) %10.4f 1-normprob(return(z))
		mac shift
	}
	local kappa = `nu'/`de'
	local se = (sqrt(2/(`n'*`m'*(`m'-1)))/`de') * sqrt((`de')^2-`x3')
	ret scalar kappa = `kappa'
	global S_4 `kappa'    /* double save in S_# and r() */
	if `m'>=. { ret scalar z = . }
	else	    ret scalar z = `kappa'/`se'
	global S_5 = `return(z)'  /* double save in S_# and r() */
	di in smcl in gr "{hline 17}{c +}{hline 31}" _n /* 
	*/ "        combined {c |}" in ye %10.4f `kappa' /*
	*/ %11.2f return(z) %10.4f 1-normprob(return(z))
	if `m'>=. { 
		di _n in gr /*
*/ "Note: Number of ratings per subject vary; cannot calculate test" _n /*
*/ "      statistics."
end

program define _crckpa2, rclass
	syntax varlist(min=2 max=2) [if]
	tokenize `varlist'
	capture assert `1'< . & `2'< . & `1'==int(`1') & `2'==int(`2') /*
		*/ & `1'>=0 & `2'>=0 `if'
	if _rc { 
		di in red "negative, missing, or noninteger values encountered"
		exit 499
	}
	tempvar m x t
	quietly { 
		gen long `m' = `1' + `2' `if'
		replace `m'=. if `m'==0
		quietly count if `m'< .
		if r(N)<1 { 
			noisily error 2000
		}
		gen long `x' = `1' if `m'< .
		sum `m'
		local n=r(N)
		local mbar = r(mean)
		sum `x'
		local pbar = r(mean)/`mbar'
		gen double `t' = (`x'-`m'*`pbar')^2/`m'
		sum `t'
		local  bms =r(mean)
		replace `t'=(`x'*(`m'-`x'))/`m'
		sum `t'
		local wms = r(mean)/(`mbar'-1)
		local kappa = (`bms'-`wms')/(`bms'+(`mbar'-1)*`wms')
		replace `t'=1/`m'
		sum `t'
		local mbarh = 1/r(mean)
		local qbar = 1-`pbar'
		local se = 1/((`mbar'-1)*sqrt(`n'*`mbarh'))*sqrt(/*
		*/ 2*(`mbarh'-1)+((`mbar'-`mbarh')*(1-4*`pbar'*`qbar'))/(/*
		*/ `mbar'*`pbar'*`qbar'))
	}
	/* double save in S_# and r() */
	ret scalar kappa = `kappa'
	ret scalar z = `kappa'/`se'
	global S_4 `kappa'
	global S_5 = `return(z)'
	di _n in smcl in gr "Two-outcomes, multiple raters:" _n(2) /*
		*/ _col(10) "Kappa        Z        Prob>Z" _n /*
		*/ _col(9) "{hline 29}"
	di %14.4f return(kappa) %11.2f return(z) %12.4f 1-normprob(return(z))
end
exit
/*

 Outcome |    Kappa         Z      Prob>Z
---------+-------------------------------
namename |   xx.xxxx    xxxx.xx    x.xxxx
namename |   xx.xxxx123456789011234567890
---------+-------------------------------
combined |   xx.xxxx    xxxx.xx    x.xxxx
*/

