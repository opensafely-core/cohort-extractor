*! version 1.0.2   02jan2015
program olo, byable(onecall) prop(or svyb svyj svyr)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' ologit `0'
end
exit
