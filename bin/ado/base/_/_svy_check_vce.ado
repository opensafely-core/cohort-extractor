*! version 1.1.0  26oct2009
program _svy_check_vce, sclass
	version 9
	capture syntax name(name=vce id="vcetype") [, MSE ]
	if c(rc) {
		di as err "invalid vcetype"
		exit 198
	}
	unabVCEtype, `vce'
	if "`mse'" != "" {
		if "`vce'" == "" {
			di as err "option vce(, mse) invalid"
			exit 198
		}
		if !inlist("`s(vce)'","brr","bootstrap","jackknife","sdr") {
			di as err ///
		"option mse is not allowed with vce(`s(vce)')"
			exit 198
		}
	}
	sreturn local mse `mse'
end

program unabVCEtype, sclass
	gettoken comma vce : 0, parse(" ,")
	capture syntax [,	Robust			///
				LINEARized		///
				JACKknife		///
				JACKNife		///
				JKnife			///
				BRR			///
				BStrap			///
				BOOTstrap		///
				SDR			///
	]
	if c(rc) {
		di as err `"option vce(`:list retok vce') invalid"'
		exit c(rc)
	}
	if "`jknife'" != "" | "`jacknife'" != "" {
		local jackknife jackknife
	}
	local bootstrap `bstrap' `bootstrap'
	if `:list sizeof bootstrap' >= 1 {
		local bootstrap bootstrap
	}
	if "`robust'" != ""{
		local linearized linearized
	}
	local vce `linearized' `jackknife' `brr' `bootstrap' `sdr'
	if `: word count `vce'' > 1 {
		di as err "vce(`:list retok vce') invalid"
		exit 198
	}
	sreturn local vce `vce'
end

exit
