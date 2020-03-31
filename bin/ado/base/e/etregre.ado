*! version 1.0.1   02jan2015
program etregre, byable(onecall) prop(svyb svyj svyr)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' etregress `0'
end
exit
