*! version 1.0.2  13oct2015
program u_mi_impute_cmd_chained, eclass
	version 12
	args impobj ivarsord force noisily every k_eq burnin inittype ///
	     chaindots chainonly monitor tracepostfile detail itererrok

	local m `_dta[_mi_impute_m]'
	if ("`monitor'`every'"!="") {
		local noisily noisily
	}
	if (`burnin'==10) {
		//so that 10 is not displayed before 'done' with -chaindots-
		//with default burnin
		local dotsevery 15	
	}
	else {
		local dotsevery 10
	}
	if ("`noisily'"!="") {
		local chaindots
	}
	if ("`tracepostfile'"!="") {	//for posting trace values
		if ("`detail'"!="") {
			local nstats 7
		}
		else {
			local nstats 2
		}
		tempname stats
		mat `stats' = J(7,`k_eq',.) // mean\sd
	}
	if ("`chaindots'"=="") {
		local nodots nodots
	}
	if ("`chainonly'"=="") {
		local chaintitle "imputing {it:m}=`m': burn-in"
	}
	else {
		local chaintitle "burn-in"
	}
	if ("`inittype'"=="random") {
		mata: `impobj'._init_random()
		local hasmiss 0 
	}
	else {
		if ($MI_IMPUTE_setstripe==0 & `burnin'==0) {
			local setstripe 1
			local omitchk 1
		}
		else if `burnin'==0 {
			local setstripe 0
			local omitchk 1
		}
		else { //initial monotone imputation
			local setstripe 0
			local omitchk 0
		}
		local iterpos : list posof "0" in every
		if (!`iterpos' & "`monitor'"=="") {
			local iterqui qui
		}
		if ("`noisily'"!="" & "`iterqui'"=="") {
			di as txt _n ///
		   "{bf:Performing monotone imputation, {it:m}=`m':}"
		}
		cap noi `iterqui' _mi_impute_chained_iter hasmiss : 	  ///
		    	"`impobj'" "`ivarsord'" "`force'" 		  ///
		    	`k_eq' "monotone" "" "`m'" "`monitor'" "`stats'"  ///
		 	"`detail'" "`chainonly'" "`setstripe'" "`omitchk'"
		local rc = _rc
		if `rc' {
			mata: `impobj'.fillmis()
			exit `rc'
		}
	}
	if ("`tracepostfile'"!="") {
		local postline
		forvalues k=1/`k_eq' {
			forvalues j=1/`nstats' {
				local postline `postline' (el(`stats',`j',`k'))
			}
		}
		post `tracepostfile' (0) (`m') `postline'
		mat `stats' = J(7,`k_eq',.)
	}
	if (`burnin'==0) { // stop here if no iterations
		u_mi_dots, indent(2) reps(`burnin') `nodots' title(`chaintitle')
		u_mi_dots, last `nodots'
		mata: `impobj'.updateNimp(("`chainonly'"!=""))
		if (`hasmiss') {
			exit 459
		}
		exit
	}

	if ("`noisily'"!="") {
		di as txt _n "{bf:Performing chained iterations, {it:m}=`m':}"
	}
	u_mi_dots, indent(2) reps(`burnin') `nodots' title(`chaintitle')
cap noi {
	if ($MI_IMPUTE_setstripe==0) {
		local setstripe 1
	}
	else {
		local setstripe 0
	}
	forvalues iter = 1/`burnin' {
		local iterpos : list posof "`iter'" in every
		if (!`iterpos' & "`monitor'"=="") {
			local iterqui qui
		}
		else {
			local iterqui noi
		}
		if (("`chaindots'"!="" |"`itererrok'"!="") & `iter'!=`burnin') {
			local capnoi capture
		}
		else {
			local capnoi capture noisily
		}
		`capnoi' `iterqui' _mi_impute_chained_iter hasmiss : ///
			"`impobj'" "`ivarsord'" "`force'"	///
			`k_eq' "" "`iter'" "`m'" 		///
			"`monitor'" "`stats'" "`detail'" "`chainonly'" ///
			"`setstripe'"
		local rc_iter = _rc
		if (`rc_iter'==1) exit 1
		local dierr = `hasmiss'+`rc_iter'
		if ("`itererrok'"=="" & `rc_iter') {
			exit `rc_iter'
		}
		else if (`rc_iter' & `iter'==`burnin') {
			cap noi u_mi_dots `iter' `dierr', ///
						every(`dotsevery') `nodots'
			exit `rc_iter'
		}
		cap noi u_mi_dots `iter' `dierr', every(`dotsevery') `nodots'
		if ("`tracepostfile'"!="") {
			local postline
			forvalues k=1/`k_eq' {
				forvalues j=1/`nstats' {
					local postline `postline' ///
							(el(`stats',`j',`k'))
				}
			}
			post `tracepostfile' (`iter') (`m') `postline'
			mat `stats' = J(7,`k_eq',.)
		}
		local setstripe 0
	}
}
local rc = _rc
	if (`rc') {
		mata: `impobj'.fillmis()
		exit `rc'
	}
	mata: `impobj'.updateNimp(("`chainonly'"!=""))
	u_mi_dots, last `nodots'
	if (`hasmiss') {
		exit 459
	}
end

program _mi_impute_chained_iter, eclass
	args hasmiss colon impobj ivars force k_eq monotone iter currm ///
	     monitor stats detail chainonly setstripe omitchk
	local haserr 0
	local k $MI_IMPUTE_kgroup
	if ("`k'"=="") {
		local k 1
	}
	tempvar touse
	qui gen byte `touse' = 0
	local noheader
	local newline di
	forvalues i=1/`k_eq' {
		gettoken ivar ivars : ivars
		// replace existing missing values in ivar with (.)
		mata: `impobj'.pImpClsInc[`i']->fillmis()
		cap noi u_mi_impute_cmd__uvmethod_init 			///
			${MI_IMPUTE_uvinit`k'_`i'}			///
			"`monotone'" "`iter'" "`currm'" "" "" "`setstripe'" ///
			"`omitchk'"
		local rc = _rc
		if (`rc') {
			mata: `impobj'.updateNimp(("`chainonly'"!=""))
			global MI_IMPUTE_badivars `ivar'
			exit `rc'
		}
		if ("`monitor'"!="") {
			`newline'
			noi _display_r2 "`currm'" "`iter'" "`ivar'" "`noheader'"
			local noheader noheader
			local newline
		}
		cap noi u_mi_impute_cmd__uvmethod ${MI_IMPUTE_uvimp`k'_`i'} ///
					"" "`touse'"
		local rc = _rc
		if (`rc'==504 | `rc'==459) { 
			if ("`force'"=="") {
				global MI_IMPUTE_badivars `ivar'
				exit 459
			}
			local ++haserr
		}
		else if `rc' {
			exit `rc'
		}
		if ("`stats'"!="") {
			qui summ `ivar' if `touse', `detail'
			mat `stats'[1,`i'] = r(mean)
			mat `stats'[2,`i'] = r(sd)
			mat `stats'[3,`i'] = r(min)
			mat `stats'[4,`i'] = r(p25)
			mat `stats'[5,`i'] = r(p50)
			mat `stats'[6,`i'] = r(p75)
			mat `stats'[7,`i'] = r(max)
		}
	}
	// so that imp. dots are displayed as x if imputed missing
	// values produced	
	c_local `hasmiss' `haserr'
end

program _display_r2
	args m iter ivar noheader
	if ("`noheader'"=="") {
		if ("`iter'"=="") local iter 0
		di as txt "Iteration " as res `iter' as txt ":"
	}
	if (!mi(e(r2))) {
		local r2 = string(e(r2), "%5.4f")
		local R2 "{space 7}R2"
	}
	else if (!mi(e(r2_p))) {
		local r2 = string(e(r2_p), "%5.4f")
		local R2 "pseudo R2"
	}
	else {
		local r2 =  string(1-e(ll)/e(ll_0), "%5.4f")
		local R2 "pseudo R2"
	}
	u_mi_impute_table_legend "`ivar'" ///
			`"{txt}`R2' = {res}`r2'{txt} ({bf:`e(cmd)'})"' 
end
