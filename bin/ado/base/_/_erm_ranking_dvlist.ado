*! version 1.0.3  08may2019
program _erm_ranking_dvlist, rclass
	syntax [, touse(string) depvar(string) sel_depvar(string)	///
		tr_depvar(string) 				 	///
		nendog(string) noendog(string) nbendog(string) 		///
		sel_indepvars(string) tr_indepvars(string) 		///
		bendog_depvars(string) oendog_depvars(string)		///
		endog_depvars(string) indepvars(string) *]


	gettoken odepvar oindepvars: depvar
	local dvlistcheck `sel_depvar'	`tr_depvar' `bendog_depvars' ///
			`oendog_depvars' `endog_depvars'
	local dvlistcheck: list dups dvlistcheck
	if "`dvlistcheck'" != "" {
		local w: word 1 of `dvlistcheck'
		noi di as error ///
		"{p 0 4 2}{bf:`w'} has more than one equation specified{p_end}"
		exit 498
	} 	
	local s
	if `nbendog' > 0 {
		forvalues i = 1/`nbendog' {
			local s `s' bendog_depvar`i'(string)		///
					bendog_indepvars`i'(string)	
		}
	}
	if `noendog' > 0 {
		forvalues i = 1/`noendog' {
			local s `s' oendog_depvar`i'(string)		///
					oendog_indepvars`i'(string)	
		}
	}
	if `nendog' > 0 {
		forvalues i = 1/`nendog' {
			local s `s' endog_depvar`i'(string)		///
					endog_indepvars`i'(string)	
		}
	}
	local 0 , `options'
	if "`s'" != "" {
		syntax, [`s']	
	}
	local alldepvars `odepvar' `oindepvars' `sel_depvar' `tr_depvar'
	if `nbendog' > 0 {
		forvalues i = 1/`nbendog' {
			local alldepvars `alldepvars' `bendog_depvar`i''
		}
	}
	if `noendog' > 0 {
		forvalues i = 1/`noendog' {
			local alldepvars `alldepvars' `oendog_depvar`i''
		}
	}
	if `nendog' > 0 {
		forvalues i = 1/`nendog' {
			local alldepvars `alldepvars' `endog_depvar`i''
		}
	}
	local userecinit = 0
	if `"`tr_depvar'"' != "" {
		ListRank `tr_indepvars' if `touse', depvarlist(`alldepvars')
		if `r(rank)' > 0 {
			local userecinit = 1
			local tr_dvlist `r(dvlist)'
			local tr_dvlist: list sort tr_dvlist
		}
	}
	if `"`sel_depvar'"' != "" {
		ListRank `sel_indepvars' if `touse' , depvarlist(`alldepvars')
		if `r(rank)' > 0 {
			local userecinit = 1
			local sel_dvlist `r(dvlist)'
			local sel_dvlist: list sort sel_dvlist
		}
	}	
	if `nbendog' > 0 {
		forvalues i = 1/`nbendog' {
			ListRank `bendog_indepvars`i'' if `touse', ///
				depvarlist(`alldepvars')
			if `r(rank)' > 0 {
				local userecinit = 1
				local bendog_dvlist`i' `r(dvlist)'
				local bendog_dvlist`i': list sort ///
					bendog_dvlist`i'
			}
		}
	}
	if `noendog' > 0 {
		forvalues i = 1/`noendog' {
			ListRank `oendog_indepvars`i'' if `touse', ///
				depvarlist(`alldepvars')
			if `r(rank)' > 0 {
				local userecinit = 1
				local oendog_dvlist`i' `r(dvlist)'
				local oendog_dvlist`i': list sort ///
					oendog_dvlist`i'
			}
		}
	}
	if `nendog' > 0 {
		forvalues i = 1/`nendog' {
			ListRank `endog_indepvars`i'' if `touse', ///
				depvarlist(`alldepvars')
			if `r(rank)' > 0 {
				local userecinit = 1
				local endog_dvlist`i' `r(dvlist)'
				local endog_dvlist`i': list sort ///
					endog_dvlist`i'
			}
		}
	}
	
	ListRank `indepvars' if `touse', ///
		depvarlist(`alldepvars')
	local depvar_dvlist `r(dvlist)'
	local depvar_dvlist: list uniq depvar_dvlist	
	local adepvar_dvlist `depvar_dvlist'
	local podepvar_dvlist: list depvar_dvlist - tr_depvar
	local done = 0
	while ~`done' {
		local iteropts depvar(`depvar')		/// 
			depvar_dvlist(`depvar_dvlist')	///
			sel_depvar(`sel_depvar')	///
			sel_dvlist(`sel_dvlist')	///
			tr_depvar(`tr_depvar')		///
			tr_dvlist(`tr_dvlist')		///
			nendog(`nendog')		///
			nbendog(`nbendog')		///
			noendog(`noendog')					
		local mdepvar_dvlist `depvar_dvlist'
		local mpodepvar_dvlist `podepvar_dvlist'
		local mtr_dvlist `tr_dvlist'
		local msel_dvlist `sel_dvlist'		
		if `nbendog' > 0 {
			forvalues i = 1/`nbendog' {
				local mbendog_dvlist`i' `bendog_dvlist`i''
				local bv `bendog_depvar`i''
				local iteropts `iteropts' 	///
					bendog_depvar`i'(`bv') 	///
					bendog_dvlist`i'(`bendog_dvlist`i'')	
			}
		}
		if `noendog' > 0 {
			forvalues i = 1/`noendog' {
				local moendog_dvlist`i' `oendog_dvlist`i''
				local ov `oendog_depvar`i''
				local iteropts `iteropts' 	///
					oendog_depvar`i'(`ov') 	///
					oendog_dvlist`i'(`oendog_dvlist`i'')
			}
		}
		if `nendog' > 0 {
			forvalues i = 1/`nendog' {
				local mendog_dvlist`i' `endog_dvlist`i''
				local ev `endog_depvar`i''
				local iteropts `iteropts' 	///
					endog_depvar`i'(`ev') 	///
					endog_dvlist`i'(`endog_dvlist`i'')
			}
		}
		local done = 1
		IterVars, actdvlist(`depvar_dvlist') `iteropts'
		local depvar_dvlist `r(actdvlist)'
		local done = `done' & ("`mdepvar_dvlist'" =="`depvar_dvlist'")
		IterVars, actdvlist(`podepvar_dvlist') `iteropts'
		local podepvar_dvlist `r(actdvlist)'
		local done = `done' & ///
			("`mpodepvar_dvlist'" =="`podepvar_dvlist'")
		if "`sel_depvar'" != "" {
			IterVars, actdvlist(`sel_dvlist') `iteropts'
			local sel_dvlist `r(actdvlist)'
			local done = `done' & ///
				("`msel_dvlist'" =="`sel_dvlist'")
		}
		if "`tr_depvar'" != "" {
			IterVars, actdvlist(`tr_dvlist') `iteropts'
			local tr_dvlist `r(actdvlist)'
			local done = `done' & ///
				("`mtr_dvlist'" =="`tr_dvlist'")
		}
		if `nbendog' > 0 {
			forvalues i = 1/`nbendog' {
				IterVars, actdvlist(`bendog_dvlist`i'') ///
					`iteropts'
				local bendog_dvlist`i' `r(actdvlist)'
				local done = `done' & 		///
					("`mbendog_dvlist`i''"	///
					=="`bendog_dvlist`i''")
			}				
		}
		if `noendog' > 0 {
			forvalues i = 1/`noendog' {
				IterVars, actdvlist(`oendog_dvlist`i'') ///
					`iteropts'
				local oendog_dvlist`i' `r(actdvlist)'
				local done = `done' & 		///
					("`moendog_dvlist`i''"	///
					=="`oendog_dvlist`i''")
			}				
		}
		if `nendog' > 0 {
			forvalues i = 1/`nendog' {
				IterVars, actdvlist(`endog_dvlist`i'') 	///
					`iteropts'
				local endog_dvlist`i' `r(actdvlist)'
				local done = `done' & 		///
					("`mendog_dvlist`i''"	///
					=="`endog_dvlist`i''")
			}				
		}
	}
	// Now return the lists
	local odtestlist `oindepvars'
	return local depvar_dvlist `depvar_dvlist'	
	local test: list depvar_dvlist & odepvar
	if "`test'" != "" {
		local a "{p 0 4 2}endogenous variables do not form a"
		local a "`a' triangular system; {bf:`odepvar'}"
		local a "`a' predicts itself{p_end}"
		noi di as error "`a'"
		exit 498
	}
	local test: list sel_depvar & sel_dvlist
	if "`test'" != "" {
		local a "{p 0 4 2}endogenous variables do not form a"
		local a "`a' triangular system; {bf:`sel_depvar'}"
		local a "`a' predicts itself{p_end}"
		noi di as error "`a'"
		exit 498
	}
	local odtestlist `odtestlist' `sel_dvlist'
	return local sel_dvlist `sel_dvlist'
	local test: list tr_depvar & tr_dvlist
	if "`test'" != "" {
		local a "{p 0 4 2}endogenous variables do not form a"
		local a "`a' triangular system; {bf:`tr_depvar'}"
		local a "`a' predicts itself{p_end}"
		noi di as error "`a'"
		exit 498
	}
	local odtestlist `odtestlist' `tr_dvlist'	
	return local tr_dvlist `tr_dvlist'
	if `nbendog' > 0 {
		local testlist `bendog_depvars'
		forvalues i = 1/`nbendog' {
			gettoken testdepvar testlist: testlist
			local test: list testdepvar & bendog_dvlist`i'
			if "`test'" != "" {
				local a "{p 0 4 2}endogenous variables do"
				local a "`a' not form a"
				local a "`a' triangular system;"
				local a "`a' {bf:`testdepvar'}"
				local a "`a' predicts itself{p_end}"
				noi di as error "`a'"
				exit 498
			}			
			local odtestlist `odtestlist' `bendog_dvlist`i''
			return local bendog_dvlist`i' `bendog_dvlist`i''
		}
	}
	if `noendog' > 0 {
		local testlist `oendog_depvars'
		forvalues i = 1/`noendog' {
			gettoken testdepvar testlist: testlist
			local test: list testdepvar & oendog_dvlist`i'
			if "`test'" != "" {
				local a "{p 0 4 2}endogenous variables do"
				local a "`a' not form a"
				local a "`a' triangular system;"
				local a "`a' {bf:`testdepvar'}"
				local a "`a' predicts itself{p_end}"
				noi di as error "`a'"
				exit 498
			}	
			local odtestlist `odtestlist' `oendog_dvlist`i''
			return local oendog_dvlist`i' `oendog_dvlist`i''
		}
	}
	if `nendog' > 0 {
		local testlist `endog_depvars'
		forvalues i = 1/`nendog' {
			gettoken testdepvar testlist: testlist
			local test: list testdepvar & endog_dvlist`i'
			if "`test'" != "" {
				local a "{p 0 4 2}endogenous variables do"
				local a "`a' not form a"
				local a "`a' triangular system;"
				local a "`a' {bf:`testdepvar'}"
				local a "`a' predicts itself{p_end}"
				noi di as error "`a'"
				local b "{p 4 4 2}The problem may be"
				local b "`b' fixable.  See"
				local b ///
	"`b' {help j_recursive##_new:triangularizing the system}{p_end}"
				noi di as error "`b'"
				exit 498
			}	
			local odtestlist `odtestlist' `endog_dvlist`i''
			return local endog_dvlist`i' `endog_dvlist`i''
		}	
	}
	local test: list odepvar & odtestlist
	if "`test'" != "" {
		local a "{p 0 4 2}endogenous variables do"
		local a "`a' not form a"
		local a "`a' triangular system;"
		local a "`a' {bf:`odepvar'}"
		local a "`a' predicts itself{p_end}"
		noi di as error "`a'"
		if "`e(cmd)'"=="eregress" {
			local b "{p 4 4 2}The problem may be"
			local b "`b' fixable.  See"
			local b ///
	"`b' {help j_recursive##_new:triangularizing the system}{p_end}"
			noi di as error "`b'"
		}
		exit 498
	}
	return local adepvar_dvlist `adepvar_dvlist'
	local init: list podepvar_dvlist & tr_depvar
	if "`init'" != "" {
		return local treatrecursive ///
			treatrecursive
		local podepvar_dvlist 
	}
	return local podepvar_dvlist `podepvar_dvlist'	
	return local userecinit = `userecinit'
end


program ListRank, rclass
	syntax [varlist(fv ts default=none)] [if], [depvarlist(string)]
	local dvlist
	local rank = 0
	marksample touse, novarlist
	fvexpand `varlist' if `touse'
	local varlist `r(varlist)'
	local dvlist 
	foreach word of local depvarlist {
		Check, check(`varlist') for(`word')
		if `r(there)' {
			local rank = `rank' + 1
			local dvlist `dvlist' `word'
		}
	}
	return local rank = `rank'
	return local dvlist `dvlist'
end
program Check, rclass
	syntax, [check(string) for(string)]
	local there = 0
	foreach word of local check {
		_ms_parse_parts `word'
		if "`r(type)'" == "variable" | "`r(type)'" == "factor" {
			local tsop
			if "`r(ts_op)'" != "" {
				local tsop `r(ts_op)'.
			}
			if "`tsop'`r(name)'" == "`for'" {
				local there = 1
				continue, break
			}
		}
		else if "`r(type)'" == "interaction" | ///
			"`r(type)'" == "product" {
			local k = r(k_names)
			forvalues i = 1/`k' {
				local tsop
				if "`r(ts_op`i')'" != "" {
                         		local tsop `r(ts_op`i')'.
	                        }
				if "`tsop'`r(name`i')'" == "`for'" {
					local there = 1
					continue, break
				}			
			}
			if `there' {
				continue, break
			}			
		}
	}
	return local there = `there'
end	

program IterVars, rclass 
	syntax, [actdvlist(string) depvar(string)		///
		sel_depvar(string) tr_depvar(string)		///
		depvar_dvlist(string) sel_dvlist(string)	/// 
		tr_dvlist(string) nbendog(string)		///
		noendog(string) nendog(string) *]
	local s
	if `nbendog' > 0 {
		forvalues i = 1/`nbendog' {
			local s `s' bendog_depvar`i'(string)		///
					bendog_dvlist`i'(string)	
		}
	}
	if `noendog' > 0 {
		forvalues i = 1/`noendog' {
			local s `s' oendog_depvar`i'(string)		///
					oendog_dvlist`i'(string)	
		}
	}
	if `nendog' > 0 {
		forvalues i = 1/`nendog' {
			local s `s' endog_depvar`i'(string)		///
					endog_dvlist`i'(string)	
		}
	}
	local 0 , `options'
	if "`s'" != "" {
		syntax, [`s']	
	}

	local factdvlist
	local factdvlist `actdvlist'
	foreach var of local actdvlist {
		if "`var'" == "`depvar'" {
			local factdvlist `factdvlist' ///
				`depvar_dvlist'		
		}
		if "`var'" == "`sel_depvar'" {
			local factdvlist `factdvlist' ///
				`sel_dvlist'		
		}
		if "`var'" == "`tr_depvar'" {
			local factdvlist `factdvlist' ///
				`tr_dvlist'		
		}
		if `nbendog' > 0 {
			forvalues i = 1/`nbendog' {
				if "`var'" == "`bendog_depvar`i''" {
					local factdvlist ///
						`factdvlist' ///
						`bendog_dvlist`i''
				}
			}
		}
		if `noendog' > 0 {
			forvalues i = 1/`noendog' {
				if "`var'" == "`oendog_depvar`i''" {
					local factdvlist ///
						`factdvlist' ///
						`oendog_dvlist`i''
				}
			}
		}
		if `nendog' > 0 {
			forvalues i = 1/`nendog' {
				if "`var'" == "`endog_depvar`i''" {
					local factdvlist ///
						`factdvlist' ///
						`endog_dvlist`i''
				}
			}
		}
	}
	local actdvlist `factdvlist'
	local actdvlist: list uniq actdvlist
	local actdvlist: list sort actdvlist
	return local actdvlist `actdvlist'
end	
