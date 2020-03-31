*! version 1.0.0  26jan2015

program define _stteffects_gmm_ipwra, rclass
	version 14.0
	syntax varlist(numeric) [if] [fw iw pw/], at(name) tvar(varname)    ///
		tmodel(string) stat(string) levels(string) control(integer) ///
		tlevel(integer) [ survdist(string) censordist(string)       ///
		ipwra(name) dipw(string) dwra(string) derivatives(varlist)  ///
		verbose ]

	local censor = ("`censordist'"!="")
	local cexpo = ("`censordist'"=="exponential")
	local pomean = ("`stat'"=="pomeans")
	local ate = ("`stat'"=="ate")
	local atet = ("`stat'"=="atet")
	local surv = ("`survdist'"!="")
	local expo = ("`survdist'"=="exponential")
	local bderiv = ("`derivatives'"!="")

	local hetprob = ("`tmodel'"=="hetprobit")
	local probit = ("`tmodel'"=="probit"|`hetprob')
	local logit = ("`tmodel'"=="logit")

	local eqs : coleq `at'
	local eqs : list uniq eqs

	/* assumption stset						*/
	/* survival time variable					*/
	local to : char _dta[st_t]
	/* failure event variable					*/
	local do : char _dta[st_d]

	local klev : list sizeof levels

	tempname bt bc
	if "`weight'"!="" & "`verbose'"!="" {
		/* gmm handles weights, use for debugging		*/
		tempvar wvar

		qui gen double `wvar'=`exp'
		local wts [`weight'=`wvar']
	}
	if "`verbose'" != "" {
		di _n "score variables"
		di "varlist |`varlist'|"
	}
	if `atet' {
		/* obtain the probability of treatment			*/
		tempvar F
		local tropt ft(`F') prlev(`tlevel')
	}
	/* return weights?						*/
	if "`ipwra'" == "" {
		tempvar ipwra
	}
	if `bderiv' {
		if "`dipw'" != "" {
			/* return derivatives for testing		*/
			local k = 0
			local dipw0 `dipw'
			local dipw
		}
		forvalues i=1/`klev' {
			local lev : word `i' of `levels'
			if `lev' == `control' {
				continue
			}
			if "`dipw0'" != "" {
				local dipw`lev' : word `++k' of `dipw0'
			}
			else {
				tempvar dipw`lev'
			}
			local dipw `dipw' `dipw`lev''
			if `atet' {
				tempvar dF`lev'
				local dft `dft' `dF`lev''
			}
		}
		if `hetprob' {
			if "`dipw0'" != "" {
				local diph : word `++k' of `dipw0'
			}
			else {
				tempvar diph
			}
			local dipw `dipw' `diph'
			if `atet' {
				tempvar dFh
				local dft `dft' `dFh'
			}
		}
		if `atet' {
			local tropt `tropt' dft(`dft')
		}
	}
	_stteffects_gmm_ps `varlist' `if', model(`tmodel') prob(`ipwra') ///
		tvar(`tvar') levels(`levels') tlevel(`tlevel')           ///
		control(`control') b(`at') `tropt' deriv(`derivatives')  ///
		dprob(`dipw')

	local slist `r(varlist)'

	tempvar ipw
	qui replace `ipwra' = 1/`ipwra' `if'
	qui gen double `ipw' = `ipwra' `if'
	if `atet' {
		/* save IPW without multiplying by F for derivatives	*/
		tempvar ipwra0
		qui gen double `ipwra0' = `ipw' `if'
		qui replace `ipwra' = cond(`tlevel'.`tvar',1,`F'*`ipwra') `if'
	}
	else {
		local ipwra0 `ipwra'
	}
	if "`verbose'" != "" {
		di _n "treatment scores"
		summarize `slist' `wts' `if'
		di _n "IP weights"
		summarize `ipwra' `if'
	}	
	if `censor' {
		tempvar wra
		if `bderiv' {
			if "`dwra'" != "" {
				/* return derivatives for debugging	*/
				gettoken dwrc dwrs : dwra
			}
			else {
				tempvar dwrc
				if !`cexpo' {
					tempvar dwrs
				}
			}
		}
		_stteffects_gmm_censor `varlist' `if', dist(`censordist') ///
			b(`at') to(`to') do(`do') deriv(`derivatives')    ///
			surv(`wra') dsurv(`dwrc' `dwrs') 

		qui replace `wra' = cond(`do',1/`wra',0) `if'
		qui replace `ipwra' = cond(`do',`ipwra'*`wra',0) `if'
		if `atet' {
			qui replace `ipwra0' = cond(`do',`ipwra0'*`wra',0) `if'
		}
		if "`verbose'" != "" {
			local slist `r(varlist)'
			di _n "censoring scores"
			summarize `slist' `wts' `if'
			di _n "censoring weights"
			summarize `wra' `if'
			di _n "combined IP and censoring weights"
			summarize `ipwra' `if'
		}
		if `bderiv' {
			tempvar wra2
			qui gen double `wra2' = cond(`do',-`wra'*`ipwra',0) `if'

			qui replace `dwrc' = cond(`do',`dwrc'*`wra2',0) `if'
			if !`cexpo' {
				qui replace `dwrs' = cond(`do', ///
					`dwrs'*`wra2',0) `if'
			}
			qui drop `wra2'
		}
	}
	if `bderiv' {
		tempvar ipw2
		qui gen double `ipw2' = -`ipw'*`ipwra0' `if'
		if `atet' {
			tempvar ti
			qui gen byte `ti' = .
		}
		forvalues i=1/`klev' {
			local lev : word `i' of `levels'
			if `lev' == `control' {
				continue
			}
			if `atet' {
				qui replace `ti' = `lev'.`tvar' `if'
				if `lev' == `tlevel' {
					qui replace `ti' = 1-`ti' `if'
				}
				qui replace `dipw`lev'' = cond(`ti', ///
						`dF`lev''*`ipwra0'+  ///
						`F'*`dipw`lev''*`ipw2',0) `if'
			}
			else {
				qui replace `dipw`lev'' = `dipw`lev''*`ipw2' ///
					`if'
			}
		}
		if `hetprob' {
			if `atet' {
				qui replace `diph' = cond(`ti', ///
					`diph'*`ipw2',0) `if'
			}
			else {
				qui replace `diph' = `diph'*`ipw2' `if'
			}
		}
		qui drop `ipw2'
		if `atet' {
			qui drop `ipw'
		}
	}
	if `surv' {
		if `atet' {
			/* condition-on-treatment			*/
			local stat0 cot
		}
		else {
			local stat0 `stat'
		}
		_stteffects_gmm_surv `varlist' `if', b(`at')                 ///
			dist(`survdist') stat(`stat0') tvar(`tvar')          ///
			levels(`levels') control(`control') tlevel(`tlevel') ///
			to(`to') do(`do') deriv(`derivatives')

		if `censor' & `bderiv' {
			/* compute CME derivatives			*/
			/* noscale option to avoid scaling scores	*/
			_stteffects_gmm_dcensor `varlist' `if', do(`do') ///
				levels(`levels') eqs(`eqs') wgt(`ipwra') ///
				expo(`expo') cexpo(`cexpo') noscale      ///
				dwgt(`dwrc' `dwrs') deriv(`derivatives')
		}
		/* compute TME deriv 					*/
		/* scale scores by weights				*/
		IPW_RA `varlist' `if', levels(`levels') control(`control') ///
			eqs(`eqs') ipw(`ipwra') expo(`expo')               ///
			hetprob(`hetprob') dipw(`dipw') deriv(`derivatives')
		if `bderiv' {
			_stteffects_gmm_scale_dome `derivatives' `if',   ///
				wgt(`ipwra') levels(`levels') eqs(`eqs') ///
				expo(`expo')
		}
	}
	else {
		IPW `varlist' `if', b(`at') stat(`stat') tvar(`tvar')    ///
			levels(`levels') control(`control') to(`to')     ///
			do(`do') ipwra(`ipwra') censor(`censor')         ///
			cexpo(`cexpo') deriv(`derivatives') dipw(`dipw') ///
			dwra(`dwrc' `dwrs') hetprob(`hetprob')
	}
	local slist `r(varlist)'
	if "`verbose'" != "" {
		di _n "outcome scores"
		summarize `slist' `if'
	}
end

program define IPW, rclass
	syntax varlist [if], b(name) stat(string) tvar(varname)  ///
		levels(string) control(integer) ipwra(varname)   ///
		to(varname) hetprob(integer) [ censor(integer 0) ///
		cexpo(integer 0) do(varname) deriv(varlist)      ///
		dwra(varlist) dipw(varlist) ]

	tempname bt btm
	tempvar t

	local bderiv = ("`deriv'"!="")
	local pomean = ("`stat'"=="pomeans")
	local klev : list sizeof levels
	local eqs : coleq `b'
	local eqs : list uniq eqs
	if `bderiv' & `censor' {
		gettoken dwc dwa : dwra
		if !`cexpo' & "`dwa'"=="" {
			/* programmer error				*/
			di as err "{p}censoring weight derivatives w.r.t. " ///
			 "log-shape linear form is required{p_end}"
			exit 498
		}
	}
	if !`pomean' {
		tempname bc

		mat `btm' = `b'[1,"POmean`control':_cons"]
		scalar `bc' = `btm'[1,1]
	}
		
	qui gen byte `t' = .
	local STAT = strupper("`stat'")
	forvalues i=1/`klev' {
		local lev : word `i' of `levels'
		qui replace `t' = `lev'.`tvar' `if'

		local ceq
		if `pomean' | `lev'==`control' {
			local poeq POmean`lev'
		}
		else {
			local poeq `STAT'`lev'
			local ceq POmean`control'
		}
		mat `btm' = `b'[1,"`poeq':_cons"]
		scalar `bt' = `btm'[1,1]
		if "`ceq'" != "" {
			scalar `bt' = `bt' + scalar(`bc')
		}
		_stteffects_gmm_var `varlist', eqs(`eqs') eq(`poeq')
		local s `r(varname)'
		/* do not scale score by weights yet			*/
		qui replace `s' = cond(`t',`to'-scalar(`bt'),0) `if'
		if `bderiv' {
			/* dPO/dpo					*/
			_stteffects_gmm_var `deriv', eqs(`eqs') req(`poeq') ///
				ceq(`poeq')
			local d `r(varname)'
			qui replace `d' = cond(`t',-`ipwra',0) `if'
			if "`ceq'" != "" {
				/* dSTAT/dpo				*/
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(`poeq') ceq(`ceq')
				local d `r(varname)'
				qui replace `d' = cond(`t',-`ipwra',0) `if'
			}
			if `censor' {
				/* compute dPO/dcm			*/
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(`poeq') ceq(CME)
				local d `r(varname)'
				qui replace `d' = cond(`do',cond(`t', ///
					`dwc'*`s',0),0) `if'
				if !`cexpo' {
					/* compute dPO/dcma		*/
					_stteffects_gmm_var `deriv',   ///
						eqs(`eqs') req(`poeq') ///
						ceq(CME_lnshape)
					local d `r(varname)'
					qui replace `d' = cond(`do', ///
						cond(`t',`dwa'*`s',0),0) `if'
				}
			}
			local k = 0
			/* treatment model				*/
			forvalues j=1/`klev' {
				local levj : word `j' of `levels'
				if `levj' == `control' {
					continue
				}
				local dipwj : word `++k' of `dipw'
				/* compute dPO/dtm			*/
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(`poeq') ceq(TME`levj')
				local d `r(varname)'
				if `censor' {
					qui replace `d' = cond(`do', ///
						cond(`t',`s'*`dipwj',0),0) `if'
				}
				else {
					qui replace `d' = cond(`t', ///
						`s'*`dipwj',0) `if'
				}
			}
			if `hetprob' {
				local diph : word `++k' of `dipw'
				/* compute dPO/dtmh			*/
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(`poeq') ceq(TME`levj'_lnsigma) 
				local d `r(varname)'
				if `censor' {
					qui replace `d' = cond(`do',    ///
						cond(`t',`s'*`diph',0),0) `if'
				}
				else {
					qui replace `d' = cond(`t', ///
						`s'*`diph',0) `if'
				}
			}
		}
		if `censor' {
			qui replace `s' = cond(`do',cond(`t',`s'*`ipwra',0), ///
				0) `if'
		}
		else {
			qui replace `s' = cond(`t',`s'*`ipwra',0) `if'
		}
		local slist `slist' `s'
	}
	return local varlist `slist'
end

program define IPW_RA, rclass
	syntax varlist [if], levels(string) eqs(string) control(integer) ///
		expo(integer) ipw(varname) hetprob(integer)              ///
		[ deriv(varlist) dipw(varlist) ]

	local bderiv = ("`deriv'"!="")
	local chain = ("`chain'"!="")
	local klev : list sizeof levels
	forvalues i=1/`klev' {
		local lev : word `i' of `levels'
		_stteffects_gmm_var `varlist', eqs(`eqs') eq(OME`lev')
		local s `r(varname)'
		if `bderiv' {
			local k = 0
			/* treatment model				*/
			forvalues j=1/`klev' {
				local levj : word `j' of `levels'
				if `levj' == `control' {
					continue
				}
				local dipwj : word `++k' of `dipw'
				/* compute dOM/dtm			*/
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(OME`lev') ceq(TME`levj')
				local d `r(varname)'
				qui replace `d' = `s'*`dipwj' `if'
			}
			if `hetprob' {
				local dipwh : word `++k' of `dipw'
				/* update dOM/dtm			*/
				_stteffects_gmm_var `deriv', eqs(`eqs') ///
					req(OME`lev') ceq(TME`levj'_lnsigma)
				local d `r(varname)'
				qui replace `d' = `s'*`dipwh' `if'
			}
		}
		/* now scale OME score					*/
		qui replace `s' = `s'*`ipw' `if'
		local slist `slist' `s'
		if !`expo' {
			/* OME_lnshape score				*/
			_stteffects_gmm_var `varlist', eqs(`eqs') ///
				eq(OME`lev'_lnshape)
			local s `r(varname)'
			if `bderiv' {
				local k = 0
				/* treatment model			*/
				forvalues j=1/`klev' {
					local levj : word `j' of `levels'
					if `levj' == `control' {
						continue
					}
					local dipwj : word `++k' of `dipw'
					/* compute dOMA/dtm		*/
					_stteffects_gmm_var `deriv',  ///
						eqs(`eqs')            ///
						req(OME`lev'_lnshape) ///
						ceq(TME`levj')
					local d `r(varname)'
					qui replace `d' = `s'*`dipwj' `if'
				}
				if `hetprob' {
					local dipwh : word `++k' of `dipw'
					/* compute dOMA/dtmh		*/
					_stteffects_gmm_var `deriv',  ///
						eqs(`eqs')            ///
						req(OME`lev'_lnshape) ///
						ceq(TME`levj'_lnsigma)
					local d `r(varname)'
					qui replace `d' = `s'*`dipwh' `if'
				}
			}
			/* now scale OME_lnshape score			*/
			qui replace `s' = `s'*`ipw' `if'
			local slist `slist' `s'
		}
	}
	return local varlist `slist'
end

exit
