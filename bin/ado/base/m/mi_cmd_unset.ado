*! version 1.0.3  04feb2015

/*
	mi unset [, asis]
*/

program mi_cmd_unset, rclass
	version 11
	syntax [, ASIS]

	if ("`asis'"!="") {
		u_mi_zap_chars
		exit
	}

	u_mi_assert_set
	u_mi_certify_data, acceptable proper
	local style `_dta[_mi_style]'

	novarabbrev nobreak mi_unset_`style'
	return add
	return local style `style'
end

program mi_unset_wide, rclass
	nobreak {
		mi_unset_wide_u
		return add
	}
end

program mi_unset_wide_u, rclass

	local M `_dta[_mi_M]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'

	local bad
	forvalues i=1(1)`M' {
		mi_unset_wide_novars *_`i'_
		local bad `bad' `r(varlist)'
	}
	if ("`bad'"!="") {
		local n : word count `bad'
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as err "{p}"
		di as smcl as err "variables `bad'"
		di as smcl as err "must be renamed before data can be unset"
		di as smcl as err "{p_end}"
		exit 110
	}

	_get_new_varname mi_miss : mi_miss
	rename _mi_miss `mi_miss'
	local vars `_dta[_mi_ivars]' `_dta[_mi_pvars]'
	foreach v of local vars {
		forvalues i=1(1)`M' {
			rename _`i'_`v' `v'_`i'_
		}
	}

	di 
	di as txt _col(13) "variables"
	di as txt _col(5) "original" _col(23) "new" _col(42) "meaning"
	di as smcl as txt "    {hline 71}"
	di as txt _col( 5) "_mi_miss" ///
		 _col(23) "`mi_miss'" ///
		 _col(42) "0=orig-complete, 1=orig-incomplete"
	if (`M') { 
		foreach v of local ivars {
			di as txt _col( 5) "_#_`v'" ///
		 	_col(23) "`v'_#_"           ///
		 	_col(42) "imputed values of `v'"
		}
		foreach v of local pvars {
			di as txt _col( 5) "_#_`v'" ///
		 	_col(23) "`v'_#_"           ///
		 	_col(42) "values of passive `v'"
		}
	}
	di as smcl as txt "    {hline 71}"
	if (`M') { 
		if (`M'==1) { 
			di as txt _col(5) "# = 1"
		}
		else if (`M'==2) { 
			di as txt _col(5) "# = 1, 2"
		}
		else if (`M'==3) { 
			di as txt _col(5) "# = 1, 2, 3"
		}
		else {
			di as txt _col(5) "# = 1, 2, ..., `M'"
		}
	}

	return local mi_miss "`mi_miss'"
	u_mi_zap_chars
end

program mi_unset_wide_novars, rclass
	capture syntax [varlist(default=none)]
	if _rc==0 { 
		return local varlist "`varlist'"
	}
end
		

program mi_unset_mlong, rclass

	_get_new_varname mi_id   : mi_id
	_get_new_varname mi_miss : mi_miss
	_get_new_varname mi_m    :  mi_m

	nobreak {
		u_mi_zap_chars
		rename _mi_id  `mi_id'
		rename _mi_miss `mi_miss'
		rename _mi_m   `mi_m'
	}

/*
       variables
 originally   new           meaning
   -----------------------------------------------------------------------
   _mi_m      mi_m          m; 0=orig, 1, 2, ...
   _mi_id     mi_id         unique m=0 obs. identifier; 1, 2, ... 
   _mi_miss   mi_miss       0=orig-complete, 1=orig-incomplete, .=marginal
   -----------------------------------------------------------------------
*/

	di 
	di as txt _col(7) "variables"
	di as txt _col(5) "original  new" _col(30) "meaning"
	di as smcl as txt "    {hline 71}"
	di as smcl as txt _col( 5) "_mi_m" ///
		 _col(16) "`mi_m'" ///
		 _col(30) "{it:m} (imputation); 0=orig, 1, 2, ..."
	di as txt _col( 5) "_mi_id" ///
		 _col(16) "`mi_id'" ///
		 _col(30) "unique orig. obs. identifier; 1, 2, ..."
	di as txt _col( 5) "_mi_miss" ///
		 _col(16) "`mi_miss'" ///
		 _col(30) "0=orig-complete, 1=orig-incomplete, .=marginal"
	di as smcl as txt "    {hline 71}"

	return local mi_id  "`mi_id'"
	return local mi_miss "`mi_miss'"
	return local mi_m   "`mi_m'"
end


program mi_unset_flong, rclass

	_get_new_varname mi_id   : mi_id
	_get_new_varname mi_miss : mi_miss
	_get_new_varname mi_m    : mi_m

	nobreak {
		u_mi_zap_chars
		rename _mi_id  `mi_id'
		rename _mi_miss `mi_miss'
		rename _mi_m   `mi_m'
	}

/*
       variables
 originally   new           meaning
   -----------------------------------------------------------------------
   _mi_m      mi_m          m, 0=orig, 1, 2, ...
   _mi_id     mi_id         unique m=0 obs. identifier; 1, 2, ... 
   _mi_miss   mi_miss       0=orig-complete, 1=orig-incomplete, .=imputedl
   -----------------------------------------------------------------------
*/

	di 
	di as txt _col(7) "variables"
	di as txt _col(5) "original  new" _col(30) "meaning"
	di as smcl as txt "    {hline 71}"
	di as smcl as txt _col( 5) "_mi_m" ///
		 _col(16) "`mi_m'" ///
		 _col(30) "{it:m} (imputation); 0=orig, 1, 2, ..."
	di as txt _col( 5) "_mi_id" ///
		 _col(16) "`mi_id'" ///
		 _col(30) "unique orig. obs. identifier; 1, 2, ..."
	di as txt _col( 5) "_mi_miss" ///
		 _col(16) "`mi_miss'" ///
		 _col(30) "0=orig-complete, 1=orig-incomplete, .=imputed"
	di as smcl as txt "    {hline 71}"

	return local mi_id  "`mi_id'"
	return local mi_miss "`mi_miss'"
	return local mi_m   "`mi_m'"
end

/*
	_get_new_varname <result> : <suggestedname>

	Return in `<result>' a new variable name similar to <suggestedname>
*/

program _get_new_varname 
	args result colon suggestedname

	capture confirm new var `suggestedname'
	if (_rc==0) {
		c_local `result' `suggestedname'
		exit
	}

	mata: st_local("myresult", _get_new_varname("`suggestedname'"))
	c_local `result' `myresult'
end

local SS string scalar
local RS real scalar

version 11
mata:
`SS' _get_new_varname(`SS' sn)
{
	`SS'	s

	if ((s=_get_new_varname_u(usubstr(sn,1,31), 1, 9)) != "") return(s)
	if ((s=_get_new_varname_u(usubstr(sn,1,29), 10, 99)) != "") return(s)
	if ((s=_get_new_varname_u(usubstr(sn,1,28), 100, 999)) != "") return(s)
	if ((s=_get_new_varname_u(usubstr(sn,1,27), 1000, 9999)) != "") return(s)
	if ((s=_get_new_varname_u(usubstr(sn,1,26), 10000, 99999)) != "") {
		return(s)
	}
	return("")
}

`SS' _get_new_varname_u(`SS' sn, `RS' from, `RS' to)
{
	`RS'	i
	`SS'	name

	for (i=from; i<=to; i++) { 
		if (_st_varindex(name = sn + strofreal(i)) >= .) return(name)
	}
	return("")
}
end
