*! version 1.0.0  15oct2015
program hetreg, byable(onecall) prop(svyb svyj svyr)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' hetregress `0'
end
exit
