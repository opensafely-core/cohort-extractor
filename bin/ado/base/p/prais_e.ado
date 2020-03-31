*! version 1.1.1  10jun2011
program define prais_e, eclass
	version 6.0
	args       negsse     /*  scalar to hold negative of sse (rss)
		*/ colon      /*  colon 
		*/ rho        /* current value of rho */

					/* Estimate model */
	local diflist
	tokenize $T_fullv
	local i 1
	while "``i''" != "" {
		tempname tvar

		_ms_parse_parts ``i''
		if r(type) == "interaction" {
			local k = r(k_names)
			local li
			local sharp
			forval j = 1/`k' {
				local li `li'`sharp'`r(op`j')'l.`r(name`j')'
				local sharp "#"
			}
		}
		else {
			local li l.``i''
		}
		qui gen double `tvar' = ``i'' - `rho'*`li'  /*
			*/ if $T_touse & l.$T_touse
		if "$T_corc" == "" {
			qui replace `tvar' = ``i'' * sqrt(1 - `rho'^2)  /*
				*/ if $T_touse & l.$T_touse != 1
		}
		local diflist `diflist' `tvar'
		local i = `i' + 1
	}

	capture drop $T_score
	qui _regress `diflist'  if $T_touse ,  depname($T_depv) /*
		*/ nocons $T_tsscon $T_opts

					/* Name coefficients */
	tempname b
	mat `b' = get(_b)
	version 11: mat colnames `b' = $T_indv $T_cons
	mat repost _b=`b', rename

	scalar `negsse' = -e(rss)

end
