*! version 1.0.1  16aug2018
program define cmxtmixlogit, byable(onecall) ///
                             properties(svylb svyj svyr svyb cm cmxtbs)

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
di as err "Data must be {bf:cmset}. Use {bf:cmset} {it:panelvar} "
di as err "{it:timevar} {it:altvar}"
di as err "{p_end}"
		}
		else {
di as err "{p 4 4 2}"
di as err "Data must be {bf:cmset}. Use {bf:cmset} {it:panelvar} ...."
di as err "{p_end}"
		}
		exit 198
	}

	`by' _mixlogit 1 `0'

end
exit
