*! version 1.1.1  19aug2019
program define asmixlogit, byable(onecall) properties(svylb svyj svyr svyb cm)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
        if !replay() {
                qui syntax [anything] [fw iw pw] [if] [in] ,    ///
                                Case(passthru)                  ///
                                [                               /// 
                                *                               /// 
                                ]
        }
        `by' _mixlogit -1 `0'
end
exit
