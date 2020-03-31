*! version 1.1.0  24apr2019
program cmmixlogit, eclass byable(onecall) properties(cm svylb svyj svyr svyb)
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}

        qui syntax [anything] [fw iw pw] [if] [in] ,    ///
                        [                               /// 
                        Case(passthru)                  ///
                        ALTernatives(passthru)          ///
                        *                               /// 
                        ]

	if (`"`case'`alternatives'"' != "") {
		if (`"`case'"' != "") {
			di as error "option {bf:case()} not allowed"
		}
		if (`"`alternatives'"' != "") {
di as err "option {bf:alternatives()} not allowed"
di as err "{p 4 4 2}"
di as err "Data must be {bf:cmset}. Use {bf:cmset} {it:caseidvar} {it:altvar}"
di as err "{p_end}"
		}
		else {
di as err "{p 4 4 2}"
di as err "Data must be {bf:cmset}. Use {bf:cmset} {it:caseidvar} ...."
di as err "{p_end}"
		}
		exit 198
	}

        `by' _mixlogit 0 `0'
end
exit
