*! version 1.2.0  27aug2018
program eintreg, eclass byable(onecall) properties(svyb svyj svyr)
	version 15.0
	if _by() {
                local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun eintreg, jkopts(eclass) noeqlist: `0'
        if "`s(exit)'" != "" {
                ereturn local cmdline `"eintreg `0'"'
                exit
        }
        if replay() {
		if "`e(cmd)'" != "eintreg" {
			error 301
		}
		else {
			Display `0'
                }
		exit
	}
	capture noisily `BY' _eintreg `0'
        if _rc {
                local myrc = _rc
                exit `myrc'
        }
end

program Display
        syntax, [*]
	_prefix_display, `options'
end
exit
