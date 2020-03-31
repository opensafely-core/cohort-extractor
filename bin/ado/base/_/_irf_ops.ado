*! version 1.0.0  23oct2013
program define _irf_ops, sclass
	version 13
	syntax anything(name=irfvar)	
	_ms_parse_parts `irfvar'
	if "`r(op)'" != "" {
		local irfvar = upper("`r(op)'") + "." + "`r(name)'"
	}
	sreturn local irfvar `irfvar'
end
exit
