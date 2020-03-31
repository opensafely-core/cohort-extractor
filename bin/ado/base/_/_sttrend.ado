*! version 7.0.0  18nov1999
program define _sttrend, rclass
	version 6 
	args mV mv by pad1 pad
	/* `mV' is the covariate matrix */
	/* `mv' is Z matrix */

	if `"`by'"'==`""' { 
		di in red `"by required"'
		exit 198 
	}
	qui cap confirm numeric v  `by'
	if _rc {
		di in red `"variable `by' must be numeric"'
		exit 198
	}


	tempname ajg ajZ ajagS
	scalar `ajZ'=0
	scalar `ajagS'=0
	mkmat `by', matrix(`ajg')
	local i 1
	while `i' <= _N { 
		scalar `ajZ'=`ajZ' + `mv'[1,`i']*`ajg'[`i',1]
		local i=`i'+1
	}	
	mat `ajg'=`ajg'*`ajg''
	local i 1
	local j 1
	while `i' <= _N { 
		local j 1
		while `j' <= _N { 
			scalar `ajagS'=`ajagS' + `ajg'[`i',`j']*`mV'[`i',`j']
			local j=`j'+1
		}
		local i=`i'+1
	}
	di _n in gr "Test for trend of survivor functions"
	di _n in gr _col(`pad1') `"chi2(1) = "' /*
	*/ in ye %10.2f (`ajZ'/sqrt(`ajagS'))^2
	di in gr _col(`pad') `"Pr>chi2 = "' /*
	*/ in ye %10.4f chiprob(1, (`ajZ'/sqrt(`ajagS'))^2)
	* noi di in red "Z()= " `ajZ'
	* noi mat list `mV' 
	ret scalar df_tr = 1
	ret scalar chi2_tr=(`ajZ'/sqrt(`ajagS'))^2
end
