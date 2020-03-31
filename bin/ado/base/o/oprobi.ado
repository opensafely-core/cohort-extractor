*! version 1.0.3   22may2017
program oprobi, byable(onecall) prop(svyb svyj svyr bayes)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' oprobit `0'
end
exit
