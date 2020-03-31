*! version 1.0.2   22may2017
program tob, byable(onecall) prop(bayes)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' tobit `0'
end
exit
