*! version 1.5.0  10jan2017
program estat_summ, rclass sortpreserve
	version 11

	if "`e(cmd)'" == "" {
		error 301
	}

	capture assert e(sample) == 0
	if !_rc {
		dis as err "e(sample) information not available"
		exit 498
	}

	syntax [anything(name=eqlist id="equation list")] , [	///
		EQuation					///
		noHEAder					///
		noWEIghts					///
		LABels						///
		MISSWARNING                                     /// NODOC	
		vsquish						///
		ALLBASElevels					///
		BASElevels					///
		noOMITted					///
		noEMPTYcells					///
		FVWRAP(passthru)				///
		FVWRAPON(passthru)				///
		NOFVLABel					/// [sic]
		FVLABel						///
		GROUP(passthru)					/// NODOC
	]

	_get_diopts DIOPTS,	`vsquish'		///
				`allbaselevels'		///
				`baselevels'		///
				`omitted'		///
				`emptycells'		///
				`fvwrap'		///
				`fvwrapon'		///
				`nofvlabel'		///
				`fvlabel'		///
							 // blank
	local eq `equation'

	local sample "e(sample)"
	local USCONS	_cons o._cons _se

	if `:length local group' {
		if !inlist("`e(cmd)'", "sem", "gsem") {
			di as err ///
			"group() option only allowed with sem and gsem"
			exit 498
		}	
		local group = bsubstr("`group'",7,length("`group'")-7)
		local sample "`sample' & `group'"
	}
// turn (e(b),eq) or eqlist into the following macros
//
//         neq           #equations
//         eqname<i>     equation name <i>
//         eqvlist<i>    eqlist in equation <i>

	if `"`eqlist'"' == "" {
		capture confirm matrix e(b)
		if !has_eprop(b) | _rc {
			dis as err "matrix e(b) not found in estimation results"
			exit 321
		}

		tempname b
		matrix `b' = e(b)
		if rowsof(`b') != 1 {
			dis as err "matrix e(b) is not a row vector"
			exit 322
		}

		_ms_lf_info
		local nlf = r(k_lf)
		local neq = 0
		if "`eq'" == "" {
			local vnames `e(depvar)'
			forval i = 1/`nlf' {
				local vnames `vnames' `r(varlist`i')'
			}
			local neq 1
			local vnames : list uniq vnames
			local vnames : list vnames - USCONS
			local eqvlist`neq' : copy local vnames
		}
		else {
			if "`e(depvar)'" != "" {
				local eqname`++neq'  depvar
				local eqvlist`neq' `e(depvar)'
			}
			forval i = 1/`nlf' {
				local cnames `"`r(varlist`i')'"'
				local cnames : list uniq cnames
				local cnames : list cnames - USCONS
				if `:length local cnames' {
					local eqname`++neq' `r(lf`i')'
					local eqvlist`neq' : copy local cnames
				}
			}
		}
	}
	else {
		local spec   `"`eqlist'"'
		local spc : subinstr local spec ":" ":" , all count(local eqcnt)
		if `eqcnt' {
			local eqlist
			local eq eq
			local neq = 0
			gettoken tok spec : spec, match(parens)
			while `"`tok'"' != "" {
				gettoken eqname tok : tok, parse(":=")
				gettoken equal  tok : tok, parse(":=")
				if "`equal'" != ":" {
					dis as err ///
`"equation list invalid; ":" expected"'
					exit 198
				}
				fvexpand `tok' if `sample'
				local vlist `"`r(varlist)'"'
				local pos : list posof "`eqname'" in eqlist
				if `pos' == 0 {
					local eqlist `eqlist' `eqname'
					local eqname`++neq' `eqname'
					local eqvlist`neq' : copy local vlist
				}
				else {
					local eqvlist`pos'	///
						`eqvlist`pos'' `vlist'
				}

				if trim(`"`spec'"') == "" {
					continue, break
				}
				gettoken tok spec : spec, match(parens)
			}
		}
		else {
			local neq = 1
			fvexpand `:list uniq eqlist' if `sample'
			local eqvlist`neq' `r(varlist)'
		}
	}

	qui count if `sample'
	local sampsz = r(N)

	local warn
	forvalues ieq = 1/`neq' {
		local vll
		foreach v of local eqvlist`ieq' {
			capture unopvarlist `v'
			if !c(rc) {
				local v `"`r(varlist)'"'
				local vll : list vll | v
			}
		}
		foreach v of local vll {
			// capture here in case variable doesn't exist
			capture count if `sample' & missing(`v')
			if _rc==0 & `r(N)' != 0 {
				local junk `e(depvar)'
				local junk : subinstr local junk "`v'" "", ///
					count(local matches)
				if `matches' == 0 {
if "`misswarning'" == "" {	
	di as text "`v' " as err "has `r(N)' missing " 		///
			plural(`r(N)', "observation")
	exit 498
}
else {
	local warntmp : di "`v' has `r(N)' missing "		///
			 plural(`r(N)', "observation")
	local warn `"`warn' "`warntmp'""'
}
				}
				else {
					local depnote "y"
				}
			}
		}
	}
	if `"`warn'"'!="" {
		local warn `"`warn' "the following table is based on nonmissing observations""'
	}

// check that weights can be evaluated and e(cluster) can be found

	if "`e(wtype)'" != "" & "`weights'" != "noweights" {
		tempvar wvar
		capture gen `wvar' `e(wexp)' if `sample'
		if _rc {
			dis as err "weighting expression cannot be evaluated"
			capture gen `wvar' `e(wexp)'
			exit 111
		}
		label var `wvar' `"`e(wexp)'"'
		char `wvar'[varname] _weight

		// summary will be weighted same as estimation cmd
		if "`e(wtype)'" == "pweight" {
			// treat pweight as aweight for -summarize-
			// produces okay mean and std. dev.
			local wt "[aweight=`wvar']"
		}
		else {
			local wt "[`e(wtype)'=`wvar']"
		}

		if "`e(wtype)'" == "fweight" {
			// will pass along f weight to report weighted N
			// a, i, and p weights do not change N
			local fwvar `wvar'
		}
	}

	if "`e(clustvar)'" != "" {
		capture confirm variable `e(clustvar)'
		if _rc {
			dis as err "cluster() variable `e(clustvar)' not found"
			exit 111
		}
	}

// width of table including variable labels

	local len = 21
	if "`labels'" != "" {
		forvalues ieq = 1 / `neq' {
			foreach v of local eqvlist`ieq' {
				if (bsubstr("`v'",1,4) == "_cut") continue

				capture confirm var `v'
				if !_rc {
					local vll : var label `v'
					local vll : length local vll
					local len = max(`len', `vll')
				}
			}
		}

		if "`e(wtype)'" != "" & "`weights'" != "noweights" {
			// wvar was generated and labeled previously
			local vll : var label `wvar'
			local vll : length local vll
			local len = max(`len', `vll')
		}

		local vlwidth = min(`:set linesize' - 57, `len')
		local llength = 53 + `vlwidth'
	}
	else {
		local vlwidth = min(`:set linesize' - 57, `len')
		local llength = 59
	}

// display table

	tempname stats newstats omit

	if "`header'" == "" {
		Header "`labels'" "`llength'" "`fwvar'" "`group'"
		if `"`warn'"' != "" {
			foreach word of local warn {
				di as text `"   `word'"'
			}
		}
	}
	HeaderTab `llength' "`labels'"

	forvalues ieq = 1/`neq' {
		local eqts `eqts`ieq''
		foreach v of local eqvlist`ieq' {
			gettoken tsop eqts : eqts
			if (bsubstr("`v'",1,4) == "_cut")  continue

			Summ "`eqname`ieq''" `v' "`wt'" "`group'"
			matrix `stats' = nullmat(`stats') \ r(stats)
			local codes `"`codes' "`r(code)'""'
		}
	}

	if "`e(wtype)'" != "" & "`weights'" != "noweights" {
		if "`eq'" != "" {
			local weq weight
			local ++neq
			local eqvlist`neq' `wvar'
		}
		else {
			local eqvlist`neq' `eqvlist`neq'' `wvar'
		}
		// summary statistics of weights are themselves unweighted
		Summ "`weq'" `wvar' "" "`group'"
		matrix `stats' = nullmat(`stats') \ r(stats)
		local codes `"`codes' "`r(code)'""'
	}

	local diopts : copy local DIOPTS
	if !`:list posof "vsquish" in diopts' {
		local diopts `diopts' vsquish
	}

	if !`:length local labels' {
		local indent indent(2)
	}
	_ms_build_info `stats' if `sample', row
	local k 0
	forval i = 1/`neq' {
		Line "+" `llength' "`labels'"
		if `:length local eq' {
			if `: length local eqname`i'' {
				DispEqn "`eqname`i''" "`labels'"
			}
		}
		local oldvarname
		local first
		local output 0
		local dim : list sizeof eqvlist`i'
	forval j = 1/`dim' {
		local ++k
		gettoken vn eqvlist`i' : eqvlist`i'
		if "`vn'" == "`wvar'" & "`eq'" == "" {
			Line "+" `llength' "`labels'"
		}
		gettoken code codes : codes
		local name
		if "`labels'" != "" {
			quietly _ms_display,	matrix(`stats')	///
						row		///
						eq(#`i')	///
						el(`j')		///
						`diopts'
			if r(output) & r(type) != "interaction" &	///
				"`r(operator)'`r(level)'" != "" {
			    local varname "`r(term)'"
			    if !`:list varname == oldvarname' {
				local name noname
				local oldvarname : copy local varname
				_ms_parse_parts `varname'
				local vname `"`r(name)'"'
				local vlab : var label `vname'
				local vl : piece 1 `vlwidth' of `"`vlab'"'
				local varname = abbrev("`varname'", 12)
				di as txt %12s "`varname'" " {c |}"	///
					_col(57) as txt `"`vl'"'
				// remainder of variable label
				local p 2
				local vl : piece `p' `vlwidth' of `"`vlab'"'
				while `"`vl'"' != "" {
				    di as txt _col(14) "{c |}" _col(57) `"`vl'"'
				    local ++p
				    local vl : piece `p' `vlwidth' of `"`vlab'"'
				}
				local vlab
			    }
			}
		}
		_ms_display,	matrix(`stats')		///
				row			///
				eq(#`i')		///
				el(`j')			///
				`indent'		///
				`first'			///
				`name'			///
				`diopts'
		if r(output) {
			local first
			if !`output' {
				local output 1
				local diopts : copy local DIOPTS
			}
		}
		else {
			if r(first) {
				local first first
			}
			continue
		}
		local note	`"`r(note)'"'
		if "`code'" == "numeric" {
			if "`labels'" != "" {
				local term
				if "`r(operator)'`r(level)'" == "" {
				    local term `"`r(term)'"'
				    if r(type) == "variable" {
					if "`term'" == "_weight" {
					    local term : copy local wvar
					}
				    }
				    else if r(type) == "factor" {
					local dot = strpos("`term'", ".")
				    	local ++dot
				    	local term = bsubstr("`term'",`dot',.)
				    }
				}
				if `:length local term' {
				    local vlab : var label `term'
				    local vl : piece 1 `vlwidth' of `"`vlab'"'
				    if `:length local vl' {
				    	local vl `"_col(57) as txt `"`vl'"'"'
				    }
				}
				if `:length local note' {
				    di as res _col(14) "  `note'" `vl'
				}
				else {
				    di as res				///
					_col(16) %9.0g `stats'[`k',1]	///
					_col(27) %9.0g `stats'[`k',2]	///
					_col(37) %8.0g `stats'[`k',3]	///
					_col(46) %8.0g `stats'[`k',4]	///
					`vl'
				}
				// remainder of variable label
				local p 2
				local vl : piece `p' `vlwidth' of `"`vlab'"'
				while `"`vl'"' != "" {
				    di as txt _col(14) "{c |}" _col(57) `"`vl'"'
				    local ++p
				    local vl : piece `p' `vlwidth' of `"`vlab'"'
				}
				local vlab
			}
			else {
				if `:length local note' {
				    di as res _col(16) "  `note'"
				}
				else {
				    di as res				///
					_col(21) %9.0g `stats'[`k',1]	///
					_col(35) %9.0g `stats'[`k',2]	///
					_col(48) %9.0g `stats'[`k',3]	///
					_col(61) %9.0g `stats'[`k',4]
				}
			}
		}
		else if "`code'" == "notfound" {
			if "`labels'" != "" {
				dis as txt _col(14) "  <not found>"
			}
			else {
				dis as txt _col(16) "  <not found>"
			}
		}
		else if "`code'" == "string" {
			if "`labels'" != "" {
				local term `"`r(term)'"'
				capture local vlab : var label `term'
				local vl : piece 1 `vlwidth' of `"`vlab'"'
				if `:length local vl' {
					local vl `"_col(57) as txt `"`vl'"'"'
				}
				dis as txt _col(14) "  <string variable>" `vl'
				// remainder of variable label
				local p 2
				local vl : piece `p' `vlwidth' of `"`vlab'"'
				while `"`vl'"' != "" {
				    di as txt _col(14) "{c |}" _col(57) `"`vl'"'
				    local ++p
				    local vl : piece `p' `vlwidth' of `"`vlab'"'
				}
				local vlab
			}
			else {
				dis as txt _col(16) "  <string variable>"
			}
		}
	} // j
	} // i
	Line "BT" `llength' "`labels'"

	// warn if cluster()
	if `"`e(cluster)'"' != "" | `"`e(clustvar)'"' != "" {
		if "`labels'" != "" {
			di as smcl "Std. Dev. not adjusted for clustering"
		}
		else {
			di as smcl "  Std. Dev. not adjusted for clustering"
		}
	}
	
	// warn if depvars based on missing values
	if "`depnote'" != "" {
		local dvars `e(depvar)'
		foreach dv of local dvars {
			qui count if `sample' & !missing(`dv')
			if `r(N)' != `sampsz' {
di as smcl "  `dv' statistics based on `r(N)' nonmissing observations"	
			}
		}
	}

	_ms_omit_info `stats', row
	matrix `omit' = r(omit)
	matrix `omit' = `omit''
	mata: st_matrix("`newstats'", ///
			select(st_matrix("`stats'"),!(st_matrix("`omit'"))) )
	mata: st_matrixrowstripe("`newstats'", ///
		select(st_matrixrowstripe("`stats'"),!(st_matrix("`omit'"))) )
	mat colnames `newstats' = mean sd min max

	return matrix stats = `newstats'
end

// ---------------------------------------------------------------------------
// subroutines
// ---------------------------------------------------------------------------

program Summ, rclass
	args eqname vn wgt group
	tempname stats
	matrix `stats' = J(1,4,.)
	
	local ifopt "if e(sample)"
	if `:length local group' {
		local ifopt "`ifopt' & `group'"
	}
	local code numeric
	local vvn : copy local vn
	capture display `vn'
	if c(rc) {
		local code notfound
	}
	else {
		local numeric 1
		unopvarlist `vn'
		local vlist `"`r(varlist)'"'
		if `:list vlist == vn' {
			local vvn : char `vn'[varname]
			if "`vvn'" == "" {
				local vvn : copy local vn
			}
			capture confirm numeric var `vn'
			local numeric = c(rc) == 0
		}
		if `numeric' {
			FixFactor vn : `vn'
			quiet summ `vn' `wgt' `ifopt'
			matrix `stats' = (r(mean),r(sd),r(min),r(max))
		}
		else {
			local code string
		}
	}
	matrix colnames `stats' = mean sd min max
	matrix rownames `stats' = `"`eqname':`vvn'"'
	return matrix stats     = `stats'
	return local code "`code'"
end

program FixFactor
	args c_vn COLON vn
	_ms_parse_parts `vn'
	if r(type) == "factor" {
		if !r(base) {
			c_local `c_vn' bn.`vn'
		}
	}
	else if r(type) == "interaction" {
		local k = r(k_names)
		if r(omit) {
			local o "o."
		}
		forval i = 1/`k' {
			local name = r(name`i')
			if "`r(ts_op`i')'" != "" {
				local name `r(ts_op)'.`name'
			}
			if "`r(level`i')'" != "" {
				if r(base`i') {
					local name `r(level`i')'b.`name'
				}
				else {
					local name `r(level`i')'`o'bn.`name'
				}
			}
			else {
				local name c.`o'`name'
			}
			local spec `spec'`sharp'`name'
			local sharp "#"
		}
		c_local `c_vn' `spec'
	}
end

// Header llength fw
// displays table header line length llength
// fw is freq. weight variable if it is to be used in computing N
//
program Header
	args labels llength fw group

	if "`e(cmd)'"=="gsem" | "`e(cmd)'"=="meglm" {
		local cmd `e(cmd2)'
	}
	if missing("`cmd'") local cmd `e(cmd)'
	
	tempvar last N touse
	if `:length local group' {
		local ifgroup = "& `group'"
	}
	quietly gen byte `touse' = e(sample) `ifgroup'
	if "`fw'" == "" {
		quietly count if `touse'
	}
	else {	// have fweights
		quietly summ `touse' [fw=`fw'], meanonly
	}
	local Obs = r(N)

	if "`e(clustvar)'" == "" {

		local ll = `llength' - 21
		if "`labels'" != "" {
			dis _n as txt "Estimation sample " as res "`cmd'" ///
			  _col(`ll') as txt "Number of obs = " as res %10.0fc `Obs'
		}
		else {
			dis _n as txt "  Estimation sample " ///
			  as res "`cmd'" ///
			  _col(`=`ll'+6') as txt ///
			  "Number of obs = " as res %10.0fc `Obs'
		}
	}
	else {
		local ll = `llength' - 28
		if "`labels'" != "" {
			dis _n as txt "Estimation sample " as res "`cmd'" ///
			    _col(`ll') as txt "Number of obs        = " ///
			    as res %10.0fc `Obs' _n
		}
		else {
			dis _n as txt "  Estimation sample " ///
			    as res "`cmd'"
			dis _col(`=`ll'+6') as txt "Number of obs        = " ///
			    as res %10.0fc `Obs' _n
		}

		qui bys `touse' `e(clustvar)' : gen `last' = _N==_n if `touse'
		if "`fw'" == "" {
			qui bys `touse' `e(clustvar)' : gen `c(obs_t)' `N' = _N if `touse'
		}
		else {
			qui bys `touse' `e(clustvar)' : ///
					gen `N'=sum(`fw') if `touse'
		}

		quietly count if `last'==1
		if "`labels'" != "" {
			dis _col(`ll') as txt "Number of clusters   = " ///
							as res %10.0fc r(N)
		}
		else {
			dis _col(`=`ll'+6') as txt "Number of clusters   = " ///
							as res %10.0fc r(N)
		}

		quietly summ `N' if `last'==1
		if "`labels'" != "" {
			dis _col(`ll') as txt "Obs per cluster: min = " ///
							as res %10.0fc r(min)
			dis _col(`ll') as txt "                 avg = " ///
							as res %10.1fc r(mean)
			dis _col(`ll') as txt "                 max = " ///
							as res %10.0fc r(max)
		}
		else {
			dis _col(`=`ll'+6') as txt "Obs per cluster: min = " ///
							as res %10.0fc r(min)
			dis _col(`=`ll'+6') as txt "                 avg = " ///
							as res %10.1fc r(mean)
			dis _col(`=`ll'+6') as txt "                 max = " ///
							as res %10.0fc r(max)
		}
	}
end


program HeaderTab
	args llength labels

	dis
	Line "TT" `llength' "`labels'"
	if "`labels'" != "" {
		dis as txt "    Variable {c |}  " ///
		           "    Mean   Std. Dev.     Min      Max   Label"
	}
	else {
		dis as txt "      Variable {c |}  " ///
		           "       Mean      Std. Dev.         Min          Max"
	}
end


// Line ch n
// displays a line (in green) of length n with separator ch (+, BT etc)
//
program Line
	args ch llength labels

	if "`labels'" != "" {
		dis as txt "{hline 13}{c `ch'}{hline `=`llength'-10'}"
	}
	else {
		dis as txt "  {hline 13}{c `ch'}{hline `=`llength'-6'}"
	}
end


program DispEqn
	args eqn labels

	local eqn = abbrev("`eqn'",12)
	if "`labels'" != "" {
		dis as res "`eqn'" _col(14) as txt "{c |}"
	}
	else {
		dis as res "  `eqn'" _col(16) as txt "{c |}"
	}
end
exit
