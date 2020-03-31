*! version 1.0.0  03may2019

program meta, rclass
	version 16.0

	gettoken subcmd 0 : 0, parse(" :,=[]()+-")

	local l = strlen("`subcmd'")

	if ("`subcmd'"=="set") {
		meta_cmd_set `0'
	}
	else if ("`subcmd'"==bsubstr("esize", 1, max(2, `l'))) {
		meta_cmd_esize `0'
	}
	else if ("`subcmd'"==bsubstr("summarize", 1, max(3, `l'))) {
		meta_cmd_summarize `0'
	}
	else if ("`subcmd'"==bsubstr("query", 1, max(1,`l'))) {
		meta_cmd_query `0'
	}
	else if ("`subcmd'"==bsubstr("regress", 1, max(3,`l'))) {
		meta_cmd_regress `0'
	}
	else if ("`subcmd'"== "clear") {
		meta_cmd_clear `0'
	}
	else if ("`subcmd'"==bsubstr("forestplot", 1, max(6, `l'))) {
		meta_cmd_forest `0'
	}
	else if ("`subcmd'"==bsubstr("funnelplot", 1, max(6, `l'))) {
		 meta_cmd_funnel `0'
	}
	else if ("`subcmd'"==bsubstr("labbeplot", 1, max(5, `l'))) {
		 meta_cmd_labbe `0'
	}
	else if ("`subcmd'"=="bias") {
		 meta_cmd_bias `0'
	}
	else if ("`subcmd'"==bsubstr("trimfill", 1, max(4,`l'))) {
		meta_cmd_trimfill `0'
	}
	else if ("`subcmd'"==bsubstr("update", 1, max(2,`l'))) { 		
		meta_cmd_update `0'
	}
	else {
		if ("`subcmd'"=="") {
			di as smcl as err "syntax error"
			di as smcl as err "{p 4 4 2}"
			di as smcl as err ///
			"{bf:meta} must be followed by a subcommand."
			di as smcl as err ///
			"You might type {bf:meta set}, or {bf:meta esize},"
			di as smcl as err "etc."
			di as smcl as err "{p_end}"
			exit 198
		}

		capture which meta_cmd_`subcmd'
		if (_rc) { 
			if (_rc==1) {
				exit 1
			}
			di as smcl as err ///
			`"subcommand {bf:meta} {bf:`subcmd'} is unrecognized"'
			exit 199
			/*NOTREACHED*/
		}
		meta_cmd_`subcmd' `0'
	}
	return add
end

exit

