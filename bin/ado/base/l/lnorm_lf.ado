*! version 1.1.0  18jun2009
program define lnorm_lf 
	version 6.0
	args todo  b  lnf g H  w1 w2

	quietly {
        	local t = "$ML_y1"       
       		local t0 = "$EREGt0"
        	local d = "$EREGd"        
		tempname s es e2s
	        tempvar I lntxb lntxb0 et et0 es es2
		mleval `I'=`b', eq(1)
     		mleval `s'=`b', eq(2) 
		qui gen double `es' = exp(`s') 
		qui gen double `e2s' = exp(2*`s')

	        gen double `lntxb'=(ln(`t')-`I')/`es'
	        gen double `lntxb0'=(ln(`t0')-`I')/`es' if `t0'>0 

	        gen double `et'= normprob(-`lntxb')
	        gen double `et0'=cond(`t0'==0, 0, normprob(-`lntxb0'))


		mlsum `lnf' = `d'*(-0.5*ln(2*_pi)-ln(`t')-`s' /*
			*/ -((`lntxb'^2)/2) - ln(`et')) + ln(`et') /*
			*/ - cond(`t0'>0, ln(`et0'), 0)
		scalar `lnf'=`lnf'+$EREGa

		if `todo'==0 { exit }
		
		/* GRADIENT VECTOR */

		tempvar d1 d2 net net0 R R0
	        gen double `net'= normd(`lntxb')
	        gen double `net0'=normd(`lntxb0') if `t0'>0
	        gen double `R'=`net'/`et'
	        gen double `R0'=`net0'/`et0'

		/* dl/db */
                qui replace `w1'=`d'*( (1/`es')*`lntxb' - `R'/`es') /*
			*/ + `R'/`es' - cond(`t0'>0, `R0'/`es', 0)
$ML_ec		mlvecsum `lnf' `d1' = `w1', eq(1)
		
		/* dl/ds */
                qui replace `w2' = `d'*(-1+(`lntxb'*`lntxb') /*
			*/ -`R'*`lntxb')+ `R'*`lntxb' /*
			*/ - cond(`t0'>0, `R0'*`lntxb0', 0)
$ML_ec		mlvecsum `lnf' `d2' = `w2', eq(2)
$ML_ec		matrix `g'=(`d1',`d2')

		if `todo'==1 { exit }
		
		/* HESSIAN MATRIX */

		tempvar f d11 d12 d22 

		/* dl/dbdb  */	
		gen double `f'=`d'*( (-1/`e2s') /* 
			*/ -(1/`e2s')*((`lntxb')*`net'*`et' /*
			*/ -`net'*`net' )/(`et'*`et')   ) /*	
			*/ +(1/`e2s')*((`lntxb')*`net'*`et' /*
			*/ -`net'*`net' )/(`et'*`et')	
	        replace `f'=`f'/*
			*/ -(1/`e2s')*(`lntxb0'*`net0'*`et0' /*
			*/ -`net0'*`net0' )/(`et0'*`et0') if `t0'>0	
		
		mlmatsum `lnf' `d11'=-`f', eq(1)

		/* dl/dbds  */	
		replace `f'=`d'*((-2/`es')*`lntxb' /*
			*/ -(1/`es')* ( -`R'+ ((`lntxb'^2)*`net'*`et' /*
	       		*/ -`net'*`net'*`lntxb')/(`et'*`et'))   ) /*
			*/ +(1/`es')* ( -`R'+ ((`lntxb'^2)*`net'*`et' /*
               		*/ -`net'*`net'*`lntxb')/(`et'*`et')) 

 	        replace `f'=`f'-(1/`es')* ( -`R0'+ /*
			*/ ((`lntxb0'^2)*`net0'*`et0' /*
                	*/ -`net0'*`net0'*`lntxb0')/(`et0'*`et0')) /*
			*/ if `t0'>0
		
		mlmatsum `lnf' `d12'= -`f', eq(1,2)
		
		/* dl/dsds  */	
			replace `f'=`d'*( -2*(`lntxb'^2) /* 
			*/ -`lntxb'*( ( (`lntxb'^2)*`net'*`et' /*
			*/ -`net'*`net'*`lntxb') /(`et'*`et'))  /* 
			*/ +`lntxb'*`R'   )  /*
		 	*/ +`lntxb'*(( (`lntxb'^2)*`net'*`et' /*
                	*/ -`net'*`net'*`lntxb')/(`et'*`et'))  /*  
                	*/ -`lntxb'*`R'   
 	        replace `f'=`f' /* 
		*/ -`lntxb0'*(((`lntxb0'^2)*`net0'*`et0' /*
		*/ -`net0'*`net0'*`lntxb0') /(`et0'*`et0'))  /*
		*/ +`lntxb0'*`R0' if `t0'>0
		
		mlmatsum `lnf' `d22'= -`f', eq(2)
		matrix `H'=(`d11',`d12' \ `d12'',`d22')
	}
end
exit
