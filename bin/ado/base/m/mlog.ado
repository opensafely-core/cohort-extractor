*! version 1.0.3   22may2017
program mlog, byable(onecall) prop(rrr svyb svyj svyr bayes)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' mlogit `0'
end
exit
