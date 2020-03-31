*! version 1.1.0  19feb2019
program define xtsf_llti, sort  /* Time-varying inefficient model,
			   Y_it = X_it*beta + E_it
			   E_it = V_it - $S_COST*eta_it*U_i
		   	   $S_COST = 1, production function; -1, cost function
			   assume U_i ~ nonnegative N(mu, sigma) 
				  V_it ~ N(0, sigmaV)
			   eta_it = exp(-`eta'*(_n-`T')) ; `eta'=0
			*/
	version 8 
	args todo b lnf g negH

	tempvar xb
	tempname sigmaS2 gamma mu eta lnsigmaS2 ltgamma
		/* xb = X_it*beta
		   sigmaS^2 = sigmaV^2 + sigma^2, sigmaS > 0	 
		   gamma = sigma^2/sigmaS^2, 0 < gamma < 1
		   lnsigmaS2 = ln(simgaS^2)
		   ltgamma = ln(gamma/(1-gamma))
		*/

	mleval `xb' = `b', eq(1)
	mleval `lnsigmaS2' = `b', eq(2) scalar 
	mleval `ltgamma' = `b', eq(3) scalar
	mleval `mu' = `b', eq(4) scalar

	local bound 20
	if abs(`lnsigmaS2') > `bound' { 
		scalar `lnsigmaS2' = sign(`lnsigmaS2')*`bound' 
	}
	if abs(`ltgamma') > `bound' { 
		scalar `ltgamma' = sign(`ltgamma')*`bound' 
	}

	scalar `gamma' = exp(`ltgamma')/(1+exp(`ltgamma'))
	scalar `sigmaS2' = exp(`lnsigmaS2')

	/* the followings need to be done in the main prog 
	global S_XTby id
	*global S_XTt t
	sort $S_XTby 
	global S_COST = 1	
	   -- end -- */

	local by "by $ML_samp $S_XTby"
	sort $ML_samp $S_XTby

	quietly {

		tempvar T eta_e zi e2 f denom
		tempname z
			/* count the numbers of time periods in each panel */
		`by': gen long `T' = sum($ML_samp) if $ML_samp
		`by': replace `T' = `T'[_N] if $ML_samp

		local e ($ML_y1-`xb')
		/* local eta_it 1 */

			/* Note: missing values for _n < _N
			   makes evaluations of below fast.
			   Only one value needed in each panel
			*/
	
		`by': gen double `eta_e' = cond( _n==_N, /*
			*/ sum(`e'), . ) if $ML_samp
		local eta2 (`T')
		`by': gen double `e2' = cond( _n==_N, sum(`e'^2), . ) /*
			*/ if $ML_samp

			/* the denominator of zi, will be called a lot */
		gen double `denom' = sqrt(`gamma'*(1-`gamma')*`sigmaS2' /*
			*/ *(1+(`eta2'-1)*`gamma')) if $ML_samp

		gen double `zi' = (`mu'*(1-`gamma')-$S_COST*`gamma'*`eta_e') /*
			*/ /`denom' if $ML_samp
		scalar `z' = `mu'/sqrt(`gamma'*`sigmaS2')

		gen double `f' = -1/2*`T'*(ln(2*_pi)+ln(`sigmaS2')) /*
			*/ - 1/2*(`T'-1)*ln1m(`gamma') /*
			*/ - 1/2*ln1p((`eta2'-1)*`gamma') /*
			*/ - ln(normprob(`z')) - 1/2*`z'^2 /*
			*/ + ln(normprob(`zi')) /*
			*/ + 1/2*`zi'^2 /*
			*/ - 1/2*(`e2'/((1-`gamma')*`sigmaS2')) if $ML_samp

			/* sum(missing)=0, which may give `lnf'=0
			   even if the logL can not be calculated */

		tempvar missing
		`by': gen byte `missing' = (`f'>=.) if _n==_N & $ML_samp
		summ `missing' if $ML_samp, meanonly
		if r(max) == 1 {
				/* logL can not be calculated for some
				   observation */
			scalar `lnf' = .
		}
		else {
			mlsum `lnf'=cond(`f'<., `f', 0)
		}

		if `todo' == 0 | `lnf'==. {
			exit
		}

		drop `f'
		tempname g1 g2 g3 g4 g5

		tempname normz
		tempvar normzi
		local ratio_z (cond(`z'>=-37, normd(`z')/norm(`z'), -`z'))
		local ratio_zi (cond(`zi'>=-37, normd(`zi')/norm(`zi'), -`zi'))
		scalar `normz' = `ratio_z'+`z'
		gen double `normzi' = `ratio_zi'+`zi'

		`by': replace `normzi'= `normzi'[_N] if $ML_samp
		`by': replace `denom' = `denom'[_N] if $ML_samp

		tempvar dng dzxb dzs2 dzgamma dzmu

			/* note: `dzxb' and `dzmu' are for whole sample,
			   the other three are for the last obs. in each
			   panel */
					/* --d(denom)/d(gamma)-- */
		gen double `dng' = `sigmaS2' /*
			*/ *((1-2*`gamma')+(`eta2'-1)*`gamma'*(2-3*`gamma'))
					/* -----d(zi)/d(xb)------ */
		gen double `dzxb' = $S_COST*`gamma'/`denom' if $ML_samp
					/* ---d(zi)/d(sigmaS^2)-- */
		gen double `dzs2' = -0.5*`zi'/`sigmaS2'
					/* ----d(zi)/d(gamma)---- */
		gen double `dzgamma' = -(`mu'+$S_COST*`eta_e')/`denom' /*
			*/ - 0.5*(`mu'*(1-`gamma')-$S_COST*`gamma'*`eta_e') /*
			*/ *`dng'/(`denom'^3)
					/* -----d(zi)/d(mu)------ */
		gen double `dzmu' = (1-`gamma')/`denom'

					/* ---d(lnL)/d(theta3)--- */
		local dg3 ( `gamma'*(1-`gamma')*(0.5*(`T'-1)/(1-`gamma') /*
			*/ - 0.5*(`eta2'-1)/(1+(`eta2'-1)*`gamma') /*
			*/ + 0.5*`normz'*`z'/`gamma' + `normzi'*`dzgamma' /*
			*/ - 0.5*`e2'/((1-`gamma')^2*`sigmaS2')) )

			/* in eq(1), do not use -cond()-
			   to sum over the last observation in
			   each id group, since the derivatives
			   needs to be calculated in observation level.
                           g1 = eq(1)*(x1,x2,...,1)' where xi are the 
			   vector of ith covariate. */

		mlvecsum `lnf' `g1' =  `e'/((1-`gamma')*`sigmaS2') /*
			*/ + `normzi'*`dzxb', eq(1)
		mlvecsum `lnf' `g2' = cond( `zi'~=., /*
			*/ -0.5*(`T'-`normz'*`z' + `normzi'*`zi' /*
			*/ - `e2'/((1-`gamma')*`sigmaS2')), 0 ), eq(2)
		mlvecsum `lnf' `g3' = cond( `zi'~=., /*
			*/ `dg3', 0 ), eq(3)
		mlvecsum `lnf' `g4' = cond( `zi'~=., /*
			*/ -1/sqrt(`gamma'*`sigmaS2')*`normz' /*
			*/ +`normzi'*`dzmu', 0 ), eq(4)  
		
		matrix `g'= (`g1', `g2', `g3', `g4')

		if `todo' == 1 | `lnf'==. {
			exit
		}
	
		#delimit ;
		tempname d11 d12 d13 d14 d15 d22 d23 d24 d25 d33 d34 d35
			 d44 d45 d55;

		tempname Rz d11i;
		tempvar Rzi dzgammaxb dzxb1;

		`by': replace `dzs2' = `dzs2'[_N] if $ML_samp;
		`by': replace `dzgamma' = `dzgamma'[_N] if $ML_samp;

					/* d(normd(z)/norm(z))/d(z) */
		scalar `Rz' = `ratio_z'*(`normz');
		gen double `Rzi' = `ratio_zi'*(`normzi') if $ML_samp;
		`by': replace `Rzi' = `Rzi'[_N] if $ML_samp;
 					/* d(dzxb)/d(gamma) */
		`by': gen double `dzgammaxb' = `gamma'*(1-`gamma')*( 
			$S_COST/`denom'
			- 0.5*($S_COST*`gamma')*`dng'[_N]/(`denom'^3) )
			if $ML_samp;
					/* d(dzgamma)/d(gamma) */
		local dzgamma2 ( -1/2*(-`mu'-$S_COST*`eta_e')*`dng'/`denom'^3
			+ 3/4*(`mu'*(1-`gamma')-$S_COST*`gamma'*`eta_e')
			*`dng'^2/(`denom'^5)
			- 1/2*((-`mu'-$S_COST*`eta_e')*`dng'
			+ (`mu'*(1-`gamma')-$S_COST*`gamma'*`eta_e')
			*`sigmaS2'*(-6*(`eta2'-1)*`gamma'+2*(`eta2'-2)))
			/`denom'^3 );
					/* d(z)/d(mu) */
		local dzdmu (1/sqrt(`gamma'*`sigmaS2'));

					/* trick for eq(1) */
		local names : colnames(`b');
		tokenize `names';
		local n : word count `names';
		local n = `n'-3;	/* 3 parameters */
		local i 1;
		gen double `dzxb1'=.;
		while `i' <= `n' { ;
					/* here `i' refers to _cons, not 
					   local i */
			if "``i''"=="_cons" { ;
				local `i' 1 ;
			};
			`by': replace `dzxb1' = 
			sum($S_COST*`gamma'*``i''/`denom') if $ML_samp;
			`by': replace `dzxb1' = 
			(`Rzi'-1)*$S_COST*`gamma'/`denom'*`dzxb1'[_N]
			+ ``i''/((1-`gamma')*`sigmaS2') if $ML_samp;
			mlvecsum `lnf' `d11i' = `dzxb1', eq(1);
			if `lnf'==. { ;
				exit ;
			};
			mat `d11' = nullmat(`d11') \ `d11i';
			local i = `i' + 1;
		};
					/* make perfectly symmetric */
		mat `d11' = 0.5*(`d11' + `d11''); 

		mlmatsum `lnf' `d12' = (`Rzi'-1)*`dzxb'*`dzs2'*`sigmaS2'
			- `normzi'*(-0.5*$S_COST*`gamma'/`denom')
			+ `e'/((1-`gamma')*`sigmaS2'), eq(1,2);

		mlmatsum `lnf' `d13' = (`Rzi'-1)*`dzxb'*`dzgamma'
			*`gamma'*(1-`gamma') - `normzi'*`dzgammaxb'
			- `e'*`gamma'/((1-`gamma')*`sigmaS2'), eq(1,3);

		mlmatsum `lnf' `d14' = (`Rzi'-1)*`dzxb'*`dzmu', eq(1,4);

		mlmatsum `lnf' `d22' = cond(`zi'~=., 
			- (`Rz'-1)*(-`z'/2)*(-`z'/2)
			+ `normz'*(-1/2)*(-`z'/2) 
			+ (`Rzi'-1)*(-`zi'/2)*(-`zi'/2)
			- `normzi'*(-1/2)*(-`zi'/2)
			+ 1/2*`e2'/((1-`gamma')*`sigmaS2'), 0 ), eq(2);

		mlmatsum `lnf' `d23' = cond( `zi'~=., 
			`gamma'*(1-`gamma')*(-1/2)*( 
			- (`Rz'-1)*`z'*(-`z'/(2*`gamma'))
			+ `normz'*(-`z'/(2*`gamma')) + (`Rzi'-1)*`zi'*`dzgamma'
			- `normzi'*`dzgamma' + `e2'/((1-`gamma')^2
			*`sigmaS2') ), 0 )
			, eq(2,3);

		mlmatsum `lnf' `d24' =  cond( `zi'~=.,
			(-1/2)*( -(`Rz'-1)*`z'*`dzdmu'
			+ `normz'*`dzdmu' + (`Rzi'-1)*`zi'*`dzmu'
			- `normzi'*`dzmu'), 0 ), eq(2,4);

		mlmatsum `lnf' `d33' = cond( `zi'~=., 
			-(1-2*`gamma')*`dg3' - (`gamma'*(1-`gamma'))^2*( 
			1/2*(`T'-1)/(1-`gamma')^2 
			+ 1/2*(`eta2'-1)^2/((1+(`eta2'-1)*`gamma'))^2
			- (-`Rz'+1)*(-0.5*`z'/`gamma')^2
			- `normz'*(3/4*`z'/`gamma'^2)
			+ (-`Rzi'+1)*`dzgamma'^2
			+ `normzi'*`dzgamma2' - `e2'/((1-`gamma')^3*`sigmaS2'))
			, 0 ), eq(3);

		mlmatsum `lnf' `d34' = cond( `zi'~=., 
			- `gamma'*(1-`gamma')*(
			- (-`Rz'+1)*(-0.5*`z'/`gamma')*`dzdmu'
			- `normz'*(-0.5/`gamma')*`dzdmu'
			+ (-`Rzi'+1)*`dzgamma'*`dzmu'
			+ `normzi'*(-1/`denom'-0.5*(1-`gamma')*`dng'
			/`denom'^3) )
			, 0 ), eq(3,4);

		mlmatsum `lnf' `d44' = cond( `zi'~=.,
			(-`Rz'+1)*`dzdmu'^2
			-(-`Rzi'+1)*`dzmu'^2
			, 0 ), eq(4);

		matrix `negH' = ( `d11',  `d12',  `d13',  `d14'
				\ `d12'', `d22',  `d23',  `d24'
				\ `d13'', `d23'', `d33',  `d34'
				\ `d14'', `d24'', `d34'', `d44' );

		#delimit cr

	}

end
