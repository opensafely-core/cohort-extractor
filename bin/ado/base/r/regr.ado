*! version 1.0.3   22may2017
program regr, byable(onecall) prop(svyb svyj svyr bayes)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' regress `0'
end
exit
