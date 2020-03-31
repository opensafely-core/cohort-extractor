*! version 1.0.0  27feb2017
program _check_e_margins_mark, rclass
	version 14
	syntax anything(id="command name" name=cmdname) [, *]
	local DEFAULT default
	local OPTSOK `"`e(marginsnomarkout)'"'
	local DEFOK : list DEFAULT in OPTSOK
	local markout = 0
	if `DEFOK' {
		local OPTSOK : list OPTSOK - DEFAULT
	}
	if `:length local OPTSOK' == 0 {
		return scalar markout = !`DEFOK'
		exit
	}
	capture syntax anything(id="command name" name=cmdname) [, `OPTSOK' *]
	if c(rc) {
		di as err ///
			"problem parsing options from {bf:e(marginsnomarkout)}"
		exit c(rc)
	}
	local ok 0
	foreach OPT of local OPTSOK {
		gettoken OPT : OPT, parse(" ()")
		local OPT = strlower(`"`OPT'"')
		if `"``OPT''"' != "" {
			local ok 1
			break
		}
	}
	if `ok' == 0 {
		if `:length local options' == 0 & `DEFOK' {
			local ok 1
		}
	}
	return scalar markout = !`ok'
end
exit
