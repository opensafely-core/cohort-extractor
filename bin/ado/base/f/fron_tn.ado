*! version 1.1.0  19feb2019
program defin fron_tn
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
			/* this program uses (b/sigs2, mu/sigs2, ln(sigmaS2), 
			   ilogit(gamma)) to estimate
   			   the truncated-normal model.  
			   This is the transformed version of
   			   fron_tn2.ado 
			*/
	version 8 
	args todo b lnf g negH
	
	tempvar xb zd ivl_gamma ln_sigs2
	
	tempname gamma sigs2 w2
	tempvar dit dits ytilde w1
	
	mleval `xb' 		= `b', eq(1)
	mleval `zd' 		= `b', eq(2)
	mleval `ivl_gamma' 	= `b', eq(3) scalar
	mleval `ln_sigs2' 	= `b', eq(4) scalar

	local bound 20
	if abs(`ln_sigs2') > `bound' { 
		scalar `ln_sigs2' = sign(`ln_sigs2')*`bound' 
	}
	if abs(`zd') < 1e-`bound' { 
		scalar `zd' = sign(`zd')*1e-`bound' 
	}
	
	scalar `sigs2'           = exp(`ln_sigs2')
	scalar `gamma'           = exp(`ivl_gamma')/(1+exp(`ivl_gamma'))

	qui gen double `ytilde'  = $ML_y1/sqrt(`sigs2')
	qui gen double `w1' = (1-`gamma')*`zd' /*
		*/ - $S_COST*`gamma'*(`ytilde'-`xb')
	scalar `w2'  = 1/( sqrt(`gamma'*(1-`gamma') )) 

	qui gen double `dit'     = `zd' / (sqrt(`gamma'))
	qui gen double `dits'    = `w1'*`w2'
	qui mlsum `lnf'        = -.5*(ln(2*_pi)+`ln_sigs2') /*
		*/ -.5*(`ytilde'-`xb'+ $S_COST*`zd')^2 /*
		*/ - ln(norm(`dit')) + ln(norm(`dits')) 

	if `todo' == 0 | `lnf'==. { 
		exit
	}	

	tempvar gj1 gj2 gj3 gj4 ratio1 ratio2 dw1 dditdg dditsdg
	tempname dgt dw2 dditsdxb dditsdzd dditsds 
	tempname d1 d2 d3 d4

	qui gen double `ratio1' = normden(`dit')/(norm(`dit'))
	qui gen double `ratio2' = normden(`dits')/(norm(`dits'))

				/* d(gamma)/d(ivl_gamma) */
	scalar `dgt'= exp(`ivl_gamma')/((1+exp(`ivl_gamma'))^2)

				/* d(dit)/d(ivl_gamma) */
	qui gen double `dditdg' = -.5*`zd'*(`gamma'^(-1.5))*`dgt'
				/* d(dits)/d(xb) */
	scalar `dditsdxb' = $S_COST*sqrt( `gamma'/(1-`gamma') )
				/* d(dits)/d(zd) */
	scalar `dditsdzd' = sqrt( (1-`gamma')/`gamma' )
				/* d(dits)/d(lnsig_s2) */
	qui gen double `dditsds' = .5*`dditsdxb'*`ytilde'

	qui gen double `gj1' = (`ytilde'-`xb'+$S_COST*`zd') /*
		*/ +`ratio2'*`dditsdxb'

	qui gen double `gj2' = -(`ytilde'-`xb'+$S_COST*`zd')*$S_COST /*
		*/ - `ratio1'/sqrt(`gamma') /*
		*/ + `ratio2'*`dditsdzd'

	qui gen double `gj4' = -.5-(`ytilde'-`xb'+$S_COST*`zd') /*
		*/ *(-`ytilde'/2) /*
		*/ + `ratio2'*`dditsds'

				/* d(w1)/d(ivl_gamma); d(w2)/d(ivl_gamma) */
	qui gen double `dw1' = (-`zd'-$S_COST*(`ytilde'-`xb'))*`dgt'
	scalar `dw2' = `w2'*(-0.5/`gamma'+0.5/(1-`gamma'))*`dgt'

					/* d(z2)/d(ivl_gamma) */
	qui gen double `dditsdg' = `w1'*`dw2'+`dw1'*`w2'

	qui gen double `gj3' = -`ratio1'*`dditdg' + `ratio2'*`dditsdg'

	mlvecsum `lnf' `d1' = `gj1', eq(1)
	mlvecsum `lnf' `d2' = `gj2', eq(2)
	mlvecsum `lnf' `d3' = `gj3', eq(3)
	mlvecsum `lnf' `d4' = `gj4', eq(4)
	
	matrix `g' = (`d1',`d2',`d3',`d4')
	
	if `todo' == 1 | `lnf'==. {
		exit
	}

	tempname h11 h12 h13 h14 h22 h23 h24 h33 h34
	tempname h41 h42 h43 h44 d2gdg2

	tempvar dr1 dr2 
	tempvar dWBdg d2w1 d2w2 dWBds

				/* d(gamma)/d(ivl_gamma)d(ivl_gamma) */
	scalar `d2gdg2'= `dgt'*(-expm1(`ivl_gamma'))/(1+exp(`ivl_gamma'))

	qui gen double `dr1' = -`ratio1'*(`ratio1'+`dit')
	qui gen double `dr2' = -`ratio2'*(`ratio2'+`dits')

	qui gen double `d2w1' = `d2gdg2'*(-`zd'-$S_COST*(`ytilde'-`xb'))
	qui gen double `d2w2' = `dw2'*(-0.5/`gamma'+0.5/(1-`gamma'))*`dgt' /*
		*/ + `w2'*(0.5/(`gamma'^2)+0.5/(1-`gamma')^2)*`dgt'*`dgt' /*
		*/ + `w2'*(-0.5/`gamma'+0.5/(1-`gamma'))*`d2gdg2'
				/* WB = d(dits)/d(ivl_gamma) */
	qui gen double `dWBdg' = 2*`dw1'*`dw2' + `w1'*`d2w2' /*
		*/ + `d2w1'*`w2' 

	qui gen double `dWBds' = $S_COST*.5*`gamma'*`ytilde'*`dw2' /*
		*/ + $S_COST*.5*`ytilde'*`dgt'*`w2'

	mlmatsum `lnf' `h11' = (`gamma'/(1-`gamma'))*(`dr2')-1, eq(1,1)
	mlmatsum `lnf' `h12' = $S_COST + `dr2'*$S_COST, eq(1,2)
	mlmatsum `lnf' `h13' = `dr2'*`dditsdg'*`dditsdxb' /*
		*/ + `ratio2'*$S_COST*0.5*(sqrt(`gamma')/(1-`gamma')^(3/2) /*
		*/ + 1/sqrt(`gamma'*(1-`gamma')))*`dgt', eq(1,3)
	mlmatsum `lnf' `h14' = -.5*`ytilde'+`dr2'*`dditsds'*`dditsdxb', eq(1,4)


	mlmatsum `lnf' `h22' = -1 - (1/`gamma')*(`dr1') /*
		*/ + `dditsdzd'^2*(`dr2'), eq(2,2)

	mlmatsum `lnf' `h23' = -`dr1'*`dditdg'*(1/(sqrt(`gamma'))) /*
		*/ - `ratio1'*`dgt'*(-0.5*`gamma'^(-1.5)) /*
		*/ + `dditsdzd'*`dditsdg'*`dr2' /*
		*/ + `ratio2'*`dgt'*(-0.5*sqrt(1-`gamma')/(`gamma'^(3/2)) /*
		*/ - 0.5/sqrt(`gamma'*(1-`gamma'))), eq(2,3)
	
	mlmatsum `lnf' `h24' = .5*`ytilde'*$S_COST  /*
		*/ +`dditsdzd'*`dditsds'*(`dr2'), eq(2,4)

	mlmatsum `lnf' `h33' = -`dditdg'*`dditdg'*(`dr1') /*
		*/ - `ratio1'*(3/4*`zd'/(`gamma'^(5/2))*`dgt'*`dgt' /*
		*/ - 0.5*`zd'/(`gamma'^(3/2))*`d2gdg2' ) /*
		*/ + `dditsdg'*`dditsdg'*(`dr2') /*
		*/ + `ratio2'*`dWBdg', eq(3,3)
	
	mlmatsum `lnf' `h34' = `dr2'*`dditsds'*`dditsdg' +`ratio2'*`dWBds' /*
		*/ , eq(3,4)
				
	mlmatsum `lnf' `h44' = -.25*`ytilde'*`ytilde' /*
		*/ - .25*(`ytilde'-`xb'+$S_COST*`zd')*`ytilde' /*
		*/ + .5*`dr2'*`dditsds'*`dditsdxb'*`ytilde' /*
		*/ - .25*`ratio2'*`dditsdxb'*`ytilde', eq(4,4)


	matrix `negH' = -1*(`h11',`h12', `h13' , `h14' \ /*
		*/ `h12'', `h22', `h23', `h24' \ /*
		*/ `h13'', `h23'', `h33', `h34' \ /*
		*/ `h14'', `h24'', `h34'', `h44' )
end	
