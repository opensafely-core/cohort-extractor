*! version 1.0.2  02jan2015
program stcrr, byable(onecall) prop(st sw hr nohr shr noshr)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`by' stcrreg `0'
end
exit
