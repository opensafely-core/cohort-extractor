*! version 1.0.2  03jun2015
program define _teffects_gmm_aipw
	version 13
	syntax varlist if [fw iw/],	///
		at(name)		///
		depvar(varlist) 	///  dependent var
		tvars(varlist) 		///  treatment indicator vars
		tlevels(string)		///
		psvars(string)		///  indep vars for ps
		stat(string)		///  stat
		ofform(string)		///  outcome functional form
		ovars(string)		///  raw indeps for outcome
		tmodel(string)		///  model for treatment var
		control(string)		///
		[			///
		ohvars(string)		///  hetvars for outcome (hetprobit)
		pshvars(string)		///  hetvars for ps (hetprobit)
		cmm(string)		///  Do NLS for CM parameters
		derivatives(varlist)	///
		]
	// at vector is: (pop, cmp, psp)
	// where pop is the 1 x klev vector of potential outcome pars
	//   cmp  is 1 x (klev)*(k_ov + k_ohv) vector of cond mean pars 
	//   psp  is 1 x (klev-1)*k_ps vector of propensity score pars 
	local klev : list sizeof tvars
	local k_ps   : list sizeof psvars
	local k_ov   : list sizeof ovars
	local k_ohv  : list sizeof ohvars
	local k_pshv : list sizeof pshvars

	local pslogit = ("`tmodel'"=="logit")
	local pshetprobit = ("`tmodel'"=="hetprobit")
	local ologit = ("`ofform'"=="logit"|"`ofform'"=="flogit")
	local ohetprobit = ("`ofform'"=="hetprobit"|"`ofform'"=="fhetprobit")
	local deriv = ("`derivatives'"!="")

	local kpar = `klev'*(1+`k_ov'+`k_ohv')+`k_ps'*(`klev'-1)+`k_pshv'
	// programmer error
	if (colsof(`at')!=`kpar') error 503

	// extract parameter vectors from at
	tempname pop					// PO parameters
	matrix `pop' = `at'[1,1..`klev']
							// CM parameters
	forvalues j=1/`klev' {
		tempname cmb`j' cmsig`j' 
		tempvar  oxb`j' ezb`j'

		local cmblist `cmblist' `cmb`j''
		local oxblist `oxblist' `oxb`j''
		if "`ofform'" == "linear" {
			local mulist `mulist' `oxb`j''
			local mu`j' `oxb`j''
		}
		else {
			tempvar  mu`j' 
			local mulist `mulist' `mu`j''
		}
		if `ohetprobit' {
			tempname cmsig`j' 
			tempvar ezb`j'
			local ezblist   `ezblist'   `ezb`j''
			local cmsiglist `cmsiglist' `cmsig`j''
		}
	}
	// conditional mean part
	CMeans, klev(`klev')			///
		cmblist(`cmblist')		///
		cmsiglist(`cmsiglist')		///
		mulist(`mulist')		///
		oxblist(`oxblist')		///
		ezblist(`ezblist')		///
		ofform(`ofform')		///
		k_ov(`k_ov')			///
		k_ohv(`k_ohv')			///
		at(`at')			///
		ovars(`ovars')			///
		ohvars(`ohvars')		///
		if(`if')			

	// propensity score part
	tempvar psxb ipw
	tempname psbj

	local i2 = `klev'*(1 +`k_ov'+`k_ohv') 
	if `pslogit' {
		tempvar den

		// exp(0), control
		qui gen double `den' = 1 `if'
	}
	else if `pshetprobit' {
		tempname pssigb
		tempvar pssig psxn

		local h2 = `i2' + `k_ps' 
	}
	forvalues j=1/`klev' {
		tempvar psp`j'
		local psplist `psplist' `psp`j''

		local lev : word `j' of `tlevels'
		if `lev' == `control' {
			local jc = `j'
			continue
		}
		local i1 = `i2' + 1
		local i2 = `i2' + `k_ps' 

		mat `psbj' = `at'[1,`i1'..`i2']
		mat colnames `psbj' = `psvars' 

		matrix score double `psxb' = `psbj'  `if'

		if `pslogit' {
			qui gen double `psp`j'' = exp(`psxb')  `if'

			qui replace `den' = `den' + `psp`j'' `if'
			qui drop `psxb'
		}
		else if `pshetprobit' {
			local h1 = `h2' +  1
			local h2 = `h2' + `k_pshv' 

			matrix `pssigb' = `at'[1,`h1'..`h2']
			matrix colnames `pssigb' = `pshvars'

			qui matrix score double `pssig' = `pssigb' `if'
			qui replace `pssig' = exp(`pssig')

			qui gen double `psxn' = `psxb'/`pssig' `if'
			// overlap assumption violation: prevent overflow ipw
			qui replace `psxn' = min(8.125,max(`psxn',-8.125)) `if'
			qui gen double `psp`j'' = normal(`psxn') `if'
		}
		else { // probit
			// overlap assumption violation: prevent overflow ipw
			qui replace `psxb' = min(8.125,max(`psxb',-8.125)) `if'
			qui gen double `psp`j'' = normal(`psxb') `if'
			local psxn `psxb'
		}
	}
	if `pslogit' {
		qui gen double `psp`jc'' =  1/`den' `if'
		// overlap assumption violation: prevent overflow ipw
		qui replace `psp`jc'' = max(c(epsdouble),`psp`jc'') `if'
		qui forvalues j=1/`klev' {
			if `j' == `jc' {
				continue
			}
			qui replace `psp`j'' = `psp`j''/`den' `if'
			// overlap assumption violation: prevent overflow ipw
			qui replace `psp`j'' = max(c(epsdouble),`psp`j'') `if'
		}
	}
	else {
		// index of the treated
		local jt = mod(`jc',2)+1
		qui gen double `psp`jc'' = 1-`psp`jt''	
	}
	if (`deriv' & "`cmm'"=="wnls") local cmm1 nls
	else local cmm1 `cmm'

	// Fill in moment equations
	POMoments, klev(`klev')		///	
		mulist(`mulist')	///
		oxblist(`oxblist')	///
		ezblist(`ezblist')	///
		depvar(`depvar')	///
		tvars(`tvars')		///
		psplist(`psplist')	///
		mvarlist(`varlist')	///
		ipw(`ipw')		///
		if(`if')		///
		pop(`pop')		///
		ofform(`ofform')	///
		cmm(`cmm1')		///
		stat(`stat') jcntl(`jc')

	local jres = 2*`klev'
	if (`ohetprobit') local jres = `jres' + `klev'
		
	PSMoments, tmodel(`tmodel')	///
		jcntl(`jc')		///
		jres(`jres')		///
		mcvlist(`varlist')	///
		psplist(`psplist')	///
		tvars(`tvars')		/// 
		psxb(`psxb')		///
		if(`if')		///
		psxn(`psxn')		///
		pssig(`pssig')

	if (!`deriv') exit

	tempvar psp

	qui gen double `psp' = 0 `if'
	forvalues j=1/`klev' {
		local tr : word `j' of `tvars'
		qui replace `psp' = `psp`j'' `if' & `tr'
	}

	PODerivatives , 			///
		depvar(`depvar')		///
		tvars(`tvars')			///
		jcntl(`jc')			///
		psvars(`psvars')		///
		stat(`stat') 			///
		ofform(`ofform')		///
		ovars(`ovars')			///
		tmodel(`tmodel')		///
		ipw(`ipw')			///
		psp(`psp')			///
		psplist(`psplist')		///
		mulist(`mulist')		///
		oxblist(`oxblist')		///
		ezblist(`ezblist')		///
		derivatives(`derivatives') 	///
		ohvars(`ohvars')  		///
		pshvars(`pshvars')		///
		psxn(`psxn')			///
		psxb(`psxb')			///
		pssig(`pssig')

	CMDerivatives `varlist', 		///
		depvar(`depvar')		///
		tvars(`tvars')			///
		psvars(`psvars')		///
		stat(`stat') 			///
		ofform(`ofform')		///
		ovars(`ovars')			///
		tmodel(`tmodel')		///
		ipw(`ipw')			///
		psp(`psp')			///
		psplist(`psplist')		///
		mulist(`mulist')		///
		oxblist(`oxblist')		///
		ezblist(`ezblist')		///
		derivatives(`derivatives') 	///
		ohvars(`ohvars')  		///
		pshvars(`pshvars')		///
		psxn(`psxn')			///
		psxb(`psxb')			///
		pssig(`pssig')			///
		cmm(`cmm')

	PSDerivatives `varlist', 		///
		depvar(`depvar')		///
		tvars(`tvars')			///
		jcntl(`jc')			///
		psvars(`psvars')		///
		stat(`stat') 			///
		ofform(`ofform')		///
		ovars(`ovars')			///
		tmodel(`tmodel')		///
		ipw(`ipw')			///
		psp(`psp')			///
		psplist(`psplist')		///
		mulist(`mulist')		///
		oxblist(`oxblist')		///
		ezblist(`ezblist')		///
		derivatives(`derivatives') 	///
		ohvars(`ohvars')  		///
		pshvars(`pshvars')		///
		psxn(`psxn')			///
		psxb(`psxb')			///
		pssig(`pssig')			///
		cmm(`cmm')

	if "`cmm'" == "wnls" {
		qui replace `ipw' = `ipw'*(1-`ipw') `if'
		local jr = `klev'
		if (`ohetprobit') local jrh = `jr'+`klev'

		forvalues j=1/`klev' {
			local rj : word `++jr' of `varlist'
			local tr : word `j' of `tvars'
			qui replace `rj' = cond(`tr',`rj'*`ipw',0) `if'
			if `ohetprobit' {
				local rj : word `++jrh' of `varlist'
				qui replace `rj' = cond(`tr',`rj'*`ipw',0) `if'
			}
		}
	}
end

program define PSMoments
	syntax, tmodel(string)		///
		jres(string)		///
		mcvlist(string)		///
		tvars(string)		/// 
		psplist(string)		///
		jcntl(string)		///
		if(string)		///
		[			///
		psxb(string)		///
		psxn(string)		///
		pssig(string)		///
		]

	local klev : list sizeof tvars
	forvalues j=1/`klev' {
		if `j' == `jcntl' {
			continue
		}
		local tr : word `j' of `tvars'
		local pspj : word `j' of `psplist'
		local resj : word `++jres' of `mcvlist'
		if "`tmodel'" == "logit" {
			qui replace `resj' = `tr'-`pspj' `if'
		}
		else if "`tmodel'" == "probit" {
			qui replace `resj' = normalden(`psxb')* ///
				(`tr'-`pspj')/(`pspj'*(1-`pspj')) `if'
		}
		else if "`tmodel'" == "hetprobit" {
			qui replace `resj' = normalden(`psxn')* ///
				(`tr'-`pspj')/(`pspj'*(1-`pspj')*`pssig') `if'

			local resh : word `++jres' of `mcvlist'
			qui replace `resh' = -`resj'*`psxb' `if'
		}
	}
end

program define CMeans
	syntax, klev(string)		///
		cmblist(string)		///
		mulist(string)		///
		oxblist(string)		///
		ofform(string)		///
		k_ov(string)		///
		k_ohv(string)		///
		at(string)		///
		ovars(string)		///	
		if(string)		///
		[			///
		cmsiglist(string)	///
		ezblist(string)		///
		ohvars(string)		///	
		]


	local i2 = `klev'
	if ("`ofform'" == "hetprobit"|"`ofform'" == "fhetprobit") {
		tempvar z
		qui gen double `z' = .
		local h2 = `i2' + `klev'*`k_ov'
	}
	forvalues j=1/`klev' {
		local cmbj : word `j' of `cmblist'
		local muj  : word `j' of `mulist'
		local oxbj : word `j' of `oxblist'

		local i1 = `i2' + 1
		local i2 = `i2' + `k_ov'
		matrix `cmbj' = `at'[1,`i1'..`i2']
		matrix colnames `cmbj' = `ovars'
		matrix score double `oxbj' = `cmbj' `if'

		if  "`ofform'" == "poisson" {
			qui gen double `muj' = exp(`oxbj') `if'
		}
		else if  ("`ofform'" == "probit"|"`ofform'" == "fprobit") {
			// prevent division by zero in CMomentj
			qui replace `oxbj' = min(8.125,max(`oxbj',-8.125)) `if'
			qui gen double `muj' = normal(`oxbj') `if'
		}
		else if  ("`ofform'" == "logit"|"`ofform'" == "flogit") {
			qui gen double `muj' = invlogit(`oxbj') `if'
		}
		else if ("`ofform'" == "hetprobit"|"`ofform'" == "fhetprobit") {
			local cmsigj : word `j' of `cmsiglist'
			local ezbj   : word `j' of `ezblist'

			local h1 = `h2' + 1
			local h2 = `h2' + `k_ohv'
			matrix `cmsigj' = `at'[1,`h1'..`h2']
			matrix colnames `cmsigj' = `ohvars'

			matrix score double `ezbj' = `cmsigj' `if'
			qui replace `ezbj' = exp(`ezbj') `if'
			qui replace `z' = `oxbj'/`ezbj' `if'

			// prevent division by zero in CMomentj
			qui replace `z' = min(8.125,max(`z',-8.125)) `if'
			
			qui gen double `muj' = normal(`z') `if'
		}
	}
end

program define POMoments 
	syntax, klev(string)			///	
		mulist(string)			///
		oxblist(string)			///
		depvar(string)			///
		tvars(string)			///
		psplist(string)			///
		mvarlist(string)		///
		if(string)			///
		pop(string)			///
		ofform(string)			///
		stat(string)			///
		ipw(string)			///
		jcntl(string)			///
		[				///
		ezblist(string)			///
		cmm(string)			///
		]

	qui gen double `ipw' = .
	forvalues j=1/`klev' {
		local tr : word `j' of `tvars'
		local muj  : word `j' of `mulist'
		local oxbj : word `j' of `oxblist'
		local pij : word `j' of `psplist'

		qui replace `ipw' = 1/`pij' `if' & `tr'

		// klev EIF moment equations for PO means 
		local resj : word `j' of `mvarlist'
		qui replace `resj' = cond(`tr',`ipw'*(`depvar'-`muj'),0)+ ///
			`muj'-`pop'[1,`j'] `if'
		if "`stat'"=="ate" & `j'!=`jcntl' {
			qui replace `resj' = `resj'-`pop'[1,`jcntl'] `if'
		}
		local jt = `klev' + `j'
		local resj : word `jt' of `mvarlist'

		if ("`ofform'" == "hetprobit"|"`ofform'" == "fhetprobit") {
			local ezbj : word `j' of `ezblist'
			local jt = 2*`klev' + `j'
			local resjh : word `jt' of `mvarlist'
		}
		if "`cmm'"=="" | "`cmm'"=="aipw" {
			CMomentj, ofform(`ofform')	///
				tr(`tr')		///
				depvar(`depvar')	///
				muj(`muj')		///
				oxbj(`oxbj')		///
				if(`if')		///
				resj(`resj')		///
				resjh(`resjh')		///
				ezbj(`ezbj')		///
				ipw(`ipw')
		}
		else {
			CMomentjNLS, ofform(`ofform')	///
				tr(`tr')		///
				depvar(`depvar')	///
				muj(`muj')		///
				oxbj(`oxbj')		///
				if(`if')		///
				resj(`resj')		///
				resjh(`resjh')		///
				ezbj(`ezbj')		///
				ipw(`ipw') `cmm'
		}
	}
end

// CMomentj fills in the moment-equation variables for conditional
// 	expectation moment functions
program define CMomentj	
	syntax, ofform(string)		///
		tr(string)		///
		depvar(string)		///
		muj(string)		///
		if(string)		///
		[			///
		oxbj(string)		///
		resj(string)		///
		resjh(string)		///
		ezbj(string)		///
		cmm(string)		///
		ipw(string)		///
		]

	qui replace `resj' = cond(`tr',`depvar'-`muj',0) `if'
	if ("`ofform'" == "probit"|"`ofform'" == "fprobit")  {
		qui replace `resj' = cond(`tr',`resj'*normalden(`oxbj')/ ///
			(`muj'*(1-`muj')),0) `if'
	}
	else if ("`ofform'" == "hetprobit"|"`ofform'" == "fhetprobit")  {
		qui replace `resj' = cond(`tr', ///
			`resj'*normalden(`oxbj'/`ezbj')/ ///
			((`muj')*(1-`muj')*`ezbj'),0) `if'

		qui replace `resjh' = cond(`tr',-`resj'*`oxbj',0) `if'
	}
end

// CMomentjNLS fills in the moment-equation variables for conditional
// 	expectation moment functions
program define CMomentjNLS	
	syntax, ofform(string)		///
		tr(string)		///
		depvar(string)		///
		muj(string)		///
		if(string)		///
		[			///
		oxbj(string)		///
		resj(string)		///
		resjh(string)		///
		ezbj(string)		///
		nls wnls		///
		ipw(string)		///
		]

	qui replace `resj' = cond(`tr',`depvar'-`muj',0) `if'
	if "`wnls'" != "" {
		qui replace `resj' = cond(`tr',`resj'*`ipw'*(`ipw'-1),0) `if'
	}
	if "`ofform'" == "poisson" {
		qui replace `resj' = cond(`tr',`resj'*`muj',0) `if'
	}
	else if ("`ofform'" == "probit"|"`ofform'" == "fprobit") {
		qui replace `resj' = cond(`tr',`resj'*normalden(`oxbj'),0) `if'
	}
	else if ("`ofform'" == "logit"|"`ofform'" == "flogit") {
		qui replace `resj' = cond(`tr',`resj'*`muj'*(1-`muj'),0) `if'
	}
	else if ("`ofform'" == "hetprobit"|"`ofform'" == "fhetprobit") {
		qui replace `resj' = cond(`tr',`resj'* ///
				normalden(`oxbj'/`ezbj')/`ezbj',0) `if'

		qui replace `resjh' = cond(`tr',-`resj'*`oxbj',0) `if'
	}
end

program define PODerivatives
	syntax, depvar(string)		///
		tvars(string)		///
		jcntl(string)		///
		stat(string)		///
		ofform(string)		///
		ovars(string)		///
		tmodel(string)		///
		psvars(string)		///
		ipw(string)		///
		psp(string)		///
		psplist(string)		///
		mulist(string)		///
		oxblist(string)		///
		derivatives(string)	///
		[			///
		ezblist(string)		///
		ohvars(string)		///
		pshvars(string)		///
		psxn(string)		///
		psxb(string)		///
		pssig(string)		///
		]

	local klev : list sizeof tvars
	local k_ps : list sizeof psvars
	local k_ov : list sizeof ovars
	local k_ohv : list sizeof ohvars
	local k_pshv : list sizeof pshvars

	local pslogit = ("`tmodel'"=="logit")
	local pshetprobit = ("`tmodel'"=="hetprobit")
	local ologit = ("`ofform'"=="logit"|"`ofform'"=="flogit")
	local ohetprobit = ("`ofform'"=="hetprobit"|"`ofform'"=="fhetprobit")

	tempvar pp dipw dcm del

	qui gen double `pp' = `psp'^2 `if'
	qui gen double `dipw' = .
	qui gen double `dcm' = .
	qui gen double `del' = .

	local kpar = `k_ps'*(`klev'-1)+`klev'*(1+`k_ov'+`k_ohv')+`k_pshv'
	// PO derivatives for moments computed in POMoments
	local jt2 = `jcntl'
	local jt1 = 1

	local jcm = `klev'
	if (`ohetprobit') local jch = `klev'*(1+`k_ov')

	local jps = `klev'*(1+`k_ov'+`k_ohv')
	if (`pshetprobit') local jpsh = `jps' + `k_ps'

	// potential outcomes
	forvalues j=1/`klev' {
		local tr : word `j' of `tvars'
		local muj : word `j' of `mulist'
		local oxbj : word `j' of `oxblist'
		
		// PO part
		local d : word `jt1' of `derivatives'
		qui replace `d' = -1 `if'
		local jt1 = `jt1' + `kpar' + 1
		if "`stat'" == "ate" {
			if `j' != `jcntl' {
				local d : word `jt2' of `derivatives'
				qui replace `d' = -1 `if'
			}
			local jt2 = `jt2' + `kpar'
		}

		// CM part
		qui replace `dcm' = cond(`tr',1-`ipw',1) `if'
		if `ologit' {
			qui replace `dcm' = `dcm'*`muj'*(1-`muj') `if'
		}
		else if ("`ofform'" == "probit"|"`ofform'" == "fprobit") {
			qui replace `dcm' = `dcm'*normalden(`oxbj') `if'
		}
		else if `ohetprobit' {
			local ezbj : word `j' of `ezblist'

			qui replace `dcm' = `dcm'* ///
				normalden(`oxbj'/`ezbj')/`ezbj' `if'
		}
		else if "`ofform'" == "poisson" {
			qui replace `dcm' = `dcm'*`muj' `if'
		}
		forvalues k=1/`k_ov' {
			local x : word `k' of `ovars'
			local d : word `++jcm' of `derivatives'
			qui replace `d' = `x'*`dcm' `if'
		}
		local jcm = `jcm' + `kpar'
		if `ohetprobit' {
			qui replace `dcm' = -`dcm'*`oxbj' `if'
			forvalues k=1/`k_ohv' {
				local x : word `k' of `ohvars'
				local dh : word `++jch' of `derivatives'
				qui replace `dh' = `x'*`dcm' `if'
			}
			local jch = `jch' + `kpar'
		}

		// PS part
		forvalues i=1/`klev' {
			if `i' == `jcntl' {
				continue
			}
			local pspi : word `i' of `psplist'

			if `pslogit' {
				if `i' == `j' {
					qui replace `dipw' = cond(`tr', ///
						-`psp'*(1-`psp')/`pp',0) `if'
				}
				else {
					qui replace `dipw' = cond(`tr', ///
						`psp'*`pspi'/`pp',0) `if'
				}
			}
			else { // PS probit
				if (`i'==`j') local sign -
				else local sign

				qui replace `dipw' = cond(`tr', ///
					`sign'normalden(`psxn')/`pp',0) `if'
				if `pshetprobit' {
					qui replace `dipw' = cond(`tr', ///
						`dipw'/`pssig',0) `if'
				}
			}
			qui replace `del' = `depvar'-`muj'
			forvalues k=1/`k_ps' {
				local x : word `k' of `psvars'
				local d : word `++jps' of `derivatives'
				qui replace `d' = cond(`tr', ///
					`x'*`dipw'*`del',0) `if'
			}
			if `pshetprobit' {
				forvalues k=1/`k_pshv' {

					local x : word `k' of `pshvars'
					local d : word `++jpsh' of `derivatives'
					qui replace `d' = cond(`tr', ///
						-`x'*`dipw'*`del'*`psxb',0) `if'
				}
			}
		}
		local jps = `jps' + `klev'*(1+`k_ov'+`k_ohv')+`k_pshv'
		if (`pshetprobit') local jpsh = `jps'+`k_ov'
	}
end

program define CMDerivatives
	syntax varlist, depvar(string)	///
		tvars(string)		///
		stat(string)		///
		ofform(string)		///
		ovars(string)		///
		tmodel(string)		///
		psvars(string)		///
		ipw(string)		///
		psp(string)		///
		psplist(string)		///
		mulist(string)		///
		oxblist(string)		///
		derivatives(string)	///
		[			///
		ezblist(string)		///
		ohvars(string)		///
		pshvars(string)		///
		psxn(string)		///
		psxb(string)		///
		pssig(string)		///
		cmm(string)		///
		]

	local klev : list sizeof tvars
	local k_ps : list sizeof psvars
	local k_ov : list sizeof ovars
	local k_ohv : list sizeof ohvars
	local k_pshv : list sizeof pshvars
	local kpar = `klev'*(1+`k_ov'+`k_ohv')+`k_ps'*(`klev'-1)+`k_pshv'

	local pslogit = ("`tmodel'"=="logit")
	local pshetprobit = ("`tmodel'"=="hetprobit")
	local ologit = ("`ofform'"=="logit"|"`ofform'"=="flogit")
	local ohetprobit = ("`ofform'"=="hetprobit"|"`ofform'"=="fhetprobit")
	local oprobit = ///
		("`ofform'"=="probit" | `ohetprobit' |"`ofform'"=="fprobit")
	local wnls = ("`cmm'"=="wnls")
	local nls = ("`cmm'"=="nls")
	/* conditional mean moment condition computed in CMomentj	*/
	/* qui replace `resj' = cond(`tr',`depvar'-`muj',0) `if'	*/

	tempvar dcm

	qui gen double `dcm' = .
	local jcm = `klev'*(1+`kpar')
	if `oprobit' {
		tempvar pp del d1 d2 f dch
		qui gen double `pp' = .
		qui gen double `del' = .
		qui gen double `d1' = .
		qui gen double `d2' = .
		qui gen double `f' = .
		qui gen double `dch' = .
		if (`ohetprobit') {
			tempvar xbs dcmh
			qui gen double `xbs' = .
			qui gen double `dcmh' = .

			local jch = `jcm' + `klev'*`k_ov'
			local jhc = `jcm' + `klev'*`kpar'
			local jh = `jch' + `klev'*`kpar'
			local jr = `klev'
			local jrh = 2*`klev'
		}
		else {
			tempname ezbj
		}
	}
	else if ("`ofform'"=="poisson") local jr = `klev'

	local jps = `jcm' + `klev'*(`k_ov'+`k_ohv')
	if (`pshetprobit') local jpsh = `jps' + `k_ps'

	if `wnls' {
		tempvar w1w
		qui gen double `w1w' = `ipw'*(`ipw'-1) `if'
		local nls = 1
	}
	else if `nls' {
		tempname w1w
		scalar `w1w' = 1
	}
	// conditional means
	forvalues j=1/`klev' {
		local tr : word `j' of `tvars'
		local muj : word `j' of `mulist'
		local oxbj : word `j' of `oxblist'
		
		// CM part
		if "`ofform'" == "linear" {
			qui replace `dcm' = -`tr' `if'
		}
		else if `ologit' {
			qui replace `dcm' = cond(`tr',`muj'*(`muj'-1),0) `if'
			if `nls' {
				qui replace `dcm' = cond(`tr',-`dcm'*(`dcm'+ ///
					(`depvar'-`muj')*(1-2*`muj')),0) `if'
			}
		}
		else if "`ofform'" == "poisson" {
			qui replace `dcm' = cond(`tr',-`muj',0) `if'
			if `nls' {
				local rx : word `++jr' of `varlist'
				qui replace `dcm' = cond(`tr',`dcm'*`muj'+ ///
					`rx',0) `if'
			}
		} 
		else if `oprobit' {
			if `ohetprobit' {
				local ezbj : word `j' of `ezblist'
				qui replace `xbs' = cond(`tr',`oxbj'/`ezbj', ///
						0) `if'
				local rx : word `++jr' of `varlist'
				local rh : word `++jrh' of `varlist'
			}
			else {
				local xbs `oxbj'
				scalar `ezbj' = 1
			}
			qui replace `del' = cond(`tr',`depvar'-`muj',0) `if'
			qui replace `f' = cond(`tr',normalden(`xbs')/`ezbj', ///
					0) `if'
			qui replace `d1' = cond(`tr',`xbs'*`del'/`ezbj'+`f', ///
					0) `if'
			if `nls' {
				qui replace `dcm' = cond(`tr',-`f'*`d1',0) `if'
				if `ohetprobit' {
					qui replace `dch' = cond(`tr', ///
						-(`f'*`oxbj')^2+       ///
						`rh'*(`xbs'^2-1),0) `if'
				}
			}
			else {
				qui replace `pp' = cond(`tr', ///
					`muj'*(1-`muj'),0) `if'
				qui replace `d2' = cond(`tr',`f'* ///
					(1-2*`muj')*`del'/`pp',0) `if'
				qui replace `dcm' = cond(`tr',-`f'* ///
					(`d1'+`d2')/`pp',0) `if'
				if `ohetprobit' {
					qui replace `f' = cond(`tr', ///
						-`f'*`oxbj',0) `if'
					qui replace `dch' = cond(`tr', ///
						(1-`xbs'^2)*`del'+`f',0) `if'

					qui replace `dch' = cond(`tr',-`f'* ///
						(`dch'-`oxbj'*`d2')/`pp',0) `if'
				}
			}
			if `ohetprobit' {
				qui replace `dcmh' = cond(`tr', ///
						-`rx'-`oxbj'*`dcm',0) `if'
			}
		} 
		if `wnls' {
			qui replace `dcm' = cond(`tr',`dcm'*`w1w',0) `if'
			if `ohetprobit' {
				qui replace `dcmh' = cond(`tr', ///
					`dcmh'*`w1w',0) `if'
			}
		}
		forvalues k=1/`k_ov' {
			local d : word `++jcm' of `derivatives'
			local x : word `k' of `ovars'

			qui replace `d' = cond(`tr',`x'*`dcm',0) `if'
			if `ohetprobit' {
				local d : word `++jhc' of `derivatives'
				qui replace `d' = cond(`tr',`x'*`dcmh',0) `if'
			}
		}
		if `ohetprobit' {
			if `wnls' {
				qui replace `dch' = cond(`tr', ///
					`dch'*`w1w',0) `if'
			}
			forvalues k=1/`k_ohv' {
				local d : word `++jh' of `derivatives'
				local x : word `k' of `ohvars'
				qui replace `d' = cond(`tr',`x'*`dch',0) `if'

				local dk : word `++jch' of `derivatives'
				qui replace `dk' = cond(`tr', ///
					-`x'*`dch'/`oxbj',0) `if'
			}
		}
		local jcm = `jcm' + `kpar'
		if `ohetprobit' {
			local jch = `jch' + `kpar' 
			local jhc = `jhc' + `kpar'
			local jh = `jh' + `kpar'
		}
	}
end

program define PSDerivatives
	syntax varlist, depvar(string)	///
		tvars(string)		///
		jcntl(string)		///
		stat(string)		///
		ofform(string)		///
		ovars(string)		///
		tmodel(string)		///
		psvars(string)		///
		ipw(string)		///
		psp(string)		///
		psplist(string)		///
		mulist(string)		///
		oxblist(string)		///
		derivatives(string)	///
		[			///
		ezblist(string)		///
		ohvars(string)		///
		pshvars(string)		///
		psxn(string)		///
		psxb(string)		///
		pssig(string)		///
		cmm(string)		///
		]

	local klev : list sizeof tvars
	local k_ps : list sizeof psvars
	local k_ov : list sizeof ovars
	local k_ohv : list sizeof ohvars
	local k_pshv : list sizeof pshvars
	local kpar = `klev'*(1+`k_ov'+`k_ohv')+`k_ps'*(`klev'-1)+`k_pshv'

	local pslogit = ("`tmodel'"=="logit")
	local pshetprobit = ("`tmodel'"=="hetprobit")
	local ologit = ("`ofform'"=="logit"|"`ofform'"=="flogit")
	local ohetprobit = ("`ofform'"=="hetprobit"|"`ofform'"=="fhetprobit")
	local oprobit = ///
		("`ofform'"=="probit" | `ohetprobit'|"`ofform'"=="fhetprobit")
	local wnls = ("`cmm'"=="wnls")

	local ips = `klev'*(1+`k_ov'+`k_ohv')
	local inc = `kpar'*`klev'
	local jps = `inc'*(2+`ohetprobit') + `ips'

	tempvar dps pp

	qui gen double `dps' = .
	if (`pslogit') qui gen double `pp' = `psp'^2
	else {
		if `pshetprobit' {
			tempvar dch
			local jr = `klev'*(2+`ohetprobit')
			local jph = `jps' + `kpar'
			local jhp = `jps' + `k_ps'
			local jh = `jhp' + `kpar'
		}
		else {
			tempname pssig
			scalar `pssig' = 1
		}
		tempvar f d2 del

		qui gen double `f' = normalden(`psxn')/`pssig'
		if (`wnls') qui gen double `pp' = `psp'^2
		else qui gen double `pp' = .
	}
	if `wnls' {
		tempvar w1w dps1

		qui gen double `w1w' = (2*`ipw'-1)/`pp' `if'
		qui gen double `dps1' = .
		local j = `jps'+1
		local d : word `j' of `derivatives'

		local jcm = `klev'
		local jdc = `inc' + `ips'
		if `ohetprobit' {
			tempvar dpsh

			qui gen double `dpsh' = .
			local jch = `jcm' + `klev'
			local jdh = `jdc' + `inc'
			local rch : word `++jch' of `varlist'
		}
		if `pshetprobit' {
			tempvar dpph 

			qui gen double `dpph' = . 
			local jdph = `jdc' + `k_ps' 
			if `ohetprobit' {
				tempvar dphh
				local jdhh = `jdph' + `inc'

				qui gen double `dphh' = .
			}
		}
		local tr : word 1 of `tvars'
		local rcm : word `++jcm' of `varlist'
		if (`pslogit') local pspj : word 1 of `psplist'

		forvalues i=1/`klev' {
			if `i' == `jcntl' {
				continue
			}
			if `pslogit' {
				local pspi : word `i' of `psplist'
				qui replace `dps' = cond(`tr', ///
					`pspj'*`pspi'*`w1w',0) `if'
			}
			else {
				qui replace `dps' = cond(`tr',`f'*`w1w',0) `if'
			}
			if `ohetprobit' {
				qui replace `dpsh' = cond(`tr',`dps'*`rch', ///
					0) `if'
			}
			qui replace `dps' = cond(`tr',`dps'*`rcm',0) `if'
			if `pshetprobit' {
				qui replace `dpph' = cond(`tr', ///
					-`dps'*`psxb',0)  `if'
				if `ohetprobit' {
					qui replace `dphh' = cond(`tr', ///
						-`dpsh'*`psxb',0) `if'
				}
			} 
			forvalues k=1/`k_ps' {
				local d : word `++jdc' of `derivatives'
				local x : word `k' of `psvars'
				qui replace `d' = `dps'*`x' `if'
				if `ohetprobit' {
					local d : word `++jdh' of `derivatives'
					qui replace `d' = cond(`tr', ///
						`dpsh'*`x',0) `if'
				}
			}
			if `pshetprobit' {
				forvalues k=1/`k_pshv' {
					local d : word `++jdph' of ///
						`derivatives'

					local x : word `k' of `pshvars'
					qui replace `d' = cond(`tr', ///
						`dpph'*`x',0) `if'

					if `ohetprobit' {
						local d : word `++jdhh' of ///
							`derivatives'
						qui replace `d' = cond(`tr', ///
							`dphh'*`x',0) `if'
					}
				}
			}
		}
	}
	// PO part
	forvalues j=1/`klev' {
		if `j' == `jcntl' {
			continue
		}
		local tr : word `j' of `tvars'
		local pspj : word `j' of `psplist'
		if `wnls' {
			local rcm : word `++jcm' of `varlist'
			local jdc = `inc' + `kpar'*(`j'-1) + `ips'
			if `ohetprobit' {
				local rch : word `++jch' of `varlist'
				local jdh = `jdc' + `inc'
			}
			if `pshetprobit' {
				local jdph = `jdc' + `k_ps' 
				local jdhh = `jdph' + `inc' 
			}
		}

		if `pslogit' {
			forvalues i=1/`klev' {
				if `i' == `jcntl' {
					continue
				}
				if `i' == `j' {
					qui replace `dps' = ///
						`pspj'*(`pspj'-1) `if'
				}
				else {
					local pspi : word `i' of `psplist'
					qui replace `dps' = `pspj'*`pspi' `if'
				}
				if `wnls' {
					qui replace `dps1' = cond(`tr', ///
						`dps'*`w1w',0) `if'
					if `ohetprobit' {
						qui replace `dpsh' = ///
							cond(`tr',   ///
							`dps1'*`rch',0) `if'
					}
					qui replace `dps1' = cond(`tr', ///
							`dps1'*`rcm',0) `if'
				} 
				forvalues k=1/`k_ps' {
					local d : word `++jps' of `derivatives'
					local x : word `k' of `psvars'
					qui replace `d' = `dps'*`x' `if'
					if `wnls' {
						local dc : word `++jdc' of ///
							`derivatives'
						qui replace `dc' = ///
							cond(`tr', ///
							`dps1'*`x',0) `if'
						if `ohetprobit' {
							local dc : word    ///
								`++jdh' of ///
								`derivatives'
							qui replace `dc' =  ///
								cond(`tr',  ///
								`dpsh'*`x', ///
								0) `if'
						}
					}
				}
			}
		}
		else { // probit
			qui gen double `del' = `tr'-`pspj' `if'
			qui replace `pp' = `pspj'*(1-`pspj') `if'
			qui gen double `d2' = `f'*`del'*(1-2*`pspj')/`pp' `if'
			qui replace `dps' = -`f'*(`psxn'*`del'/`pssig'+`f'+ ///
					`d2')/`pp' `if'
			if `wnls' {
				qui replace `dps1' = -`f'*`w1w' `if'
				if `ohetprobit' {
					qui replace `dpsh' = `dps1'*`rch' `if'
				}
				qui replace `dps1' = `dps1'*`rcm' `if'
				if `pshetprobit' {
					qui replace `dpph' = -`dps1'*`psxb' `if'
					if `ohetprobit' {
						qui replace `dphh' = ///
							-`dpsh'*`psxb' `if'
					}
				}
			}
			if `pshetprobit' {
				qui replace `f' = -`f'*`psxb' `if'
				qui gen double `dch' = (1-`psxn'^2)*`del'+ ///
					`f' `if'
				qui replace `dch' = -`f'*(`dch'- ///
					`psxb'*`d2')/`pp'

				local r : word `++jr' of `varlist'
			}
			forvalues i=1/`k_ps' {
				local x : word `i' of `psvars'
				local d : word `++jps' of `derivatives'

				qui replace `d' = `dps'*`x' `if'

				if `pshetprobit' {
					local d : word `++jph' of `derivatives'
					qui replace `d' = -`x'*(`r'+ ///
						`psxb'*`dps') `if'
				}
				if `wnls' {
					local dc : word `++jdc' of `derivatives'
					qui replace `dc' = cond(`tr', ///
						`dps1'*`x',0) `if'
					if `ohetprobit' {
						local dc : word `++jdh' of ///
							`derivatives'
						qui replace `dc' = ///
							cond(`tr', ///
							`dpsh'*`x',0) `if'
					}
				}
			}
			if `pshetprobit' {
				forvalues k=1/`k_pshv' {
					local d : word `++jh' of `derivatives'
					local x : word `k' of `pshvars'
					qui replace `d' = `x'*`dch' `if'

					local d : word `++jhp' of `derivatives'
					qui replace `d' = -`x'*`dch'/`psxb' ///
						`if'
					if `wnls' {
						local d : word `++jdph' of ///
							`derivatives'
						local x : word `k' of `pshvars'
						qui replace `d' = cond(`tr', ///
							`dpph'*`x',0) `if'

						local d : word `++jdhh' of ///
							`derivatives'
						if `ohetprobit' {
							qui replace `d' =   ///
								cond(`tr',  ///
								`dphh'*`x', ///
								0) `if'
						}
					}
				}
			}
		}
		local jps = `jps'+`ips'+`k_pshv'
	}
end
	
exit
