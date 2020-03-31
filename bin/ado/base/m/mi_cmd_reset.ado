*! version 1.0.0  28may2009

/*
	mi reset <varlist> [=exp] [if] [, m(<numlist>) noUPdate SYSCALL]

	returns r(N), number of changes made
*/


program mi_cmd_reset, rclass
	version 11

	u_mi_assert_set
	syntax varlist [=exp] [if] [,				///
		M(numlist integer)				///
		noUPdate 					///
		SYSCALL ]

	if ("`syscall'"=="") {
		u_mi_certify_data, acceptable
	}
	else {
		local update noupdate
	}

	mata: check_and_order_numlist("m", `_dta[_mi_M]')


	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'

	local iv
	local pv
	foreach v of local varlist {
		local in : list posof "`v'" in ivars
		if (`in') {
			local iv `iv' `v'
		}
		else {
			local in : list posof "`v'" in pvars
			if (`in') {
				local pv `pv' `v'
			}
			else {
				not_imp_pass_error `v'
				/* NOTREACHED*/
			}
		}
	}

	if (`_dta[_mi_M]'==0) {
		di as txt "({it:M}=0; no action taken)"
		return scalar N = 0
		exit
	}
	if (_N==0) { 
		di as txt "({_N}==0; no action taken)"
		return scalar N = 0
		exit
	}

	if ("`update'"=="") {
		u_mi_certify_data, proper
	}

	mi_cmd_reset_`_dta[_mi_style]' "`iv'" "`pv'" ///
				`"`exp'"' `"`if'"' "`m'"
	return scalar N = r(N)
end

program mi_cmd_reset_mlong, sort rclass
	args iv pv eqexp ifexp mlist 

	sort _mi_m _mi_id
	qui count if _mi_m==0
	local in "in `=r(N)+1'/l"

	tempvar touse tofix
	qui gen byte `touse' = 0
	qui replace  `touse' = 1 `ifexp' `in'


	if (`"`eqexp'"' != "") {
		local hasexp 1
		tempvar val
		qui gen double `val' `eqexp' if `touse' `in'
	}
	else {
		local hasexp 0
	}

	local cnt 0
	if ("`mlist'"=="") {
		quietly {
			foreach v of local iv {
				local tru `v'[_mi_id]
				gen byte `tofix'=0
				replace `tofix'=1 if `touse' & `tru'==. `in'

				if (`hasexp') { 
					if ("`: type `v''" == "float") {
						replace `tofix'=0 if ///
						`v'==float(`val') & `tofix' `in'
					}
					else {
						replace `tofix'=0 if ///
						`v'==`val' & `tofix' `in'
					}
				}
				else {
					replace `tofix'=0 ///
						if `v'==. & `tofix' `in'
				}

				count if `tofix' `in'
				local cnt = `cnt' + r(N)

				if (`hasexp') {
					replace `v' = `val' if `tofix' `in'
				}
				else {
					replace `v' = `tru' if `tofix' `in'
				}
				drop `tofix'
			}
			foreach v of local pv {
				local tru `v'[_mi_id]
				gen byte `tofix'=0 
				replace `tofix'=1 if `touse' `in'

				if (`hasexp') {
					if ("`: type `v''" == "float") {
						replace `tofix'=0 if ///
						`v'==float(`val') & `tofix' `in'
					}
					else {
						replace `tofix'=0 if ///
						`v'==`val' & `tofix' `in'
					}
				}
				else {
					replace `tofix'=0 if ///
					`v'==`tru' & `tofix' `in'
				}

				count if `tofix' `in'
				local cnt = `cnt' + r(N)

				if (`hasexp') {
					replace `v' = `val' if `tofix' `in'
				}
				else {
					replace `v' = `tru' if `tofix' `in'
				}
				drop `tofix'
			}
		}
		return scalar N = `cnt'
		updated_msg `cnt'
		exit
	}

	quietly {
		foreach m of local mlist {
			foreach v of local iv {
				local tru `v'[_mi_id]
				gen byte `tofix'=0
				replace `tofix'=1 if `touse' & `tru'==. ///
					& _mi_m==`m' `in'

				if (`hasexp') { 
					if ("`: type `v''" == "float") {
						replace `tofix'=0 if ///
						`v'==float(`val') & `tofix' `in'
					}
					else {
						replace `tofix'=0 if ///
						`v'==`val' & `tofix' `in'
					}
				}
				else {
					replace `tofix'=0 ///
						if `v'==. & `tofix' `in'
				}

				count if `tofix' `in'
				local cnt = `cnt' + r(N)

				if (`hasexp') {
					replace `v' = `val' if `tofix' `in'
				}
				else {
					replace `v' = `tru' if `tofix' `in'
				}
				drop `tofix'
			}
			foreach v of local pv {
				local tru `v'[_mi_id]
				gen byte `tofix'=0 
				replace `tofix'=1 if `touse' & _mi_m==`m' `in'

				if (`hasexp') {
					if ("`: type `v''" == "float") {
						replace `tofix'=0 if ///
						`v'==float(`val') & `tofix' `in'
					}
					else {
						replace `tofix'=0 if ///
						`v'==`val' & `tofix' `in'
					}
				}
				else {
					replace `tofix'=0 if ///
					`v'==`tru' & `tofix' `in'
				}

				count if `tofix' `in'
				local cnt = `cnt' + r(N)

				if (`hasexp') {
					replace `v' = `val' if `tofix' `in'
				}
				else {
					replace `v' = `tru' if `tofix' `in'
				}
				drop `tofix'
			}
		}
	}
	return scalar N = `cnt'
	updated_msg `cnt'

end

program updated_msg
	args cnt

	local values = cond(`cnt'==1, "value", "values")
	di as txt "(`cnt' `values' reset)"
end


program mi_cmd_reset_flong, sort rclass
	args iv pv eqexp ifexp mlist 

	sort _mi_m _mi_id
	qui count if _mi_m==0
	local in "in `=r(N)+1'/l"

	tempvar touse tofix
	qui gen byte `touse' = 0
	qui replace  `touse' = 1 `ifexp' `in'


	if (`"`eqexp'"' != "") {
		local hasexp 1
		tempvar val
		qui gen double `val' `eqexp' if `touse' `in'
	}
	else {
		local hasexp 0
	}

	local cnt 0
	if ("`mlist'"=="") {
		quietly {
			foreach v of local iv {
				local tru `v'[_mi_id]
				gen byte `tofix'=0
				replace `tofix'=1 if `touse' & `tru'==. `in'

				if (`hasexp') { 
					if ("`: type `v''" == "float") {
						replace `tofix'=0 if ///
						`v'==float(`val') & `tofix' `in'
					}
					else {
						replace `tofix'=0 if ///
						`v'==`val' & `tofix' `in'
					}
				}
				else {
					replace `tofix'=0 ///
						if `v'==. & `tofix' `in'
				}

				count if `tofix' `in'
				local cnt = `cnt' + r(N)

				if (`hasexp') {
					replace `v' = `val' if `tofix' `in'
				}
				else {
					replace `v' = `tru' if `tofix' `in'
				}
				drop `tofix'
			}
			foreach v of local pv {
				local tru `v'[_mi_id]
				gen byte `tofix'=0 
				replace `tofix'=1 ///
					if `touse' & _mi_miss[_mi_id] `in'

				if (`hasexp') {
					if ("`: type `v''" == "float") {
						replace `tofix'=0 if ///
						`v'==float(`val') & `tofix' `in'
					}
					else {
						replace `tofix'=0 if ///
						`v'==`val' & `tofix' `in'
					}
				}
				else {
					replace `tofix'=0 if ///
					`v'==`tru' & `tofix' `in'
				}

				count if `tofix' `in'
				local cnt = `cnt' + r(N)

				if (`hasexp') {
					replace `v' = `val' if `tofix' `in'
				}
				else {
					replace `v' = `tru' if `tofix' `in'
				}
				drop `tofix'
			}
		}
		return scalar N = `cnt'
		updated_msg `cnt'
		exit
	}

	quietly {
		foreach m of local mlist {
			foreach v of local iv {
				local tru `v'[_mi_id]
				gen byte `tofix'=0
				replace `tofix'=1 if `touse' & `tru'==. ///
					& _mi_m==`m' `in'

				if (`hasexp') { 
					if ("`: type `v''" == "float") {
						replace `tofix'=0 if ///
						`v'==float(`val') & `tofix' `in'
					}
					else {
						replace `tofix'=0 if ///
						`v'==`val' & `tofix' `in'
					}
				}
				else {
					replace `tofix'=0 ///
						if `v'==. & `tofix' `in'
				}

				count if `tofix' `in'
				local cnt = `cnt' + r(N)

				if (`hasexp') {
					replace `v' = `val' if `tofix' `in'
				}
				else {
					replace `v' = `tru' if `tofix' `in'
				}
				drop `tofix'
			}
			foreach v of local pv {
				local tru `v'[_mi_id]
				gen byte `tofix'=0 
				replace `tofix'=1 if `touse' & _mi_m==`m' ///
					& _mi_miss[_mi_id] `in'

				if (`hasexp') {
					if ("`: type `v''" == "float") {
						replace `tofix'=0 if ///
						`v'==float(`val') & `tofix' `in'
					}
					else {
						replace `tofix'=0 if ///
						`v'==`val' & `tofix' `in'
					}
				}
				else {
					replace `tofix'=0 if ///
					`v'==`tru' & `tofix' `in'
				}

				count if `tofix' `in'
				local cnt = `cnt' + r(N)

				if (`hasexp') {
					replace `v' = `val' if `tofix' `in'
				}
				else {
					replace `v' = `tru' if `tofix' `in'
				}
				drop `tofix'
			}
		}
	}
	return scalar N = `cnt'
	updated_msg `cnt'

end


program mi_cmd_reset_wide, rclass
	preserve 

	quietly mi convert mlong, clear noupdate
	mi_cmd_reset_mlong `0'
	return scalar N = r(N)
	if (r(N)) {
		mi convert wide, clear noupdate
		restore, not
	}
end


program mi_cmd_reset_flongsep, rclass
	args iv pv eqexp ifexp mlist 

	local name "`_dta[_mi_name]'"
	local M     `_dta[_mi_M]'
	preserve

	local ipv `iv' `pv'

	keep _mi_id _mi_miss `ipv'
	local todrop
	foreach v of local ipv {
		rename `v' _0_`v'
		local todrop `todrop' _0_`v'
	}
	tempfile base
	sort _mi_id 
	mata: u_mi_rm_dta_chars()
	qui save "`base'", replace

	tempvar touse val tofix


	if ("`mlist'"=="") {
		local forcmd "forvalues m=1(1)`M'" 
	}
	else {
		local forcmd "foreach m of local mlist"
	}

	quietly {
		local cnt 0
		`forcmd' {
noi di "DOING m=`m'"
			use _`m'_`name', clear 
			sort _mi_id
			merge 1:1 _mi_id using "`base'", ///
				sorted assert(match) nogen norep 
			gen byte `touse' = 0
			replace `touse' = 1 `ifexp'

			if (`"`eqexp'"' != "") {
				local hasexp 1
				qui gen double `val' `eqexp' if `touse'
			}
			else {
				local hasexp 0
			}

			foreach v of local iv {
				gen byte `tofix'=0
				replace `tofix'=1 if `touse' & _0_`v'==.

				if (`hasexp') { 
					if ("`: type `v''" == "float") {
						replace `tofix'=0 if ///
						`v'==float(`val') & `tofix'
					}
					else {
						replace `tofix'=0 if ///
						`v'==`val' & `tofix'
					}
				}
				else {
					replace `tofix'=0 if `v'==. & `tofix'
				}

				count if `tofix' `in'
				local cnt = `cnt' + r(N)

				if (`hasexp') {
					replace `v' = `val' if `tofix'
				}
				else {
					replace `v' = _0_`v' if `tofix' 
				}
				drop `tofix'
			}
			foreach v of local pv {
				gen byte `tofix'=0 
				replace `tofix'=1 if `touse' & _mi_miss

				if (`hasexp') {
					if ("`: type `v''" == "float") {
						replace `tofix'=0 if ///
						`v'==float(`val') & `tofix'
					}
					else {
						replace `tofix'=0 if ///
						`v'==`val' & `tofix'
					}
				}
				else {
					replace `tofix'=0 if ///
					`v'==_0_`v' & `tofix'
				}

				count if `tofix' `in'
				local cnt = `cnt' + r(N)

				if (`hasexp') {
					replace `v' = `val' if `tofix'
				}
				else {
					replace `v' = _0_`v' if `tofix'
				}
				drop `tofix'
			}
			drop _mi_miss `todrop' `touse' 
			capture drop `val'
			save _`m'_`name', replace
		}
	}
	return scalar N = `cnt'
	updated_msg `cnt'
end


program not_imp_pass_error
	args varname

		
	di as err "{p 0 4 2}
	di as err "variable {bf:`varname'} not registered"
	di as err "as imputed or passive"
	di as err "{p_end}
	exit 198
end


mata:
void check_and_order_numlist(string scalar macname, real scalar M)
{
	real scalar		i, v, lastv
	real colvector		numlist
	string rowvector	list

	if (length(list = tokens(st_local(macname))) == 0) return
	numlist = sort(strtoreal(list)', 1)
	lastv = 0
	for (i=1; i<=length(numlist); i++) {
		v = numlist[i]
		if (v<1 | v>M | v!=floor(v)) {
			errprintf("option {bf:m()} contains invalid elements\n")
			errprintf("{p 4 4 2}\n")
			errprintf(
			    "1 <= {it:m} <= %g, {it:m} integral, required\n", 
			    M)
			errprintf("{p_end}\n")
			exit(198)
		}
		if (v==lastv) {
			errprintf("option {bf:m()} contains repeated values\n")
			exit(198)
		}
		lastv = v
	}
	st_local(macname, invtokens(strofreal(numlist)'))

}

end
