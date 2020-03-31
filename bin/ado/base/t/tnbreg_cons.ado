*! version 1.1.0  12apr2019
/* updates file trnb_cons.ado */
program define tnbreg_cons
	version 11.0
	args todo b lnf g H g1 g2

	local tp $ZTNB_tp_
	if "`tp'" == "" {
		local ll `e(llopt)'
		local tp = 0
		if ("`ll'" != ""){
			cap confirm names `ll'
			if _rc {
			/* it is not a name, should be a number */
				cap confirm number `ll'
				if _rc{
					di as error
					"{cmd:ll(`ll')} must specify " ///
					"a nonnegative value"
					exit 200
				}
				else{
					local tp = `ll'
					capture noisily
				}
			}
			else{
			/* ll() does not contain a number */
				cap confirm variable `ll'
				if _rc!=0 {
				/* ll() contains a name that is not a */
				/* variable.  possibly it is a scalar */
					local tp = `ll'
					cap confirm number `tp'
					if _rc!=0{
						di as error ///
						"{cmd:ll(`ll')} must " ///
						"specify a nonnegative value"
						exit 200
					}
				}
				else {
				/* ll() contains the name of a variable */
					qui summarize `ll'
					if r(min) < 0 {
						di as error ///
						"{cmd:ll(`ll')} must  " ///
						" contain all " ///
						"nonnegative values"
							exit 200
					}
					tempvar tp
					gen double `tp' = `ll'
				}
			}
		}

	}
/* Calculate the log-likelihood. */
	tempvar m
	tempname lndelta delta lnoned

	mleval `m' = `b', eq(1)
	mleval `lndelta' = `b', eq(2) scalar

	scalar `delta' = exp(`lndelta')
	/* lnoned = -ln(p) */

	tempvar m1
	qui gen double `m1' = `m'

	tempvar xb mu
	qui gen double `xb' = `m' if $ML_samp
	qui gen double `mu' = exp(`xb') if $ML_samp
	/* m = mu(j)/delta */
	qui replace `m' = exp(`m'-`lndelta')  if $ML_samp

	local y "$ML_y1"

	if `lndelta' < -20 {
		mlsum `lnf' = -lngamma(`y'+1) - `mu' /*
		*/	+`y'*`xb'-ln1m(exp(-exp(`xb')))
	}
	else {
	    tempvar lnfi
	    qui gen double `lnfi'=lngamma(`y'+exp(`xb'-`lndelta')) 	///
		 -lngamma(`y'+1)-lngamma(exp(`xb'-`lndelta')) 		///
		+ `lndelta'*`y' - (`y'+exp(`xb'-`lndelta'))*		///
		ln1p(exp(`lndelta')) 					///
		- ln(nbinomialtail(exp(`xb'-`lndelta'), 		///
		`tp'+1, 1/(1+exp(`lndelta'))))
	    mlsum `lnf' = `lnfi'
	}

	if (`todo' == 0 | `lnf'>=.)  exit

/* Calculate the scores and gradient. */
	tempvar z1 z2 z3 f1 f2 w1 x1

	if `lndelta' < -20 {
		qui gen double `z1'= exp(-`mu') if $ML_samp
		qui replace `g1' = `y' - `mu'- `z1'*`mu'/(1-`z1') if $ML_samp
		qui replace `g2' = 0 if $ML_samp
	}
	else{

		qui gen double `z2'= `m'*(digamma(`y'+`m') - 		///
			digamma(`m') - ln1p(exp(`lndelta'))) if $ML_samp

		qui gen double `z3' = cond($ML_samp&`tp'==0, 	///
			1-(1+`delta')^(-`m'), 			///
			cond($ML_samp&`tp'>0,			///
			nbinomialtail(`m', `tp'+1, 1/(1+exp(`lndelta'))),.))

		qui gen double `f1' = `m'*(digamma(`y'+`m') - 		///
			digamma(`m') -  ln1p(exp(`lndelta'))) if $ML_samp
		qui gen double `f2' = `y' -(`y'+`m')*`delta'/ 		///
			(1+exp(`lndelta')) - `z2' if $ML_samp

		tempvar hm lowm
		tempname h htemp
		tempname h1 h2 htemp1
		scalar `h1' = epsdouble()^(1/3)
		qui sum `m1' if $ML_samp
		scalar `htemp' = abs(r(mean))
		scalar `h1' = `h1'*(`htemp'+`h1')
		scalar `htemp1' = `htemp'+`h1'
		scalar `h1' = `htemp1'-`htemp'
		scalar `h2' = epsdouble()^(1/3)
		scalar `htemp' = abs(`lndelta')
		scalar `h2' = `h2'*(`htemp'+`h2')
		scalar `htemp1' = `htemp'+`h2'
		scalar `h2' = `htemp1'-`htemp'		

		qui gen double `lowm' = `m1' - `h1' if $ML_samp & `tp'>0
		qui gen double `hm'   = `m1' + `h1' if $ML_samp & `tp'>0
		tempvar lxb lmu hxb hmu
		qui replace  `lowm' = exp(`lowm' - `lndelta') ///
			if $ML_samp & `tp'>0
		qui replace  `hm'   = exp(`hm'   - `lndelta') ///
			if $ML_samp & `tp'>0

		tempvar w2 w3 x2 x3
		qui gen double `w2' = ///
			ln(nbinomialtail(`lowm', `tp'+1, ///
				1/(1+exp(`lndelta'))) ) ///
				if $ML_samp & `tp'>0
		qui gen double `w3' = ///
			ln(nbinomialtail(`hm', `tp'+1, ///
			1/(1+exp(`lndelta'))) ) if $ML_samp & `tp'>0

		tempname ldelta hd
		scalar `ldelta' = exp(`lndelta' - `h2')
		scalar `hd' = exp(`lndelta' + `h2')
		qui replace `lowm' = exp(`m1' - (`lndelta' - `h2')) ///
			if $ML_samp & `tp'>0
		qui replace `hm'   = exp(`m1' - (`lndelta' + `h2')) ///
			if $ML_samp & `tp'>0
		qui gen double `x2' = 				///
			ln(nbinomialtail(`lowm', `tp'+1,	///
			1/(1+`ldelta')) ) if $ML_samp & `tp'>0
		qui gen double `x3' = 			///
			ln(nbinomialtail(`hm', `tp'+1, 	///
			1/(1+`hd')) ) if $ML_samp & `tp'>0
		qui gen double `w1' = cond($ML_samp & `tp'>0, 		///
			-(`w3'-`w2')/(2*`h1'),				///
			cond($ML_samp & `tp'==0,			///
			-(1+`delta')^(-`m')* ln1p(exp(`lndelta'))*`m'/`z3',.))

		qui gen double `x1' = cond($ML_samp & `tp'>0, 		///
			-(`x3'-`x2')/(2*`h2'),				///
			cond($ML_samp & `tp'==0,			///
			(1+ exp(`lndelta'))^(-`m')*(`m'*ln1p(`delta') 	///
			-`mu'/(1+exp(`lndelta')) ) / `z3',.))

		qui replace `g1' = `f1'+`w1' if $ML_samp
		qui replace `g2' = `f2'+`x1' if $ML_samp
	}
	$ML_ec	tempname d1 d2
	$ML_ec	mlvecsum `lnf' `d1' = `g1', eq(1)
	$ML_ec	mlvecsum `lnf' `d2' = `g2', eq(2)
	$ML_ec	matrix `g' = (`d1',`d2')
	if (`todo' == 1 | `lnf'>=.)  exit
	/* Calculate negative hessian. */
	tempname d11 d12 d22
	tempvar dd
	tempvar z4 z5

	qui gen double `z4'=(1+`delta')^(-`m')*	///
		ln1p(exp(`lndelta'))*(-`m') if $ML_samp
	qui gen double `z5'=(1+`delta')^(-`m')*(	///
		-ln1p(exp(`lndelta'))*(`m')		///
		+`mu'/(1+exp(`lndelta'))) if $ML_samp

	if `lndelta' < -20 {"
		mlmatsum `lnf' `d11' = `mu'- 				///
			(`mu'^2* `z1'+ `z1'^2 * `mu'-`z1'*`mu')/	///
			((1-`z1')^2) , eq(1)
		mlmatsum `lnf' `d12' = 0, eq(1,2)
		mlmatsum `lnf' `d22' = 0, eq(2)
	}
	else {

		tempvar hdelta hxb
		scalar `hdelta' = epsdouble()^(1/4)
		scalar `htemp' = abs(`lndelta')
		scalar `hdelta' = `hdelta'*(`htemp'+`hdelta')
		scalar `htemp1' = `htemp'+`hdelta'
		scalar `hd' = `htemp1'-`htemp'

		scalar `h' = epsdouble()^(1/4)
		qui sum `xb' if $ML_samp
		scalar `htemp' = abs(r(mean))
		scalar `h' = `h'*(`htemp'+`h')
		scalar `htemp1' = `htemp'+`h'
		scalar `hxb' = `htemp1'-`htemp'		

		tempvar lnfdPxbP lnfdPxbM lnfdMxbP lnfdMxbM
		qui gen double `lnfdPxbP'=				///
			lngamma(`y'+exp(`xb'+`hxb'-`lndelta'-`hdelta')) ///
			 -lngamma(`y'+1)-lngamma(exp(			///
			`xb'+`hxb'-`lndelta'-`hdelta')) 		///
			+ (`lndelta'+`hdelta')*`y' - 			///
			(`y'+exp(`xb'+`hxb'-`lndelta'-`hdelta'))*	///
			ln1p(exp(`lndelta'+`hdelta')) 			///
			- ln(nbinomialtail(exp(				///
			`xb'+`hxb'-`lndelta'-`hdelta'), `tp'+1, 	///	
			1/(1+exp(`lndelta'+`hdelta'))))
		qui gen double `lnfdPxbM'=lngamma(`y'+exp(		///
			`xb'-`hxb'-`lndelta'-`hdelta')) 		///
			 -lngamma(`y'+1)-lngamma(exp(			///
			`xb'-`hxb'-`lndelta'-`hdelta')) 		///
			+ (`lndelta'+`hdelta')*`y'-(			///
			`y'+exp(`xb'-`hxb'-`lndelta'-`hdelta'))*	///
			ln1p(exp(`lndelta'+`hdelta')) 			///
			- ln(nbinomialtail(exp(				///
			`xb'-`hxb'-`lndelta'-`hdelta'), `tp'+1, 	///	
			1/(1+exp(`lndelta'+`hdelta'))))
		qui gen double `lnfdMxbP'=lngamma(`y'+exp(	///
			`xb'+`hxb'-`lndelta'+`hdelta')) 	///
			 -lngamma(`y'+1)-lngamma(exp(		///
			`xb'+`hxb'-`lndelta'+`hdelta')) 	///
			+ (`lndelta'-`hdelta')*`y' - (		///
			`y'+exp(`xb'+`hxb'-			///
			`lndelta'+`hdelta'))*			///
			ln1p(exp(`lndelta'-`hdelta')) 		///
			- ln(nbinomialtail(exp(			///	
			`xb'+`hxb'-`lndelta'+`hdelta'), `tp'+1, ///	
			1/(1+exp(`lndelta'-`hdelta'))))
		qui gen double `lnfdMxbM'=lngamma(`y'+exp(	///
			`xb'-`hxb'-`lndelta'+`hdelta')) 	///
			 -lngamma(`y'+1)-lngamma(exp(		///
			`xb'-`hxb'-`lndelta'+`hdelta')) 	///
			+ (`lndelta'-`hdelta')*`y' - (		///
			`y'+exp(`xb'-`hxb'-			///
			`lndelta'+`hdelta'))*			///
			ln1p(exp(`lndelta'-`hdelta')) 		///
			- ln(nbinomialtail(exp(			///
			`xb'-`hxb'-`lndelta'+`hdelta'), `tp'+1, ///	
			1/(1+exp(`lndelta'-`hdelta'))))
		tempvar cross
		qui gen double `cross' = -((`lnfdPxbP'-`lnfdPxbM')-	///
			(`lnfdMxbP'-`lnfdMxbM'))/(4*`hdelta'*`hxb') ///
			if $ML_samp & `tp' > 0
		tempvar lnfdP lnfdM
		qui gen double `lnfdP'=lngamma(			///
			`y'+exp(`xb'-`lndelta'-`hdelta')) 	///
			 -lngamma(`y'+1)-lngamma(exp(		///
			`xb'-`lndelta'-`hdelta')) 		///
			+ (`lndelta'+`hdelta')*`y' - (		///
			`y'+exp(`xb'-`lndelta'-`hdelta'))*	///
			ln1p(exp(`lndelta'+`hdelta')) 		///
			- ln(nbinomialtail(exp(			///
			`xb'-`lndelta'-`hdelta'), `tp'+1, 	///	
			1/(1+exp(`lndelta'+`hdelta'))))
		qui gen double `lnfdM'=lngamma(`y'+exp(		///
			`xb'-`lndelta'+`hdelta')) 		///
			 -lngamma(`y'+1)-lngamma(exp(		///
			`xb'-`lndelta'+`hdelta')) 		///
			+ (`lndelta'-`hdelta')*`y' - (		///
			`y'+exp(`xb'-`lndelta'+`hdelta'))*	///
			ln1p(exp(`lndelta'-`hdelta')) 		///
			- ln(nbinomialtail(exp(			///
			`xb'-`lndelta'+`hdelta'), `tp'+1, 	///	
			1/(1+exp(`lndelta'-`hdelta'))))
		tempvar d2d
		qui gen double `d2d' = -(`lnfdP'-2*`lnfi'+`lnfdM')/(	///
			`hdelta'*`hdelta') ///
			if $ML_samp & `tp' > 0
		tempvar lnfxbP lnfxbM
		qui gen double `lnfxbP'=lngamma(`y'+exp(	///
			`xb'+`hxb'-`lndelta')) 			///
			 -lngamma(`y'+1)-lngamma(exp(		///
			`xb'+`hxb'-`lndelta')) 			///
			+ (`lndelta')*`y'-(`y'+exp(		///
			`xb'+`hxb'-`lndelta'))*  		/// 
			ln1p(exp(`lndelta')) 			///
			- ln(nbinomialtail(exp(			///
			`xb'+`hxb'-`lndelta'), `tp'+1, 		///	
			1/(1+exp(`lndelta'))))
		qui gen double `lnfxbM'=lngamma(`y'+exp(	///	
			`xb'-`hxb'-`lndelta')) 			///
			 -lngamma(`y'+1)-lngamma(exp(		///
			`xb'-`hxb'-`lndelta')) 			///
			+ (`lndelta')*`y'-(`y'+exp(		///
			`xb'-`hxb'-`lndelta'))*			///
			ln1p(exp(`lndelta')) 			///
			- ln(nbinomialtail(exp(			///
			`xb'-`hxb'-`lndelta'), `tp'+1, 		///	
			1/(1+exp(`lndelta'))))
		tempvar d2xb
		qui gen double `d2xb' = -(`lnfxbP'-2*`lnfi'+	///
			`lnfxbM')/(`hxb'*`hxb') 		///
			if $ML_samp & `tp' > 0
		qui gen double `dd' = -`m'*(digamma(`y'+`m') - 	///	
			digamma(`m') - ln1p(exp(`lndelta')) + 	///
			`m'*(trigamma(`y'+`m') - trigamma(`m'))) if $ML_samp

		mlmatsum `lnf' `d11' = cond(`tp'==0,`dd'+ 	 	///
			(`z4'*(ln1p(exp(`lndelta'))*`m'-1)*`z3'- 	///
			(`z4')^2)/(`z3')^2, `d2xb'), eq(1)

		mlmatsum `lnf' `d12' = cond(`tp'==0,		///
			`m'*`delta'/(1+`delta') - `dd' 		///
			-((1-`z3')*(ln1p(			///
			exp(`lndelta'))*`m'-`mu'/(1+`delta'))* 	///
			(-ln1p(exp(`lndelta'))*`m'+1)*`z3'+ 	///
			`z4'*(1-`z3')*(`m'*ln1p(exp(`lndelta'))	///
			-`mu'/(1+`delta')))/(`z3')^2,`cross'), eq(1,2)

		mlmatsum `lnf' `d22' = cond(`tp'==0,`delta'*(	///
			`y'-`m'*(1+2*`delta'))/(1+`delta')^2 	///
			+ `dd'- ((1-`z3')*((-`mu'/(1+`delta')+	///
			`m'*ln1p(exp(`lndelta')))^2+		///
			`mu'*`delta'/((1+`delta')^2)-`m'*ln1p(	///
			exp(`lndelta'))+`mu'/(1+`delta'))*`z3'+ ///
			`z5'^2)/(`z3')^2, `d2d'), eq(2)
	}
	matrix `H' = (`d11',`d12' \ `d12'',`d22')
end

