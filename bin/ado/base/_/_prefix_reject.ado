*! version 1.0.2  07feb2005
program _prefix_reject, sclass
	version 9
	_on_colon_parse `0'
	local 0 `s(before)'
	args caller cmdname
	local 0 `"`s(after)'"'
	if `"`:list retok 0'"' == "" {
		exit
	}
	capture syntax [anything] [if/]
	if c(rc) | (`"`anything'"' != "" & `"`if'"' != "") {
		di as err `"reject() incorrectly specified: `:list retok 0'"'
		exit 198
	}
	else if `"`if'"' != "" {
		local reject `"`:list retok if'"'
	}
	else	local reject `"`:list retok 0'"'

	capture assert `reject'
	if c(rc) == 0 {
		di as err ///
`"`caller' rejected results from `cmdname' while using the entire dataset"'
		exit 9
	}
	if c(rc) != 9 {
		di as err `"reject() incorrectly specified: `reject'"'
		exit 198
	}
	sreturn local reject `"`reject'"'
end
exit
