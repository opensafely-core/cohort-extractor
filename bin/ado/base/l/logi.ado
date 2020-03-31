*! version 1.0.3   22may2017
program logi, byable(onecall) prop(or svyb svyj svyr bayes)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' logit `0'
end
exit
