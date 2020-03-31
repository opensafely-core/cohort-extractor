*! version 1.0.0  23mar2017
program _eprobit_asf
	syntax, varn(string) [vart(string)] eq(string)	[noOFFset]	///
	[cond(string)] outcomeorder(string) touse(string) 		///
	[intpoints(string)] [defaultasf]	
	tempvar xb
	qui predict double `xb' if `touse', xb equation(`eq') `offset'
	tempname fullvar allcatvals
	matrix `fullvar' = e(varfull)
	matrix `allcatvals' = e(catvals)
	local i = colnumb(`fullvar',`"`eq'"')
	local catindlist `i'
	local k = colsof(`fullvar')
	local condindlist	
	local edeplist `e(depvar)'
	forvalues j = 1/`k' {
		local checklist `e(depvar_dvlist)'
		local checklistval: word `j' of `e(depvar)'
		local gotit: list checklistval & checklist
		if ("`condindlist'" == "" & "`gotit'" != "") {
			local condindlist `j'
		}
		else if ("`gotit'" != "") {
			local condindlist `condindlist', `j'
		}
	}
	if "`e(depvar_dvlist)'" != "" & "`condindlist'" != "" & ///
		"`intpoints'" != "" {
		tempname catindmat
		matrix `catindmat' = (`catindlist')
		tempname condindmat
		matrix `condindmat' = (`condindlist')
		tempname sc s0
		scalar `sc' = .
		scalar `s0' = .
		mata: eprobit_asf_cond_var_s0_sc("`fullvar'",	///
			"`catindmat'","`condindmat'","`s0'","`sc'")
	}
	tempname isbinary
	matrix `isbinary' = e(binary)
	tempvar stor
	qui gen double `stor' = .
	if `isbinary'[1,colnumb(`isbinary',"`eq'")] == 1 {
		if "`e(depvar_dvlist)'" != ""  & "`intpoints'" != "" {
			if `outcomeorder' == 2 {
				mata:_erm_asf_probit("`stor'",	///
				`intpoints',"`xb'",	///
				"`s0'","`sc'",0,"`touse'")
			}
			else {
				qui replace `xb' = -`xb'
				mata:_erm_asf_probit("`stor'",	///
				`intpoints',"`xb'",	///
				"`s0'","`sc'",1,"`touse'")
			}
		}
		else {
			if `outcomeorder' == 2 {
				qui replace `stor' = normal(`xb') if `touse'
			}
			else {
				qui replace `stor' = normal(-`xb') if `touse'
			}
		}
	}
	else {
		if `outcomeorder' == 1 & "`e(cutsinteract)'" == ""{
			local abname = ustrleft("`eq'",32-6)
			qui replace `xb' = _b[/`abname':cut1] - `xb' if `touse'
			if "`e(depvar_dvlist)'" != "" & "`intpoints'" != "" {
				mata:_erm_asf_probit("`stor'",	///
					`intpoints',		///
					"`xb'","`s0'","`sc'",1,"`touse'")
			}
			else {
				qui replace `stor' = normal(`xb') if `touse'
			}
		}
		else if `outcomeorder' == 1 {
			foreach val of numlist `e(trvalues)'`e(extrvalues)' {
				local abname = ustrleft("`eq'",32-6)
				local cutlpref ///
				/`abname':`val'.`e(extrdepvar)'`e(trdepvar)'
				qui replace `xb' = _b[`cutlpref'#cut1] ///
					- `xb' if `touse' & ///
					`e(trdepvar)'`e(extrdepvar)'==`val'
			}
			if "`e(depvar_dvlist)'" != "" & "`intpoints'" != "" {
				mata:_erm_asf_probit("`stor'",	///
					`intpoints',		///
					"`xb'","`s0'","`sc'",1,"`touse'")
			}
			else {
				qui replace `stor' = normal(`xb') if `touse'
			}
		}
		tempname nvals
		matrix `nvals' = e(nvals)
		local k = `nvals'[1,1]	
		local km1 = `k'-1
		forvalues i=2/`km1' {
			if `outcomeorder' == `i' & "`e(cutsinteract)'" == "" {
				local j = `i'-1
				tempvar xbu
				local abname = ustrleft("`eq'",32-6)
				qui gen double `xbu' = _b[/`abname':cut`i']-`xb'
				qui replace `xb' = _b[/`abname':cut`j']-`xb'
				tempvar stor1 stor2
				qui gen double `stor1' = .
				qui gen double `stor2' = .
				if "`e(depvar_dvlist)'" != "" & ///
					"`intpoints'" != "" {
					mata:_erm_asf_probit("`stor1'",	///
					`intpoints',"`xb'","`s0'",	///
					"`sc'",1,"`touse'")
					mata:_erm_asf_probit("`stor2'",	///
					`intpoints',"`xbu'","`s0'",	///
					"`sc'",1,"`touse'")
				}
				else {
					qui replace `stor1' = normal(`xb') ///
						if `touse'
					qui replace `stor2' = normal(`xbu') ///
						if `touse'			
				}
				qui replace `stor' = `stor2'-`stor1' if `touse'
			}
			else if `outcomeorder' == `i' {
				local j = `i'-1
				tempvar xbu
				qui gen double `xbu' = .
				foreach val of ///
					numlist `e(trvalues)'`e(extrvalues)' {
					local abname = ustrleft("`eq'",32-6)
					local cutlpref ///
				/`abname':`val'.`e(extrdepvar)'`e(trdepvar)'
					qui replace `xbu' = ///
_b[`cutlpref'#cut`i']-`xb' if `e(trdepvar)'`e(extrdepvar)'==`val'
					qui replace `xb' = ///
_b[`cutlpref'#cut`j']-`xb' if `e(trdepvar)'`e(extrdepvar)'==`val'
				}
				tempvar stor1 stor2
				qui gen double `stor1' = .
				qui gen double `stor2' = .
				if "`e(depvar_dvlist)'" != "" & ///
					"`intpoints'" != "" {
					mata:_erm_asf_probit("`stor1'",	///
					`intpoints',"`xb'","`s0'",	///
					"`sc'",1,"`touse'")
					mata:_erm_asf_probit("`stor2'",	///
					`intpoints',"`xbu'","`s0'",	///
					"`sc'",1,"`touse'")
				}
				else {
					qui replace `stor1' = normal(`xb') ///
						if `touse'
					qui replace `stor2' = normal(`xbu') ///
						if `touse'			
				}
				qui replace `stor' = `stor2'-`stor1' if `touse'	
			}			
		}
		if `outcomeorder' == `k' {
			local k = `k'-1
			if "`e(cutsinteract)'" == "" {
				local abname = ustrleft("`eq'",32-6)
				qui replace `xb' = -_b[/`abname':cut`k']+`xb'
			}
			else {
				foreach val of ///
					numlist `e(trvalues)'`e(extrvalues)' {
					local abname = ustrleft("`eq'",32-6)
					local cutlpref ///
				/`abname':`val'.`e(extrdepvar)'`e(trdepvar)'
					qui replace `xb' = 		///
					-_b[`cutlpref'#cut`k']+`xb'	///
					if `e(extrdepvar)'`e(trdepvar)'==`val'
				}	
			}
			if "`e(depvar_dvlist)'" != "" & "`intpoints'" != "" {
				mata:_erm_asf_probit("`stor'",	///
				`intpoints',			///
				"`xb'","`s0'","`sc'",0,"`touse'")
			}
			else {
				qui replace `stor' = normal(`xb') if `touse'
			}
		}		
	}
	gen `vart' `varn' = `stor' if `touse'
	local eqval = `allcatvals'[`outcomeorder',	///
		colnumb(`allcatvals',"`eq'")]	
	_ms_parse_parts `eq'
	local leqval: value label `r(name)'
	capture label list `leqval'
	if _rc {
		local leqval
	}
	if "`leqval'" != "" {
		local leqval: label `leqval' `eqval'
	}
	else {
		local leqval `eqval'
	}
	if "`e(depvar_dvlist)'" != "" {
		local lab `"Structural Pr(`eq'==`leqval')"'
	}
	else {
		local lab `"Pr(`eq'==`leqval')"'
	}
	label variable `varn' `"`lab'"'	
	if "`defaultasf'" != "" {
		di as text ///
			"(option {bf:asf} assumed; Pr(`eq'==`eqval'))"
	}
end
