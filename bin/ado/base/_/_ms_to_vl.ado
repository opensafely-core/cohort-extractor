*! version 1.0.2  29jan2015
program _ms_to_vl, rclass
	version 12
	syntax [, matrix(string) prefix(name) nopar NOFVLABel]

	if "`par'" == "" {
		local strippar "*"
	}
	else	local strippar StripPar

	local plen : length local prefix
	if `plen' > 8 {
		di as err "invalid prefix() option;"
		di as err "prefix name length may not exceed 8 characters"
		exit 198
	}
	if `plen' == 0 {
		local prefix _vl_
	}
	if `:length local matrix' {
		if bsubstr("`matrix'",1,2) == "r(" {
			tempname m
			matrix `m' = `matrix'
			local matrix : copy local m
		}
		local colna : colfull `matrix', quote
		local matrix matrix(`matrix')
	}
	else	local colna : colfull e(b), quote

	_ms_eq_info, `matrix'
	local keq = r(k_eq)
	forval eq = 1/`keq' {
		local k`eq' = r(k`eq')
	}
	local vlist	/* empty */
	local kv	0
	forval eq = 1/`keq' {
		forval el = 1/`k`eq'' {
			gettoken spec colna : colna, quotes

			_ms_element_info,	el(`el')	///
						eq(#`eq')	///
						width(900)	///
						`matrix'	///
						coding		///
						`nofvlabel'	///
								 // blank
			local k = r(k)
			local labels `"`r(level)'"'
			forval i = 1/`k' {
				gettoken LA`i' labels : labels, bind
			}

			_ms_parse_parts `spec'
			if r(type) == "interaction" {
				forval i = 1/`k' {
					local LE`i' `"`r(level`i')'"'
					local NA`i' `"`r(name`i')'"'
				}
			}
			else if r(type) == "factor" {
				local k 1
				local LE1 `"`r(level)'"'
				local NA1 `"`r(name)'"'
			}
			else {
				local k 0
			}
			forval i = 1/`k' {
			    if bsubstr(`"`LA`i''"',1,1) == "(" {
				local j : list posof "`NA`i''" in vlist
				if `j' == 0 {
					local ++kv
					local j = `kv'
					capture label list `prefix'`j'
					if c(rc) == 0 {
						di as err ///
"value label named `prefix'`j' already defined"
						exit 459
					}
					local vlist `vlist' `NA`i''
				}
				`strippar' LA`i' : `"`LA`i''"'
				label define `prefix'`j'	///
					`LE`i'' `"`LA`i''"',	///
					add modify
			    }
			}
		}
	}
	local VLIST : copy local vlist
	forval i = 1/`kv' {
		gettoken var VLIST : VLIST
		return local name`i' `var'
		return local vl`i' `prefix'`i'
	}
	return scalar k_names = `kv'
end

program StripPar
	args lname COLON label

	gettoken string rest : label , parse("()") match(haspar)
	if "`haspar' `rest'" == "( " {
		c_local `lname' `"`string'"'
	}
end

exit
