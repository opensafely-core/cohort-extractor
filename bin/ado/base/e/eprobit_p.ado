*! version 1.0.4  13sep2019
program define eprobit_p
	version 15
	syntax [anything] [if] [in] [,		///
		EQuation(string)		///
		OUTLevel(string)		///
		Mean				///
		Pr				///
		xb				///
		SCores				///
		POMean				///
		TLevel(string)			///
		te				///
		tet				///
		noOFFset			///
		fix(varlist numeric min=1 ts)	///
		e(string)			///	
		YStar(string)			///	
		Pre(string)			///  	
		STRuctural			///	/* undocumented */
		total				///	/* undocumented */
		cond(string)			///	/* undocumented */
		INTPoints(string)		///	/* undocumented */
		TARGet(passthru)		///
		base(passthru)			///	
		]
	if "`equation'" != "" {
		local v
		capture fvunab v: `equation'
		if _rc {
			local v
		}
		else {
			local ev `e(depvar)'
			local v: list v & ev
		}
		if "`v'" == "" {
			di as err "{bf:equation()} incorrectly " ///
				"specified;"
			di as err "{p 0 4 2}`equation' is not "
			di as err "a dependent variable " /// 
			"in the model{p_end}"	
			exit 498
		}
		local equation `v'
	}
	else {
		local equation `e(odepvar)'
	}
	local outlevelspec 0
	if "`outlevel'" != "" {
		local outlevelspec 1
	}
	if "`base'" != "" {
		if "`equation'" != "`e(odepvar)'" {
			di as err "{p 0 4 2}{bf:base()} requires that " 
			di as err "{bf:equation()} corresponds to first "
			di as err "dependent variable {p_end}"
			exit 498
		}		
		if "`te'" != "" {
			opts_exclusive "te base()"
		}
		if "`tet'" != "" {
			opts_exclusive "tet base()"
		}
		if "`pomean'" != "" {
			opts_exclusive "pomean base()"
		}
	}
	if "`target'" != "" {
		if "`equation'" != "`e(odepvar)'" {
			di as err "{p 0 4 2}{bf:target()} requires that " 
			di as err "{bf:equation()} corresponds to first "
			di as err "dependent variable {p_end}"
			exit 498
		}		
		if "`te'" != "" {
			opts_exclusive "te target()"
		}
		if "`tet'" != "" {
			opts_exclusive "tet target()"
		}
		if "`pomean'" != "" {
			opts_exclusive "pomean target()"
		}
	}
	if "`fix'" != "" {
		if "`te'" != "" {
			opts_exclusive "te fix()"
		}
		if "`tet'" != "" {
			opts_exclusive "tet fix()"
		}
		if "`pomean'" != "" {
			opts_exclusive "pomean fix()"
		}
		capture tsunab fix: `fix'
		if _rc {
			di as error "{bf:fix()} invalid;"
			tsunab fix: `fix'
		}
		local posslist `e(depvar_dvlist)'
		foreach var of local fix {
			local allin: list var in posslist
			if !`allin' {
				di as error "{p 0 4 2}{bf:fix()} invalid; "
				di as error "`var' is not an "
				di as error "endogenous covariate in "
				di as error "the model{p_end}"
				exit 498
			}
		}
		if "`equation'" != "`e(odepvar)'" {
			di as err "{p 0 4 2}{bf:fix()} requires that " 
			di as err "{bf:equation()} corresponds to first "
			di as err "dependent variable {p_end}"
			exit 498
		}
		local dvlist `e(adepvar_dvlist)'
		local dvlistmacs `e(fdepvar_dvlistmacs)'
		foreach word of local fix {
			StrikeFix, fixword(`word') ///
				dvlist(`dvlist') dvlistmacs(`dvlistmacs')
			local dvlist `r(dvlist)'
			local dvlistmacs `r(dvlistmacs)'
		}
		local k = wordcount("`dvlist'")
		forvalues i = 1/`k' {
			local dv: word `i' of `dvlist'
			local dvmac: word `i' of `dvlistmacs'
			local vd `e(`dvmac')'
			local listin: list fix & vd
			if `"`listin'"' != "" {
				di as error "{p 0 4 2}endogenous "
				di as error "{bf:`dv'} depends "
				di as error "on fixed {bf:`listin'}{p_end}"
				exit 498
			}
		}
	}
	if "`structural'" != "" & "`total'" != "" {
		opts_exclusive "structural total"
	}
	if "`structural'" != "" {
		if "`equation'" != "`e(odepvar)'" {
			di as err "{p 0 4 2} {bf:structural} requires that " 
			di as err "{bf:equation()} corresponds to first "
			di as err "dependent variable {p_end}"
			exit 498
		}
		if "`e'" != "" {
			opts_exclusive "structural e()"
		}
		if "`pre'" != "" {
			opts_exclusive "structural pr()"
		}
		if "`ystar'" != "" {
			opts_exclusive "structural ystar()"
		}
		if "`scores'" != "" {
			opts_exclusive "structural scores"
		}
		if "`tet'" != "" {
			opts_exclusive "structural tet"
		}
		if "`cond'" != "" {
			opts_exclusive "structural cond()"
		}	 		
	}
	else {
		local total total
		if "`e'`pre'`ystar'`tet'`scores'`cond'" ///
			== "" & ("`total'" == "" & 		///
			"`equation'" == "`e(odepvar)'") {
			local structural structural
		}
		if "`equation'" != "`e(odepvar)'" & "`xb'" == "" {
			local total total
		}
		if "`tet'" != "" & "`total'" == "" {
			di as error "{bf:tet} requires {bf:total}"
			exit 498
		}
	}
	if "`structural'" != "" {
		local asf asf
	}

	local linearendog `e(endogdepvars)' `e(tseldepvar)'
	local inlinear: list linearendog & equation
	local allstat `xb'`pr'`pomean'`te'`tet'`mean'
	local allstat `allstat'`e'`scores'`ystar'`pre'
	if "`inlinear'" != "" & "`allstat'" == "" {
		local mean mean
		di as text "(option {bf:mean} assumed; mean of `equation')"
	}	
	else if "`allstat'" == "" {
		local pr pr
		if !`outlevelspec' {
			di as text ///
			 "(option {bf:pr} assumed; predicted probabilities)"
		}
	}
	if "`pr'`mean'" == "" & "`fix'" != "" {
		di as error "{p 0 4 2}option {bf:fix()} only allowed with" 
		di as error "{bf:pr} and {bf:mean}{p_end}"
		exit 198
	}
	if "`pr'`mean" == "" & "`base'" != "" {
		di as error "{p 0 4 2}option {bf:base()} only allowed with"
		di as error "{br:pr} and {bf:mean}{p_end}"
		exit 198
	}
	if "`pr'`mean" == "" & "`target'" != "" {
		di as error "{p 0 4 2}option {bf:target()} only allowed with"
		di as error "{br:pr} and {bf:mean}{p_end}"
		exit 198
	}
	local opttest
	if "`outlevel'" != "" {
		local opttest `opttest' outlevel()
	}
	if "`e'" != "" {
		local opttest `opttest' e()
	}
	if "`pre'" != "" {
		local opttest `opttest' pr()
	}
	if "`ystar'" != "" {
		local opttest `opttest' ystar()
	}
	if "`tlevel'" != "" {
		local opttest `opttest' tlevel()
	}
	if "`cond'" != "" {
		local opttest `opttest' cond()
	}
	if "`scores'" != "" {
		local opttest scores `opttest' `mean' `pr' ///
			`xb' `pomean' `te' `tet'
		local w: word count `opttest'
		if `w' > 1 {
			opts_exclusive "`opttest'"
		}		
		_eprobit_get_scores `0'
		exit 0
	}
	if "`xb'" != "" {
		local opttest xb `opttest' `mean' `pr' ///
			`pomean' `te' `tet' 
		local w: word count `opttest'
		if `w' > 1 {
			opts_exclusive "`opttest'"
		}
		if "`equation'" != "" {
			capture confirm variable `equation'
			if ~_rc {
				fvexpand `equation'
				local equation `r(varlist)'
			}
			local equation equation(`equation')
		}
		_predict `anything' `if' `in', xb `equation' `offset'
		exit
	}
	local opttest
	if "`outlevel'" != "" {
		local opttest `opttest' outlevel()
	}
	if "`tlevel'" != "" {
		local opttest `opttest' tlevel()
	}
	if "`e'" != "" {
		local opttest `opttest' e()
	}
	if "`pre'" != "" {
		local opttest `opttest' pr()
	}
	if "`ystar'" != "" {
		local opttest `opttest' ystar()
	}
	if "`mean'" != "" {
		local opttest mean `opttest' `pr' ///
			`pomean' `te' `tet' 
		local w: word count `opttest'
		if `w' > 1 {
			opts_exclusive "`opttest'"
		}
	}
	local opttest
	if "`outlevel'" != "" {
		local opttest `opttest' outlevel()
	}
	if "`tlevel'" != "" {
		local opttest `opttest' tlevel()
	}
	if "`ystar'" != "" {
		local opttest `opttest' ystar()
	}
	if "`e'" != "" {
		local opttest `opttest' e()
	}
	if "`pre'" != "" {
		local opttest pr() `opttest' `pr' ///
		`pomean' `te' `tet' 
		local w: word count `opttest'
		if `w' > 1 {
			opts_exclusive "`opttest'"
		}	
	}
	local opttest
	if "`outlevel'" != "" {
		local opttest `opttest' outlevel()
	}
	if "`tlevel'" != "" {
		local opttest `opttest' tlevel()
	}
	if "`ystar'" != "" {
		local opttest `opttest' ystar()
	}

	if "`e'" != "" {
		local opttest e() `opttest' `pr' ///
			`pomean' `te' `tet'  
		local w: word count `opttest'
		if `w' > 1 {
			opts_exclusive "`opttest'"
		}
	}
	local opttest
	if "`outlevel'" != "" {
		local opttest `opttest' outlevel()
	}
	if "`tlevel'" != "" {
		local opttest `opttest' tlevel()
	}
	if "`ystar'" != "" {
		local opttest ystar() `opttest' `pr' ///
			`pomean' `te' `tet' 
		local w: word count `opttest'
		if `w' > 1 {
			opts_exclusive "`opttest'"
		}
	}
	if "`pr'" != "" {
		if "`tlevel'" != "" {
			opts_exclusive "pr tlevel()"
		}
		local opttest pr `pomean' `te' `tet'
		local w: word count `opttest'
		if `w' > 1 {
			opts_exclusive "`opttest'"
		}
	}
	if "`pomean'" != "" {
		local opttest pomean `te' `tet'
		local w: word count `opttest'
		if `w' > 1 {
			opts_exclusive "`opttest'"
		}
	}
	if "`te'" != "" & "`tet'" != "" {
		opts_exclusive "te tet"
	}
	//opts exclusive done
	if "`intpoints'" != "" {
		if "`asf'" == "" {
			di as error "{p 0 4 2}{bf:intpoints()} only "
			di as error "allowed with structural prediction{p_end}"
			exit 498
		}
		capture confirm integer number `intpoints'
		local rc = _rc
		capture assert `intpoints' > 1 & `intpoints' < 129
		local rc = `rc' | _rc
		if (`rc') {
			di as error "{bf:intpoints()} must be " ///
				"an integer greater than 1"  ///
				" and less than 129"
			exit 198 
		}	
		local asfintpoints `intpoints'
	}
	if "`e(extrdepvar)'`e(trdepvar)'" == "" & "`pomean'"!="" {
		di as err "{bf:pomean} not appropriate;"
		di as err "model has no treatment"
		exit 498
	}
	if "`e(extrdepvar)'`e(trdepvar)'" == "" & "`te'`teasf'" != "" {
		di as err "{bf:te} not appropriate;"
		di as err "model has no treatment"
		exit 498
	}
	if "`e(extrdepvar)'`e(trdepvar)'" == "" & "`tet'" != "" {
		di as err "{bf:tet} not appropriate;"
		di as err "model has no treatment"
		exit 498
	}
	if "`inlinear'" != "" {
		if "`outlevel'" != "" {
			di as err "{p 0 4 2} {bf:outlevel()} incorrectly " ///
				"specified; "
			di as err "an outcome value "	
			di as err "may only be specified for "	
			di as err "categorical dependent "
			di as err "variables{p_end}"
			exit 498
		}
		if "`pr'" != "" {
			di as err "{p 0 4 2}{bf:pr} inappropriate "
			di as err "for linear outcome{p_end}"
			exit 498
		}
	}		
	if "`outlevel'" != "" {
		if "`mean'" != "" {
			di as err "{p 0 4 2}{bf:outlevel()} incorrectly " ///
				"specified;"
			di as err " an outcome value "	
			di as err "may not be specified with {bf:mean}"	
			di as err "mean{p_end}"
			exit 498
		}
		capture Eq `"`outlevel'"' `equation'			
		if _rc {
			di as err "{bf:outlevel()} "	///
				"incorrectly specified;"
			Eq `"`outlevel'"' `equation'
		}
		local outcome `s(icat)'
	}		
	if "`tlevel'" != "" {
		capture Eq `"`tlevel'"' `e(extrdepvar)'`e(trdepvar)'
		if _rc {
			di as err "{bf:tlevel()} "	///
				"incorrectly specified;"
			Eq `"`tlevel'"' `e(extrdepvar)'`e(trdepvar)'
		}
		else if `s(icat)' == 1 & "`te'`tet'" != "" {
			di as error "{bf:tlevel()} must be valid " ///
				"noncontrol treatment level"
			exit 198
		}
		local tlevel `s(icat)'
	}
	if "`asf'" != "" & "`pr'" != "" {
		local prasf prasf
		local pr
	}
	if "`asf'" != "" & "`mean'" != "" {
		local meanasf meanasf
		local mean
	}
	if "`asf'" != "" & "`pomean'" != "" {
		local pomeanasf pomeanasf
		local pomean
	}
	if "`asf'" != "" & "`te'" != "" {
		local teasf teasf			
		local te
	}


	tempname catnvals
	matrix `catnvals' = e(nvals)
	local pralln = 0
	local prasfalln = 0 
	local pomeanallt = 0
	local tetetalltm1 = 0
	if "`pr'" != "" {
		local no = `catnvals'[1,colnumb(`catnvals',"`equation'")]
		capture _stubstar2names `anything', nvars(`no')
		if !_rc {
			local varlist `s(varlist)'
			local typlist `s(typlist)'
			if `"`outcome'"' != "" {
				di as error "too many variables"
				exit 103
			}
			local pralln = 1
		}
		else {
			capture _stubstar2names `anything', nvars(1)
			if !_rc {
				local varlist `s(varlist)'
				local typlist `s(typlist)'
				if "`outcome'" == "" {
					tempname isbinary
					matrix `isbinary' = e(binary)
					if `isbinary'[1,colnumb(	///
						`isbinary',"`equation'")] {
						local outcome #2
					}
					else {
						local outcome #1
					}
					Eq `"`outcome'"' `equation'
					local outcome `s(icat)'		
				}
			}
			else {
				_stubstar2names `anything', nvars(1)
			}
		}
	}
	else if "`mean'`e'`pre'`ystar'" != "" {
		_stubstar2names `anything', nvars(1)
		local varlist `s(varlist)'
		local typlist `s(typlist)'		
	}
	else if "`meanasf'" != "" {
		_stubstar2names `anything', nvars(1)
		local varlist `s(varlist)'
		local typlist `s(typlist)'	
	}
	else if "`prasf'" != "" {
		local no = `catnvals'[1,colnumb(`catnvals',"`equation'")]
		capture _stubstar2names `anything', nvars(`no')
		if !_rc {
			local varlist `s(varlist)'
			local typlist `s(typlist)'
			if `"`outcome'"' != "" {
				di as error "too many variables"
				exit 103
			}
			local prasfalln = 1
		}
		else {
			capture _stubstar2names `anything', nvars(1)
			if !_rc {
				local varlist `s(varlist)'
				local typlist `s(typlist)'
				if "`outcome'" == "" {
					tempname isbinary
					matrix `isbinary' = e(binary)
					if `isbinary'[1,colnumb(	///
						`isbinary',"`equation'")] {
						local outcome #2
					}
					else {
						local outcome #1
					}
					Eq `"`outcome'"' `equation'
					local outcome `s(icat)'		
				}
			}
			else {
				_stubstar2names `anything', nvars(1)
			}
		}			
	}
	else if "`pomean'`pomeanasf'" != "" {
		if "`equation'" != "`e(odepvar)'" {
			di as err "{p 0 4 2} {bf:pomean} requires that " 
			di as err "{bf:equation()} corresponds to first "
			di as err "dependent variable {p_end}"
			exit 498
		}	
		if "`e(trdepvar)'" != "" {	
			local nt = ///
			`catnvals'[1,colnumb(`catnvals',"`e(trdepvar)'")]
		}
		else {
			local nt: word count `e(extrvalues)' 
		}
		capture _stubstar2names `anything', nvars(`nt')
		if !_rc {
			local varlist `s(varlist)'
			local typlist `s(typlist)'
			local pomeanallt = 1
		}
		else {
			_stubstar2names `anything', nvars(1)
			local varlist `s(varlist)'
			local typlist `s(typlist)'
		}
		if "`tlevel'" != "" & `pomeanallt' {
			di as error "too many variables specified"
			exit 103				
		}
		if "`tlevel'" == "" & ~`pomeanallt' {
			local tlevel #1
			Eq `"`tlevel'"' `e(extrdepvar)'`e(trdepvar)'	
			local tlevel `s(icat)'
		}
	}
	else if "`te'`teasf'`tet'" != "" {
		if "`te'`teasf'" != "" {
			local tearg te
		}
		if "`tet'" != "" {
			local tearg tet
			local pomeancond pomeancond
		}
		if "`equation'" != "`e(odepvar)'" {
			di as err "{p 0 4 2} {bf:`tearg'} requires that " 
			di as err "{bf:equation()} corresponds to first "
			di as err "dependent variable {p_end}"
			exit 498
		}
		if "`e(trdepvar)'" != "" {		
			local ntm1 = `catnvals'[1,colnumb(	///
				`catnvals',"`e(trdepvar)'")]-1
		}
		else {
			local ntm1: word count `e(extrvalues)' 
			local ntm1 = `ntm1'-1
		}
		capture _stubstar2names `anything', nvars(`ntm1')
		if !_rc {
			local varlist `s(varlist)'
			local typlist `s(typlist)'
			if `ntm1' > 1 {
				local tetetalltm1 = 1
			}
		}
		else {
			_stubstar2names `anything', nvars(1)
			local varlist `s(varlist)'
			local typlist `s(typlist)'
		}
		if "`tlevel'" != "" & `tetetalltm1' {
			di as error "too many variables specified"
			exit 103
		}
		if "`tlevel'" == "" & ~`tetetalltm1' {
			local tlevel #2
			Eq `"`tlevel'"' `e(extrdepvar)'`e(trdepvar)'	
			local tlevel `s(icat)'
		}		
	}
	if "`te'`teasf'`tet'`pomean'`pomeanasf'" != ""  & "`outcome'" == "" {
		if "`outcome'" == "" {
			tempname isbinary
			matrix `isbinary' = e(binary)
			if `isbinary'[1,colnumb(	///
				`isbinary',"`equation'")] {
				local outcome #2
			}
			else {
				local outcome #1
			}
			Eq `"`outcome'"' `equation'
			local outcome `s(icat)'		
		}
	}
	local intpoints = e(intpoints)
	local intpoints3 = e(intpoints3)
	local depvars `e(depvar)'
	local seldepvar `e(seldepvar)'
	local odepvar `e(odepvar)'
	local indepvars: list depvars & cond
	if "`indepvars'" == "" {
		foreach name of local cond {
			local indepvars: list depvars & name 
			if "`indepvars'" == "" {
				di as err "{bf:cond()} incorrectly specified;"
				di as err "{p 0 4 2}`name' is not a dependent"
				di as err " variable in the model{p_end}"	
				exit 498
			}
		}
	}
	if "`cond'" == "" {
		if "`equation'" == "`e(odepvar)'" {
			if "`fix'" != "" {
				local condlist `dvlist'
				foreach word of local dvlistmacs {
					local condlist `condlist' `e(`word')'
				}
				local condlist: list uniq condlist		
			}
			else if "`te'`pomean'" != "" {
				if "`e(treatrecursive)'"!="" & "`te'" != "" {
					di as error "{p 0 4 2}endogenous "
					di as error "regressors depend on "
					di as error "the treatment, try "
					di as error "{bf:tet}{p_end}"
					exit 498
				}
				if "`e(treatrecursive)'"!="" & "`pomean'"!="" {
					di as error "{p 0 4 2}endogenous "
					di as error "regressors depend on "
					di as error "the treatment, try "
					di as error "{bf:pr()}"
					di as error ///
						" and {bf:target()}{p_end}"
					exit 498
				}
				local condlist `e(podepvar_dvlist)'
			}
			else {
				local condlist `e(depvar_dvlist)'
			}
		}
		else {
			if "`equation'" == "`e(seldepvar)'" {
				local condlist `e(sel_dvlist)'
			}
			if "`equation'" == "`e(tseldepvar)'" {
				local condlist `e(tsel_dvlist)'
			}
			if "`equation'" == "`e(trdepvar)'" {
				local condlist `e(tr_dvlist)'
			}
			local nbendog = e(nbendog)
			local noendog = e(noendog)
			local nendog = e(nendog)
			if `nbendog' > 0 {
				forvalues i = 1/`nbendog' {
					if "`equation'" == ///
						"`e(bendog_depvar`i')'"	{
							local condlist ///
							`e(bendog_dvlist`i')'
					}
				}
			}
			if `noendog' > 0 {
				forvalues i = 1/`noendog' {
					if "`equation'" == ///
						"`e(oendog_depvar`i')'"	{
							local condlist ///
							`e(oendog_dvlist`i')'
					}
				}
			}
			if `nendog' > 0 {
				forvalues i = 1/`nendog' {
					if "`equation'" == ///
						"`e(endog_depvar`i')'"	{
							local condlist ///
							`e(endog_dvlist`i')'
					}
				}
			}
		}
		local cond `condlist'
	}
	local pluralcond
	if wordcount("`cond'") > 1 {
		local pluralcond s
	}
	tempvar touse
	marksample touse, novarlist
	if "`teasf'`pomeanasf'" != "" {
		local cond
	}
	if "`pomean'" != "" {
		tempname allcatvals
		matrix `allcatvals' = e(catvals)
		if `pomeanallt' {
			local formiss
			forvalues i = 1/`nt' {
				gettoken varn varlist: varlist
				gettoken vart typlist: typlist
				if "`e(trdepvar)'" != "" {
					local tlevel = `allcatvals'[`i', ///
					colnumb(`allcatvals',"`e(trdepvar)'")]	
				}
				else {
					local tlevel: ///
						word `i' of `e(extrvalues)' 
				}
				local olevel = `allcatvals'[		///
					`outcome',			///
					colnumb(`allcatvals',"`equation'")]
				qui predict `vart' `varn' `if' `in',	 ///	
					pomean tlevel(`tlevel') `offset' /// 
					equation(`equation') 		 ///
					outlevel(`olevel')	 	 ///
					cond(`cond') total
				local formiss `formiss' `varn'
			}
			MissCount `formiss'
			exit		
		}
		else {
			if "`e(trdepvar)'" != "" {
				local tlevel = `allcatvals'[`tlevel',	///
					colnumb(`allcatvals',"`e(trdepvar)'")]
			}
			else {
				local tlevel: word `tlevel' of `e(extrvalues)'		
			}
			_eprobit_mean, varn(`varlist')			/// 
				vart(`typlist')				///
				eq(`equation') cond(`cond')		/// 
				touse(`touse')				///
				outcomeorder(`outcome')			///
				intpoints(`intpoints')			/// 
				intpoints3(`intpoints3')		///
				pomeaneq(`e(extrdepvar)'`e(trdepvar)')	///	
				pomeanval(`tlevel') `defaultpr'
			if "`cond'" != "" {
				notes `varlist': ///
			"Conditioned on endogenous variable`pluralcond': `cond'"
			}
		}
	}
	else if "`pomeanasf'" != "" {
		tempname allcatvals
		matrix `allcatvals' = e(catvals)
		if `pomeanallt' {
			local formiss
			forvalues i = 1/`nt' {
				gettoken varn varlist: varlist
				gettoken vart typlist: typlist
				if "`e(trdepvar)'" != "" {
					local tlevel = `allcatvals'[`i', ///
					colnumb(`allcatvals',"`e(trdepvar)'")]	
				}
				else {
					local tlevel: ///
						word `i' of `e(extrvalues)' 
				}
				local olevel = `allcatvals'[		///
					`outcome',			///
					colnumb(`allcatvals',"`equation'")]
				qui predict `vart' `varn' `if' `in',	 ///	
					pomean tlevel(`tlevel') `offset' /// 
					equation(`equation') 		 ///
					outlevel(`olevel')	 	 ///
					cond(`cond') structural
				local formiss `formiss' `varn'
			}
			MissCount `formiss'
			exit		
		}
		else {
			if "`e(trdepvar)'" != "" {
				local tlevel = `allcatvals'[`tlevel',	///
					colnumb(`allcatvals',"`e(trdepvar)'")]
			}
			else {
				local tlevel: word `tlevel' of `e(extrvalues)'		
			}
			_eprobit_mean, varn(`varlist')			/// 
				vart(`typlist')				///
				eq(`equation') cond(`cond')		/// 
				touse(`touse')				///
				outcomeorder(`outcome')			///
				intpoints(`intpoints')			/// 
				intpoints3(`intpoints3')		///
				pomeaneq(`e(extrdepvar)'`e(trdepvar)')	///	
				pomeanval(`tlevel') `defaultpr'	pomeanasf
		}
	}
	else if "`te'`tet'" != "" {
		tempname allcatvals
		matrix `allcatvals' = e(catvals)
		local olevel = `allcatvals'[			///
				`outcome',			///
				colnumb(`allcatvals',"`equation'")]	
		if "`e(trdepvar)'" != "" {
			local controltlevel = `allcatvals'[1,	///
				colnumb(`allcatvals',"`e(trdepvar)'")]
		}
		else {
			local controltlevel: word 1 of `e(extrvalues)'
		}
		if `tetetalltm1' {
			tempname tb
			qui predict double `tb' `if' `in',	///
				pomean tlevel(`controltlevel')	///
				`offset'			///
				equation(`equation') outlevel(`olevel')	///
				cond(`cond') total
			local formiss	
			forvalues i = 1/`ntm1' {
				local j = `i' + 1
				gettoken varn varlist: varlist
				gettoken vart typlist: typlist
				if "`e(trdepvar)'" != "" {
					local tlevel = `allcatvals'[`j', ///
					colnumb(`allcatvals',"`e(trdepvar)'")]
				}
				else {
					local tlevel: ///
						word `j' of `e(extrvalues)'
				}
				tempname tt
				qui predict double `tt' `if' `in',	///
					pomean tlevel(`tlevel')		///
					`offset'			///
					equation(`equation')		/// 
					outlevel(`olevel')		///
					cond(`cond') total
				qui gen `vart' `varn' = `tt'-`tb' `if' `in'
				_ms_parse_parts `e(odepvar)'
				local lolevel: value label `r(name)'
				cap label list `lolevel'
				if _rc {
					local lolevel 
				}
				if "`lolevel'" != "" {
					local lolevel: label `lolevel' `olevel'
				}
				else {
					local lolevel `olevel'
				}
				_ms_parse_parts	`e(extrdepvar)'`e(trdepvar)'
				local ltlevel: value label `r(name)'
				cap label list `ltlevel'
				if _rc {
					local ltlevel
				}
				if "`ltlevel'" != "" {
					local ltlevel: label `ltlevel' `tlevel'
				}
				else {
					local ltlevel `tlevel'
				}
				_ms_parse_parts `e(extrdepvar)'`e(trdepvar)'
				local lclevel: value label `r(name)'
				cap label list `lclevel'
				if _rc {
					local lclevel
				}
				if "`lclevel'" != "" {
					local lclevel: label `lclevel' ///
						`controltlevel'
				}
				else {
					local lclevel `controltlevel'
				}
				if "`tet'" != "" {
					local lab treatment effect ///
						on the treated ///
						Pr(`equation'==`lolevel'), ///
					`e(extrdepvar)'`e(trdepvar)': ///
					`ltlevel' vs. `lclevel'
				}
				else {
					local lab treatment effect ///
						Pr(`equation'==`lolevel'), ///
					`e(extrdepvar)'`e(trdepvar)': ///
					`ltlevel' vs. `lclevel'
				}
				label variable `varn' `"`lab'"' 
				if "`cond'" != "" {
					notes `varn': ///
			"Conditioned on endogenous variable`pluralcond': `cond'"
				}
				local formiss `formiss' `varn'
			}
			MissCount `formiss'
		}
		else {
			local varn `varlist'
			local vart `typlist'
			tempname tb
			qui predict double `tb' `if' `in',	///
				pomean tlevel(`controltlevel')	///
				`offset'			///
				equation(`equation') outlevel(`olevel')	///
				cond(`cond') total
			if "`e(trdepvar)'" != "" {
				local tlevel = `allcatvals'[`tlevel',	///
					colnumb(`allcatvals',"`e(trdepvar)'")]
			}
			else {
				local tlevel: word `tlevel' of `e(extrvalues)'
			}
			tempname tt
			qui predict double `tt' `if' `in',	///
				pomean tlevel(`tlevel')		///
				`offset'			///
				equation(`equation') outlevel(`olevel')	///
				cond(`cond') total
			gen `vart' `varn' = `tt'-`tb' `if' `in'
			_ms_parse_parts `e(odepvar)'
			local lolevel: value label `r(name)'
			cap label list `lolevel'
			if _rc {
				local lolevel 
			}
			if "`lolevel'" != "" {
				local lolevel: label `lolevel' `olevel'
			}
			else {
				local lolevel `olevel'
			}
			_ms_parse_parts `e(extrdepvar)'`e(trdepvar)'
			local ltlevel: value label `r(name)'
			cap label list `ltlevel' 
			if _rc {
				local ltlevel
			}
			if "`ltlevel'" != "" {
				local ltlevel: label `ltlevel' `tlevel'
			}
			else {
				local ltlevel `tlevel'
			}				
			_ms_parse_parts	`e(extrdepvar)'`e(trdepvar)'
			local lclevel: value label `r(name)'
			cap label list `lclevel'
			if _rc {
				local lclevel 
			}
			if "`lclevel'" != "" {
				local lclevel: label `lclevel' ///
					`controltlevel'
			}
			else {
				local lclevel `controltlevel'
			}
			if "`tet'" != "" {
				local lab treatment effect ///
					on the treated ///
					Pr(`equation'==`lolevel'), ///
					`e(extrdepvar)'`e(trdepvar)': ///
					`ltlevel' vs. `lclevel'
			}
			else {
				local lab treatment effect ///
					Pr(`equation'==`lolevel'), ///
					`e(extrdepvar)'`e(trdepvar)': ///
					`ltlevel' vs. `lclevel'
			}
			label variable `varn' `"`lab'"' 
			if "`cond'" != "" {
				notes `varn': ///
		"Conditioned on endogenous variable`pluralcond': `cond'"
			}
		}
	}
	else if "`teasf'" != "" {
		tempname allcatvals
		matrix `allcatvals' = e(catvals)
		local olevel = `allcatvals'[			///
				`outcome',			///
				colnumb(`allcatvals',"`equation'")]	
		if "`e(trdepvar)'" != "" {
			local controltlevel = `allcatvals'[1,	///
				colnumb(`allcatvals',"`e(trdepvar)'")]
		}
		else {
			local controltlevel: word 1 of `e(extrvalues)'
		}
		if `tetetalltm1' {
			tempname tb
			qui predict double `tb' `if' `in',	///
				pomean tlevel(`controltlevel')	///
				`offset'			///
				equation(`equation') outlevel(`olevel')	///
				cond(`cond') structural
			local formiss	
			forvalues i = 1/`ntm1' {
				local j = `i' + 1
				gettoken varn varlist: varlist
				gettoken vart typlist: typlist
				if "`e(trdepvar)'" != "" {
					local tlevel = `allcatvals'[`j', ///
					colnumb(`allcatvals',"`e(trdepvar)'")]
				}
				else {
					local tlevel: ///
						word `j' of `e(extrvalues)'
				}
				tempname tt
				qui predict double `tt' `if' `in',	///
					pomean tlevel(`tlevel')		///
					`offset'			///
					equation(`equation')		/// 
					outlevel(`olevel')		///
					cond(`cond') structural
				qui gen `vart' `varn' = `tt'-`tb' `if' `in'
				_ms_parse_parts `e(odepvar)'
				local lolevel: value label `r(name)'
				cap label list `lolevel'
				if _rc {
					local lolevel 
				}
				if "`lolevel'" != "" {
					local lolevel: label `lolevel' `olevel'
				}
				else {
					local lolevel `olevel'
				}
				_ms_parse_parts	`e(extrdepvar)'`e(trdepvar)'
				local ltlevel: value label `r(name)'
				cap label list `ltlevel'
				if _rc {
					local ltlevel
				}
				if "`ltlevel'" != "" {
					local ltlevel: label `ltlevel' `tlevel'
				}
				else {
					local ltlevel `tlevel'
				}
				_ms_parse_parts `e(extrdepvar)'`e(trdepvar)'
				local lclevel: value label `r(name)'
				cap label list `lclevel'
				if _rc {
					local lclevel
				}
				if "`lclevel'" != "" {
					local lclevel: label `lclevel' ///
						`controltlevel'
				}
				else {
					local lclevel `controltlevel'
				}
				if wordcount("`e(depvar_dvlist)'") > 1 {
					local lab Structural treatment ///
					effect ///
					Pr(`equation'==`lolevel'), ///
					`e(extrdepvar)'`e(trdepvar)': ///
					`ltlevel' vs. `lclevel'
				}
				else {
					local lab treatment ///
					effect ///
					Pr(`equation'==`lolevel'), ///
					`e(extrdepvar)'`e(trdepvar)': ///
					`ltlevel' vs. `lclevel'
				}
				label variable `varn' `"`lab'"' 
				local formiss `formiss' `varn'
			}
			MissCount `formiss'
		}
		else {
			local varn `varlist'
			local vart `typlist'
			tempname tb
			qui predict double `tb' `if' `in',	///
				pomean tlevel(`controltlevel')	///
				`offset'			///
				equation(`equation') outlevel(`olevel')	///
				cond(`cond') structural
			if "`e(trdepvar)'" != "" {
				local tlevel = `allcatvals'[`tlevel',	///
					colnumb(`allcatvals',"`e(trdepvar)'")]
			}
			else {
				local tlevel: word `tlevel' of `e(extrvalues)'
			}
			tempname tt
			qui predict double `tt' `if' `in',	///
				pomean tlevel(`tlevel')		///
				`offset'			///
				equation(`equation') outlevel(`olevel')	///
				cond(`cond') structural
			gen `vart' `varn' = `tt'-`tb' `if' `in'
			_ms_parse_parts `e(odepvar)'
			local lolevel: value label `r(name)'
			cap label list `lolevel'
			if _rc {
				local lolevel 
			}
			if "`lolevel'" != "" {
				local lolevel: label `lolevel' `olevel'
			}
			else {
				local lolevel `olevel'
			}
			_ms_parse_parts `e(extrdepvar)'`e(trdepvar)'
			local ltlevel: value label `r(name)'
			cap label list `ltlevel' 
			if _rc {
				local ltlevel
			}
			if "`ltlevel'" != "" {
				local ltlevel: label `ltlevel' `tlevel'
			}
			else {
				local ltlevel `tlevel'
			}				
			_ms_parse_parts	`e(extrdepvar)'`e(trdepvar)'
			local lclevel: value label `r(name)'
			cap label list `lclevel'
			if _rc {
				local lclevel 
			}
			if "`lclevel'" != "" {
				local lclevel: label `lclevel' ///
					`controltlevel'
			}
			else {
				local lclevel `controltlevel'
			}
			if wordcount("`e(depvar_dvlist)'") > 1 {
				local lab Structural treatment effect ///
					Pr(`equation'==`lolevel'), ///
					`e(extrdepvar)'`e(trdepvar)': ///
					`ltlevel' vs. `lclevel'
			}
			else {
				local lab treatment effect ///
					Pr(`equation'==`lolevel'), ///
					`e(extrdepvar)'`e(trdepvar)': ///
					`ltlevel' vs. `lclevel'
			}
			label variable `varn' `"`lab'"' 
		}
	}
	else if "`pr'" != "" {
		if `pralln' {
		// one variable specified for every outcome level of equation
			local formiss
			forvalues i = 1/`no' {
				gettoken varn varlist: varlist
				gettoken vart typlist: typlist
				qui _eprobit_mean, varn(`varn')		///
					vart(`vart')			///
					eq(`equation') cond(`cond') 	///
					touse(`touse')			///
					outcomeorder(`i')		///
					intpoints(`intpoints')		/// 
					intpoints3(`intpoints3')	///
					`base'				///
					`target' `offset'
				if "`cond'" != "" {
					notes `varn': ///
		"Conditioned on endogenous variable`pluralcond': `cond'"
				}	
				local formiss `formiss' `varn'
				if "`fix'" != "" {
					ExpFix, fix(`"`fix'"')
					note `varn': "`s(fix)'"
				}
				if "`base'" != "" {
					ExpBase, `base'
					note `varn': "`s(base)'"
				}
				if "`target'" != "" {
					ExpTarget, `target'
					note `varn': "`s(target)'"
				}
			}
			if "`defaultpr'" != "" {
				di as text ///
				"(option {bf:pr} assumed; Pr(`equation'))"
			}	
			MissCount `formiss'
		}
		else {
			_eprobit_mean, varn(`varlist')			/// 
				vart(`typlist')				///
				eq(`equation') cond(`cond')		/// 
				touse(`touse')				///
				outcomeorder(`outcome')			///
				intpoints(`intpoints')			/// 
				intpoints3(`intpoints3')		///
				`base'					///
				`target'				///
				`defaultpr'
			if "`cond'" != "" {
				notes `varlist': ///
		"Conditioned on endogenous variable`pluralcond': `cond'"
			}
			if "`fix'" != "" {
				ExpFix, fix(`"`fix'"')
				note `varlist': "`s(fix)'"
			}
			if "`base'" != "" {
				ExpBase, `base'
				note `varlist': "`s(base)'"
			}
			if "`target'" != "" {
				ExpTarget, `target'
				note `varlist': "`s(target)'"
			}
		}
	}
	else if "`prasf'" != "" {
		if `prasfalln' {
			local formiss
		// one variable specified for every outcome level of equation
			forvalues i = 1/`no' {
				gettoken varn varlist: varlist
				gettoken vart typlist: typlist
				local defarg
				if `i' == `no' {
					local defarg `defaultasf'
				}
				qui _eprobit_asf, varn(`varn')		///
					vart(`vart') cond(`cond')	///
					`offset'			///
					touse(`touse')			///
					eq(`equation')			///
					outcomeorder(`i')		///
					intpoints(`asfintpoints')	///
					`defarg'
				local formiss `formiss' `varn'
			}
			MissCount `formiss'
		}
		else {
			_eprobit_asf, varn(`varlist')			/// 
				vart(`typlist')	cond(`cond')		///
				touse(`touse')				///
				`offset'				///
				eq(`equation')				///
				outcomeorder(`outcome')			///
				intpoints(`asfintpoints')		///
				`defaultasf'			
		}
	}
	else if "`mean'" != "" {
		// Mean
		if "`inlinear'" != "" {
			_eregress_mean_constr, varn(`varlist')		/// 
				vart(`typlist')				///
				eq(`equation') cond(`cond')		/// 
				touse(`touse')				///
				intpoints(`intpoints')			/// 
				intpoints3(`intpoints3')		///
				`defaultmean' `offset'
			if "`cond'" != "" {
				notes `varlist': ///
			"Conditioned on endogenous variable`pluralcond': `cond'"
			}
			if "`fix'" != "" {
				ExpFix, fix(`"`fix'"')
				note `varlist': "`s(fix)'"
			}
			if "`base'" != "" {
				ExpBase, `base'
				note `varlist': "`s(base)'"
			}
			if "`target'" != "" {
				ExpTarget, `target'
				note `varlist': "`s(target)'"
			}
		}
		else {
			// categorical
			tempname allcatvals nvals
			matrix `allcatvals' = e(catvals)
			matrix `nvals' = e(nvals)
			local eqi = colnumb(`allcatvals',"`equation'")
			local nvalsi = `nvals'[1,`eqi']
			tempvar storeval
			qui gen double `storeval' = 0 if `touse'
			forvalues i = 1/`nvalsi' {
				tempvar sv`i'
				local val = `allcatvals'[`i',`eqi']
				qui eprobit_p double `sv`i'' if `touse', ///
					pr equation(`equation') 	 ///
					outlevel(`val')		 	 ///
					`offset' fix(`fix') 		 ///
					`base' `target'
				qui replace `storeval' = `storeval' + 	///
					`val'*`sv`i'' if `touse'
			}
			gen `typlist' `varlist' = `storeval' if `touse'
			label variable `varlist' "mean of `equation'"
			if "`cond'" != "" {
				notes `varlist': ///
		"Conditioned on endogenous variable`pluralcond': `cond'"
			}
			if "`fix'" != "" {
				ExpFix, fix(`"`fix'"')
				note `varlist': "`s(fix)'"
			}
			if "`base'" != "" {
				ExpBase, `base'
				note `varlist': "`s(base)'"
			}
			if "`target'" != "" {
				ExpTarget, `target'
				note `varlist': "`s(target)'"
			}
		}	
	}
	else if "`meanasf'" != "" {
		tempname allcatvals nvals
		matrix `allcatvals' = e(catvals)
		matrix `nvals' = e(nvals)
		local eqi = colnumb(`allcatvals',"`equation'")
		local nvalsi = `nvals'[1,`eqi']
		tempvar storeval
		qui gen double `storeval' = 0 if `touse'
		forvalues i = 1/`nvalsi' {
			tempvar sv`i'
			local val = `allcatvals'[`i',`eqi']
			qui _eprobit_asf, varn(`sv`i'')		///
				vart(double) cond(`cond')	///
				`offset'			///
				touse(`touse')			///
				eq(`equation')			///
				outcomeorder(`i')		///
				intpoints(`asfintpoints')	
			qui replace `storeval' = `storeval' + 	///
				`val'*`sv`i'' if `touse'
		}
		gen `typlist' `varlist' = `storeval' if `touse'
		label variable `varlist' "Structural mean of `equation'"
	}
	else if "`e'" != "" {
		//e()
		if "`inlinear'" != "" {
			// check arguments to meane
			ParseMeanArgs, range(`e') touse(`touse')
			local uppert `s(uppert)'
			local lowert `s(lowert)'
			local upper `s(upper)'
			local lower `s(lower)'
			local margs
			if "`uppert'" != "" {
				local margs `margs' upper(`upper') ///	
					uppert(`uppert')
			}
			if "`lowert'" != "" {
				local margs `margs' lower(`lower') ///
					lowert(`lowert')
			}
			_eregress_mean_constr, varn(`varlist')	/// 
				vart(`typlist')			///
				eq(`equation') cond(`cond')	/// 
				touse(`touse')			///
				intpoints(`intpoints')		/// 
				intpoints3(`intpoints3')	///
				`margs'
			if "`cond'" != "" {
				notes `varlist': ///
		"Conditioned on endogenous variable`pluralcond': `cond'"
			}
			if "`fix'" != "" {
				ExpFix, fix(`"`fix'"')
				note `varlist': "`s(fix)'"
			}
			if "`base'" != "" {
				ExpBase, `base'
				note `varlist': "`s(base)'"
			}
			if "`target'" != "" {
				ExpTarget, `target'
				note `varlist': "`s(target)'"
			}
		}
		else {
			di as error "{p 0 4 2}{bf:e()} not allowed with "
			di as error "categorical {bf:equation()}{p_end}"
			exit 498  
		}
	}
	else if "`ystar'" != "" {
		//ystar()
		if "`inlinear'" != "" {
			ParseMeanArgs, range(`ystar') touse(`touse')
			local uppert `s(uppert)'
			local lowert `s(lowert)'
			local upper `s(upper)'
			local lower `s(lower)'
			local margs
			if "`uppert'" != "" {
				local margs `margs' upper(`upper') ///	
					uppert(`uppert')
			}
			if "`lowert'" != "" {
				local margs `margs' lower(`lower') ///
					lowert(`lowert')
			}
			_eregress_mean_ystar, varn(`varlist')		///
				vart(`typlist')				///
				eq(`equation') cond(`cond')		///
				touse(`touse')				///
				intpoints(`intpoints')			///
				intpoints3(`intpoints3')		///
				`margs'
			if "`cond'" != "" {
				notes `varlist': ///
		"Conditioned on endogenous variable`pluralcond': `cond'"
			}
			if "`fix'" != "" {
				ExpFix, fix(`"`fix'"')
				note `varlist': "`s(fix)'"
			}
			if "`base'" != "" {
				ExpBase, `base'
				note `varlist': "`s(base)'"
			}
			if "`target'" != "" {
				ExpTarget, `target'
				note `varlist': "`s(target)'"
			}
		}
		else {
			di as error "{p 0 4 2}{bf:ystar()} not allowed with "
			di as error "categorical {bf:equation()}{p_end}"
			exit 498  
		}
	}
	else {
		//pr()
		if "`inlinear'" != "" {
			ParseMeanArgs, range(`pre') touse(`touse')
			local uppert `s(uppert)'
			local lowert `s(lowert)'
			local upper `s(upper)'
			local lower `s(lower)'
			local margs
			if "`uppert'" != "" {
				local margs `margs' upper(`upper') ///	
					uppert(`uppert')
			}
			if "`lowert'" != "" {
				local margs `margs' lower(`lower') ///
					lowert(`lowert')
			}
			_eregress_mean_pr, varn(`varlist')		/// 
				vart(`typlist')				///
				eq(`equation') cond(`cond')		/// 
				touse(`touse')				///
				intpoints(`intpoints')			/// 
				intpoints3(`intpoints3')		///
				`margs' `offset'
			if "`cond'" != "" {
				notes `varlist': ///
		"Conditioned on endogenous variable`pluralcond': `cond'"
			}
			if "`fix'" != "" {
				ExpFix, fix(`"`fix'"')
				note `varlist': "`s(fix)'"
			}
			if "`base'" != "" {
				ExpBase, `base'
				note `varlist': "`s(base)'"
			}
			if "`target'" != "" {
				ExpTarget, `target'
				note `varlist': "`s(target)'"
			}
		}
		else {
			di as error "{p 0 4 2} {bf:pr()} not allowed with "
			di as error "categorical {bf:equation()}{p_end}"
			exit 498  
		}
	}	
end

program define Eq, sclass
	sret clear
	args out eqvar
	tempname eqvals
	tempname eqnval
	if "`eqvar'" == "`e(extrdepvar)'" {
		local roweqvar: word count `e(extrvalues)'
		matrix `eqvals' = J(1,`roweqvar',.)
		local vallist `e(extrvalues)'
		forvalues i = 1/`roweqvar' {
			gettoken val vallist: vallist
			matrix `eqvals'[1,`i'] = `val' 
		}
	}
	else {
		matrix `eqvals' = e(catvals)
		matrix `eqnval' = e(nvals)
		local coleqvar = colnumb(`eqvals',"`eqvar'")
		local roweqvar = `eqnval'[1,`coleqvar']
		local neqvarvals = `roweqvar'
		matrix `eqvals' = `eqvals'[1..`roweqvar',`coleqvar']'
	}	
	local i = 1
	_ms_parse_parts `eqvar'
	local f: value label `r(name)'
	cap label list `f'
	if _rc {
		local f 
	}
	local icat
	if "`f'" != "" {
		cap label list `f'
		local k1 = r(min)
		local k2 = r(max)
		local j = 1
		forvalues i = `k1'/`k2' {
			local f2: label `f' `i'
			if ltrim(`"`out'"') == ltrim(`"`f2'"') {
				local icat `j'
				continue, break
			}
			local j = `j' + 1
		}
		if "`icat'" != "" {
			sret local icat `icat'
			exit
		}		
	}
	if substr(ltrim(`"`out'"'),1,1)=="#" {
		local out = substr(ltrim(`"`out'"'),2,.)
		Chk, eqvar(`eqvar') test(confirm integer number `out')
		Chk, eqvar(`eqvar') test(assert `out' >= 1)
		capture assert `out' <= `roweqvar'
		local cat = `roweqvar'
		if _rc {
			di in red "there is no outcome #`out'" _n /*
			*/ "there are only `cat' categories of `eqvar'"
			exit 111
		}
		sret local icat `"`out'"'
		exit
	}
	Chk, eqvar(`eqvar') test(confirm number `out')
	local i = 1
	while `i' <= `roweqvar' {
		if `out' == el(`eqvals',1,`i') {
			sret local icat `i'
			exit
		}
		local i = `i' + 1
	}

	di in red `"outcome `out' not found for `eqvar'"'
	Chk, eqvar(`eqvar') test(assert 0) /* return error */
end

program define Chk
	syntax, eqvar(string) test(string)
	capture `test'
	if _rc {
		di in red "must specify a value of `eqvar'," /*
		*/ _n "or #1, #2, ..."
		exit 111
	}
end

program define Onevar
	gettoken option 0 : 0
	local n : word count `0'
	if `n'==1 {
		exit 
	}
	di in red "option `option' requires that you specify 1 new variable"
	error cond(`n'==0,102,103)
end


program MultVars
	syntax [newvarlist]
	local nvars : word count `varlist'
	if `nvars' == e(k_eq) {
		exit
	}
	if `nvars' != e(k_cat) {
		local ed: word 1 of `e(depvar)'
		capture noisily error cond(`nvars'<e(k_cat1), 102, 103)
		di in red /*
		*/ "`ed' has `e(k_cat1)' outcomes and so you " /*
		*/ "must specify `e(k_cat1)' new variables, or " _n /*
		*/ "you can use the outlevel() option and specify " /*
		*/ "variables one at a time"
		exit cond(`nvars'<e(k_cat1), 102, 103)
	}
end

program ParseCond 
	capture syntax, CONDitional
	if _rc {
		di as err "{bf:pomean()} " ///
			"incorrectly specified"
		exit 198	
	}
end

program ParseMeanArgs, sclass
	syntax, range(string) touse(string)
	gettoken pr1 range: range, parse(", ")
	capture confirm number `pr1'
	local pr1n = !_rc | ltrim(rtrim("`pr1'"))=="."
	capture confirm numeric variable `pr1'
	local pr1v = !_rc 
	if "`range'" == "" {
		di as error "{bf:e()} incorrectly specified;"
		di as error "two arguments must be given"
		exit 198
	}
	else if !`pr1n' & !`pr1v' {
		di as error ///
		"{p 0 1 2} first argument to {bf:e()}" ///
		" must be a real number " ///
		" or a numeric variable{p_end}"
		exit 198	
	}
	gettoken comma pr2: range, parse(", ")
	capture confirm number `pr2'
	local pr2n = !_rc | rtrim(ltrim("`pr2'")) == "."
	capture confirm numeric variable `pr2'
	local pr2v = !_rc
	if !`pr2n' & !`pr2v' {
		di as error ///
		"{p 0 1 2} second argument to {bf:e()}" ///
		" must be a real number " ///
		" or a numeric variable{p_end}"
		exit 198	
	}
	// Check ranges..
	capture assert `pr1' <= `pr2' if ~missing(`pr1')
	if _rc {
		di as error "{bf:e()} incorrectly specified;"
		di as error "{p 0 1 2} upper bound `pr2' must be greater "
		di as error "than or equal to lower bound `pr1' when "
		di as error "both are defined{p_end}"
		exit 498
	}	
	local uppert
	if `pr2v' | ~missing(`pr2') {
		local uppert `pr2'
	} 
	local lowert
	if `pr1v' | ~missing(`pr1') {
		local lowert `pr1'
	}
	sreturn local uppert `uppert'
	sreturn local lowert `lowert'
	sreturn local upper `pr2'
	sreturn local lower `pr1' 	
end

program MissCount
	tempname misscount
	mata:MissCount("`misscount'","`0'")
	if `misscount' > 0 {
		local dimisscount = `misscount'
		di as text "(`dimisscount' missing values generated)"
	}
end

program CheckFixed
syntax varlist
end

program StrikeFix, rclass
	syntax, fixword(string) dvlist(string) dvlistmacs(string)
	local k = wordcount("`dvlist'")
	local actdvlist
	local actdvlistmacs
	forvalues i = 1/`k' {
		gettoken actd dvlist: dvlist
		gettoken actdm dvlistmacs: dvlistmacs
		if "`actd'" != "`fixword'" {
			local actdvlist `actdvlist' `actd'
			local actdvlistmacs `actdvlistmacs' `actdm'
		}		
	}
	return local dvlist `actdvlist'
	return local dvlistmacs `actdvlistmacs'
end

program ExpFix, sclass
	syntax, fix(string)
	local nwords = wordcount(`"`fix'"')
	if `nwords' > 1 {
		local fix = `"Variables treated as exogenous: `fix'"'
	}
	else {
		local fix = `"Variable treated as exogenous: `fix'"'
	}
	sreturn local fix `fix'
end

program ExpBase, sclass
	syntax, base(string)
	sreturn local base `"Base value specification: `base'"'
end

program ExpTarget, sclass
	syntax, target(string)
	sreturn local target `"Target value specification: `target'"'
end




mata:
void MissCount(string scalar misscount, string scalar varlist) {
	
        real matrix varlistview

        pragma unset varlistview

	st_view(varlistview,.,varlist)
	st_numscalar(misscount,missing(varlistview))
}
end
