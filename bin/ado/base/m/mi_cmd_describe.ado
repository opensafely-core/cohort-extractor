*! version 1.0.2  24mar2011

					/* mi describe			*/
/*
	mi describe [, detail noupdate notime]

	option notime is undocumented -- suppresses time display.

	returns:
	   scalar:
		r(update)       # of secs. since last -mi update-
		r(N)            # of obs. (logical)
		r(N_incomplete) # of incomplete obs.
		r(N_complete)   # of complete obs.
		r(M)		M
	   macros:
		r(style)	 <style>
		r(ivars)        names of imputed vars
		r(_0_miss_ivars) # == . in ea. ivar in m=0
		r(_0_hard_ivars) # > . in ea. ivar in m=0
		r(pvars)        names of passive vars
		r(_0_miss_pvars) # >= . in ea. pvar in m=0

		r(_1_miss_ivars) m=1, if detail 
		r(_1_miss_pvars) m=1, if detail 
				 etc. 
*/

program mi_cmd_describe, rclass
	version 11.0

	u_mi_assert_set
	syntax [, Detail noTIME noUPdate]
	if ("`detail'"!="") { 
		if ("`update'"=="") {
			mi update
		}
	}
	else {
		u_mi_certify_data, acceptable
	}

	/* ------------------------------------------------------------ */
	local style `_dta[_mi_style]'
	mi_des_basestats_`style'
	local complete  = r(complete)
	local incomplete = r(incomplete)
	local total     = r(total)
	local M         = r(M)
	local sysvars     "`r(sysvars)'"
	/* also defines 
		ivar0_`i'    printable string for m=`i'
		pvar0_`i'    printable string for m=`i'
		missivar_0   # # ... #
		hardivar_0   # # ... #
		misspvar_0   # # ... #
	*/

	if ("`detail'"!="" & `M') { 
		mi_des_fullstats_`style'
		/* defines macros 
			ivar_`i'	string to print, i over ivars
			pvar_`i'	string to print, i over pvars

			_`m'_ivars	#s of missing ivars, m = 1 .. `M'
			_`m'_pvars	#s of missing ivars, m = 1 .. `M'
		*/
		forvalues m=1(1)`M' {
			ret local _`m'_miss_ivars `_`m'_ivars'
			ret local _`m'_miss_pvars `_`m'_pvars'
		}
	}

	/* ------------------------------------------------------------ */
	/* return scalar update ... set below */
	return scalar M = `M'
	return scalar N_complete = `complete'
	return scalar N_incomplete = `incomplete'
	return scalar N = `total'
	return local style "`style'"
	return local ivars "`_dta[_mi_ivars]'"
	return local pvars "`_dta[_mi_pvars]'"
	return local rvars "`_dta[_mi_rvars]'"
	return local _0_miss_ivars "`missivar_0'"
	return local _0_hard_ivars "`hardivar_0'"
	return local _0_miss_pvars "`misspvar_0'"

	/* ------------------------------------------------------------ */

	di
	di as smcl as txt "{p 2 10 1}"
	di as smcl "Style:"
	if ("`style'"=="flongsep") { 
		di as smcl "{res:`style' `_dta[_mi_name]'}"
	}
	else {
		di as smcl "{res:`style'}{break}"
	}
	local uptime `_dta[_mi_update]'
	if ("`uptime'"!="") {
		local uptimetxt : di %tc `uptime'*1000
		u_mi_curtime get cur
		u_mi_time_diff difftxt : `cur' `uptime'
		return scalar update = r(secs)
	
		if ("`time'"=="") {
			di as smcl "{break}last {bf:mi update} `uptimetxt'," 
			di as smcl "`difftxt'"
		}
	}
	else {
		return scalar update = .
	}
	di

	/* ------------------------------------------------------------ */
	di as txt "  Obs.:   complete  " as res %11.0fc `complete'

	local imputations = cond(`M'==1, "imputation", "imputations")
	local imp : di %11.0fc `M'
	local imp = strtrim("`imp'")
	di as txt _col(11) "incomplete" as res %11.0fc `incomplete' ///
		 as txt "  ({it:M} = {res:`imp'} `imputations')"
	di as smcl _col(11) "{hline 21}"

	di as txt _col(11) "total     " as res %11.0fc `total'
	di

	/* ------------------------------------------------------------ */

	local n : word count `_dta[_mi_ivars]'
	local semicolon = cond(`n'==0, "", ";")

	di as smcl as txt "{p 2 20 1}"
	di as smcl "Vars.:  imputed:  `n'`semicolon'
	local vars `_dta[_mi_ivars]'
	local i 0
	foreach v of local vars { 
		local ++i
		local n : word count `ivar_`i''
		if (`n') {
			di as smcl "`v'(`ivar0_`i''; `ivar_`i'')"
		}
		else {
			di as smcl "`v'(`ivar0_`i'')"
		}
	}
	di as smcl "{p_end}"

	local n : word count `_dta[_mi_pvars]'
	local semicolon = cond(`n'==0, "", ";")
	di
	di as smcl as txt "{p 10 20 1}"
	di as smcl "passive:  `n'`semicolon'
	local vars `_dta[_mi_pvars]'
	local i 0
	foreach v of local vars { 
		local ++i
		local n : word count `pvar_`i''
		if (`n') { 
			di as smcl "`v'(`pvar0_`i''; `pvar_`i'')"
		}
		else {
			di as smcl "`v'(`pvar0_`i'')"
		}
	}
	di as smcl "{p_end}"

	local n : word count `_dta[_mi_rvars]'
	local semicolon = cond(`n'==0, "", ";")
	di
	di as smcl as txt "{p 10 20 1}"
	di as smcl "regular:  `n'`semicolon'
	if (`n') {
		di as smcl as txt "`_dta[_mi_rvars]'"
	}
	di as smcl "{p_end}"

	local n : word count `sysvars'
	local semicolon = cond(`n'==0, "", ";")
	di
	di as smcl as txt "{p 10 20 1}"
	di as smcl "system:{bind:   }`n'`semicolon'
	if (`n') {
		di as smcl as txt "`sysvars'"
	}
	di as smcl "{p_end}"

	unab vars : _all
	local tosub `_dta[_mi_ivars]' `_dta[_mi_pvars]' ///
		   `_dta[_mi_rvars]' `sysvars'
	local vars : list vars - tosub
	if ("`style'"=="wide") {
		local tosub 
		local ivars `_dta[_mi_ivars]'
		local pvars `_dta[_mi_pvars]'
		forvalues i=1(1)`M' {
			foreach v of local ivars {
				local tosub `tosub' _`i'_`v'
			}
			foreach v of local pvars {
				local tosub `tosub' _`i'_`v'
			}
		}
		local vars : list vars - tosub
	}

	local n : word count `vars'
	di
	di as smcl as txt "{p 9 4 1}"
	if (`n'==0) { 
		di as smcl "(there are no unregistered variables)"
	}
	else if (`n'==1) {
		di as smcl "(there is one unregistered variable;"
		di as smcl "`vars')"
	}
	else if (`n'<5) {
		di as smcl "(there are `n' unregistered variables;" 
		di as smcl "`vars')"
	}
	else {
		di as smcl "(there are `n' unregistered variables)"
	}
	di as smcl "{p_end}"
end



	

program mi_des_basestats_wide, rclass
	quietly {
		count if _mi_miss
		return scalar incomplete = r(N)
		return scalar total = _N
		return scalar complete = _N - return(incomplete)
		return scalar M = `_dta[_mi_M]'
		return local sysvars "_mi_miss"

		local ivars `_dta[_mi_ivars]'
		local pvars `_dta[_mi_pvars]'
		local missivar_0 
		local hardivar_0
		local misspvar_0
		local i 0
		foreach v of local ivars {
			local ++i
			count if `v'==.
			local missivar_0 `missivar_0' `r(N)'
			local toadd "{res:`r(N)'}"
			local _0_miss_ivar `_0_
			count if `v'>.
			local hardivar_0 `hardivar_0' `r(N)'
			if (r(N)) { 
				local toadd "`toadd'+{res:`r(N)'}"
			}
			c_local ivar0_`i' `toadd'
		}
		c_local missivar_0 `missivar_0'
		c_local hardivar_0 `hardivar_0'
		local i 0
		foreach v of local pvars {
			local ++i
			count if `v'>=.
			local misspvar_0 `misspvar_0' `r(N)'
			c_local pvar0_`i' {res:`r(N)'}
		}
		c_local misspvar_0 `misspvar_0'
	}
end
		
program mi_des_basestats_flong, rclass
	quietly {
		count if _mi_miss & _mi_m==0
		return scalar incomplete = r(N)
		count if _mi_m==0
		return scalar total = r(N)
		return scalar complete = return(total) - return(incomplete)
		return scalar M = `_dta[_mi_M]'
		return local sysvars "_mi_m _mi_id _mi_miss"

		local ivars `_dta[_mi_ivars]'
		local pvars `_dta[_mi_pvars]'
		local missivar_0
		local hardivar_0
		local misspvar_0

		local i 0
		foreach v of local ivars {
			local ++i
			count if `v'==. & _mi_m==0
			local missivar_0 `missivar_0' `r(N)'
			local toadd "{res:`r(N)'}"
			count if `v'>. & _mi_m==0
			local hardivar_0 `hardivar_0' `r(N)'
			if (r(N)) { 
				local toadd "`toadd'+{res:`r(N)'}"
			}
			c_local ivar0_`i' `toadd'
		}
		c_local missivar_0 "`missivar_0'"
		c_local hardivar_0 "`hardivar_0'"
		local i 0
		foreach v of local pvars {
			local ++i
			count if `v'>=. & _mi_m==0
			local misspvar_0 `misspvar_0' `r(N)'
			c_local pvar0_`i' {res:`r(N)'}
		}
		c_local misspvar_0 "`misspvar_0'"
	}
end

program mi_des_basestats_mlong, rclass
	quietly {
		count if _mi_miss & _mi_m==0
		return scalar incomplete = r(N)
		count if _mi_m==0
		return scalar total = r(N)
		return scalar complete = return(total) - return(incomplete)
		return scalar M = `_dta[_mi_M]'
		return local sysvars "_mi_m _mi_id _mi_miss"

		local ivars `_dta[_mi_ivars]'
		local pvars `_dta[_mi_pvars]'
		local missivar_0
		local hardivar_0
		local misspvar_0
		local i 0
		foreach v of local ivars {
			local ++i
			count if `v'==. & _mi_m==0
			local missivar_0 `missivar_0' `r(N)'
			local toadd "{res:`r(N)'}"
			count if `v'>. & _mi_m==0
			local hardivar_0 `hardivar_0' `r(N)'
			if (r(N)) { 
				local toadd "`toadd'+{res:`r(N)'}"
			}
			c_local ivar0_`i' `toadd'
		}
		c_local missivar_0 "`missivar_0'"
		c_local hardivar_0 "`hardivar_0'"
		local i 0
		foreach v of local pvars {
			local ++i
			count if `v'>=. & _mi_m==0
			local misspvar_0 `misspvar_0' `r(N)'
			c_local pvar0_`i' {res:`r(N)'}
		}
		c_local misspvar_0 "`misspvar_0'"
	}
end

program mi_des_basestats_flongsep, rclass

	local missivar_0
	local hardivar_0
	local misspvar_0
	quietly {
		count if _mi_miss
		return scalar incomplete = r(N)
		return scalar total = _N
		return scalar complete = _N - return(incomplete)
		return scalar M = `_dta[_mi_M]'
		return local sysvars "_mi_id _mi_miss"

		local ivars `_dta[_mi_ivars]'
		local pvars `_dta[_mi_pvars]'
		local i 0
		foreach v of local ivars {
			local ++i
			count if `v'==.
			local missivar_0 `missivar_0' `r(N)'
			local toadd "{res:`r(N)'}"
			count if `v'>.
			local hardivar_0 `hardivar_0' `r(N)'
			if (r(N)) { 
				local toadd "`toadd'+{res:`r(N)'}"
			}
			c_local ivar0_`i' `toadd'
		}
		c_local missivar_0 `missivar_0'
		c_local hardivar_0 `hardivar_0'
		local i 0
		foreach v of local pvars {
			local ++i
			count if `v'>=.
			local misspvar_0 `misspvar_0' `r(N)'
			c_local pvar0_`i' {res:`r(N)'}
		}
		c_local misspvar_0 `misspvar_0'
	}
end


program mi_des_fullstats_wide
		/* defines macros 
			ivar_`i', 	i over ivars
			pvar_`i'	i over pvars 
			_`m'_ivars	m over imputations
			_`m'_pvars	m over imputations
		*/
	local M    `_dta[_mi_M]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'

	quietly {
		local i 0
		foreach v of local ivars {
			local ++i
			local mlist 
			forvalues m=1(1)`M' {
				count if _`m'_`v'==.
				local _`m'_ivars `_`m'_ivars' `r(N)'
				local mlist `mlist' `r(N)'
			}
			mi_des_compress mlist : "`mlist'"
			c_local ivar_`i' `mlist'
		}
		local i 0
		foreach v of local pvars {
			local ++i
			local mlist 
			forvalues m=1(1)`M' {
				count if _`m'_`v'>=.
				local _`m'_pvars `_`m'_pvars' `r(N)'
				local mlist `mlist' `r(N)'
			}
			c_local rawpvar_`i' `mlist'
			mi_des_compress mlist : "`mlist'"
			c_local pvar_`i' `mlist'
		}
		forvalues m=1(1)`M' {
			c_local _`m'_ivars `_`m'_ivars'
			c_local _`m'_pvars `_`m'_pvars'
		}
	}
end

program mi_des_fullstats_mlong
		/* defines macros 
			ivar_`i', 	i over ivars
			pvar_`i'	i over pvars 
			_`m'_ivars	m over imputations
			_`m'_pvars	m over imputations
		*/
	local M    `_dta[_mi_M]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'

	quietly {
		local i 0
		foreach v of local ivars {
			local ++i
			local mlist 
			forvalues m=1(1)`M' {
				count if `v'==. & _mi_m==`m'
				local _`m'_ivars `_`m'_ivars' `r(N)'
				local mlist `mlist' `r(N)'
			}
			mi_des_compress mlist : "`mlist'"
			c_local ivar_`i' `mlist'
		}
		local i 0
		foreach v of local pvars {
			local ++i
			local mlist 
			forvalues m=1(1)`M' {
				count if `v'>=. & ///
					((_mi_m==0 & _mi_miss==0) | _mi_m==`m')
				local _`m'_pvars `_`m'_pvars' `r(N)'
				local mlist `mlist' `r(N)'
			}
			mi_des_compress mlist : "`mlist'"
			c_local pvar_`i' `mlist'
		}
		forvalues m=1(1)`M' {
			c_local _`m'_ivars `_`m'_ivars'
			c_local _`m'_pvars `_`m'_pvars'
		}
	}
end


program mi_des_fullstats_flong
		/* defines macros 
			ivar_`i', 	i over ivars
			pvar_`i'	i over pvars 
			_`m'_ivars	m over imputations
			_`m'_pvars	m over imputations
		*/
	local M    `_dta[_mi_M]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'

	quietly {
		local i 0
		foreach v of local ivars {
			local ++i
			local mlist 
			forvalues m=1(1)`M' {
				count if `v'==. & _mi_m==`m'
				local _`m'_ivars `_`m'_ivars' `r(N)'
				local mlist `mlist' `r(N)'
			}
			mi_des_compress mlist : "`mlist'"
			c_local ivar_`i' `mlist'
		}
		local i 0
		foreach v of local pvars {
			local ++i
			local mlist 
			forvalues m=1(1)`M' {
				count if `v'>=. & _mi_m==`m'
				local _`m'_pvars `_`m'_pvars' `r(N)'
				local mlist `mlist' `r(N)'
			}
			mi_des_compress mlist : "`mlist'"
			c_local pvar_`i' `mlist'
		}
		forvalues m=1(1)`M' {
			c_local _`m'_ivars `_`m'_ivars'
			c_local _`m'_pvars `_`m'_pvars'
		}
	}
end

program mi_des_fullstats_flongsep
		/* defines macros 
			ivar_`i', 	i over ivars
			pvar_`i'	i over pvars 
			_`m'_ivars	m over imputations
			_`m'_pvars	m over imputations
		*/
	local M    `_dta[_mi_M]'
	local name `_dta[_mi_name]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'

	if (`M'==0) {
		exit
	}

	preserve 
	quietly {
		local i 0
		forvalues m=1(1)`M' { 
			local ++i
			use _`m'_`name', clear 

			local ivar_`i'
			local pvar_`i'
			local i 1
			foreach v of local ivars {
				count if `v'==.
				local _`m'_ivars `_`m'_ivars' `r(N)'
				local ivar_`i' `ivar_`i'' `r(N)'
				local ++i
			}
			local i 1
			foreach v of local pvars {
				count if `v'==.
				local _`m'_pvars `_`m'_pvars' `r(N)'
				local pvar_`i' `ivar_`i'' `r(N)'
				local ++i
			}
			c_local _`m'_ivars `_`m'_ivars'
			c_local _`m'_pvars `_`m'_pvars'
		}

		local i 0
		foreach v of local ivars {
			local ++i
			mi_des_compress topost : "`ivar_`i''"
			c_local ivar_`i' `topost'
		}
		foreach v of local pvars {
			mi_des_compress topost : "`pvar_`i''"
			c_local pvar_`i' `topost'
		}
	}
end
		
program mi_des_compress
	args toret colon  oldlist

	local lastel (-1)
	local cnt 0
	local comma
	foreach el of local oldlist {
		if (`el'!=`lastel') {
			if (`cnt') {
				if (`cnt'==1) {
					local toadd "{res:`lastel'}"
				}
				else {
					local toadd "`cnt'*{res:`lastel'}"
				}
				local list "`list'`comma'`toadd'"
				local comma ", "
			}
			local cnt 1
			local lastel `el'
		}
		else {
			local ++cnt
		}
	}
	if (`cnt') {
		if (`cnt'==1) {
			local toadd "{res:`lastel'}"
		}
		else {
			local toadd "`cnt'*{res:`lastel'}"
		}
		local list "`list'`comma'`toadd'"
	}
	c_local `toret' "`list'"
end
