*! version 1.0.2  09may2017
program u_mi_impute_check_ivars
	version 12
	args unabivars colon ivars ivarsmax
	local errindent 0 4 2
	if (`"`ivars'"'=="") {
		di as err "{p `errindent'}"	///
			"imputation (left-hand-side) variable required{p_end}"
		exit 100
	}
	cap noi _chk_ts `ivars'
	if _rc {
		if ($MI_IMPUTE_user==0) {
			exit _rc
		}
		if ("`ivarsmax'"=="1") {
			di as err "imputation variable is incorrectly specified"
		}
		else {
			di as err ///
				"imputation variables are incorrectly specified"
		}
		exit _rc
	}
	_fv_check_depvar `ivars'
	unab ivars : `ivars'
	local ivdups : list dups ivars
	if ("`ivdups'"!="") {
		local ndups : word count `ivdups'
		di as err "{p}{bf:`ivdups'}: duplicate imputation"
		di as err plural(`ndups',"variable") " found{p_end}"
		exit 198
	}
	local p: word count `ivars'
	if ("`ivarsmax'"!="") {
		if (`p'>`ivarsmax') {
			di as err "{p `errindent'}"	///
			  "too many imputation variables specified{p_end}"
			exit 103
		}
	}
	confirm numeric variable `ivars'
	// ivars must be registered as imputed
	local imputed	`_dta[_mi_ivars]'
	local bad `ivars'
	unab  bad: `bad'
	local bad: list bad - imputed
	if ("`bad'"!="") {
		di as err "{p `errindent'}{bf:`bad'}: must be registered " ///
			 "as imputed; see " ///
  			 "{helpb mi register:{bind:mi register}}{p_end}"
		exit 198
	}
	c_local `unabivars' `ivars'
end

program _chk_ts
	syntax [varlist(default=none fv)]
end
