*! version 1.0.2  10feb2015

/*
	mi expand [=]<exp> <if> [, generate(<newvarname>) noupdate]

	The expand is carried forward on the m=0 data
	and then the result is duplicated in each of the 
	imputed datasets

	May change sort order of data

*/

program mi_cmd_expand
	version 11.0

	u_mi_assert_set
	gettoken token : 0, parse(" =")

	if (bsubstr("`token'", 1, 1)!="=") {
		local 0 `"=`0'"'
	}
	syntax =/exp [if/] [, GENerate(string) noUPdate]
	if ("`generate'"!="") {
		confirm new var `generate'
	}

	tempname msgno
	u_mi_certify_data, acceptable msgno(`msgno')
	if ("`update'"=="") { 
		u_mi_certify_data, proper msgno(`msgno')
	}

	mi_expand_`_dta[_mi_style]' `"`exp'"' `"`if'"' "`generate'"
	u_mi_fixchars, proper
end


program mi_expand_wide
	args exp ifexpr marker

	if (`"`ifexpr'"'!="") {
		local if `"if `ifexpr'"'
	}
	if ("`marker'"!="") {
		local generate "generate(`marker')"
	}
	expand =`exp' `if', `generate'
end


program mi_expand_mlong
	args exp ifexpr marker

	u_combine_ifexpr f_ifexpr : `"`ifexpr'"' "_mi_m==0"

	tempvar nvar
	u_expand_count N_add : `nvar' `"`exp'"' `"`f_ifexpr'"' 

	if (`N_add'==0) { 
		di as txt "(0 observations created)"
		if ("`marker'"!="") {
			qui gen byte `marker' = 0 
		}
		exit
	}

	if ("`marker'" != "") {
		local generate generate(`marker')
	}

	tempvar newid
	local M `_dta[_mi_M]'

	quietly {
		preserve
		if (`M'==0) {
			expand `nvar', `generate'
			sort _mi_id `marker'
			drop _mi_id
			gen `c(obs_t)' _mi_id = _n
			compress _mi_id
		}
		else {
			tempfile selfile margfile file0
			keep if _mi_m==0
			expand `nvar', `generate'
			sort _mi_id `marker'
			tempvar newid
			gen `c(obs_t)' `newid' = _n
			save "`file0'"
			keep _mi_id `newid' `marker'
			save "`selfile'"

			restore, preserve
			keep if _mi_m
			save "`margfile'"
			forvalues i=1(1)`M' {
				if (`i'!=1) {
					use "`margfile'", clear
				}
				keep if _mi_m==`i'
				sort _mi_id
				merge 1:m _mi_id using "`selfile'", ///
					keep(match) nonotes nogen
				drop _mi_id
				rename `newid' _mi_id
				tempfile file`i'
				save "`file`i''"
			}
			use "`file0'", clear
			keep if _mi_m==0
			drop _mi_id
			rename `newid' _mi_id
			forvalues i=1(1)`M' {
				append using "`file`i''"
			}
		}
		count if _mi_m==0
		char _dta[_mi_N] `r(N)'
		restore, not
	}

	local obs = cond(`N_add'==1, "observation", "observations")
	di as smcl as txt ///
	"(`N_add' `obs' created in {it:m}=0; {it:m}>0 obs. updated)"
end

program mi_expand_flong
	args exp ifexpr marker

	u_combine_ifexpr f_ifexpr : `"`ifexpr'"' "_mi_m==0"

	tempvar nvar
	u_expand_count N_add : `nvar' `"`exp'"' `"`f_ifexpr'"' 

	if (`N_add'==0) { 
		di as txt "(0 observations created)"
		if ("`marker'"!="") {
			qui gen byte `marker' = 0 
		}
		exit
	}

	if ("`marker'" != "") {
		local generate generate(`marker')
	}

	tempvar newid
	local M `_dta[_mi_M]'

	quietly {
		preserve
		if (`M'==0) {
			expand `nvar', `generate'
			sort _mi_id `marker'
			drop _mi_id
			gen `c(obs_t)' _mi_id = _n
			compress _mi_id
		}
		else {
			sort _mi_m _mi_id
			replace `nvar' = `nvar'[_mi_id] if _mi_m
			expand `nvar', `generate'
			sort _mi_m _mi_id `marker'
			drop _mi_id
			by _mi_m: gen `c(obs_t)' _mi_id = _n
			compress _mi_id
		}

		count if _mi_m==0
		char _dta[_mi_N] `r(N)'
		restore, not
	}

	local obs = cond(`N_add'==1, "observation", "observations")

	di as smcl as txt ///
	"(`N_add' `obs' created in {it:m}=0 and in each {it:m}>0)"
end


program mi_expand_flongsep
	args exp ifexpr marker

	local name "`_dta[_mi_name]'"
	local M    "`_dta[_mi_M]'"

	tempvar nvar
	u_expand_count N_add : `nvar' `"`exp'"' `"`ifexpr'"' 

	if (`N_add'==0 & "`marker'"=="") { 
		di as txt "(0 observations created)"
		exit
	}

	if (`M'==0) { 
		preserve
		if ("`marker'"!="") {
			local generate generate(`marker')
		}
		expand `nvar', `generate'
		quietly {
			sort _mi_id `marker'
			drop `nvar' _mi_id
			gen `c(obs_t)' _mi_id = _n
			compress _mi_id
		}
		char _dta[_mi_N] `=_N'
		restore, not
		exit
	}
	u_mi_xeq_on_tmp_flongsep, nopreserve: ///
		mi_sub_expand_flongsep `newname' `N_add' `nvar' `marker'
end



program u_expand_count
	args toret_N_add colon  tvar exp ifexpr

	if (`"`ifexpr'"' != "") { 
		local if    `"if (`ifexpr')"'
		local andif `"& (`ifexpr')"'
	}
	quietly { 
		gen double `tvar' = `exp' `if'
		count if (`tvar'>=.) `andif'
		local N_miss = r(N)
		if (r(N)) {
			replace `tvar'=1 if (`tvar'>=.) `andif'
		}

		count if (`tvar'!=floor(`tvar')) `andif'
		local N_notint = r(N)
		if (r(N)) {
			replace `tvar' = floor(`tvar') `andif'
		}
		compress `tvar'

		count if (`tvar'<0) `andif'
		local N_neg = r(N)

		count if (`tvar'==0) `andif'
		local N_0 = r(N)

		if (`N_neg' | `N_0') {
			replace `tvar' = 1 if (`tvar'<=0) `andif'
		}
	}
	if (`N_miss') { 
		local counts = cond(`N_miss'==1, "count", "counts")
		local obs   = cond(`N_miss'==1, "observation", "observations")
		di as txt ///
		"(`N_miss' missing counts ignored; `observations' not deleted)"
	}
	if (`N_notint') {
		di as txt ///
		"(`N_miss' noninteger counts truncated to integer)"
	}
	if (`N_neg') {
		local counts = cond(`N_neg'==1, "count", "counts")
		local obs   = cond(`N_neg'==1, "observation", "observations")
		di as txt ///
		"(`N_neg' negative counts ignored; `observations' not deleted)"
	}
	if (`N_0') {
		local counts = cond(`N_0'==1, "count", "counts")
		local obs   = cond(`N_0'==1, "observation", "observations")
		di as txt ///
		"(`N_0' zero counts ignored; `observations' not deleted)"
	}

	quietly { 
		count `if'
		local N = r(N)
		summarize `tvar', meanonly 
		local N_add = r(sum) - `N'
	}
	c_local `toret_N_add' `N_add'
end

program u_combine_ifexpr
	args ifexprname colon ifexpr1 ifexpr2

	local ifexpr
	if (`"`ifexpr1'"'!="" & `"`ifexpr2'"'=="") { 
		local ifexpr `"`ifexpr1'"'
	}
	else if (`"`ifexpr1'"'=="" & `"`ifexpr2'"'!="") { 
		local ifexpr `"`ifexpr2'"'
	}
	else if (`"`ifexpr1'"'!="" & `"`ifexpr2'"'!="") { 
		local ifexpr `"(`ifexpr1') & (`ifexpr2')"'
	}

	c_local `ifexprname'   `"`ifexpr'"'
end
