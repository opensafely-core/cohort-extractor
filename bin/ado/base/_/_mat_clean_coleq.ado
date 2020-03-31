*! version 1.0.0  26aug2005
program _mat_clean_coleq
	version 9
	_on_colon_parse `0'
	local list `"`s(after)'"'
	local 0 `s(before)'
	syntax name(name=macname id="macro name")
	if strpos(`"`list'"',".") {
		local list : subinstr local list "." ",", all
	}
	if strpos(`"`list'"',":") {
		local list : subinstr local list ":" ";", all
	}
	c_local `macname' `"`list'"'
end
