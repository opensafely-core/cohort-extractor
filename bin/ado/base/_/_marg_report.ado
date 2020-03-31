*! version 1.6.5  06may2019
program _marg_report, rclass
	version 11
	local vv : di "version " string(max(11,_caller())) ", missing:"
	if !inlist("`e(cmd)'", "contrast", "margins", "pwcompare", "pwmean") {
		if ("`e(contwc_np)'"=="") {
			error 301
		}
	}
	
	local cmdloco "`e(est_cmdline)'"
	local cmdloco: word 2 of `cmdloco'
	local isloco = 0 
	if ("`cmdloco'"=="series") {
		local isloco = 1
	}
	local is_contrast = "`e(cmd)'" == "contrast"
	local is_pwcompare = "`e(cmd)'" == "pwcompare"
	local is_pwmean = "`e(cmd)'" == "pwmean"
	local is_margins = "`e(cmd2)'" == "margins"
	if (`is_contrast') {
		local contrastoptsnp `"`e(contrastoptsnp)'"'
	}
	if `is_contrast' {
		local OPTS	noWALD			///
				NOEFFects EFFects	///
				CIeffects		///
				PVeffects		///
				noSVYadjust		///
				noATLEVELS				
	}
	else if `is_pwcompare' {
		local OPTS	EFFects			///
				CIeffects		///
				PVeffects		///
				GROUPs			///
				CIMargins		///
				SORT
	}
	else if `is_pwmean' {
		local OPTS	EFFects			///
				CIeffects		///
				PVeffects		///
				GROUPs			///
				CIMeans			///
				SORT
	}

	syntax [,	Level(passthru)		///
			vsquish			///
			NOATLegend		///
			NOPREDICTLegend		///
			MCOMPare(passthru)	///
			`OPTS'			///
			*			///
	]

	if "`noeffects'" != "" {
		opts_exclusive "`noeffects' `effects'"
		opts_exclusive "`noeffects' `cieffects'"
		opts_exclusive "`noeffects' `pveffects'"
	}

	_get_mcompare, `mcompare'
	local method	`"`s(method)'"'
	local all	`"`s(adjustall)'"'
	opts_exclusive "`all' `groups'"
	local ci : length local cieffects
	local pv : length local pveffects
	local full : length local effects

	_check_eformopt `e(est_cmd)', eformopts(`options') soptions
	local options `"`s(options)'"'
	local eform `"`s(eform)'"'
	_get_diopts diopts, `options' `vsquish' `level'
	local level `"`s(level)'"'

	if `is_contrast' | `is_pwcompare' {
		// ignore the -nopvalues- option, -contrast- and
		// -pwcompare- are already going to use it
		local nopvalues nopvalues
		local diopts : list diopts - nopvalues
	}
	local dydx  "`e(derivatives)'"

	if `is_contrast' {
		local wald = "`wald'" != "nowald"
		if !`ci'`pv'`full' & "`noeffects'" == "" {
			if `"`method'"' != "noadjust"	|	///
			   `"`e(has_full_coding)'"' == "1" |	///
			   `wald' == 0 {
				local ci 1
			}
		}
		local coding coding
		local ct1 coeftitle(Contrast)
		local ct2 coeftitle2(`dydx')
		tempname group tinfo
		matrix `group' = e(group)
		matrix `tinfo' = e(test_info)
		local kg = colsof(`group')
		local pos 0
		forval i = 1/`kg' {
			if `group'[1,`i'] < 0 {
				local pos = `tinfo'[2,`i'] - 1
				continue, break
			}
		}
		if `pos' {
			tempname b V err
			matrix `b' = e(b)
			matrix `b' = `b'[1,1..`pos']
			matrix `V' = e(V)
			matrix `V' = `V'[1..`pos',1..`pos']
			matrix `err' = e(error)
			matrix `err' = `err'[1,1..`pos']
			local matopts bmat(`b') vmat(`V') emat(`err')
			if e(small) == 1 {
				tempname df3
				matrix `df3' = e(df3)
				matrix `df3' = `df3'[1,1..`pos']
				local matopts `matopts' dfmat(`df3')
			}
		}
		else if e(small) == 1 {
			local matopts dfmat(e(df3))
		}
		if `is_margins' == 0 {
			local septitle septitle
		}
	}
	else if `is_pwcompare' | `is_pwmean' {
		local wald 0
		local mlist `groups' `cimargins' `cimeans'
		if !`ci'`pv'`full' {
			if "`mlist'" == "" {
				local ci 1
			}
		}
		opts_exclusive "`all' `groups'"
		local gr	: length local groups
		if `is_pwcompare' {
			local cm : length local cimargins
		}
		else {
			local cm : length local cimeans
		}
		if "`e(V_vs)'" == "matrix" {
			local Vvsopt vmat(e(V_vs))
		}
		if e(small) == 1 {
			tempname Lddf Mddf
			matrix `Lddf' = e(L_df)
			matrix `Mddf' = e(M_df)
		}

		local matopts	bmat(e(b_vs))		///
				`Vvsopt'		///
				dfmat(`Lddf')		///
				emat(e(error_vs))	///
				mmat(e(b))		///
				mvmat(e(V))		///
				suffix(_vs)
		local mcnote mcompare(\`return(mcmethod_vs)')
		local compare compare
		local ct1 coeftitle(Contrast)
		local ct2 coeftitle2(`dydx')
	}
	else {
		local wald 0
		local full 1
		if "`dydx'" != "" {
			local ct1 coeftitle(`dydx')
		}
		else {
			local ct1 coeftitle(Margin)
		}
	}
	
	if (("`e(est_cmd)'" != "npregress") | (`isloco'==1) | ///
		("`e(est_cmd)'" == "npregress" & `is_contrast'==0)) {
		if c(noisily) {
			tempname u
			_coef_table_header, obj(`u') `septitle'
			if "`e(vce)'" == "delta" {
				vceHeader `u'
			}
			.`u'.display
		}
		local label `"`e(predict_label)'"'
		if `:length local label' {
			local label `"`label', `e(expression)'"'
		}
		else {
			local label `"`e(expression)'"'
		}
		local di di
		if !inlist(`"`label'"', "", "predict()") | e(k_predict) == 1 {
			if "`e(PredLegend)'" == "" {
				`di'
			}
			local di
			if "`e(PredLegend)'" == "" {
				Legend Expression `"`label'"'
			}
			local label
		}
		if "`e(alternative)'" != "" {
			`di'
			local di
			Legend Alternative `"`e(alternative)'"'
		}
		if "`e(outcome)'" != "" {
			`di'
			local di
			Legend Outcome `"`e(outcome)'"'
		}
		local hasat = "`e(at)'" == "matrix"
		if `:length local dydx' {
			local xvars "`e(xvars)'"
			foreach x of local xvars {
				_ms_parse_parts `x'
				if !r(omit) {
					local XVARS `XVARS' `x'
				}
			}
			`di'
			local di
			Legend "`dydx' w.r.t." "`XVARS'"
		}
		if "`e(over)'" != "" {
			`di'
			local di
			Legend over "`e(over)'"
		}
		if "`e(within)'" != "" {
			`di'
			local di
			Legend within "`e(within)'"
		}
		if "`e(margin_method)'" != "" {
			`di'
			local di
			Legend "Margins" "`e(margin_method)'"
		}
		if !inlist("`e(emptycells)'", "", "strict") {
			`di'
			local di
			Legend "Empty cells" "`e(emptycells)'"
		}
		if `:length local label' {
			if "`nopredictlegend'" == "" {
				`di'
				local di
				if "`e(PredLegend)'" == "" {
					PredLegend
				}
				else {
					`e(PredLegend)'
				}
			}
		}
		if `hasat' & "`noatlegend'" == "" {
			`di'
			local di
			AtLegend, `vsquish'
		}
	}
	if e(small) == 1 {
		local dfmiss dfmissing	
	}

	local radd 1
	if `is_contrast' {
		if `wald' {
			if "`method'" != "noadjust" {
				`vv'					///
				quietly _coef_table,	cmdextras	///
							`matopts'	///
							`mcompare'	///
							`dfmiss'	
				tempname pvmat
				matrix `pvmat' = r(table)
				local row = rownumb(`pvmat', "pvalue")
				if `row' {
					matrix `pvmat' = `pvmat'[`row',1...]
					local pvopt		///
						pvmat(`pvmat')	///
						mctitle(`r(mctitle)')
				}
				return add
				return local level
				local radd 0
			}
			if ("`e(est_cmd)'" == "npregress") { 
				capture mat list r(L)
				local rc = _rc 
				if (`rc') {
					local isr = 0
					local kterms = e(k_terms)
				}
				else {
					local isr = 1
					local kterms = r(k_terms)
				}
				if (`isr') {
					capture mat list r(V)
					local rc = _rc
					if (`rc'==0) {
						mata: _np_contrast(	///
							`kterms', ., `isr') 
					}
				}
				else {
					capture mat list e(V)
					local rc = _rc
					if (`rc'==0) {
						mata: _np_contrast(	///
							`kterms', ., `isr') 
					}			
				}
				capture mat list r(chi2)
				local rc = _rc
				if (`rc'==0) {
					local npregress npregress(1)
				}
				tempname npchi2 npdf npp
				matrix `npchi2' = r(chi2)
				matrix `npdf'   = r(df)
				matrix `npp'    = r(p)
			}
			if ("`e(contwc_np)'"=="" &  ///
				"`e(vcetype)'"=="Bootstrap" & ///
				"`e(est_cmd)'" == "npregress" & ///
				(`isloco'==0)) {
				di as txt `"Contrasts of predictive margins"' _c
				di as txt  as txt ///
				_col(49) "Number of obs" _col(67) "= " ///
				as res %10.0fc e(N)
				di as txt  as txt _col(49) ///
				"Replications" _col(67) "= " as ///
				res %10.0fc e(N_reps)
			}
			if ("`e(est_cmd)'" == "npregress" &	///
				"`e(vcetype)'"=="" & ///
				(`isloco'==0)){
				di
				di as txt `"Contrasts of predictive margins"'
			}
			if ("`e(est_cmd)'" == "npregress" & (`isloco'==0)) {
				local label `"`e(predict_label)'"'
				if `:length local label' {
					local label `"`label', `e(expression)'"'
				}
				else {
					local label `"`e(expression)'"'
				}
				local di di
				if !inlist(`"`label'"', "", "predict()") ///
					| e(k_predict) == 1 {
					if "`e(PredLegend)'" == "" {
						`di'
					}
					local di
					if "`e(PredLegend)'" == "" {
						Legend Expression `"`label'"'
					}
					local label
				}
				local hasat = "`e(at)'" == "matrix"
				if `:length local dydx' {
					local xvars "`e(xvars)'"
					foreach x of local xvars {
						_ms_parse_parts `x'
						if !r(omit) {
							local XVARS `XVARS' `x'
						}
					}
					`di'
					local di
					Legend "`dydx' w.r.t." "`XVARS'"
				}
				if "`e(over)'" != "" {
					`di'
					local di
					Legend over "`e(over)'"
				}
				if "`e(within)'" != "" {
					`di'
					local di
					Legend within "`e(within)'"
				}
				if "`e(margin_method)'" != "" {
					`di'
					local di
					Legend "Margins" "`e(margin_method)'"
				}
				if !inlist("`e(emptycells)'", "", "strict") {
					`di'
					local di
					Legend "Empty cells" "`e(emptycells)'"
				}
				if `:length local label' {
					if "`nopredictlegend'" == "" {
						`di'
						local di
						if "`e(PredLegend)'" == "" {
							PredLegend
						}
						else {
							`e(PredLegend)'
						}
					}
				}
				if `hasat' & "`noatlegend'" == "" {
					`di'
					local di
					AtLegend, `vsquish'
				}			
			}
			di
			WaldTable, `pvopt' `svyadjust' `atlevels'	///
				`diopts' `npregress' 		  	///
				npchi2(`npchi2') npdf(`npdf') 		///
				npp(`npp')
			local puttabs `"`puttabs' `r(put_tables)'"'
			return add
			if ("`e(est_cmd)'" == "npregress") {
				mata: st_matrix("e(chi2)", ///
					st_matrix("`npchi2'"))
				mata: st_matrix("e(df)", st_matrix("`npdf'"))
				mata: st_matrix("e(p)", st_matrix("`npp'"))
				capture noi return matrix chi2 = `npchi2'
				capture noi return matrix df   = `npdf'
				capture noi return matrix p    = `npp'
			}
		}
		else if ("`e(est_cmd)'" == "npregress") {
			if ("`e(contwc_np)'"=="" &  ///
				"`e(vcetype)'"=="Bootstrap") {
				di as txt `"Contrasts of predictive margins"'
				di as txt  as txt ///
				_col(49) "Number of obs" _col(67) "= " ///
				as res %10.0fc e(N)
				di as txt  as txt _col(49) ///
				"Replications" _col(67) "= " as ///
				res %10.0fc e(N_reps)
			}
			if ("`e(vcetype)'"==""){
				di
				di as txt `"Contrasts of predictive margins"'
			}
			local label `"`e(predict_label)'"'
			if `:length local label' {
				local label `"`label', `e(expression)'"'
			}
			else {
				local label `"`e(expression)'"'
			}
			local di di
			if !inlist(`"`label'"', "", "predict()") ///
				| e(k_predict) == 1 {
				if "`e(PredLegend)'" == "" {
					`di'
				}
				local di
				if "`e(PredLegend)'" == "" {
					Legend Expression `"`label'"'
				}
				local label
			}
			local hasat = "`e(at)'" == "matrix"
			if `:length local dydx' {
				local xvars "`e(xvars)'"
				foreach x of local xvars {
					_ms_parse_parts `x'
					if !r(omit) {
						local XVARS `XVARS' `x'
					}
				}
				`di'
				local di
				Legend "`dydx' w.r.t." "`XVARS'"
			}
			if "`e(over)'" != "" {
				`di'
				local di
				Legend over "`e(over)'"
			}
			if "`e(within)'" != "" {
				`di'
				local di
				Legend within "`e(within)'"
			}
			if "`e(margin_method)'" != "" {
				`di'
				local di
				Legend "Margins" "`e(margin_method)'"
			}
			if !inlist("`e(emptycells)'", "", "strict") {
				`di'
				local di
				Legend "Empty cells" "`e(emptycells)'"
			}
			if `:length local label' {
				if "`nopredictlegend'" == "" {
					`di'
					local di
					if "`e(PredLegend)'" == "" {
						PredLegend
					}
					else {
						`e(PredLegend)'
					}
				}
			}
			if `hasat' & "`noatlegend'" == "" {
				`di'
				local di
				AtLegend, `vsquish'
			}					
		}
	}
	else if `is_pwcompare' | `is_pwmean' {
		local GROUPSOK = "`method'" != "dunnett" & "`all'" == ""
		if `is_pwcompare' {
			local coefttl coeftitle(Margin)
		}
		else {
			local coefttl coeftitle(Mean)
		}
		if `gr' {
			di
			`vv'						///
			_coef_table,	`sort'				///
					bmat(e(b_vs))			///
					`Vvsopt'			///
					emat(e(error_vs))		///
					mmat(e(b))			///
					memat(e(error))			///
					mvmat(e(V))			///
					cmdextras			///
					groups				///
					`mcompare'			///
					showeqns			///
					`coefttl'			///
					dfmat(`Lddf')			///
					`dfmiss'			///
					`diopts'
			local puttabs `"`puttabs' `r(put_tables)'"'
			return add
			return local level
			Footnotes,	dydx(`dydx')			///
					mcompare(`return(mcmethod)')
			return local mcmethod
		}
		else if `GROUPSOK' {
			quietly						///
			`vv'						///
			_coef_table,	bmat(e(b_vs))			///
					`Vvsopt'			///
					emat(e(error_vs))		///
					mmat(e(b))			///
					memat(e(error))			///
					mvmat(e(V))			///
					cmdextras			///
					groups				///
					dfmat(`Lddf')			///
					`dfmiss'			///
					`mcompare'
			return add
			return local level
			return local mcmethod
		}
		if `cm' {
			di
			`vv'						///
			_coef_table,	`sort'				///
					cmdextras			///
					nopvalues			///
					showeqns			///
					`coefttl'			///
					dfmat(`Mddf')			///
					`dfmiss'			///
					`diopts'
			local puttabs `"`puttabs' `r(put_tables)'"'
			return add
			return local level
			Footnotes, dydx(`dydx')
		}
		else {
			quietly `vv' _coef_table, 	cmdextras 	///
						 	dfmat(`Mddf')	///
							`dfmiss'
			return add
			return local level
		}
	}
	if `pv' {
		if e(small) == 1 {
			local dftable dfpvalues
		}
		else {
			local dftable noci
		}

		di
		`vv'					///
		_coef_table,	`coding'		///
				`compare'		///
				cmdextras		///
				showeqns		///
				`ct1'			///
				`ct2'			///
				`mcompare'		///
				`matopts'		///
				`sort'			///
				`eform'			///
				`dftable'		///
				`dfmiss'		///
				`diopts'
		local puttabs `"`puttabs' `r(put_tables)'"'
		return add
		return local level
		local radd 0
		Footnotes, dydx(`dydx') pveffects `mcnote'
		local nomclegend nomclegend
	}

	// special information from -margins4npregress-
	
	local cidefault `"`e(cidefault)'"'
	local cinot = 1
	if ("`e(contwc_np)'"!="" &  "`e(vcetype)'"=="None") {
		local full    = 0 
		local radd    = 0
		local cinot   = 0 
	}	
	if (`ci')  {
		if e(small) == 1 {
			local dftable dfci
		}
		else local dftable nopvalues
		di
		`vv'					///
		_coef_table,	`coding'		///
				`compare'		///
				cmdextras		///
				showeqns		///
				`ct1'			///
				`ct2'			///
				`mcompare'		///
				`matopts'		///
				`cidefault'		///
				`sort'			///
				`eform'			///
				`nomclegend'		///
				`dftable'		///
				`dfmiss'		///
				`diopts'
		if `radd' {
			local puttabs `"`puttabs' `r(put_tables)'"'
			return add
			return local level
			local radd 0
		}
		Footnotes, dydx(`dydx') cieffects `mcnote'
		local nomclegend nomclegend 
	}
	if `full' {
		di
		`vv'					///
		_coef_table,	`coding'		///
				`compare'		///
				cmdextras		///
				showeqns		///
				`ct1'			///
				`ct2'			///
				`mcompare'		///
				`matopts'		///
				`cidefault'		///
				`sort'			///
				`eform'			///
				`nomclegend'		///
				`dfmiss'		///
				`diopts'
		if `radd' {
			local puttabs `"`puttabs' `r(put_tables)'"'
			return add
			return local level
			local radd 0
		}
		Footnotes, dydx(`dydx') cieffects pveffects `mcnote'
		local nomclegend nomclegend
	}
	if `radd' {
		quietly `vv' _coef_table, cmdextras ///
				`matopts' `mcompare' `dfmiss'
		return add
		return local level
	}
	return scalar level = `level'
	local nofvlabel nofvlabel
	local nofvlabel : list diopts & nofvlabel
	return local nofvlabel `nofvlabel'
	return hidden local isloco = `isloco'
	return hidden local put_tables `: list retok puttabs'
	if `"`e(footnote)'"' != "" {
		`e(footnote)'
	}
end

program vceHeader
	args u
	local model_vce `"`e(model_vcetype)'"'
	if !`:length local model_vce' {
		local model_vce `"`e(model_vce)'"'
		local proper conventional twostep unadjusted
		if `:list model_vce in proper' {
			local model_vce = strproper(`"`e(model_vce)'"')
		}
		else	local model_vce = strupper(`"`e(model_vce)'"')
	}
	local h1 "Model VCE"
	if `:length local model_vce' {
		.`u'.c2 = 14
		.`u'.PushLeft `"`h1'"' ": " as res `"`model_vce'"'
	}
end

program Legend
	args name value
	local len = strlen("`name'")
	local c2 = 14
	local c3 = 16
	di "{txt}{p2colset 1 `c2' `c3' 2}{...}"
	if `len' {
		if `len' > 12 {
			local name = abbrev(`"`name'"', 12)
		}
		di `"{p2col:`name'}:{space 1}{res:`value'}{p_end}"'
	}
	else {
		di `"{p2col: }{space 2}{res:`value'}{p_end}"'
	}
	di "{p2colreset}{...}"
end

program PredLegend
	local k_pred = e(k_predict)
	if `k_pred' == 1 {
		Legend Expression `"predict(`e(predict_opts)')"'
		exit
	}
	forval i = 1/`k_pred' {
		local label `"`e(predict`i'_label)'"'
		if `:length local label' {
			local label `"`label', predict(`e(predict`i'_opts)')"'
		}
		else {
			local label `"predict(`e(predict`i'_opts)')"'
		}
		Legend "`i'._predict" `"`label'"'
		local title
	}
end

program AtLegend
	syntax [, vsquish]
	tempname at
	matrix `at'	= e(at)
	local atrowna	: rowna `at'
	local k_by	= e(k_by)
	local hasby	= `k_by' > 1
	local r		= rowsof(`at')
	local c		= colsof(`at')
	if `"`e(altvals)'"' == "matrix" {
		tempname altvals
		matrix `altvals' = e(altvals)
		local k_alt = colsof(`altvals')
		local altvar `"`e(altvar)'"'
	}
	else	local k_alt 0
	if `r' == `k_by' {
		local vsquish vsquish
	}
	if "`vsquish'" == "" {
		local di di
	}
	if `hasby' {
		local within `"`e(within)'"'
		local r	= `r'/`k_by'
		local ind "{space 4}"
	}
	local NLIST : colna `at'
	local row 0
	local oldname
	local flushbal 0
	if `r' == 1 {
		local title at
		local first 1
		local stats `"`e(atstats1)'"'
		local stats : list uniq stats
		local asstats asbalanced asobserved
		local stats : list stats - asstats
		if `:list sizeof stats' == 0 {
			local flushbal 1
		}
	}
	forval i = 1/`r' {
		if `r' > 1 {
			local first 1
		}
		local SLIST `"`e(atstats`i')'"'
		local allasobs : list uniq SLIST
		local allasobs = "`allasobs'" == "asobserved"
		`di'
	forval g = 1/`k_by' {
		gettoken rowna atrowna : atrowna
		if `k_alt' > 1 {
			gettoken altspec : rowna , parse("# ")
			_ms_parse_parts `altspec'
			if `"`r(name)'"' == `"`altvar'"' {
				local altlev = r(level)
				gettoken altspec rowna : rowna , parse("# ")
				_msparse `altspec', noomit
				local altspec `"`r(stripe)'"'
				gettoken SHARP rowna : rowna , parse("# ")

		if `"`rowna'"' == "" {
			local title : copy local altspec
			local first 1
		}
		else {
			_ms_parse_parts `rowna'
			if `"`r(name)'`r(name1)'"' == "_at" {
				di as txt `"`altspec'#"'
				gettoken atspec rowna : rowna , parse("# ")
				gettoken SHARP rowna : rowna , parse("# ")
				_msparse `atspec', noomit
				local atspec `"`r(stripe)'"'
				local title : copy local atspec
				local first 1
			}
			else {
				local title : copy local altspec
				local first 1
			}
		}

			}
			else if `"`r(name)'"' == "_at" {
				gettoken atspec rowna : rowna , parse("# ")
				gettoken SHARP rowna : rowna , parse("# ")
				_msparse `atspec', noomit
				local atspec `"`r(stripe)'"'
				local title : copy local atspec
				local first 1
			}
		}
		else if `r' > 1 {
			gettoken atspec rowna : rowna , parse("# ")
			gettoken SHARP rowna : rowna , parse("# ")
			_msparse `atspec', noomit
			local atspec `"`r(stripe)'"'
			if `first' {
				local title : copy local atspec
			}
		}
		if `k_by' > 1 {
			_msparse `rowna', noomit
			local group `"`r(stripe)'"'
			if `first' {
				Legend "`title'" "`group'"
			}
			else {
				Legend "" "`group'"
			}
			local first 0
		}
		local ++row
		local nlist : copy local NLIST
		local slist : copy local SLIST
		forval j = 1/`c' {
			gettoken name nlist : nlist
			gettoken spec slist : slist, bind
			local factor 0
			local asbal = "`spec'" == "asbalanced"
			if `asbal' {
				local factor 1
			}
			else if !`allasobs' {
				if missing(`at'[`row',`j']) {
					if `at'[`row',`j'] != .g {
						continue
					}
				}
			}
			_ms_parse_parts `name'
			if r(type) == "factor" {
				if `at'[`row',`j'] == 0 {
					continue
				}
				else if `at'[`row',`j'] == 1 {
					local factor 1
				}
				local name `r(level)'`r(ts_op)'.`r(name)'
			}
			if `factor' {
				_ms_parse_parts `name'
				local op `"`r(ts_op)'"'
				local val = r(level)
				if `:length local op' {
					local name `"`op'.`r(name)'"'
				}
				else	local name `"`r(name)'"'
				if `asbal' {
					if `:list name in within' {
						local olname
						continue
					}
					if `"`name'"' == "`olname'" {
						continue
					}
				}
			}
			else {
				local name = abbrev("`name'", 12)
			}
			local olname : copy local name
			local ss = 16 - strlen("`name'")
			if `ss' > 0 {
				local space "{space `ss'}"
			}
			else	local space
			if !`factor' {
				local val : display %9.0g `at'[`row',`j']
				local val : list retok val
			}
			if `asbal' {
				if `flushbal' {
					local val
				}
				else {
					local val "{space 12}"
				}
			}
			else {
				local len : length local val
				local ss = 11 - `len'
				if `ss' > 0 {
					local val "{space `ss'}`val'"
				}
			}
			if `factor' & !`asbal' {
				local spec
			}
			if bsubstr("`spec'",1,1) == "(" {
				gettoken val : spec, match(PAR)
			}
			else if !inlist(`"`spec'"',	"",	///
						"asobserved",	///
						"value",	///
						"values",	///
						"zero") {
				if !`hasby' {
				    if bsubstr("`spec'",1,1) == "o" {
					local spec = bsubstr("`spec'",2,.)
				    }
				}
				local val `"`val' {txt:(`spec')}"'
			}
			if `allasobs' {
				local pair `"`ind'{txt:(asobserved)}"'
			}
			else if `asbal' {
				local pair ///
					"`ind'{txt:`name'}`space'  `val'"
			}
			else {
				local pair ///
					"`ind'{txt:`name'}`space'{txt:=} `val'"
			}
			if `first' {
				Legend "`title'" `"`pair'"'
				local first 0
			}
			else {
				Legend "" `"`pair'"'
			}
			if `allasobs' {
				continue, break
			}
		} // j
	} // g
	} // i
end

program WaldTable, rclass
	syntax [,			///
		vsquish			///
		noSVYadjust		///
		noATLEVELS		///
		pvmat(name)		///
		mctitle(string)		///
		Level(cilevel)		/// IGNORED
		npregress(integer 0)	///
		npchi2(string) 		///
		npdf(string) 		///
		npp(string)		///
		*			///
	]

	tempname X df p info Tab

	local noatlevels : length local atlevels

	local has_mcpv = "`pvmat'" != "" & "`mctitle'" != ""

	_get_diopts diopt0, `options'
	local junk : subinstr local diopt0 "nolstretch" "",	///
		all word count(local nolstretch)
	local junk : subinstr local diopt0 "lstretch" "",	///
		all word count(local lstretch)
	local is_svy = "`e(prefix)'" == "svy"
	local svy_adjust = `is_svy' & "`svyadjust'" == ""
	if missing(e(df_r)) {
		local svy_adjust 0
	}
	if e(small) == 1 {
		 local small 1
	}
	else local small 0
	local hasdf2	= "`e(df2)'" == "matrix"
	if `hasdf2' {
		local stat F
		tempname df2 group
		matrix `X'	= e(F)
		matrix `df'	= e(df)
		matrix `df2'	= e(df2)
		matrix `p'	= e(p)
		if `svy_adjust' {
			mata: _svy_adjust("`X'", "`df'", "`df2'", "`p'")
			return matrix p = `p'
			return matrix F = `X'
			matrix `p' = return(p)
			matrix `X' = return(F)
		}
		matrix `group'	= e(group)
	}
	else {
		local stat chi2
		if (`npregress') {
			matrix `X'	= `npchi2'
			matrix `df'	= `npdf'
			matrix `p'	= `npp'	
		}
		else {
			matrix `X'	= e(chi2)
			matrix `df'	= e(df)
			matrix `p'	= e(p)
		}
	}
	matrix `info'	= e(test_info)
	local overall	= strlen("`e(overall)'")
	local k		= colsof(`X')

	local mcwaldmsg = `has_mcpv'
	if `has_mcpv' {
		local has1 0
		forval i = 1/`k' {
			if `df'[1,`i'] == 1 {
				local has1 1
				continue, break
			}
		}
		if `has1' == 0 {
			local has_mcpv 0
		}
	}

	if (`small') {
		if `has_mcpv' {
			local cols 6
			local w6 11
			local t6 %11s
			local p6 2
			local n6 %9.4f
			local s6 .
			local b6 `""""'
		}
		else local cols 5
	}
	else {
		if (`has_mcpv') {
			local cols 5
			local w5 11
			local t5 %11s
			local p5 2
			local n5 %9.4f
			local s5 .
			local b5 `""""'
		}
		else local cols 4
	}
	if `nolstretch' {
		local w1	13
	}
	else {
		if `small' {
			local w1 = c(linesize) - 2 - 11 - 11 - 12 - 11
			if `has_mcpv' {
				local w1 = `w1' - `w6'
			}
		}
		else {
			local w1 = c(linesize) - 2 - 11 - 12 - 11
			if `has_mcpv' {
				local w1 = `w1' - `w5'
			}
		}
		CFindMinWidth `w1' `info' joint `noatlevels' `"`diopt0'"'
		local w1 = r(width) + 1
	}

if `small' {
	tempname tempdf
	mat `tempdf' = e(df2)
	local hasmiss `=matmissing(`tempdf')'
		
	.`Tab'	= ._tab.new, col(`cols') lmargin(0) puttab(`Tab')
	// column	1	2	3	4	5 	6
	.`Tab'.width	`w1'	|11	11	12	11	`w6'
	local --w1
	.`Tab'.titlefmt	.	%11s	%11s	%12s	%11s	`t6'
	.`Tab'.pad	.	2	2	3	2	`p6'
	.`Tab'.numfmt	.	%9.0g	%9.2f	%9.2f	%9.4f	`n6'
	.`Tab'.strcolor	.       result  .	.       .	`s6'

	.`Tab'.sep, top
	if `has_mcpv' {
		.`Tab'.titles	"" "" "" "" "" "`mctitle'"
		if (`hasmiss') {
			.`Tab'.titles	"" "df" ///
				"{help j_mixed_ddf:	   ddf}" ///
				"`stat'" "P>`stat'" "P>`stat'"
		}
		else {
		.`Tab'.titles	"" "df" "ddf" "`stat'" "P>`stat'" "P>`stat'"
		}
	}
	else {
		if (`hasmiss') {
			.`Tab'.titles	"" "df" ///
				"{help j_mixed_ddf:	   ddf}" ///
				"`stat'" "P>`stat'"
		}
		else {
		.`Tab'.titles	"" "df" "ddf" "`stat'" "P>`stat'"
		}
	}
}
else {
	.`Tab'	= ._tab.new, col(`cols') lmargin(0) puttab(`Tab')
	// column	1	2	3	4	5
	.`Tab'.width	`w1'	|11	12	11	`w5'
	local --w1
	.`Tab'.titlefmt	.	%11s	%12s	%11s	`t5'
	.`Tab'.pad	.	2	3	2	`p5'
	.`Tab'.numfmt	.	%9.0g	%9.2f	%9.4f	`n5'
	.`Tab'.strcolor	.       result  .       .	`s5'

	.`Tab'.sep, top
	if `has_mcpv' {
		.`Tab'.titles	"" "" "" "" "`mctitle'"
		.`Tab'.titles	"" "df" "`stat'" "P>`stat'" "P>`stat'"
	}
	else {
		.`Tab'.titles	"" "df" "`stat'" "P>`stat'"
	}
}
	.`Tab'.sep
	_ms_eq_info
	local k_eq = r(k_eq)
	forval i = 1/`k_eq' {
		local eq`i' `"`r(eq`i')'"'
	}
	local oldeq = 0
	forval i = 1/`k' {
		if `hasdf2' {
			local ig = `group'[1,`i']
			if `ig' < 0 {
				continue
			}
		}
		local el 0
		if `i' == `k' & `overall' {
			if `small' {
				.`Tab'.row "" "" "" "" "" `b6'
			}
			else {
				.`Tab'.row "" "" "" "" `b5'
			}
			local ttl "Overall"
		}
		else {
			local ttl
			local diopt `diopt0' joint
			if `noatlevels' & `info'[3,`i'] == 2 {
				continue
			}
			if `info'[3,`i'] == 1 {
				local diopt `diopt0' joint nolevel
			}
			else if `info'[3,`i'] == 3 {
				local ttl "Joint "
			}
			else if `info'[3,`i'] == 4 {
				if `noatlevels' {
					local diopt `diopt0' joint nolevel
				}
				else {
					local ttl "Joint "
				}
			}
			local eq = `info'[1,`i']
			if `eq' != `oldeq' {
				if `"`eq`eq''"' != "_" {
					if `eq' > 1 {
						.`Tab'.sep
					}
					_ms_eq_display, eq(`eq') width(`w1')
					.`Tab'.after_ms_eq_display eq
					di
				}
				local oldeq = `eq'
			}
			local el = `info'[2,`i']
			if `"`ttl'"' == "" {
				_ms_display,	width(`w1')		///
						eq(#`eq')		///
						el(`el')		///
						novbar			///
						`vsquish'		///
						`VSQUISH'		///
						`diopt'
				.`Tab'.after_ms_display
			}
			else {
				local el 0
			}
			local VSQUISH
		}
		if missing(`X'[1,`i']) {
		    if `small' {
			if (missing(`df2'[1,`i']) & `df'[1,`i'] != 0) {
				.`Tab'.row	"`ttl'"		///
						`df'[1,`i']	///
						`df2'[1,`i']	///
						`X'[1,`i']	///
						`p'[1,`i']	///
						`b6'
			}
			else {
				.`Tab'.row "`ttl'" "  (not testable)" ///
			 			"" "" "" `b6'
			}
		    }
		    else {
			.`Tab'.row "`ttl'" "  (not testable)" "" "" `b5'
		    }
		}
		else if `df'[1,`i'] == 0 {
		    if `small' {
			.`Tab'.row "`ttl'" "  (omitted)" "" "" "" `b6'
		    }
		    else {
			.`Tab'.row "`ttl'" "  (omitted)" "" "" `b5'
		    }
		}
		else {
			if `has_mcpv' {
				if `el' & `df'[1,`i'] == 1 {
					local mcpv `pvmat'[1,`el']
				}
				else {
					local mcpv `""""'
				}
			}
			if `small' {
			.`Tab'.row	"`ttl'"		///
					`df'[1,`i']	///
					`df2'[1,`i']	///
					`X'[1,`i']	///
					`p'[1,`i']	///
					`mcpv'

			}
			else {
			.`Tab'.row	"`ttl'"		///
					`df'[1,`i']	///
					`X'[1,`i']	///
					`p'[1,`i']	///
					`mcpv'
			}
		}
		if `hasdf2' & `i' < `k' & !`small' {
			if `ig' != `group'[1,`i'+1] {
				local eq = `info'[1,`i'+1]
				local el = `info'[2,`i'+1]
				_ms_display,	width(`w1')		///
						eq(#`eq')		///
						el(`el')		///
						nolevel			///
						`vsquish'		///
						novbar			///
						joint
				.`Tab'.row	""			///
						`df2'[1,`i']		///
						"  (denominator)"	///
						""			///
						`b5'
				.`Tab'.sep
				if !`:length local vsquish' {
					local VSQUISH vsquish
				}
			}
		}
	}
	if `hasdf2' & !`small' {
		local skip 1
		if `is_svy' {
			if `svy_adjust' {
				local skip 0
			}
			local ttl "Design"
		}
		else {
			local ttl "Denominator"
		}
		if `skip' {
			.`Tab'.row "" "" "" "" `b5'
		}
		.`Tab'.row "`ttl'" `e(df_r)' "" "" `b5'
	}
	.`Tab'.sep, bottom
	.`Tab'.width_of_table
	.`Tab'.post_results "" _wald
	return add 
	if `mcwaldmsg' {
		di as txt "{p 0 6 0 `s(width)'}Note: " ///
		"`mctitle'-adjusted p-values are reported for tests on" ///
		" individual contrasts only.{p_end}"
	}
	if `svy_adjust' {
		di as txt "{p 0 6 0 `s(width)'}Note: " ///
		"F statistics are adjusted for the survey design.{p_end}"
	}
end

program CFindMinWidth, rclass
	args w info joint noatlevels diopt
	if `:length local joint' {
		if "`e(group)'" == "matrix" {
			tempname group
			matrix `group' = e(group)
			local ig = `group'[1,1]
		}
	}
	local has_group : length local group
	local k = colsof(`info')
	local max 0
	forval i = 1/`k' {
		local levels 1
		local eq = `info'[1,`i']
		local el = `info'[2,`i']
		if `el' == 0 {
			continue
		}
		if `:length local joint' {
			if inlist(`info'[3,`i'], 2) & `noatlevels'{
				continue
			}
			if inlist(`info'[3,`i'], 1, 3) {
				local levels 0
			}
			if inlist(`info'[3,`i'], 4) & `noatlevels' {
				local levels 0
			}
			if `has_group' {
				local ig = `group'[1,`i']
				if `ig' < 0 {
					local levels 0
				}
			}
		}
		_ms_element_info,	///
			width(`w')	///
			eq(#`eq')	///
			el(`el')	///
			coding		///
			`joint'		///
			`diopt'
		local loop = r(k_term)
		if `loop' {
			forval j = 1/`loop' {
				local len = strlen(`"`r(term`j')'"')
				if `max' < `len' {
					local max = `len'
				}
			}
		}
		else {
			local len = strlen(`"`r(term)'"')
			if `max' < `len' {
				local max = `len'
			}
		}
		if !`levels' {
			continue
		}
		local loop = r(k_level)
		if `loop' {
			forval j = 1/`loop' {
				local len = strlen(`"`r(level`j')'"') + 1
				if `max' < `len' {
					local max = `len'
				}
			}
		}
		else {
			local len = strlen(`"`r(level)'"') + 1
			if `max' < `len' {
				local max = `len'
			}
		}
	}
	if `max' < 12 {
		local max 12
	}
	if `max' > `w' {
		local max `w'
	}
	return scalar width = `max'
end

program Footnotes
	syntax [,	dydx(string)		///
			cieffects		///
			pveffects		///
			mcompare(passthru)	///
	]

	if "`s(width)'" != "" {
		local p "{p 0 6 0 `s(width)'}"
	}
	else {
		local p "{p 0 6 0}"
	}

	if `:length local dydx' & "`e(continuous)'" == "" {
		di as txt "`p'Note: " ///
"`dydx' for factor levels is the discrete change from the base level." ///
"{p_end}"
	}

	local ci : length local cieffects
	local pv : length local pveffects
	if "`e(cmd)':`e(group)'" == "contrast:matrix" {
		tempname g
		matrix `g' = e(group)
		matrix `g' = `g'*`g''
		if `g'[1,1] {
			if `ci' & `pv' {
				local msg ", pvalues, and confidence intervals"
			}
			else if `ci' {
				local msg " and confidence intervals"
			}
			else {
				local msg " and pvalues"
			}
			di as txt ///
"`p'Note: Standard errors`msg'"						///
" for individual contrasts are derived from the linear combination"	///
" of covariates."							///
" The '/' operator affects only the table of Wald statistics."		///
"{p_end}"
		}
	}

	if "`e(cmd)'" == "pwcompare" {
		_get_mcompare, `mcompare'
		local method `"`s(method)'"'
		local needbalanced duncan dunnett snk
		if "`e(balanced)'" == "0" & `:list method in needbalanced' {
			if e(k_terms) == 1 {
				local factors "A factor was"
			}
			else {
				local factors "One or more factors were"
			}
			di as txt "`p'Note: " ///
"The `method' method requires balanced data for proper level coverage. " ///
"`factors' found to be unbalanced."
			di as txt "{p_end}"
		}
	}

	if e(small)==1 {

		tempname Ldf
		if "`e(cmd)'" == "contrast" {
			mat `Ldf' = e(df3)	
			local msg contrast
		}
		else if "`e(cmd)'" == "pwcompare" {
			mat `Ldf' = e(L_df)
			local msg pairwise comparison 
		}

		if `pv' & `ci' & `=rowsof(`Ldf') >1' {
			di as txt "`p'Note: " ///
				"Degrees of freedom are specific " ///
				"to each `msg'. " 
			di as txt "{p_end}"
		}
		if (matmissing(`Ldf')) {
			di as txt "`p'Note: " ///
				"Small-sample inference is " ///
				"{help j_mixed_ddf:not available} " ///
				"for some `msg's."
			di as txt "{p_end}"
		}
		
	}
	
	// npregress specific 

	if ("`e(npcmd)'" != "npregress") {
		exit
	}
	if ("`e(npcmd)'" == "npregress" & "`e(cmdname)'"=="") {
		di as txt "{p 0 6 2}" ///
		"Note: You may compute standard errors using" ///
		"{bf: vce(bootstrap)} or {bf:reps()}.{p_end}"	
	}
	local exactzero = e(exactzero)
	if ("`e(npcmd)'" == "npregress" & `exactzero'>0) {
		if (`exactzero'>1) {
		di as txt "{p 0 6 2}" ///
		     "Note: `e(exactzero)' coefficients are exactly zero. " ///
		    "There are very few observations in the " ///
		     "region where these margins are computed. " ///
		   "{p_end}"
		}
		else {
		di as txt "{p 0 6 2}" ///
		     "Note: `e(exactzero)' coefficient is exactly zero. " ///
		    "There are very few observations in the " ///
		     "region where this margin is computed. " ///
		   "{p_end}"		
		}	
	}

	local emptycount  = r(empty_count)
	local emptycounte = e(empty_count)
	if ((`emptycount'>0 & `emptycount'!=.)|	///
		(`emptycounte'>0 & `emptycounte'!=.) ) {
		local ar "regions"
		if (`emptycount'==1|`emptycounte'==1) {
			local ar "region"
		}
		local k = `emptycount'
		if (`k'==.) {
			local k = `emptycounte'
		}
		di as txt "{p 0 6 2}" ///
		"Note: You requested predictions in `k' `ar'"	///
		" for which there are no data in the original"	///
		" estimation sample. Predictions in these "	///
		"regions are not estimable.{p_end}"		
	}
end

exit
