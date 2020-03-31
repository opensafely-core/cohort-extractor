*! version 1.0.0  07jan2015

program define _stteffects_gmm_ps, rclass
	version 14.0
	syntax varlist [if], model(string) tlevel(integer) control(integer)  ///
		levels(string) tvar(varname) b(name) prob(name) [ ft(string) ///
		prlev(string) deriv(varlist) dprob(string) dft(string) ]

	local bderiv = ("`deriv'"!="")
	local eqs : coleq `b'
	local eqs : list uniq eqs
	local klev : list sizeof levels
	local kft : list sizeof ft
	if `kft' {
		if "`prlev'" != "" {
			local kpr : list posof "`prlev'" in levels
			if !`kpr' {
				/* programmer error			*/
				di as err "level `prlev' is not one of the " ///
				 "treatment levels"
				exit 197
			}
		}
		else if `kft' < `klev' {
			/* programmer error				*/
			di as err "at least `klev' variables required in " ///
			 "option {bf:ft()}"
			exit 197
		}
	}
	forvalues i=1/`klev' {
		tempvar f`i'
		local flist `flist' `f`i''
	}
	local hetprob = ("`model'"=="hetprobit")
	local probit = ("`model'"=="probit"|`hetprob')
	if `probit' { 
		Hetprobit `varlist' `if', b(`b') tlevel(`tlevel')      ///
			tvar(`tvar') levels(`levels') flist(`flist')   ///
			prob(`prob') hetprob(`hetprob') deriv(`deriv') ///
			dprob(`dprob') df(`dft')
		return add

	}
	else {
		Multinomial `varlist' `if', b(`b') tlevel(`tlevel')      ///
			control(`control') tvar(`tvar') levels(`levels') ///
			flist(`flist') prob(`prob') deriv(`deriv')       ///
			dprob(`dprob') df(`dft')
		return add
	}
	if `kft' {
		/* return probabilities					*/
		if "`prlev'" != "" {
			local f : word 1 of `ft'
			qui gen double `f' = `f`kpr'' `if'
		}
		else {
			forvalues k=1/`klev' {
				local f : word `k' of `ft'
				qui gen double `f' = `f`k''
			}
		}
	}
end

program define Hetprobit, rclass
	syntax varlist [if], b(name) tlevel(integer) hetprob(integer) ///
		tvar(varname) levels(string) flist(string) prob(name) ///
		[ deriv(varlist) dprob(string) df(string) ]

	local eqs : coleq(`b')
	local eqs : list uniq eqs
	local bderiv = ("`deriv'"!="")
	local bdprob = ("`dprob'"!="")
	local bdf = ("`df'"!="")
	if `bdprob' {
		/* IPW derivatives					*/
		gettoken dp dh : dprob
	}
	if `bdf' {
		/* IPW ATET derivatives, testing only			*/
		gettoken df dfh : df
	}

	tempvar xb tr
	qui gen byte `tr' = `tlevel'.`tvar'
	mat score double `xb' = `b' `if', eq(TME`tlevel')
	
	_stteffects_gmm_var `varlist', eqs(`eqs') eq(TME`tlevel')
	local r `r(varname)'

	tempvar f
	if `hetprob' {
		tempvar s z
		mat score double `s' = `b' `if', eq(TME`tlevel'_lnsigma)

		qui replace `s' = exp(`s') `if'
		qui replace `s' = max(`s',c(epsdouble)) `if'
		qui gen double `z' = `xb'/`s' `if'
	}
	else local z `xb'

	local k : list posof "`tlevel'" in levels
	local ft : word `k' of `flist'
	local k = mod(`k',2)+1
	local fc : word `k' of `flist'
	
	qui gen double `ft' = normal(`z') `if'
	qui gen double `fc' = 1-`ft' `if'
	qui gen double `f' = normalden(`z') `if'
	if `bdf' {
		/* ATET return dF(tlevel), testing only			*/
		qui gen double `df' =  `f' `if'
		if `hetprob' {
			qui replace `df' = `df'/`s' `if'
			qui gen double `dfh' = -`df'*`xb'
		}
	}
	qui replace `f' = cond(`tr',`f',-`f') `if'
	qui gen double `prob' = cond(`tr',`ft',`fc') `if'
	qui replace `r' = `f'/`prob' `if'

	if `bderiv' | `bdprob' {
		tempvar dfx

		qui gen double `dfx' = -`z'*`f' `if'
		local dFx `f'
	}
	if `hetprob' {
		local heq TME`tlevel'_lnsigma
		qui replace `r' = `r'/`s' `if'
		_stteffects_gmm_var `varlist', eqs(`eqs') eq(`heq')
		local rh `r(varname)'

		qui replace `rh' = -`r'*`xb' `if'

		if `bderiv' | `bdprob' {
			tempvar dFx dFs dfs

			qui gen double `dFx' = `f'/`s' `if'
			qui gen double `dFs' = -`f'*`z' `if'
			qui replace `dfx' = `dfx'/`s' `if'
			qui gen double `dfs' = `z'^2*`f' `if'
		}
	}
	if `bdprob' {
		/* return dF(tvar)					*/
		qui gen double `dp' = `dFx' `if'
		if `hetprob' {
			qui gen double `dh' = `dFs' `if'
		}
	}
	if `bderiv' {
		tempvar dr
		qui gen double `dr' = (`dfx'-`dFx'*`f'/`prob')/`prob' `if'
		if `hetprob' {
			qui replace `dr' = `dr'/`s' `if'
		}
		_stteffects_gmm_var `deriv', eqs(`eqs') req(TME`tlevel') ///
			ceq(TME`tlevel')
		local d `r(varname)'
		qui replace `d' = `dr' `if'
		if `hetprob' {
			tempvar ps drh

			qui gen double `ps' = `s'*`prob' `if'
			qui replace `dFs' = -`f'*`xb'+`ps' `if'
			qui gen double `drh' = (`dfs'-`dFs'*`f'/`ps')/`ps' `if'
			_stteffects_gmm_var `deriv', eqs(`eqs') ///
				req(TME`tlevel') ceq(`heq')
			local d `r(varname)'
			qui replace `d' = `drh' `if'

			qui replace `drh' = -`xb'*`drh' `if'
			_stteffects_gmm_var `deriv', eqs(`eqs') req(`heq') ///
				ceq(`heq') 
			local d `r(varname)'
			qui replace `d' = `drh' `if'

			qui replace `dr' = -`xb'*`dr'-`r' `if'
			_stteffects_gmm_var `deriv', eqs(`eqs') req(`heq') ///
				ceq(TME`tlevel')
			local d `r(varname)'
			qui replace `d' = `dr' `if'
		}
	}
	local rlist `r' `rh'

	return local varlist `rlist'
end

program define Multinomial, rclass
	syntax varlist [if], b(name) tlevel(integer) control(integer) ///
		tvar(varname) levels(string) flist(string) prob(name) ///
		[ deriv(varlist) dprob(string) df(string) ]

	tempvar D 
	qui gen double `prob' = 0 `if'
	qui gen double `D' = 1 `if'
	local bderiv = ("`deriv'"!="")
	local bdprob = ("`dprob'"!="")
	local bdf = ("`df'"!="")
	local klev : list sizeof levels
	local eqs : coleq `b'
	local eqs : list uniq eqs

	forvalues i=1/`klev' {
		tempvar t`i'
		local lev : word `i' of `levels'
		local f`i' : word `i' of `flist'
		qui gen byte `t`i'' = `lev'.`tvar' `if'
		if `lev' == `control' {
			qui gen double `f`i'' = 1 `if'
			local ic = `i'
		}
		else {
			if `lev' == `tlevel' {
				local it = `i'
			}
			mat score double `f`i'' = `b' `if', eq(TME`lev')
			qui replace `f`i'' = exp(`f`i'') `if'
			qui replace `D' = `D' + `f`i'' `if'
		}
	}
	forvalues i=1/`klev' {
		qui replace `f`i'' = `f`i''/`D' `if'
		qui replace `prob' = cond(`t`i'',`f`i'',`prob') `if'
		if `i' != `ic' {
			local lev : word `i' of `levels'
			_stteffects_gmm_var `varlist', eqs(`eqs') eq(TME`lev')
			local r `r(varname)'
			qui replace `r' = `t`i''-`f`i'' `if'
			local rlist `rlist' `r'
		}
	}
	return local varlist `rlist'
	
	if !`bderiv' & !`bdprob' {
		exit
	}
	local kp = 0
	local kf = 0
	forvalues i=1/`klev' {
		if `i' == `ic' {
			continue
		}
		if `bdprob' {
			/* IPW derivatives				*/
			local dp : word `++kp' of `dprob'
			qui gen double `dp' = cond(`t`i'',`f`i''*(1-`f`i''), ///
				-`f`i''*`prob') `if'
		}
		if `bdf' {
			/* ATET; dP(tlevel)/dilev			*/
			local dfk : word `++kf' of `df'
			if `i'==`it' {
				qui gen double `dfk' = `f`i''*(1-`f`i'') `if'
			}
			else {
				qui gen double `dfk' = -`f`it''*`f`i'' `if'
			}
		}
		if !`bderiv' {
			continue
		}
		local lev : word `i' of `levels'
		local req TME`lev'
		forvalues j=1/`klev' {
			if `j' == `ic' {
				continue
			}
			local lev : word `j' of `levels'
			local ceq TME`lev'
			_stteffects_gmm_var `deriv', eqs(`eqs') req(`req') ///
				ceq(`ceq')
			local d `r(varname)'
			if `i' == `j' {
				qui replace `d' = -`f`i''*(1-`f`i'') `if'
			}
			else {
				qui replace `d' = `f`i''*`f`j'' `if'
			}
		}
	}
end

exit
