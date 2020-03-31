*! version 1.0.0  15jan2013
program gsem_model_hinfo_check, sortpreserve
	version 13
	syntax [varlist(default=none ts fv)] [if] [, group(varlist)]
	if "`group'" == "" {
		exit
	}
	if "`varlist'" == "" {
		exit
	}
	if "`s(fvops)'" == "true" {
		fvexpand `varlist' `if'
		local varlist `"`r(varlist)'"'
	}
	tempvar x
	quietly gen double `x' = . in 1
	sort `group'
	foreach var of local varlist {
		quietly replace `x' = `var'
		capture by `group' : assert `x' == `x'[1]
		if c(rc) {
			local gspec : subinstr local group " " ">", all
	di as err "{p 0 0 2}"
	di as err "invalid path specification;{break}"
	di as err "a path from `var' to a [`gspec'] latent variable"
	di as err "was specified, but `var' is not constant within"
	di as err "the groups defined by [`gspec']"
	di as err "{p_end}"
			exit 459
		}
	}
end
exit
