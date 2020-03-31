*! version 1.3.0  19feb2019
program define clog_lf
        version 6
	args todo b lnf g H sc

/* Calculate the log-likelihood. */

        tempvar z
	mleval `z' = `b'

	mlsum `lnf' = cond($ML_y1, cond(`z'>100, 0, /*
	*/ cond(`z'<-12, `z'-(exp(`z')/2)*(-expm1(`z')/4), /*
	*/ ln1m(exp(-exp(`z'))))), -exp(`z'))

	if `todo'==0 | `lnf'==. { exit }

/* Calculate the score and gradient. */

	qui replace `sc' = cond($ML_y1,exp(`z'-exp(`z'))/(-expm1(-exp(`z'))), /*
	*/ -exp(`z')) if $ML_samp

$ML_ec	mlvecsum `lnf' `g' = `sc'

	if `todo'==1 | `lnf'==. { exit }

/* Calculate the negative hessian. */

	mlmatsum `lnf' `H' = cond($ML_y1, /*
	*/ -(`sc'/(-expm1(-exp(`z'))))*(-expm1(`z')-exp(-exp(`z'))), /*
	*/ exp(`z'))
end
