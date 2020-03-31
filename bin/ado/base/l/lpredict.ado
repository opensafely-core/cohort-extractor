*! version 2.3.0  19feb2019
program define lpredict
* touched by kth
	version 6.0
	if `"`e(cmd)'"'!="logistic" & "`e(cmd)'"!="logit" { error 301 }

	tempvar new keep y m p 
	syntax newvarname(gen) [, DBeta DEviance DX2 DDeviance Hat Number /*
		*/ Resid RStandard ]
	rename `varlist' `new'

	if `"`rstanda'"'!="" { 
		tempvar resid hat
		lpredict `resid', resid
		lpredict `hat', hat 
		quietly replace `new' = `resid'/sqrt(1-`hat')
		label var `new' "standardized Pearson residual"
		rename `new' `varlist'
		exit
	}
	if `"`dbeta'"'!="" { 
		tempvar resid hat
		lpredict `resid', resid 
		lpredict `hat', hat 
		quietly replace `new' = `resid'^2*`hat'/(1-`hat')^2
		label var `new' "Pregibon's dbeta"
		rename `new' `varlist'
		exit
	}
	if `"`dx2'"'!="" { 
		tempvar rstd
		lpredict `rstd', rstandard
		quietly replace `new' = `rstd'^2
		label var `new' "H-L dX^2"
		rename `new' `varlist'
		exit
	}
	if `"`ddevian'"'!="" { 
		tempvar dev res hat
		lpredict `dev', deviance
		lpredict `hat', hat
		quietly replace `new' = `dev'^2/(1-`hat')
		label var `new' "H-L dD"
		rename `new' `varlist'
		exit
	}

	if `"`resid'`devianc'`hat'`number'"'=="" { 
		local prob "prob"
	}

	local l `e(depvar)'
	_getrhs rhs

	quietly { 
		_predict double `p' if e(sample)
		gen byte `keep'=`p'!=. & `l'!=. 
		if `"`e(wtype)'"'!="" { 
			if `"`e(wtype)'"'!="fweight" {
				di in red /*
				*/ `"not possible with `e(type)'s"'
				exit 135
			}
			tempvar w 
			gen `w' `e(wexp)'
			replace `keep'=0 if `w'<=0 | `w'==.
			replace `w'=. if `keep'==0
			local lab "weighted "
		}
		else	local w 1

		if `"`prob'"'!="" { 
			label var `new' `"`lab'Pr(`e(depvar)')"'
			replace `new'=`p' if `keep'
			rename `new' `varlist'
			exit
		}

		sort `keep' `rhs'
		if `"`number'"'!="" { 
			by `keep' `rhs': replace `new'=cond(_n==1 & `keep',1,.)
			replace `new' = sum(`new')
			replace `new'=. if `new'==0
			label var `new' "covariate pattern"
			rename `new' `varlist'
			exit
		}
		by `keep' `rhs': gen `c(obs_t)' `m'=cond(_n==_N,sum(`w'),.)
		by `keep' `rhs': gen `c(obs_t)' `y'=cond(_n==_N, /*
				*/ sum((`l'!=0 & `l'!=.)*`w') ,.)

		if `"`devianc'"'!="" { 
			label var `new' `"`lab'deviance residual"'
			#delimit ;
			replace `new' = sqrt(
				2*(
				`y'*ln(`y'/(`m'*`p')) + 
				(`m'-`y')*ln((`m'-`y')/(`m'*(1-`p')))
				)
				)
			;
			#delimit cr
			replace `new'=-`new' if `y'-`m'*`p'<0
			replace `new'=-sqrt(2*`m'*abs(ln1m(`p'))) if `y'==0
			replace `new'=sqrt(2*`m'*abs(ln(`p'))) if `y'==`m'
		}
		else if `"`hat'"'!="" { 
			label var `new' `"`lab'leverage"'
			tempvar rthat
			_predict double `rthat', stdp
			replace `new'=`m'*`p'*(1-`p')*`rthat'*`rthat'
		}
		else {
			label var `new' `"`lab'Pearson residual"'
			replace `new' = (`y'-`m'*`p')/sqrt(`m'*`p'*(1-`p'))
		}
		by `keep' `rhs': replace `new' = cond(`keep',`new'[_N],.)
	}
	rename `new' `varlist'
end
