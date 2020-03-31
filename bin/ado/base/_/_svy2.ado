*! version 1.7.1  21oct2019
program _svy2, rclass sort
	version 9
	local vv : di "version " string(_caller()) ":"
	if _caller() >= 16 {
		local FV fv
	}
	syntax varlist(numeric `FV') [if] [in]	///
		[pw iw],			///
		TYPE(name)			///
	[					///
		SVY ZEROweight			///
		over(passthru)			///
		SUBpop(passthru)		///
		sovar(varname numeric)		/// undocumented
		FIRSTCALL			/// undocumented
		B(name)				/// output matrices
		V(name)				///
		VSRS(name)			///
		STRata(varname)			///
		CLuster(varname)		///
		STDize(varname)			///
		STDWeight(varname numeric)	///
		noSTDRescale			///
		TOUSE1(name)			///
		JKNIFE				///
		JKRW				///
		NOVARIANCE			///
		dof(numlist max=1 int >0)	///
		fvbase(string)			///
		*				///
	]
	local fvops = "`s(fvops)'" == "true"
	if "`type'" == "ratio" {
		if `fvops' {
			error 6102
		}
	}

	if "`jkrw'" != "" {
		local jknife jkrw
	}

	if "`svy'" != "" {
		if "`cluster'" != "" {
			di as err "option cluster() is not allowed with svy"
			exit 198
		}
		if "`strata'" != "" {
			di as err "option strata() is not allowed with svy"
			exit 198
		}
		if "`weight'" != "" {
			di as err ///
	"weights can only be supplied to {help svyset##|_new:svyset}"
			exit 198
		}
	}
	else {
		if "`dof'" != "" {
			di as err "option dof() not allowed"
			exit 198
		}
		if `"`options'"' != "" {
			local 0 `", `options'"'
			syntax [, BADOPTION ]
			di as err "option badoption not allowed"
			exit 198
		}
	}

	if !inlist("`type'","mean","ratio","total") {
		di as err "option type(`type') invalid"
		exit 198
	}
	if "`type'" == "ratio" {
		if mod(`:word count `varlist'',2) {
			di as err ///
			"invalid number of variables for type(ratio)"
			exit 198
		}
	}
	if "`jknife'" != "" {
		if "`type'" != "total" {
			di as err "option jknife requires option type(total)"
			exit 198
		}
		if "`v'`vsrs'" == "" {
			di as err ///
			"option jknife requires option v() or vsrs()"
			exit 198
		}
	}
	if "`novariance'" != "" & "`v'" == "" {
		tempname v
	}

	if "`svy'`zeroweight'" != "" | "`weight'" == "iweight" {
		local zero zeroweight
	}

	marksample touse, novarlist `zero'
	if "`cluster'`strata'" != "" {
		markout `touse' `cluster' `strata', strok
	}
	if "`stdize'" != "" {
		markout `touse' `stdize', strok
		markout `touse' `stdweight'
	}

	// get the -svyset- information
	local firstcall : length local firstcall
	if `:length local sovar' {
		local subuse : copy local sovar
		local resampling resampling
	}
	else	tempvar subuse
	`vv'				///
	_svy_setup `touse' `subuse',	///
		`svy'			///
		cmdname(`type')		///
		`over'			///
		`subpop'		///
		`resampling'		///
		// blank
	return add
	local posts	`return(poststrata)'
	if !`:length local dof' {
		local dof `"`return(dof)'"'
	}
	if _caller() >= 16 & "`type'" != "ratio" {
		local olist `"`return(over)'"'
		if `:list sizeof olist' { 
			fvrevar `varlist', list
			local vlist `"`r(varlist)'"'
			local both : list olist & vlist
			if `:list sizeof both' {
				gettoken var : both
				di as err ///
	"over variable {bf:`var'} not allowed in {it:varlist}"
				exit 198
			}
		}
	}

	if !inlist("`return(stages_wt)'", "0", "") {
		local wlist `"`return(wlist)'"'
		foreach w of local wlist {
			quietly replace `subuse' = 0 if `w' <= 0 | missing(`w')
		}
		local wlist : subinstr local wlist " " "*", all
		local wexp "= `wlist'"
		local wtype pweight
	}

	// mark out observations where the varlist variables contain missing
	// values, then update 'touse' and 'subuse' accordingly
	quietly count if `subuse'
	local nsub = r(N)
	tempvar	vltouse
	mark `vltouse' if `touse'
	markout `vltouse' `varlist'
	if `:length local zero' & `"`return(wexp)'`weight'"' != "" {
		if `:length local weight' {
			local wexp : copy local exp
		}
		else	local wexp `"`return(wexp)'"'
		gettoken equal wvar : wexp, parse(" =")
		local wvar : list retok wvar
		quietly replace `touse' = 0 if `subuse' & !`vltouse' & `wvar'
	}
	else {
		quietly replace `touse' = 0 if `subuse' & !`vltouse'
	}
	drop `vltouse'
	if "`resampling'" == "" | `firstcall' {
		quietly replace `subuse' = 0 if !`touse'
		quietly count if `subuse'
		if r(N) < `nsub' {
			return clear
			local lab : value label `subuse'
			if "`lab'" != "" {
				label drop `lab'
			}
			quietly drop `subuse'
			`vv'				///
			_svy_setup `touse' `subuse',	///
				`svy'			///
				cmdname(`type')		///
				`over'			///
				`subpop'		///
				// blank
			return add
		}
	}

	local nobs1 = c(N) - return(N) + 1
	if `nobs1' != 1 & "`posts'`stdize'" != "" {
		// sort the data by the estimation sample, then use -in-
		sort `touse'
		local ifin "in `nobs1'/l"
		local i1i2 "(`nobs1', `c(N)')"
	}
	else {
		if `nobs1' != 1 {
			// no need to sort, so just use -if-
			local ifin if `touse'
		}
		local i1i2 "."
	}

	return local settings
	return local brrweight
	return local bsrweight
	return local jkrweight
	return local sdrweight
	return local dof
	if "`svy'" != "" {
		local stages	= return(stages)
		if missing(`stages') {
			local stages 1
		}
		if `stages' > 1 & "`jknife'" != "" {
			local stages 1
		}
		local hasstr 0
		forval i = 1/`stages' {
			if "`return(strata`i')'" != "" {
				local stri `return(strata`i')'
				if bsubstr("`:type `stri''",1,3) == "str" {
					tempvar stru
					qui egen `stru' = group(`stri') `ifin'
					local stri `stru'
				}
				local strata `strata' `stri'
				local sortlist `sortlist' `stri'
				local ++hasstr
			}
			else {
				// NOTE: `sui' exists because you
				// cannot have stratification at level
				// i if the sampling units are the
				// observations at level i-1
				if `i' == 1 & `stages' > 1 {
					local strata `touse'
				}
				else if `i' < `stages' {
					local strata `strata' `sui'
				}
			}
			if "`return(su`i')'" != "" {
				local sui `return(su`i')'
				if bsubstr("`:type `sui''",1,3) == "str" {
					tempvar sutmp
					qui egen `sutmp' = group(`sui') `ifin'
					local sui `sutmp'
				}
				local su `su' `sui'
				local sortlist `sortlist' `sui'
			}
			// else there is one less su var than stages
			local fpc	`fpc' `return(fpc`i')'
		}
		if !`hasstr' {
			local strata
		}
		local posts	`return(poststrata)'
		local postw	`return(postweight)'
		local calmethod	`"`return(calmethod)'"'
		local calmodel	`"`return(calmodel)'"'
		local calopts	`"`return(calopts)'"'
		local singleu	`return(singleunit)'
		local wtype	`return(wtype)'
		local wexp	`"`return(wexp)'"'
		if "`calmethod'" != "" {
			tempname wvar
			if "`fvbase'" != "" {
				set fvbase `fvbase'
			}
			quietly				///
			svycal `calmethod' `calmodel'	///
				[`wtype'`wexp'] `ifin',	///
				generate(`wvar')	///
				`calopts'
			set fvbase off
		}
		else if "`wlist'" != "" {
			tempname wvar
			quietly gen double `wvar' `wexp' `ifin'
		}
		else {
			gettoken equal wvar : wexp, parse(" =")
			local wvar : list retok wvar
		}
	}
	else {
		if "`cluster'" != "" {
			if bsubstr("`:type `cluster''",1,3) == "str" {
				tempvar clvar
				qui egen `clvar' = group(`cluster') `ifin'
			}
			else	local clvar `cluster'
		}
		if "`strata'" != "" {
			local ustrata `strata'
			if bsubstr("`:type `strata''",1,3) == "str" {
				tempvar stvar
				qui egen `stvar' = group(`strata') `ifin'
			}
			else	local stvar `strata'
		}
		if "`weight'" != "" {
			tempvar wvar
			quietly gen double `wvar' `exp' `ifin'
			local wexp `"`:list retok exp'"'
		}
		local stages	1
		local su	`clvar'
		local strata	`stvar'
		local sortlist	`strata' `su'
		local wtype	`weight'
	}
	if `fvops' {
		fvexpand `varlist' if `subuse'
		local varlist `"`r(varlist)'"'
	}

	if "`calmethod'" != "" {
		// generate calibration residuals for VCE
		if `fvops' {
			fvrevar `varlist' if `subuse'
			local VARLIST `"`r(varlist)'"'
		}
		else	local VARLIST : copy local varlist
		if "`type'" == "mean" {
			foreach var of local VARLIST {
				local CALVARS `CALVARS' `var' `touse'
			}
		}
		else {
			local CALVARS : copy local VARLIST
		}
		tempname rstub
		if "`over'`subpop'" != "" {
			local subopt subuse(`subuse')
		}
		if inlist("`type'","mean","ratio") {
			local pairs pairs
		}
		_svycal_residuals `CALVARS' if `touse',	///
			stub(`rstub')			///
			wcal(`wvar')			///
			`pairs'				///
			`subopt'
		unab calres : `rstub'*
	}
	else if "`posts'" != "" {
		// poststratification
		tempvar postid
		sort `touse' `posts'
		GenId `postid' `posts' `nobs1'
		local postvars `postid' `postw'

		// do not return vsrs() for poststratification
		local vsrs
	}

	// standardization
	if "`stdize'`stdweight'" != "" {
		if "`type'" == "total" {
			di as err ///
"options stdize() and stdweight() are not allowed for totals"
			exit 198
		}
		if `:word count `stdize' `stdweight'' == 1 {
			if "`stdweight'" == "" {
				di as err ///
				"option stdize() requires stdweight()"
			}
			if "`stdize'" == "" {
				di as err ///
				"option stdweight() requires stdize()"
			}
			exit 198
		}
		tempvar stdid
		sort `touse' `stdize'
		GenId `stdid' `stdize' `nobs1'
		local stdvars `stdid' `stdweight'

		return local stdize `stdize'
		return local stdweight `stdweight'

		if "`svy'" != "" {
			// do not return vsrs() for svy standardization
			local vsrs
		}
	}
	else if "`stdrescale'" != "" {
		di as err "option nostdrescale requires option stdize()"
		exit 198
	}

	local mvarlist	`varlist'	///
			`calres'	///
			`subuse'	///
			`stdvars'	///
			`wvar'		///
			`fpc'		///
			`strata'	///
			`su'		///
			`postvars'
	local mvarlist	: list retok mvarlist
	local kinput	: list sizeof varlist
	local kcalres	: list sizeof calres
	local ksubuse	: list sizeof subuse
	local kstdvars	: list sizeof stdvars
	local stdrescale = "`stdrescale'" == ""
	local kwvar	: list sizeof wvar
	local kfpc	: list sizeof fpc
	local kstrata	: list sizeof strata
	local ksu	: list sizeof su
	local kpostvars	: list sizeof postvars

	if `"`sortlist'"' != "" {
		sort `touse' `sortlist'
	}
	capture			///
	mata: _svy2(		///
		"`b'",		/// OUTPUT: point estimates
		"`v'",		/// OUTPUT: variance estimates
		"`vsrs'",	/// OUTPUT: SRS variance estimates
		"`type'",	/// INPUT:  summary type
		`i1i2',		/// INPUT:  (i1, i2)
		"mvarlist",	/// INPUT:  local holding stata variables
		"`touse'",	/// INPUT:  touse variable
		`kinput',	/// INPUT:  # of input vars to summarize
		`kcalres',	/// INPUT:  # of calibration residuals
		`ksubuse',	/// INPUT:  .,0,1 for subuse (over) var
		`kstdvars',	/// INPUT:  .,0,2 for stdize vars
		`stdrescale',	/// INPUT:  .,0,1 for stdrescale
		`kwvar',	/// INPUT:  .,0,1 for wvar
		`stages',	/// INPUT:  # of stages
		`kfpc',		/// INPUT:  # of fpc vars
		`kstrata',	/// INPUT:  # of strata vars
		`ksu',		/// INPUT:  # of sample unit vars
		`kpostvars',	/// INPUT:  .,0,2 for poststrata vars
		"`singleu'",	/// INPUT:  singleunit string code
		"`jknife'"	/// INPUT:  jknife string code
	)

	if c(rc) error c(rc)

	// saved results
	local sclist : r(scalars)
	foreach sc of local sclist {
		return scalar `sc' = r(`sc')
	}
	local matlist : r(matrices)
	tempname m
	foreach mat of local matlist {
		matrix `m' = r(`mat')
		return matrix `mat' `m'
	}
	if "`svy'" != "" {
		if `:length local dof' {
			return scalar df_r = `dof'
		}
		else	return scalar df_r = r(N_psu) - r(N_strata)
		if `"`return(subpop)'"' == "" {
			return local N_sub
			return local N_subpop
		}
	}
	else {
		if inlist("`wtype'", "fweight", "iweight") {
			return scalar N = r(N_pop)
			return scalar df_r = r(N_pop) - 1
		}
		else	return scalar df_r = r(N) - 1
		if "`cluster'" != "" {
			return hidden local cluster `cluster'
			return scalar df_r = r(N_psu) - r(N_strata)
			return scalar N_clust = r(N_psu)
		}
		if "`ustrata'" != "" {
			return local strata `ustrata'
			return scalar N_strata = r(N_strata)
		}
		else {
			return local N_strata
		}
		if "`wtype'" != "" {
			return local wtype `wtype'
			return local wexp  `"`wexp'"'
		}
		return local N_sub
		return local N_subpop
		return local N_pop
		return local N_psu
	}
	if "`touse1'" != "" {
		capture confirm new var `touse1'
		if c(rc) {
			quietly replace `touse1' = `touse'
		}
		else	rename `touse' `touse1'
	}
end

program GenId
	// Assumption:  the data is sorted by a "touse" variable and the
	// "oldid" variable.
	//
	// Note: this routine is much faster than using -egen, group()- or
	// -by: generate- with an -if-, given the above assumption.
	args newid oldid nobs1
	local in `nobs1'/l
	quietly gen `newid' = `oldid' != `oldid'[_n-1] in `in'
	quietly replace `newid' = 1 in `nobs1'
	quietly replace `newid' = sum(`newid') in `in'
	sum `newid', meanonly
	if r(max) > c(max_matdim) {
		error 915
	}
end

exit
