*! version 1.0.0  29aug2019
program _ms_mark_omitted, sclass
	version 16

	// Syntax:
	//
	//	_ms_mark_omitted <action> <omit> <list>
	//
	// <action> is omit or drop
	//
	// <omit> is a matrix stripe element
	//
	// <list> is a list of matrix stripe element
	//
	// Find the first not-omitted element of <list> that matches
	// <omit> and either mark as omitted or drop it from <list>.
	// Loop through the elements of <list> in reverse order.

	gettoken action	0 : 0
	gettoken omit	0 : 0

	if !inlist("`action'","omit","drop") {
		di as err ///
		"{bf:`action'} found where {bf:omit} or {bf:drop} expected"
		exit 198
	}

	_msparse `omit', noomit
	local noomit `"`r(stripe)'"'
	if r(omit) == 0 {
		_msparse `omit', makeomit
		local omit `"`r(stripe)'"'
	}

	ReverseList `0'
	local 0 `"`s(list)'"'

	local found no
	foreach el of local 0 {
		_msparse `el', noomit
		local EL `"`r(stripe)'"'
		if r(omit) == 0 {
			if `"`EL'"' == `"`noomit'"' {
				local noomit
				local found yes
				if "`action'" == "omit" {
					local el `"`omit'"'
				}
				else {
					continue
				}
			}
		}
		else if "`action'" == "drop" {
			if `"`EL'"' == `"`noomit'"' {
				local noomit
				local found yes
				continue
			}
		}
		local list `el' `list'
	}
	sreturn local list `"`list'"'
	sreturn local found `"`found'"'
end

program ReverseList, sclass
	while `:length local 0' {
		gettoken el 0 : 0
		local list `el' `list'
	}
	sreturn local list `"`list'"'
end

exit
