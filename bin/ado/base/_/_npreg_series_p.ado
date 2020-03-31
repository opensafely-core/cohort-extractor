*! version 1.0.0  28nov2018

program define _npreg_series_p, eclass 
	version 16
        syntax [anything] [if] [in], 		///
			[			///
			Residuals		///
			Mean			///
			SCores 			///
			tolerance(string)	///
			atsample 		///
                        ]  

	marksample touse 
	tempvar touse2 touse3
	quietly generate `touse2' = e(sample)
	quietly generate `touse3' = `touse2'*`touse' 	

	// Which estimator 
	
	local estis = e(estis)
	
	// Names for scores 

        _stubstar2names `anything', nvars(1) singleok
        local varlist  = s(varlist)
        local typlist `s(typlist)'
        local ns: list sizeof varlist 
	
        // Parsing options

        local options = ("`residuals'"!="") + ("`mean'"!="") + ("`scores'"!="")
               
        local stat "`residuals'`mean'`scores'"

        if `options' > 1 {
                display as error "only one statistic may be specified"
                exit 198
        }

        if `options'== 0 {
                display as text "(statistic {bf:mean} assumed; mean function)"
                local stat "mean"
        }

	// Checklists for prediction 
	
	local cvars "`e(cvars)'"
	local todobien = 0 
	mata: st_numscalar("e(empty_cell)", 0, "hidden")
	local rck: list sizeof cvars 
	if (`estis'>1 & "`cvars'"!="") {
		_check_cvars if `touse3', cvars(`cvars') 		///
					  tolerance(`tolerance')	///
					  `atsample'
		capture checkestimationsample
		local rc = _rc 
		if ((`rc'| "`c(marginsatvars)'"!="") & `rck'>1) {
			local oldvars "`e(renoms)'"
			local kold: list sizeof oldvars
			if (`kold'>1) {
				_check_intersect if `touse2', ///
					cvars("`oldvars'") newvars("`cvars'")
				local todobien = r(todobien)
			}
		} 
	}

	if ("`atsample'"!="") {
		if ("`cvars'"=="") {
			display as error "option {bf:atsample} misspecified"
			di as err "{p 2 2 2}" 
			di as smcl as err "This option only works when"
			di as smcl as err " you have continuous covariates"
			di as smcl as err " in your model. You have none."
			exit 198
		}
		tempvar sampvar 
		quietly generate `sampvar' = . 
		_at_sample, atnombre(`sampvar') cvars(`cvars')
		quietly replace `touse' = `touse'*`sampvar'
	}

	// Predictions for different basis 
	
	local yvar  "`e(depvar)'"
	local constant "`e(hascons)'"
	if (`estis'==3) {
		local knots = e(knots)
		local orden = e(order)
		local cvars "`e(cvars)'"
		local dvars "`e(dinter)'"
		local dnp "`e(dnp)'"
		local vars  "`e(covariates)'"	
		if (`todobien'==0) {
			_making_bsknots_p if `touse', knots(`knots')	///
				 cvars(`cvars') dvars(`dvars')		///
				 orden(`orden')	yvar(`yvar')		///
				 `constant' variable(`varlist')		///
				 typlist(`typlist') `stat'		///
				 dnp(`dnp')
		}
		else {
di as txt "{p 0 9 2}" ///
"Warning: You requested a prediction " ///
"in a region with no data for the original" ///
" estimation sample. All predictions are missing. {p_end}"
			if ("`stat'"=="mean") {
				quietly generate `typlist' `varlist' = ///
					. if `touse3'
				label var `varlist' "mean function"
			}
			else {
				if ("`stat'"=="residuals") {
					quietly generate `typlist' 	///
						`varlist' =	. ///
					label variable `varlist' "Residuals"
				}
				else {
					quietly generate `typlist' ///
						`varlist' = . ///
						if `touse3'
					label variable `varlist' ///
				  "equation-level scores from series estimation"
				}
			}
		}
	}
	if (`estis'==2) {
		local knots = e(knots)
		local orden = e(order)
		local cvars "`e(cvars)'"
		local dvars "`e(dinter)'"
		local dnp "`e(dnp)'"
		local vars  "`e(covariates)'"	
		if (`todobien'==0) {
			_making_knots_p if `touse', knots(`knots')	///
				 cvars(`cvars') dvars(`dvars')		///
				 orden(`orden')	yvar(`yvar')		///
				 `constant' variable(`varlist')		///
				 typlist(`typlist') `stat'		///
				 dnp(`dnp')	
		}
		else {
di as txt "{p 0 9 2}" ///
"Warning: You requested a prediction " ///
"in a region with no data for the original" ///
" estimation sample. All predictions are missing. {p_end}"
			if ("`stat'"=="mean") {
				quietly generate `typlist' `varlist' = ///
					. if `touse3'
				label var `varlist' "mean function"
			}
			else {
				if ("`stat'"=="residuals") {
					quietly generate `typlist' 	///
						`varlist' =	. ///
					label variable `varlist' "Residuals"
				}
				else {
					quietly generate `typlist' ///
						`varlist' = . ///
						if `touse3'
					label variable `varlist' ///
				  "equation-level scores from series estimation"
				}
			}
		}
	}
	if (`estis'==1) {
		tempvar xb 
		if ("`e(cmd_loco)'"!="_npreg_series_two") {
			_predict `typlist' `xb' if `touse3', xb
			if ("`stat'"=="mean") {
				generate `typlist' `varlist' = `xb' if `touse3'
				label var `varlist' "mean function"
			}
			else {
				if ("`stat'"=="residuals") {
					generate `typlist' `varlist' =	///
						`yvar' - `xb' if `touse3'
					label variable `varlist' "Residuals"
				}
				else {
					generate `typlist' `varlist' =	///
						`yvar' - `xb' if `touse3'
					label variable `varlist' ///
				  "equation-level scores from series estimation"
				}
			}
		}
		else {
			tempname beta 
			local nomscvs `"`e(regressors)'"'
			local b "`nomscvs'"	

			tempname atmat ebknew
			local cvars     = e(cvars)
			local todos     = e(listatotal)
			local listad    = e(listacambio)
			local atstripes = e(atstripes)
			matrix `atmat'  = e(atmatrix)
			matrix colnames `atmat' =  `atstripes'
			local dinter "`e(dvars)'"
			local atvars "`e(atvars)'"
			local noatc = 0
			local esat = 0 
			if ("`e(cvars)'"!="" & "`c(marginsatvars)'"!="") {
				fvexpand `cvars'
				local cvarnew = r(varlist)
				local kcvn: list sizeof cvarnew
				forvalues i=1/`kcvn' {
					local cnewx: word `i' of `cvarnew'
					_ms_parse_parts `cnewx'
					local cnom "`cnom' `r(name)'"
				}
				local cfinal "`cnom' `cvars'"
				local interx: list atvars - cfinal
				if ("`interx'"=="") {
					local noatc = 1
				}
				local atvars "`interx'"
			}
			if ("`dinter'"!="" & ///
				"`c(marginsatvars)'"!="" & `noatc'==0) {
				fvexpand `e(cvars)'
				local cvars "`r(varlist)'"
				fvexpand `dinter'
				local dinter "`r(varlist)'"
				*quietly mata: _dinter_expand_("`dinter'")
				local original  "`cvars' `dinter'"
				matrix `ebknew' = e(b_series)
				if ("`e(hascons)'"=="") {
					matrix colnames `ebknew' = `b' _cons
				}
				else {
					matrix colnames `ebknew' = `b'		
				}
				_fv_term_info `atvars', individuals	///
							fvrestripe	///
							matrix(`ebknew')
				local b: colna `ebknew'
				local esat = 1
				matrix `beta' = `ebknew'
			}
			else {
				matrix `beta' = e(b_series)
				if ("`e(hascons)'"=="") {	
					matrix colnames `beta' = `b' _cons
				}
				else {
					matrix colnames `beta' = `b' 
				}			
			}
			matrix rownames `beta' = "`yvar'"

			if ("`stat'"=="mean") {
				matrix score `typlist' `varlist' =	///
					`beta' if `touse3'
				label variable `varlist' "mean function"
			}
			else {
				tempvar xbscore 
				quietly matrix score	///
					`typlist' `xbscore' = `beta' if `touse3'
				quietly generate `typlist' `varlist' = ///
					`yvar' - `xbscore' if `touse3'
				if ("`stat'"=="residuals") {
					label variable `varlist' "Residuals"
				}
				else {
					label variable `varlist' ///
		"equation-level scores from series estimation"
				}
			}
		}
	}

end

program define _making_knots_p, rclass
	syntax [if][in], [ knots(integer 1)	///
			   cvars(string)	///
			   dvars(string)	///
			   dnp(string)		///
			   orden(integer 3)	///
			   yvar(string)		///
			   variable(string)	///
			   typlist(string)	///
			   noCONstant		///
			   SCores		///
			   Residuals		///
			   mean]	
	
	marksample touse 
	tempname beta matknot xmat matmm matc matd 
	tempvar touse2 touse3
	quietly generate `touse2' = e(sample)
	quietly generate `touse3' = `touse2'*`touse' 
	
	local p   = `orden'
	local k:  list sizeof cvars
	local l   = `knots'
	matrix `matknot' = e(matknots)
	matrix `matc' 	= e(matcnint)
	matrix `matd' 	= e(matdnint)
	
	forvalues i=1/`k' {
		local x: word `i' of `cvars'
		local xe "`x'"
		matrix `matmm' = e(matmm)
		local min = `matmm'[`i',1]
		local max = `matmm'[`i',2]
		tempvar __x`i'rs 
		quietly generate double `__x`i'rs' =	///
			(`x' - `min')/(`max'-`min') if `touse3'
		local xe "`__x`i'rs'"
		if (`p'==1) {
			local xint`i' "c.`xe'"
		}
		if (`p'==2) {
			local xint`i' "c.`xe'##c.`xe'"
		}
		if (`p'==3) {
			local xint`i' ///
				"c.`xe'##c.`xe'##c.`xe'"
		}
		forvalues j=1/`l' {	
			local rrk = `matknot'[`i', `j']
			tempvar __x`i'__knot_`j'
			generate double `__x`i'__knot_`j'' =	///
				(max(0, `xe'-`rrk'))^`p' if `touse3'
			local cnames`i' "`cnames`i'' c.`__x`i'__knot_`j''"
		}
	}
	
	if (`matd'[1,1]!=.) {
		local kdnt: list sizeof dvars
		forvalues i=1/`kdnt' {
			local x: word `i' of `dvars'
			if (`matd'[1,`i']==1) {
				local newdnt "`newdnt' `x'"
			}
			else {
				local newnod "`newnod' `x'"
			}
		}
		local dvars "`newdnt'"
	}
	
	local dinter "`dvars'"	
	if ("`dvars'"!="") {
		/*_dvar_inter
		local dinter "##(`s(dinter)')"
		local nocv "`s(dinter)'"*/
		local dinter "##(`dvars')"
	}
	
	local kxn  = 1
	
	forvalues i=1/`k' {
		if (`matc'[1,`i']==.|`matc'[1,`i']==1) {
			local ins "(`xint`i'' `cnames`i'')"
			local ins1 "`xint1' `cnames`i''"
			if (`orden'==1) {
				if (`k'==1) {
					local nomscv`kxn' "`ins1'"
				}
				else {
					local nomscv`kxn' "`ins'"
				}
				local notsp "`notsp' `xint`i''"
			}
			if (`orden'==2) {
				local notsp "`notsp' `xint`i''"
				local nomscv`kxn' "`xint`i'' `cnames`i''"
			}
			if (`orden'==3) {
				local notsp "`notsp' `xint`i''"	
				local nomscv`kxn' "`xint`i'' `cnames`i''"	
			}
			local kxn = `kxn' + 1
		}
		else if (`matc'[1,`i']==0) {
			local newnoc "`newnoc' `xint`i'' `cnames`i''"
		}
	}
	
	local kxn = `kxn'-1
	local nomscvs "`nomscv1'"
	
	if (`kxn'>1) {
		forvalues i=2/`kxn' {
			if ("`dinter'"=="") {
				local nomscvs "(`nomscvs')##(`nomscv`i'')"
			}
			else if (`i'==`k') {
				local nomscvs ///
					"((`nomscvs')##(`nomscv`i''))`dinter'"
			}
		}	
	}
	else {
		if ("`dvars'"!="") {
			local nomscvs "(`nomscvs')`dinter'"
		}
		else {
			local nomscvs "`nomscvs'"
		}
	}
	
	local cons = 1
	if ("`constant'"!="") {
		local cons = 0
	}
	
	local known "`e(known)'"
	if ("`known'"!="") {
		local knppr = e(knppr)
		if (`knppr'>0) {
			forvalues i=1/`knppr' {
				tempvar xkn`i' 
				quietly generate double `xkn`i'' = . 
				local namesknn "`namesknn' `xkn`i''"
			}
		}
		_parse_known `known' if `touse3', names(`namesknn')
		local nomscvs "`nomscvs' `s(kname)'"
	}
	
	local nomscvs `"`nomscvs' `newnoc' `newnod'"'
	
	fvexpand `nomscvs' if `touse3'
	local b "`r(varlist)'"
	
	// Code for at() with discrete variables  	

	tempname atmat ebknew
	local todos     = e(listatotal)
	local listad    = e(listacambio)
	local atstripes = e(atstripes)
	matrix `atmat'  = e(atmatrix)
	matrix colnames `atmat' =  `atstripes'
	local dinter "`e(dvars)'"
	local atvars "`e(atvars)'"
	local noatc = 0
	if ("`cvars'"!="" & "`c(marginsatvars)'"!="") {
		fvexpand `cvars'
		local cvarnew = r(varlist)
		local kcvn: list sizeof cvarnew
		forvalues i=1/`kcvn' {
			local cnewx: word `i' of `cvarnew'
			_ms_parse_parts `cnewx'
			local cnom "`cnom' `r(name)'"
		}
		local cfinal "`cnom' `cvars'"
		local interx: list atvars - cfinal
		if ("`interx'"=="") {
			local noatc = 1
		}
		local atvars "`interx'"
	}
	local esat = 0 
	if ("`e(cmd_loco)'"=="_npreg_series_two" & "`dinter'"!="" & ///
		"`c(marginsatvars)'"!="" & `noatc'==0) {
		fvexpand `dinter'
		local dinter "`r(varlist)'"
		quietly mata: _dinter_expand_("`dinter'")
		local original  "`e(catnames)' `dinter'"
		matrix `ebknew' = e(b_series)
		if (`cons'==1) {
			matrix colnames `ebknew' = `b' _cons
		}
		else {
			matrix colnames `ebknew' = `b'		
		}
		_fv_term_info `atvars', individuals	///
					fvrestripe	///
					matrix(`ebknew')
	
		local b: colna `ebknew'
		local esat = 1
	}
	if ("`e(cmd_loco)'"=="_npreg_series_two") {
		if (`esat'==0) {
			mata: st_matrix("`beta'", st_matrix("e(b_series)"))
		}
		else {
			mata: st_matrix("`beta'", st_matrix("`ebknew'"))		
		}
	}
	else {
		mata: st_matrix("`beta'", st_matrix("e(b)"))
	}
	matrix rownames `beta' = "`yvar'"
	if (`esat'==0) {
		if (`cons'==1) {	
			matrix colnames `beta' = `b' _cons
		}
		else {
			matrix colnames `beta' = `b'
		}
	}
	else {
		matrix colnames `beta' = `b'
	}	
	if ("`mean'"!="") {
		matrix score `typlist' `variable' = `beta' if `touse3'
		label variable `variable' "mean function"
	}
	else {
		tempvar xbscore 
		quietly matrix score `typlist' `xbscore' = `beta' if `touse3'
		quietly generate `typlist' `variable' = ///
			`yvar' - `xbscore' if `touse3'
		if ("`residuals'"!="") {
			label variable `variable' "residuals"
		}
		else {
			label variable `variable' ///
			"equation-level scores from series estimation"
		}
	}
end 


program define _making_bsknots_p, rclass
	syntax [if][in], [ knots(integer 1)	///
			   cvars(string)	///
			   dvars(string)	///
			   dnp(string)		///
			   orden(integer 3)	///
			   yvar(string)		///
			   variable(string)	///
			   typlist(string)	///
			   noCONstant		///
			   SCores		///
			   Residuals		///
			   mean]	
	
	marksample touse 
	tempvar touse2 touse3
	quietly generate `touse2' = e(sample)
	quietly generate `touse3' = `touse2'*`touse' 
	
	tempname beta matmm mptc2 matmm2 matc matd 
	
	matrix `matmm'  = e(matmm) 
	matrix `matmm2' = e(matmm2) 
	matrix `mptc2'  = e(matknots)
	matrix `matc' 	= e(matcnint)
	matrix `matd' 	= e(matdnint)
	
	local kx:  list sizeof cvars
	forvalues i=1/`kx' {
		tempvar nmx`i'
		local x: word `i' of `cvars'
		local min = `matmm2'[`i', 1]
		local max = `matmm2'[`i', 2]
		quietly generate double `nmx`i'' = ///
			(`x' - `min')/(`max' - `min') if `touse3'
		local xvars "`xvars' `nmx`i''"
	}
	local knotsnew = `knots' + 1
	local k  = `knotsnew'-1
	local k2 = `knotsnew' + `orden'
	local km = 1 
	forvalues i=1/`kx'{
		local x: word `i' of `cvars'
		forvalues j=1/`k2' {
			tempvar _x`i'__b`j'
			quietly generate double	///
				`_x`i'__b`j'' = . ///
				if `touse3'
			local cnames`i' ///
				"`cnames`i'' c.`_x`i'__b`j''"
			local cnoms`i' ///
				"`cnoms`i'' `_x`i'__b`j''"
		}
		local cnames "`cnames' `cnoms`i''"	
	}
	
	if ("`cvars'"!="") {
		mata: _kroenecker_knots("`xvars'", "`mptc2'", `orden',	///
			`kx', "`cnames'", "`matmm'", "`touse3'")
	}
	
	local dz: list sizeof dnp 
	local kfix: list sizeof dinter
	
	if (`matd'[1,1]!=.) {
		local kdnt: list sizeof dvars
		forvalues i=1/`kdnt' {
			local x: word `i' of `dvars'
			if (`matd'[1,`i']==1) {
				local newdnt "`newdnt' `x'"
			}
			else {
				local newnod "`newnod' `x'"
			}
		}
		local dvars "`newdnt'"
	}
	
	if ("`dvars'"!="") {
		_dvar_inter
		local dinter "##(`s(dinter)')"
		local nocv "`s(dinter)'"
	}
	
	local kxn  = 1
	local kxn2 = 1
	
	forvalues i=1/`kx' {
		if (`matc'[1,`i']==.|`matc'[1,`i']==1) {
			local nomscv`kxn' "`cnames`i''"
			local kxn2 = `kxn2' + 1
		}
		else if (`matc'[1,`i']==0) {
			local newnoc "`newnoc' `cnames`i''"
		}
		if ("`dinter'"!="") {
			local nomscv`kxn' "(`nomscv`kxn'')"
		}
		local kxn = `kxn2'
	}

	local kxn = `kxn'-1
	local nomscvs "`nomscv1'" 
	if (`kxn'>1) {
		forvalues i=2/`kxn' {
			local nomscvs "(`nomscvs')##(`nomscv`i'')"
		}	
	}
	if ("`dinter'"!="") {
		local nomscvs "(`nomscvs')`dinter'"
	}
	if ("`cvars'"=="") {
		local nomscvs "`nocv'"
		local notsp "`nocv'"
	}
	
	local cons = 1
	if ("`constant'"!="") {
		local cons = 0
	}
	
	local known "`e(known)'"
	if ("`known'"!="") {
		local knppr = e(knppr)
		if (`knppr'>0) {
			forvalues i=1/`knppr' {
				tempvar xkn`i' 
				quietly generate double `xkn`i'' = . 
				local namesknn "`namesknn' `xkn`i''"
			}
		}
		_parse_known `known' if `touse3', names(`namesknn')
		local nomscvs "`nomscvs' `s(kname)'"
	}

	local nomscvs `"`nomscvs' `newnoc' `newnod'"'
	fvexpand `nomscvs' if `touse3'
	local b "`r(varlist)'"
	// Code for at() with discrete variables  	

	tempname atmat ebknew
	local todos     = e(listatotal)
	local listad    = e(listacambio)
	local atstripes = e(atstripes)
	matrix `atmat'  = e(atmatrix)
	matrix colnames `atmat' =  `atstripes'
	local dinter "`e(dvars)'"
	local atvars "`e(atvars)'"
	local noatc = 0
	if ("`cvars'"!="" & "`c(marginsatvars)'"!="") {
		fvexpand `cvars'
		local cvarnew = r(varlist)
		local kcvn: list sizeof cvarnew
		forvalues i=1/`kcvn' {
			local cnewx: word `i' of `cvarnew'
			_ms_parse_parts `cnewx'
			local cnom "`cnom' `r(name)'"
		}
		local cfinal "`cnom' `cvars'"
		local interx: list atvars - cfinal
		if ("`interx'"=="") {
			local noatc = 1
		}
		local atvars "`interx'"
	}
	local esat = 0 
	if ("`e(cmd_loco)'"=="_npreg_series_two" & "`dinter'"!="" & ///
		"`c(marginsatvars)'"!="" & `noatc'==0) {
		fvexpand `dinter'
		local dinter "`r(varlist)'"
		quietly mata: _dinter_expand_("`dinter'")
		local original  "`e(catnames)' `dinter'"
		matrix `ebknew' = e(b_series)
		if (`cons'==1) {
			matrix colnames `ebknew' = `b' _cons
		}
		else {
			matrix colnames `ebknew' = `b'		
		}
		quietly _fv_term_info `atvars', individuals	///
					fvrestripe	///
					matrix(`ebknew')

		local b: colna `ebknew'
		local esat = 1
	}
	if ("`e(cmd_loco)'"=="_npreg_series_two") {
		if (`esat'==0) {
			mata: st_matrix("`beta'", st_matrix("e(b_series)"))
		}
		else {
			mata: st_matrix("`beta'", st_matrix("`ebknew'"))		
		}
	}
	else {
		mata: st_matrix("`beta'", st_matrix("e(b)"))
	}
	matrix rownames `beta' = "`yvar'"
	if (`esat'==0) {
		if (`cons'==1) {	
			matrix colnames `beta' = `b' _cons
		}
		else {
			matrix colnames `beta' = `b'
		}
	}
	else {
		matrix colnames `beta' = `b'
	}

	if ("`mean'"!="") {
		matrix score `typlist' `variable' = `beta' if `touse3'
		label variable `variable' "mean function"
	}
	else {
		tempvar xbscore 
		quietly matrix score `typlist' `xbscore' = `beta' if `touse3'
		quietly generate `typlist' `variable' = ///
			`yvar' - `xbscore' if `touse3'
		if ("`residuals'"!="") {
			label variable `variable' "residuals"
		}
		else {
			label variable `variable' ///
			"equation-level scores from series estimation"
		}
	}
end


program define _check_intersect, rclass
	syntax [anything] [if] [in], [  cvars(string) 		///
					newvars(string) 	///
					*			///
				      ]
	marksample touse 
	tempname knots mgn A B C D orig mm
	tempvar uno new 
	quietly generate byte `uno'  = 1 if `touse'
	matrix `knots' =  e(matknots)
	matrix `mm'    = e(matmm2)
	local k1 = colsof(`knots')
	local k2: list sizeof cvars
	local bla ""
	forvalues i=1/`k2' {
		tempvar __x`i'_knots
		local nmx`i': word `i' of `cvars'
		matrix `mgn' = `knots'[`i',1..`k1']
		quietly generate  byte `__x`i'_knots' = 0
		forvalues j=1/`k1' {
			if (`j'<`k1') {
				quietly replace `__x`i'_knots' = `j' if	///
					   (`nmx`i''>= `mgn'[1, `j'])	///
					&  (`nmx`i''<= `mgn'[1, `j'+1])
			}
			else {
				quietly replace `__x`i'_knots' = `j' if  ///
					(`nmx`i''> `mgn'[1,`j'])
			}
			local vacio`i' "`vacio`i'' `__x`i'_knots'"
		}
		if (`i'==1) {
			local vacio "ibn.`vacio1'"
		}
		else {
			local vacio "(`vacio')#ibn.(`vacio`i'')"
		}
	}
	mata: _indic_reg("`vacio'", "`orig'", "`touse'")
	fvexpand `vacio' if `touse'
	local dinter = r(varlist)
	quietly mata: _dinter_expand_("`dinter'")
	matrix `B' = `orig''
	matrix `C' = `B'
	matrix colnames `B' = `dinter'
	mata: st_local("bla", ///
	invtokens(select(st_matrixcolstripe("`B'")[.,2], st_matrix("`C'")')'))
	mata: st_matrix("`B'", select(st_matrix("`B'"), st_matrix("`C'")))
	matrix colnames `B' = `bla'
	local k: list sizeof bla
	local todobien = 0 
	forvalues i=1/`k' {
		tempvar check`i'
		local x: word `i' of `bla'
		_ms_parse_parts `x'
		local k2 = r(k_names)
		forvalues j=1/`k2' {
			tempvar nuevof cond`i'`j' viejot`j'
			local nuevo: word `j' of `newvars' 
			local viejo0: word `j' of `cvars' 
			_ms_parse_parts `x'
			tempvar x`i'`j'
			local name  = r(name`j')
			local level = r(level`j')
			quietly generate double `x`i'`j'' =	///
				`viejo0'*(`level'.`name')
			summarize `x`i'`j'' if `level'.`name' & ///
				`touse', meanonly
			local max = r(max)
			local min = r(min)
			quietly summarize `nuevo' if `touse', meanonly
			local max0 = r(max)
			local min0 = r(min)
			if (float(`max0')==float(`min0')) {
				local min1 = `mm'[`j', 1]
				local max1 = `mm'[`j', 2]		 			
			}
			else {
				local max1 = `max0'
				local min1 = `min0'
			}
			quietly generate double `nuevof' = 	///
			(`nuevo' - `min1')/(`max1'-`min1') if `touse'
			quietly generate byte `cond`i'`j'' =	///
				cond(`nuevof'<=`max', 1, 0)*	///
				cond(`nuevof'>=`min', 1, 0) 	///
				if `touse'
			capture drop `nuevof'
			if (`j'==1) {
				quietly generate `check`i'' = `cond`i'`j'' ///
					if `touse'
			}
			else {
				quietly replace `check`i'' = `check`i''* ///
					`cond`i'`j'' if `touse'
			}
		}
		summarize `check`i'', meanonly 
		local media = r(mean)
		if (`media'>0) {
			local todobien = `todobien' + 1
			mata: st_numscalar("e(empty_cell)", 1, "hidden")
		}
	}
	return local todobien = `todobien'
end


program define _check_cvars
	syntax [anything] [if] [in], [cvars(string) tolerance(string)	///
					atsample *]
	
	marksample touse
	tempname minmax
	
	matrix `minmax' = e(matmm3)
	local k: list sizeof cvars
	
	forvalues i=1/`k' {
		tempvar epsilon`i'
		local y: word `i' of `cvars'
		_ms_parse_parts `y'
		local x = r(name)
		summarize `x' if `touse', meanonly 
		local max   = r(max) 
		local min   = r(min) 
		quietly generate `epsilon`i'' = (abs(`x') + ///
			(epsdouble())^(1/3))*(epsdouble())^(1/3) if `touse'
		summarize `epsilon`i'' if `touse', meanonly
		if ("`tolerance'"=="") {
			local tolerancia = abs(100*r(max))
		}
		else {
			_string_or_real, mystring("`tolerance'") ///
				optn("tolerance")
			local tolerancia = abs(real("`tolerance'"))
		}
		local fmax  = `minmax'[`i',2] + `tolerancia'
		local fmin  = `minmax'[`i',1] - `tolerancia' 	
		if (`fmax'<`max' & "`atsample'"=="") {
			local c = strofreal(`tolerancia')
			display as error "prediction outside valid range "
			if ("`tolerance'"=="") {
		di as err "{p 2 2 2}" 	
		di as smcl as err "Predictions outside the range of"
		di as smcl as err " the original data are unreliable."
		di as smcl as err " The maximum of {bf:`x'}"
		di as smcl as err " exceeds the maximum of {bf:`x'} used"
		di as smcl as err " for estimation by more than `c',"
		di as smcl as err " the maximum tolerance allowed."
		di as smcl as err " You may"
		di as smcl as err " modify this tolerance using the"
		di as smcl as err " {bf:tolerance()} option or"
		di as smcl as err " restrict your counterfactual"
		di as smcl as err " inquiries to the estimation sample"
		di as smcl as err " using the {bf:atsample} option."
		di as smcl as err "{p_end}"			
		exit 198
			}
			else {
		di as err "{p 2 2 2}" 	
		di as smcl as err " The maximum of {bf:`x'}"
		di as smcl as err " exceeds the maximum of {bf:`x'} used"
		di as smcl as err " for estimation by more than `c',"
		di as smcl as err " the maximum tolerance requested."
		di as smcl as err " You may"
		di as smcl as err " modify this tolerance using the"
		di as smcl as err " {bf:tolerance()} option or"
		di as smcl as err " restrict your counterfactual"
		di as smcl as err " inquiries to the estimation sample"
		di as smcl as err " using the {bf:atsample} option."
		di as smcl as err "{p_end}"			
		exit 198			
			}
		}
		if (`min'<`fmin'  & "`atsample'"=="") {
			local c = strofreal(`tolerancia')
			display as error "prediction outside valid range "
			if ("`tolerance'"=="") {	
		di as err "{p 2 2 2}" 
		di as smcl as err "Predictions outside the range of"
		di as smcl as err " the original data are unreliable."
		di as smcl as err " The minimum of {bf:`x'}"
		di as smcl as err " is less than the minimum of"
		di as smcl as err " {bf:`x'} used"
		di as smcl as err " for estimation by more than `c',"
		di as smcl as err " the minimum tolerance allowed."
		di as smcl as err " You may"
		di as smcl as err " modify this tolerance using the"
		di as smcl as err " {bf:tolerance()} option or"
		di as smcl as err " restrict your counterfactual"
		di as smcl as err " inquiries to the estimation sample"
		di as smcl as err " using the {bf:atsample} option."
		di as smcl as err "{p_end}"			
		exit 198
			}
			else {
		di as err "{p 2 2 2}" 
		di as smcl as err " The minimum of {bf:`x'}"
		di as smcl as err " is less than the minimum of"
		di as smcl as err " {bf:`x'} used"
		di as smcl as err " for estimation by more than `c',"
		di as smcl as err " the minimum tolerance requested."
		di as smcl as err " You may"
		di as smcl as err " modify this tolerance using the"
		di as smcl as err " {bf:tolerance()} option or"
		di as smcl as err " restrict your counterfactual"
		di as smcl as err " inquiries to the estimation sample"
		di as smcl as err " using the {bf:atsample} option."
		di as smcl as err "{p_end}"			
		exit 198			
			}
		}
	}
end

program define _string_or_real 
	syntax, mystring(string) optn(string)
	local sp = real("`mystring'")
	if (`sp'==.) {
		display as error "option {bf:`optn'()} "	///
			"specified incorrectly"
		di as err "{p 2 2 2}" 		
		di as smcl as err " You should specify an"
		di as smcl as err " integer not a string"
		di as smcl as err "{p_end}"		
		exit 198		
	}
end

program define _parse_known, sclass
	syntax varlist(numeric fv) [if][in], [predict(string) names(string)]
	
	marksample touse 
	
	tempname mmat
	
	fvexpand `varlist' if `touse'
	local newcovars = r(varlist)
	local k: list sizeof newcovars
	local ktest = e(knppr)
	if (`ktest'>0) {
		local knp = 1
		matrix `mmat' = e(minmaxp)
	}
	forvalues i=1/`k' {
		local x: word `i' of `newcovars'
		_ms_parse_parts `x'
		local tipo   = r(type)
		if ("`tipo'"=="interaction") {
			local k2 = r(k_names)
			forvalues j=1/`k2' {
				local myop  = r(op`j')
				local namej = r(name`j')
				if ("`myop'"=="c"|"`myop'"=="co") {
					local inter: list namej & cnamel 
					if ("`inter'"=="") {
						local __x`i'`j'p:	///
						word `knp' of `names'
						local min = `mmat'[`knp', 1]
						local max = `mmat'[`knp', 2]
						quietly replace ///
						`__x`i'`j'p' = ///
						(`namej'-`min')/ ///
						(`max'-`min')	if `touse'
						local nomxp "c.`__x`i'`j'p'"
						local nomxp0 "`namej'"
						local knp = `knp' + 1
					}
					if (`j'==1) {
						local newnom	///
						"`nomxp'#"
						local newnom0	///
						"c.`namej'#"
					}
					else if (`j'<`k2') {
						local newnom	///
						"`newnom'`nomxp'#"	
						local newnom0	///
						"`newnom0'c.`namej'#"			
					}
					if (`k2'>1 & `j'==`k2') {
						local newnom	///
						"`newnom'`nomxp'"
						local newnom0	///
						"`newnom0'c.`namej'"
					}
				}
				else {
					local dnomj "`myop'.`namej'"
					if (`j'==1) {
						local newnom	///
						"`dnomj'#"
					}
					else if (`j'<`k2') {
						local newnom	///
						"`newnom'`dnomj'#"			
					}
					if (`k2'>1 & `j'==`k2') {
						local newnom	///
						"`newnom'`dnomj'"
					}
					local newnom0 "`newnom'"
				}
				local cnamel "`cnamel' `namej'"
			}
			local kname "`kname' `newnom'"
			local kname0 "`kname0' `newnom0'"
		}
		else if ("`tipo'"=="variable") {
			local namej = r(name)
			local inter: list namej & cnamel 
			if ("`inter'"=="") {
				local ___x`i'p:	///
				word `knp' of `names'
				local min = `mmat'[`knp', 1]
				local max = `mmat'[`knp', 2]
				quietly replace ///
				`___x`i'p' = ///
				(`namej'-`min')/ ///
				(`max'-`min')	if `touse'
				local nomxp "c.`___x`i'p'"
				local knp = `knp' + 1
			}
			local cnamel "`cnamel' `namej'"
			local kname "`kname' `nomxp'"
			local kname0 "`kname0' `namej'"
		}
		if ("`tipo'"=="factor"){
			local namej = r(name)
			local opa "`r(op)'"
			local kname "`kname' `opa'.`namej'"
			local kname0 "`kname0' `opa'.`namej'"
		}
	}

	 sreturn local kname "`kname'"
end

program define _dvar_inter, sclass
	local names "`e(dvars)'"
	local cvars "`e(cvars)'"
	local k1: list sizeof names 
	local j = 1 
	forvalues i=1/`k1' {
		local uno: word `i' of `names'
		_ms_parse_parts `uno'
		local name1 = r(name)
		if (`i'==1) {
			local name0 "`name1'"
		}
		if("`name1'"=="`name0'") {
			local n`j' "`n`j'' `uno'"
		}
		else {
			local j = `j' + 1
			local n`j' "`uno'"
		}
		local name0 "`name1'"
	}
	local k2 = `j'
	if ("`cvars'"=="" & `k2'==1) {
		local dinter "`n1'"
	}
	if ("`cvars'"!="" & `k2'==1) {
		local dinter "(`n1')"
	}
	local dinter0 "(`n1')"
	if (`k2'>1) {
		forvalues i=2/`k2' {
			local dinter "`dinter0'##(`n`i'')"
			local dinter0 "`dinter'"
		}
	}
	sreturn local dinter "`dinter'"
end

program define _reg_inter, sclass
	local cvars "`e(cantes)'"
	if ("`e(dvars)'"!="") {
		_dvar_inter
		local dinter "`s(dinter)'"
		if ("`e(basis)'"=="polynomial") {
			fvexpand `dinter'
			local dinterpoly "`r(varlist)'"
			local k: list sizeof dinterpoly 
			forvalues i=1/`k' {
				local x: word `i' of `dinterpoly'
				_ms_parse_parts `x'
				if ("`r(type)'"!="interaction") {
					local a = r(level)
					local b = r(name)
					local s "`s' `a'.`b'"
				}
				else {
					local k2 = r(k_names)
					local int ""
					forvalues j=1/`k2' {
						local a = r(name`j')
						local b = r(level`j')
						if (`j'<`k2') {
							local int ///
							"`int'`a'.`b'#"
						}
						else {
							local int ///
							"`int'`a'.`b'#"
						}
					}
					local s "`s' `int'"
				}
			}
			local dinter "`s'"
		}
	}
	if ("`cvars'"!="" & "`dinter'"!="") {
		local lpol "(`cvars')##(`dinter')"
	}
	if ("`cvars'"!="" & "`dinter'"=="") {
		local lpol "`cvars'"
	}
	if ("`cvars'"=="" & "`dinter'"!="") {
		local lpol "`dinter'"
	}
	sreturn local lpol "`lpol'"
end

program define _at_sample
	syntax [anything][if][in], [atnombre(string) cvars(string)]
	
	marksample touse 
	
	tempname minmax
	tempvar atnombre0 
	generate `atnombre0' = `touse'
	matrix `minmax' = e(matmm3)
	local k: list sizeof cvars
	
	forvalues i=1/`k' {
		local x: word `i' of `cvars'
		tempvar atnombre`i'
		local max = `minmax'[`i',2]
		local min = `minmax'[`i',1]
		generate `atnombre`i'' =  (`x'>=`min')*(`x'<=`max')
		quietly replace `atnombre0' = `atnombre0'*`atnombre`i''
	}
	quietly replace `atnombre' = `atnombre0'
	capture drop `.t_atsm'
	quietly gen byte `.t_atsm' = `atnombre'
end

