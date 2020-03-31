*! version 1.0.2  22mar2019
program u_mi_impute_cmd__uvmethod, eclass
	version 12
	args impobj method ivars ifspec ifcond conditional condval ///
	     ifgroup expnames bootstrap fvrevar savetouse

	// 'savetouse' used by -chained- to store iteration summary statistics
	if ("`savetouse'"=="") { 
		mata: `impobj'.fillmis()
	}
	else {
		qui replace `savetouse' = 0
		mata: `impobj'.fillmis(); 	///
		     st_store(`impobj'.misid,"`savetouse'",J(`impobj'.nmis,1,1))
	}

	tempvar touse tousecond
	mark `touse' `ifspec'
	markout `touse' `ivars', sysmissok
	mark `tousecond' `ifcond'
	markout `tousecond' `ivars', sysmissok
	if ("`ifgroup'"!="") {
		qui replace `touse' = 0 if !(`ifgroup') & `touse'==1
		qui replace `tousecond' = 0 if !(`ifgroup') & `tousecond'==1
	}
	u_mi_impute_replace_expvars `expnames' if `touse'
	if ("`fvrevar'"!="") {
		cap drop __mi_fv*
		fvrevar `fvrevar' if `touse', stub(__mi_fv)
	}

	local N_cond = .
	if (`"`conditional'"'!="") {
		qui count if !(`tousecond') & `touse' & `ivars'==.
		local N_cond = r(N)
		qui replace `ivars' = `condval' 	///
				if !(`tousecond') & `touse' & `ivars'==.
		qui summ `ivars' if !(`tousecond') & `touse', meanonly
		if (r(max)>r(min)) {
			di as err "{p 0 0 2}"
			di as err "{bf:conditional()}: imputation"
			di as err "variable not constant outside"
			di as err "conditional sample;{p_end}"
			di as err "{p 4 4 2}{bf:`ivars'} is not constant"
			di as err "outside the subset identified by"
			di as err `"{bf:(`conditional')} within the"'
			di as err "imputation sample.  This may happen when"
			di as err "missing values of conditioning variables"
			di as err "are not nested within missing values of"
			di as err "{bf:`ivars'}.{p_end}"
			exit 498
		}
	}

	// proceed to imputation only if have misvals to impute
	qui count if `ivars'==. & `tousecond'
	if (`r(N)'==0) {
		mata:	`impobj'.N_cond = `N_cond'; 	///
			`impobj'.N_imp_out=`N_cond';	///
			`impobj'.N_imp =`N_cond'
		exit
	}

	tempname beta
	if ("`bootstrap'"=="") {
		mata: st_local("nmiss", strofreal(`impobj'.draw_parms())); ///
		      st_matrix("`beta'", `impobj'.beta')
		if !(`nmiss') {
			eret repost b = `beta'
		}
	}
	else {
		mat `beta' = e(b)
		local nmiss = matmissing(`beta')
		if ("`method'"=="regress") {
			mata:   `impobj'.beta = st_matrix("`beta'")';	///
				`impobj'.sigma = st_numscalar("e(rmse)")
		}
		else {
			mata: `impobj'.beta = st_matrix("`beta'")'
		}
	}
	if (`nmiss') {
		mata:   `impobj'.N_allimp  = `impobj'.N_allimp, 0;	///
			`impobj'.N_allcond = `impobj'.N_allcond, 0;
		exit 504
	}


	tempvar pr
	local prnames `pr'
	if ("`method'"=="pmm") {
		qui _predict double `pr' if `tousecond', xb
	}
	else if ("`method'"=="logit") {
		qui predict double `pr' if `tousecond' & `ivars'==., rules
	}
	else if ("`method'"=="mlogit") {
		mata: st_local("prnames", invtokens(st_tempname(`e(k_out)')))
		qui predict double `prnames' if `tousecond' & `ivars'==., pr
	}
	else {
		qui predict double `pr' if `tousecond' & `ivars'==., xb
	}
	if ("`method'"=="regress") {
		mata: st_local("offset",`impobj'.offset)
		if ("`offset'"!="") {
			qui replace `pr' = `pr'+`offset'
		}
	}
	mata: st_local("nmiss", strofreal(`impobj'.impute("`prnames'")))
        if (`nmiss') {
		global MI_IMPUTE_badivars `ivars'
                exit 459
        }
	else { //should not occur
		qui count if `ivars'==. & `touse'
		if (r(N)>0) {
			global MI_IMPUTE_badivars `ivars'
	                exit 459
		}
	} 
end
