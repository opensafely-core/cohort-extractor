*! version 1.0.1  04nov2019
program _prefix_omitted, sclass
	version 16

	// Syntax:
	//
	// 	_prefix_omitted ms_spec_list : keep_spec_list
	//
	// Build a list of omitted matrix stripe elements in
	// ms_spec_list.  This utility considers an element omitted if
	// it is not present in -e(b)-, the diagonal element of -e(V)-
	// is zero, or has been marked as omitted.
	//
	// Elements in keep_spec_list are skipped.

	_on_colon_parse `0'
	local curr `s(before)'
	local term0 `s(after)'

	sreturn clear

	// look for omitted terms
	foreach vname of local curr {
		if `:list vname in term0' {
			continue
		}
		local pos : colnumb e(b) "`vname'"
		if missing(`pos') {
			local omitted `omitted' `vname'
		}
	}

	tempname m t0

	matrix `m' = diag0cnt(e(V))
	if `m'[1,1] == 0 {
		sreturn local omitted "`omitted'"
		exit
	}

	local dim : list sizeof curr
	matrix `m' = J(1,`dim',0)
	matrix colna `m' = `curr'
	local dim0 : list sizeof term0
	matrix `t0' = J(1,`dim0'+1,0)
	matrix colna `t0' = `term0' _cons

	// look for omitted terms
	if "`e(cmd)'" == "mlogit" {
		if e(ibaseout) == 1 {
			local eq #2
		}
		else	local eq #1
		tempname eV
		matrix `eV' = e(V)["`eq':","`eq':"]
	}
	else {
		local eV e(V)
	}
	local colna : colname `eV'
	local i 0
	foreach vname of local colna {
		local ++i
		_msparse `vname', noomit
		local VNAME "`r(stripe)'"
		if r(omit) == 0 {
			if `eV'[`i',`i'] != 0 {
				continue
			}
		}
		local pos = colnumb(`t0', "`vname'")
		if ! missing(`pos') {
			continue
		}
		local pos = colnumb(`t0', "`VNAME'")
		if ! missing(`pos') {
			continue
		}
		local pos = colnumb(`m', "`vname'")
		if missing(`pos') {
			local pos = colnumb(`m', "`VNAME'")
		}
		if missing(`pos') {
			di as err "`vname' not found in termlist"
			exit 198
		}
		matrix `m'[1,`pos'] = `m'[1,`pos'] + 1
	}
	local i 0
	foreach vname of local curr {
		local ++i
		local dups = `m'[1,`i']
		forval j = 1/`dups' {
			local omitted `omitted' `vname'
		}
	}
	sreturn local omitted "`omitted'"
end

exit
