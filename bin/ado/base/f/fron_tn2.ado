*! version 1.1.0  18jun2009
program define fron_tn2	
			/* frontier: truncated-normal model,
			   Y_i = X_i*beta + E_i; E_i = V_i - $S_COST*U_i
		   	   $S_COST = 1, production function; -1, cost function
			   assume U_i ~ nonnegative N(mu, sigma_u) 
				  V_i ~ N(0, sigma_v) noise
			   ivl_gam is inverse logit of gamma, i.e.
				gamma=exp(ivl_gamma)/(1+exp(ivl_gamma))
				     =sigma_u^2/sigma_s^2
	   		   ln_sigs2=ln(sigma_s^2)
				sigma_s^2 = sigma_u^2 + sigma_v^2
			*/
			/* this program uses (b, mu, ln(sigmaS2), 
			   ilogit(gamma)) to estimate
   			   the truncated-normal model.  
			   This is the untransformed version of
   			   fron_tn.ado 
			*/

	version 7
	args todo b lnf g negH g1 g2 g3 g4

	tempvar xb mu 
	tempname ivl_gamma ln_sigs2
	mleval `xb'=`b', eq(1)		/* linear form xb */
	mleval `mu'=`b', eq(2)		/* mu, mean of truncated normal */
	mleval `ivl_gamma' = `b', eq(3) scalar
	mleval `ln_sigs2' = `b', eq(4) scalar

	local bound 20
	if abs(`ln_sigs2') > `bound' { 
		scalar `ln_sigs2' = sign(`ln_sigs2')*`bound' 
	}

	tempname sigmaS gamma sigmaV sigmaU lambda

	scalar `sigmaS' = exp(0.5*`ln_sigs2')
	local sigs2 (`sigmaS'^2)
	scalar `gamma' = exp(`ivl_gamma')/(1+exp(`ivl_gamma'))
	scalar `sigmaU' = sqrt(`gamma'*`sigs2')
	scalar `sigmaV' = sqrt((1-`gamma')*`sigs2')
	scalar `lambda' = `sigmaU'/`sigmaV'	/* sqrt(gamma/(1-gamma)) */

	tempvar e z1 z2 z3
	qui gen double `e' = $ML_y1-`xb'
	qui gen double `z1'= `mu'/`sigmaU'
	qui gen double `z2'= (`mu'/`lambda' - $S_COST*`lambda'*`e')/`sigmaS'
	qui gen double `z3'= (`e' + $S_COST*`mu')/`sigmaS'

	mlsum `lnf' = -0.5*ln(2*_pi) - ln(`sigmaS') /*
		*/ - ln(norm(`z1')) + ln(norm(`z2')) - 1/2*(`z3')^2 

	if `todo'==0 | `lnf'==. {exit}

$ML_ec	tempname d1 d2 d3 d4
	tempvar zr1 zr2
	qui gen double `zr1'=cond(`z1'>=-37, normd(`z1')/norm(`z1'), -`z1')
	qui gen double `zr2'=cond(`z2'>=-37, normd(`z2')/norm(`z2'), -`z2')

	tempname dgt dlg dz1lg
				/* d(sigmaS)/d(lnsigs2) */
	local dss (0.5*`sigmaS')
				/* d(gamma)/d(ivl_gamma) */
	scalar `dgt' = exp(`ivl_gamma')/((1+exp(`ivl_gamma'))^2)
				/* d(lambda)/d(ivlgamma) */
	local dlag ( 0.5*(`lambda'/`gamma' + `lambda'/(1-`gamma')) )
	scalar `dlg' = `dlag'*`dgt'
	
				/* d(z1)/d(lnsigs2) */
	local dz1ls ( -0.5*`z1' )
				/* d(z1)/d(ivlgamma) */
	local dz1lg ( -0.5*`z1'/`gamma'*`dgt' )
				/* d(z1)/d(mu) */
	local dz1mu (1/`sigmaU')

	tempvar dz2ss dz2la 
	tempname dz2xb dz2mu
				/* d(z2)/d(xb) */
	scalar `dz2xb' = $S_COST*`lambda'/`sigmaS'
				/* d(z2)/d(sigmaS) */
	qui gen double `dz2ss' = -`z2'/`sigmaS'
				/* d(z2)/d(lambda) */
	qui gen double `dz2la' = -`mu'/(`sigmaS'*`lambda'^2) /*
		*/ - $S_COST*`e'/`sigmaS'
				/* d(z2)/d(mu) */
	scalar `dz2mu' = 1/(`sigmaS'*`lambda')
				/* d(z2)/d(lnsigs2) */
	local dz2ls (`dz2ss'*`dss')
				/* d(z2)/d(ivlgamma) */
	local dz2lg (`dz2la'*`dlg')

				/* d(z3)/d(xb) */
	local dz3xb (-1/`sigmaS')
				/* d(z3)/d(sigmaS) */
	local dz3ss (-`z3'/`sigmaS')
				/* d(z3)/d(mu) */
	local dz3mu ($S_COST/`sigmaS')
				/* d(z3)/d(lnsigs2) */
	local dz3ls (`dz3ss'*`dss')
				
	qui replace `g1' = `zr2'*`dz2xb' - `z3'*`dz3xb'
	qui replace `g2' = -`zr1'*`dz1mu' + `zr2'*`dz2mu' - `z3'*`dz3mu'
	qui replace `g3' = -`zr1'*`dz1lg' + `zr2'*`dz2lg' 
	qui replace `g4' = -0.5 - `zr1'*`dz1ls' /*
		*/ + `zr2'*`dz2ls' /*
		*/ - `z3'*`dz3ls'

$ML_ec	mlvecsum `lnf' `d1'=`g1', eq(1)
$ML_ec	mlvecsum `lnf' `d2'=`g2', eq(2)
$ML_ec	mlvecsum `lnf' `d3'=`g3', eq(3)
$ML_ec	mlvecsum `lnf' `d4'=`g4', eq(4)
$ML_ec	mat `g'=(`d1', `d2', `d3', `d4')

	if `todo'==1 | `lnf'==. {exit}

	tempname d11 d12 d13 d14 d22 d23 d24 d33 d34 d44

	tempvar ztd1 ztd2
				/* derivative of -normd(z1)/normprob(z1) */
	qui gen double `ztd1'=`zr1'*(`zr1'+`z1')
				/* derivative of -normd(z2)/normprob(z2) */
	qui gen double `ztd2'=`zr2'*(`zr2'+`z2')

	tempname d2gdg2 d2sds2 dlglg
				/* d(gamma)/d(ivl_gamma)d(ivl_gamma) */
	scalar `d2gdg2' = `dgt'*(1-exp(`ivl_gamma'))/(1+exp(`ivl_gamma'))
				/* d(sigmaS)/d(lnsigs2)d(lnsigs2) */
	scalar `d2sds2' = 0.5*0.5*`sigmaS' 
				/* d(lambda)/d(gamma)d(gamma) */
	scalar `dlglg' = ( 0.5*( 1/(1-`gamma')^2 - 1/`gamma'^2 )*`lambda' /*
		*/ + 0.5*( 1/(1-`gamma') + 1/`gamma' )*`dlag' ) /*
		*/ *`dgt'*`dgt' /*
		*/ + `dlag'*`d2gdg2' 
/*
	scalar `dlglg' = 0.5*( 1.5*sqrt(`gamma')/sqrt((1-`gamma')^5) /*
		*/ + 0.5/sqrt(`gamma'*(1-`gamma')^3) /*
		*/ - 0.5/sqrt(`gamma'^3*(1-`gamma')) /*
		*/ + 0.5/sqrt(`gamma'*(1-`gamma')^3) )*`dgt'*`dgt' /*
		*/ + `dlag'*`d2gdg2'
*/
				/* d(sigmaS)/d(lnsigs2)d(lnsigs2) */
	local dss2 ( 0.5*`dss' )

				/* d(z1)/d(mu)d(ivlgamma) */
	local dz1mulg (-0.5/(`sigmaS'*sqrt(`gamma'^3))*`dgt')
				/* d(z1)/d(mu)d(lnsigs2) */
	local dz1muls (-1/(`sigs2'*sqrt(`gamma'))*`dss')
				/* d(z1)/d(ivlgamma)d(ivlgamma) */
	local dz1lglg ( -0.5*(`dz1lg'/`gamma'-`z1'/`gamma'^2*`dgt')*`dgt' /*
		*/ -0.5*`z1'/`gamma'*`d2gdg2' )
				/* d(z1)/d(ivlgamma)d(lnsigs2) */
	local dz1lgls ( -0.5*`dz1ls'/`gamma'*`dgt' )
				/* d(z1)/d(lnsigs2)d(lnsigs2) */
	local dz1lsls ( -0.5*`dz1ls' )

				/* d(z2)/d(xb)d(ivlgamma) */
	local dz2xblg ($S_COST/`sigmaS'*`dlg')
				/* d(z2)/d(xb)d(lnsigs2) */
	local dz2xbls (-$S_COST*`lambda'/`sigs2'*`dss')
				/* d(z2)/d(mu)d(ivlgamma) */
	local dz2mulg (-1/(`sigmaS'*`lambda'^2)*`dlg')
				/* d(z2)/d(mu)d(lnsigs2a) */
	local dz2muls (-1/(`sigs2'*`lambda')*`dss')
				/* d(z2)/d(ivlgamma)d(ivlgamma) */
	local dz2lglg ( /*
		*/ 2*`mu'/(`sigmaS'*`lambda'^3)*`dlg'*`dlg' /*
		*/ + `dz2la'*`dlglg' /*
		*/ )
				/* d(z2)/d(ivlgamma)d(lnsigs2) */
	local dz2lgls ( 1/`sigs2'*(`mu'/`lambda'^2 + $S_COST*`e') /*
		*/ *`dss'*`dlg' )
				/* d(z2)/d(lnsigv2)d(lnsigv2) */
	local dz2lsls ( /*
		*/ (-`dz2ls'/`sigmaS' + `z2'/`sigs2'*`dss')*`dss' /*
		*/ + `dz2ss'*`dss2' /*
		*/ )

				/* d(z3)/d(xb)d(lnsigs2) */
	local dz3xbls (1/`sigs2'*`dss')
				/* d(z3)/d(mu)d(lnsigs2) */
	local dz3muls (-$S_COST/`sigs2'*`dss')
				/* d(z3)/d(lnsigs2)d(lnsigs2) */
	local dz3lsls ( /*
		*/ - (`dz3ss'/`sigmaS' - `z3'/`sigs2')*`dss'^2 /*
		*/ + `dz3ss'*`dss2' /*
		*/)

	mlmatsum `lnf' `d11' = `ztd2'*`dz2xb'*`dz2xb' 		/*
		*/ + `dz3xb'*`dz3xb' 				/*
		*/ , eq(1)

	mlmatsum `lnf' `d12' = `ztd2'*`dz2xb'*`dz2mu' 		/*
		*/ + `dz3mu'*`dz3xb' 				/*
		*/ , eq(1,2)

	mlmatsum `lnf' `d13' = `ztd2'*`dz2xb'*`dz2lg' 		/*
		*/ - `zr2'*`dz2xblg' 				/*
		*/ , eq(1,3)

	mlmatsum `lnf' `d14' = `ztd2'*`dz2xb'*`dz2ls' 		/*
		*/ - `zr2'*`dz2xbls' 				/*
		*/ + `dz3xb'*`dz3ls' + `z3'*`dz3xbls' 		/*
		*/ , eq(1,4)

	mlmatsum `lnf' `d22' = -`ztd1'*`dz1mu'*`dz1mu' 		/*
		*/ + `ztd2'*`dz2mu'*`dz2mu' + `dz3mu'*`dz3mu' 	/*
		*/ , eq(2)

	mlmatsum `lnf' `d23' = -`ztd1'*`dz1mu'*`dz1lg' 		/*
		*/ + `zr1'*`dz1mulg' + `ztd2'*`dz2mu'*`dz2lg' 	/*
		*/ - `zr2'*`dz2mulg' 		 		/*
		*/ , eq(2,3)

	mlmatsum `lnf' `d24' = -`ztd1'*`dz1mu'*`dz1ls' 		/*
		*/ + `zr1'*`dz1muls' + `ztd2'*`dz2mu'*`dz2ls' 	/*
		*/ - `zr2'*`dz2muls' + `dz3ls'*`dz3mu' 		/*
		*/ + `z3'*`dz3muls' 				/*
		*/ , eq(2,4)

	mlmatsum `lnf' `d33' = -`ztd1'*`dz1lg'*`dz1lg' 		/*
		*/ + `zr1'*`dz1lglg' + `ztd2'*`dz2lg'*`dz2lg' 	/*
		*/ - `zr2'*`dz2lglg' 				/*
		*/ , eq(3)

	mlmatsum `lnf' `d34' = -`ztd1'*`dz1lg'*`dz1ls' 		/*
		*/ + `zr1'*`dz1lgls' + `ztd2'*`dz2lg'*`dz2ls' 	/*
		*/ - `zr2'*`dz2lgls' 				/*
		*/ , eq(3,4)

	mlmatsum `lnf' `d44' = -`ztd1'*`dz1ls'*`dz1ls' 		/*
		*/ + `zr1'*`dz1lsls' + `ztd2'*`dz2ls'*`dz2ls' 	/*
		*/ - `zr2'*`dz2lsls' + `dz3ls'*`dz3ls' 		/*
		*/ + `z3'*`dz3lsls' 				/*
		*/ , eq(4)

	matrix `negH' = (`d11', `d12', `d13', `d14' 		/*
		*/ \ `d12'', `d22', `d23', `d24' 		/*
		*/ \ `d13'', `d23'', `d33', `d34' 		/*
		*/ \ `d14'', `d24'', `d34'', `d44')
end 

