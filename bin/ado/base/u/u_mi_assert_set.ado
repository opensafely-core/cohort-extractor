*! version 1.0.1  12mar2011
/*
	u_mi_assert_set [<desired_style>]

	assert that the data are -mi set-, optionally of the desired 
	style, and issue appropriate error message if not.
	Handles version of -mi set- via -u_mi_how_set-.
	If flongsep_sub in memory, issues error.

	See u_mi_zap_chars for a complete list of characteristics used.
*/

program u_mi_assert_set /* [desired_style] */
	version 11
	args desired_style

	u_mi_how_set style 
	if ("`style'"=="") {
		if (_N==0 & c(k)==0) { 
			di as err "no data in memory"
		}
		else {
			di as smcl as err "data not {bf:mi set}"
		}
		exit 119
	}
	if ("`desired_style'" != "") {
		if ("`style'"!="`desired_style'") {
			di as smcl as err ///
				"data not {bf:mi set `desired_style'}"
			exit 459
		}
	}
	if ("`style'"=="flongsep_sub") {
		local   m  `_dta[_mi_m]'
		local name `_dta[_mi_name]'
		di as err "no; you have _`m'_`name'.dta in memory"
		if (c(changed)==0) {
			di as err "   you need to {bf:use `name'} first"
		}
		else {
			di as smcl as err "{p 4 8 2}"
			di as smcl as err "(1) if the changes you have made to"
			di as smcl as err "_`m'_`name'.dta are important,"
			di as smcl as err "you need to {bf:save _`m'_`name'}"
			di as smcl as err "{p_end}
			di as smcl as err "{p 4 8 2}"
			di as smcl as err "(2) you need to {bf:use `name'}"
			di as smcl as err "{p_end}
		}
		exit 198
	}
end
