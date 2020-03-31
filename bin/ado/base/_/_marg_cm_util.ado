*! version 1.0.0  16feb2018
program _marg_cm_util
	version 16

	local margprop `"`e(marginsprop)'"'
	if `:list posof "cm" in margprop' == 0 {
		exit
	}

	if `"`0'"' == "label" {
		tempname rhold
		_return hold `rhold'
		PostLabel
		_return restore `rhold'
	}
	else {
		di as err "invalid argument to _marg_cm_util"
		exit 199
	}
end

program PostLabel
	local colna : colna e(b)
	gettoken spec : colna
	local spec : subinstr local spec "@" "#", all
	local spec : subinstr local spec "|" "#", all
	_ms_parse_parts `spec'
	if r(type) == "factor" {
		if r(name) != "_outcome" {
			exit
		}
	}
	else if r(type) == "interaction" {
		local has_out 0
		local k = r(k_names)
		forval i = 1/`k' {
			if r(name`i') == "_outcome" {
				local has_out 1
				continue, break
			}
		}
		if `has_out' == 0 {
			exit
		}
	}
	local altvar `"`e(altvar)'"'
	local vl : value label `altvar'
	if `"`vl'"' == "" {
		exit
	}
	label copy `vl' _outcome, eclass
end

exit
