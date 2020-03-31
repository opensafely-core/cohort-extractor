*! version 1.2.7  13jun2016
program _prefix_footnote
	version 9
	local is_st = "`e(cmd2)'" == "streg"
	if `is_st' {
		local tropt TR
	}
	syntax [, deff `tropt' linesize(int 79) * ]

	if `is_st' & `"`e(noeform)'"' != "" & `"`tr'"' != "" {
		di as txt "{p 0 6 2}" ///
		"Note: Option tr ignored; " ///
		"not appropriate with strata() or ancillary() options." ///
		"{p_end}"
	}

	local footnote `"`e(footnote)'"'
	gettoken cmd args : footnote, parse(" ,")
	capture which `cmd'
	if !c(rc) {
		if `:length local options' {
			`footnote' , `options'
		}
		else {
			`footnote'
		}
	}
	capture
	if "`e(prefix)'" == "svy" {
		_svy_fpc_note "`deff'" `linesize'
		_svy_subpop_note, linesize(`linesize')
		_svy_singleton_note, linesize(`linesize')
	}
	if inlist(`"`e(cmd)'"',"logit","logistic","probit") {
		CompleteLogit
	}
	if inlist(`"`e(cmd)'"',"mlogit","ologit","oprobit") {
		CompleteOlogit
	}
	if "`e(missing)'" == "missing" ///
	 & inlist("`e(vce)'", "brr", "bootstrap", "jackknife") {
	 	if "`e(vce)'" == "brr" {
			local vcetype BRR
		}
		else	local vcetype `e(vce)'
		if e(N_misreps) == 1 {
			local reps replicate
		}
		else {
			local reps replicates
		}
		if "`e(N_misreps)'" != "" {
			local the `e(N_misreps)'
		}
		else	local the "some of the"
		di as txt "{p 0 6 0 `linesize'}" ///
"Note: One or more parameters could not be estimated in " ///
"`the' `vcetype' `reps'; " ///
"standard-error estimates include only complete replications.{p_end}"
	}
	if inlist(`"`e(opt)'"', "ml", "moptimize") | !missing(e(converged)) {
		ml_footnote
	}
	_check_e_rc
end

program CompleteLogit
	local cf = e(N_cdf)
	local cs = e(N_cds)
	local complete = `cf' + `cs'
	if `complete' > 0 & !missing(`complete') {
		local fs = cond(`cf'==1,"","s")
		local ss = cond(`cs'==1,"","es")
		di as txt "{p 0 6 2}" ///
"Note: `cf' failure`fs' and `cs' success`ss' completely determined.{p_end}"
	}
end

program CompleteOlogit
	local complete = e(N_cd)
	if `complete' > 0 & !missing(`complete') {
		if `complete' != 1 {
			local os "s"
		}
		di as txt "{p 0 6 2}" ///
"Note: `complete' observation`os' completely determined." ///
"  Standard errors questionable.{p_end}"
	}
end

exit
