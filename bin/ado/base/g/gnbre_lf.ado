*! version 1.2.0  20aug2000
program define gnbre_lf
        version 6.0
	args lnf xb lna

	tempvar lnalpha m
	local bound -20
	quietly {
		gen double `lnalpha' = cond(`lna'<`bound',`bound',`lna') /*
		*/ if $ML_samp

		gen double `m' = exp(-`lnalpha')

		replace `lnf' = cond(`lna'>`bound',lngamma(`m'+$ML_y1) /* 
				   */ - lngamma($ML_y1+1) - lngamma(`m') /*
				   */ - `m'*ln(1+exp(`xb'+`lnalpha')) /*
				   */ - $ML_y1*ln(1+exp(-`xb'-`lnalpha')), /*
			 	   */ - lngamma($ML_y1+1) - exp(`xb') /*
				   */ + $ML_y1*`xb') if $ML_samp
	}
end
