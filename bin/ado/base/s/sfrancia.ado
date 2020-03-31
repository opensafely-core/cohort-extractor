*! version 2.3.0  19feb2019
*  Originally written by P. Royston, updated by StataCorp
program define sfrancia, rclass byable(recall) sort
	version 6, missing
	syntax varlist [if] [in] [, boxcox noTies ]

	if _caller() < 12 { // version control
		local boxcox boxcox
	}
	tempvar touse
	mark `touse' `if' `in'	/* but do not markout varlist */

	if ("`boxcox'"!="") {
		local nmin = 5
		local nmax = 1000
		local trlab Box-Cox
	}
	else {
		local nmin = 10
		local nmax = 5000
		local trlab log
	}

	tokenize `varlist'
	#delimit ; 
	di in smcl in gr _n _col(19) /*
		*/ "Shapiro-Francia W' test for normal data" _n _n
		"    Variable {c |}       Obs" _col(32) "W'"
		_col(44) "V'"
		_col(54) "z       Prob>z" _n 
		"{hline 13}{c +}{hline 53}"
	;
	#delimit cr
	tempvar WD1
	while "`1'"~="" { 
		/*
			Calculate ranks
		*/
		capture drop `WD1'
		if "`ties'"!="" {
			tempvar UVAR
			capture drop `UVAR'
			qui gen `UVAR' = `1' if `touse'
			qui sort `UVAR'
			qui gen `WD1' = _n if `touse'
		}
		else {
			qui genrank `WD1' = `1' if `touse'  
		}
		/*
			Calculate number of good values
		*/
		quietly summarize `WD1'
		local G=r(N)
		if r(N)<`nmin' { 
			local R . 
			local w . 
			local Z .
			local sig .
			ret scalar p = .
		}
		else if "`boxcox'"!="" { // Royston (1983)
			quietly replace `WD1'=invnorm((`WD1'-0.375)/(`G'+0.25))
			quietly corr `1' `WD1'
			local X=log(`G')-5
			local L=-0.0480157+`X'*(0.01971964-0.0119065*`X'*`X')
			local M=-exp(1.6930674+`X'*(0.1441647 /*
				*/	+`X'*(-0.01849276  /*
				*/	+`X'*(0.031074485+`X'*0.0055717663))))
			local S=exp(-0.510725+`X'*(-0.1160364 /*
				*/	+`X'*(-0.006702098 /*
				*/ 	+`X'*(0.054465944+`X'*0.0087397329))))
			local Y=(((1-(r(rho))^2)^`L')-1)/`L'
			local Z=(`Y'-`M')/`S'
			local R=(r(rho))^2
			local w=(1-`R')/( (`L'*`M'+1)^(1/`L') )
			ret scalar p = normprob(-`Z')
			local sig=max(return(p),.00001)
		}
		else { // Royston (1993)
			quietly replace `WD1' =invnorm((`WD1'-0.375)/(`G'+0.25))
			quietly corr `1' `WD1'
			local R = (r(rho))^2
			local U = log(`G')
			local V = log(`U')
			local M = -1.2725 + 1.0521*(`V'-`U') 	
			local S = 1.0308 - 0.26758*(`V'+(2/`U'))
			local Y = log1m(`R')
			local Z = (`Y'-`M')/`S'
			local w = (1-`R')*exp(-`M')
			ret scalar p = normprob(-`Z')
			local sig = max(return(p),.00001)
		}
		#delimit ;
		di in smcl in gr %12s abbrev("`1'",12) " {c |}" in ye
			%10.0fc `G' "   "
			%8.5f `R' "   "
			%8.3f `w' "  "
			%8.3f `Z' "    "
			%7.5f `sig'
		;
		#delimit cr
		mac shift 
	}
	if (`G'<`nmin' | `G'>`nmax') {
		di
		di in smcl "{p 0 6 2 67}" 
		di as txt in smcl "Note: The normal approximation to the"
		di as txt in smcl "sampling distribution of W' is valid for"
		di as txt in smcl "`nmin'<=n<=`nmax' under the `trlab'"
		di as txt in smcl "transformation.{p_end}"
	}
	ret scalar N = `G'
	ret scalar W = `R'
	ret scalar V = `w'
	ret scalar z = `Z'

	/* Double saves */
	global S_1 `return(N)'		/* # observations		*/
	global S_2 `return(W)'		/* W'				*/
	global S_3 `return(V)'		/* V'				*/
	global S_4 `return(z)'		/* z				*/
	global S_5 `return(p)'
end

