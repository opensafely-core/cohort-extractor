*! version 2.3.0  14nov2013
program define gomp_lf 
	version 6.0
	args todo  baug  lnf gr D  A  B 
	quietly {
		tempvar  g  
		mleval `g'=`baug',eq(2)
		qui cap assert `g'==0
		if _rc==0 {
			gamma2 `todo' `baug' `lnf' `gr' `D' `A' `B' `g'
			exit
		} 
		replace `g'=cond(`g'<0, `g'- 0.000001, `g'+ 0.000001) /*
			*/ if abs(`g')<0.000001
		gamma1 `todo' `baug' `lnf' `gr' `D' `A' `B' `g'
	}
end

program define gamma1
	version 6.0
	args todo  baug  lnf gr D  A  B g 
	local t = "$ML_y1"
	local t0 = "$EREGt0"
	local d = "$EREGd"
        tempvar L I  et et0
	mleval `I'=`baug', eq(1)
	gen double `L' = exp(`I')
        gen double `et' = exp(`g'*`t')
        gen double `et0' = exp(`g'*$EREGt0)

	mlsum  `lnf' = ($EREGd*( `I' + `g'*`t') /*
			*/  -(`L'/`g')*(`et' - `et0'))
	scalar `lnf'=`lnf' + $EREGa
		
	/* Gradient */
	tempname g2   dbdg dgdg

	replace `A'=($EREGd-(`L'/`g')*(`et' - `et0') )

$ML_ec	mlvecsum `lnf' `gr' = `A' , eq(1)   /* gr = dL/db */

	replace    `B'=$EREGd*`t'+ (`L'/(`g'^2))*(`et'-`et0')
	replace `B' = `B' - (`L'/`g')*((`et'*`t')-(`et0'*$EREGt0))
$ML_ec	mlvecsum `lnf' `g2' = `B' , eq(2)   /* gr = dL/dg */
$ML_ec	matrix `gr' = (`gr',`g2')

	/* Hessian */
	tempvar  C
	gen double  `C'=((-`L'/`g')*(`et'-`et0'))     /* dbdb */
	mlmatsum `lnf' `D' = `C', eq(1)                 /*  d2L/dbdb */

	replace `C' = ( (`L'/`g')*(`et'*((1/`g')-`t') /*
		*/ -`et0'*((1/`g')-$EREGt0)))      /* dbdg */

	mlmatsum `lnf'  `dbdg' = `C' ,eq(1,2)           /* d2L/dbdg */

	replace `C' = (2/(`g'^3))*(`et0'-`et')
	replace `C' = `C'+(2/(`g'^2))*(`et'*(`t')-`et0'*($EREGt0))
	replace `C' = `C'-(1/`g')*(`et'*(`t'^2)-`et0'*($EREGt0^2))
	replace `C' = `L'*`C'                    /* dgdg */

	mlmatsum `lnf'  `dgdg' = `C' ,eq(2)           /* d2L/dgdg */
	matrix `D' = -(`D',`dbdg' \ `dbdg'',`dgdg')

end    /* END OF GAMMA ~= 0 */

program define gamma2   /* FOR GAMMA=0 */
	version 6.0
	args todo  baug  lnf gr D  A  B 

	local t = "$ML_y1"
	local t0 = "$EREGt0"
	local d = "$EREGd"
	tempvar L I  
	tempname  g
	mleval `I'=`baug', eq(1)
	gen double `L' = exp(`I')

		
	mlsum `lnf' =($EREGd*`I' -`L'*(`t'-$EREGt0))
	scalar `lnf'=`lnf' + $EREGa
		
	/* Gradient */
	tempname g2  dbdg dgdg

	replace `A'=($EREGd-`L'*(`t'-$EREGt0)) 
$ML_ec	mlvecsum `lnf' `gr' = `A' , eq(1)   /* gr = dL/db */


	replace `B'=$EREGd*`t'-(1/2)*`L'*((`t'^2)-($EREGt0^2))
$ML_ec	mlvecsum `lnf' `g2' = `B' , eq(2)   /* gr = dL/dg */

$ML_ec	matrix `gr' = (`gr',`g2')
		

	/* Hessian */
	tempvar  C
	gen double  `C'=(-`L')*(`t'-$EREGt0)      /* dbdb */
	mlmatsum `lnf' `D' = `C', eq(1)                 /*  d2L/dbdb */

	replace `C'=(-1/2)*`L'*((`t'^2)-($EREGt0^2)) /* dbdg */
	mlmatsum `lnf'  `dbdg' = `C' ,eq(1,2)           /* d2L/dbdg */

	replace `C'=(-1/3)*`L'*((`t'^3)-($EREGt0^3)) /* dgdg */

	mlmatsum `lnf'  `dgdg' = `C' ,eq(2)           /* d2L/dgdg */
	matrix `D' = (`D',`dbdg' \ `dbdg'',`dgdg')
	matrix `D' = `D' * -1    

end	/* END OF GAMMA ==0   */ 
exit
