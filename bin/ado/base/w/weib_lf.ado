*! version 7.1.0  18jun2009
program define weib_lf
	version 6
	args todo b lnf g H g1 g2

	tempvar xb
	tempname lnp p

	local lnt  "$S_ML_lnt" /* ln(time)             */
	local d    "$S_ML_d"   /* dead/censor variable */
	local lnt0 "$S_ML_lt0" /* ln(t0) */

	mleval `xb'  = `b', eq(1)
	mleval `lnp' = `b', eq(2) scalar
	scalar `p' = exp(`lnp')

	if `todo' == 0 {
		mlsum `lnf' = cond(`lnt0'!=.,exp(`p'*`lnt0'+`xb'),0) /*
		*/ - exp(`p'*`lnt'+`xb') + `d'*(`lnp'+`p'*`lnt'+`xb')
		exit
	}

	quietly {
		tempvar eplnt eplnt0
$ML_ec		tempname d1 d2

		gen double `eplnt' = exp(`p'*`lnt'+`xb') if $ML_samp
		gen double `eplnt0' = cond(`lnt0'!=.,exp(`p'*`lnt0'+`xb'),0) /*
		*/ if $ML_samp
		local lnt0 "cond(`lnt0'!=.,`lnt0',0)"

		mlsum `lnf' = `eplnt0' - `eplnt' + `d'*(`lnp'+`p'*`lnt'+`xb')

		replace `g1' = `eplnt0' - `eplnt' + `d'
		replace `g2' = `p'*(`lnt0'*`eplnt0' - `lnt'*`eplnt') /*
		*/ + `d'*(`p'*`lnt' + 1)

$ML_ec		mlvecsum `lnf' `d1' = `g1', eq(1)
$ML_ec		mlvecsum `lnf' `d2' = `g2', eq(2)
$ML_ec		mat cat `g' = `d1' `d2'

		if `todo' == 1 { exit }

		tempname d11 d12 d22

		mlmatsum `lnf' `d11' = `eplnt' - `eplnt0', eq(1)
		mlmatsum `lnf' `d12' = `p'*(`lnt'*`eplnt' - `lnt0'*`eplnt0'), /*
		*/ eq(1,2)
		mlmatsum `lnf' `d22' = `p'*(`lnt'*(`p'*`lnt'+1)*`eplnt' /*
		*/ - `lnt0'*(`p'*`lnt0'+1)*`eplnt0' - `d'*`lnt'), eq(2)

		mat cat `H' = `d11' `d12' \ `d12'' `d22'
	}
end
