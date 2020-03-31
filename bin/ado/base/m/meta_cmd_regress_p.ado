*! version 1.0.1  14mar2019
program define meta_cmd_regress_p
	version 16
	
	local myopts "STDF RESiduals FITted FIXEDonly REFfects"
	local myopts "`myopts' SE(string) Hat Leverage"
	
	_pred_se "`myopts'" `0'		/* handles xb and stdp */
	if `s(done)' {
		exit
	}
	
	local typ `s(typ)'
	local varn `s(varn)'
	local 0    `"`s(rest)'"'
	syntax [if] [in] [, `myopts' noOFFset]  // stdf  undoc
	
	marksample touse
	
	local oplist "`stdf' `residuals' `fitted' `xb' `stdp' `reffects'"
	local oplist "`oplist' `hat' `leverage'"
	opts_exclusive "`oplist'"
	
	if !missing("`leverage'") local hat hat // synonym for -hat-
	
	local type "`stdf'`residuals'`fitted'`reffects'`hat'"
	
	if "`e(model)'"!="random" {
		if !missing("`reffects'") {
			di as err "{p}option {bf:reffects} is valid only " ///
				"with random-effects meta-regression{p_end}"
			exit 498	
		}
		if !missing("`fixedonly'") {
			di as txt "{p 0 6 2}"			///
		  "note: option {bf:fixedonly} ignored{p_end}"
		  local fixedonly
		}
	}
	
	if !missing("`se'") {
		_parse comma se setype : se
		local 0 `setype'
		
		syntax [, marginal *]
		if !missing("`options'") {
			di as err "{p}invalid option {bf:se()}; " ///
				"suboption {bf:`options'} not allowed{p_end}"
			exit 198
			
		}
		if !missing("`marginal'") { 
			if !inlist("`type'", "residuals", "fitted") {
				di as err "{p}suboption {bf:marginal} " ///
				"within the {bf:se()} option may be " ///
				"specified only with options {bf:residuals}" ///
				" or {bf:fitted}{p_end}"
				exit 198
			}
			if "`e(model)'"!="random" {
				di as err "{p}suboption {bf:marginal} " ///
				"within the {bf:se()} option may be " ///
				"specified only with random-effects " ///
				"meta-regression{p_end}"
				exit 198
			}
			if missing("`fixedonly'") {
				di as err "{p}suboption {bf:marginal} " ///
				"within the {bf:se()} option requires " ///
				"option {bf:fixedonly}{p_end}"
				exit 198
			}
		}
		cap confirm new var `se', exact
		if _rc {
			di as err "invalid option {bf:se(`se')}; " ///
				"variable {bf:`se'} already defined"
			exit 110	
		}
		local which "`hat' `stdf' `stdp'"
		local k : word count `which'
		if `k' > 0 {
			di as err "{p}option {bf:se(`se')} is not allowed " ///
			"with option {bf:`which'}{p_end}"
			exit 184
		}
	}
	
	if !missing("`fixedonly'") {
		local which "`reffects' `stdf'" 
		local k : word count `which'
		if `k' > 0 {
			di as err "{p}option {bf:fixedonly} is not allowed " ///
			"with option {bf:`which'}{p_end}"
			exit 184
		}
	}
		
	local db double	
	tempvar tau2 phi
	scalar `tau2' = cond("`e(tau2)'"=="", 0, e(tau2))
	scalar `phi' = cond("`e(phi)'"=="", 1, e(phi))
	if "`type'"==""  {
		if !missing("`se'") {
			di as err ///
			"option {bf:se()} is not allowed with option" ///
			" {bf:xb}"
			exit 184
		}
		if !missing("`fixedonly'") {
			di as err ///
			"option {bf:fixedonly} is not allowed with option" ///
			" {bf:xb}"
			exit 184
		}
		di "{txt}(option {bf:xb} assumed; fitted values)"
		_predict `typ' `varn' `if' `in', xb `offset'
		
		exit
	}
	
	if inlist("`type'", "stdf", "hat") | !missing("`se'") {
		tempvar stdp
		if missing("`fixedonly'") | !missing("`setype'") {
			// H(v+tau^2) eq 13 in W. VIECHTBAUER, Cheung (2010)
			qui _predict `db' `stdp' if `touse', stdp `offset'
		}
		else {
			tempvar stdp TOUSE
			qui gen byte `TOUSE' = e(sample)
			
			qui gen double `stdp' = . 
			mata: _hat_fixedonly("`stdp'" , "`e(indepvars)'", ///
				"`e(depvar)'", "_meta_se", ///
				`= 1 - `e(noconstant)'', "`TOUSE'" )	
		}
		
	}
	
	if inlist("`type'", "reffects", "fitted",  "residuals") {
		tempvar xb
		qui _predict `db' `xb' if `touse', xb  `offset'
	}

	if inlist("`type'","reffects","fitted","residuals") | !missing("`se'") {
		tempvar lambda   /* Bayes shrinkage factor */
		qui gen `db' `lambda' =  `tau2' / ( `tau2' + _meta_se^2 ) ///
			 if `touse'
		tempvar xbu
		gen `db' `xbu' = `lambda'*`e(depvar)' + (1-`lambda')*`xb' ///
			 if `touse'	 
	}

	if "`type'" == "reffects" {
		gen `typ' `varn' = `lambda' * ( `e(depvar)' - `xb' ) if `touse'
		label var `varn' "Predicted random effects"
		if !missing("`se'") {
			gen `typ' `se' =  `lambda' * ///
				sqrt( _meta_se^2 + `tau2'-`stdp'^2 ) if `touse'
			label var `se' "S.E. of random effects"
		}
		exit
	}
	
	if "`type'" == "fitted" {
		if "`c(marginscmd)'" == "on" {			
			if "`fixedonly'" == "" local fixedonly fixedonly	
		}
		if missing("`fixedonly'") & "`e(model)'"=="random" {
			gen `typ' `varn' = `xbu' if `touse'
			label var `varn' "Fitted values (xb + u)"
			if !missing("`se'") {
				gen `typ' `se'=sqrt(`lambda'^2*(_meta_se^2+ ///
				`tau2') + (1-`lambda'^2) * `stdp'^2) if `touse'
				label var `se' "S.E. of fitted values"
			}			
		}
		else {
			gen `typ' `varn' = `xb' if `touse'
			label var `varn' "Fitted values; fixed portion (xb)"
			if !missing("`se'") {
				gen `typ' `se' = `stdp' if `touse'
				label var `se' "S.E. of xb (stdp)"
			}
		}
		exit
	}
	
	if "`type'" == "residuals" {
		if missing("`fixedonly'")  & "`e(model)'"=="random" {
			gen `typ' `varn' = `e(depvar)' - `xbu'  if `touse'
			label var `varn' "Residuals (y - (xb+u))"
			if !missing("`se'") {
				gen `typ' `se' = sqrt(_meta_se^2 + `tau2' ///
				   - `stdp'^2)*sqrt(1 + `lambda'^2) if `touse'
				label var `se' "S.E. of Residuals"
			}			
		}
		else {
			gen `typ' `varn' = `e(depvar)' - `xb'  if `touse'
			label var `varn' "Residuals; fixed portion (y - xb)"
			if !missing("`se'") {
				if missing("`setype'") {
		gen `typ' `se' = sqrt(`phi'*_meta_se^2 - `stdp'^2) if `touse'				
				}
				else {
		gen `typ' `se' = sqrt(_meta_se^2 + `tau2'-`stdp'^2) if `touse'		
				}

				label var `se' "S.E. of Residuals"
			}
		}		
		exit
	}
	
	if "`type'" == "stdf" {
		gen `typ' `varn' =  sqrt( `stdp'^2 + `tau2' ) if `touse'
		label var `varn' "S.E. of the forecast"
		exit
	}

	if "`type'" == "hat" {
		if missing("`fixedonly'")  & "`e(model)'"=="random" {
			gen `typ' `varn' = `stdp'^2/( _meta_se^2 + `tau2' ) ///
				if `touse'
			label var `varn' "Leverage"
		}
		else {
			gen `typ' `varn' = `stdp'^2/(`phi' * _meta_se^2) ///
				if `touse'
			label var `varn' "Leverage"
		}
		exit
	}
			
end
