*! version 4.1.0  19 Feb 2019  (glm component)
program define _crcgldv /* squared weighted deviance residuals */
	version 4.0
	local y `1'
	local family "`2'"
	local bernoul `3'
	local m `4'
	local k `5'
	local mu `6'
	local wt `7'
	local dev `8'
	quietly {
		if "`family'"=="gau" {
			replace `dev' = (`y'-`mu')^2
		}
		else if "`family'"=="bin" & `bernoul' {
			replace `dev'= cond(`y', -2*ln(`mu'), /*
			 */ -2*ln1m(`mu'))
		}
		else if "`family'"=="bin" & !`bernoul' {
			replace `dev' = cond(`y'>0 & `y'<`m', /*
	 */ 2*`y'*ln(`y'/`mu') + 2*(`m'-`y')*ln((`m'-`y')/(`m'-`mu')), /*
	 */ cond(`y'==0, 2*`m'*ln(`m'/(`m'-`mu')), 2*`y'*ln(`y'/`mu')) ) 
		}
		else if "`family'" == "poi" { 
			replace `dev' = cond(`y'==0, 2*`mu', /*
			 */ 2*(`y'*ln(`y'/`mu')-(`y'-`mu')))
		}
		else if "`family'" == "gam" {
			replace `dev' = -2*(ln(`y'/`mu')- /*
			 */ (`y'-`mu')/`mu')
		}
		else if "`family'" == "ivg" {
			replace `dev' = (`y'-`mu')^2/(`mu'^2*`y')
		}
		else if "`family'" == "nb" {
			replace `dev' = cond(`y'==0, /*
			 */ 2*ln1p(`k'*`mu')/`k', /*
			 */ 2*(`y'*ln(`y'/`mu')-(1+`k'*`y')/`k'*  /*
			 */ ln((1+`k'*`y')/(1+`k'*`mu'))))
		}
		replace `dev'=max(0,`dev')*`wt'	    /* max:  for roundoff */
	}
end
