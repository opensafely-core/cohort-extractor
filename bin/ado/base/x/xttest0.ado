*! version 1.5.4  09feb2015
program define xttest0, rclass sort
	version 4.0
	if "`e(cmd)'"!="xtreg" & ///
		("`e(cmd2)'"!="xtreg" & "`e(cmd)'" != "xtgee") { error 301 }
	if "`e(model)'" != "re" {
		di in red "last estimates not xtreg, re"
		exit 301
	}
	if "`*'"!="" { error 198 }
	tempvar touse e sum Ti
	tempname cur Tn T ee LM pval
	tempname A1 M11

	_ms_op_info e(b)
	if r(fvops) {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
	}

	qui gen byte `touse' = e(sample)

	_evlist
	local rhs "`s(varlist)'"
	sret clear
	local lhs "`e(depvar)'"
	local ivar "`e(ivar)'"

	estimate hold `cur'
	capture {
		`vv' ///
		_regress `lhs' `rhs' if `touse'
		predict double `e' if `touse', resid
	}
	if _rc {
		estimate unhold `cur'
		error _rc
	}
	estimate unhold `cur'
	quietly {
		sort `e(ivar)'
		by `e(ivar)': gen `c(obs_t)' `Ti' = cond(_n==_N,sum(`touse'),.)
		gen double `sum' = sum(`Ti'^2)
		scalar `M11' = `sum'[_N]
		drop `sum'

		by `e(ivar)': gen double `sum' = cond(_n==_N,sum(`e')^2,.) 
		replace `sum' = sum(`sum')
		scalar `A1' = `sum'[_N]

		replace `sum' = sum(`e'^2)
		scalar `A1' = 1-`A1'/`sum'[_N]
	}
	
	if e(sigma_u) <= 0 {
		scalar `LM' = 0
		scalar `pval' = 1
	}
	else {
		scalar `LM'=scalar( ((e(N)^2)/2) * ( (`A1'^2)/(`M11'-e(N)) ) )
		scalar `pval'= chiprob(1,`LM') / 2
	}
	
	#delimit ;
	di _n in gr 
	"Breusch and Pagan Lagrangian multiplier test for random effects" ;
	di _n in gr _col(9) 
	   "`e(depvar)'[`e(ivar)',t] = Xb + u[`e(ivar)'] + e[`e(ivar)',t]" ;
	di in smcl _n in gr _col(9) "Estimated results:" _n
		_col(26) "{c |}"
		_col(34) "Var" _col(42) "sd = sqrt(Var)" _n 
		_col(17) "{hline 9}{c +}{hline 29}" ;
		
	qui summ `e(depvar)' if `touse' ;
	di in smcl _col(16) in gr %9s abbrev("`e(depvar)'",9) " {c |}  " in ye
		%9.0g r(Var) _skip(6) %9.0g sqrt(r(Var)) ;
	di in smcl _col(24) in gr "e {c |}  " in ye 
		%9.0g e(sigma_e)^2 _skip(6) %9.0g e(sigma_e) ;
	di in smcl _col(24) in gr "u {c |}  "  in ye 
		%9.0g e(sigma_u)^2 _skip(6) %9.0g e(sigma_u) ;

	version 11: ///
		di _n in gr _col(9) "Test:" _col(17) "Var(u) = 0" _n 
		_col(30) "{help j_chibar:chibar2(01)} =" ///
		_col(44)  in ye %8.2f `LM' _n in gr 			///
		_col(27) "Prob > chibar2 = " _col(45) in ye %7.4f 
		`pval' ;

#delimit cr
	ret scalar lm = `LM'
	ret scalar df = 1
	ret scalar p = `pval'

	global S_1 = `LM'	/* double save */
end
exit

Breusch and Pagan Lagrangian multiplier test for random effects
---------------------------------------------------------------

        lnC[firm,t] = Xb + u[firm] + e[firm,t]

	Estimated results:
                               Var       sd = sqrt(Var)
		---------+-----------------------------
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
		longlong |  123456789      123456789
		       u |  123456789      123456789
		       e |  123456789      123456789

	Test:   Var(u) = 0
                             chibar2(01) = xxxxx.xx
			  Prob > chibar2 =    Xx.xxxx
