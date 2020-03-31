*! version 1.0.0  13nov2018
program xteregress, eclass byable(onecall) properties(xtbs)
	version 16.0
	if _by() {
                local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun xteregress, panel jkopts(eclass) noeqlist: `0'
        if "`s(exit)'" != "" {
                ereturn local cmdline `"xteregress `orig0'"'
                exit
        }
        if replay() {
		if "`e(cmd)'" != "xteregress" {
			error 301
		}
		else {
			Display `0'
                }
		exit
	}
	local orig0 `0'
	AddRe `0' 	
	local 0 `0' `r(addre)'
	capture noisily `BY' _eregress `0'
        if _rc {
                local myrc = _rc
                exit `myrc'
        }
	else {
		ereturn local cmdline `"xteregress `orig0'"'
	}
end

program AddRe, rclass
	syntax varlist(fv numeric ts) [if] [in][, *]
	if `"`options'"' == "" {
		local addre , re
	}
	else {
		local addre re
	}
	return local addre `addre'
end

program Display
	syntax, [*]
	_prefix_display, `options'
end

exit
