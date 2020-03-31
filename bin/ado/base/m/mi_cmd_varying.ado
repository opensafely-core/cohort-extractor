*! version 2.0.2  26jan2012

/*
	mi varying [varlist] [, unregistered noupdate syscall]

	Returns
		r(ivars)	nonvarying imputed variables
		r(pvars)	nonvarying passive variables
		r(uvars_v)	varying unregistered variables
		r(uvars_s_v)	(super) varying unregistered variables
		r(uvars_s_s)	 super  varying unregistered variables

	if -unregistered- specified, only r(uvars*) returned
	Note:  r() results mutually exclusive.
*/

program mi_cmd_varying, rclass
	version 11.0

	u_mi_assert_set
	syntax [varlist(default=none)] [, UNREGistered noUPdate SYSCALL]
	if ("`varlist'"!="") {
		if ("`unregistered'"!="") { 
			di as smcl as err "{p 0 4 2}"
			di as smcl as err "option {bf:unregistered} may"
			di as smcl as err "not be specified with"
			di as smcl as err "explicit varlist"
			di as smcl as err "{p_end}"
			exit 198
		}
	}

	tempname msgno
	if ("`syscall'"=="") {
		u_mi_certify_data, acceptable msgno(`msgno')
	}
	else { 
		local update "noupdate"
	}

	/* ------------------------------------------------------------ */
				/* set local macros ivars, pvars, 
				   rvars, uvars 			*/
	if ("`varlist'"=="") {
		mi_varying_default
	}
	else {
		mi_varying_specified `varlist'
	}
	/* ------------------------------------------------------------ */
	if ("`update'"=="") { 
		u_mi_certify_data, proper msgno(`msgno')
	}
	/* ------------------------------------------------------------ */
				/* perform check			*/

	tempvar cnt
	scalar `cnt' = 0
	if (`_dta[_mi_M]') {
		local style `_dta[_mi_style]'
		if ("`unregistered'"=="") {
			if ("`ivars'"!="" | "`pvars'"!="") {
				mi_varying_ip_`style' `cnt' "`ivars'" "`pvars'"
				return add
			}
		}

		if ("`uvars'"!="") {
			mi_varying_unreg_`style' `cnt' "`uvars'"
			return add
		}
	}
	if (`cnt'==0) {
		di as txt "  (no problems found)"
	}
	else {
		di as txt "  {hline}"
		if ("`_dta[_mi_style]'"=="flong" | 	///
		    "`_dta[_mi_style]'"=="flongsep") {
			footnote
		}
	}
	/* ------------------------------------------------------------ */
end

program footnote 
	di as txt "{p 2 4 2}"
	di as txt "* super/varying means super varying but would be"
	di as txt "varying if registered as imputed; variables vary"
	di as txt "only where equal to soft missing in {it:m}=0.
	di as txt "{p_end}"
end


					/* parsing of -mi varying-	*/
program mi_varying_default
	c_local ivars `_dta[_mi_ivars]'
	c_local pvars `_dta[_mi_pvars]'
	c_local rvars `_dta[_mi_rvars]'

	local regvars `_dta[_mi_ivars]' `_dta[_mi_pvars]' `_dta[_mi_rvars]'
	unab allvars : _all
	local sysvars "_mi_miss _mi_m _mi_id"
	local uvars : list allvars - regvars
	local uvars : list uvars - sysvars
	if ("`_dta[_mi_style]'"=="wide") {
		local M     `_dta[_mi_M]' 
		local ivars `_dta[_mi_ivars]' `_dta[_mi_pvars]'
		foreach vn of local ivars {
			local list
			forvalues m = 1(1)`M' { 
				local list `list' _`m'_`vn'
			}
			local uvars : list uvars - list
		}
	}
	c_local uvars `uvars'
end

					/* parsing of -mi varying-	*/
program mi_varying_specified
	local fullivars `_dta[_mi_ivars]'
	local fullpvars `_dta[_mi_pvars]'
	local fullrvars `_dta[_mi_rvars]'

	local ivars
	local pvars
	local rvars
	local uvars
	foreach vn of local 0 {
		local in : list vn in fullivars
		if (`in') {
			local ivars `ivars' `vn'
		}
		else {
			local in : list vn in fullpvars
			if (`in') {
				local pvars `pvars' `vn'
			}
			else {
				local in : list vn in fullrvars
				if (`in') {
					local rvars `rvars' `vn'
				}
				else {
					local uvars `uvars' `vn'
				}
			}
		}
	}
	c_local ivars `ivars'
	c_local pvars `pvars'
	c_local rvars `rvars'
	c_local uvars `uvars'
end

					/* gen'l utility of -mi varying- */

program mi_varying_header
end

program mi_varying_msg
	args cnt lhs vlist

	if (`cnt'==0) {
		di as txt ""
		di as txt "             Possible problem   variable names"
		di as txt "  {hline}"
	}
	scalar `cnt' = `cnt' + 1

	local l_lhs = strlen("`lhs'")
	local indent = 29 - strlen("`lhs'")

	di as smcl as txt "{p `indent' 32 2}"
	di as smcl as txt "`lhs':"
	if ("`vlist'"=="") {
		di as smcl as txt "(none)"
	}
	else {
		di as smcl as res "`vlist'"
	}
	di as smcl as txt "{p_end}"
end

					/* wide, -mi varying-		*/

program mi_varying_ip_wide, rclass
	args cnt ivars pvars

	quietly count if _mi_miss 
	if (r(N)==0) { 
		exit
	}

	mi_varying_ip_wide_u `cnt' "imputed" "`ivars'"
	return local ivars `r(nonvarying)'

	mi_varying_ip_wide_u `cnt' "passive" "`pvars'"
	return local pvars `r(nonvarying)'
	
end


program mi_varying_unreg_wide
	exit
end

program mi_varying_ip_wide_u, rclass
	args cnt type vlist

	local varylist
	foreach vn of local vlist {
		wide_value_differs `vn'
		if (r(differs)) {
			local varylist `varylist' `vn'
		}
		local varylist : list uniq varylist 
	}
	local nonvarylist : list vlist - varylist 
	local nonvarylist : list sort nonvarylist
	return local nonvarying `nonvarylist'
	mi_varying_msg `cnt' "`type' nonvarying" "`nonvarylist'"
end

program wide_value_differs, rclass
	args vn
	local M `_dta[_mi_M]'
	quietly {
		forvalues m=1(1)`M' {
			count if `vn'!=_`m'_`vn'
			if (r(N)) {
				return scalar differs = 1
				exit
			}
		}
	}
	return scalar differs = 0
end
		
					/* mlong, -mi varying-		*/
program mi_varying_ip_mlong, rclass sortpreserve
	args cnt ivars pvars

	quietly count if _mi_m==0 & _mi_miss 
	if (r(N)==0) { 
		exit
	}

	sort _mi_m _mi_id

	mi_varying_ip_mlong_u `cnt' "imputed" "`ivars'"
	return local ivars `r(nonvarying)'

	mi_varying_ip_mlong_u `cnt' "passive" "`pvars'"
	return local pvars `r(nonvarying)'

end

program mi_varying_ip_mlong_u, rclass
	args cnt type vlist

	local nonvarylist
	foreach vn of local vlist {
		qui count if `vn'!=`vn'[_mi_id] & _mi_m>0
		if (r(N)==0) {
			local nonvarylist `nonvarylist' `vn'
		}
	}
	local nonvarylist : list sort nonvarylist
	return local nonvarying `nonvarylist'
	mi_varying_msg `cnt' "`type' nonvarying" "`nonvarylist'"
end

	

program mi_varying_unreg_mlong, rclass sortpreserve
	args cnt vlist

	quietly count if _mi_m==0 & _mi_miss 
	if (r(N)==0) { 
		exit
	}

	sort _mi_m _mi_id
	local uvars_v
	foreach vn of local vlist {
		qui count if `vn'!=`vn'[_mi_id] & _mi_m>0
		if (r(N)) {
			local uvars_v `uvars_v' `vn'
		}
	}
	local uvars_v : list sort uvars_v
	return local uvars_v `uvars_v'
	mi_varying_msg `cnt' "unregistered varying" "`uvars_v'"
end

					/* flong, -mi varying-		*/
program mi_varying_ip_flong, rclass
	mi_varying_ip_mlong `0'
	return add
end

		

program mi_varying_unreg_flong, rclass sortpreserve
	args cnt vlist

	qui count if _mi_m==0
	if (r(N)==0 | r(N)==_N) {
		mi_varying_msg `cnt' "unregistered varying" ""
		mi_varying_msg `cnt' "*unregistered super/varying" ""
		mi_varying_msg `cnt' "unregistered super varying" ""
		exit
	}
	local Np1 = r(N)+1
	local in_mgt0 "in `Np1'/l"
	local miss    "_mi_miss[_mi_id]"
	
	sort _mi_m _mi_id
	local uvars_v
	local uvars_s_v
	local uvars_s_s
	foreach vn of local vlist {
		local true "`vn'[_mi_id]"
		qui count if `vn'!=`true' `in_mgt0'
		if (r(N)) {
			qui count if `vn'!=`true' & `miss'==0 `in_mgt0'
			if (r(N)) {
				cap confirm numeric variable `vn'
				if _rc==0 {
					qui count if `vn'!=`true' & ///
						     `true'!=. `in_mgt0'
					if (r(N)) {
						local uvars_s_s `uvars_s_s' `vn'
					}
					else {
						local uvars_s_v `uvars_s_v' `vn'
					}
				}
				else {
					local uvars_s_s `uvars_s_s' `vn'
				}
			}
			else {
				local uvars_v `uvars_v' `vn'
			}
		}
	}
	local uvars_v : list sort uvars_v
	return local uvars_v `uvars_v'
	mi_varying_msg `cnt' "unregistered varying" "`uvars_v'"

	local uvars_s_v : list sort uvars_s_v
	return local uvars_s_v `uvars_s_v'
	mi_varying_msg `cnt' "*unregistered super/varying" "`uvars_s_v'"

	local uvars_s_s : list sort uvars_s_s
	return local uvars_s_s `uvars_s_s'
	mi_varying_msg `cnt' "unregistered super varying" "`uvars_s_s'"
end


					/* flongsep, -mi varying-	*/
program mi_varying_ip_flongsep, rclass
	args cnt ivars pvars

	quietly count if _mi_miss 
	if (r(N)==0) { 
		exit
	}

	preserve

	local name `_dta[_mi_name]'
	local M    `_dta[_mi_M]'
	local allvars `ivars' `pvars'

	quietly {
		keep if _mi_miss
		keep _mi_id `allvars' 
		foreach vn of local allvars {
			rename `vn' _0_`vn'
		}
		sort _mi_id
		tempfile truth
		save "`truth'"

		local ivarying
		local pvarying
		forvalues m=1(1)`M' {
			use _`m'_`name', clear 
			keep _mi_id `allvars' 
			sort _mi_id
			merge 1:1 _mi_id using "`truth'", ///
				nogen sorted norep keep(match) nonotes
			foreach vn of local ivars {
				count if `vn'!=_0_`vn'
				if (r(N)) {
					local ivarying `ivarying' `vn'
				}
			}
			local ivarying : list uniq ivarying
			foreach vn of local pvars {
				count if `vn'!=_0_`vn'
				if (r(N)) {
					local pvarying `pvarying' `vn'
				}
			}
			local pvarying : list uniq pvarying
		}
	}

	local inonvarying : list ivars - ivarying
	local pnonvarying : list pvars - pvarying

	local inonvarying : list sort inonvarying
	return local ivars `inonvarying'
	mi_varying_msg `cnt' "imputed nonvarying" "`inonvarying'"

	local pnonvarying : list sort pnonvarying
	return local pvars `pnonvarying'
	mi_varying_msg `cnt' "passive nonvarying" "`pnonvarying'"
end


program mi_varying_unreg_flongsep, rclass
	args cnt uvars

	preserve

	local name `_dta[_mi_name]'
	local M    `_dta[_mi_M]'

	local uvar_v
	local uvar_s_v
	local uvar_s_s

	quietly {
		keep _mi_id _mi_miss `uvars' 
		foreach vn of local uvars {
			rename `vn' _0_`vn'
		}
		sort _mi_id
		tempfile truth
		save "`truth'"

		forvalues m=1(1)`M' {
			use _`m'_`name', clear 
			keep _mi_id `uvars' 
			sort _mi_id
			merge 1:1 _mi_id using "`truth'", ///
				nogen sorted norep nonotes assert(match)
			foreach vn of local uvars {
				count if `vn'!=_0_`vn'
				if (r(N)) {
					count if `vn'!=_0_`vn' & _mi_miss==0
					if (r(N)) {
cap confirm numeric var `vn'
if _rc==0 {
	count if `vn'!=_0_`vn' & _0_`vn'!=.
	if (r(N)) {
		local uvars_s_s `uvars_s_s' `vn'
		local uvars_s_s : list uniq uvars_s_s
	}
	else {
		local uvars_s_v `uvars_s_v' `vn'
		local uvars_s_v : list uniq uvars_s_v
	}
}
else {
	local uvars_s_s `uvars_s_s' `vn'
	local uvars_s_s : list uniq uvars_s_s
}
					}
					else {
						local uvars_v `uvars_v' `vn'
						local uvars_v : ///
						  list uniq uvars_v
					}
				}
			}
		}
	}

	local uvars_v : list sort uvars_v
	return local uvars_v `uvars_v'
	mi_varying_msg `cnt' "unregistered varying" "`uvars_v'"

	local uvars_s_v : list sort uvars_s_v
	return local uvars_s_v `uvars_s_v'
	mi_varying_msg `cnt' "*unregistered super/varying" "`uvars_s_v'"

	local uvars_s_s : list sort uvars_s_s
	return local uvars_s_s `uvars_s_s'
	mi_varying_msg `cnt' "unregistered super varying" "`uvars_s_s'"
end
