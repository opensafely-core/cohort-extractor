*! version 1.0.2  06jun2019

/*
	frlink  {1:1|m:1} ...		// see frlink_gen.ado

        frlink dir                      // see frlink_dd.ado

        frlink describe <varname>       // see frlink_dd.ado
               -

	frlink  rebuild <varname>	// see frlink_rebuild.ado
                -------
*/


program frlink, rclass
	local orig `"`0'"'
	gettoken subcmd 0 : 0, parse(" ,")

	local l = strlen(`"`subcmd'"')

	if ("`subcmd'"=="1:1" | "`subcmd'"=="m:1") {
		frlink_gen `subcmd' `0'
		return add
		exit
	}

	if ("`subcmd'"==substr("describe", 1, max(1,`l'))) {
		frlink_dd describe `0'
		return add
		exit
	}

	if ("`subcmd'"=="dir") {
		frlink_dd dir `0'
		return add
		exit
	}


	if ("`subcmd'"=="rebuild") {
		frlink_rebuild `0'
		return add
		exit
	}

	local 0 `"`orig'"'
	capture quietly syntax varlist , FRame(string)    ///
                         		 [ GENerate(name) ///
                           		   DEBUG(string)     ]

	if (_rc==0) {
		di as err "must specify match type of {bf:1:1} or {bf:m:1}"
		exit 197
	}

	di as err "{bf:`subcmd'} invalid {bf:frlink} subcommand"
	exit 197
end

