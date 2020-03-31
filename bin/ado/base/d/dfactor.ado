*! version 1.2.3  06mar2019

program define dfactor, eclass byable(onecall)
	local vv : display "version " _caller() ":"
	version 11

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	if replay() {
		if ("`e(cmd)'"!="dfactor") error 301
		
		Replay `0'
		exit
	}
	`vv' ///
	cap noi `BY' Estimate mnames : `0'
	local rc = c(rc)

	/* clean up Mata matrices with tempnames			*/
	foreach m of local mnames {
		cap mata: mata drop `m'
	}
	cap
	exit `rc'
end

program Estimate, eclass byable(recall) sortpreserve
	local version = string(_caller())
	local vv "version `version':"
	version 11

	gettoken _mnames 0 : 0, parse(":")
	gettoken colon 0 : 0, parse(":")

	syntax anything(id="equations") [if] [in],	///
		[			///
		CONSTraints(numlist)	///
		from(string)		///
		METHod(string)		///
		seed(string)		///
		*]

	/* undocumented: seed(string), seed for 10 random initial	*/
	/*  estimates							*/
	qui tsset, noquery
	local cmdline `"dfactor `:list retokenize 0'"'

	_parse_optimize_options, `options'
	local mlopt `s(mlopts)'

	_get_diopts diopts rest, `s(rest)'
	if "`rest'" != "" {
		local wc: word count `s(rest)'
		di as err `"{p} `=plural(`wc',"option")' {bf:`s(rest)'} "' ///
			`"`=plural(`wc',"is","are")' not allowed{p_end}"'
		exit(198)
	}
	ParseMethod, `method'
	local method `s(method)'
	local initopt ("dfactor","`method'","","","`seed'")

	_parse expand cmd op : 0
	if `cmd_n' == 1  {
		local nofactors nofactors
	}
	else if `cmd_n' != 2  {
		di as err "more than two equations specified"
		di as err "{p}You may have omitted the comma separating " ///
		 "the equations and the options.{p_end}"		
		exit 198
	}
	if ("`constraints'" != "") local constr constraints

	marksample touse
	local tmp : subinstr local cmd_1 "," ",", all count(local nc)
	/* parsing state						*/
	if mod(`nc',2) {
		/* options						*/
		local cmd_1 `"`cmd_1' observables `constr' touse(`touse')"'
	}
	else {
		/* equations						*/
		local cmd_1 `"`cmd_1', observables `constr' touse(`touse')"'
	}	

	Eqs_parse `cmd_1' 

	local obs_depvars 	`r(depvars)'
	local obs_indeps  	`r(fvindeps)'
	local obs_arlist  	`r(arlist)'
	local obs_arstructure	`r(arstructure)'
	local obs_covstructure	`r(covstructure)'
	local obs_type		`r(type)'
	local obs_constant      `r(constant)'
	local indeps		`r(indeps)'

	if "`nofactors'" == "" {
		local tmp : subinstr local cmd_2 "," ",", all count(local nc)
		/* parsing state: options or variables			*/
		if (mod(`nc',2)) local cmd_2 `"`cmd_2' touse(`touse')"'
		else local cmd_2 `"`cmd_2', touse(`touse')"'

		Eqs_parse `cmd_2' 

		local fac_depvars 	`r(depvars)'
		local fac_indeps  	`r(fvindeps)'
		local fac_arlist  	`r(arlist)'
		local fac_arstructure	`r(arstructure)'
		local fac_covstructure	`r(covstructure)'
		local fac_type		`r(type)'
		local indeps		`indeps' `r(indeps)'
		local indeps : list uniq indeps
					/* compute sizer parameters 
					 * nf, p, q, k, nw, and nx 
					 */
		local nf : word count `fac_depvars'			
		local np : word count `fac_arlist'
		if `np'>0 {
			local p  : word `np' of `fac_arlist'
		}
		else {
			local p = 0 
		}
		local pm1 = `p' - 1
	}
	else {
		local nf = 0
		local np = 0
		local  p = 0
	}

	local nq : word count `obs_arlist'
	if `nq'>0 {
		local q  : word `nq' of `obs_arlist'
	}
	else {
		local q = 0 
	}
	local qm1 = `q' - 1

	if "`obs_constant'" == "" {
		tempvar cons
		qui gen double `cons' = 1
		local obs_indeps `obs_indeps' `cons'
	}

	local k  : word count `obs_depvars'
	local nw : word count `fac_indeps'
	local nx : word count `obs_indeps'
	local all_indeps `fac_indeps' `obs_indeps'
	local all_indeps : list uniq all_indeps
	local nwx : word count `all_indeps'
				
				/* identify error cases */
	if `nf' >= `k' {
		di as error "{p}number of factors is greater than or " ///
			"equal the number of observable variables{p_end}"
		exit 498
	}
				// handle six special cases here 

	if (`nf'>0 & `np'>0 & `nq'>0) {
		local mcase DFAR
	}
	else if (`nf'>0 & `np'==0 & `nq'>0) {
		local mcase SFAR
	}
	else if (`nf'==0 & `np'==0 & `nq'>0) {
		local mcase VAR
	}
	else if (`nf'>0 & `np'>0 & `nq'==0) {
		local mcase DF
	}
	else if (`nf'>0 & `np'==0 & `nq'==0) {
		local mcase SF
	}
	else if (`nf'==0 & `np'==0 & `nq'==0) {
		local mcase SUR
	}
	else {
		local mcase NOTYET
		di as err "invalid model specification"
		exit 498
	}
	tempname Amat Bmat Cmat Dmat Fmat Gmat Qmat Rmat Gamma 
	tempname Q1mat Q2mat Qinfo 
	local mlist `Amat' `Bmat' `Cmat' `Dmat' `Fmat' `Gmat' `Qmat'
	local mlist `mlist' `Rmat' `Gamma' `Q1mat' `Q2mat' `Qinfo'
	c_local `_mnames' `mlist'
	/* Qinfo (case={0,1}, Q/Q1 structure, dim(Q/Q1), 		*/
	/* 		R/Q2 structure,	 dim(R/Q2), p, q)		*/
	/* case=0 -> standard Q and R (applies to all -sspace- models)	*/
	/*      1 -> Q with Q1 and Q2 on diagonal (see -dfactor-)	*/
	/* Q?/R structure = 0->identity, 1->dscalar, 2->diagonal, 	*/
	/* 		3->unstructured					*/
	/* p = factor autocorrelation parameter				*/
	/* q = observable autocorrelation parameter			*/

	if "`mcase'" == "DFAR" {
		foreach fvar of local fac_depvars {
			tempvar fac_`fvar'
			qui generate double `fac_`fvar'' =.
			local seq_names `seq_names' `fac_`fvar''
		}

		forvalues i=1/`pm1' {
			foreach fvar of local fac_depvars {
				tempvar L`i'_fac_`fvar'
				qui generate double `L`i'_fac_`fvar'' =.
				local seq_names `seq_names' `L`i'_fac_`fvar''
			}
		}

		local tsdepvars : subinstr local obs_depvars "." "_", all
		foreach ovar of local tsdepvars {
			tempvar e_`ovar'
			qui gen double `e_`ovar''=.
			local obs_evars `obs_evars' `e_`ovar''
			local seq_names `seq_names' `e_`ovar''
		}

		forvalues i=1/`qm1' {
			foreach e_ovar of local obs_evars {
				tempvar L`i'_`e_ovar'
				qui generate double `L`i'_`e_ovar'' =.
				local seq_names `seq_names' `L`i'_`e_ovar'' 
			}
		}
		/* state space A matrix contains dfactor A and C 	*/
		/*  matrices						*/

						// dfactor A matrix 
		local fp = `nf'*`p'
		local op = `k'*`q'
		local k_state = `fp'+`op'
		local k_obser = `k'
		local k_state_err = `k' + `nf'
		local k_obser_err = 0

		mata: `Amat' = J(`k_state', `k_state', 0)
		if `p'>1 {
			mata: `Amat'[|`nf'+1,1 \ `fp',`fp'-`nf'|] = I(`fp'-`nf')
		}
		if `q'>1 {
			mata: `Amat'[|`fp'+1+`k',`fp'+1 \ 	///
				`k_state',`k_state'-`k'|]= I(`op'-`k')
		}
	
		A_details, fac_arstructure(`fac_arstructure')	///
			nf(`nf') np(`np') 			///
			fac_arlist(`fac_arlist') 		///
			fac_depvars(`fac_depvars')

		matrix `Gamma' = r(Gamma)
		local dnames `r(dnames)'
						// dfactor C matrix 

		C_details, obs_arstructure(`obs_arstructure')	///
			zrow(`fp') zcol(`fp')			///
			k(`k') nq(`nq') 			///
			obs_arlist(`obs_arlist') 		///
			obs_depvars(`obs_depvars')

		matrix `Gamma' = `Gamma', r(Gamma)
		local dnames `dnames' `r(dnames)'

		mata: `Cmat' = J(`k_state', `k_state_err', 0)
		mata: `Cmat'[|1,1 \ `nf',`nf'|] = I(`nf')
		mata: `Cmat'[|`fp'+1,`nf'+1 \ `fp'+`k',`nf'+`k'|] ///
			= I(`k')
						// B matrix 
		if `nw'>0 {
			BF_details , code(2) 	///
			depvars(`fac_depvars')	///
			indeps(`fac_indeps')	///
			all_indeps(`all_indeps') cons(`cons')
	
			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(dnames)'
			mata: `Bmat' = J(`fp'+`op',`nwx',0)
		}
		else {
			mata: `Bmat' = J(0,0,.)
		}
						// D matrix
		mata: `Dmat' = J(`k', `k_state', 0)			
		mata: `Dmat'[|1,`nf'*`p'+1 \ `k',`nf'*`p'+`k'|] = I(`k')

		D_details , obs_depvars(`obs_depvars')	///
			     fac_depvars(`fac_depvars') ///

		matrix `Gamma' = `Gamma', r(Gamma)
		local dnames `dnames' `r(dnames)'

						// F matrix 
		if `nx'>0 {
			BF_details , code(5)		///
				depvars(`obs_depvars')	///
				indeps(`obs_indeps')	///
				all_indeps(`all_indeps') cons(`cons')

			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(dnames)'

			mata: `Fmat' = J(`k',`nwx',0)
		}
		else {
			mata: `Fmat' = J(0,0,.)
		}
		// Q1 & Q2 at identity
		mata: `Qinfo' = (1, 0, `nf', 0, `k', `p', `q')

						// Q1
		`vv' ///
		Qi_details , dim(`nf') 				///
			covstructure(`fac_covstructure')	///
			depvars(`fac_depvars') qinfo(`Qinfo')

		mata: `Q1mat' = st_matrix("r(Qimat)")
		local veqs `"`veqs' `r(veqs)'"'

		if "`fac_covstructure'"!="identity" {
			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(qnames)'
		}	
						// Q2
		`vv' ///
		Qi_details , dim(`k') 				///
			covstructure(`obs_covstructure')	///
			depvars(`obs_depvars') qinfo(`Qinfo')	///
			observable

		mata: `Q2mat' = st_matrix("r(Qimat)")
		local veqs `"`veqs' `r(veqs)'"'

		if "`obs_covstructure'"!="identity" {
			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(qnames)'
		}	
			
		mata: `Gmat'=`Qmat'=`Rmat'=J(0,0,.)

		local ssvec (&`Amat',&`Bmat',&`Cmat',&`Dmat',&`Fmat',&`Gmat'
		local ssvec `ssvec',&`Q1mat',&`Q2mat',&`Qinfo')
	}
	else if "`mcase'" == "SFAR" {
		local seq_names
		foreach fvar of local fac_depvars {
			tempvar fac_`fvar'
			qui generate double `fac_`fvar'' =.
			local seq_names `seq_names' `fac_`fvar''
		}

		local tsdepvars : subinstr local obs_depvars "." "_", all
		foreach ovar of local tsdepvars {
			tempvar e_`ovar'
			qui gen double `e_`ovar''=.
			local obs_evars `obs_evars' `e_`ovar''
			local seq_names `seq_names' `e_`ovar''
		}

		forvalues i=1/`qm1' {
			foreach e_ovar of local obs_evars {
				tempvar L`i'_`e_ovar'
				qui generate double `L`i'_`e_ovar'' =.
				local seq_names `seq_names' `L`i'_`e_ovar'' 
			}
		}
						// A matrix 
		local op = `k'*`q'
		local k_state = `nf'+`k'*`q'
		local k_obser = `k'
		local k_state_err = `k' + `nf'
		local k_obser_err = 0
		mata: `Amat' = J(`k_state', `k_state', 0)
		if (`q'>1) {
			mata: `Amat'[|`nf'+`k'+1,`nf'+1 \ 		///
				`nf'+`k'*`q',`nf'+`k'*(`q'-1)|] = 	///
				I(`k'*(`q'-1))
		}
						// A.C matrix
		C_details, obs_arstructure(`obs_arstructure')	///
			zrow(`nf') zcol(`nf')			///
			k(`k') nq(`nq') 			///
			obs_arlist(`obs_arlist') 		///
			obs_depvars(`obs_depvars')

		matrix `Gamma' = r(Gamma)
		local dnames `r(dnames)'
						// B matrix 
		if `nw'>0 {
			BF_details , code(2) 		///
				depvars(`fac_depvars')	///
				indeps(`fac_indeps')	///
				all_indeps(`all_indeps') cons(`cons')

			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(dnames)'
			mata: `Bmat' = J(`k_state',`nwx',0)
		}
		else {
			mata: `Bmat' = J(0,0,.)
		}
						// C matrix

		mata: `Cmat' = J(`k_state', `k_state_err', 0)
		mata: `Cmat'[|1,1 \ `nf',`nf'|] = I(`nf')
		mata: `Cmat'[|`nf'+1,`nf'+1 \ `nf'+`k',`nf'+`k'|] ///
			= I(`k')
						// D matrix

		mata: `Dmat' = J(`k', `k_state', 0)			
		mata: `Dmat'[|1,`nf'+1 \ `k',`nf'+`k'|] = I(`k')
		D_details , obs_depvars(`obs_depvars')	///
			     fac_depvars(`fac_depvars') ///

		matrix `Gamma' = `Gamma', r(Gamma)
		local dnames `dnames' `r(dnames)'

						// F matrix 
		if `nx'>0 {
			BF_details , code(5) 		///
				depvars(`obs_depvars')	///
				indeps(`obs_indeps')	///
				all_indeps(`all_indeps') cons(`cons')
	
			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(dnames)'
			mata: `Fmat' = J(`k',`nwx',0)
		}
		else {
			mata: `Fmat' = J(0,0,.)
		}

		// Q1 & Q2 at identity
		mata: `Qinfo' = (1, 0, `nf', 0, `k', 0, `q')
						// Q1
		`vv' ///
		Qi_details , dim(`nf') 				///
			covstructure(`fac_covstructure')	///
			depvars(`fac_depvars') qinfo(`Qinfo')

		mata: `Q1mat' = st_matrix("r(Qimat)")
		local veqs `"`veqs' `r(veqs)'"'

		if "`fac_covstructure'"!="identity" {
			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(qnames)'
		}		
						// Q2
		`vv' ///
		Qi_details , dim(`k') 				///
			covstructure(`obs_covstructure')	///
			depvars(`obs_depvars') qinfo(`Qinfo')	///
			observable

		mata: `Q2mat' = st_matrix("r(Qimat)")
		local veqs `"`veqs' `r(veqs)'"'

		if "`obs_covstructure'"!="identity" {
			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(qnames)'
		}	
		mata: `Gmat'=`Qmat'=`Rmat'=J(0,0,.)

		local ssvec (&`Amat',&`Bmat',&`Cmat',&`Dmat',&`Fmat',&`Gmat'
		local ssvec `ssvec',&`Q1mat',&`Q2mat',&`Qinfo')
	}
	else if "`mcase'" == "VAR" {
		local seq_names 
		local tsdepvars : subinstr local obs_depvars "." "_", all
		foreach ovar of local tsdepvars {
			tempvar e_`ovar'
			qui gen double `e_`ovar''=.
			local obs_evars `obs_evars' `e_`ovar''
			local seq_names `seq_names' `e_`ovar''
		}

		forvalues i=1/`qm1' {
			foreach e_ovar of local obs_evars {
				tempvar L`i'_`e_ovar'
				qui generate double `L`i'_`e_ovar'' =.
				local seq_names `seq_names' `L`i'_`e_ovar'' 
			}
		}
		local k_state = `k'*`q'
		local k_obser = `k'
		local k_state_err = `k'
		local k_obser_err = 0
						// A matrix 
		mata: `Amat' = J(`k_state', `k_state', 0)
		if `q'>1 {
			mata: `Amat'[|`k'+1,1 \ `k'*`q',`k'*(`q'-1)|] = ///
				I(`k'*(`q'-1))
		}

		C_details, obs_arstructure(`obs_arstructure')	///
			zrow(0) zcol(0)				///
			k(`k') nq(`nq') 			///
			obs_arlist(`obs_arlist') 		///
			obs_depvars(`obs_depvars')

		matrix `Gamma' = r(Gamma)
		local dnames `r(dnames)'
						// B matrix 
		local obs_evars
		foreach var of local obs_depvars {
			_ms_parse_parts e.`var'
			local obs_evars `obs_evars' `r(op)'.`var'
		}

		if `nw'>0 {
			BF_details , code(2) 		///
				depvars(`fac_depvars')	///
				indeps(`fac_indeps')	///
				all_indeps(`all_indeps') cons(`cons')

			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(dnames)'
			mata: `Bmat' = J(`k_state',`nwx',0)
		}
		else {
			mata: `Bmat' = J(0,0,.)
		}
						// C matrix

		mata: `Cmat' = J(`k_state', `k', 0)
		mata: `Cmat'[|1,1 \ `k',`k'|] = I(`k')

						// D matrix
		mata: `Dmat' = I(`k'), J(`k', `k'*(`q'-1), 0)			
		
						// F matrix 
		if `nx'>0 {
			BF_details , code(5) 		///
				depvars(`obs_depvars')	///
				indeps(`obs_indeps')	///
				all_indeps(`all_indeps') cons(`cons')

			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(dnames)'
			mata: `Fmat' = J(`k',`nwx',0)
		}
		else {
			mata: `Fmat' = J(0,0,.)
		}

   		/* Use Q and R, not Q1 Q2				*/
		mata: `Qinfo' = (0, 0, `k', 0, 0, 0, 0)

						// Q matrix & Cov(e)
		`vv' ///
		Qi_details , dim(`k') 				///
			covstructure(`obs_covstructure')	///
			depvars(`obs_depvars') qinfo(`Qinfo')	///
			fobservable

		mata: `Qmat' = st_matrix("r(Qimat)")
		local Q_structure `obs_covstructure'
		local veqs `"`veqs' `r(veqs)'"'

		if "`fac_covstructure'"!="identity" {
			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(qnames)'
		}	
						// R matrix is NULL
		mata: `Rmat' = J(0,0,.)
		mata: `Gmat'=`Q1mat'=`Q2mat'=J(0,0,.)

		local ssvec (&`Amat',&`Bmat',&`Cmat',&`Dmat',&`Fmat',&`Gmat'
		local ssvec `ssvec',&`Qmat',&`Rmat',&`Qinfo')
	}
	else if "`mcase'" == "DF" {
		local seq_names
		foreach fvar of local fac_depvars {
			tempvar fac_`fvar'
			qui generate double `fac_`fvar'' =.
			local seq_names `seq_names' `fac_`fvar''
		}

		forvalues i=1/`pm1' {
			foreach fvar of local fac_depvars {
				tempvar L`i'_fac_`fvar'
				qui generate double `L`i'_fac_`fvar'' =.
				local seq_names `seq_names' `L`i'_fac_`fvar''
			}
		}

		local fp = `nf'*`p'
		local k_state = `fp'
		local k_obser = `k'
		local k_state_err = `nf'
		local k_obser_err = `k'
						// A matrix 
		mata: `Amat' = J(`fp', `fp', 0)
		if `p'>1 {
			mata: `Amat'[|`nf'+1,1 \ `fp',`fp'-`nf'|] = I(`fp'-`nf')
		}
	
		A_details, fac_arstructure(`fac_arstructure')	///
			nf(`nf') np(`np') 			///
			fac_arlist(`fac_arlist') 		///
			fac_depvars(`fac_depvars')

		matrix `Gamma' = r(Gamma)
		local dnames `r(dnames)'
						// B matrix 
		if `nw'>0 {
			BF_details , code(2) 		///
				depvars(`fac_depvars')	///
				indeps(`fac_indeps')	///
				all_indeps(`all_indeps') cons(`cons')

			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(dnames)'
			mata: `Bmat' = J(`nf'*`p',`nwx',0)
		}
		else {
			mata: `Bmat' = J(0,0,.)
		}
						// C matrix & Cov(nu \ e)
		mata: `Cmat' = J(`nf'*`p', `nf', 0)
		mata: `Cmat'[|1,1 \ `nf',`nf'|] = I(`nf')

						// D matrix
		mata: `Dmat' = J(`k', `nf'*`p', 0)			

		D_details , obs_depvars(`obs_depvars')	///
			     fac_depvars(`fac_depvars') ///

		matrix `Gamma' = `Gamma', r(Gamma)
		local dnames `dnames' `r(dnames)'
						// F matrix 
		if `nx'>0 {
			BF_details , code(5) 		///
				depvars(`obs_depvars')	///
				indeps(`obs_indeps')	///
				all_indeps(`all_indeps') cons(`cons')

			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(dnames)'
			mata: `Fmat' = J(`k',`nwx',0)
		}
		else {
			mata: `Fmat' = J(0,0,.)
		}
   		/* Use Q and R, not Q1 Q2				*/
		mata: `Qinfo' = (0, 0, `nf', 0, `k', 0, 0)

						// Q matrix
		`vv' ///
		Qi_details , dim(`nf') 			///
			covstructure(`fac_covstructure')	///
			depvars(`fac_depvars') qinfo(`Qinfo')	

		mata: `Qmat' = st_matrix("r(Qimat)")
		local veqs `"`veqs' `r(veqs)'"'
		local Q_structure `fac_covstructure'

		if "`fac_covstructure'"!="identity" {
			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(qnames)'
		}	
						// R matrix
		`vv' ///
		Qi_details , dim(`k') 				///
			covstructure(`obs_covstructure')	///
			depvars(`obs_depvars') qinfo(`Qinfo')	///
			observable 

		mata: `Rmat' = st_matrix("r(Qimat)")
		local veqs `"`veqs' `r(veqs)'"'
		local R_structure `obs_covstructure'
		mata: `Gmat' = J(0,0,.)

		if "`obs_covstructure'"!="identity" {
			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(qnames)'
		}	
			
		mata: `Q1mat'=`Q2mat'=J(0,0,.)

		local ssvec (&`Amat',&`Bmat',&`Cmat',&`Dmat',&`Fmat',&`Gmat'
		local ssvec `ssvec',&`Qmat',&`Rmat',&`Qinfo')
	}
	else if "`mcase'" == "SF" {
		local seq_names
		foreach fvar of local fac_depvars {
			tempvar fac_`fvar'
			qui generate double `fac_`fvar'' =.
			local seq_names `seq_names' `fac_`fvar''
		}

		local k_state = `nf'
		local k_obser = `k'
		local k_state_err = `nf'
		local k_obser_err = `k'
						// A matrix
		mata: `Amat' = J(`nf', `nf', 0)
						// B matrix 
		if `nw'>0 {
			BF_details , code(2) 		///
				depvars(`fac_depvars')	///
				indeps(`fac_indeps')	///
				all_indeps(`all_indeps') cons(`cons')
	
			matrix `Gamma' = r(Gamma)
			local dnames `r(dnames)'
			mata: `Bmat' = J(`nf',`nwx',0)
		}
		else {
			mata: `Bmat' = J(0,0,.)
		}
						// C matrix is I(nf)
						// ignored if NULL
		mata: `Cmat' = J(0,0,.)
						// D matrix

		mata: `Dmat' = J(`k', `nf', 0)			

		D_details , obs_depvars(`obs_depvars')	///
			     fac_depvars(`fac_depvars') ///

		matrix `Gamma' = nullmat(`Gamma'), r(Gamma)
		local dnames `dnames' `r(dnames)'

						// F matrix 
		if `nx'>0 {
			BF_details , code(5) 		///
				depvars(`obs_depvars')	///
				indeps(`obs_indeps')	///
				all_indeps(`all_indeps') cons(`cons')

			matrix `Gamma' = nullmat(`Gamma'), r(Gamma)
			local dnames `dnames' `r(dnames)'
			mata: `Fmat' = J(`k',`nwx',0)
		}
		else {
			mata: `Fmat' = J(0,0,.)
		}

   		/* Use Q and R, not Q1 Q2				*/
		mata: `Qinfo' = (0, 0, `nf', 0, `k', 0, 0)

						// Q matrix
		`vv' ///
		Qi_details , dim(`nf') 			///
			covstructure(`fac_covstructure')	///
			depvars(`fac_depvars') qinfo(`Qinfo')

		mata: `Qmat' = st_matrix("r(Qimat)")
		local veqs `"`veqs' `r(veqs)'"'
		local Q_structure `fac_covstructure'

		if "`fac_covstructure'"!="identity" {
			capture confirm matrix `Gamma'
			local rc = _rc
			if `rc' {
				matrix `Gamma' = r(Gamma)
			}
			else {
				matrix `Gamma' = `Gamma', r(Gamma)
			}	
			local dnames `dnames' `r(qnames)'
		}	
						// R matrix
		`vv' ///
		Qi_details , dim(`k') 				///
			covstructure(`obs_covstructure')	///
			depvars(`obs_depvars') qinfo(`Qinfo')	///
			observable

		mata: `Rmat' = st_matrix("r(Qimat)")
		local veqs `"`veqs' `r(veqs)'"'
		local R_structure `obs_covstructure'
		mata: `Gmat' = J(0,0,.)

		if "`obs_covstructure'"!="identity" {
			matrix `Gamma' = `Gamma', r(Gamma)
			local dnames `dnames' `r(qnames)'
		}	
		mata: `Q1mat'=`Q2mat'=J(0,0,.)

		local ssvec (&`Amat',&`Bmat',&`Cmat',&`Dmat',&`Fmat',&`Gmat'
		local ssvec `ssvec',&`Qmat',&`Rmat',&`Qinfo')
	}
	else if "`mcase'" == "SUR" {
		local seq_names
		foreach fvar of local fac_depvars {
			tempvar fac_`fvar'
			qui generate double `fac_`fvar'' =.
			local seq_names `seq_names' `fac_`fvar''
		}
		local k_state = `k'
		local k_obser = `k'
		local k_state_err = `k'
		local k_obser_err = 0
						// A matrix, must exist 
		mata: `Amat' = J(`k', `k', 0)

						// B matrix is null
		mata: `Bmat' = J(0,0,.)
						// C matrix is I(k)
						// ignored if NULL
		mata: `Cmat' = J(0,0,.)
						// D matrix, must exist
		mata: `Dmat' = I(`k')
						// F matrix 
		if `nx'>0 {
			BF_details , code(5) 		///
				depvars(`obs_depvars')	///
				indeps(`obs_indeps')	///
				all_indeps(`all_indeps') cons(`cons')

			matrix `Gamma' = nullmat(`Gamma'), r(Gamma)
			local dnames `dnames' `r(dnames)'
			mata: `Fmat' = J(`k',`nwx',0)
		}
		else {
			mata: `Fmat' = J(0,0,.)
		}

		/* Use Q and R, not Q1 Q2				*/
		mata: `Qinfo' = (0, 0, `k', 0, 0, 0, 0)   

						// Q matrix
		`vv' ///
		Qi_details , dim(`k') 				///
			covstructure(`obs_covstructure')	///
			depvars(`obs_depvars') qinfo(`Qinfo')	///
			fobservable

		mata: `Qmat' = st_matrix("r(Qimat)")
		local veqs `"`veqs' `r(veqs)'"'
		local Q_structure `obs_covstructure'

		if "`obs_covstructure'"!="identity" {
			matrix `Gamma' = nullmat(`Gamma'), r(Gamma)
			local dnames `dnames' `r(qnames)'
		}	
						// R matrix is NULL
		mata: `Rmat' = J(0,0,.)
		mata: `Gmat'=`Q1mat'=`Q2mat'=J(0,0,.)

		local ssvec (&`Amat',&`Bmat',&`Cmat',&`Dmat',&`Fmat',&`Gmat'
		local ssvec `ssvec',&`Qmat',&`Rmat',&`Qinfo')
	}
	else {
		di as err "invalid model specified"
		exit 498
	}
	`vv' ///
	mat colnames `Gamma' = `dnames'
	`vv' ///
	mat rownames `Gamma' = mcode row col

	_sspace_equation_order, gamma(`Gamma') state_deps(`fac_depvars') ///
		obser_deps(`obser_depvars')
	mat `Gamma' = r(gamma)
	local dnames : colfullnames `Gamma'

	tempname b V
	mat `b' = J(1,colsof(`Gamma'),1)
	`vv' ///
	matrix colnames `b' = `dnames'
	matrix rownames `b' = sspace

	matrix `V' = `b''*`b'
	`vv' ///
	matrix colnames `V' = `dnames'
	`vv' ///
	matrix rownames `V' =  `dnames'
	ereturn post `b' `V'

	`vv' ///
	makecns `constraints' 
	local k_autoCns = r(k_autoCns)
	local ncns = 0
	if "`constraints'"!="" | `k_autoCns' {
		tempname T a Cm
		cap matcproc `T' `a' `Cm'
		if c(rc) != 0 {
			/* all constraints were dropped in makecns	*/
			local Cm
			local T
			local a
		}
		else local ncns = rowsof(`Cm')
	}
	local csropt ("`Cm'","`T'","`a'")

	_ts tvar panvar if `touse', sort onepanel
	markout `touse' `obs_depvars' `all_indeps' `tvar'

	local nest = colsof(`Gamma')-`ncns'

	qui count if `touse'
	local N = r(N)
	if (`N'==0) error 2000
	if (`N'<=`nest') error 2001
	if `N' < 10*`nest' {
		di as txt "{p}note: attempting to estimate `nest' " ///
		 "parameters using `N' observations{p_end}"
	}

	_check_ts_gaps `tvar', touse(`touse')

	tempname tmin tmax
	summarize `tvar' if `touse', meanonly
	scalar `tmax' = r(max)
	scalar `tmin' = r(min)
	local fmt : format `tvar'
	local tmins = trim(string(r(min), "`fmt'"))
	local tmaxs = trim(string(r(max), "`fmt'"))

	/* do not call any rclass functions from here to _sspace_epost	*/ 
	mata: _sspace_entry(`ssvec', "`Gamma'", "`from'", `csropt', ///
		`mlopt', `initopt', "`touse'", `"`obs_depvars'"',   ///
		`"`all_indeps'"')

	mat `b' = r(b)
	mat `V' = r(V)

	if "`obs_constant'" == "" {
		`vv' ///
		mat colnames `b' = `dnames'
		local ceqs    : coleq    `b'
		local cnames  : colnames `b'
		local cnames : subinstr local cnames "`cons'" "_cons", all word

		local dnames 
		
		local n_names : word count `cnames'
		local n_eqsb  : word count `ceqs'
		if `n_names' != `n_eqsb' {
			di as err "parameter names invalid"
			exit 498
		}
		forvalues ip = 1/`n_names' {
			local eqnme : word `ip' of `ceqs'
			local nme   : word `ip' of `cnames'
			local dnames `dnames' `eqnme':`nme'
		}
	}

	`vv' ///
	mat colnames `b' = `dnames'
	mat rownames `b' = dfactor
	local eqs : coleq `b'
	local eqs : list uniq eqs
	local kb = colsof(`b')

	`vv' ///
	mat rownames `V' = `dnames'
	`vv' ///
	mat colnames `V' = `dnames'
	
	ereturn post `b' `V' `Cm', obs(`=r(N)') esample(`touse') buildfvinfo

	if "`cons'" != "" {
		local all_indeps : subinstr local all_indeps "`cons'" "_cons"
	}

	_sspace_epost, obser_deps(`obs_depvars') indeps(`all_indeps') ///
		k_state_err(`k_state_err') k_obser_err(`k_obser_err') ///
		method(`method') dnames(`dnames') hidden

	tempname bp 
	_b_pclass PCDEF : default
	_b_pclass PCVAR : VAR
	mat `bp' = J(1,`kb',`PCDEF')
	forvalues i=1/`kb' {
		if `Gamma'[1,`i']==7 | `Gamma'[1,`i']==8 {
			if `Gamma'[2,`i'] == `Gamma'[3,`i'] {
				mat `bp'[1,`i'] = `PCVAR'
			}
		}
	}
	`vv' ///
	mat colnames `bp' = `dnames'
	ereturn hidden matrix b_pclass = `bp'

	ereturn hidden scalar version = cond(`version'<16,1,2)

	/* k_eq is the # equation names in e(b), used by -_coef_table-,	*/
	/* and is _not_ k_obser + k_state				*/
	local keq : list sizeof eqs
	ereturn scalar k_eq = `keq'

	if `version' < 16 {
		ereturn scalar k_aux = `:list sizeof veqs'
	}
	else {
		ereturn hidden scalar k_var = `:list sizeof veqs'
	}
	ereturn scalar k_eq_model = `keq'
	local weqs : list eqs - veqs
	local df_m = 0
	if "`all_indeps'" != "_cons" {
		foreach eq of local weqs {
			qui test [`eq'], `accum'
			local df_m = r(df)
			local accum accum
		}
		ereturn scalar p = r(p)
	}
	ereturn scalar df_m = `df_m'
	ereturn scalar chi2 = r(chi2)
	ereturn local chi2type Wald

	fvrevar `obs_depvars', list
	local depvar `r(varlist)'
	local sample `depvar' `indeps' `tvar'
	local sample : list uniq sample
	signestimationsample `sample'

	ereturn hidden matrix gamma = `Gamma'
	ereturn scalar k_factor = `nf'
	ereturn scalar k_obser = `k_obser'
	ereturn hidden scalar k_state = `k_state'
	ereturn hidden scalar k_state_err = `k_state_err'
	ereturn hidden scalar k_obser_err = `k_obser_err'
	/* number of estimated parameters				*/
	ereturn scalar k = `kb'
	ereturn local eqnames `eqs'
	if ("`k_autoCns'"!="") ereturn hidden scalar k_autoCns = `k_autoCns'	

	ereturn scalar tmax = `tmax'
	ereturn scalar tmin = `tmin'
	ereturn local tmins `tmins'
	ereturn local tmaxs `tmaxs'

	ereturn local depvar `depvar'
	ereturn local tvar `tvar'
	/* observed dependent variables with TS operators		*/
	ereturn local obser_deps `obs_depvars'
	/* factor latent variables for postestimation labeling		*/ 
	ereturn local factor_deps `fac_depvars'
	if "`cons'" != "" {
		local all_indeps : subinstr local all_indeps "`cons'" "_cons"
	}
	ereturn scalar k_dv = `:word count `depvar''
	ereturn local model `mcase'
	ereturn scalar f_ar_max = `p'
	ereturn scalar o_ar_max = `q'
	if (`p') ereturn local f_ar "ar(`fac_arlist')"
	if (`q') ereturn local o_ar "ar(`obs_arlist')"

	ereturn local factor_cov `fac_covstructure'
	ereturn local observ_cov `obs_covstructure'

	/* -margins- are not allowed					*/
	ereturn local marginsok 
	ereturn local marginsnotok _ALL
	/* observed indep vars with TS operators & expanded factors	*/
	if `:length local all_indeps' {
		ereturn local covariates `all_indeps'
	}
	else {
		ereturn local covariates _NONE
	}

	ereturn local predict dfactor_p
	ereturn local estat_cmd dfactor_estat
	ereturn local cmdline `"`cmdline'"'
	ereturn local title "Dynamic-factor model"
	ereturn local cmd dfactor


	Replay, `diopts'
end

program define Replay
	version 11
	syntax, [ * ] 

	_get_diopts diopts, `options'

	local ever = cond(missing(e(version)),1,e(version))

	if (e(df_m)==0) _coef_table_header, nomodeltest
	else _coef_table_header

	_coef_table, `diopts'

	if !e(stationary) di as txt "Note: Model is not stationary."

	local kvar = cond(`ever'==1,e(k_aux),e(k_var))
	if `kvar' {
		di as smcl "{p 0 6 0 79}" ///
		 "Note: Tests of variances against zero " ///
		 "are one sided, and the two-sided confidence intervals "  ///
		 "are truncated at zero.{p_end}"
	}
	if !e(converged) di as smcl "Note: Convergence not achieved."
end

program define A_details, rclass
	version 11
	syntax , 				///
		fac_arstructure(string)		///
		nf(integer)			///
		np(integer)			///
		fac_arlist(numlist)		///
		fac_depvars(string)

	tempname gamma	

	if "`fac_arstructure'" == "diagonal" {
		matrix `gamma' = J(3, `nf'*`np', 0)
		local cnt = 1
		foreach i of local fac_arlist {
			forvalues j=1/`nf' {
				local fvar : word `j' of `fac_depvars'
				local dnames `dnames' `fvar':L`i'.`fvar'
				matrix `gamma'[1,`cnt'] = 1
				matrix `gamma'[2,`cnt'] = `j'
				matrix `gamma'[3,`cnt'] = (`i'-1)*`nf' + `j'
				local ++cnt	
			}
		}
	}
	else if "`fac_arstructure'" == "ltriangular" {
		matrix `gamma' = J(3, .5*`nf'*(`nf'+1)*`np', 0)
		local cnt = 1
		foreach i of local fac_arlist {
			forvalues j1=1/`nf' {		// row Ai
				local fvar1 : word `j1' of `fac_depvars'
				forvalues j2=1/`j1' {	// col Ai
					local fvar2 : word `j2' of `fac_depvars'
					local tmp `fvar1':L`i'
					local dnames `dnames' `tmp'.`fvar2'
					matrix `gamma'[1,`cnt'] = 1
					matrix `gamma'[2,`cnt'] = `j1'
					matrix `gamma'[3,`cnt'] = (`i'-1)* ///
						`nf' + `j2'
					local ++cnt	
				}
			}
		}
	}
	else if "`fac_arstructure'" == "general" {
		matrix `gamma' = J(3, `nf'*`nf'*`np', 0)
		local cnt = 1
		foreach i of local fac_arlist {
			forvalues j1=1/`nf' {		// row Ai
				local fvar1 : word `j1' of `fac_depvars'
				forvalues j2=1/`nf' {	// col Ai
					local fvar2 : word `j2' of `fac_depvars'
					local tmp  `fvar1':L`i'
					local dnames `dnames' `tmp'.`fvar2'
					matrix `gamma'[1,`cnt'] = 1
					matrix `gamma'[2,`cnt'] = `j1'
					matrix `gamma'[3,`cnt'] = (`i'-1)* ///
						`nf' + `j2'
					local ++cnt	
				}
			}
		}
	}
	else {
		di as err "{bf:arstructure(`fac_arstructure')} invalid"
		exit 498
	}

	return matrix Gamma `gamma'
	return local dnames `dnames'
end

program define C_details, rclass
	version 11
	syntax , 				///
		obs_arstructure(string)		///
		zcol(integer)			///	zero column
		zrow(integer)			///	zero row
		k(integer)			///
		nq(integer)			///
		obs_arlist(numlist)		///
		obs_depvars(string)

	tempname gamma	

	if "`obs_arstructure'" == "diagonal" {
		matrix `gamma' = J(3, `k'*`nq', 0)
		local cnt = 1
		foreach i of local obs_arlist {
			forvalues j=1/`k' {
				local fvar : word `j' of `obs_depvars'
				_ms_parse_parts e.`fvar'
				local fvar `r(op)'.`r(name)'
				_ms_parse_parts e.L`i'.`fvar'
				local Lfvar `r(op)'.`r(name)'

				local dnames `dnames' `fvar':`Lfvar'
				matrix `gamma'[1,`cnt'] = 1
				matrix `gamma'[2,`cnt'] = `zrow' + `j'
				matrix `gamma'[3,`cnt'] = `zcol' + ///
					(`i'-1)*`k' + `j'
				local ++cnt	
			}
		}
	}
	else if "`obs_arstructure'" == "ltriangular" {
		matrix `gamma' = J(3, .5*`k'*(`k'+1)*`nq', 0)
		local cnt = 1
		foreach i of local obs_arlist {
			forvalues j1=1/`k' {		// row Ai
				local fvar1 : word `j1' of `obs_depvars'
				_ms_parse_parts e.`fvar1'
				local fvar1 `r(op)'.`r(name)'
				forvalues j2=1/`j1' {	// col Ai
					local fvar2 : word `j2' of `obs_depvars'
					_ms_parse_parts e.L`i'.`fvar2'
					local Lfvar2 `r(op)'.`r(name)'

					local dnames `dnames' `fvar1':`Lfvar2'
					matrix `gamma'[1,`cnt'] = 1
					matrix `gamma'[2,`cnt'] = `zrow' + `j1'
					matrix `gamma'[3,`cnt'] = `zcol' + ///
						(`i'-1)*`k' + `j2'
					local ++cnt	
				}
			}
		}
	}
	else if "`obs_arstructure'" == "general" {
		matrix `gamma' = J(3, `k'*`k'*`nq', 0)
		local cnt = 1
		foreach i of local obs_arlist {
			forvalues j1=1/`k' {		// row Ai
				local fvar1 : word `j1' of `obs_depvars'
				_ms_parse_parts e.`fvar1'
				local fvar1 `r(op)'.`r(name)'
				forvalues j2=1/`k' {	// col Ai
					local fvar2 : word `j2' of `obs_depvars'
					_ms_parse_parts e.L`i'.`fvar2'
					local Lfvar2 `r(op)'.`r(name)'

					local dnames `dnames' `fvar1':`Lfvar2'
					matrix `gamma'[1,`cnt'] = 1
					matrix `gamma'[2,`cnt'] = `zrow' + ///
						`j1'
					matrix `gamma'[3,`cnt'] = `zcol' + ///
						(`i'-1)*`k' + `j2'
					local ++cnt	
				}
			}
		}
	}
	else {
		di as err "{bf:arstructure(`obs_arstructure')} invalid"
		exit 498
	}

	return matrix Gamma `gamma'
	return local dnames `dnames'
end

program define Eqs_parse, rclass
	version 11
	syntax anything(equalok), touse(varname) ///
		[				 ///
		ar(numlist integer sort >0)	 ///
		ARStructure(string)		 ///
		COVStructure(string)		 ///
		noCONStant			 ///
		observables			 ///
		constraints			 ///
		]

	if "`constant'" != "" & "`observables'" == "" {
		di as err "{p}{bf:noconstant} may not be specified in " ///
		 "factor equations{p_end}"
		exit 198
	}

	gettoken depvars anything:anything, parse("=")

	if `"`anything'"' == "" {
		local depvars `"`depvars'"'
		local indeps  
	}
	else {
		gettoken eq indeps:anything, parse("=")

		if `"`eq'"' != "=" {
			display as err "error parsing equations"
			display as err `"{p}{bf:`0'} invalid{p_end}"' 
		}
		local depvars `"`depvars'"'
		local indeps  `"`indeps'"'
	}

	if "`observables'" != "" {
		tsunab depvars : `depvars'
		qui _rmcoll `depvars' if `touse', noconstant force 
		local depvars1 `r(varlist)'
		local collvars : list depvars - depvars1
		local ncoll : word count `collvars'
		if `ncoll' > 0 {
			di as txt "{p 0 6 2}note: {bf:`collvars'} dropped " ///
			 "because of collinearity with other dependent "    ///
			 "variables" _c
			if "`constraints'" != "" {
				di as txt "; any constraints involving " ///
				 "these variables will also be dropped{p_end}"
			}
			else di as txt "{p_end}"

			local depvars `depvars1'
		}
		/* check for repeated depvars using different TS 	*/
		/* operators						*/
		fvrevar `depvars', list
		local tsdepvar `r(varlist)'
		local dups : list dups tsdepvar
		if "`dups'" != "" {
			local ndup : word count `dups'
			di as err "{p}dependent " 		       ///
			 `"`=plural(`ndup',"variable")' {bf:`dups'} "' ///
			 `"`=plural(`ndup',"is","are")' on the left-"' ///
			 "hand-side of more than one observation "     ///
			 "equation; this is not allowed{p_end}"
			exit 498
		}
	}
	else {
		capture confirm names `depvars'
		local rc = _rc
		if `rc' {
			di as err `"{p}{bf:`depvars'} contains at "' ///
			 "least one invalid name{p_end}"
			exit 198
		}	
		local nf : word count `depvars'
		if `nf' > 1 {
			local depvars : list uniq depvars

			if `:word count `depvars'' != `nf' {
				di as err "{p}at least one factor name has " ///
				 "been specified more than once{p_end}"
				exit 198
			}
		}
		local defltcov default(identity)
	}

	if `"`indeps'"' != "" {
		_rmcoll `indeps' if `touse', `constant'
		local fvindeps `r(varlist)'

		fvexpand `fvindeps' if `touse'
		local fvindeps `r(varlist)'

		local vlist `fvindeps'
		local indeps
		while `: length local vlist' {
			gettoken var vlist: vlist, bind

			_ms_parse_parts `var'
			local indeps `indeps' `r(name)'
		}
		local indeps : list uniq indeps
	}

	ARstructure_parse `arstructure'
	local arstructure `r(structure)'

	_sspace_covstructure_parse, `covstructure' `defltcov'
	local covstructure `r(structure)'

	return local depvars 		`depvars'
	return local fvindeps 	 	`fvindeps'
	return local indeps 	 	`indeps'
	return local arlist     	`ar'
	return local arstructure	`arstructure'
	return local covstructure	`covstructure'
	return local constant           `constant'

	if "`observables'" == "" {	
		return local type factor
	}
	else {
		return local type observables
	}
end

program define Qi_details, rclass
	local version = string(_caller())
	version 11
	syntax ,			///
		dim(integer)		///
		covstructure(string)	///
		depvars(string)		///
		qinfo(name)		///
		[			///
		observable		///
		fobservable		///
		]


	tempname Qimat qgamma 

	matrix `Qimat' = I(`dim')

	if "`observable'" == "" {
		local dim_arg = 3
		local str_arg = 2
		local mcode   = 7
		local ename     nu
		if "`fobservable'" != "" {
			local vtype observable
		}
		else {
			local vtype factor
		}
	}
	else {
		local dim_arg = 5
		local str_arg = 4
		local mcode   = 8
		local ename     e
		local vtype observable
	}

	mata: `qinfo'[1,`dim_arg'] = `dim'

	if "`covstructure'"=="identity" {
		return matrix Qimat = `Qimat'
		exit
	}
	else if "`covstructure'"=="dscalar" {
		mata: `qinfo'[1, `str_arg'] = 1
		matrix `qgamma'=(`mcode' \ 1 \ 1)
		_msparse var(`ename'):, eq
		local vname `"`r(stripe)'"'
		if `version' < 16 {
			local qnames "`vname':_cons"
			local veqs "`vname'"
		}
		else {
			local qnames "/`vtype':`vname'"
			local veqs "/`vtype'"
		}
	}
	else if "`covstructure'"=="diagonal" {
		mata: `qinfo'[1, `str_arg'] = 2
		matrix `qgamma'= J(3, `dim', 0)
		local cnt = 1
		foreach fvar of local depvars {
			matrix `qgamma'[1, `cnt'] = `mcode' 
			matrix `qgamma'[2, `cnt'] = `cnt' 
			matrix `qgamma'[3, `cnt'] = `cnt' 

			_ms_parse_parts e.`fvar'
			local vname var(`r(op)'.`r(name)')
			if `version' < 16 {
				local qnames `"`qnames' `vname':_cons"'
				local veqs `"`veqs' `vname'"'
			}
			else {
				local qnames `"`qnames' /`vtype':`vname'"'
				/* repeat vtype to count # variances	*/
				local veqs `"`veqs' /`vtype'"'
			}
			local ++cnt
		}
	}
	else { // if "`covstructure'"=="unstructured" {
		mata: `qinfo'[1, `str_arg'] = 3
		matrix `qgamma'= J(3, .5*`dim'*(`dim'+1), 0)
		local cnt3 = 1
		/* covariance parameters in vech() order	*/
		forvalues j = 1/`dim' {
			local fvar2 : word `j' of `depvars'

			_ms_parse_parts e.`fvar2'
			local fvar2 `r(op)'.`r(name)'

			forvalues i = `j'/`dim' {
				local fvar1 : word `i' of `depvars'

				_ms_parse_parts e.`fvar1'
				local fvar1 `r(op)'.`r(name)'

				matrix `qgamma'[1, `cnt3'] = `mcode' 
				matrix `qgamma'[2, `cnt3'] = `i' 
				matrix `qgamma'[3, `cnt3'] = `j' 

				if (`i'==`j') local qname "var(`fvar1')"
				else local qname "cov(`fvar2',`fvar1')"

				if `version' < 16 {
					local qnames `"`qnames' `qname':_cons"'
					local veqs `"`veqs' `qname'"'
				}
				else {
					local nm "/`vtype':`qname'"
					local qnames `"`qnames' `nm'"'
					/* repeat vtype to count 
					 *  # covariances		*/
					local veqs `"`veqs' /`vtype'"'
					local ve
				}
				local ++cnt3
			}	
			if `version' >= 16 {
			}
		}
	}

	return matrix Qimat = `Qimat'
	return matrix Gamma = `qgamma'
	return local qnames `"`qnames'"'
	return local veqs `"`veqs'"'
end

program define BF_details, rclass
	version 11
	syntax , 			///
		code(integer)		///
		depvars(string)		///
		[			///
		indeps(string)		///
		all_indeps(string)	///
		cons(string)		///
		]

	tempname mat rgamma 

	if ("`indeps'"=="") exit

	local p : word count `indeps'
	local n : word count `depvars'
		
	matrix `rgamma' = J(3,`p'*`n',0)
	local rdnames 
	local cnt = 1
	forvalues i=1/`n' {
		local dvar : word `i' of `depvars'
		foreach ivar of local indeps {
			local j : list posof "`ivar'" in all_indeps
			matrix `rgamma'[1, `cnt'] = `code'
			matrix `rgamma'[2, `cnt'] = `i'
			matrix `rgamma'[3, `cnt'] = `j'
			if ("`ivar'"=="`cons'") local ivar _cons
			local rdnames `rdnames' `dvar':`ivar'
			local ++cnt
		}
	}

	return local dnames `rdnames'
	return matrix Gamma = `rgamma'
end

program D_details, rclass
	version 11
	syntax, 			///
		obs_depvars(string) 	///
		fac_depvars(string)	///

	local k : word count `obs_depvars'
	local nf : word count `fac_depvars'

	tempname dgamma
	matrix `dgamma' = J(3, `k'*`nf', 0)
	local dnames 
	local cnt 1
	forvalues i=1/`k' {
		local yvar : word `i' of `obs_depvars'
		forvalues j = 1/`nf' {
			local fvar : word `j' of `fac_depvars'
			matrix `dgamma'[1,`cnt'] = 4
			matrix `dgamma'[2,`cnt'] = `i'
			matrix `dgamma'[3,`cnt'] = `j'
			local dnames `dnames' `yvar':`fvar'

			local ++cnt
		}
	}

	return local dnames `dnames'
	return matrix Gamma = `dgamma'
end

program define ARstructure_parse, rclass
	version 11
	syntax [anything(name=struc)]

	local n : word count `struc'
	if `n' > 1 {
		di as err `"{p}{bf:arstructure(`struc')} invalid; "' ///
		 "use {bf:diagonal}, {bf:ltriangular}, or {bf:general}{p_end}"
		exit 198
	}	
	else if `n' == 0 {
		local structure diagonal
	}	
	else {
		local len = length(`"`struc'"')
		if `"`struc'"'==bsubstr("diagonal",1,max(2,`len')) { 
			/* DIagonal 					*/
			local structure diagonal
		}	
		else if `"`struc'"'==bsubstr("ltriangular",1,max(2,`len')) { 
			/* LTriangular 					*/
			local structure ltriangular
		}	
		else if `"`struc'"'==bsubstr("general",1,max(2,`len')) { 
			/* GEneral 					*/
			local structure general
		}	
		else {
			di as err `"{p}{bf:arstructure(`struc')} "' 	  ///
			 "invalid; use {bf:diagonal}, {bf:ltriangular}, " ///
			 "or {bf:general}{p_end}"
			exit 198
		}
        }

	return local structure `structure'
end

program ParseMethod, sclass
	version 11
	syntax, [ HYBrid DEJong * ]

	local method `hybrid' `dejong'
	local wc : word count `method'
	if "`options'"!="" | `wc'>1 {
		local method `method' `options'
		local method : list retokenize method
		di as err "{p}option {bf:method(`method')} is not allowed; " ///
		 "use {bf:method(hybrid)} or {bf:method(dejong)}{p_end}"
		exit 198
	}
	sreturn clear
	if (`wc'==0) local method hybrid

	sreturn local method `method'
end

exit

y_t = P*f_t + Q*x_t + u_t
f_t = R*w_t + A1*f_{t-1} + A2*f_{t-2} + ... + Ap*f_{t-p} + v_t
u_t = C1*u_{t-1} + C2*u_{t-2} + ... + Cq*u_{t-q} + e_t

	where 
	  	y_t is k  x 1    vector of observed variables
		P   is k  x nf   matrix of parameters (factor loadings)
		f_t is nf x 1    vector of unobserved factors
		Q   is k  x nx   matrix of parameters
		x_t is nx x 1    vector of exogenous variables
		u_t is k  x 1    vector of disturbances
		R   is nf x nw   matrix of parameters
		w_t is nw x 1    vector of exogenous variables
		Ai  is nf x nf   matrix of parameters
		v_t is nf x 1    vector of disturbances
		Ci  is k  x k    matrix of parameters 
		e_t is k  x 1    vector of disturbances


State space form

	z_t = Az_{t-1} + Bx_{t-1} + Cw_{t-1}
	y_t = Dz_t     + Fx_t     + Gv_t

	code	matrix	description
	1	A	A matrix
	2	B	B matrix
	3	C	C matrix
	4	D	D matrix
	5	F	F matrix
	6	G	G matrix
	7	Q	Cov(w_t, w_t) = S_w matrix
	8	R	Cov(v_t, v_t) = S_v matrix
	9       Q1      upper block of Q     Q=(Q1,0\0,Q2)
	10      Q2      lower block of Q

Gamma maps vector of parameters delta to state-space matrices
Gamma is 3 x np, np is total number of parameters in model
Each column of Gamma is (mcode, row, col)

/*
 * Qinfo1 (case={0,1}, Q1_structure, dim(Q1), Q2_structure, dim(Q2), p, q)
 * case=0=>standard Q and R
 * case=1=> Q = diag(Q1,Q2)
 * Q*_structure 0=>identity, 1=>dscalar, 2=>diagonal, 3=>unstructured/general
 */

