*! version 3.3.0  29jun2009
program define ml_elf
	version 8.0
	args calltype dottype
	// no need to check memory requirements
	if (`calltype' == -1) exit

	local i 1
	while `i' <= $ML_n {
		tempname x`i'
		qui mat score double `x`i'' = $ML_b if $ML_samp, eq(#`i')
		if "${ML_xo`i'}${ML_xe`i'}" != "" {
			if "${ML_xo`i'}" != "" {
				qui replace `x`i'' = `x`i'' + ${ML_xo`i'}
			}
			else 	qui replace `x`i'' = `x`i'' + ln(${ML_xe`i'})
		}
		local list `list' `x`i''
		local i = `i' + 1
	}

	tempvar f
	qui gen double `f' = . in 1

	$ML_vers $ML_user `f' `list'
	ml_count_eval `f' `dottype'

	mlsum $ML_f = `f'

	if (`calltype'==0 | scalar($ML_f)==.) exit

				/* we now continue to make derivative
				   calculations
				*/
	tempname nfac wrk h
	tempvar one x0 grad xj0 fphh fmhh Dii Dij

	mat $ML_g = J(1,$ML_k,0)
	mat $ML_V = J($ML_k, $ML_k, 0)
	mat `h' = J(1, $ML_n, 0)
	qui gen byte `one' = 1 if $ML_samp

	quietly {
		local i 1
		while `i'<=$ML_n {
			if "${ML_xc`i'}" == "nocons" {
				local vl`i' ${ML_x`i'}
			}
			else 	local vl`i' ${ML_x`i'} `one'

			local se ${ML_fp`i'}
			local ee ${ML_lp`i'}

			tempvar fph`i' fmh`i'

			rename `x`i'' `x0'

					/* calculate stepsize `h'[1,`i'],
					   `fph`i'', and `fmh`i'' */

  		 	noi ml_adjs elf `i' `fph`i'' `fmh`i'' `x0' `list'
			matrix `h'[1,`i'] = r(step)
			local hi `h'[1,`i']

						/* gradient calculation */

			gen double `grad'=$ML_w*(`fph`i''-`fmh`i'')/(2*`hi')
			matrix vecaccum `wrk' = `grad' `vl`i'', nocons
			mat subst $ML_g[1,`se'] = `wrk'
			drop `grad'
					 	/* Dii calculation */

			gen double `Dii' = $ML_w* /*
				*/ (`fph`i''-2*`f'+`fmh`i'')/(`hi'^2)
			summ `Dii' if $ML_samp, meanonly
			scalar `nfac' = r(mean)
/* using wrk */
			matrix accum `wrk'= `vl`i'' [iw=-`Dii'/`nfac'], nocons
			if r(N)!=0 {
				mat `wrk' = `wrk' * `nfac'
				mat subst $ML_V[`se',`se'] = `wrk'
			}
/* wrk now free */
			drop `Dii'
			if `calltype'==2 { 		/* Dij calculation */
				local nei = `ee' - `se' + 1
				local nei1 = `nei' + 1
				local j 1
				while `j' < `i' { /* wrap */
local hj `h'[1,`j']
rename `x`j'' `xj0'
gen double `x`j'' = `xj0' + `hj'
gen double `fphh' = . in 1
noi $ML_vers $ML_user `fphh' `list'
ml_count_eval `f' input

drop `x`j''
gen double `x`j'' = `xj0' - `hj'
replace `x`i'' = `x0' - `hi'
gen double `fmhh' = . in 1
noi $ML_vers $ML_user `fmhh' `list'
ml_count_eval `f' input
replace `x`i'' = `x0' + `hi'
drop `x`j''

gen double `Dij' = $ML_w * /*
*/ (`fphh'+`fmhh'+2*`f'-`fph`i''-`fmh`i''-`fph`j''-`fmh`j'' ) /*
*/ / (2*`hi'*`hj')

* gen double `Dij' = $ML_w * (`fphh'-`fph`i''-`fph`j''+`f')/(`hi'*`hj')
summ `Dij' if $ML_samp, meanonly
scalar `nfac' = r(mean)
								/* use wrk */
mat accum `wrk' = (`vl`i'') (`vl`j'') [iw=-`Dij'/`nfac'], nocons
if r(N) != 0 {
	mat `wrk' = `wrk'[1..`nei',`nei1'...]
	mat `wrk' = `wrk' * `nfac'

	local sej ${ML_fp`j'}

	mat subst $ML_V[`se',`sej'] = `wrk'
	mat `wrk' = `wrk' '
	mat subst $ML_V[`sej',`se'] = `wrk'
}
								/* wrk free */
drop `Dij' `fphh' `fmhh'
rename `xj0' `x`j''

local j=`j'+1
				} /* wrap */
			} /* Dij */

			drop `x`i''
			rename `x0' `x`i''

			local i=`i'+1
		} /* i loop */
	} /* quietly */
	if "$ML_showh" != "" {
		ml_showh `h'
	}
end
exit
