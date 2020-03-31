*! version 1.0.0  06mar2009
/*
	u_mi_how_set <macname> {selectok}

	Returns in <macname> how data are set, or returns "" if data 
	are not set.  Handles case of data being set by older version 
	-mi-.
	
        If -selectok- specified, -mi select- dataset okay.
	Otherwise, returns error.

	mi version history:
		_mi_ds_1		current version
*/


program u_mi_how_set /* <macname> {selectok} */
	version 11
	args mname selectok

	local marker `_dta[_mi_marker]'

	if ("`marker'" == "_mi_ds_1") {
		c_local `mname' `_dta[_mi_style]'
		exit
	}
	if ("`marker'" == "select") {
		if ("`selectok'"=="selectok") {
			c_local `mname' select
			exit
		}
		di as smcl as err "data in memory are from {bf:mi select}"
		exit 119
	}
	if ("`marker'"=="") {
		c_local `mname'
		exit
	}
	di as smcl as err "data {bf:mi set} by a more modern version of {bf:mi}"
	exit 610
end
