*! version 7.1.0  18jun2009
program define weib1_lf               /* Hazard metric */
	version 6
	args todo b lnf g H g1 g2

	tempvar xb p lnt lnt0 nxb
	tempname lnp 

	local t = "$EREGt"
	local t0 = "$EREGt0"
	local d = "$EREGd"
	qui gen double `lnt'=ln(`t') 
	qui gen double `lnt0'=ln(`t0') 

	mleval `xb'  = `b', eq(1)
	mleval `lnp' = `b', eq(2) 
	qui gen double `p' = exp(`lnp') if $ML_samp
	qui gen double `nxb'= -`xb'*`p'
	tempvar eplnt eplnt0
	qui gen double `eplnt' = exp(`p'*`lnt'+`nxb') if $ML_samp
	qui gen double `eplnt0' = cond(`lnt0'!=.,exp(`p'*`lnt0'+`nxb'),0) 

	if `todo' == 0 {
		mlsum `lnf' = `eplnt0'-`eplnt'+`d'*(`lnp'+`p'*`lnt'+`nxb'-`lnt')
		scalar `lnf'=`lnf'+$EREGa
		exit
	}
	quietly {
$ML_ec		tempname d1 d2

		*/ if $ML_samp
		local lnt0 "cond(`lnt0'!=.,`lnt0',0)"

		mlsum `lnf' = `eplnt0'-`eplnt'+`d'*(`lnp'+`p'*`lnt'+`nxb'-`lnt')
		scalar `lnf'=`lnf'+$EREGa

		replace `g1' = `p'*(`eplnt' - `eplnt0' - `d')
		replace `g2' = /*
		*/ `p'*(((`xb'-`lnt')*`eplnt' - (`xb'-`lnt0')*`eplnt0') /*
		*/ + `d'*((`lnt'-`xb' + 1/`p')))

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mat cat `g' = `d1' `d2'

		if `todo' == 1 { exit }

		tempname d11 d12 d22

		mlmatsum `lnf' `d11' = -`p'*`p'*(`eplnt0' - `eplnt'), eq(1)
		mlmatsum `lnf' `d12' = -`p'*((-`xb'*`p'+`p'*`lnt'+1)*`eplnt' /*
			*/ -(-`xb'*`p'+`p'*`lnt0'+1)*`eplnt0'-`d'), eq(1,2)
		mlmatsum `lnf' `d22' = /*
		*/ -`p'*`p'*((-2*`xb'*`lnt0'+(`lnt0'^2)+(`xb'^2))*`eplnt0' /*
			*/ +(2*`xb'*`lnt'-(`lnt'^2)-(`xb'^2))*`eplnt' /*
			*/  - `d'/(`p'*`p')), eq(2)

		mat cat `H' = `d11' `d12' \ `d12'' `d22'
	}
end
