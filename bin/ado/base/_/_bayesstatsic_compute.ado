*! version 1.0.3  30nov2018
program _bayesstatsic_compute
	version 14.0
	args mllmethod dicvec lmlvec numchains chains i
	if "`chains'" == "" {
		mat `lmlvec'[`i',1] = `e(`mllmethod')'
		mat `dicvec'[`i',1] = e(dic)
		mat `numchains'[`i',1] = `e(nchains)'
	}
	else {
		tempname tlml tdic slml sdic
		scalar `slml' = 0
		scalar `sdic' = 0
		mat `tlml' = e(`mllmethod'_chains)
		mat `tdic' = e(dic_chains)
		if `"`chains'"' == "_all" {
			cap confirm e(nchains)
			if _rc {
				di as err "no chains are available"
				return 198
			}
			local chains `e(allchains)'
		}
		local nch = 0
		foreach ch of local chains {
			local nch = `nch' + 1
			cap scalar `slml' = `slml' + `tlml'[1, `ch']
			if _rc {
				di as err "chain {bf:`ch'} not available"
				return 198
			}
			cap scalar `sdic' = `sdic' + `tdic'[1, `ch']
			if _rc {
				di as err "chain {bf:`ch'} not available"
				return 198
			}
		}
		scalar `slml' = `slml' / `nch'
		scalar `sdic' = `sdic' / `nch'
		mat `lmlvec'[`i',1] = `slml'
		mat `dicvec'[`i',1] = `sdic'
		mat `numchains'[`i',1] = `nch'
	}
end
