*! version 1.0.1  26apr2017
program tpoiss_ul_d2
	args todo b lnf g negH score
	version 11.0
	local ll $ZTP_tp_
	local ul $ZTP_ul_tp_
	local y $ML_y1
							// log-likelihood
	tempvar xb mu PrB
	mleval `xb' = `b'
	qui gen double `mu' = exp(`xb') 
	if (`"`ll'"' != "") {
		qui gen double  `PrB'= 		///
			poissontail(`mu', `ll'+1)-poissontail(`mu',`ul') 
	}
	else {
		qui gen double  `PrB'= 	1-poissontail(`mu',`ul') 
	}
	mlsum `lnf' = -`mu'+`y'*`xb'-lngamma(`y'+1)-ln(`PrB')
							// scores and gradient
	if (`todo' == 0 | `lnf' >=.) exit	
	tempvar dL_dmu dPrB_dmu p_ll p_ul1
	
	if (`"`ll'"' != "") {
		qui gen double `p_ll' = poissonp(`mu',`ll')
	}
	else {
		qui gen double `p_ll' = 0
	}
	qui gen double `p_ul1' = poissonp(`mu', `ul'-1)
	qui replace `p_ul1' = 0 if (`ul'-1<0)

	qui gen double `dPrB_dmu' =  `p_ll'- `p_ul1'
	qui gen double `dL_dmu'   =  -1+`y'/`mu'-`dPrB_dmu'/`PrB' 
	qui replace `score' = `dL_dmu'*`mu' if $ML_samp
	$ML_ec mlvecsum `lnf' `g' = `score' 
							// negH 
	if (`todo' == 1 | `lnf' >=.) exit
	tempvar dPrB_dmu2 dL_dmu2 p_ll1 p_ul2 

	if (`"`ll'"' != "") {
		qui gen double `p_ll1' =  poissonp(`mu', `ll'-1)
		qui replace `p_ll1' = 0 if (`ll'-1<0)
	}
	else {
		qui gen double `p_ll1' =  0
	}
	qui gen double `p_ul2' = poissonp(`mu', `ul'-2)
	qui replace `p_ul2' = 0 if (`ul'-2<0)
	
	qui gen double `dPrB_dmu2' = `p_ll1'-`p_ll'-`p_ul2'+`p_ul1'
	qui gen double `dL_dmu2'   = 				///
		-`y'/`mu'^2+(`dPrB_dmu'/`PrB')^2-`dPrB_dmu2'/`PrB'
	mlmatsum `lnf' `negH' = -(`score'+`dL_dmu2'*`mu'^2) 
end
