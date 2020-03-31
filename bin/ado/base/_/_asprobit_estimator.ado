*! version 2.3.2  12apr2019
*! estimator for asmprobit and asroprobit

program _asprobit_estimator, eclass byable(recall) 
	local vv : di "version " string(_caller()) ":"
	if _caller() >= 11 {
		local negh negh
	}
	version 14
	syntax, model(name) [				///
		noTRANsform				///
		CONSTraints(numlist > 0 integer)	///
		Robust					///
		CLuster(passthru)			///
		FROM(string)				///
		TECHnique(string)			///
		INITBhhh(integer 0)			///
		ITERate(passthru)			///
		VCE(passthru)				///
		NOPREserve				///
		DEBug					///
		MLInit					///
		TRace					///
		NOLOg LOg				///
		CLUSTERCHECK(varname)			///
		* ]

	/* undocumented options						*/
	/* trace - verbose output					*/

	qui findfile _probitmodel_macros.ado
	qui include `"`r(fn)'"'

	mlopts mlopts rest, `options'

	/* syntax error if there is anything left			*/
	PostError `model', `rest'

	local nattrib = `.`model'.kvars'
	local ncasev = `.`model'.kbavars'
	local response `.`model'.dep'
	local attribs `.`model'.strvars'
	local casevars `.`model'.strbavars'

	if "`.`model'.wtype'" != "" {
		local weight `.`model'.wtype'
		local exp "=`.`model'.weight.exp'"
	}
	if "`weight'"=="iweight" | "`weight'"=="fweight" {
		local wtopt [`weight'`exp']
	}
	else if "`weight'" == "pweight" {
		local wtopt [iweight`exp']	
	}
	_vce_parse, argopt(CLuster) opt(Robust oim opg) old: ///
		[`weight'`exp'], `vce' `cluster' `robust'

	local cluster `r(cluster)'
	local robust `r(robust)'
	local vce `r(vce)'

       	if "`robust'" != "" {
		local pseudo pseudo
		local robust robust
	}
	local d1 d1
	ParseTech `"`technique'"' `initbhhh' "`vce'" 

	local technique `"`s(technique)'"'
	local tech `"`s(tech)'"'
	local d1 "`s(d1)'"
	local vce0 "`s(vce0)'"
	local vce "`s(vce)'"
	local tech2 "`s(tech2)'"
	local vce2 "`s(vce2)'"
	local d21 "`s(d21)'"
	local initbhhh = `s(initbhhh)'
	local techmeth "`s(techmeth)'"
	local techswitch = `s(techswitch)'

	local nalt = `.`model'.altern.k'
	if (`nalt'<=2) local initbhhh = 0 
	else local critopt crittype(log simulated-`pseudo'likelihood)

	if (!`.`model'.cov.structural') local transform notransform
	local reparam = (`.`model'.cholesky' & "`transform'"=="")

	local wald = `.`model'.kvars'>0
	if `.`model'.kbavars' > 0 {
		local wald = `wald' + `nalt' - 1
	}
	local ncov = `.`model'.kanc'
	local ncoef = `.`model'.kcoef'
	tempname b ic ilog
	if "`from'" == "" {
		local vconstr = 0
		if `"`constraints'"' != "" {
			local stripe `"`.`model'.asstripe'"'
			local stripe `"`stripe' `.`model'.bastripe'"' 
			/* variance parms stripe for structural cov	*/
			local stripe `"`stripe' `.`model'.vparstripe'"'
			matrix `b' = J(1,`ncoef'+`ncov',0)
			`vv' ///
			matrix colnames `b' = `stripe'

			CheckConstraints "`b'" `ncov' `"`constraints'"'
			/* vconstr is the number of constraints on the  */
		 	/*  variance parameters				*/
			/* bconstr is the number of constraints on the  */
			/*  regression parameters 			*/
			local vconstr = `e(vconstr)'
			local bconstr = `e(bconstr)'
			if `bconstr' > 0 {
				/* pass the constraint matrix on to  	*/
				/*  clogit for initial estimates    	*/
				tempname C 
				matrix `C' = e(C)
				local cmat cmat(`C')
			}	
		}
		if `reparam' & `vconstr' > 0 {
			/* constraints on variance/covariance 		*/
			/*  parameters, cannot reparameterize 	  	*/
			local reparam = 0
			.`model'.cholesky = 0
		}
	}
	else {
		local reparam = 0
		if (`.`model'.cov.structural' & "`transform'"=="") {
			.`model'.cholesky = 0
		}
	}
	/* now generate ml ancillary parameters				*/
	local case `.`model'.case.varname'
	local touse `.`model'.touse'
	local altern `.`model'.altern.varname'
	
	.`model'.genancpar
	
	sort `case' `altern'
	
	local prefix `c(prefix)' 
	local isloop : list posof "_loop" in prefix

	if "`cluster'" != "" | ("`clustercheck'" != "" & !`isloop') {
		
		/* make sure cluster is constant with case		*/
		
		if "`cluster'" != "" {
			local cvar `cluster'
		}
		else {
			local cvar `clustercheck'
		}
		
		cap assertnested `cvar' `case' if `touse'
		if _rc == 459 {
			di as err "{p}cases must be nested within " ///
			 	  "clusters{p_end}"
			exit 459
		}
		else if _rc {
			error _rc
		}
	}

	if "`from'"=="" {
		local b0 `b'
		.`model'.initest, b(`b') `cmat' `trace'

		local initopt init(`b')
	}
	else {
		gettoken b0 rest: from, parse(", ")
		local initopt init(`from')
	}
	.`model'.droptvars
	.`model'.genscvar
	if "`robust'" != "" {
		.`model'.robustcheckmemory, b(`b0')
	}
	if "`tech2'"=="" & `reparam' {
		local tech2 nr
		local vce2  oim
		if ("`vce'"=="opg") local d21 d2
		else local d21 d1
	}
	if "`tech2'" != "" {
		local waldopt2 waldtest(`wald')
		local waldopt waldtest(0)
	}
	else {
		if ("`vce'"!="") local vceopt vce(`vce')
		local waldopt waldtest(`wald')
	}
	global ASPROBIT_model `model'
	global ASPROBIT_trace = ("`trace'"!="")

	if ("`constraints'" != "") local conopt constraints(`constraints')
	local mlmodel `.`model'.mlmodel' `.`model'.mlancmodel'

	if "`trace'" != "" {
		.`model'.cov.summary
		di "cholesky = " `.`model'.cholesky'
		di "reparam =  " `reparam'
		di _n "mlmodel |`mlmodel'|"
		if "`from'" != "" {
			gettoken b rest : from, parse(" ,")
		}
		di _n "initial estimates" _c
		mat li `b', noheader
	}
	local converged = 0
	local rc = 0

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	set buildfvinfo off
	if `initbhhh' > 0 {
		if "`log'" == "" {
			di _n in smcl in gr "(setting optimization to BHHH)"
			if ("`techmeth'" != "") local log1 log
		}
		/* `onercp'!=0, we use d2 and nr but the algorithm is    */
		/*  actually bhhh technique and opg for negative hessian */
		`vv' ///
		ml model d2 asprobit_lf `mlmodel' `wtopt' if `touse',     ///
			technique(nr) collinear nopreserve `conopt'       ///
			noscvars `critopt' search(off) `initopt' nooutput ///
			`trace' iterate(`initbhhh') `mllog' nowarning max `negh'

		matrix `b' = e(b)
		scalar `ic' = e(ic)
		matrix `ilog' = e(ilog)
		local initopt init(`b')
		local converged = e(converged)
		local rc = e(rc)
		if `converged' & "`tech2'"=="" {
			local tech2 nr
			local vce2  oim
			if ("`vce'"=="opg") local d21 d2
			else local d21 d1
			local waldopt2 waldtest(`wald')
		}
	}
	if `converged' == 0 {
		if "`debug'" != "" {
			global ASPROBIT_trace = 0

			`vv' ///
			ml model d1debug asprobit_lf `mlmodel' `wtopt'     ///
				if `touse', nopreserve collinear `initopt' ///
				noscvars gradient showstep trace max       ///
				search(off) `trace' `mllog' `negh'
		}
		else {
			if ("`log1'" != "") di _n in smcl in gr ///
				"(switching optimization to `techmeth')"
			/* let -ml- approximate the negative hessian 	*/
			/*  (unless tech=bhhh) 				*/
			`vv' ///
			ml model `d1' asprobit_lf `mlmodel' `wtopt'       ///
				if `touse', technique(`tech') nopreserve  ///
				collinear `conopt' `initopt' search(off)  ///
				noscvars `vceopt' `robopt' `iterate'      ///
				`mlopts' `critopt' `waldopt' nooutput max ///
				`trace' `mllog' `negh'
		}
		matrix `b' = e(b)
		scalar `ic' = e(ic)
		matrix `ilog' = e(ilog)
		local converged = e(converged)
		local rc = e(rc)
	}
	if "`tech2'" != "" {
		if `reparam' {
			/* put parameter estimates into desired metric 	*/
			if "`log'" == "" {
				di _n in gr "Reparameterizing to " ///
				 "correlation metric" _c
				if (`converged') di " and refining estimates" 
				else di _n
			}
			.`model'.reparameterize, b(`b')
			if `converged' {
				local iteropt `iterate'
			}
			else {
				local iteropt iterate(0)
				local qui qui	
			}
			local mlmodel `.`model'.mlmodel' `.`model'.mlancmodel'
		}
		else {
			local iteropt iterate(0)
			local qui qui 
		}
		`vv' ///
		`qui' ml model `d21' asprobit_lf `mlmodel' `wtopt'         ///
			if `touse',  technique(`tech2') vce(`vce2')        ///
			collinear `conopt' init(`b') nopreserve `mlopts'   ///
			`critopt' `waldopt2' search(off) nooutput noscvars ///
			max nowarning `iteropt' `mllog' `negh'

		if `reparam' & e(converged)==0 {
			di in gr "note: reparameterization failed"
		} 
		else {
			ereturn scalar converged = `converged'
			ereturn scalar rc = `rc'
		}
	}
	if "`robust'" != "" {
		tempname b V
		mat `V' = e(V)
		mat `b' = e(b)
		if ("`cluster'"!="") local clopt cluster(`cluster')

		.`model'.robust, b(`b') v(`V') `clopt' 
	}
	else if "`vce0'" == "opg" {
		ereturn local vce "opg"
		ereturn local vcetype "OPG"
		ereturn local ml_method "d1"
	}

	ereturn scalar ic = `ic'
	ereturn matrix ilog = `ilog'

	ereturn local k_dv

	/* post model into ereturn					*/ 
	.`model'.eretpost

	local varlist `.`model'.dep' `.`model'.strvars' `.`model'.strbavars'
	/* original varname returned by _alternvar.variable method	*/ 
	local case `.`model'.case.exp'
	local altern `.`model'.altern.variable'

        signestimationsample `varlist' `case' `altern' `cluster'

	set buildfvinfo on
	ereturn repost, esample(`touse') buildfvinfo ADDCONS
	ereturn local predict asprobit_p
	ereturn local estat_cmd asprobit_estat
	eret hidden local marginsprop addcons

	if `.`model'.mversion' >= `PROBIT_VERSION_CM_BASE' {
		local ks = e(k_sigma)
		local kr = e(k_rho)
		local kc = `ks'+`kr'
		if `kc' {
			tempname pb b
			_b_pclass PCDEF : default
			_b_pclass PCSD : group0
			_b_pclass PCCOR : tanh

			mat `b' = e(b)
			local stripe : colfullnames `b'
			local k = colsof(`b')

			if `k' > `kc' {
				mat `pb' = J(1,`k'-`kc',`PCDEF')
			}
			if `ks' {
				mat `pb' = (nullmat(`pb'),J(1,`ks',`PCSD'))
			}
			if `kr' {
				mat `pb' = (nullmat(`pb'),J(1,`kr',`PCCOR'))
			}
			mat colnames `pb' = `stripe'
			ereturn hidden matrix b_pclass = `pb'
		}
	}
end

program PostError
	syntax name(name=model), [ SCore(string) ]

	if "`score'"!="" {
		if ("`.`model'.classname'"=="_asmprobitmodel") {
			local cmd asmprobit
		}
		else local cmd asroprobit

		di as error "{p}option {bf:score()} not allowed; see "       ///
		"{helpb `cmd' postestimation##predict:`cmd' postestimation}" ///
		" to obtain scores{p_end}"
		exit 198
	}
end
  
program ParseTech, sclass
	args technique initbhhh vce

	if "`initbhhh'"!="" & `initbhhh'<0 {
		di as error "{bf:initbhhh()} must be greater than 0"
		exit 198
	}
	tokenize `technique'

	local d1 d1
	local tech `technique'
	local vce0 `vce'
	else if ("`vce'"== "cluster") local vce robust

	if "`2'" == "" {
		if "`1'" == "" {
			local tech bfgs
			local technique bfgs
		}
		if "`tech'" == "bhhh" {
			local initbhhh = 0
			/* must trick -ml- and let the likelihood evaluator */
			/* compute the outer product gradient approximation */
			/* to the negative Hessian 			    */
			local d1 d2
			local tech nr

			/* detect if an extra call to ml is needed to get */
			/*  the desired vce 				  */
			if "`vce'"=="oim" | "`vce'"=="robust" {
				local vce oim
				local tech2 nr
				local vce2  oim
				local d21   d1
			}
			else { /* "`vce'"=="opg" */
				local vce oim
				local vce0 opg
			} 
		}
		else {
			if ("`vce'"=="") local vce oim
			if "`vce'" == "opg" {
			/* detect if an extra call to ml is needed to get */
			/*  the desired vce 				  */
				local tech2 nr
				local vce2  oim
				local d21   d2
			}
			else if "`vce'" == "robust" {
				local vce oim
			}
			if `initbhhh' > 0 {
				if ("`tech'" == "nr") ///
					local techmeth Newton-Raphson
				else local techmeth = upper("`technique'")
			}
		}
		sreturn local techswitch = 0
	}
	else {
		if ("`vce'"=="") local vce oim
		local initbhhh = 0
		local i = 0
		while "``++i''" != "" {
			if "``i''" == "bhhh" {
				di as error "{p}" 			    ///
				 "{bf:technique(`technique')} is invalid; " ///
				 "use the {bf:initbhhh({it:#})} option{p_end}"
				exit 184
			}
		}
		local tech2 nr
		if "`vce'"=="oim" | "`vce'"=="robust" {
			local vce oim
			local vce2  oim
			local d21   d1
		}
		else { /* "`vce'"=="opg" */
			local vce2  oim
			local d21   d2
			local vce0  opg
		}
		sreturn local techswitch = 1
	}
	sreturn local technique `"`technique'"'
	sreturn local tech `"`tech'"'
	sreturn local d1 "`d1'"
	sreturn local vce0 "`vce0'"
	sreturn local vce "`vce'"
	sreturn local tech2 "`tech2'"
	sreturn local vce2 "`vce2'"
	sreturn local d21 "`d21'"
	sreturn	local initbhhh = `initbhhh'
	sreturn local techmeth "`techmeth'"
end

program CheckConstraints, eclass 
	args b nv clist

	local vconstr = 0
	local bconstr = 0
	if `"`clist'"' == "" {
		ereturn local vconstr = `vconstr'
		ereturn local bconstr = `bconstr'
		exit 0
	}
	tempname T a C CV V b1 CB
		
	matrix `b1' = `b'
	matrix `V' = `b''*`b'
	ereturn post `b1' `V' 
	makecns `clist', nocnsnotes r
	if r(k) == 0 {
		ereturn local vconstr = `vconstr'
		ereturn local bconstr = `bconstr'
		exit 0
	}	
	matcproc `T' `a' `C'

	local nr = rowsof(`C')
	local nc = colsof(`C')
	local i1 = `nc'-`nv'-1
	forvalues i=1/`nr' {
		forvalues j=1/`i1' {
			if `C'[`i',`j'] != 0 {
				local `++bconstr'
				matrix `CB' = (nullmat(`CB')\ ///
					(`C'[`i',1..`i1'],`C'[`i',`nc']))
				continue, break
			}
		}
	}
	ereturn local bconstr = `bconstr'
	if (`bconstr' > 0) ereturn matrix C = `CB'

	if `nv' > 0 {
		local `++i1'
		local `--nc'
		local j = 0

		forvalues i = 1/`nr' {
			forvalues j = `i1'/`nc' {
				if `C'[`i',`j'] != 0 {
					local `++vconstr'
					continue, break
				}
			}
		}
	}

	ereturn local vconstr = `vconstr'
end

exit


