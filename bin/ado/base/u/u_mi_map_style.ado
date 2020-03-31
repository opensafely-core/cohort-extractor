*! version 1.0.1  20jan2015

/*
	u_mi_map_style <lmac> : <style>

	returns official abbreviation, which are 

		min. abbreviation	returned
		--------------------------------
		fl			flong
		flongs			flongsep
		ml			mlong
		w			wide
*/

program u_mi_map_style
	version 11.0
	args mac colon style

	local l = strlen("`style'")

	if ("`style'" == bsubstr("flongsep", 1, max(6,`l'))) {
		c_local `mac' "flongsep"
		exit
	}

	if ("`style'" == bsubstr("flong", 1, max(2,`l'))) {
		c_local `mac' "flong"
		exit
	}

	if ("`style'" == bsubstr("mlong", 1, max(2,`l'))) {
		c_local `mac' "mlong"
		exit
	}


	if ("`style'" == bsubstr("wide", 1, max(1,`l'))) {
		c_local `mac' "wide"
		exit
	}

	if ("`style'" == "") { 
		di as smcl as err "must specify dataset style"
	}
	else {
		di as smcl as err "{bf:`style'}: invalid {it:style}"
	}
	di as smcl as err "{p 4 4 2}"
	di as smcl as err "{it:styles} are {bf:wide}, {bf:mlong},"
	di as smcl as err "{bf:flong}, and {bf:flongsep}"
	di as smcl as err "{p_end}"
	exit 198
end
