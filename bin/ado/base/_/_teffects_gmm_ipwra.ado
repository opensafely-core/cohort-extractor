*! version 1.0.2  03jun2015

program define _teffects_gmm_ipwra
	version 13
	syntax varlist if [fw iw pw/], at(name) tmodel(string) omodel(string) ///
		tvars(varlist) tlevels(string) tvarlist(varlist)           ///
		depvar(varname)  dvarlist(varlist) stat(string)            ///
		control(string) [ treated(passthru) hdvarlist(varlist)     ///
		htvarlist(varlist) derivatives(varlist) ]
	/* ignore fweight, handled by GMM				*/
	local att = ("`stat'"=="att")
	local kdvar : list sizeof dvarlist
	local kpsvar : list sizeof tvarlist
	local klev : list sizeof tlevels
	local khdvar : list sizeof hdvarlist
	local khtvar : list sizeof htvarlist
	local kra = `klev'*(`kdvar'+`khdvar'+1)
	local deriv = ("`derivatives'"!="")

	local dhprob = ("`omodel'"=="hetprobit"|"`omodel'"=="fhetprobit")
	local thprob = ("`tmodel'"=="hetprobit")

	local vlist `varlist'
	local keqra = (2+`dhprob')*`klev'
	forvalues i=1/`keqra' {
		local v : word 1 of `vlist'
		local rlist `rlist' `v'
		local vlist : list vlist - v
	}
	if `deriv' {
		forvalues i=1/`klev' {
			tempvar dtv`i'
			qui gen double `dtv`i'' = 0 `if'
			local dtvar `dtvar' `dtv`i''
		}
	}
	tempvar ipw xb
	tempname xb bipw bra

	if "`stat'" != "pomeans" {
		/* ipw expects the treatment coding with the constant	*/
		/*  vector (the control level) as the first column	*/
		local jc : list posof "`control'" in tlevels
		local tvar0 : word `jc' of `tvars'
		tempvar ttvar0
		qui gen byte `ttvar0' = 1
		local tvars0 : subinstr local tvars "`tvar0'" "`ttvar0'"
	}
	else local tvars0 `tvars'

	/* IPW								*/
	if "`tmodel'" == "logit" {
		local kipw = (`klev'-1)*`kpsvar'
		local i = `kra'+1
		local k = `kra'+`kipw'
		/* programmer error					*/
		if (colsof(`at')!=`k') error 503

		mat `bipw' = `at'[1,`i'...]

		if `deriv' {
			forvalues i=1/`kipw' {
				tempvar dtvv`i'
				qui gen double `dtvv`i'' = 0 `if'
				local dtvlist `dtvlist' `dtvv`i''
			}
			SubsetDVars `derivatives', kipw(`kipw') kra(`kra') ///
				klev(`klev') dtvar(`dtvar')                ///
				dtvlist(`dtvlist') dhprob(`dhprob')
			local derivipw `r(derivipw)'
			local derivra `r(derivra)'
		}
		 _teffects_gmm_ipw_mlogit `vlist' `if', at(`bipw')        ///
			stat(`stat') tvars(`tvars0') tlevels(`tlevels')   ///
			control(`control') `treated' tvarlist(`tvarlist') ///
			ipw(`ipw') derivatives(`derivipw')
	}
	else {
		/* probit or hetprobit					*/
		local kipw = `kpsvar'+`khtvar'
		local i = `kra'+1
		local k = `kra'+`kipw'
		/* programmer error					*/
		if (colsof(`at')!=`k') error 503

		mat `bipw' = `at'[1,`i'...]

		if `deriv' {
			forvalues i=1/`kipw' {
				tempvar dtvv`i'
				qui gen double `dtvv`i'' = 0 `if'
				local dtvlist `dtvlist' `dtvv`i''
			}
			SubsetDVars `derivatives', kipw(`kipw') kra(`kra') ///
				klev(`klev') dtvar(`dtvar')                ///
				dtvlist(`dtvlist') thprob(`thprob')        ///
				dhprob(`dhprob')
			local derivipw `r(derivipw)'
			local derivra `r(derivra)'
		}
		 _teffects_gmm_ipw_hetprobit `vlist' `if', at(`bipw')     ///
			model(`tmodel') stat(`stat') tvars(`tvars0')    ///
			tlevels(`tlevels') control(`control') `treated' ///
			tvarlist(`tvarlist') hvarlist(`htvarlist')      ///
			ipw(`ipw') derivatives(`derivipw')
	}
	/* RA								*/
	mat `bra' = `at'[1,1..`kra']
	_teffects_gmm_ra `rlist' `if', at(`bra') tvars(`tvars')    ///
		tlevels(`tlevels') control(`control') `treated'    ///
		depvar(`depvar') dvarlist(`dvarlist') stat(`stat') ///
		model(`omodel') hvarlist(`hdvarlist') ipw(`ipw')   ///
		derivatives(`derivra') 

	if (!`deriv') exit

	local kpar = `kra' + `kipw'
	local kr = `klev'
	local kd = `klev'*`kpar'
	forvalues i=1/`klev' {
		local kd = `kd' + `kra'
		local r : word `++kr' of `varlist'

		local kw = 0
		forvalues k=2/`klev' {
			forvalues j=1/`kpsvar' {
				local dw : word `++kw' of `dtvlist'
				local dr : word `++kd' of `derivatives'
				qui replace `dr' = `r'*`dw'/`ipw'
			}
		}
		local kd = `kd' + `khtvar'
	}
	if `thprob' {
		local kr = `klev'
		local kd = `klev'*`kpar'
		forvalues i=1/`klev' {
			local kd = `kd' + `kra' + `kpsvar'
			local r : word `++kr' of `varlist'
			forvalues k=2/`klev' {
				local kw = `kpsvar'
				forvalues j=1/`khtvar' {
					local dw : word `++kw' of `dtvlist'
					local dr : word `++kd' of `derivatives'

					qui replace `dr' = `r'*`dw'/`ipw'
				}
			}
		}
	}
	if `dhprob' {
		local kr = 2*`klev'
		local kd = 2*`klev'*`kpar'
		forvalues i=1/`klev' {
			local kd = `kd' + `kra'
			local r : word `++kr' of `varlist'
			local kw = 0
			forvalues k=2/`klev' {
				forvalues j=1/`kpsvar' {
					local dw : word `++kw' of `dtvlist'
					local dr : word `++kd' of `derivatives'

					qui replace `dr' = `r'*`dw'/`ipw'
				}
			}
			if (`thprob') local kd = `kd' + `khtvar'
		}
	}
	if `dhprob' & `thprob' {
		local kr = 2*`klev'
		local kd = 2*`klev'*`kpar'
		forvalues i=1/`klev' {
			local kd = `kd' + `kra' + `kpsvar'
			local r : word `++kr' of `varlist'
			forvalues k=2/`klev' {
				local kw = `kpsvar'
				forvalues j=1/`khtvar' {
					local dw : word `++kw' of `dtvlist'
					local dr : word `++kd' of `derivatives'

					qui replace `dr' = `r'*`dw'/`ipw'
				}
			}
		}
	}
end

program define SubsetDVars, rclass
	syntax varlist, kipw(integer) kra(integer) klev(integer)   ///
		dtvar(varlist) dtvlist(varlist) [ thprob(integer 0) ///
		dhprob(integer 0) ]

	local k = 0
	local keq = (2+`dhprob')*`klev'

	forvalues i=1/`keq' {
		forvalues j=1/`kra' {
			local d : word `++k' of `varlist'
			local derivra `derivra' `d'
		}
		local k = `k'+`kipw'
	}
	local derivipw `dtvar' `dtvlist'
	forvalues i=2/`klev' {
		local k = `k' + `kra'
		local derivipw `derivipw' `dtvar'
		forvalues j=1/`kipw' {
			local d : word `++k' of `varlist'
			local derivipw `derivipw' `d'
		}
	}
	if `thprob' {
		local k = `k' + `kra'
		local derivipw `derivipw' `dtvar'
		forvalues j=1/`kipw' {
			local d : word `++k' of `varlist'
			local derivipw `derivipw' `d'
		}
	}
	return local derivipw `derivipw'
	return local derivra `derivra'
end
exit
