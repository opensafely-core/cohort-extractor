*! version 1.1.0  30mar2018

program define _stteffects_ipwra_gmm, eclass
	version 14.0
	syntax varname, from(name) stat(string) touse(varname)             ///
		[ tmodel(string) treatvars(string) treat2vars(string)      ///
		survdist(string) survvars(string) survshape(string)        ///
		censordist(string) censorvars(string) censorshape(string)  ///
		wtype(string) wvar(varname) control(string) tlevel(string) ///
		levels(string) verbose NOLOg LOg * ]

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	local tvar `varlist'
	if "`log'" == "" {
		local noi noi
		if ("`verbose'"=="") local iterlogonly iterlogonly
	}
	local stripe : colfullnames `from'

	/* POM GMM equations						*/
	_stteffects_pom_gmm, stripe(`stripe') levels(`levels') stat(`stat') ///
		control(`control')

	local eqs `"`s(eqs)'"'
	local param `"`s(param)'"'

	mat colnames `from' = `s(stripe)'

	if "`survdist'" != "" {
		/* OME GMM equations					*/
		_stteffects_ome_gmm, dist(`survdist') vlist(`survvars') ///
			avlist(`survshape') levels(`levels')

		local eqs `"`eqs' `s(eqs)'"'
		local param `"`param' `s(param)'"'
		local survopts `"`s(options)'"'
	}
	if "`censordist'" != "" {
		/* CME GMM equations					*/
		_stteffects_ome_gmm, dist(`censordist') vlist(`censorvars') ///
			avlist(`censorshape')

		local eqs `"`eqs' `s(eqs)'"'
		local param `"`param' `s(param)'"'
		local cenopts `"`s(options)'"'
	}
	if "`tmodel'" != "" {
		local ip ip
		GetTModelOpts, tmodel(`tmodel') levels(`levels')  ///
			treatvars(`treatvars') control(`control') ///
			tlevel(`tlevel') treat2vars(`treat2vars')

		local eqs `"`eqs' `s(eqs)'"'
		local param `"`param' `s(param)'"'
		local tropts `"`s(tropts)'"'
	}
	if "`wtype'" != "" {
		local wts [`wtype'=`wvar']
		if "`wtype'" == "fweight" {
			local fwts [fw=`wvar']
		}
	}

	local kpar = colsof(`from')
	if "`verbose'" != "" {
		di _n `"equations(`eqs') nparameters(`kpar')"'
		di _n `"parameters(`param') from(`from')"'
		di _n `"`survopts' `cenopts' `tropts' stat(`stat')"'
	}
	if ("`iterlogonly'"!="") di

	cap `noi' gmm _stteffects_gmm_`ip'wra if `touse' `wts',	///
		equations(`eqs') nparameters(`kpar') 		///
		parameters(`param') from(`from')    		///
		`survopts' `cenopts' `tropts' stat(`stat')      ///
		tvar(`tvar') levels(`levels') control(`control') ///
		tlevel(`tlevel') onestep haslfderivatives	///
		`iterlogonly' `options' `verbose' `mllog'
		
	local conv = e(converged)
	local rc = c(rc)
	if `rc' {
		if (`rc'>1) di as err "{bf:gmm} estimation failed"
		
		exit `rc'
	}
	tempname rank
	local vce `e(vce)'
	local vcetype `e(vcetype)'
	local clustvar `e(clustvar)'
	local N_clust = e(N_clust)
	scalar `rank' = e(rank)

	tempname b V tu

	mat `b' = e(b)
	mat `V' = e(V)

	mat colnames `b' = `stripe'
	mat colnames `V' = `stripe'
	mat rownames `V' = `stripe'

	gen byte `tu' = e(sample)
	_ms_build_info `b' if `tu' `fwts'
	
	local N = e(N)

	ereturn post `b' `V', esample(`tu') obs(`N')
	ereturn scalar converged = `conv'
	ereturn local vce `vce'
	ereturn local vcetype `vcetype'
	ereturn local clustvar `clustvar'
	if (`N_clust' != .) eret scalar N_clust = `N_clust'
	ereturn hidden scalar rank = `rank'
end

program define GetTModelOpts, sclass
	syntax, tmodel(string) levels(string) treatvars(string) ///
		control(integer) tlevel(integer) [ treat2vars(string) ]

	local klev : list sizeof levels
	local ip ip
	_stteffects_split_vlist, vlist(`treatvars')
	local treatvars `"`s(vlist)'"'
	local tconst = ("`s(constant)'"=="")
	local tropts `"tmodel(`tmodel')"'
	if `klev' == 2 {
		local eqs `"TME`tlevel'"'
		local param `"{TME`tlevel':`treatvars'"'
		local tropts `"`tropts' instr(TME`tlevel':`treatvars'"'
		if `tconst' {
			local param `"`param' _cons}"'
			local tropts `"`tropts')"'
		}
		else {
			local param `"`param'}"'
			local tropts `"`tropts',noconstant)"'
		}
		if "`tmodel'" == "hetprobit" {
			local eqs `"`eqs' TME`tlevel'_lnsigma"'
			local param `"`param' {TME`tlevel'_lnsigma:"'
			local param `"`param'`treat2vars'}"'
			local tropts `"`tropts' instr(TME`tlevel'_lnsigma:"'
			local tropts `"`tropts' `treat2vars',noconstant)"'
		}
	}
	else {
		local tropts `"`tropts' instr("'
		forvalues i=1/`klev' {
			local lev : word `i' of `levels'
			if "`lev'" == "`control'" {
				continue
			}
			local eqs `"`eqs' TME`lev'"'
			local param `"`param' {TME`lev':`treatvars'"'
			//local tropts `"`tropts' instr(TME`lev'`treatvars'"'
			local tropts `"`tropts' TME`lev'"'
			if `tconst' {
				local param `"`param' _cons}"'
			}
			else {
				local param `"`param'}"'
			}
		}
		local tropts `"`tropts':`treatvars'"'
		if `tconst' {
			local tropts `"`tropts')"'
		}
		else {
			local tropts `"`tropts',noconstant)"'
		}
	}
	local eqs : list retokenize eqs
	local param : list retokenize param
	local tropts : list retokenize tropts

	sreturn local eqs `"`eqs'"'
	sreturn local param `"`param'"'
	sreturn local tropts `"`tropts'"'
end

exit
