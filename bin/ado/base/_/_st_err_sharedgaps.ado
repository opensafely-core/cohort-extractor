*! version 1.0.0  29jan2013
program _st_err_sharedgaps
	version 12
	args shared forceshared touse

	if (`"`shared'"'=="") {
		exit
	}

	qui stdescribe if `touse'
	if (`r(t0_max)'==0 & `r(N_gap)'==0) {
		exit
	}

	if ("`forceshared'"!="") {
		di as txt "{p 0 9 2}Warning: option {bf:shared()} is used "
		di as txt "in the presence of delayed entries or gaps.  "
		di as txt "The results are consistent only under "
		di as txt "the assumption that the frailty distribution "
		di as txt "is independent of the covariates and the "
		di as txt "truncation points.  This is a restrictive "
		di as txt "assumption, and you should evaluate if it is"
		di as txt "reasonable for your data before you proceed "
		di as txt "with estimation.{p_end}"
		exit
	}

	di as err "{bf:shared()}: delayed entries or gaps detected;"
	di as err "{p 4 4 2}The {bf:shared()} option is not allowed "
	di as err "in the presence of delayed entries "
	di as err "or gaps.  To proceed, you may "
	di as err "consider using the undocumented "
	di as err "{helpb st_forceshared:forceshared} option.  If you "
	di as err "use {bf:forceshared}, you will obtain "
	di as err "consistent results only under the assumption "
	di as err "that the frailty distribution is independent of the "
	di as err "covariates and the truncation points.  This is a "
	di as err "restrictive assumption, and you should evaluate if "
	di as err "it is reasonable for your data before you proceed "
	di as err "with estimation.{p_end}"
	exit 498
end
