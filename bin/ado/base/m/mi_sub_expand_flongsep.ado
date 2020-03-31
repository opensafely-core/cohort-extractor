*! version 1.0.1  09feb2015
program mi_sub_expand_flongsep
	version 11
	args N_add nvar marker


	if ("`marker'"!="") {
		local generate generate(`marker')
	}

	local name "`_dta[_mi_name]'"
	local M    `_dta[_mi_M]'
	quietly {
		if (`M') {
			tempfile tomer
			keep _mi_id `nvar'
			sort _mi_id
			save "`tomer'"
			forvalues m=1(1)`M' {
				use "_`m'_`name'", clear 
				sort _mi_id
				merge 1:1 _mi_id using "`tomer'", ///
						assert(match) nogen nonotes
				expand `nvar', `generate'
				sort _mi_id `marker'
				drop _mi_id `nvar'
				gen `c(obs_t)' _mi_id = _n 
				compress _mi_id 
				save "_`m'_`name'", replace
			}
			use "`name'", clear 
		}
		expand `nvar', `generate'
		sort _mi_id `marker'
		drop _mi_id `nvar'
		gen `c(obs_t)' _mi_id = _n 
		compress _mi_id 
		char _dta[_mi_N] `=_N'
	}

	local obs = cond(`N_add'==1, "observation", "observations")
	if (`N_add'==0) { 
		di as txt "(0 `obs' created)"
	}
	else {
		di as smcl as txt ///
		"(`N_add' `obs' created in {it:m}=0 and in each {it:m}>0)"
	}
end
