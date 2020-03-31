*! version 1.0.3   22may2017
program prob, byable(onecall) prop(svyb svyj svyr bayes)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' probit `0'
end
exit
