*! version 2.0.2  15apr2019
program mlexp_p
	version 14
	
	if "`e(cmd)'" != "mlexp" {
		exit 301
	}
	
	syntax anything(name=vlist) [if] [in], [ 		///
				xb Equation(string)		///
			  SCores 				///
			  FORCENUMERIC	/* undocumented */	///
			]
	
	if "`xb'" == "" & "`scores'" == "" {
		di "{txt}(option {bf:xb} assumed)"
		local xb xb
	}
	if "`xb'" != "" {
		_predict `0'
		exit 0
	}	
	marksample touse
	qui replace `touse' = 0 if !e(sample)	

	tempname b
	mat `b' = e(b)

	local k = e(k)
	local version = cond(missing(e(version)),0,e(version))
	local params `e(params)'
	local expr `e(lexp)'

	if `version' < 14.0 {
		local eqparms `params'
		local kscr = `k'
		local what parameter
	}
	else {
		local eqnames : coleq `b'
		local eqnames : list uniq eqnames
		local kscr : list sizeof eqnames
		local eqparms `eqnames'
		local what equation
	}
	_stubstar2names `vlist', nvars(`kscr')
	local typlist `s(typlist)'
	local typ : word 1 of `typlist'
	local varlist `s(varlist)'
	local i = 0
	foreach var of local varlist {
		tempvar var`++i'
		qui gen double `var`i'' = .
		local tvlist `tvlist' `var`i''
	}
	
	if `version' < 14 {
		local i = 0
		foreach p of local eqparms {
			local xb`p' `b'[1,`++i']
			local xblist `"`xblist' `xb`p''"'
		}
	}
	else {
		tempname beq
		local clist (
		local vlist
		foreach eq of local eqparms {
			tempvar xb`eq'
			mat `beq' = `b'[1,"`eq':"]
			mat score double `xb`eq'' = `beq'
			local xblist `"`xblist' `xb`eq''"'
			local vars : colnames `beq'
			local vcons _cons
			local vcons : list vcons & vars
			local cons = ("`vcons'"=="_cons")
			local clist "`clist'`c'`cons'"
			if `cons' {
				local vars : list vars - vcons
			}
			if "`vars'" == "" {
				local vlist `"`vlist'`sep'_"'
			}
			else {
				local vlist `"`vlist'`sep'`vars'"'
			}

			local sep |
			local c ,
		}
		local clist "`clist')"
		local c = ":"
	}
					// log-L as called by deriv()
	if "`e(hasderiv)'" == "yes" & "`forcenumeric'" == "" {
		local i = 0
		foreach ep of local eqparms {
			tempvar scr`++i'

			local dexpr `e(d_`ep')'
			foreach p of local eqparms {
				local dexpr : subinstr local dexpr ///
					"{`p'`c'}" "`xb`p''", all
			}
			cap gen double `scr`i'' = `dexpr' if `touse'
			if _rc {
				di as err "could not calculate score for `ep'"
				exit _rc
			}
		}
	}
	else {
		local i = 0
		foreach ep of local eqparms {
			tempvar scr`++i'
			qui gen double `scr`i'' = .
			local scrlist `scrlist' `scr`i''
			local xbvlist `xbvlist' `xb`ep''

			local expr : subinstr local expr "{`ep'`c'}" ///
				"`xb`ep''", all
		}
		tempvar ll
		qui gen double `ll' = .

		if "`e(wtype)'" != "" {
			tempvar wgtvar
			qui gen double `wgtvar' `e(wexp)' if `touse'
		}

		local mlopts iterate(0) nolog
		local hasderiv = 0
		local nolog = 1
		
		tempname mlexp_e
		_estimates hold `mlexp_e', copy restore
		local scoresonly = 1
		local searchoff = 1
		qui mata: _mlexp_wrk("`b'","`params'","`eqnames'",	///	
			"`xbvlist'", `"`vlist'"',`clist',"`ll'",	///
			"`touse'",`"`expr'"', "`e(wtype)'",		///
			"`wgtvar'","`e(vce)'","",`hasderiv',"","",	///
			"`e(Cns)'",`version',`nolog',"","`mlopts'",	///
			`searchoff',`"`scrlist'"')

	}
	local i = 0
	foreach var of local varlist {
		local ep : word `++i' of `eqparms'
		qui gen `typ' `var' = `scr`i''
		label variable `var' `"score for `what' `ep'"'
	}
end	
exit
