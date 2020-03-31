*! version 3.2.0  02may2007
program define ml_elfs /* list of score variables to be created */
	version 7
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

	tempvar f x0 fp fm
	tempname f0

	qui gen double `f' = . in 1

	$ML_vers $ML_user `f' `list'

	mlsum $ML_f = `f'
	ml_count_eval $ML_f text
	drop `f'

	if scalar($ML_f)==. {
		di as err "cannot evaluate $ML_crtyp function"
		exit 1400
	}

	quietly {		/* we now make derivative calculations */
		local i 1
		while `i'<=$ML_n {
			rename `x`i'' `x0'

			noi ml_adjs elf `i' `fp' `fm' `x0' `list'

			gen double ``i''= (`fp'-`fm')/(2*r(step)) if $ML_samp

				/* note $ML_w is intentionally left out of
				   the above score */

			drop `x`i''
			rename `x0' `x`i''

			local i = `i'+1
		}
	}
end
