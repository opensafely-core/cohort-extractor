*! version 1.1.0  08dec2010

/*
        Checks if variables in <varlist> are registered as imputed variables.
        Assumes -mi- data are set and acceptable.

	Syntax:
		u_mi_mustbe_registered <badvars> <unabvars>: <varlist> <noerr>

        Returns variables not in the imputation list in <badvars> and gives an
        error message unless <noerr> is not empty.

*/
program u_mi_mustbe_registered_imputed
	version 11.0

	args badvars unabivars colon varlist noerr

	cap unab varlist : `varlist'
	if _rc {
		di as err `"{bf:`=rtrim("`varlist'")'}: "' _c
		unab varlist : `varlist'
	}

	local imputed	`_dta[_mi_ivars]'
	local ivars : list uniq varlist
	local bad: list ivars - imputed
	c_local `badvars' `bad'
	if (`"`unabivars'"'!="") {
		c_local `unabivars' `varlist'
	}
	if ("`bad'"!="" & "`noerr'"=="") {
		di as err "{p 0 4 2}{bf:`bad'}: must be registered as imputed;"
		di as err "see {helpb mi register:{bind:mi register}}{p_end}"
		exit 198
	}
end
