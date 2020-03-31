*! version 1.0.3   22may2017
program ologi, byable(onecall) prop(or svyb svyj svyr bayes)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' ologit `0'
end
exit
