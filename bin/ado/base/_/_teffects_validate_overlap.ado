*! version 1.0.2  17apr2014
program _teffects_validate_overlap
	version 13
	syntax varlist(numeric), at(passthru) tvars(varlist) tlevels(string) ///
		model(string) depvar(passthru) touse(varname) stat(string)   ///
		epscd(real) control(passthru) [ treated(string)              ///
		hvarlist(passthru) osample(string) ]

	local klev : list sizeof tlevels
	local hetprobit = ("`model'"=="hetprobit")

	tempvar p1 m 
	qui gen double `m' = .
	local prlist `p1'
	local mlist `m'
	forvalues j=2/`klev' {
		tempvar p`j' m`j'
		qui gen double `m`j'' = .
		local prlist `prlist' `p`j''
		local mlist `mlist' `m`j''

		if `hetprobit' {
			tempvar mh`j'
			qui gen `mh`j'' = .
			local mhlist `mhlist' `mh`j''
		}
	}
	local mlist `mlist' `mhlist'

	/* get propensity scores and check for overlap			*/
	_teffects_gmm_ipw `mlist' if `touse', `at' model(`model')           ///
		tvars(`tvars') tlevels(`tlevels') stat(`stat') `depvar'     ///
		tvarlist(`varlist') `control' treated(`treated') `hvarlist' ///
		prlist(`prlist')

	qui drop `mlist'
	local fail = 0
	local drop = 0
	if "`osample'" != "" {
		qui gen byte `osample' = 0 if `touse'
		label variable `osample' "overlap violation indicator"
	}
	local form err
	local par "{p}"

	if "`stat'" == "att" {
		local i1 : list posof "`treated'" in tlevels
		local i2 = `i1'
		local cond `""1 -" %9.3e `epscd'"'
		local epscd = 1-`epscd'
		local dir greater
		local sym >
	}
	else {
		local i1 = 1
		local i2 = `klev'
		local dir less
		local sym <
		local cond %9.3e `epscd'
	}
	forvalues j=`i1'/`i2' {
		qui count if `p`j'' `sym' `epscd' & `touse'
		if r(N) {
			local lev : word `j' of `tlevels'
			local mys = cond(r(N)>1, "s", "")
			di as err "{p}treatment `lev' has " r(N) " " ///
			 "propensity score`mys' `dir' than " `cond' "{p_end}"
			local `++fail'
			if "`force'" != "" {
				qui replace `touse' = 0 if `p`j''`sym'`epscd'
			}
			else if "`osample'" != "" {
					qui replace `osample' = 1 ///
						if `p`j''`sym'`epscd'
			}
			local drop = `drop' + r(N)
		}
	}
	if (`fail') {
		di as err "{p}treatment overlap assumption has been " ///
		 "violated" _c
		local link teffects_ipw##osample:osample
		if "`osample'" != "" {
			di as err " by observations identified in variable " ///
			 "{helpb `link'}{bf:(`osample')}{p_end}"
		}
		else {
			di as err "; use option {helpb `link'}" ///
			 "{bf:()} to identify the overlap violators{p_end}"
		}
		exit 498
	}
end
exit
