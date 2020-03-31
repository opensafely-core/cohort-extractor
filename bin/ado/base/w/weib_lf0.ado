*! version 1.1.0  18jun2009
program define weib_lf0
	version 6
	args todo b lnf g H g1 g2

	tempvar xb
	tempname lnp p

	local lnt "$S_ML_lnt" /* ln(time)             */
	local d   "$S_ML_d"   /* dead/censor variable */

	mleval `xb'  = `b', eq(1)
	mleval `lnp' = `b', eq(2) scalar
	scalar `p' = exp(`lnp')

	if `todo' == 0 {
		mlsum `lnf' = -exp(`p'*`lnt'+`xb') + `d'*(`lnp'+`p'*`lnt'+`xb')
		exit
	}

	quietly {
		tempvar eplnt
$ML_ec		tempname d1 d2

		gen double `eplnt' = exp(`p'*`lnt'+`xb') if $ML_samp

		mlsum `lnf' = -`eplnt' + `d'*(`lnp'+`p'*`lnt'+`xb')

		replace `g1' = -`eplnt' + `d'
		replace `g2' = `p'*`lnt'*`g1' + `d'

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mat cat `g' = `d1' `d2'

		if `todo' == 1 { exit }

		tempname d11 d12 d22

		mlmatsum `lnf' `d11' = `eplnt', eq(1)
		mlmatsum `lnf' `d12' = `p'*`lnt'*`eplnt', eq(1,2)
		mlmatsum `lnf' `d22' = `p'*`lnt'*((`p'*`lnt'+1)*`eplnt'-`d'), /*
		*/ eq(2)

		mat cat `H' = `d11' `d12' \ `d12'' `d22'
	}
end
