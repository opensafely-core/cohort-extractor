*! version 1.1.0  19feb2019
program define xtgee_plink
	version 6.0
	args type m N

	if "`type'" == "log" {
		replace `m' = `N'*exp(`m')
	}
	else if "`type'" == "logit" {
		replace `m' = (`N'*exp(`m'))/(1+exp(`m'))
	}
	else if "`type'" == "recip" {
		replace `m' = `N'/`m'
	}
	else if "`type'" == "power" {
		if $S_X_pow == 0 {
			replace `m' = `N'*exp(`m')
		}
		else	replace `m' = `N'*`m'^(1/$S_X_pow)
	}
	else if "`type'" == "opower" {
		if $S_X_pow == 0 {
			replace `m' = `N'*exp(`m') / (1 + exp(`m'))
		}
		else	replace `m' = `N'*($S_X_pow*`m'+1)^(1/$S_X_pow) / /*
			*/          (1+(1+$S_X_pow*`m')^(1/$S_X_pow))
	}
	else if "`type'" == "nbinom" {
		replace `m' = exp(`m')/($S_X_nba*(-expm1(`m')))
	}
	else if "`type'" == "probit" {
		replace `m' = `N'*normprob(`m')
	}
        else if "`type'" == "cloglog" {
                replace `m' = `N'*(-expm1(-exp(`m')))
        }
	if "$S_X_mvar" == "binom" {
		tempvar fitted
		gen `fitted' = `m'/`N'
		summ `fitted'
		if r(max) >= .9999 {
			replace `m' = (`m'/`N'*.9999)*`N'
		}
	}
end
exit
