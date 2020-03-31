*! version 1.0.0  02sep2004
program define xtgee_elink
	version 6.0
	args type m e N

	if "`type'" == "poiss" {
		replace `e' = `e'/sqrt(`m')
	}
	else if "`type'" == "binom" {
		tempvar tt
		gen double `tt' = `m'/`N' * (1 - `m'/`N')
		replace `tt' = 1e-24 if `tt' < 1e-24
		replace `e' = `e' / sqrt(`tt' * `N')
	}
	else if "`type'" == "gamma" {
		replace `e' = `e'/abs(`m')
	}
	else if "`type'" == "nbinom" {
		replace `e' = `e' / sqrt(`m' + $S_X_nba*`m'*`m')
	}
	else if "`type'" == "igauss" {
		replace `e' = `e' / sqrt(`m'^3)
	}
end
exit
