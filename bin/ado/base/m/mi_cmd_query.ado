*! version 1.0.1  16mar2009

/*
	mi query

	returns
	   macros:
		r(style)	<ext_style> 
		r(name)		if style==flongsep or flongsep_sub

	   scalars:
		r(update)	secs. since last -mi update-
		r(m)		m (data==flongsep) 
		r(M)		M (all other)

*/

program mi_cmd_query, rclass
	version 11.0

	syntax

	u_mi_how_set style
	if ("`style'"=="") {
		return local style ""
		return scalar update = .
		return scalar m = 0
		return scalar M = 0
		di as smcl as txt "(data not {bf:mi set})"
		exit
	}
	
	return local style `style'

	if ("`style'"=="flongsep_sub") {
		local name `_dta[_mi_name]'
		local m    `_dta[_mi_m]'

		return local name `name'
		return scalar m = `m'
		return scalar update = .

		di as smcl as txt "{p}"
		di as smcl "data {it:m}=`m' of flongsep `name'"
		di as smcl "{p_end}"
		exit
	}

	return scalar M = `_dta[_mi_M]'
	if ("`style'"=="flongsep") {
		local name `_dta[_mi_name]'
		return local name `name'
		di as txt "data " as res "mi set `style' `name'" ///
		as txt ", M = " as res "`_dta[_mi_M]'"
	}
	else {
		di as txt "data " as res "mi set `style'" ///
		as txt ", M = " as res "`_dta[_mi_M]'"
	}

	local uptime `_dta[_mi_update]'
	if ("`uptime'"!="") {
		local uptimetxt : di %tc `uptime'*1000
		u_mi_curtime get cur
		u_mi_time_diff difftxt : `cur' `uptime'
		return scalar update = r(secs)
	
		di as smcl as txt "{p}"
		di as smcl "last {bf:mi update} `uptimetxt'," 
		di as smcl "`difftxt'"
		di as smcl "{p_end}"
	}
	else {
		return scalar update = .
	}
end
