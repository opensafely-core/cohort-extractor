*! version 1.0.2  04oct2016

/*
	u_mi_check_setvars {settime|runtime} [varlist]

	see note at bottom of u_mi_not_mi_set.ado
*/

program u_mi_check_setvars
	version 11

	gettoken when 0 : 0
	gettoken who  0 : 0
	cap noi syntax [varlist(default=none)]
	if (_rc==111) {
		di as err "{p 4 4 2}"
		di as err "Your {bf:mi} data are {bf:`who'} and "
		di as err "some of the variables previously declared"
		di as err "by {bf:`who'} are not in the dataset.  {bf:mi}"
		di as err "verifies that none of the {bf:`who'} variables" 
		di as err "are also registered as imputed or passive.  Type"
		di as err "{helpb mi_`who':mi `who', clear} to clear old"
		di as err "no-longer-valid settings."
		di as err "{p_end}"
		exit 111
	}
	else if (_rc) {
		exit _rc
	}
	if ("`varlist'"=="") {
		exit
	}

	local vars `_dta[_mi_ivars]' `_dta[_mi_pvars]'
	local prob : list varlist & vars
	if ("`prob'"=="") {
		exit
	}

	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'

	local probi : list ivars & varlist
	local probp : list pvars & varlist

	local ni : word count `probi'
	local np : word count `probp'

	local vars2 = cond(`np'==1, "variable", "variables")

	di as smcl as err "{p 0 0 2}"
	if (`ni') { 
		local vars = cond(`ni'==1, "variable", "variables")
		di as smcl as err "`vars'"
		di as smcl as err "{bf}`probi'"
		di as smcl as err "{sf}registered as imputed"
		if (`np') {
			di as smcl as err "and"
		}
	}
	if (`np') {
		local vars = cond(`np'==1, "variable", "variables")
		di as smcl as err "`vars'"
		di as smcl as err "{bf}`probp'"
		di as smcl as err "{sf}registered as passive"
	}
	di as smcl as err "{p_end}"
	di as smcl as err "{p 4 4 2}
	di as smcl as err "Imputed and passive variables may not be"
	di as smcl as err "used as the basis for {bf:mi `who'}."
	if ("`when'"=="runtime") {
		di as smcl as err "The first step to solving this problem"
		di as smcl as err "is to use {bf:mi `who'} to"
		di as smcl as err "un-`who' your data."
	}
	di as smcl as err "{p_end}"
	exit 459
end
