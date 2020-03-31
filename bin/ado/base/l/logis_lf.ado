*! version 2.2.0  19feb2019
program define logis_lf 
	version 6.0
      args todo baug lnf gr D w1 w2
	quietly {
		local t="$ML_y1"
		local t0="$EREGt0"
		local d="$EREGd"
		tempvar L I et et0
		tempname b1 lng g negb
	 	mleval `I'=`baug',eq(1)     
		mat `negb'=-1*`baug'		
		mleval `lng'=`negb',eq(2)
		/* scalar `g'=exp(`lng') */
		qui gen double `g'=exp(`lng')
		replace `I'=-`I'
		gen double `L' = exp(`I')
		gen double `et' = (`L'*`t')^`g' 
		gen double `et0' = (`L'*`t0')^`g' 
	
		mlsum `lnf' /*
			*/ = `d'*(`I'*`g' +`lng'+(`g'-1)*log(`t')) /*
			*/  -(1+`d')*log1p(`et') + log1p(`et0')
		scalar `lnf'= `lnf' + $EREGa
	
		if `1'==0 {exit}

		/* Gradient Calculation */

		tempvar   C
		tempname g2 dbdlg dlgdlg
		/* dl/db */
		qui replace `w1'=-(`d'*`g'-(1+`d')*`et'*`g'/(1+`et'))
		qui replace `w1'= `w1' -  `et0'*`g'/(1+`et0') if `t0'> 0 
		
$ML_ec		mlvecsum `lnf' `gr' =`w1',eq(1)
	
		/* dl/dlng */

		qui replace    `w2'=-(`d'*(`I'*`g' +1+`g'*log(`t')) /*
			*/ -(1+`d')*`et'*(`I'+log(`t'))*`g'/(1+`et'))
		qui replace `w2' =`w2' - `et0'*(`I'+log(`t0'))*`g'/(1+`et0') /*
			*/ if `t0'> 0

$ML_ec		mlvecsum `lnf' `g2' = `w2',eq(2)

$ML_ec		matrix `gr'=(`gr',`g2')
	
		/* HESSIAN */

		/* d2l/dbdb */
		qui gen double `C'=-(1+`d')*`et'*(`g'^2)/(1+`et')^2 
		qui replace `C'= `C' + `et0'*(`g'^2)/(1+`et0')^2 if `t0'>0


		mlmatsum `lnf' `D' = `C',eq(1)
 
		/* d2l/dbdlg */
		tempvar xblnt xblnt0
		qui gen double `xblnt'=(`I'+log(`t')) 
		qui gen double `xblnt0'=(`I'+log(`t0')) if `t0'>0

		qui replace `C'=`d'*`g' /*
			*/-(1+`d')*`et'*`g'*(`xblnt'*`g'+1+`et')/(1+`et')^2 
		qui replace `C'=`C'+ /*
		       */ `et0'*`g'*(`xblnt0'*`g'+1+`et0')/(1+`et0')^2 if `t0'>0

		mlmatsum `lnf' `dbdlg' =`C' , eq(1,2)
		/* d2l/dlgdlg */
        
		qui replace `C'=`d'*`g'*(`xblnt') /*
			*/ -(1+`d')*`et'*`g'*`xblnt'*  /*
			*/ ((`xblnt'*`g')+1+`et')/(1+`et')^2 
		qui replace `C'=`C'+`et0'*`g'*`xblnt0' /* 
			*/ * (`xblnt0'*`g'+1+`et0')/(1+`et0')^2 if `t0'>0

		mlmatsum `lnf' `dlgdlg'=`C',eq(2)

		matrix `D' = -(`D',`dbdlg' \ `dbdlg'',`dlgdlg')
	}
end
exit
