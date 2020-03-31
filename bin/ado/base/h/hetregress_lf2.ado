*! version 1.0.0  12apr2016
program hetregress_lf2
	
	version 15
	args todo b lnfj g1 g2 H
	tempvar mu lnsigma2 sigma
	mleval `mu' = `b', eq(1)
	mleval `lnsigma2' = `b', eq(2)
	quietly {
		gen double `sigma' = exp(1/2 *`lnsigma2')
		replace `lnfj' = ln(normalden($ML_y1, `mu', `sigma'))
		if (`todo'==0) exit
		
		tempvar z
		gen double `z' = ($ML_y1 - `mu')/`sigma'
		replace `g1' = `z'/`sigma'
		replace `g2' = 1/2 *(`z'*`z'-1) 
		if (`todo'==1) exit

		tempname d11 d12 d22
		mlmatsum `lnfj' `d11' = -1/(`sigma'^2) , eq(1)
		mlmatsum `lnfj' `d12' = -`z'/`sigma' , eq(1,2)
		mlmatsum `lnfj' `d22' = -1/2*`z'*`z' , eq(2)
		matrix `H' = (`d11', `d12' \ `d12'', `d22')	
	}
end
