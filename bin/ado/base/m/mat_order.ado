*! version 1.0.2  16apr2003
program define mat_order
	version 8
	args b12 colon b1 b2

	if "`colon'" != ":" {
		exit 198
	}
	if rowsof(`b1')!=rowsof(`b2') | colsof(`b1')!=colsof(`b2') {
		error 503
	}

	local rfullb1 : rowfullnames `b1'
	local cfullb1 : colfullnames `b1'
	local rfullb2 : rowfullnames `b2'
	local cfullb2 : colfullnames `b2'

	local nr = rowsof(`b1')
	local nc = colsof(`b1')

	// check match of names between b1 and b2

	if `"`:list dups rfullb1'"' != "" {
		dis as err "mat_order: non-unique row names"
		exit 503
	}
	if `"`:list dups cfullb1'"' != "" {
		dis as err "mat_order: non-unique column names"
		exit 503
	}
	if `:list rfullb1 === rfullb2' == 0 | /// 
	   `:list cfullb1 === cfullb2' == 0 {
		dis as err "mat_order: name mismatch"
		exit 503
	}

	// indices in b1

	local i 1
	foreach r of local rfullb2 {
		local row`i' = rownumb(`b1',"`r'")
		local ++i
	}
	local j 1
	foreach c of local cfullb2 {
			local col`j' = colnumb(`b1',"`c'")
			local ++j
	}

	// copy b1 into bb12

	tempname bb12
	mat `bb12' = `b2'              // names are ok now
	forvalues i = 1 / `nr' {
			forvalues j = 1 / `nc' {
				mat `bb12'[`i',`j'] = `b1'[`row`i'', `col`j'']
			}
	}
	mat `b12' = `bb12'
end
exit
