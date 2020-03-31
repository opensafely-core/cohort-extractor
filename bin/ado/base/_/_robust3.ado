*! version 1.2.1  09nov2010
program _robust3, eclass
	version 10
	syntax [pw iw fw aw] [, CLuster(varname) MINUS(int 1)]
	if "`weight'" != "" {
		local wt [`weight'`exp']
	}
	if "`cluster'" != "" {
		local clopt cluster(`cluster')
	}
	tempvar sc
	quietly predict double `sc'* if e(sample), scores

nobreak {

	local epilog "*"
	if `"`e(robust_prolog)'"' != "" {
		`e(robust_prolog)'
		local epilog `"`e(robust_epilog)'"'
	}

capture noisily break {

	_robust2 `sc'* `wt' if e(sample), `clopt' minus(`minus')
	drop `sc'*

} // capture noisily break

	local rc = c(rc)
	`epilog'

} // nobreak
	if (`rc') exit `rc'

	if "`cluster'" != "" {
		ereturn local vce cluster
	}
	else	ereturn local vce robust
	ereturn local vcetype Robust
	ereturn local wtype "`weight'"
	ereturn local wexp "`exp'"
	_prefix_model_test
	_post_vce_rank
end
