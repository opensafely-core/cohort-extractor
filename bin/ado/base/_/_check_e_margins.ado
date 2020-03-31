*! version 1.1.0  08mar2015
program _check_e_margins, rclass
	version 11
	syntax anything(id="command name" name=cmdname) [, *]
	local DEFAULT default
	local OPTSOK `"`e(marginsok)'"'
	local DEFOK : list DEFAULT in OPTSOK
	if `DEFOK' {
		local OPTSOK : list OPTSOK - DEFAULT
	}
	local OPTSNOT `"`e(marginsnotok)'"'
	if "`OPTSNOT'" == "_ALL" {
		di as err "{bf:`cmdname'} not appropriate after {bf:`e(cmd)'}"
		exit 322
	}
	local DEFNOT : list DEFAULT in OPTSNOT
	if `DEFNOT' {
		local OPTSNOT : list OPTSNOT - DEFAULT
	}
	local OPTS `OPTSOK' `OPTSNOT'
	if `:length local OPTS' == 0 {
		if `DEFNOT' {
			if strtrim(`"`0'"') == "," {
				di as err "default {bf:predict} option " _c
				di as err "not appropriate with {bf:`cmdname'}"
				exit 322
			}
		}
		return scalar marginsok = `DEFOK'
		exit
	}
	local OPTS : list OPTSOK & OPTSNOT
	if `:length local OPTS' {
		di as err ///
		"{bf:e(marginsok)} and {bf:e(marginsnotok)} are in conflict"
		error 322
	}
	capture syntax anything(id="command name" name=cmdname) [, `OPTSNOT' *]
	if c(rc) {
		di as err "problem parsing options from {bf:e(marginsnotok)}"
		exit c(rc)
	}
	local NOT 0
	foreach OPT of local OPTSNOT {
		gettoken OPTNAME REST : OPT, parse(" ()")
		local OPTNAME = strlower(`"`OPTNAME'"')
		if `"``OPTNAME''"' != "" {
			if `:length local rest' {
				local NOTOPT `OPTNAME'()
			}
			else	local NOTOPT `OPTNAME'
			local NOT 1
			break
		}
		local OPTNAME
	}
	if `NOT' == 0 {
		if `:length local options' == 0 & `DEFNOT' {
			local NOT 1
		}
	}
	if `NOT' {
		if `:length local NOTOPT' {
			di as err "{bf:predict} option {bf:`NOTOPT'} " _c
		}
		else {
			di as err "default {bf:predict} option " _c
		}
		di as err "not appropriate with {bf:`cmdname'}"
		exit 322
	}
	capture syntax anything(id="command name" name=cmdname) [, `OPTSOK' *]
	if c(rc) {
		di as err "problem parsing options from {bf:e(marginsok)}"
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
	return scalar marginsok = `ok'
end
exit
