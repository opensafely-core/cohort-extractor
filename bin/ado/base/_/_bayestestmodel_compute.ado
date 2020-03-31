*! version 1.0.2  24sep2018
program _bayestestmodel_compute
	version 14.0
	args mllmethod prvec lmlvec postprvec sumpostpr numchains chains i
	//compute posterior probability for current model
	if "`chains'" == "" {
		mat `lmlvec'[`i',1] = `e(`mllmethod')'
		mat `postprvec'[`i',1] = exp(`lmlvec'[`i',1])*`prvec'[`i',1]
		scalar `sumpostpr' = `sumpostpr' + `postprvec'[`i',1]
		mat `numchains'[`i',1] = `e(nchains)'
	}
	else {
		if `"`chains'"' == "_all" {
			cap confirm e(nchains)
			if _rc {
				di as err "no chains are available"
				return 198
			}
			local chains `e(allchains)'
		}
		tempname tlmlvec tempsc
		scalar `tlmlvec' = 0
		local nch = 0
		foreach ch of local chains {
			local nch = `nch' + 1
			cap mat `tempsc' = e(`mllmethod'_chains)
			cap scalar `tlmlvec' = `tlmlvec' + `tempsc'[1,`ch']
			if _rc {
				di as err "chain {bf:`ch'} not available"
				return 198
			}
		}
		mat `lmlvec'[`i',1] = `tlmlvec' / `nch'
		mat `postprvec'[`i',1] = exp(`lmlvec'[`i',1])*`prvec'[`i',1]
		scalar `sumpostpr' = `sumpostpr' + `postprvec'[`i',1]
		mat `numchains'[`i',1] = `nch'
	}
end
