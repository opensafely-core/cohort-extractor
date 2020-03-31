*! version 1.0.0  05jul2009
program _prefix_replay, rclass
	version 11

	capture _on_colon_parse `0'
	local rc = _rc
	if (!`rc') {
		local pos = strpos(`"`0'"',":")
		if `pos' {
			return scalar replay = 0
			exit
		}
	}
	local before_colon `s(before)'
	if `rc' | `"`s(after)'"' == "" {
		if !c(rc) {
			local 0 `"`s(before)'"'
                }
		return scalar replay = replay()
	}
	else {
		return scalar replay = 0
	}
end
