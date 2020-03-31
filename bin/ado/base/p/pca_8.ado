*! version 1.0.1 28dec2003
program pca_8, rclass byable(onecall)
	version 8

	syntax [varlist(default=none)] [aw fw] [if] [in] [, pc pcf pf IPf ml * ]

	if "`pc'`pcf'`pf'`ipf'`ml'" != "" {
		dis as err "`pc'`pcf'`pf'`ipf'`ml' invalid"
		exit 198
	}

	if "`weight'" != "" {
		local wgt `"[`weight'`exp']"'
	}

	if _by() {
		local by "by `_byvars', `_byrc0':"
	}

	/* avoid error -- don't specify pc when replaying */
	if "`varlist'" != "" {
		local options `options' pc
	}

	`by' factor_cmd8 `varlist' `wgt' `if' `in' , `options'

	return add
end
