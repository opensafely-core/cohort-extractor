*! version 1.1.0  16jan2015
program define _teffects_replaym
	version 13

	syntax, [ * DMVariables ]

	_get_diopts diopts, `options'

	if "`e(subcmd)'" == "nnmatch" {
		local estimator "nearest-neighbor matching"
	}
	else {			// must be psmatch
		local estimator "propensity-score matching"
	}

	di as txt _n"`e(title)'{col 48}Number of obs {col 67}= " ///
		as res %10.0fc e(N)
	di "{txt:Estimator}{col 16}:{res: `estimator'}"		///
		"{col 48}{txt:Matches: requested }{col 67}{txt:=} " 	///
		 as res %10.0fc e(k_nneighbor)
	di "{txt:Outcome model}{col 16}:{res: matching}"	///
		as txt "{col 63}min {col 67}= " as res %10.0fc e(k_nnmin)
	if "`e(subcmd)'" == "nnmatch" {
		local metric `e(metric)'
		if "`metric'"=="mahalanobis" | "`metric'"=="euclidean" {
			local metric = proper("`metric'")
		}
		di "{txt:Distance metric: }{res:`metric'}"	///
			"{col 63}{txt:max }{col 67}{txt:=} " 	///
			 as res %10.0f e(k_nnmax)
	}
	else {
		di "{txt:Treatment model}{col 16}:{res: `e(tmodel)'}"	///
			"{col 63}{txt:max }{col 67}{txt:=} " 		///
			as res %10.0f e(k_nnmax)
	}

	_coef_table, coding showeqns `diopts' 

	if "`e(subcmd)'" == "nnmatch"  & "`dmvariables'" != "" {
if "`e(emvarlist)'" != "" {
	local sp 3
	local s2 23
}
else {
	local sp 0
	local s2 20
}

di as text "{p `sp' `s2' 2}Matching variables: {res:`e(fvmvarlist)'}{p_end}"
if "`e(bavarlist)'"!="" {
	di as txt "{p `sp' `s2' 2}Bias-adj variables: "	///
		"{res:`e(fvbavarlist)'}{p_end}"
}

if "`e(emvarlist)'" != "" {
	di as txt "{p 0 `s2' 2}Exact-match variables: "	///
		"{res:`e(fvematch)'}{p_end}"
}
	}
end
