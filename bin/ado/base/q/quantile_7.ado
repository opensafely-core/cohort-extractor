*! version 2.1.4  28sep2004
program define quantile_7, sort
	version 6, missing
	syntax varname [if] [in] [, *] 
	tempvar QUANT LINE FRAC CNT
	quietly {
		gen `QUANT'=`varlist' `if' `in'
		sort `QUANT'
		gen long `CNT'=sum(`QUANT'~=.)
		gen `FRAC'=(`CNT'-0.5)/`CNT'[_N]
		gen `LINE'=`QUANT'[1] + `CNT'* /*
			*/ ((`QUANT'[`CNT'[_N]]-`QUANT'[1])/`CNT'[_N])
		_crcslbl `QUANT' `varlist'
		local w : variable label `QUANT'
		lab var `QUANT' "Quantiles of `w'"
		lab var `FRAC' "Fraction of the data"
		lab var `LINE' " "
	}
	gr7 `QUANT' `LINE' `FRAC', s(oi) c(.l) xsca(0,1) /*
		*/ `options' xlab(0,.25,.5,.75,1)
end
