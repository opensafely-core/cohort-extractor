*! version 1.0.10  16feb2015
program ml_score, rclass
	version 9, missing
	syntax anything(name=scvars id="newvarlist")	///
		[if] [in] [, FORCEscores OLDOLOGit MISSing * ]

	marksample touse, novarlist

	if "`oldologit'" != "" {
		local 0 , `oldologit'
		syntax [, NONOPTION ]
		exit 198		// [sic]
	}
	if "`e(cmd)'" != "" {
		if "`e(prefix)'" == "svy" {
			local pre "svy:"
		}
		local cmd `e(cmd)'
		Chk_Method method : `cmd' `forcescores'
	}
	else	error 301

	local depvars	`e(depvar)'
	tempname b
	if "`e(b)'" != "matrix" {
		error 301
	}
	matrix `b' = e(b)
	// `eqnames'	:= list of equation names
	// `eq`i'xvars'	:= list of predictors for the `i'th equation
	// `neq'	:= number of equations
	_get_eqspec eqnames eq neq : `b'

	_score_spec `scvars', b(`b') `options'
	local spec	`s(eqspec)'
	local scvars	`s(varlist)'
	local typlist	`s(typlist)'
	if `neq' > 1 & `:word count `typlist'' == 1 {
		forval i = 1/`neq' {
			local typcp `typcp' `typlist'
		}
		local typlist `typcp'
	}
	if "`spec'" != "" {
		local spec = bsubstr("`spec'",2,.)	// drop '#'
		local scvari `scvars'			// newvarname
		local scvars
		forval i = 1/`neq' {
			tempname sci
			local scvars `scvars' `sci'
		}
	}
	else {
		local spec _all_
	}
	confirm new var `scvars' `scvari'

	// build equation specifications for -ml model-
	local scores
	forval i = 1/`neq' {
		local eq : word `i' of `eqnames'
		local typ : word `i' of `typlist'
		tempname scorei
		quietly gen `typ' `scorei' = . in 1
		local scores `scores' `scorei'
		_get_offopt `e(offset`i')'
		if `"`s(offopt)'"' == "" & `i' == 1 {
			_get_offopt `e(offset)'
		}
		local opts `eq`i'nocons' `s(offopt)'
		if "`missing'" == "" {
			markout `touse' `eq`i'xvars'
		}
		if `i' == 1 {
			if "`missing'" == "" {
				markout `touse' `depvars'
			}
			local model "(`eq': `depvars' = `eq`i'xvars', `opts')"
		}
		else {
			local model "`model' (`eq': `eq`i'xvars', `opts')"
		}
		local xvars `xvars' `eq`i'xvars'
	}
	if "`e(wtype)'" != "" {
		local wt [`e(wtype)'`e(wexp)']
	}
	Chk_Eval eval

nobreak {

	ml_hold

capture noisily quietly break {

	ml model `method' `eval' `model' `wt' if `touse',	///
		init(`b') nopreserve collinear `missing'
	if "`method'" == "lf" {
		tempname ml_tn ml_hn
		matrix `ml_tn' = e(ml_tn)
		matrix `ml_hn' = e(ml_hn)
		forval i = 1/$ML_n {
			global ML_tn`i' : tempvar
			scalar ${ML_tn`i'} = `ml_tn'[1,`i']
			global ML_hn`i' : tempvar
			scalar ${ML_hn`i'} = `ml_hn'[1,`i']
		}
		global ML_mlsc on
	}
	else {
		// d1 and d2 produce analytical scores
		global ML_sclst `scores'
		if "$ML_evalf" != "" {
			$ML_evalf 1
		}
		else {
			$ML_eval 1
		}
	}

	forval i = 1/`neq' {
		local scorei : word `i' of `scores'
		global ML_sc`i' `scorei'
	}
	$ML_score `scvars'
	if `neq' == 1 {
		label var `scvars' "equation-level score from `pre'`cmd'"
	}
	else {
		forval i = 1/`neq' {
			local scorei : word `i' of `scvars'
			local eq : word `i' of `eqnames'
			if "`eq`i'xvars'" == "" & `i' != 1 {
				local eqi "/`eq'"
			}
			else	local eqi "[`eq']"
			label var `scorei' ///
			"equation-level score for `eqi' from `pre'`cmd'"
		}
	}
	if "`spec'" != "_all_" {
		rename `:word `spec' of `scvars'' `scvari'
		local scvars `scvari'
	}

} // capture noisily quietly break

	local rc = c(rc)

	ml_unhold
	ml_clear

} // nobreak

	if (`rc') exit `rc'

	tempvar nomis
	mark `nomis'
	markout `nomis' `scvars'
	quietly count if !`nomis'
	if r(N) > 0 {
		di as txt "(`r(N)' missing values generated)"
	}

	return local scorevars `scvars'

end

program Chk_Method
	args c_method COLON cmd force
	if "`e(opt)'" != "ml" {
		di as err ///
"`cmd' not supported by ml score; see help {help ml score##|_new:ml score}"
		exit 301
	}
	local method `e(ml_method)'
	if "`method'" == "" {
		di as err ///
"ml score requires that the ml method is in e(ml_method)"
		exit 301
	}
	local supported lf d1 d2
	if !`:list method in supported' {
		di as err ///
"scores cannot be produced with method `method'"
		exit 301
	}
	local props : properties `cmd'
	local ml_score ml_score
	if `"`force'"' == "" & `"`method'"' != "lf"	///
	   & !`: list ml_score in props' {
		if inlist(`"`method'"',"d1","d2") {
			di as err ///
"{p 0 0 2}`cmd' does not have the 'ml_score' property;"	///
" see help {help ml score##|_new:ml score}{p_end}"
			exit 301
		}
		di as err ///
"`cmd' not supported by ml score; see help {help ml score##|_new:ml score}"
		exit 301
	}
	c_local method `method'
end

program Chk_Eval
	args c_eval
	if "`e(ml_score)'" != "" {
		local eval `e(ml_score)'
	}
	else	local eval `e(user)'
	if "`eval'" == "" {
		di as err ///
"{p 0 0 2}ml score requires that the name of the likelihood evaluator "	///
"is in e(ml_score) or e(user){p_end}"
		exit 301
	}
	c_local `c_eval' `eval'
end
exit
