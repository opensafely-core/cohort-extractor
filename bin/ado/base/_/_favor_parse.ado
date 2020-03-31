*! version 1.1.0  06oct2008
program _favor_parse, sclass
	version 10
	_on_colon_parse `0'
	local 0 `"`s(before)'"'
	local after `s(after)'
	local after: list retok after
	syntax [, SPEed SPAce ]
	local FAVOR `speed' `space'
	if !`:length local FAVOR' {
		local FAVOR = c(matafavor)
	}
	local 0 `", `after'"'
	cap syntax [, SPEed SPAce ]
	if _rc {
		di as err "option {cmd:favor(`after')} is not allowed"
		exit 198
	}
	local favor `speed' `space'
	if `:length local favor' {
		sreturn local favor `favor'
	}
	else	sreturn local favor `FAVOR'
end
