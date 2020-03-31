*! version 3.2.0  19feb2019
program define swilk, rclass byable(recall) sort
	version 6, missing
	syntax varlist [if] [in] [, Lnnormal noTies Generate(string) ]
	tempvar touse 
	mark `touse' `if' `in' 	/* but do not markout varlist */
/*
	Default options are:
		display the output,
		normal (not 3-param lognormal),
		b1 (minimum skewness estimate of shift parameter, not
			gammastar),
		ranks to calc scores.
*/
	if "`generat'"!="" { 
		confirm new var `generat'
	}

	tempvar WTEST UVAR

	if "`lnnorma'" == "" {
		di _n in gr _col(20) "Shapiro-Wilk W test for normal data" _n
	}
	else {
		di _n in gr _col(10) /*
		*/ "Shapiro-Wilk W test for 3-parameter lognormal data" _n
	}
	di in smcl in gr "    Variable {c |}        Obs" _col(33) "W" /*
		*/ _col(45) "V" _col(55) "z       Prob>z" _n /*
		*/ "{hline 13}{c +}{hline 54}"

	tokenize `varlist'
	while "`1'"~="" {
		capture drop `WTEST'
		capture drop `UVAR'
		local vtype : type `1'
		/*
			Calculate number of good values and SSQ of data
		*/
		quietly {
			if bsubstr("`vtype'",1,3)=="str" { 
				gen `UVAR' = . 
			}
			else	gen `UVAR'=`1' if `touse'
			summarize `UVAR'
			local G=r(N)
		}
		if `G'<3 | ("`lnnorma'" ~= "" & `G'<5) {
			local W .
			local V . 
			local Z . 
			local P .
			if "`generat'" ~= "" {
				capture drop `generat'
				qui gen `generat' = .
			}
		}
		else {
			local G1 = `G'-1
			local SD=sqrt(r(Var))

			/*
				Calculate ranks or 1..n
			*/
			if "`ties'" ~= "noties" {
				qui genrank `WTEST' = `UVAR'
			}
			else {
				sort `UVAR'
				qui gen `WTEST' = _n if `UVAR' <.
			}

			/*
				Calculate coefficients
			*/
			if `G'==3 {
				qui replace `WTEST' = sqrt(0.5)*(_n-2)
			}
			else {
				qui replace `WTEST'=/*
					*/ invnorm((`WTEST'-.375)/(`G'+0.25))
				qui summarize `WTEST'
				local summ2=r(Var)*`G1'
				local X = 1/sqrt(`G')
				local A1 = `WTEST'[`G']/sqrt(`summ2') /*
				*/ +`X'*(0.221157+`X'*(-0.147981 /*
				*/ +`X'*(-2.071190 /*
				*/ +`X'*(4.434685-`X'*2.706056))))
				/*
					Renormalize the m-based coeffs to find
					approximate coeffs
				*/
				if `G'>5 {
					local i1 3
					local A2=`WTEST'[`G1']/sqrt(`summ2') /*
					*/ +`X'*(0.042981+`X'*(-0.293762 /*
					*/ +`X'*(-1.752461+`X'*(5.682633 /*
					*/ -`X'*3.582633))))
					local fac= /*
					*/ sqrt((`summ2'-2*`WTEST'[`G']^2- /*
					*/ 2*`WTEST'[`G1']^2)/ /*
					*/ (1-2*(`A1')^2-2*(`A2')^2))
					quietly {
						replace `WTEST' = `A1' in `G'
						replace `WTEST' = `A2' in `G1'
						replace `WTEST' = -`A1' in 1
						replace `WTEST' = -`A2' in 2
					}
				}
				else {
					local i1 2
					local fac= /*
					*/ sqrt((`summ2'-2*`WTEST'[`G']^2)/ /*
					*/ (1-2*(`A1')^2))
					qui replace `WTEST' = `A1' in `G'
					qui replace `WTEST' = -`A1' in 1
				}
				local i2=`G'-`i1'+1
				qui replace `WTEST'=`WTEST'/`fac' in `i1'/`i2'
			}
			/*
				Save coefficients if required
			*/
			if "`generat'" ~= "" {
				capture drop `generat'
				qui gen `generat' = `WTEST'
			}
			/*
				Get W
			*/
			qui correlate `UVAR' `WTEST'
			local W=(r(rho))^2
			local Y = log1m(`W')
			local X = log(`G')
			local M   0
			local S   1
			if `G'==3 {
				/*
					Exact P value for n=3
				*/
				local SW = sqrt(`W')
				global ang = 1.5707288+`SW'*(-0.2121144+ /*
			 	*/ `SW'*(0.074261-0.0187293*`SW'))
				global ang = _pi/2-$ang*sqrt(1-`SW')
				local stqr = 1.047198 /* arcsin sqrt(0.75) */
				local P = (6/_pi)*($ang-`stqr')
				local Z = -invnorm(`P')
				local V = (1-`W')/(1-(sin(_pi/12+`stqr'))^2)
			}
			else {
				if `G'<=11 {
					local gamma = `G'*0.459-2.273
					if `Y'>=`gamma' {
						local Y = 9.9999 /* signif */
						local V   .
					}
					else {
						local Y = -log(-`Y'+`gamma')
						local M = 0.5440+ /*
						*/ `G'*(-0.39978 + `G'* /*
				 		*/ (0.025054-`G'*0.0006714))
						local S= /*
						*/ exp(1.3822+`G'*(-0.77857 /*
				 		*/ +`G'* /*
						*/ (0.062767-`G'*0.0020322)))
						/*
						  V is (1-W)/(median of 1-W)
						*/
						local V = (1-`W') /*
						*/ /exp(`gamma'-exp(-`M'))
					}
				}
				else {
					local M = -1.5861+`X'*(-0.31082 /*
					*/ +`X'*(-0.083751+`X'*0.0038915))
					local S = exp(-0.4803+`X'*(-0.082676 /*
					*/ +`X'*0.0030302))
					/*
						V is (1-W)/(median of 1-W).
					*/
					local V=(1-`W')/exp(`M')
		  		}
				if "`lnnorma'" ~= "" {
					local S2 = `SD'-(`SD')^2
					if `G'<=11 {
						local ZBAR= /*
						*/ -3.8267+`X'*(2.82415- /*
						*/ `S2'*0.020815-`X'*0.63673)
						local ZSD =-4.9914+`X'* /*
						*/ (-`S2'*0.013431+ /*
						*/ 8.6724+ /*
						*/ `X'*(-4.2790+`X'*0.70350))
					}
					else {
						local ZBAR = -3.7796+`X'* /*
						*/ (2.40381-`S2'* /*
						*/ 0.027027+`X'* /*
						*/ (-0.66756-`S2'*0.0019887+ /*
						*/ `X'* /*
						*/ (0.082863-`X'*0.0037935)))
						local ZSD= /*
						*/ 2.1924+`X'*(-1.0957+`X'* /*
						*/ (0.33737-`S2'*0.0053312+ /*
						*/ `X'* (-0.043201+ /*
						*/ `X'*0.0019974)))
					}
					local M=`M'+`ZBAR'*`S'
					local S=`S'*`ZSD'
		  		}
		  		local Z=(`Y'-`M')/`S'
		  		local P=normprob(-`Z')
			}
		}
		#delimit ;
		di in smcl in gr %12s abbrev("`1'",12) " {c |} " in ye
			%10.0fc `G' "   "
			%8.5f `W' "   "
			%8.3f `V' "  "
			%8.3f `Z' "    "
			%7.5f `P'
		;
		#delimit cr
		mac shift
	}

	
	local nmin 4
	local nmax 2000
	qui count if `touse'
	if (r(N)<`nmin' | r(N)>`nmax') {
                di
                di in smcl "{p 0 6 2 67}" 
                di as txt in smcl "Note: The normal approximation to the"
                di as txt in smcl "sampling distribution of W' is valid for"
                di as txt in smcl "`nmin'<=n<=`nmax'.{p_end}"
        }

	return scalar N = `G'
	return scalar W = `W'
	return scalar V = `V'
	return scalar z = `Z'
	return scalar p = `P'

	/* Double saves */
	global S_1 "`return(N)'"
	global S_2 "`return(W)'"
	global S_3 "`return(V)'"
	global S_4 "`return(z)'"
	global S_5 "`return(p)'"
end
