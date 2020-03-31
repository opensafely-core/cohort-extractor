*! version 1.1.0  12apr2019
program define tnbreg_mean
	version 11.0
	args todo b lnf g H sc1 sc2

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
	tempvar xb
	tempname lnalpha m
	mleval `xb' = `b', eq(1)
	mleval `lnalpha' = `b', eq(2) scalar

	local y "$ML_y1"
	scalar `m' = exp(-`lnalpha')

	if `lnalpha' < -20 {
		mlsum `lnf' = -lngamma(`y'+1) - exp(`xb') 		///
		 	+ `y'*`xb' -ln(poissontail(exp(`xb'),`tp' + 1))
 	}
	else {
		tempvar lnfi
		qui gen double `lnfi' = lngamma(`m'+`y') - lngamma(`y'+1) ///
				- lngamma(`m') - 			///
				`m'*ln1p(exp(`xb'+`lnalpha')) 		///
				- `y'*ln1p(exp(-`xb'-`lnalpha')) 	///
				- ln(nbinomialtail(`m', `tp' + 1, 	///
						1/(1+(exp(`xb'+`lnalpha')))))
		mlsum `lnf' = `lnfi'	

	}
	if (`todo' == 0 | `lnf'>=.)  exit

/* Calculate the scores and gradient. */
	tempname alpha
	tempvar mu p z1
	qui gen double `mu' = exp(`xb') if $ML_samp
	qui gen double `p'  = 1/(1+exp(`xb'+`lnalpha')) if $ML_samp


	tempvar t1 lp0 hp0 lp1 hp1

	tempvar w2 w3 x2 x3

	if `lnalpha'<-20 {
		qui gen double `z1' = exp(-`mu') if $ML_samp
		qui replace `sc1' = `y'-`mu'- `z1'*`mu'/(1-`z1') if $ML_samp
		qui replace `sc2' = 0 if $ML_samp
	}
	else {
		tempvar t1 lp0 hp0 lp1 hp1
		tempvar w2 w3 x2 x3 z2 z3 z4
		tempvar hm lowm lalpha halpha
		/* The following values for h and h2 are used for calculating
		 * numerical derivatives
		*/
		tempname h h2 htemp htemp1
		scalar `h' = epsdouble()^(1/3)
		scalar `htemp' = abs(`lnalpha')
		scalar `h' = `h'*(`htemp'+`h')
		scalar `htemp1' = `htemp'+`h'
		scalar `h' = `htemp1'-`htemp'
		
		qui gen double `lalpha' = `lnalpha' - `h' 		///
				if $ML_samp & `tp'>0
		qui gen double `halpha' = `lnalpha' + `h' 		///
				if $ML_samp & `tp'>0
		qui gen double `lowm'   = exp(-`lalpha')  		///
				if $ML_samp & `tp'>0
		qui gen double `hm'     = exp(-`halpha')  		///
				if $ML_samp & `tp'>0

		qui gen double `t1' = `xb' + `lnalpha'
		scalar `h2' = epsdouble()^(1/3)
		qui sum `xb' if $ML_samp
		scalar `htemp' = abs(r(mean))
		scalar `h2' = `h2'*(`htemp'+`h2')
		scalar `htemp1' = `htemp'+`h2'
		scalar `h2' = `htemp1'-`htemp'


		qui gen double `lp0' = 1/(1+exp(`t1' -`h2') )  		///
				if $ML_samp & `tp'>0
		qui gen double `hp0' = 1/(1+exp(`t1' +`h2') )  		///
				if $ML_samp & `tp'>0
		qui gen double `lp1' = 1/(1+exp(`xb' + `lalpha') ) 	///
				if $ML_samp & `tp'>0
		qui gen double `hp1' = 1/(1+exp(`xb' + `halpha') ) 	///
				if $ML_samp & `tp'>0
		qui gen double `w2' = 					///
			ln(nbinomialtail(`lowm', `tp'+1, `lp1')) 	///
					if $ML_samp & `tp'>0
		qui gen double `w3' = 					///
			ln(nbinomialtail(`hm',   `tp'+1, `hp1')) 	///
					if $ML_samp & `tp'>0

		qui gen double `x2' = 					///
			ln(nbinomialtail(`m', `tp'+1, `lp0'))  	///
					if $ML_samp & `tp'>0
		qui gen double `x3' = 					///
			ln(nbinomialtail(`m', `tp'+1, `hp0')) 	///
				if $ML_samp & `tp'>0

		qui gen double `z2' = cond($ML_samp & `tp'==0,	///
			1- `p'^`m', 					///
			cond($ML_samp & `tp'>0, 			///
			nbinomialtail(`m', `tp' + 1,		///
			1/(1+(exp(`xb'+`lnalpha')))), . ))

		qui gen double `z3' = cond($ML_samp & `tp'==0, 	///
				-`p'^(`m'+1)*`mu'/ `z2',		///
				cond($ML_samp & `tp'>0,		///
				-(`x3'-`x2')/(2*`h2'), .))

		qui gen double `z4' = cond($ML_samp & `tp'==0, 	///
				`p'^`m'*(-`m'^2*ln(`p') - 		///
					`m'*`mu'*`p')/`z2'/ `m', 	///
				cond($ML_samp & `tp'>0,		///
				-(`w3'-`w2')/(2*`h'), .))

		qui replace `sc1' = `p'*(`y'-`mu') + `z3' if $ML_samp
		qui replace `sc2' = `m'*(digamma(`m') - 	///
			digamma(`y'+`m')  - ln(`p')) +  	///
			`p'*(`y'-`mu') + `z4' if $ML_samp
	}

	$ML_ec	tempname g1 g2
	$ML_ec	mlvecsum `lnf' `g1' = `sc1', eq(1)
	$ML_ec	mlvecsum `lnf' `g2' = `sc2', eq(2)
	$ML_ec	matrix `g' = (`g1',`g2')

	if (`todo' == 1 | `lnf'>=. ) exit

/* Calculate negative hessian. */

	tempname alpha d11 d12 d22
	tempvar  z3
	qui gen double `z3'= - `m'^2*ln(`p')-`m'*`mu'*`p' if $ML_samp
	scalar `alpha' = exp(`lnalpha')

	if `lnalpha' < -20 {
		mlmatsum `lnf' `d11' = `mu'- /*
		*/ (`mu'^2* `z1'+ `z1'^2 * `mu'-`z1'*`mu')/((1-`z1')^2) /*
		*/ , eq(1)
		mlmatsum `lnf' `d12' = 0, eq(1,2)
		mlmatsum `lnf' `d22' = 0, eq(2)
	}
	else {
		tempname ha hxb
		scalar `ha' = epsdouble()^(1/4)
		scalar `htemp' = abs(`lnalpha')
		scalar `ha' = `ha'*(`htemp'+`ha')
		scalar `htemp1' = `htemp'+`ha'
		scalar `ha' = `htemp1'-`htemp'

		scalar `hxb' = epsdouble()^(1/4)
		qui sum `xb' if $ML_samp
		scalar `htemp' = abs(r(mean))
		scalar `hxb' = `hxb'*(`htemp'+`hxb')
		scalar `htemp1' = `htemp'+`hxb'
		scalar `hxb' = `htemp1'-`htemp'
		tempvar lnfaPxbP lnfaPxbM lnfaMxbP lnfaMxbM
		qui gen double `lnfaPxbP' = ///
			lngamma(exp(-`lnalpha'-`ha')+`y')-lngamma(`y'+1)- ///
			lngamma(exp(-`lnalpha'-`ha'))-exp(-`lnalpha'-`ha')* ///
			ln1p(exp(`xb'+`hxb'+`lnalpha'+`ha')) ///
			- `y'*ln1p(exp(-`xb'-`hxb'-`lnalpha'-`ha')) 	///
			- ln(nbinomialtail(exp(-`lnalpha'-`ha'), `tp' + 1, ///
				1/(1+(exp(`xb'+`hxb'+`lnalpha'+`ha'))))) ///
			if $ML_samp & `tp' > 0
		qui gen double `lnfaPxbM' = ///
			lngamma(exp(-`lnalpha'-`ha')+`y')-lngamma(`y'+1)- ///
			lngamma(exp(-`lnalpha'-`ha'))-exp(-`lnalpha'-`ha')* ///
			ln1p(exp(`xb'-`hxb'+`lnalpha'+`ha')) ///
			- `y'*ln1p(exp(-`xb'+`hxb'-`lnalpha'-`ha')) 	///
			- ln(nbinomialtail(exp(-`lnalpha'-`ha'), `tp' + 1, ///
				1/(1+(exp(`xb'-`hxb'+`lnalpha'+`ha'))))) ///
			if $ML_samp & `tp' > 0
		qui gen double `lnfaMxbP' = ///
			lngamma(exp(-`lnalpha'+`ha')+`y')-lngamma(`y'+1)- ///
			lngamma(exp(-`lnalpha'+`ha'))-exp(-`lnalpha'+`ha')* ///
			ln1p(exp(`xb'+`hxb'+`lnalpha'-`ha')) ///
			- `y'*ln1p(exp(-`xb'-`hxb'-`lnalpha'+`ha')) 	///
			- ln(nbinomialtail(exp(-`lnalpha'+`ha'), `tp' + 1, ///
				1/(1+(exp(`xb'+`hxb'+`lnalpha'-`ha'))))) ///
			if $ML_samp & `tp' > 0
		qui gen double `lnfaMxbM' = ///
			lngamma(exp(-`lnalpha'+`ha')+`y')-lngamma(`y'+1)- ///
			lngamma(exp(-`lnalpha'+`ha'))-exp(-`lnalpha'+`ha')* ///
			ln1p(exp(`xb'-`hxb'+`lnalpha'-`ha')) ///
			- `y'*ln1p(exp(-`xb'+`hxb'-`lnalpha'+`ha')) 	///
			- ln(nbinomialtail(exp(-`lnalpha'+`ha'), `tp' + 1, ///
				1/(1+(exp(`xb'-`hxb'+`lnalpha'-`ha'))))) ///
			if $ML_samp & `tp' > 0

		tempvar cross
		qui gen double `cross' = -((`lnfaPxbP'-`lnfaPxbM')-	///
			(`lnfaMxbP'-`lnfaMxbM'))/(4*`ha'*`hxb') ///
			if $ML_samp & `tp' > 0
		tempvar lnfaP lnfaM
		qui gen double `lnfaP' = ///
			lngamma(exp(-`lnalpha'-`ha')+`y')-lngamma(`y'+1)- ///
			lngamma(exp(-`lnalpha'-`ha'))-exp(-`lnalpha'-`ha')* ///
			ln1p(exp(`xb'+`lnalpha'+`ha')) ///
			- `y'*ln1p(exp(-`xb'-`lnalpha'-`ha')) 	///
			- ln(nbinomialtail(exp(-`lnalpha'-`ha'), `tp' + 1, ///
				1/(1+(exp(`xb'+`lnalpha'+`ha'))))) ///
			if $ML_samp & `tp' > 0
		qui gen double `lnfaM' = ///
			lngamma(exp(-`lnalpha'+`ha')+`y')-lngamma(`y'+1)- ///
			lngamma(exp(-`lnalpha'+`ha'))-exp(-`lnalpha'+`ha')* ///
			ln1p(exp(`xb'+`lnalpha'-`ha')) ///
			- `y'*ln1p(exp(-`xb'-`lnalpha'+`ha')) 	///
			- ln(nbinomialtail(exp(-`lnalpha'+`ha'), `tp' + 1, ///
				1/(1+(exp(`xb'+`lnalpha'-`ha'))))) ///
			if $ML_samp & `tp' > 0
		tempvar d2a
		qui gen double `d2a' = -(`lnfaP'-2*`lnfi'+`lnfaM')/(	///
			`ha'*`ha') if $ML_samp & `tp' > 0
		tempvar lnfxbP lnfxbM
		qui gen double `lnfxbP' =lngamma(exp(-`lnalpha')+`y') - ///
				lngamma(`y'+1) 				///
				- lngamma(exp(-`lnalpha')) - 		///
				exp(-`lnalpha')*			///
				ln1p(exp(`xb'+`hxb'+`lnalpha')) 	///
				- `y'*ln1p(exp(-`xb'-`hxb'-`lnalpha')) 	///
				- ln(nbinomialtail(exp(-`lnalpha'), 	///
				`tp' + 1, 				///
				1/(1+(exp(`xb'+`hxb'+ `lnalpha'))))) 	///
				if $ML_samp & `tp' > 0
		qui gen double `lnfxbM' =lngamma(exp(-`lnalpha')+`y') -  ///
				lngamma(`y'+1)-lngamma(exp(-`lnalpha'))- ///	
				exp(-`lnalpha')*			 ///
				ln1p(exp(`xb'-`hxb'+`lnalpha')) 	 ///
				- `y'*ln1p(exp(-`xb'+`hxb'-`lnalpha')) 	 ///
			- ln(nbinomialtail(exp(-`lnalpha'), `tp' + 1,    ///
			1/(1+(exp(`xb'-`hxb'+ `lnalpha'))))) 		 ///
			if $ML_samp & `tp' > 0
		tempvar d2xb
		qui gen double `d2xb' = 				///
			-(`lnfxbP'-2*`lnfi'+`lnfxbM')/(`hxb'*`hxb') 	///
			if $ML_samp & `tp' > 0

		mlmatsum `lnf' `d11' = cond(`tp'== 0, /*
			*/ `mu'*`p'*(`alpha'*`p'*(`y'-`mu')+1)- /*
			*/ `p'^(`m'+2)*(`mu'^2-`mu')/(`z2'^2) - /*
			*/ `p'^(2*(`m'+1))*`mu'/(`z2'^2), `d2xb') ///
			, eq(1)
		mlmatsum `lnf' `d12' = cond(`tp'==0, /*
			*/ `alpha'*`mu'*`p'^2*(`y'-`mu')-/*
			*/ `p'^(`m'+1)*(-`mu'*`z3'/`m'+`mu'-`mu'*`p') /*
			*/ /(`z2'^2) + `p'^(2*`m'+1)*(`mu'-`mu'*`p') /*
			*/ /(`z2'^2), `cross'), eq(1,2)
		mlmatsum `lnf' `d22' = cond(`tp'==0, /*
			*/ `m'*(digamma(`m') - digamma(`y'+`m') /*
			*/ - ln(`p') /*
			*/ - `m'*(trigamma(`y'+`m') - trigamma(`m'))) /*
			*/ + `mu'*`p'*(`alpha'*`p'*(`y'-`mu')- 1)- /*
			*/ `p'^`m'*(`z3'^2/`m' - `z3'+(`mu'*`p')^2) /*
			*/ /`m'/(`z2'^2) +`p'^(2*`m')*(-`z3'+ /*
			*/ (`mu'*`p')^2)/`m'/(`z2'^2),`d2a')  , eq(2)
	}
	matrix `H' = (`d11',`d12' \ `d12'',`d22')
end

