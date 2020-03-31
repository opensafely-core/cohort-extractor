*! version 1.1.0  01mar2015
program rocregplot
	version 12
	if "`e(cmd)'" != "rocreg" {
		di as error "rocregplot only used after rocreg"
		exit 198
	}
	
	syntax , [	classvars(varlist) 		///
				bfile(string) 		///
				roc(numlist) 	 	///
				INVroc(numlist) 	///
				Level(str)	  	///
				btype(string)		///
				at(string) 		///
				at1(string)		///
				at2(string) 		///
				at3(string) 		///
				at4(string) 		///
				at5(string) 		///
				at6(string) 		///
				at7(string) 		///
				at8(string) 		///
				at9(string) 		///
				at10(string) 		///
				*			///
				]

	local isml = "`e(ml)'" == "ml"
	local haslevel = "`level'"!=""
	local isprobit  = "`e(probit)'" == "probit"
	if `haslevel' {
		local oldlevel = c(level)
                local oldlevel = string(`oldlevel',"%9.0g")
		set level `level'
                local level = string(`level',"%9.0g")
		qui set level `oldlevel'
	}
	else {
		local level = c(level)
                local level = string(`level',"%9.0g")
	}
	if "`roc'" != "" & "`invroc'" != "" {
		di as error "only one of roc() or invroc() may be specified"
		exit 198
	}
	if ("`bfile'" != "" & `"`roc'`invroc'"' == "") {
		if ("`e(link)'" == "") {
			di as err "Last estimates are nonparametric;"
			di as err "bfile() not allowed"
			exit 198
		}
		else {
			di as err "{p 0 4 2}roc() or invroc() must be specified"
			di as err " if bfile() specified {p_end}"
			exit 198
		}
	}
	if "`btype'" !="" & "`e(nobootstrap)'"!="" {
		di as error "last estimates are not bootstrap;"
		di as err "btype() not allowed" 
		exit 198
	} 
	if "`e(probit)'`e(roc)'`e(invroc)'" == "" & "`btype'" !="" {
		di as error "last estimates do not contain roc() " ///
		as error "or invroc() estimates;"
		di as err "btype() not allowed" 
		exit 198
	}
	if !inlist(`"`btype'"',"","n","bc","p") {
		di as err "{p 0 4 2} btype() must be n, bc, or p {p_end}" 
		exit 198
	}
	if (!`isprobit' & "`btype'" == "") {
		if("`e(nobootstrap)'" == "" & "`e(roc)'`e(invroc)'" != "") {
			local btype "n"
		}
	}
	if (`isprobit' & "`btype'" == "") {
		if(!`isml' & "`roc'`invroc'" != "") {
			local btype n
		}
	}
		
	if !`isml' {
 		if `isprobit' & ("`bfile'" == "" & `"`roc'`invroc'"' != "") {
			if "`roc'"!= "" {
				local err roc()
			}
			else {
				local err invroc()
			}
			di as error "last estimates are parametric bootstrap;"
			di as error "bfile() must be specified if `err'" ///
				" is specified"
			exit 198
		}
		else if !`isprobit' & `"`roc'`invroc'"' != "" {
			if "`roc'"!= "" {
				local err roc()
			}
			else {
				local err invroc()
			}
			di as error ///
				"last estimates are nonparametric;"
			di as error "`err' invalid" 
			exit 198
		}
		else if !`isprobit' & "`bfile'" != "" {
			di as error ///
				"last estimates are nonparametric;"
			di as error "bfile() invalid" 
			exit 198
		}
		if "`btype'" != "" & "`roc'`invroc'" == "" & `isprobit'{
			di as err "nothing to do; "
			di as err "{p 0 4 2}either roc() or invroc() must" ///
			" be specified if btype() is specified{p_end}"
	        	exit 198
		}
	}
	else {
		if "`btype'"!="" {
			di as err "{p 0 4 2}btype() not allowed "
		        di as err "after maximum likelihood estimation{p_end}"
	        	exit 198
		}
		if "`bfile'" != ""{
			di as err "{p 0 4 2}bfile() not allowed "
	       		di as err "after maximum likelihood estimation{p_end}"
	       	 	exit 198
		}
	}
	if (`haslevel' & !`isprobit') {
	      di as error "last estimates are nonparametric;"
	      di as err "level() not allowed "
	      exit 198
	}
	if (!`isprobit' | `"`roc'`invroc'"'=="")& `haslevel' {
		di as err "nothing to do; "
		di as err "{p 0 4 2}either roc() or invroc() must" ///
		" be specified if level() is specified{p_end}"
              exit 198
	} 
	
	// convert ats to data coordinates  
	preserve
	// default to mean of entire population
        if ("`e(roccov)'" != "") {
		tempname estpres
		qui estimates store `estpres'
		qui mean `e(roccov)' if e(sample)
		tempname margmeans 
		matrix `margmeans' = e(b)	
		qui estimates restore `estpres'
		qui estimates drop `estpres'
	}
	if (`"`at2'`at2'`at3'`at4'`at5'`at6'`at7'`at8'`at9'`at10'"' == "" & `"`at1'"' != "") {
		if(`"`at'"' != "") {
			di as error ///
			"{p 0 4 2}at() only specified when curve wanted for" 
			di as error " single covariate group{p_end}"		
			exit 198
		}
		else {
			local at `at1'
			local at1 
		}
	} 
	capture assert (`"`at'"' ==  "") | ///
		(`"`at1'`at2'`at3'`at4'`at5'`at6'`at7'`at8'`at9'`at10'"' ///
		== "") ///
		if 							///
		`"`at'`at1'`at2'`at3'`at4'`at5'`at6'`at7'`at8'`at9'`at10'"' ///
		!=""
	if (_rc != 0) {
		di as error ///
		"{p 0 4 2}at() only specified when curve wanted for" 
		di as error " single covariate group{p_end}"		
		exit 198
	}
		
	capture assert /// 
		`"`at'`at1'`at2'`at3'`at4'`at5'`at6'`at7'`at8'`at9'`at10'"' ///
		=="" ///
		if `"`e(roccov)'"' == ""
	if (_rc != 0) {
		di as error ///
		"{p 0 4 2}at*() specified only when roccov() was "
		di as error "specified in rocreg{p_end}"
		exit 198
	}
	capture assert ///
		`"`at'`at1'`at2'`at3'`at4'`at5'`at6'`at7'`at8'`at9'`at10'"' ///
		!= "" if `"`e(roccov)'"' != ""
	if (_rc != 0) {
		di as error ///
"{p 0 4 2}covariate values must be specified when roccov() was specified in rocreg{p_end}"
		exit 198
	}
	local j = 0
	if (`"`at'`at1'`at2'`at3'`at4'`at5'`at6'`at7'`at8'`at9'`at10'"' != "") {
		local at0 `at'
		if (`"`at0'"' == "") {
			forvalues i = 1/10 {
				local k = `i' - 1
				local at`k' `at`i''
				local at`i' 
			}
		}
		forvalues i = 1/10 {
			local j2 = `i' - 1
			capture assert `"`at`j2''"' != "" if `"`at`i''"' != ""
			if (_rc != 0) {
				di as error ///
"{p 0 4 2}at*() must follow sequence, at1(), at2(), etc{p_end}"
				exit 198
			}
		}
		forvalues i = 0/10 {
			if "`at`i''"~="" {
				tokenize "`at`i''" ,parse(" =,")
				foreach var in `e(roccov)' {
					local in_`var' = 0
				}
				while "`1'"!="" {
					capture assert ///
subinstr("`e(roccov)'","`1'","",.) != "`e(roccov)'"
					if (_rc) {
						di as error ///
`"{p 0 4 2} `1' not ROC regression covariate{p_end}"'
						exit 198
					}
					capture assert `in_`1'' == 0
					if (_rc) {
						if(`i'== 0) {
                                                di as error ///
`"{p 0 4 2} `1' specified twice in at(){p_end}"'
						}
						else {
                                                di as error ///
`"{p 0 4 2} `1' specified twice in at`i'(){p_end}"'
						}
                                                exit 198

					}
					local in_`1' = 1
					capture qui replace `1' `2' `3' ///
						if _n == `i'+1
					if (_rc) {
						if(`"`at'"' != "") {
							di as error ///
`"at() syntax error for variable `1'"'
						}
						else {
							local j = `i' + 1
							di as error ///
`"at`j'() syntax error for variable `1'"'
						}
						exit 198
					}
					local atlist `atlist' `1'
					if "`4'"=="," {
						mac shift 4
					}
					else { 
						mac shift 3 
					}
				}
				foreach var in `e(roccov)' {
					if (`in_`var''==0) {
						local colm = ///
                                                	colnumb( ///
							`margmeans',"`var'")
                                                tempname tempscal
                                                scalar `tempscal' = ///
                                                        `margmeans'[1,`colm']
                                                qui replace `var' = ///
                                                        `tempscal' ///
                                                        if _n == `i' + 1
					}
				}
				local j = `j' + 1				
			}
		}	
	}
	if (`j'==0) {
		local j = 1
	}
	if (`"`bfile'"' != "") {
		local bfile bfile(`bfile')
	}
	if (`"`roc'"' != "") {
		local roc roc(`roc')
	}
	if (`"`invroc'"' != "") {
		local invroc invroc(`invroc')
	}
	if (`"`btype'"' != "") {
		local btype btype(`btype')
	}
	if (`"`classvars'"' != "") {
		local classvars classvars(`classvars')
	}

	if (`"`at'`at1'`at2'`at3'`at4'`at5'`at6'`at7'`at8'`at9'`at10'"'!="") {
		GRocRegPlot_h in 1/`j' ///
		, `classvars' `bfile' `roc' `invroc' ///
		`btype' level(`level') `options'
	}
	else {
		GRocRegPlot_h if e(sample) ///
		, `classvars' `bfile' `roc' `invroc' ///
		`btype' level(`level') `options'
	}

	restore
end

program GRocRegPlot_h,
	syntax  [if] [in], [	classvars(varlist) 	///
				bfile(string) 		///
				roc(numlist)		///	
				INVroc(numlist) 	///
				level(cilevel)		///
				btype(string)		///
				*			///
				] 

	if ("`e(ml)'" == "ml" & "`e(roccov)'" != "") {
		GRocRegPEstat_ML `0'	
	}
	else if ("`e(link)'" != "" &  "`e(roccov)'" != "") {
		GRocRegPEstat `0'
	}
	else if ("`e(link)'" == "") {
		GRocReg_EstatGNP `0'
	}
	else {
		// marginal model
		if(`"`e(ml)'"' != "") {
			GRocRegPEstat_ML_Margin `0'
		}
		else {
			GRocRegPEstat_Margin `0'		
		}		
	}
end

program GRocRegPEstat
	syntax [if] [in], 	[bfile(string)] 	///
				[roc(numlist) 		///
				INVroc(numlist) 	///
				Level(cilevel) 		///
				classvars(string) 	///
				btype(string)		///
				norefline] * 

	// check that roc and invroc arguments legal
	if(`"`roc'"' != "") {
		foreach num of numlist `roc' {
			if `num' <= 0 | `num' >=1 {
				noi di as error ///
					"roc() inputs must be in (0,1)"
				error 198
			}
		}
	}

	if(`"`invroc'"' != "") {
		foreach num of numlist `invroc' {
			if `num' <= 0 | `num' >= 1 {
				noi di as error ///
					"invroc() inputs must be in (0,1)"
				error 198
			}
		}
	}


	// mark sample and load covariate values into matrix
	// before bootstrap data used
	if (`"`classvars'"' == "") {
		local classvars `e(classvars)'
	}

	foreach vf of local classvars {
		local label_`vf': variable label `vf'
	}

	marksample touse
	qui count if `touse'
	local tousecnt = r(N)
	capture assert `tousecnt' > 0 
	if (_rc != 0) {
		noi di as error ///
		"no observations"
		exit 2000
	}
	qui markout `touse' `e(roccov)' 
	capture qui count if `touse'
	local ntouse = r(N)
	if r(N) <= 0  {
		noi di as error "data contains missing values"
		exit 2000
	}
	// number of graphs, observations times each classvar
	local ngr : word count `classvars'
	local ngr = `ngr'*`ntouse'

	local classvarcnt: word count `classvars'
	// start as 1, reset with added covariates
	local ncovobs = 1

	preserve
	// get covariate values in matrix
	tempname iregvarsmat
	qui mkmat `e(roccov)' if `touse', matrix(`iregvarsmat')
	local ncovobs = rowsof(`iregvarsmat')

	local iregvarsmatlabs
	if (`ncovobs'==1) {
		local iregvarsmatlabs at

	}
	else {
		forvalues i=1/`ncovobs' {
			local iregvarsmatlabs `iregvarsmatlabs' at`i'
		}
	}
	matrix rownames `iregvarsmat' = `iregvarsmatlabs'

	//sample marked, parse remaining syntax

	local parseit ASPECTratio(string) LEGend(string asis) RLOPTs(string)
	forvalues i = 1/`ngr' {
		local parseit `parseit' line`i'opts(string)
	}
	local parseit `parseit' *
	local 0 , `options'
	syntax, [`parseit']

	_get_gropts, graphopts(`options') gettwoway
	capture assert "`s(graphopts)'" == ""
	if (_rc) {
		local f: word 1 of `s(graphopts)'
		tokenize `"`f'"', parse(" (")
		local f1 `1'
		tokenize `"`f'"', 
		local f2 `1'
		if (`"`f1'"' != `"`f2'"') {
			local f `f1'()
		}
		else {
			local f `f1'
		}
		di as error `"option `f' not allowed"'
		exit 198
	}

	if(`"`refline'"' == "norefline") {
		local norefline norefline
	}
	local graph graph


	local	link `"`e(link)'"'
	local roccov `"`e(roccov)'"'
	local refvar	`"`e(refvar)'"'
	local ctrlmodel	`"`e(ctrlmodel)'"'
	local ctrlcov	`"`e(ctrlcov)'"'

	// we've gotten all we need from sample
	// and parsed syntax
	// get bootstrap results
	if (`"`bfile'"' != "") {
		qui use `bfile', clear
		// rename variables as needed
		// classvar index 
		// roccov index
		local keeplist 
		foreach verb of varlist _all {
			local f: variable label `verb'
			local vvit = 1
			foreach var in `classvars' {
				if (`"`f'"' == `"[`var']_b[i_cons]"') {
					rename `verb' _v`vvit'_b_i_cons
					local keeplist	///
						`keeplist' _v`vvit'_b_i_cons
				}
				if (`"`f'"' == `"[`var']_b[s_cons]"') {
					rename `verb' _v`vvit'_b_s_cons
					local keeplist ///
						`keeplist' _v`vvit'_b_s_cons
				}
				local rcit = 1
				foreach rocvar in `e(roccov)' {
					if (`"`f'"'==`"[`var']_b[`rocvar']"') {
						rename `verb' _v`vvit'_b_`rcit'
						local 	keeplist ///
							`keeplist' ///
							_v`vvit'_b_`rcit'
					}
					local rcit = `rcit' + 1
				}
				local vvit = `vvit' + 1
			}
		}
		keep `keeplist'
	}

	
	if (`"`roc'"'!="") {
		// estimate ROC value for bootstrap observations
		// and observed estimate values
		tokenize
		// iteration for tokenizing later, to give colnames
		local iter = 1
		local i = 1
		local roccnt: word count `roc'
		local varcnt: word count `classvars'
		tempname rocobsmat
		matrix `rocobsmat' = J(1,`roccnt'*`varcnt'*`ncovobs',.)
	
		foreach num of numlist `roc' {
			forvalues j = 1/`ncovobs' {
				local vvit = 1
				foreach var in `classvars' {
					if(`"`bfile'"' != "") {
						//bootstrap realizations
						RBF1, 	i(`i') 		  ///
							j(`j') 		  ///
							vvit(`vvit')	  ///
							im(`iregvarsmat') ///	
							link(`link')	  ///
							num(`num')
					}

					//observed
					tempname obs_roc_`i'_`j'_v`vvit'
					tempname bmat
					ROF1, num(`num')		   ///
			  		      o(`obs_roc_`i'_`j'_v`vvit'') ///
					      bmat(`bmat')		   ///
					      var(`var') 		   ///
					      im(`iregvarsmat')		   ///
					      link(`link') i(`i') j(`j')

					local `iter' = "`var':roc_`i'_`j'"
					matrix `rocobsmat'[1,`iter'] = ///
						`obs_roc_`i'_`j'_v`vvit'' 
					local iter = `iter'+1
					local vvit = `vvit' + 1
				}
			}
			local i = `i'+1
		}
		matrix colnames `rocobsmat' = `*'
		if(`"`bsm'"' == "") {
			tempname bsm
			matrix `bsm' = `rocobsmat'
		} 
		else {
			matrix `bsm' = `bsm',`rocobsmat'
		}
	}

	if (`"`invroc'"'!="") {
		// estimate invROC value for bootstrap observations
		// and observed estimate values
		tokenize
		local iter = 1
		local i = 1

		local invroccnt: word count `invroc'
		local varcnt: word count `classvars'

		tempname invrocobsmat
		matrix `invrocobsmat' = J(1,`invroccnt'*`varcnt'*`ncovobs',.)

		foreach num of numlist `invroc' {
			forvalues j = 1/`ncovobs' {
				local vvit = 1
				foreach var in `classvars' {
					if(`"`bfile'"' != "") {			
						// bootstrap realizations
						IBF1, 	i(`i') 		  ///
							j(`j') 		  ///
							vvit(`vvit')	  ///
							im(`iregvarsmat') ///	
							link(`link')	  ///
							num(`num')
					}
				
					//observed
					tempname obs_invroc_`i'_`j'_v`vvit'
					local of `obs_invroc_`i'_`j'_v`vvit''	
					IOF1, num(`num')		    ///
			  		      o(`of') 			    ///
					      var(`var') 		    ///
					      im(`iregvarsmat')		    ///
					      link(`link')		    ///
					      i(`i') 			    ///
					      j(`j')

					local `iter' = "`var':invroc_`i'_`j'"
					matrix `invrocobsmat'[1,`iter'] = ///
						`obs_invroc_`i'_`j'_v`vvit'' 
					local iter = `iter'+1
					local vvit = `vvit' + 1
				}
			}
			local i = `i'+1
		}

		matrix colnames `invrocobsmat'= `*'
		if(`"`bsm'"' == "") {
			tempname bsm
			matrix `bsm' = `invrocobsmat'
		} 
		else {
			matrix `bsm' = `bsm',`invrocobsmat'
		}
	}

	// using previous calculation, temporarily 
	// add ROC and invROC estimation results to current estimates

	tempname tobst
	if(`"`bsm'"' != "") {
		matrix `tobst' = e(b),`bsm'
	}
	else {
		matrix `tobst' = e(b)
	}

	tempname rb rV rse rbias rb_bs rlevel ///
		rci_normal rci_percentile rz0 rci_bc 
	matrix `rb' = `tobst'

	if (`"`bfile'"' != "") {
		// ordering of data could be different
		// so directly pass in varlist

		local bnames: colfullnames `rb'
		matrix `rb_bs' = `rb'
		matrix `rse' = `rb'
	
		matrix `rci_percentile' = `rb' \ `rb'
		matrix `rci_bc' = `rci_percentile'
		matrix `rz0' = `rse'
	
		matrix colnames `rci_percentile' = `bnames'
		matrix colnames `rci_bc' = `bnames'
		matrix colnames `rz0' = `bnames'
		matrix colnames `rb_bs' = `bnames'
		matrix colnames `rse' = `bnames'

		tempname bob
		qui estimates store `bob'
		qui mean _all
		tempname tb tse
		matrix `tb' = e(b)
		matrix `tse' = e(N)*vecdiag(e(V))
		local coln = colsof(`tb')
		forvalues it=1/`coln' {
			matrix `tse'[1,`it'] = sqrt(`tse'[1,`it'])
		}
	
		scalar `rlevel' = `level'
		local alpha = 1-(`level'/100)
		local ciuba = 1-(`alpha'/2)
		local cilba = `alpha'/2
		local tcilba = 100*`cilba' 
		local tciuba = 100*`ciuba'
		local vvit = 1
		foreach var in `classvars' {
			local rib = colnumb(`rb_bs',`"`var':i_cons"')
			matrix `rb_bs'[1,`rib']= ///
				`tb'[1,colnumb(`tb',"_v`vvit'_b_i_cons")]
			matrix `rse'[1,colnumb(`rse',`"`var':i_cons"')] =  ///
				`tse'[1,colnumb(`tse',"_v`vvit'_b_i_cons")]
			qui _pctile _v`vvit'_b_i_cons, ///
				percentile(`tcilba' `tciuba')
			local rp = colnumb(`rci_percentile',`"`var':i_cons"')
			matrix `rci_percentile'[1,`rp'] = r(r1)
			matrix `rci_percentile'[2,`rp'] = r(r2) 
			qui count if _v`vvit'_b_i_cons <= ///
				`rb'[1,colnumb(`rb',`"`var':i_cons"')]
			tempname z0
			scalar `z0' = invnormal(r(N)/_N)
			matrix `rz0'[1,colnumb(`rz0',`"`var':i_cons"')] = `z0'
			local p1 = 100*normal(`z0'+ (`z0'-invnormal(`ciuba')))
			local p2 = 100*normal(`z0'+ (`z0'+invnormal(`ciuba')))
		
			local icoln =colnumb(`rci_bc',`"`var':i_cons"')
			if(`p1' == . | `p2' == .) {
				matrix `rci_bc'[1,`icoln'] = .
				matrix `rci_bc'[2,`icoln'] = .
			}
			else {
				_pctile _v`vvit'_b_i_cons, ///
					percentile(`p1' `p2')
				matrix `rci_bc'[1,`icoln'] = r(r1)
				matrix `rci_bc'[2,`icoln'] = r(r2)
			}	
			local rsb = colnumb(`rb_bs',`"`var':s_cons"')
			matrix `rb_bs'[1,`rsb']= ///
				`tb'[1,colnumb(`tb',"_v`vvit'_b_s_cons")]
			matrix `rse'[1,colnumb(`rse',`"`var':s_cons"')] = ///
				`tse'[1,colnumb(`tse',"_v`vvit'_b_s_cons")]
			qui _pctile _v`vvit'_b_s_cons , ///
				percentile(`tcilba' `tciuba')
			local rp = colnumb(`rci_percentile',`"`var':s_cons"')
			matrix `rci_percentile'[1,`rp'] = r(r1)
			matrix `rci_percentile'[2,`rp'] = r(r2) 
			qui count if _v`vvit'_b_s_cons <= ///
				`rb'[1,colnumb(`rb',`"`var':s_cons"')]
			tempname z0
			scalar `z0' = invnormal(r(N)/_N)
			matrix `rz0'[1,colnumb(`rz0',`"`var':s_cons"')] = `z0'
			local p1 = 100*normal(`z0'+ (`z0'-invnormal(`ciuba')))
			local p2 = 100*normal(`z0'+ (`z0'+invnormal(`ciuba')))
			local scoln = colnumb(`rci_bc',`"`var':s_cons"')
			if(`p1' == . | `p2' == .) {
				matrix `rci_bc'[1,`scoln'] = .
				matrix `rci_bc'[2,`scoln'] = .
			}
			else {
				_pctile _v`vvit'_b_s_cons, ///
					percentile(`p1' `p2')
				matrix `rci_bc'[1,`scoln'] = r(r1)
				matrix `rci_bc'[2,`scoln'] = r(r2)
			}
				
			local roccov `e(roccov)'
			local rcit = 1
			foreach rc in `e(roccov)' {
				local rcib = colnumb(`rb_bs',`"`var':`rc'"')
				local tcib = colnumb(`tb',"_v`vvit'_b_`rcit'")
				matrix `rb_bs'[1,`rcib'] = `tb'[1,`tcib']
				local rcsb = colnumb(`rse',`"`var':`rc'"')
				local tcsb = colnumb(`tse',"_v`vvit'_b_`rcit'")
				matrix `rse'[1,`rcsb'] = `tse'[1,`tcsb']
				qui _pctile _v`vvit'_b_`rcit' , ///
					percentile(`tcilba' `tciuba')
				local rp = colnumb( /// 
					`rci_percentile',`"`var':`rc'"')
				matrix `rci_percentile'[1,`rp'] ///
					= r(r1)
				matrix `rci_percentile'[2,`rp'] ///
					= r(r2) 
				qui count if _v`vvit'_b_`rcit' <= ///
					`rb'[1,colnumb(`rb',`"`var':`rc'"')]
				tempname z0
				scalar `z0' = invnormal(r(N)/_N)
				local rciz0 =colnumb(`rz0',`"`var':`rc'"')
				matrix `rz0'[1,`rciz0'] = `z0'
				
				local p1 = 100*normal(`z0'+ (`z0'- ///
					invnormal(`ciuba')))
				local p2 = 100*normal(`z0'+ (`z0'+ ///
					invnormal(`ciuba')))
				local rcibc = colnumb(`rci_bc',`"`var':`rc'"')
				if(`p1' == . | `p2' == .) {
					matrix `rci_bc'[1,`rcibc'] = .
					matrix `rci_bc'[2,`rcibc'] = .
				}
				else {
					_pctile _v`vvit'_b_`rcit', ///
						percentile(`p1' `p2')
					matrix `rci_bc'[1,`rcibc'] = r(r1)
					matrix `rci_bc'[2,`rcibc'] = r(r2)
				}
				local rcit = `rcit' + 1
			}

			if ("`roc'" != "") {
				local f: word count `roc'
				forvalues j=1/`ncovobs' {
					forvalues i = 1/`f' {
					RGE, 				///
						i(`i') 			///
						j(`j') 			///
						var(`var') 		///
						vvit(`vvit') 		///
						var(`var') 		///
						rci_percentile( 	///
						`rci_percentile') 	///
						rb(`rb') 		///
						rz0(`rz0') 		///
						rb_bs(`rb_bs') 		///
						tb(`tb') 		///
						rse(`rse') 		///
						tse(`tse') 		///
						tcilba(`tcilba') 	///
						tciuba(`tciuba') 	///
						rci_bc(`rci_bc')	///
						ciuba(`ciuba')		///
						cilba(`cilba')	
	 
					}
				}
			}
			if ("`invroc'" != "") {
				local f: word count `invroc'
				forvalues j=1/`ncovobs' {
					forvalues i = 1/`f' {
						IGE, 			///
						i(`i') 			///
						j(`j') 			///
						var(`var') 		///
						vvit(`vvit') 		///
						var(`var') 		///
						rci_percentile( 	///
						`rci_percentile') 	///
						rb(`rb') 		///
						rz0(`rz0') 		///
						rb_bs(`rb_bs') 		///
						tb(`tb') 		///
						rse(`rse') 		///
						tse(`tse') 		///
						tcilba(`tcilba') 	///
						tciuba(`tciuba') 	///
						rci_bc(`rci_bc')	///
						ciuba(`ciuba')		///
						cilba(`cilba')	

					}
				}
			}
			local vvit = `vvit' + 1
		}
	
		qui estimates restore `bob'
		qui estimates drop `bob'
		matrix `rbias' = `rb' - `rb_bs'
		matrix colnames `rbias' = `bnames'
		matrix `rci_normal' = ///
		`rb'-invnormal(`ciuba')*`rse' \ `rb'+invnormal(`ciuba')*`rse'
	}
	// initialize nobootstrap as an alternate bootstrap indicator for the 
	// following sub-program calls
	if (`"`bfile'"' == "") {
		local nobootstrap = `"nobootstrap"'
	}

	// display time
	if(`"`roc'"' != "") {
		di ""
		di as text "ROC curve"
		foreach var of local classvars {
			di ""
			di as text "   Status    : " as result `"`e(refvar)'"'
			di as text "   Classifier: " as result `"`var'"' 	
			
			forvalues j = 1/`ncovobs' {
				GDisEmp_GP, classvar(`"`var'"')   ///
						stat("roc") 	  ///	
						statlist(`roc')   ///
						`nobootstrap' 	  ///
						level(`level') 	  ///
						covnumb(`j') 	  ///
						rb(`rb') 	  ///
						iregvarsmat(	  ///
						`iregvarsmat')    ///
						rci_percentile(   ///
						`rci_percentile') ///
						rci_bc(`rci_bc')  ///
						rbias(`rbias') 	  ///
						rse(`rse') 	  ///
						link(`e(link)')   ///
						rci_normal(	  ///
						`rci_normal')
			}
		}
	}
	if(`"`invroc'"' != "") {
		di ""
		di as text "False-positive rate"
		foreach var of local classvars {
			di ""
			di as text "   Status    : " as result `"`e(refvar)'"'
			di as text "   Classifier: " as result `"`var'"'
		 
			forvalues j = 1/`ncovobs' { 	
				GDisEmp_GP, 	classvar(`"`var'"')	   ///
						stat("invroc") 		   ///
						statlist(`invroc') 	   ///
						`nobootstrap' 		   ///
						level(`level') 		   ///
						covnumb(`j') 		   ///
						rb(`rb') 		   ///
						iregvarsmat(`iregvarsmat') ///
						rci_percentile( 	   ///
						`rci_percentile') 	   ///
						rci_bc(`rci_bc') 	   ///
						rbias(`rbias') 		   ///
						rse(`rse') 		   ///
						link(`e(link)') 	   ///
						rci_normal(`rci_normal')
			}
		}
	}

	// prepare reference line graph, if necessary
	if (`"`norefline'"' == "") {
		local rlgraph ///
		(function y=x, ///
			range(0 1) ///
			n(2) ///
			lstyle(refline) ///
			yvarlabel("Reference") ///
			`rlopts' /// graph opts
			)
	}


	// now prepare ROC curve graphs
	local it = 1
	local i = 1
	local sgraphl
	foreach var of local classvars {
		forvalues k=1/`ncovobs' {
			local opts `"`line`it'opts'"'
			if(`"`opts'"' == "") {
				local a = mod(`it',15)+1
				local opts lstyle(p`a'line)
			}
			local legendordlist = `"`legendordlist' `it'"'
			tempname sgintercept_`i'_`k' sgslope_`i'_`k'
			scalar `sgintercept_`i'_`k'' = ///
				`rb'[1,colnumb(`rb',`"`var':i_cons"')]
			scalar `sgslope_`i'_`k'' = ///
				`rb'[1,colnumb(`rb',`"`var':s_cons"')]		
			assert `sgslope_`i'_`k''!=. & `sgintercept_`i'_`k'' !=.
			local roccov `e(roccov)'
			foreach ivar of local roccov {
				local ivi = colnumb(`iregvarsmat',`"`ivar'"')
				local iv2 = colnumb(`rb',`"`var':`ivar'"')
				scalar `sgintercept_`i'_`k'' = ///
					`sgintercept_`i'_`k''+ ///
					`iregvarsmat'[`k',`ivi']*`rb'[1,`iv2']
			}
			
			assert `sgslope_`i'_`k''!=. & `sgintercept_`i'_`k''!=.
			if(`"`link'"' == "logit") {
local sgraphl `sgraphl' (function y = (x==1) + (x>0)*(x<1)*(1/(1+exp(-(`sgintercept_`i'_`k''+`sgslope_`i'_`k''*logit(.3*(x<=0)+ 0*(x>=1)+(x>0)*(x<1)*x))))), range(0 1) `opts')
			}
			else {
local sgraphl `sgraphl' (function y = (x==1) + (x>0)*(x<1)*normal(`sgintercept_`i'_`k''+`sgslope_`i'_`k''*invnormal(.3*(x<=0)+ 0*(x>=1)+(x>0)*(x<1)*x)), range(0 1) `opts')
			}
			local it = `it' + 1
		}
		local i = `i' + 1
	}

	//ready CI's for ROC and invROC, prepare to graph them
	if (`"`btype'"' == "n") {
		local cilab = "ci_normal"
	}
	else if (`"`btype'"' == "bc") {
		local cilab = "ci_bc"
	}
	else {
		local cilab = "ci_percentile"
	}	
	if (`"`roc'"' != "") {
		local v: word count `roc'
		local i = 1
		local it1 = 1
		local vvit = 1
		foreach var of local classvars {
			forvalues k=1/`ncovobs' {
				local peopts
				local ciopts

				tempvar rocp_`vvit'_`k' 
				tempvar rocl_`vvit'_`k' 
				tempvar rocu_`vvit'_`k' 
				tempvar roc_num
				qui gen double `rocp_`vvit'_`k'' = .
				if (`"`nobootstrap'"' == "") {
					qui gen double `rocl_`vvit'_`k'' = .
					qui gen double `rocu_`vvit'_`k'' = .
				}
				qui gen double `roc_num' = .
				local it = 1
				foreach num of numlist `roc' {
					qui replace `roc_num' = `num' ///
						if _n == `it'
					local ind `"`var':roc_`it'_`k'"'
					local rbi = colnumb(`rb',"`ind'")
					qui replace `rocp_`vvit'_`k''= ///
						`rb'[1,`rbi'] if _n == `it'
					local rcbr=colnumb(`r`cilab'',"`ind'")
					local nob = `"`nobootstrap'"' == ""
					if (`nob') {
						local val `r`cilab''[1,`rcbr']
					}
					else {
						local val  .
					}
					qui replace ///
						`rocl_`vvit'_`k''=`val' ///
						 if _n == `it'
					if (`nob') {
						local val `r`cilab''[2,`rcbr']
					}
					else {
						local val .
					}
					qui replace ///
						`rocu_`vvit'_`k''=`val' ///
						 if _n == `it'

					local it = `it' + 1
				}
				local jind = mod(`it1',15) + 2
				if (`jind' == 16) {
					local jind = 1
				}
				if(`"`ciopts'"' == "") {
					local ciopts lstyle(p`jind'solid)
				}
				if(`"`peopts'"' == "") {
					local peopts mstyle(p`jind')
				}
				if (`"`nobootstrap'"' == "") {
local rocgraph `rocgraph' (rcap `rocl_`vvit'_`k'' `rocu_`vvit'_`k'' `roc_num', `ciopts')
				}
local procgraph `procgraph' (scatter `rocp_`vvit'_`k'' `roc_num', `peopts')
				local it1 = `it1' + 1
			}
			local i = `i' + 1
			local vvit = `vvit' + 1
		}
	}
	if (`"`invroc'"' != "") {
		local v: word count `invroc'
		local i = 1
		local it1 = 1
		local vvit = 1
		foreach var of local classvars {
			forvalues k=1/`ncovobs' {
				local peopts
				local ciopts

				tempvar invrocp_`vvit'_`k' 
				tempvar invrocl_`vvit'_`k' 
				tempvar invrocu_`vvit'_`k' 
				tempvar invroc_num
				qui gen double `invrocp_`vvit'_`k'' = .
				if (`"`nobootstrap'"' == "") {
					qui gen double `invrocl_`vvit'_`k'' = .
					qui gen double `invrocu_`vvit'_`k'' = .
				}
				qui gen double `invroc_num' = .
				local it = 1
				foreach num of numlist `invroc' {
					qui replace `invroc_num' = ///
						`num' if _n == `it'	
					local ind `"`var':invroc_`it'_`k'"'
					local rbi =colnumb(`rb',"`ind'")
					qui replace `invrocp_`vvit'_`k'' ///
						=`rb'[1,`rbi'] if _n == `it'
					
					local rci =colnumb(`r`cilab'',"`ind'")
					local val .
					if (`"`nobootstrap'"' == "") {
						local val `r`cilab''[1,`rci']
					}
					qui replace `invrocl_`vvit'_`k'' ///
						= `val' if _n == `it'
					local val .
					if (`"`nobootstrap'"' == "") {
						local val `r`cilab''[2,`rci']
					}
					qui replace `invrocu_`vvit'_`k'' ///
						= `val' if _n == `it'
					local it = `it' + 1
				}
			
				local jind = mod(`it1',15) + 2
				if (`jind' == 16) {
					local jind = 1
				}
				if(`"`ciopts'"' == "") {
					local ciopts lstyle(p`jind'solid)
				}
				if(`"`peopts'"' == "") {
					local peopts mstyle(p`jind')
				}

				if (`"`nobootstrap'"' == "") {
local invrocgraph `invrocgraph' (rcap `invrocl_`vvit'_`k'' `invrocu_`vvit'_`k'' `invroc_num', horizontal `ciopts')
				}
local pinvrocgraph `pinvrocgraph' (scatter `invroc_num' `invrocp_`vvit'_`k'', `peopts')
				local it1 = `it1' + 1
			}
			local i = `i' + 1
			local vvit = `vvit' + 1
		}
	}
		
	// prepare legend and aspectratio
	if (`"`legend'"' == "") {
		//user did not specify a legend option
		// get a legend label list together
		local it = 1
		local varcnt: word count `classvars'
		foreach var of local classvars {
			local vf `label_`var''
			if (`"`vf'"' == "") {
				local vf `var'
			}
			local legendmac `"`legendmac'- `"`vf'"'"'
			if (`ncovobs'>1) {
				forvalues k = 1/`ncovobs' {
					if (`k' == 1) {
						local legendmac ///
						`legendmac' `it' `"At `k'"'
					}
					else {
						local legendmac ///
						`legendmac'- `" "' `it' ///
						 `"At `k'"'
					}
					local it = `it'+1
				}
			}
			else {
				local legendmac `legendmac' `it' `""'
				local it = `it' + 1
			}
		}
		local f = `ncovobs'*`varcnt'+`varcnt'
		local legendmac ///
			`"legend(order(`legendmac') cols(2))"'
		local legend `legendmac'
	}
	else {
		local legend legend(`legend')
	}

	if(`"`aspectratio'"' == "") {
		local aspectratio aspectratio(1)
	}
	else {
		local aspectratio aspectratio(`aspectratio')
	}

	// draw plot
	twoway 	`sgraphl' 	///
		`rlgraph' 	///
		`rocgraph'	///
		 `procgraph' 	///
		`invrocgraph' 	///
		`pinvrocgraph', ///
			`aspectratio' 		///
			xtitle("False-positive rate") 		///
			ytitle("True-positive rate (ROC)") 	///
			xlabel(0(.25)1,grid) 		///	
			ylabel(0(.25)1,grid) 		///
			`legend' `options' 

end

// called for a specific classvar, and covariate number 
program GDisEmp_GP
	syntax, 	classvar(name) 			///
			stat(string) 			///
			statlist(numlist) 		///
			[nobootstrap] 			///
			level(cilevel) 			///
			covnumb(integer) 		///
			rb(name) 			///
			[iregvarsmat(name)] 		///
			[rci_percentile(name)] 		///
			[rci_bc(name)] 			///
			[rbias(name)] 			///
			[rse(name)] 			///
			link(string) 			///
			[rci_normal(name)]
			
	if (`"`stat'"' == "pauc") {
		local stabat pAUC
	}
	else if (`"`stat'"' == "invroc") {
		local stabat invROC
	}
	else {
		local stabat = upper(`"`stat'"') 
	}				
			
	if (`"`bootstrap'"'=="nobootstrap") {
		local nobootstrap nobootstrap
	}
	else {
		local nobootstrap ""
	}

	local j = `covnumb'

	if (`"`iregvarsmat'"' != "") {
		di ""
		di "Under covariates: "
		local a = colsof(`iregvarsmat')
		matlist `iregvarsmat'[`j',1..`a']'
		di
	}
	DC
	di as text "{hline 13}{c TT}{hline 64}"
	local dcol = 14 - length(`"`stat' "')
	di as text _col(14) "{c |}" _col(19) ///
		"Observed" _col(42) "Bootstrap"
	local llen = 0
	// 10s place
	local llen = `llen' + 2
	if (floor(`level') != `level') {
		// decimal point
		local llen = `llen' + 1
	}
	if (100*(`level'-floor(`level')) > 9) {
		// tenth's place
		local llen = `llen' + 1
	}
	if (100*(`level'-floor(`level'))/10 != ///
		floor(100*(`level'-floor(`level'))/10)) {
		// hundredth's place
		local llen = `llen' + 1
	}
	local al = 58 -`llen'


	di as text  _col(`dcol') `"`stabat' "' _col(14) "{c |}" ///
		 _col(22) "Coef." _col(34) "Bias" ///
		_col(42) "Std. Err." _col(`al') ///
		"[`=strsubdp("`level'")'% Conf. Interval]"

	di as text "{hline 13}{c +}{hline 64}"
	tempname eb
	matrix `eb' = `rb'

	tempname ecin
	tempname ecip
	tempname ecibc 
	tempname bias
	tempname semat
	if(`"`nobootstrap'"' == "") {
		matrix `ecin' = `rci_normal'
		matrix `ecip' = `rci_percentile'
		matrix `ecibc' = `rci_bc'
		matrix `bias' = `rbias'
		matrix `semat' = `rse'
	}
	else {
		local matnames: colfullnames `eb'
		matrix `ecin' = J(2,colsof(`eb'),.)
		matrix colnames `ecin' = `matnames'
		matrix `ecip' = J(2,colsof(`eb'),.)
		matrix colnames `ecip' = `matnames'
		matrix `ecibc' = J(2,colsof(`eb'),.)
		matrix colnames `ecibc' = `matnames'
		matrix `bias' = J(1,colsof(`eb'),.)
		matrix colnames `bias' = `matnames'
		matrix `semat' = J(1,colsof(`eb'),.)
		matrix colnames `semat' = `matnames'
	}	

	local i = 1
	foreach num of numlist `statlist' {
		local cl = colnumb(`eb',`"`classvar':`stat'_`i'_`j'"')
		di as text _col(4) %9.0g `num' _col(14) "{c |}" as result ///
			_col(18) %9.0g `eb'[1,`cl'] 			  ///
			_col(29) %9.0g `bias'[1,`cl'] 			  ///
			_col(41) %9.0g `semat'[1,`cl'] 			  ///
			_col(54) %9.0g `ecin'[1,`cl'] 			  ///
			_col(65) %9.0g `ecin'[2,`cl'] 			  ///
			_col(76) as text "(N)"
		di as text _col(14) "{c |}" as result			  ///
			_col(54) %9.0g `ecip'[1,`cl'] 			  ///
			_col(65) %9.0g `ecip'[2,`cl'] 			  ///
			_col(76) as text "(P)"
		di as text _col(14) "{c |}" as result			  ///
			_col(54) %9.0g `ecibc'[1,`cl'] 			  ///
			_col(65) %9.0g `ecibc'[2,`cl'] 			  ///
		_col(75) as text "(BC)"
		local i = `i'+1
	}
	di as text "{hline 13}{c BT}{hline 64}"

end

program GRocRegPEstat_Margin
	syntax [if] [in], 	[bfile(string)] 	///
				[roc(numlist) 		///
				INVroc(numlist) 	///
				Level(cilevel) 		///
				classvars(string)	///
				btype(string) norefline] * 

	// check that roc and invroc arguments legal
	if(`"`roc'"' != "") {
		foreach num of numlist `roc' {
			capture assert `num' > 0 & `num' < 1
			if (_rc != 0) {
				noi di as error ///
				"roc() inputs must be in (0,1)"
				error 198
			}
		}
	}

	if(`"`invroc'"' != "") {
		foreach num of numlist `invroc' {
			capture assert `num' > 0 & `num' < 1
			if (_rc != 0) {
				noi di as error ///
				"invroc() inputs must be in (0,1)"
				error 198
			}
		}
	}



	local graph graph

	// mark sample and load covariate values into matrix
	// before bootstrap data used
	if (`"`classvars'"' == "") {
		local classvars `e(classvars)'
	}

	qui marksample touse
	foreach var of varlist `classvars' {
		markout `touse' _roc_`var' _fpr_`var'
	}

	local tousecnt = r(N)
	capture assert `tousecnt' > 0 
	if (_rc != 0) {
		noi di as error ///
		"no observations"
		exit 2000
	}
	
	foreach vf of local classvars {
		local label_`vf': variable label `vf'
	}
	// number of graphs, observations times each classvar
	local ngr : word count `classvars'

	
	//sample marked, parse remaining syntax

	local parseit ASPECTratio(string) LEGend(string asis) RLOPTs(string)
	forvalues i = 1/`ngr' {
		local parseit `parseit' line`i'opts(string) plot`i'opts(string)
	}
	local parseit `parseit' *
	local 0 , `options'
	syntax, [`parseit']

	_get_gropts, graphopts(`options') gettwoway
	capture assert "`s(graphopts)'" == ""
	if (_rc) {
		local f: word 1 of `s(graphopts)'
		tokenize `"`f'"', parse(" (")
		local f1 `1'
		tokenize `"`f'"', 
		local f2 `1'
		if (`"`f1'"' != `"`f2'"') {
			local f `f1'()
		}
		else {
			local f `f1'
		}
		di as error `"option `f' not allowed"'
		exit 198
	}
	if(`"`refline'"' == "norefline") {
		local norefline norefline
	}

 
	local link `"`e(link)'"'
	local refvar	`"`e(refvar)'"'
	local ctrlmodel	`"`e(ctrlmodel)'"'
	local ctrlcov	`"`e(ctrlcov)'"'
	
	tempname tmat
	matrix `tmat' = e(b)

	// prepare ROC curve and ROC scatter graphs
	local legenordlist_pt 
	local legenordlist_ln
	local vcnt: word count `classvars'
	local i = 1
	local vvit = 1
	foreach var of varlist `classvars' {
		local j = `vcnt' + `i'
		local vf: variable label `var'
		if (`"`vf'"' == "") {
			local vf `var'
		}
		local legendordlist_pt=`"`legendordlist_pt' `i' `"`vf'"'"'
		local legendordlist_ln=`"`legendordlist_ln' `j' `"`vf' Fit"'"'
		local opts `"`plot`i'opts'"'
		if(`"`opts'"' == "") {
			local opts mstyle(p`i')
		}
		local opts connect(i) `opts'

	        local sgraphsp `sgraphsp'         			///
        	      (connected _roc_`var' _fpr_`var'  if `touse',  	///
                	          sort(_fpr_`var' _roc_`var') 		///
                        	   `opts'                 		///
	               )
		local opts `"`line`i'opts'"'
		if(`"`opts'"' == "") {
			local opts lstyle(p`i'line)
		}
		tempname `vvit'cons `vvit'slope
		scalar ``vvit'cons' = ///
			`tmat'[1,colnumb(`tmat',`"`var':i_cons"')]
		scalar ``vvit'slope' = ///
			`tmat'[1,colnumb(`tmat',`"`var':s_cons"')]
		if(`"`link'"' != `"probit"') {
local sgraphsl `sgraphsl' (function y = 0*(x==0) + (x==1) + (x>0)*(x<1)*(1/(1+exp(-(``vvit'cons'+``vvit'slope'*logit(.3*(x<=0)+ .3*(x>=1)+(x>0)*(x<1)*x))))), range(0 1) `opts')
		}
		else {
local sgraphsl `sgraphsl' (function y = 0*(x==0)+(x==1) + (x>0)*(x<1)*normal(``vvit'cons'+``vvit'slope'*invnormal(.3*(x<=0)+ .3*(x>=1)+(x>0)*(x<1)*x)),  range(0 1) `opts')
		}
		local i = `i' + 1
		local vvit = `vvit' + 1
	}

	local classvarcnt: word count `classvars'

	local ncovobs = 1

	// we've gotten all we need from sample
	// get bootstrap results
	if (`"`bfile'"' != "") {
		preserve
		qui use `bfile', clear
		// rename variables as needed
		// classvar index 
		// roccov index
		local keeplist 
		foreach verb of varlist _all {
			local f: variable label `verb'
			local vvit = 1
			foreach var in `classvars' {
				if (`"`f'"' == `"[`var']_b[i_cons]"') {
					rename `verb' _v`vvit'_b_i_cons
					local keeplist ///
						`keeplist' _v`vvit'_b_i_cons
				}
				if (`"`f'"' == `"[`var']_b[s_cons]"') {
					rename `verb' _v`vvit'_b_s_cons
					local keeplist ///
						`keeplist' _v`vvit'_b_s_cons
				}
				if (`"`f'"' == `"[`var']_b[auc]"') {
					rename `verb' _v`vvit'_b_auc
					local keeplist ///
					`keeplist' _v`vvit'_b_auc		
				}
				local vvit = `vvit' + 1
			}
		}
		keep `keeplist'
	}

	if (`"`roc'"'!="") {
		// estimate ROC value for bootstrap observations
		// and observed estimate values
		tokenize
		// iteration for tokenizing later, to give colnames
		local iter = 1
		local i = 1

		local roccnt: word count `roc'
		local varcnt: word count `classvars'
		tempname rocobsmat
		matrix `rocobsmat' = J(1,`roccnt'*`varcnt'*`ncovobs',.)
	
		foreach num of numlist `roc' {
			forvalues j = 1/`ncovobs' {
				local vvit = 1	
				foreach var in `classvars' {
					local v _v`vvit'_b_roc_`i'_`j' 
					local vi _v`vvit'_b_i_cons
					local vs _v`vvit'_b_s_cons
					if (`"`link'"'=="probit") {
						local val `vs'*invnormal(`num')
						local valf normal
					}
					else {
						local val `vs'*logit(`num')
						local valf invlogit
					}

					if(`"`bfile'"' != "") {
						// realizations
						qui gen double `v'=`vi'  
						qui replace `v'=`v'+`val'
						qui replace `v'=`valf'(`v')
						qui replace `v' = 1 ///
							if `num' == 1
						qui replace `v' = 0 ///
							if `num' == 0
					}

					//observed
					tempname obs_roc_`i'_`j'_v`vvit'
					tempname bmat
					local v `obs_roc_`i'_`j'_v`vvit''
					

					matrix `bmat' = e(b)
					local bci = ///
						colnumb(`bmat',"`var':i_cons")
					local si = ///
						colnumb(`bmat',"`var':s_cons")
					local vs `bmat'[1,`si']
					scalar `v' = `bmat'[1,`bci']
					if(`"`link'"'=="probit") {
						local val `vs'*invnormal(`num')
						local valf normal
					}
					else {
						local val `vs'*logit(`num')
						local valf invlogit
					}
					scalar `v' = `bmat'[1,`bci']
					scalar `v' = `v'+`val'
					scalar `v' = `valf'(`v')
					if (inlist(`num',1,0)) {
						scalar `v' = `num'
					}

					local `iter' = "`var':roc_`i'_`j'"
					matrix `rocobsmat'[1,`iter'] = ///
						`obs_roc_`i'_`j'_v`vvit'' 
					local iter = `iter'+1
					local vvit = `vvit' + 1
				}
			}
			local i = `i'+1
		}
		matrix colnames `rocobsmat' = `*'
		if(`"`bsm'"' == "") {
			tempname bsm
			matrix `bsm' = `rocobsmat'
		} 
		else {
			matrix `bsm' = `bsm',`rocobsmat'
		}
	}


	if (`"`invroc'"'!="") {
		// estimate invROC value for bootstrap observations
		// and observed estimate values
		tokenize
		local iter = 1
		local i = 1

		local invroccnt: word count `invroc'
		local varcnt: word count `classvars'

		tempname invrocobsmat
		matrix `invrocobsmat' = J(1,`invroccnt'*`varcnt'*`ncovobs',.)

		foreach num of numlist `invroc' {
			forvalues j = 1/`ncovobs' {
				local vvit = 1
				foreach var in `classvars' {
					if(`"`bfile'"' != "") {
						//bootstrap realizations
						IRGPM, 	i(`i') 		///
							j(`j') 		///
							num(`num')	///
							link(`link')	///
							vvit(`vvit')	
					}	
					
					tempname obs_invroc_`i'_`j'_v`vvit'
					local o `obs_invroc_`i'_`j'_v`vvit''

					//observed
					IRGPMO, o(`o') 		///
						num(`num') 	///
						var(`var')	///
						link(`link')			
					local `iter' = "`var':invroc_`i'_`j'"
					matrix `invrocobsmat'[1,`iter'] = ///
						`obs_invroc_`i'_`j'_v`vvit'' 
					local iter = `iter'+1
					local vvit = `vvit' + 1
				}
			}
			local i = `i'+1
		}

		matrix colnames `invrocobsmat'= `*'
		if(`"`bsm'"' == "") {
			tempname bsm
			matrix `bsm' = `invrocobsmat'
		} 
		else {
			matrix `bsm' = `bsm',`invrocobsmat'
		}
	}

	// using previous calculation, temporarily 
	// add ROC and invROC estimation results to current estimates
	tempname tobst
	if(`"`bsm'"' != "") {
		matrix `tobst' = e(b),`bsm'
	}
	else {
		matrix `tobst' = e(b)
	}

	tempname rb rV rse rbias rb_bs rlevel rci_normal ///
			rci_percentile rz0 rci_bc 
	matrix `rb' = `tobst'

	if (`"`bfile'"' != "") {
		// ordering of data could be different
		// so directly pass in varlist

		local bnames: colfullnames `rb'
		matrix `rb_bs' = `rb'
		matrix `rse' = `rb'
	
		matrix `rci_percentile' = `rb' \ `rb'
		matrix `rci_bc' = `rci_percentile'
		matrix `rz0' = `rse'
	
		matrix colnames `rci_percentile' = `bnames'
		matrix colnames `rci_bc' = `bnames'
		matrix colnames `rz0' = `bnames'
		matrix colnames `rb_bs' = `bnames'
		matrix colnames `rse' = `bnames'

		tempname bob
	
		qui estimates store `bob'
		qui mean _all
		tempname tb tse
		matrix `tb' = e(b)
		matrix `tse' = e(N)*vecdiag(e(V))
		local coln = colsof(`tb')
		forvalues it=1/`coln' {
			matrix `tse'[1,`it'] = sqrt(`tse'[1,`it'])
		}
	
		scalar `rlevel' = `level'
		local alpha = 1-(`level'/100)
		local ciuba = 1-(`alpha'/2)
		local cilba = `alpha'/2
		local tcilba = 100*`cilba' 
		local tciuba = 100*`ciuba'
		local vvit = 1
		foreach var in `classvars' {
			local rib = colnumb(`rb_bs',`"`var':i_cons"')
			matrix `rb_bs'[1,`rib']= ///
				`tb'[1,colnumb(`tb',"_v`vvit'_b_i_cons")]
			matrix `rse'[1,colnumb(`rse',`"`var':i_cons"')]= ///
				`tse'[1,colnumb(`tse',"_v`vvit'_b_i_cons")]
			qui _pctile _v`vvit'_b_i_cons , ///
				percentile(`tcilba' `tciuba')
			local ic = ///
				colnumb(`rci_percentile',`"`var':i_cons"')
			matrix `rci_percentile'[1,`ic'] = r(r1)
			matrix `rci_percentile'[2,`ic'] = r(r2) 
			qui count if _v`vvit'_b_i_cons <= ///
				`rb'[1,colnumb(`rb',`"`var':i_cons"')]
			tempname z0
			scalar `z0' = invnormal(r(N)/_N)
			matrix `rz0'[1,colnumb(`rz0',`"`var':i_cons"')] = `z0'
			local p1 = 100*normal(`z0'+ (`z0'-invnormal(`ciuba')))
			local p2 = 100*normal(`z0'+ (`z0'+invnormal(`ciuba')))
			local rcibci = colnumb(`rci_bc',`"`var':i_cons"')
			if(`p1' == . | `p2' == .) {
				matrix `rci_bc'[1,`rcibci'] = .
				matrix `rci_bc'[2,`rcibci'] = .
			}
			else {
				_pctile _v`vvit'_b_i_cons, ///
					percentile(`p1' `p2')
				matrix `rci_bc'[1,`rcibci'] = r(r1)
				matrix `rci_bc'[2,`rcibci'] = r(r2)
			}	
		
			local rbi = colnumb(`rb_bs',`"`var':s_cons"')
			matrix `rb_bs'[1,`rbi']= ///
				`tb'[1,colnumb(`tb',"_v`vvit'_b_s_cons")]
			matrix `rse'[1,colnumb(`rse',`"`var':s_cons"')]= ///
				`tse'[1,colnumb(`tse',"_v`vvit'_b_s_cons")]
			qui _pctile _v`vvit'_b_s_cons, ///
				percentile(`tcilba' `tciuba')
			local sc = colnumb(`rci_percentile',`"`var':s_cons"')
			matrix `rci_percentile'[1,`sc'] = r(r1)
			matrix `rci_percentile'[2,`sc'] = r(r2) 
			qui count if _v`vvit'_b_s_cons <= ///
				`rb'[1,colnumb(`rb',`"`var':s_cons"')]
			tempname z0
			scalar `z0' = invnormal(r(N)/_N)
			matrix `rz0'[1,colnumb(`rz0',`"`var':s_cons"')] = `z0'
			local p1 = 100*normal(`z0'+ (`z0'-invnormal(`ciuba')))
			local p2 = 100*normal(`z0'+ (`z0'+invnormal(`ciuba')))
			
			local rcbs= colnumb(`rci_bc',`"`var':s_cons"')
			if(`p1' == . | `p2' == .) {
				matrix `rci_bc'[1,`rcbs'] = .
				matrix `rci_bc'[2,`rcbs'] = .
			}
			else {
				_pctile _v`vvit'_b_s_cons, ///
					percentile(`p1' `p2')
				matrix `rci_bc'[1,`rcbs'] = r(r1)
				matrix `rci_bc'[2,`rcbs'] = r(r2)
			}
				
			if ("`roc'" != "") {
				local f: word count `roc'
				forvalues j=1/`ncovobs' {
					forvalues i = 1/`f' {
						local arp `rci_percentile'
						RGM, 	i(`i') 		 ///
						 	j(`j') 		 ///
							rb_bs(`rb_bs') 	 ///
							tb(`tb') 	 ///
							rse(`rse') 	 ///
							tse(`tse') 	 ///
							tcilba(`tcilba') /// 
							tciuba(`tciuba') ///
							cilba(`cilba') 	 ///
							ciuba(`ciuba') 	 ///
							rp(`arp')	 ///
							rz0(`rz0') 	 ///
							rci_bc(`rci_bc') ///
							var(`var')	 ///
							vvit(`vvit')	///
							rb(`rb')
					}
				}
			}
		
			if ("`invroc'" != "") {
				local f: word count `invroc'
				forvalues j=1/`ncovobs' {
					forvalues i = 1/`f' {
						local arp `rci_percentile'
						IRGM, 	i(`i') 		 ///
						 	j(`j') 		 ///
							rb_bs(`rb_bs') 	 ///
							tb(`tb') 	 ///
							rse(`rse') 	 ///
							tse(`tse') 	 ///
							tcilba(`tcilba') /// 
							tciuba(`tciuba') ///
							ciuba(`ciuba') 	 ///
							cilba(`cilba') 	 ///
							rp(`arp')	 ///
							rz0(`rz0') 	 ///
							rci_bc(`rci_bc') ///
							var(`var')	 ///
							vvit(`vvit')	///
							rb(`rb')
					}
				}
			}
		
			local vvit = `vvit' + 1
		}
		qui estimates restore `bob'
		qui estimates drop `bob'
		matrix `rbias' = `rb' - `rb_bs'
		matrix colnames `rbias' = `bnames'
		matrix `rci_normal' = ///
		`rb' - invnormal(`ciuba')*`rse' \ `rb' + ///
			invnormal(`ciuba')*`rse'
	}
	// initialize nobootstrap as an alternate bootstrap indicator for the 
	// following sub-program calls
	if (`"`bfile'"' == "") {
		local nobootstrap = `"nobootstrap"'
		
	}

	// display time
	
	if(`"`roc'"' != "") {
		di ""
		di as text "ROC curve"
		foreach var of local classvars {
			di ""
			di as text "   Status    : " as result `"`e(refvar)'"'
			di as text "   Classifier: " as result `"`var'"' 	
			forvalues j = 1/`ncovobs' {
				local arp `rci_percentile'
				GDisEmp_GP,	classvar(`"`var'"') 	   ///
					    	stat("roc") 		   ///
						statlist(`roc') 	   ///
						`nobootstrap' 		   ///
					    	level(`level') 		   ///
						covnumb(`j') 		   ///
						rb(`rb') 		   ///
						iregvarsmat(`iregvarsmat') ///
						rci_percentile(`arp')      ///
						rci_bc(`rci_bc') 	   ///
						rbias(`rbias') 		   ///
						rse(`rse') 		   ///
						link(`e(link)') 	   /// 
						rci_normal(`rci_normal')
			}
		}
	}
	if(`"`invroc'"' != "") {
		di ""
		di as text "False-positive rate"
		foreach var of local classvars {
			di ""
			di as text "   Status    : " as result `"`e(refvar)'"'
			di as text "   Classifier: " as result `"`var'"'
			forvalues j = 1/`ncovobs' { 	
				local arp `rci_percentile'
				GDisEmp_GP, 	classvar(`"`var'"') 	   ///
						stat("invroc") 		   ///
						statlist(`invroc') 	   ///
						`nobootstrap' 		   ///
						level(`level') 		   ///
						covnumb(`j') 		   ///
						rb(`rb') 		   ///
						iregvarsmat(`iregvarsmat') ///
						rci_percentile(`arp') 	   ///
						rci_bc(`rci_bc') 	   ///
						rbias(`rbias') 		   ///
						rse(`rse') 		   ///
						link(`e(link)') 	   ///
						rci_normal(`rci_normal')
			}
		}
	}
	// prepare reference line graph, if necessary
	if (`"`norefline'"' == "") {
		local rlgraph ///
		(function y=x, range(0 1) ///
				n(2) ///
				lstyle(refline) ///
				yvarlabel("Reference") ///
				`rlopts' /// graph opts
		)
	}

	//ready CI's for ROC and invROC, prepare to graph them
	if(`"`nobootstrap'"' == "") {
		restore
	}
	if (`"`btype'"' == "n") {
		local cilab = "ci_normal"
	}
	else if (`"`btype'"' == "bc") {
		local cilab = "ci_bc"
	}
	else {
		local cilab = "ci_percentile"
	}	
	if (`"`roc'"' != "") {
		local v: word count `roc'
		capture assert _N > `v'
		local i = 1
		local it1 = 1
		local vvit = 1
		foreach var of local classvars {
			forvalues k=1/`ncovobs' {
				local peopts 
				local ciopts
				tempvar rocp_`vvit'_`k' 
				tempvar rocl_`vvit'_`k' 
				tempvar rocu_`vvit'_`k' 
				tempvar roc_num
				qui gen double `rocp_`vvit'_`k'' = .
				if (`"`nobootstrap'"' == "") {
					qui gen double `rocl_`vvit'_`k'' = .
					qui gen double `rocu_`vvit'_`k'' = .
				}
				qui gen double `roc_num' = .
				local it = 1
				foreach num of numlist `roc' {
					qui replace `roc_num' = `num' ///
						if _n == `it'
					local vind `"`var':roc_`it'_`k'"'
					local rbi = colnumb(`rb',`"`vind'"')
					qui replace `rocp_`vvit'_`k'' = ///
						`rb'[1,`rbi'] if _n == `it'
					local ici=colnumb(`r`cilab'',"`vind'")	
					local rcm `r`cilab''
					if (`"`nobootstrap'"' == "") {
						qui replace               ///
							`rocl_`vvit'_`k'' ///
							=`rcm'[1,`ici']   ///
							if _n == `it'
						qui replace               ///
							`rocu_`vvit'_`k'' ///
							=`rcm'[2,`ici']   ///
							if _n == `it'
					}
					local it = `it' + 1
				}
				local jind = mod(`it1',15) + 2
				if (`jind' == 16) {
					local jind = 1
				}
				if(`"`ciopts'"' == "") {
					local ciopts lstyle(p`jind'solid)
				}
				if(`"`peopts'"' == "") {
					local peopts mstyle(p`jind')
				}

				if (`"`nobootstrap'"' == "") {
local rocgraph `rocgraph' (rcap `rocl_`vvit'_`k'' `rocu_`vvit'_`k'' `roc_num', `ciopts')
				}
local procgraph `procgraph' (scatter `rocp_`vvit'_`k'' `roc_num', `peopts')
				local it1 = `it1' + 1
			}
			local i = `i' + 1
			local vvit = `vvit' + 1
		}
	}
	
	if (`"`invroc'"' != "") {
		local v: word count `invroc'
		capture assert _N > `v'
		local i = 1
		local it1 = 1
		local vvit = 1
		foreach var of local classvars {
			forvalues k=1/`ncovobs' {
				local peopts
				local ciopts
				tempvar invrocp_`vvit'_`k' 
				tempvar invrocl_`vvit'_`k' 
				tempvar invrocu_`vvit'_`k' 
				tempvar invroc_num
				qui gen double `invrocp_`vvit'_`k'' = .
				if (`"`nobootstrap'"' == "") {
					qui gen double `invrocl_`vvit'_`k''=.
					qui gen double `invrocu_`vvit'_`k''=.
				}
				qui gen double `invroc_num' = .
				local it = 1
				foreach num of numlist `invroc' {
					qui replace `invroc_num' = `num' ///
					if _n == `it'
					local vind `"`var':invroc_`it'_`k'"'
					local iv =colnumb(`rb',"`vind'")
					qui replace `invrocp_`vvit'_`k'' = ///
						`rb'[1,`iv'] if _n == `it'
					local rcm `r`cilab''
					local ivl `invrocl_`vvit'_`k''
					local ivu `invrocu_`vvit'_`k''
					if (`"`nobootstrap'"' == "") {
						qui replace `ivl' = ///
							`rcm'[1,`iv'] ///
							if _n == `it'
						qui replace `ivu' = ///
							`rcm'[2,`iv'] ///
							if _n == `it'
					}
					local it = `it' + 1
				}			
				local jind = mod(`it1',15) + 2
				if (`jind' == 16) {
					local jind = 1
				}
				if(`"`ciopts'"' == "") {
					local ciopts lstyle(p`jind'solid)
				}
				if(`"`peopts'"' == "") {
					local peopts mstyle(p`jind')
				}

				if (`"`nobootstrap'"' == "") {
local invrocgraph `invrocgraph' (rcap `invrocl_`vvit'_`k'' `invrocu_`vvit'_`k'' `invroc_num', horizontal `ciopts')
				}
local pinvrocgraph `pinvrocgraph' (scatter `invroc_num' `invrocp_`vvit'_`k'', `peopts')
				local it1 = `it1' + 1
			}
			local i = `i' + 1
			local vvit = `vvit' + 1
		}
	}
		

	// prepare legend and aspectratio
	local f: word count `classvars'
	if("`legend'"=="") {
		local rowsa = 2*`f'
local legendmac `"legend(order(`legendordlist_pt' `legendordlist_ln') symxsize(*.5) row(`rowsa'))"'
local legend `legendmac'
	}
	else {
		local legend legend(`legend')
	}
	
	if(`"`aspectratio'"' == "") {
		local aspectratio aspectratio(1)
	}
	else {
		local aspectratio aspectratio(`aspectratio')
	}

	// add 0,1 fpr and roc values to observations
	// will be deleted later
	local Nmax=_N+2
	qui set obs `Nmax'
	tempvar drp
	qui gen `drp'=1 if _n>`Nmax'-2
	foreach y of varlist `classvars' {
		qui replace _fpr_`y' = 0 if _n == `Nmax'-1
		qui replace _roc_`y' = 0 if _n == `Nmax'-1
		qui replace _fpr_`y' = 1 if _n == `Nmax'
		qui replace _roc_`y' = 1 if _n == `Nmax'
	}

	qui replace `touse' = 1 if `drp' == 1


	// draw plot
	twoway `sgraphsp' 			///
		`sgraphsl' 			///
		`rlgraph' 			///
		`rocgraph'			///
		 `procgraph' 			///
		`invrocgraph' 			///
		`pinvrocgraph', 		///
			`aspectratio' 		///
			xtitle("False-positive rate") 		///
			ytitle("True-positive rate (ROC)") 	///
			xlabel(0(.25)1,grid) 		///
			ylabel(0(.25)1,grid) 		///
			`legend' 		///
			`options' 

	qui capture count if `drp' != 1
	if (_rc == 0) {
		qui drop if `drp'
	}
end


program GRocReg_EstatGNP
	syntax [if] [in] [, 	classvars(varlist) 	///
				Level(cilevel) 		///
				btype(string) norefline] *

	if(`"`refline'"' == "norefline") {
		local norefline norefline
	}
	local roc `e(roc)'
	local invroc `e(invroc)'
	if (`"`classvars'"' == "") {
		local classvars `e(classvars)'
	}
	// number of graphs
	local ngr : word count `classvars'

	// mark sample
	qui marksample touse
	foreach var of varlist `classvars' {
		markout `touse' _roc_`var' _fpr_`var'
	}

	// parse remaining syntax 

	local parseit ASPECTratio(string) LEGend(string asis) RLOPTs(string)
	forvalues i = 1/`ngr' {
		local parseit `parseit' plot`i'opts(string) 
	}
	local parseit `parseit' *
	local 0 , `options'
	syntax, [`parseit']

	_get_gropts, graphopts(`options') gettwoway
	capture assert "`s(graphopts)'" == ""
	if (_rc) {
		local f: word 1 of `s(graphopts)'
		tokenize `"`f'"', parse(" (")
		local f1 `1'
		tokenize `"`f'"', 
		local f2 `1'
		if (`"`f1'"' != `"`f2'"') {
			local f `f1'()
		}
		else {
			local f `f1'
		}
		di as error `"option `f' not allowed"'
		exit 198
	}


	// prepare reference line graph
	if (`"`norefline'"' == `""') {
		local rlgraph ///
			(function y=x, ///
			range(0 1) ///
			n(2) ///
			lstyle(refline) ///
			yvarlabel("Reference") ///
			`rlopts' /// graph opts
			)
	}

	tempname tmat
	matrix `tmat' = e(b)
		

	// prepare ROC curve plot
	local legendordlist_pt 
	local vcnt: word count `classvars'
	local i = 1
	foreach var of varlist `classvars' {
		local j = `vcnt' + `i'
		local vf: variable label `var'
		if (`"`vf'"' == "") {
			local vf `var'
		}
		local legendordlist_pt = `"`legendordlist_pt' `i' `"`vf'"'"'
		local opts `"`plot`i'opts'"'
		if(`"`opts'"' == "") {
			local opts mstyle(p`i') 
			}
		local f: subinstr local opts "connect(" "", all
		local fopt: length local opts
		local f: length local f
		if (`f' == `fopt') {
			local opts `opts' connect(J)  lstyle(p`i'line)
		}	
	
		local sgraphsp `sgraphsp' 			     	///
			(connected _roc_`var' _fpr_`var' if `touse', 	///
			sort(_fpr_`var' _roc_`var') 			///
			`opts' 						///
			)
		local i = `i' + 1
	}

	if (`"`btype'"' == `"n"') {
		local cilab = `"ci_normal"'
	}
	else if (`"`btype'"' == `"bc"') {
		local cilab = `"ci_bc"'
	}
	else {
		local cilab = `"ci_percentile"'
	}	

	// prepare ROC and invROC confidence interval plots
	if(`"`e(roc)'"' != `""') {
		tempname rb r`cilab'
		matrix `rb' = e(b)
		matrix `r`cilab'' = e(`cilab')
		
		local v: word count `roc'
		local j = 1
		local vvit = 1
		foreach var of varlist `classvars' {
			local peopts
			local ciopts

			tempvar rocp_`vvit' rocl_`vvit' rocu_`vvit' roc_num
			qui gen double `rocp_`vvit'' = .
			if (`"`e(nobootstrap)'"' == `""') {
				qui gen double `rocl_`vvit'' = .
				qui gen double `rocu_`vvit'' = .
			}
			qui gen double `roc_num' = .
			local i = 1	
			foreach num of numlist `roc' {
				qui replace `roc_num' = `num' if _n == `i'
				local vind = `"`var':roc_`i'"'
				local rbi = colnumb(`rb',`"`var':roc_`i'"')
				qui replace `rocp_`vvit'' = ///
					`rb'[1,`rbi'] ///
					if _n == `i'
				if (`"`e(nobootstrap)'"' == "") {
					local rci ///
						= colnumb(`r`cilab'',"`vind'")
					qui replace `rocl_`vvit'' = ///
						`r`cilab''[1,`rci'] if _n==`i'
					qui replace `rocu_`vvit'' = ///
						`r`cilab''[2,`rci'] if _n==`i'
				}
				local i = `i' + 1
			}
			local jind = `j' + 1
			if (`j' == 15) {
				local jind = 1
			}
			if(`"`ciopts'"' == "") {
				local ciopts lstyle(p`jind'solid)
			}
			if(`"`peopts'"' == "") {
				local peopts mstyle(p`jind')
			}

			if (`"`e(nobootstrap)'"' == "") {
				local rocgraph ///
`rocgraph' (rcap `rocl_`vvit'' `rocu_`vvit'' `roc_num', `ciopts')
			}
local procgraph `procgraph' (scatter `rocp_`vvit'' `roc_num', `peopts')
			local j = `j'+1
			local vvit = `vvit' + 1
		}	
	}

	if(`"`e(invroc)'"' != `""') {
		tempname rb r`cilab'
		matrix `rb' = e(b)
		matrix `r`cilab'' = e(`cilab')

		local v: word count `invroc'
		capture assert _N > `v'
		local j = 1
		local vvit = 1
		foreach var of varlist `classvars' {
			local peopts
			local ciopts

			tempvar invrocp_`vvit' 
			tempvar invrocl_`vvit'
			tempvar invrocu_`vvit' 
			tempvar invroc_num
			qui gen double `invrocp_`vvit'' = .
			if (`"`e(nobootstrap)'"' == `""') {		
				qui gen double `invrocl_`vvit'' = .
				qui gen double `invrocu_`vvit'' = .
			}
			qui gen double `invroc_num' = .
			local i = 1	
			foreach num of numlist `invroc' {
				local vind `"`var':invroc_`i'"'
				qui replace `invroc_num' = `num' if _n == `i'
				qui replace `invrocp_`vvit'' = ///
					`rb'[1,colnumb(`rb',"`vind'")] ///
					if _n == `i'
				if(`"`e(nobootstrap)'"' == `""') {
					local rcib = ///
						colnumb(`r`cilab'',"`vind'")
					qui replace `invrocl_`vvit'' = ///
						`r`cilab''[1,`rcib'] if _n==`i'
					qui replace `invrocu_`vvit'' = ///
						`r`cilab''[2,`rcib'] if _n==`i'
				}
				local i = `i' + 1
			}
			local jind = `j' + 1
			if (`j' == 15) {
				local jind = 1
			}
			if(`"`ciopts'"' == "") {
				local ciopts lstyle(p`jind'solid)
			}
			if(`"`peopts'"' == "") {
				local peopts mstyle(p`jind')
			}

			if (`"`e(nobootstrap)'"' == "") {		 
local invrocgraph `invrocgraph' (rcap `invrocl_`vvit'' `invrocu_`vvit'' `invroc_num', horizontal `ciopts')
			}
local pinvrocgraph `pinvrocgraph' (scatter  `invroc_num' `invrocp_`vvit'', `peopts')
			local j = `j' + 1
			local vvit = `vvit' + 1
		}	
	}

	// prepare legend and aspect ratio
	if (`"`legend'"'== "") {
		local legendmac ///
`"legend(order(`legendordlist_pt') row(`ngr'))"'
		local legend `legendmac'
	}
	else {
		local legend legend(`legend')
	}
	if(`"`aspectratio'"' == "") {
		local aspectratio aspectratio(1)
	}
	else {
		local aspectratio aspectratio(`aspectratio')
	}


	// add 0,1 values fpr and roc values to observations
	// will be deleted later
	local Nmax=_N+2
	qui set obs `Nmax'
	tempvar drp
	qui gen `drp'=1 if _n>`Nmax'-2
	foreach y of varlist `classvars' {
		qui replace _fpr_`y' = 0 if _n == `Nmax'-1
		qui replace _roc_`y' = 0 if _n == `Nmax'-1
		qui replace _fpr_`y' = 1 if _n == `Nmax'
		qui replace _roc_`y' = 1 if _n == `Nmax'
	}
	qui replace `touse' = 1 if `drp' == 1

	// draw plot
	twoway `sgraphsp'		 	///
		`rlgraph'		 	///
		`rocgraph' 		 	///
		 `procgraph' 		 	///
		`invrocgraph' 		 	///
		`pinvrocgraph', 	 	///
			`aspectratio' 	 	///
			xtitle("False-positive rate")    	///
			ytitle("True-positive rate (ROC)") 	///
			xlabel(0(.25)1,grid) 		///
			ylabel(0(.25)1,grid) 		///
			`legend' 		///
			`options' 
	qui drop if `drp'==1
end

program GRocRegPEstat_ML, rclass
	syntax [if] [in], 	[roc(numlist) 		///
				INVroc(numlist) 	///
				Level(cilevel) 		///
				classvars(string) norefline] *

	// check that roc and invroc arguments legal
	if(`"`roc'"' != "") {
		foreach num of numlist `roc' {
			capture assert `num' > 0 & `num' < 1
			if (_rc != 0) {
				noi di as error ///
				"roc() inputs must be in (0,1)"
				error 198
			}
		}
	}

	if(`"`invroc'"' != "") {
		foreach num of numlist `invroc' {
			capture assert `num' > 0 & `num' < 1
			if (_rc != 0) {
				noi di as error ///
				"invroc() inputs must be in (0,1)"				
				error 198
			}
		}
	}
	// mark sample and load covariate values into matrix

	preserve
	// start as 1, reset with added covariates
	local ncovobs = 1
	marksample touse
	qui count if `touse'
	local tousecnt = r(N)
	capture assert `tousecnt' > 0 
	if (_rc != 0) {
		noi di as error ///
			"no observations"
		exit 2000
	}
	qui markout `touse' `roccov' `sregcov'
	capture qui count if `touse'
	capture assert r(N) > 0
	if(_rc != 0) {
		noi di as error ///
			"no non-missing observations"
		exit 2000
	}
	// get covariate values in matrix
	tempname iregvarsmat
	qui mkmat `e(roccov)' if `touse', matrix(`iregvarsmat')
	local ncovobs = rowsof(`iregvarsmat')

        local iregvarsmatlabs
        if (`ncovobs'==1) {
                local iregvarsmatlabs at

        }
	else {
	        forvalues i=1/`ncovobs' {
        	        local iregvarsmatlabs `iregvarsmatlabs' at`i'
	        }
	}
        matrix rownames `iregvarsmat' = `iregvarsmatlabs'

	if(`"`refline'"' == "norefline") {
		local norefline norefline
	}

	local graph graph
	if (`"`classvars'"' == "") {
		local classvars `e(classvars)'
	}

	foreach vf of local classvars {
		local label_`vf': variable label `vf'
	}
	// number of graphs, observations times each classvar
	local ngr: word count `classvars'
	local ngr = `ngr'*`ncovobs'

	//sample marked, parse remaining syntax

	local parseit ASPECTratio(string) LEGend(string asis) RLOPTs(string)
	forvalues i = 1/`ngr' {
		local parseit `parseit' line`i'opts(string)
	}
	local parseit `parseit' *
	local 0 , `options'
	syntax, [`parseit']
	_get_gropts, graphopts(`options') gettwoway
	capture assert "`s(graphopts)'" == ""
	if (_rc) {
		local f: word 1 of `s(graphopts)'
		tokenize `"`f'"', parse(" (")
		local f1 `1'
		tokenize `"`f'"', 
		local f2 `1'
		if (`"`f1'"' != `"`f2'"') {
			local f `f1'()
		}
		else {
			local f `f1'
		}
		di as error `"option `f' not allowed"'
		exit 198
	}



	if(`"`refline'"' == "norefline") {
		local norefline norefline
	}
	local graph graph

	capture assert `"`e(cmdname)'"' == "rocreg"
	if (_rc != 0) {
		di as error "rocregplot only used after rocreg"
		exit 198
	}

	local	link `"`e(link)'"'
	local roccov `"`e(roccov)'"'
	local refvar	`"`e(refvar)'"'
	local ctrlmodel	`"`e(ctrlmodel)'"'
	local ctrlcov	`"`e(ctrlcov)'"'

	// prepare reference line graph, if necessary
	if (`"`norefline'"' == "") {
		local rlgraph (function y=x, ///
				range(0 1) ///
				n(2) ///
				lstyle(refline) ///
				yvarlabel("Reference") ///
				`rlopts' /// graph opts	
				)
	}

		
	// load covariate values into data for prediction
	clear
	if (`"`iregvarsmat'"' != "") {
		qui svmat double `iregvarsmat', names(col) 
	}
	foreach var of local classvars {
		qui gen `var' = .
	}

	// temporary estimates storage, ROC & invROC results will
	// be added to this matrix
	tempname rb
	matrix `rb' = e(b)
	local it = 1
	local i = 1

	// prepare ROC curve graphs 
	foreach var of local classvars {
		forvalues k=1/`ncovobs' {
			local opts `"`line`it'opts'"'
			if(`"`opts'"' == "") {
				local a = mod(`it',15)+1
				local opts lstyle(p`a'line)
			}
			local legendordlist = `"`legendordlist' `it'"'

			tempname sgintercept_`i'_`k' sgslope_`i'_`k'
			scalar `sgintercept_`i'_`k'' = ///
				`rb'[1,colnumb(`rb',`"`var':i_cons"')]
			scalar `sgslope_`i'_`k'' = ///
				`rb'[1,colnumb(`rb',`"`var':s_cons"')]		
			assert `sgslope_`i'_`k''!=. & `sgintercept_`i'_`k''!=.
			foreach ivar of local roccov {
				local iv1 =colnumb(`iregvarsmat',`"`ivar'"')
				local iv2 =colnumb(`rb',`"`var':`ivar'"')
				scalar `sgintercept_`i'_`k'' = ///
					`sgintercept_`i'_`k''+ ///
					`iregvarsmat'[`k',`iv1']* ///
					`rb'[1,`iv2']
			}
			assert `sgslope_`i'_`k''!=. & `sgintercept_`i'_`k''!=.
			if(`"`link'"' == "logit") {
local sgraphl `sgraphl' (function y = (x==1) + (x>0)*(x<1)*(1/(1+exp(-(`sgintercept_`i'_`k''+`sgslope_`i'_`k''*logit(.3*(x<=0)+ 0*(x>=1)+(x>0)*(x<1)*x))))), range(0 1) `opts')
			}
			else {
local sgraphl `sgraphl' (function y = (x==1) + (x>0)*(x<1)*normal(`sgintercept_`i'_`k''+`sgslope_`i'_`k''*invnormal(.3*(x<=0)+ 0*(x>=1)+(x>0)*(x<1)*x)), range(0 1) `opts')
			}
			local it = `it' + 1
		}
		local i = `i' + 1
	}

	local classvarcnt: word count `classvars'

	// add ROC and invROC input values to data

	local roc_count: word count `roc'
	local invroc_count: word count `invroc'
	local maxobs = max(`roc_count',`invroc_count',_N)
	qui set obs `maxobs'

	local invrocgraph
	local pinvrocgraph
	local rocgraph
	local procgraph

	// estimate ROC and invROC
	local cvcnt: word count `classvars'
	if (`"`roc'"' != "") {
		tempname procmat
		matrix `procmat' = J(1,`ncovobs'*`roc_count'*`cvcnt',.)
		local procmatnames 
		tempname serocmat
		matrix `serocmat' = J(1,`ncovobs'*`roc_count'*`cvcnt',.)
		local serocmatnames
		tempname cirocmat
		matrix `cirocmat' = J(2,`ncovobs'*`roc_count'*`cvcnt',.)
		local cirocmatnames
	}

	if (`"`invroc'"' != "") {
		tempname pinvrocmat
		matrix `pinvrocmat' = J(1,`ncovobs'*`invroc_count'*`cvcnt',.)
		local pinvrocmatnames 
		tempname seinvrocmat
		matrix `seinvrocmat' = J(1,`ncovobs'*`invroc_count'*`cvcnt',.)
		local seinvrocmatnames
		tempname ciinvrocmat
		matrix `ciinvrocmat' = J(2,`ncovobs'*`invroc_count'*`cvcnt',.)
		local ciinvrocmatnames
	}

	if(`"`roc'"' != "") {
		tempvar roc_num
		qui gen double `roc_num' = .
		local i = 1
		local it1 = 1
		local itmat =1
		local vvit = 1
		foreach var of local classvars {
			forvalues k=1/`ncovobs' {
				local peopts
				local ciopts
				tempvar rocp_`vvit'_`k' 
				tempvar rocl_`vvit'_`k' 
				tempvar rocu_`vvit'_`k' 
				tempvar rocse_`vvit'_`k'
				qui gen double `rocp_`vvit'_`k''=.
				qui gen double `rocl_`vvit'_`k'' =. 
				qui gen double `rocu_`vvit'_`k'' =.
				qui gen double `rocse_`vvit'_`k'' = .
				local it = 1
				foreach num of numlist `roc' {
					qui replace `roc_num' = `num' ///
						if _n == `it'
					tempvar predvar sevar inpvar
					qui gen double `inpvar' = `num'
					qui predict `predvar' 	///
						if _n == `k', 		///
						roc at(`inpvar') 	///
						classvar(`var') 	///
						se(`sevar') 		
					qui replace `rocp_`vvit'_`k'' =  ///
						`predvar'[`k'] if _n == `it'
					qui replace `rocse_`vvit'_`k''=  ///
						`sevar'[`k'] if _n == `it'
					local alpha = 1-(`level'/100)
					local ciuba = 1-(`alpha'/2)
					local cilba = `alpha'/2
					qui replace `rocu_`vvit'_`k'' = ///
						`predvar'[`k'] + 	///
						`sevar'[`k']*		///
						invnormal(`ciuba') if _n==`it'
					qui replace `rocl_`vvit'_`k'' = ///
						`predvar'[`k'] - 	///
						`sevar'[`k']*		///
						invnormal(`ciuba') if _n==`it'
					local procmatnames ///
						`procmatnames' ///
						`var':roc_`it'_`k'
					matrix `procmat'[1,`itmat'] = ///
						`predvar'[`k']
					matrix `serocmat'[1,`itmat'] = ///
						`sevar'[`k']
					matrix `cirocmat'[1,`itmat'] = 	///
						`predvar'[`k']-		///
						`sevar'[`k']*		///
						invnormal(`ciuba')
					matrix `cirocmat'[2,`itmat'] = 	///
						`predvar'[`k']+		///
						`sevar'[`k']*		///
						invnormal(`ciuba')
					local it = `it' + 1
					local itmat = `itmat'+1
				}			
				local jind = mod(`it1',15) + 2
				if (`jind' == 16) {
					local jind = 1
				}
				if(`"`ciopts'"' == "") {
					local ciopts lstyle(p`jind'solid)
				}
				if(`"`peopts'"' == "") {
					local peopts mstyle(p`jind')
				}

local rocgraph `rocgraph' (rcap `rocl_`vvit'_`k'' `rocu_`vvit'_`k'' `roc_num', `ciopts')
local procgraph `procgraph' (scatter `rocp_`vvit'_`k'' `roc_num', `peopts')
				local it1 = `it1' + 1
			}
			local i = `i' + 1
			local vvit = `vvit' + 1
		}
	}

	local serocmatnames `procmatnames'
	local cirocmatnames `procmatnames'

	if(`"`invroc'"' != "") {
		local i = 1
		local it1 = 1
		local itmat = 1
		tempvar invroc_num
		qui gen double `invroc_num' = .
		local vvit = 1
		foreach var of local classvars {
			forvalues k=1/`ncovobs' {
				local peopts
				local ciopts
				tempvar invrocp_`vvit'_`k' 
				tempvar invrocl_`vvit'_`k'
				tempvar invrocu_`vvit'_`k' 
				tempvar invrocse_`vvit'_`k'
				qui gen double `invrocp_`vvit'_`k''=.
				qui gen double `invrocl_`vvit'_`k'' =. 
				qui gen double `invrocu_`vvit'_`k'' =.
				qui gen double  `invrocse_`vvit'_`k'' = .
				local it = 1
				foreach num of numlist `invroc' {
					qui replace `invroc_num' = `num' ///
						if _n == `it'
					tempvar predvar sevar inpvar
					qui gen double `inpvar' = `num'
					qui predict `predvar' 	///
						if _n == `k', 		///
						invroc at (`inpvar') 	///
						classvar(`var') 	///
						se(`sevar') 		
					qui replace `invrocse_`vvit'_`k'' ///
						= `sevar'[`k'] if _n == `it'
					qui replace `invrocp_`vvit'_`k'' ///
						= `predvar'[`k'] if _n==`it'
					local alpha = 1-(`level'/100)
					local ciuba = 1-(`alpha'/2)
					local cilba = `alpha'/2
					qui replace `invrocu_`vvit'_`k''= ///
						`predvar'[`k']+ 	  ///
						`sevar'[`k']*		  ///
						invnormal(`ciuba') if _n==`it'
					qui replace `invrocl_`vvit'_`k''= ///
						`predvar'[`k']-		  ///
						`sevar'[`k']*		  ///
						invnormal(`ciuba') if _n==`it'
					local 	pinvrocmatnames ///
						`pinvrocmatnames' ///
						`var':invroc_`it'_`k'
					matrix `pinvrocmat'[1,`itmat'] = ///
						`predvar'[`k']
					matrix `seinvrocmat'[1,`itmat']= ///
						 `sevar'[`k']
					matrix `ciinvrocmat'[1,`itmat']= ///
						`predvar'[`k']-	 	 ///
						`sevar'[`k']*		 ///
						invnormal(`ciuba')
					matrix `ciinvrocmat'[2,`itmat']= ///
						`predvar'[`k']+		 ///
						`sevar'[`k']*		 ///
						invnormal(`ciuba')		
					local itmat = `itmat'+1
					local it = `it' + 1
				}
				local jind = mod(`it1',15) + 2
				if (`jind' == 16) {
					local jind = 1
				}
				if(`"`ciopts'"' == "") {
					local ciopts lstyle(p`jind'solid)
				}
				if(`"`peopts'"' == "") {
					local peopts mstyle(p`jind')
				}
local invrocgraph `invrocgraph' (rcap `invrocl_`vvit'_`k'' `invrocu_`vvit'_`k'' `invroc_num', horizontal `ciopts')
local pinvrocgraph `pinvrocgraph' (scatter `invroc_num' `invrocp_`vvit'_`k'', `peopts')
				local it1 = `it1' + 1
			}
			local i = `i' + 1
			local vvit = `vvit' + 1
		}
	}
	local seinvrocmatnames `pinvrocmatnames'
	local ciinvrocmatnames `pinvrocmatnames'

	if (`"`roc'"' != "") {
		matrix colnames `procmat'  = `procmatnames'
		matrix colnames `serocmat' = `serocmatnames'
		matrix colnames `cirocmat' = `cirocmatnames'
	}

	if (`"`invroc'"' != "") {
		matrix colnames `pinvrocmat'  = `pinvrocmatnames'
		matrix colnames `seinvrocmat' = `seinvrocmatnames'
		matrix colnames `ciinvrocmat' = `ciinvrocmatnames'
	}

	// display results

	if(`"`roc'"' != "") {
		di ""
		di as text "ROC curve"
		foreach var of local classvars {
			di ""
			di as text "   Status    : " as result `"`e(refvar)'"'
			di as text "   Classifier: " as result `"`var'"' 	
			forvalues j = 1/`ncovobs' {
				GDisEmp_GP_ML,	classvar(`"`var'"') 	   ///
						stat("roc") 		   ///
						statlist(`roc') 	   ///
						level(`level') 		   ///
						covnumb(`j')   		   ///
						rb(`procmat') 		   ///
						iregvarsmat(`iregvarsmat') ///
						rci(`cirocmat') 	   ///
						rse(`serocmat')
			}
		}
	}
	if(`"`invroc'"' != "") {
		di ""
		di as text "False-positive rate"
		foreach var of local classvars {
			di ""
			di as text "   Status    : " as result `"`e(refvar)'"'
			di as text "   Classifier: " as result `"`var'"'
			forvalues j = 1/`ncovobs' { 	
				GDisEmp_GP_ML,	classvar(`"`var'"') 	   ///
						stat("invroc") 		   ///
						statlist(`invroc') 	   ///
						level(`level') 		   ///
						covnumb(`j') 		   ///
						rb(`pinvrocmat') 	   ///
						iregvarsmat(`iregvarsmat') ///
						rci(`ciinvrocmat') 	   ///
						rse(`seinvrocmat')
			}
		}
	}

	// prepare legend and aspectratio
	if(`"`legend'"'=="") {
		local it = 1
		local varcnt: word count `classvars'
		foreach var of local classvars {
			local vf `label_`var''
			if (`"`vf'"' == "") {
				local vf `var'
			}
			local legendmac `"`legendmac'- `"`vf'"'"'
			if (`ncovobs' > 1) {
				forvalues k = 1/`ncovobs' {
					if (`k' == 1) {
						local legendmac ///
						`legendmac' `it' `"At `k'"'
					}
					else {
						local legendmac ///
						`legendmac'- `" "' `it' ///
						 `"At `k'"'
					}
					local it = `it'+1
				}
			}
			else {
				local legendmac ///
				`legendmac' `it' `""'
				local it = `it'+1
			}
		}
		local f = `ncovobs'*`varcnt'+`varcnt'
		local ///
		legendmac `"legend(order(`legendmac') cols(2))"'
		local legend `legendmac'
	}
	else {
		local legend legend(`legend')
	}

	if(`"`aspectrat'"' == "") {
		local aspectratio aspectratio(1)
	}
	else {
		local aspectratio aspectratio(`aspectratio')
	}	
	
	// draw plot
	twoway `sgraphl' 			///
		`rlgraph' 			///
		`rocgraph' 			///
		`procgraph' 			///
		`invrocgraph' 			///
		`pinvrocgraph', 		///
			`aspectratio' 		///
			xtitle("False-positive rate") 		///
			ytitle("True-positive rate (ROC)") 	///
			xlabel(0(.25)1,grid) 	///
			ylabel(0(.25)1,grid) 	///
			`legend' 		///
			`options' 
	restore
end 

program GRocRegPEstat_ML_Margin
	syntax [if] [in], 	[roc(numlist) ///
				INVroc(numlist) ///
				Level(cilevel) ///
				classvars(string) norefline] *

	// check that roc and invroc arguments legal
	if(`"`roc'"' != "") {
		foreach num of numlist `roc' {
			capture assert `num' > 0 & `num' < 1
			if (_rc != 0) {
				noi di as error ///
					"roc() inputs must be in (0,1)"
				error 198
			}
		}
	}

	if(`"`invroc'"' != "") {
		foreach num of numlist `invroc' {
			capture assert `num' > 0 & `num' < 1
			if (_rc != 0) {
				noi di as error ///
					"invroc() inputs must be in (0,1)"
				error 198
			}
		}
	}

	// mark sample
	preserve
	if (`"`classvars'"' == "") {
		local classvars `e(classvars)'
	}

	qui marksample touse
	foreach var of varlist `classvars' {
		markout `touse' _roc_`var' _fpr_`var'
	}

	local ncovobs = 1
	local graph graph
	foreach vf of local classvars {
		local label_`vf': variable label `vf'
	}
	// number of graphs
	local ngr : word count `classvars'

	// sample marked, parse remaining syntax

	local	link `"`e(link)'"'
	local refvar	`"`e(refvar)'"'
	local ctrlmodel	`"`e(ctrlmodel)'"'
	local ctrlcov	`"`e(ctrlcov)'"'

	local parseit ASPECTratio(string) LEGend(string asis) RLOPTs(string)
	forvalues i = 1/`ngr' {
		local parseit `parseit' line`i'opts(string) plot`i'opts(string)
	}
	local parseit `parseit' *
	local 0 , `options'
	syntax, [`parseit']

	_get_gropts, graphopts(`options') gettwoway
	capture assert "`s(graphopts)'" == ""
	if (_rc) {
		local f: word 1 of `s(graphopts)'
		tokenize `"`f'"', parse(" (")
		local f1 `1'
		tokenize `"`f'"', 
		local f2 `1'
		if (`"`f1'"' != `"`f2'"') {
			local f `f1'()
		}
		else {
			local f `f1'
		}
		di as error `"option `f' not allowed"'
		exit 198
	}

	if(`"`refline'"' == "norefline") {
		local norefline norefline
	}


	// prepare reference line graph
	if (`"`norefline'"' == "") {
		local rlgraph 				///
		(function y=x, 				///
				range(0 1) 		///
				n(2) 			///
				lstyle(refline) 	///
				yvarlabel("Reference") 	///
				`rlopts' 		/// graph opts
		)
	}


	tempname tmat
	matrix `tmat' = e(b)
	
	// prepare ROC curve and ROC scatter plots	
	local legendordlist_pt 
	local legendordlist_ln
	local vcnt: word count `classvars'
	local i = 1
	local vvit = 1
	foreach var of varlist `classvars' {
		local j = `vcnt' + `i'
		local vf: variable label `var'
		if (`"`vf'"' == "") {
			local vf `var'
		}
		local legendordlist_pt=`"`legendordlist_pt' `i' `"`vf'"'"'
		local legendordlist_ln=`"`legendordlist_ln' `j' `"`vf' Fit"'"'
		local opts `"`plot`i'opts'"'
		if(`"`opts'"' == "") {
			local opts mstyle(p`i')
		}

		local opts connect(i) `opts'
		
	        local sgraphsp `sgraphsp'         			  ///
		            (connected _roc_`var' _fpr_`var'  if `touse', ///
                	         sort(_fpr_`var' _roc_`var') 		  ///
                        	   `opts'                 		  ///
		            )
		local opts `"`line`i'opts'"'
		if(`"`opts'"' == "") {
			local opts lstyle(p`i'line)
		}
		tempname `vvit'cons `vvit'slope
		scalar ``vvit'cons' = ///
			`tmat'[1,colnumb(`tmat',`"`var':i_cons"')]
		scalar ``vvit'slope' = ///
			`tmat'[1,colnumb(`tmat',`"`var':s_cons"')]
		if(`"`link'"' != `"probit"') {
local sgraphsl `sgraphsl' (function y = 0*(x==0) + (x==1) + (x>0)*(x<1)*(1/(1+exp(-(``vvit'cons'+``vvit'slope'*logit(.3*(x<=0)+ .3*(x>=1)+(x>0)*(x<1)*x))))), range(0 1) `opts')
		}
		else {
local sgraphsl `sgraphsl' (function y = 0*(x==0)+(x==1) + (x>0)*(x<1)*normal(``vvit'cons'+``vvit'slope'*invnormal(.3*(x<=0)+ .3*(x>=1)+(x>0)*(x<1)*x)),  range(0 1) `opts')
		}
		local i = `i' + 1
		local vvit = `vvit' + 1
	}

	local classvarcnt: word count `classvars'


	// add observations containing ROC and invROC value
	local roc_count: word count `roc'
	local invroc_count: word count `invroc'
	local maxobs = max(`roc_count',`invroc_count',_N)
	qui set obs `maxobs'


	// estimate ROC and invROC
	local invrocgraph
	local pinvrocgraph
	local rocgraph
	local procgraph

	local cvcnt: word count `classvars'
	if (`"`roc'"' != "") {
		tempname procmat
		matrix `procmat' = J(1,`ncovobs'*`roc_count'*`cvcnt',.)
		local procmatnames 
		tempname serocmat
		matrix `serocmat' = J(1,`ncovobs'*`roc_count'*`cvcnt',.)
		local serocmatnames
		tempname cirocmat
		matrix `cirocmat' = J(2,`ncovobs'*`roc_count'*`cvcnt',.)
		local cirocmatnames
	}

	if (`"`invroc'"' != "") {
		tempname pinvrocmat
		matrix `pinvrocmat' = J(1,`ncovobs'*`invroc_count'*`cvcnt',.)
		local pinvrocmatnames 
		tempname seinvrocmat
		matrix `seinvrocmat' = J(1,`ncovobs'*`invroc_count'*`cvcnt',.)
		local seinvrocmatnames
		tempname ciinvrocmat
		matrix `ciinvrocmat' = J(2,`ncovobs'*`invroc_count'*`cvcnt',.)
		local ciinvrocmatnames
	}


	if(`"`roc'"' != "") {
		tempvar roc_num
		qui gen double `roc_num' = .
		local i = 1
		local it1 = 1
		local itmat =1
		local vvit = 1
		foreach var of local classvars {
			forvalues k=1/`ncovobs' {
				local peopts
				local ciopts
				tempvar rocp_`vvit'_`k' 
				tempvar rocl_`vvit'_`k' 
				tempvar rocu_`vvit'_`k' 
				tempvar rocse_`vvit'_`k'
				qui gen double `rocp_`vvit'_`k''=.
				qui gen double `rocl_`vvit'_`k'' =. 
				qui gen double `rocu_`vvit'_`k'' =.
				qui gen double  `rocse_`vvit'_`k'' = .
				local it = 1
				foreach num of numlist `roc' {
					qui replace `roc_num' = `num' ///
						if _n == `it'
					tempvar predvar sevar inpvar
					qui gen double `inpvar' = `num'
					qui predict `predvar' 	///
						if _n == `k', 		///
						roc at(`inpvar')	///
						classvar(`var') 	///
						se(`sevar')	
						
					qui replace `rocp_`vvit'_`k''= ///
						`predvar'[`k'] if _n==`it'
					qui replace `rocse_`vvit'_`k''= ///
						`sevar'[`k'] if _n == `it'
					local alpha = 1-(`level'/100)
					local ciuba = 1-(`alpha'/2)
					local cilba = `alpha'/2
					qui replace `rocu_`vvit'_`k'' = ///
						`predvar'[`k'] + 	///
						`sevar'[`k']*		///
						invnormal(`ciuba') if _n==`it'
					qui replace `rocl_`vvit'_`k'' = ///
						`predvar'[`k'] - 	///
						`sevar'[`k']*		///
						invnormal(`ciuba') if _n==`it'
					local 	procmatnames 	///
						`procmatnames' 	///
						`var':roc_`it'_`k'
					matrix `procmat'[1,`itmat'] = ///
						`predvar'[`k']
					matrix `serocmat'[1,`itmat']= ///
						`sevar'[`k']
					matrix `cirocmat'[1,`itmat']= 	///
						`predvar'[`k']-		///
						`sevar'[`k']*		///
						invnormal(`ciuba')
					matrix `cirocmat'[2,`itmat']= 	///
						`predvar'[`k']+		///
						`sevar'[`k']*		///
						invnormal(`ciuba')
					local it = `it' + 1
					local itmat = `itmat'+1
				}			
				local jind = mod(`it1',15) + 2
				if (`jind' == 16) {
					local jind = 1
				}
				if(`"`ciopts'"' == "") {
					local ciopts lstyle(p`jind'solid)
				}
				if(`"`peopts'"' == "") {
					local peopts mstyle(p`jind')
				}

local rocgraph `rocgraph' (rcap `rocl_`vvit'_`k'' `rocu_`vvit'_`k'' `roc_num',`ciopts')
local procgraph `procgraph' (scatter `rocp_`vvit'_`k'' `roc_num', `peopts')
				local it1 = `it1' + 1
			}
			local i = `i' + 1
			local vvit = `vvit' + 1
		}
	}

	local serocmatnames `procmatnames'
	local cirocmatnames `procmatnames'

	if(`"`invroc'"' != "") {
		local i = 1
		local it1 = 1
		local itmat = 1
		tempvar invroc_num
		qui gen double `invroc_num' = .
		local vvit = 1
		foreach var of local classvars {
			forvalues k=1/`ncovobs' {
				local peopts
				local ciopts
				tempvar invrocp_`vvit'_`k' 
				tempvar invrocl_`vvit'_`k' 
				tempvar invrocu_`vvit'_`k' 
				tempvar invrocse_`vvit'_`k'
				qui gen double `invrocp_`vvit'_`k''=.
				qui gen double `invrocl_`vvit'_`k'' =. 
				qui gen double `invrocu_`vvit'_`k'' =.
				qui gen double  `invrocse_`vvit'_`k'' = .
				local it = 1
				foreach num of numlist `invroc' {
					qui replace `invroc_num' = `num' ///
						if _n == `it'
					tempvar predvar sevar inpvar
					qui gen double `inpvar' = `num'
					qui predict `predvar' 	///
						if _n == `k', 		///
						invroc at(`inpvar') 	///
						classvar(`var') 	///
						se(`sevar') 
						
					qui replace `invrocse_`vvit'_`k'' ///
						=`sevar'[`k'] if _n==`it'
					qui replace `invrocp_`vvit'_`k'' ///
						=`predvar'[`k'] if _n==`it'
					local alpha = 1-(`level'/100)
					local ciuba = 1-(`alpha'/2)
					local cilba = `alpha'/2
					qui replace `invrocu_`vvit'_`k''= ///
						`predvar'[`k']+ 	  ///
						`sevar'[`k']*		  ///
						invnormal(`ciuba') if _n==`it'
					qui replace `invrocl_`vvit'_`k''= ///
						`predvar'[`k']- 	  ///
						`sevar'[`k']*		  ///
						invnormal(`ciuba') if _n==`it'
					local 	pinvrocmatnames  ///
						`pinvrocmatnames' ///
						`var':invroc_`it'_`k'
					matrix `pinvrocmat'[1,`itmat'] = ///
						`predvar'[`k']
					matrix `seinvrocmat'[1,`itmat']= ///
						`sevar'[`k']
					matrix `ciinvrocmat'[1,`itmat'] = ///
						`predvar'[`k']-		  ///
						`sevar'[`k']*		  ///
						invnormal(`ciuba')
					matrix `ciinvrocmat'[2,`itmat'] = ///
						`predvar'[`k']+		  ///
						`sevar'[`k']*		  ///
						invnormal(`ciuba')		
					local itmat = `itmat'+1
					local it = `it' + 1
				}
				local jind = mod(`it1',15) + 2
				if (`jind' == 16) {
					local jind = 1
				}
				if(`"`ciopts'"' == "") {
					local ciopts lstyle(p`jind'solid)
				}
				if(`"`peopts'"' == "") {
					local peopts mstyle(p`jind')
				}

local invrocgraph `invrocgraph' (rcap `invrocl_`vvit'_`k'' `invrocu_`vvit'_`k'' `invroc_num', horizontal `ciopts')
local pinvrocgraph `pinvrocgraph' (scatter `invroc_num' `invrocp_`vvit'_`k'', `peopts')
				local it1 = `it1' + 1
			}
			local i = `i' + 1
			local vvit = `vvit' + 1
		}
	}
	local seinvrocmatnames `pinvrocmatnames'
	local ciinvrocmatnames `pinvrocmatnames'

	if (`"`roc'"' != "") {
		matrix colnames `procmat'  = `procmatnames'
		matrix colnames `serocmat' = `serocmatnames'
		matrix colnames `cirocmat' = `cirocmatnames'
	}

	if (`"`invroc'"' != "") {
		matrix colnames `pinvrocmat'  = `pinvrocmatnames'
		matrix colnames `seinvrocmat' = `seinvrocmatnames'
		matrix colnames `ciinvrocmat' = `ciinvrocmatnames'
	}


	// display results
	if(`"`roc'"' != "") {
		di ""
		di as text "ROC curve"
		foreach var of local classvars {
			di ""
			di as text "   Status    : " as result `"`e(refvar)'"'
			di as text "   Classifier: " as result `"`var'"' 	
			forvalues j = 1/`ncovobs' {
				GDisEmp_GP_ML, 	classvar(`"`var'"') 	   ///
						stat("roc") 		   ///
						statlist(`roc') 	   ///
						level(`level') 		   ///
						covnumb(`j') 		   ///
						rb(`procmat') 		   ///
						iregvarsmat(`iregvarsmat') ///
						rci(`cirocmat')  	   ///
						rse(`serocmat')
			}
		}
	}
	if(`"`invroc'"' != "") {
		di ""
		di as text "False-positive rate"
		foreach var of local classvars {
			di ""
			di as text "   Status    : " as result `"`e(refvar)'"'
			di as text "   Classifier: " as result `"`var'"'
			forvalues j = 1/`ncovobs' { 	
				GDisEmp_GP_ML, 	classvar(`"`var'"') 	   ///
						stat("invroc") 		   ///
						statlist(`invroc') 	   ///
						level(`level') 		   ///
						covnumb(`j') 		   ///
						rb(`pinvrocmat') 	   ///
						iregvarsmat(`iregvarsmat') ///
						rci(`ciinvrocmat') 	   ///
						rse(`seinvrocmat')
			}
		}
	}

	// prepare legend and aspect ratio
	local f: word count `classvars'
	if (`"`legend'"'=="") {
		local rowsa = 2*`f'
local legendmac `"legend(order(`legendordlist_pt' `legendordlist_ln') symxsize(*.5) row(`rowsa'))"'
	local legend `legendmac'
	}
	else {
		local legend legend(`legend')
	}
	
	if(`"`aspectrat'"' == "") {
		local aspectratio aspectratio(1)
	}
	else {
		local aspectratio aspectratio(`aspectratio')
	}	
	
	// add points for 0,1 fpr and roc values, to be deleted later
	local Nmax=_N+2
	qui set obs `Nmax'
	tempvar drp
	qui gen `drp'=1 if _n>`Nmax'-2
	foreach y of varlist `classvars' {
		qui replace _fpr_`y' = 0 if _n == `Nmax'-1
		qui replace _roc_`y' = 0 if _n == `Nmax'-1
		qui replace _fpr_`y' = 1 if _n == `Nmax'
		qui replace _roc_`y' = 1 if _n == `Nmax'
	}

	qui replace `touse' = 1 if `drp' == 1

	// draw graph

	twoway `sgraphsp' 			///
		`sgraphsl'  			///
		`rlgraph' 			///
		`rocgraph' 			///
		`procgraph' 			///
		`invrocgraph' 			///
		`pinvrocgraph', 		///
			`aspectratio' 		///
			xtitle("False-positive rate") 		///
			ytitle("True-positive rate (ROC)") 	///
			xlabel(0(.25)1,grid) 		///
			ylabel(0(.25)1,grid) 		///
			`legend' 		///
			`options' 

	qui capture count if `drp' != 1
	if (_rc == 0) {
		qui drop if `drp'
	}

	restore
end 

// called for a specific classvar, and covariate number 
program GDisEmp_GP_ML
	syntax, 		classvar(name) 		///
				stat(string) 		///
				statlist(numlist) 	///
				level(cilevel) 		///
				covnumb(integer) 	///
				rb(name) 		///
				[iregvarsmat(name)] 	///
				[rci(name)] 		///
				[rse(name)]
	local j = `covnumb'
	if (`"`iregvarsmat'"' != "") {
		di ""
		di "Under covariates: "
		local a = colsof(`iregvarsmat')
		matlist `iregvarsmat'[`j',1..`a']'
		di
	}
	DC
	di as text "{hline 13}{c TT}{hline 64}"
	local dcol = 14 - length(`"`stat' "')

	local llen = 0
	// 10s place
	local llen = `llen' + 2
	if (floor(`level') != `level') {
		// decimal point
		local llen = `llen' + 1
	}
	if (100*(`level'-floor(`level')) > 9) {
		// tenth's place
		local llen = `llen' + 1
	}
	if (100*(`level'-floor(`level'))/10 != ///
		floor(100*(`level'-floor(`level'))/10)) {
		// hundredth's place
		local llen = `llen' + 1
	}
	local al = 47 -`llen'


	if (`"`stat'"' == "pauc") {
		local stabat pAUC
	}
	else if (`"`stat'"' == "invroc") {
		local stabat invROC
	}
	else {
		local stabat = upper(`"`stat'"') 
	}

	di as text _col(`dcol') `"`stabat' "' _col(14) "{c |}" _col(22) ///
		"Coef." _col(30) "Std. Err." _col(`al') ///
		"[`=strsubdp("`level'")'% Conf. Interval]" 
	
	di as text "{hline 13}{c +}{hline 64}"
	
	tempname eb
	matrix `eb' = `rb'

	tempname eci
	tempname semat
	matrix `eci' = `rci'
	matrix `semat' = `rse'

	local i = 1
	foreach num of numlist `statlist' {
		di as text _col(4) %9.0g `num' _col(14) "{c |}" as result ///
		_col(18) %9.0g ///
		`eb'[1,colnumb(`eb',`"`classvar':`stat'_`i'_`j'"')] ///
		_col(29) %9.0g ///
		`semat'[1,colnumb(`eb',`"`classvar':`stat'_`i'_`j'"')] ///
		_col(44) %9.0g ///
		`eci'[1,colnumb(`eb',`"`classvar':`stat'_`i'_`j'"')] ///
		_col(55) %9.0g ///
		`eci'[2,colnumb(`eb',`"`classvar':`stat'_`i'_`j'"')] 
		local i = `i'+1
	}
	di as text "{hline 13}{c BT}{hline 64}"
end

program IGE
	syntax,	i(string) 		///
		j(string) 		///
		var(string) 		///
		vvit(string) 		///
		var(string)		///
		rci_percentile(string) 	///
		rb(string) 		///
		rz0(string) 		///
		rb_bs(string) 		///
		tb(string) 		///
		rse(string) 		///
		tse(string) 		///
		tcilba(string) 		///
		tciuba(string) 		///
		rci_bc(string) 		///
		ciuba(string) 		///
		cilba(string)

	local tbsi = colnumb(`rb_bs',`"`var':invroc_`i'_`j'"')
	local tbi =colnumb(`tb',`"_v`vvit'_b_invroc_`i'_`j'"')
	matrix `rb_bs'[1,`tbsi'] = `tb'[1,`tbi']
	local rsei = colnumb(`rse',`"`var':invroc_`i'_`j'"')
	local tsei = colnumb(`tse',`"_v`vvit'_b_invroc_`i'_`j'"')
	matrix `rse'[1,`rsei'] = `tse'[1,`tsei']
	qui _pctile _v`vvit'_b_invroc_`i'_`j', percentile(`tcilba' `tciuba')
	local rp = colnumb(`rci_percentile',`"`var':invroc_`i'_`j'"')
	matrix `rci_percentile'[1,`rp'] = r(r1)
	matrix `rci_percentile'[2,`rp'] = r(r2) 
	qui count if _v`vvit'_b_invroc_`i'_`j' <= ///
		`rb'[1,colnumb(`rb',`"`var':invroc_`i'_`j'"')]
	tempname z0
	scalar `z0' = invnormal(r(N)/_N)
	local rz0i =colnumb(`rz0',`"`var':invroc_`i'_`j'"')
	matrix `rz0'[1,`rz0i'] = `z0'
	local p1 = 100*normal(`z0'+ (`z0'-invnormal(`ciuba')))
	local p2 = 100*normal(`z0'+ (`z0'+invnormal(`ciuba')))
	local rbi =colnumb(`rci_bc',`"`var':invroc_`i'_`j'"')
	if(`p1' == . | `p2' == .) {
		matrix `rci_bc'[1,`rbi'] = .
		matrix `rci_bc'[2,`rbi'] = .
	}
	else {
		_pctile _v`vvit'_b_invroc_`i'_`j', percentile(`p1' `p2')
		matrix `rci_bc'[1,`rbi'] = r(r1)
		matrix `rci_bc'[2,`rbi'] = r(r2)
	}
end

program RGE
	syntax,	i(string) 		///
		j(string) 		///
		var(string) 		///
		vvit(string) 		///
		var(string) 		///
		rci_percentile(string) 	///
		rb(string) 		///
		rz0(string) 		///
		rb_bs(string) 		///
		tb(string) 		///
		rse(string) 		///
		tse(string) 		///
		tcilba(string) 		///
		tciuba(string) 		///
		rci_bc(string) 		///
		ciuba(string) 		///
		cilba(string)

	matrix `rb_bs'[1,colnumb(`rb_bs',`"`var':roc_`i'_`j'"')] = ///
		`tb'[1,colnumb(`tb',`"_v`vvit'_b_roc_`i'_`j'"')]
	matrix `rse'[1,colnumb(`rse',`"`var':roc_`i'_`j'"')] = ///
		`tse'[1,colnumb(`tse',`"_v`vvit'_b_roc_`i'_`j'"')]
	qui _pctile _v`vvit'_b_roc_`i'_`j', percentile(`tcilba' `tciuba')
	local rp = colnumb(`rci_percentile',`"`var':roc_`i'_`j'"')
	matrix `rci_percentile'[1,`rp'] = r(r1)
	matrix `rci_percentile'[2,`rp'] = r(r2) 
	qui count if _v`vvit'_b_roc_`i'_`j' <= ///
		`rb'[1,colnumb(`rb',`"`var':roc_`i'_`j'"')]
	tempname z0
	scalar `z0' = invnormal(r(N)/_N)
	matrix `rz0'[1,colnumb(`rz0',`"`var':roc_`i'_`j'"')] = `z0'
	local p1 = 100*normal(`z0'+ (`z0'-invnormal(`ciuba')))
	local p2 = 100*normal(`z0'+ (`z0'+invnormal(`ciuba')))
	local rbi = colnumb(`rci_bc',`"`var':roc_`i'_`j'"')
	if(`p1' == . | `p2' == .) {
		matrix `rci_bc'[1,`rbi'] = .
		matrix `rci_bc'[2,`rbi'] = .
	}
	else {
		_pctile _v`vvit'_b_roc_`i'_`j', percentile(`p1' `p2')
		matrix `rci_bc'[1,`rbi'] = r(r1)
		matrix `rci_bc'[2,`rbi'] = r(r2)
	}	
end

program IOF1
	syntax,	num(string) 		///
		o(string) 		///
		var(string) 		///
		im(string) 		///
		link(string) 		///
		i(string) 		///
		j(string)

	local obs `o'
	local iregvarsmat `im'
	tempname sinterceptit sslopeit bmat
	matrix `bmat' = e(b)
	scalar `sinterceptit' = `bmat'[1,colnumb(`bmat',"`var':i_cons")]
	scalar `sslopeit' = 0
	local inames:colfullnames `iregvarsmat'
	foreach ivar of local inames {
		local iv = colnumb(`bmat',"`var':`ivar'")
		local iv2=colnumb(`iregvarsmat',"`ivar'")
		scalar `sinterceptit' = ///
			`bmat'[1,`iv']*`iregvarsmat'[`j',`iv2'] ///
			+ `sinterceptit' 
	}
	scalar `sslopeit' = `sslopeit' + ///
		`bmat'[1,colnumb(`bmat',"`var':s_cons")]
	if(`"`link'"'=="probit") {
		scalar `obs' = ///
		normal((1/`sslopeit')*(invnormal(`num') - `sinterceptit'))
		if (inlist(`num',1,0)) {
			scalar `obs' = `num'
		} 
	}
	else {
		scalar `obs' = ///
		1/(1+exp(-(-ln(1/`num'-1) -`sinterceptit')/`sslopeit'))
		if(inlist(`num',1,0)) {
			scalar `obs' = `num'
		}		
	}
end

program IBF1
	syntax,	i(string)	/// 
		j(string) 	///
		vvit(string) 	///
		link(string) 	///
		im(string) 	///
		num(string)
	local iregvarsmat `im'
	tempvar interceptit slopeit
	qui gen double `interceptit' = _v`vvit'_b_i_cons
	qui gen double `slopeit' = 0
	local inames:colfullnames `iregvarsmat'
	local rcit = 1
	foreach ivar of local inames {
		local iv =colnumb(`iregvarsmat',"`ivar'")
		qui replace `interceptit' = 				///
			_v`vvit'_b_`rcit'*`iregvarsmat'[`j',`iv'] + 	///
			`interceptit' 
		local rcit = `rcit' + 1
	}
	qui replace `slopeit' = `slopeit' + _v`vvit'_b_s_cons
	if ("`link'"=="probit") {
		qui gen double _v`vvit'_b_invroc_`i'_`j' = ///
			normal((1/`slopeit')*(invnormal(`num')-`interceptit'))
		qui replace _v`vvit'_b_invroc_`i'_`j' = 1 if `num' == 1
		qui replace _v`vvit'_b_invroc_`i'_`j' = 0 if `num' == 0
		qui replace _v`vvit'_b_invroc_`i'_`j' = . if `slopeit' < 1e-10
	}
	else {
		qui gen double _v`vvit'_b_invroc_`i'_`j' = ///
			1/(1+exp(-(-ln(1/`num'-1)-`interceptit')/`slopeit'))
		qui replace _v`vvit'_b_invroc_`i'_`j' = 1 if `num' == 1
		qui replace _v`vvit'_b_invroc_`i'_`j' = 0 if `num' == 0
		qui replace _v`vvit'_b_invroc_`i'_`j' = . if `slopeit' < 1e-10
	}
	drop `interceptit' `slopeit'
end

program ROF1
	syntax,	num(string) 	///
		o(string) 	///
		bmat(string) 	///
		var(string) 	///
		im(string) 	///
		link(string) 	///
		i(string) 	///
		j(string)

	local iregvarsmat `im'
	matrix `bmat' = e(b)
	local obs `o'
	scalar `obs' = `bmat'[1,colnumb(`bmat',"`var':i_cons")]
	local inames:colfullnames `iregvarsmat'
	foreach ivar of local inames {
		local iv = colnumb(`bmat',"`var':`ivar'")
		local bv = colnumb(`iregvarsmat',"`ivar'")
		scalar `obs' = 	`obs'+ `bmat'[1,`iv']*`iregvarsmat'[`j',`bv']
	}
	local sv = colnumb(`bmat',"`var':s_cons")
	if(`"`link'"'=="probit") {
		scalar `obs'=normal(`obs' + `bmat'[1,`sv']*invnormal(`num')) 
		if (inlist(`num',1,0)) {
			scalar `obs' = `num'
		}
	}
	else {
		scalar `obs'=1/(1+exp(-(`obs'+ `bmat'[1,`sv']*logit(`num'))))
		if(inlist(`num',1,0)) {
			scalar `obs' = `num'
		}
	}
end

program RBF1
	syntax,	i(string) 	///
		j(string) 	///
		vvit(string) 	///
		link(string) 	///
		im(string) 	///
		num(string)

	local iregvarsmat `im'
	qui gen double _v`vvit'_b_roc_`i'_`j' = _v`vvit'_b_i_cons
	local inames: colfullnames `iregvarsmat'
	local rcit = 1
	foreach ivar of local inames {						
		local vi =colnumb(`iregvarsmat',"`ivar'")
		qui replace _v`vvit'_b_roc_`i'_`j' =  ///
			_v`vvit'_b_roc_`i'_`j' + ///
			_v`vvit'_b_`rcit'*`iregvarsmat'[`j',`vi'] 
		local rcit = `rcit' + 1
	}

	if(`"`link'"'=="probit") {
		qui replace _v`vvit'_b_roc_`i'_`j' = ///
			normal( _v`vvit'_b_roc_`i'_`j' + ///
			_v`vvit'_b_s_cons*invnormal(`num'))
		qui replace _v`vvit'_b_roc_`i'_`j' = 1 if `num' == 1
		qui replace _v`vvit'_b_roc_`i'_`j' = 0 if `num' == 0
	}
	else {
		qui replace _v`vvit'_b_roc_`i'_`j' = ///
			1/(1+exp(-(_v`vvit'_b_roc_`i'_`j'+ ///
			_v`vvit'_b_s_cons*logit(`num'))))
		qui replace _v`vvit'_b_roc_`i'_`j' = 1 if `num' == 1
		qui replace _v`vvit'_b_roc_`i'_`j' = 0 if `num' == 0
	}
end

program IRGPM
	syntax,	i(string) 	///
		j(string) 	///
		num(string) 	///
		link(string) 	///
		vvit(string)

	tempvar interceptit slopeit
	qui gen double `interceptit' = _v`vvit'_b_i_cons
	qui gen double `slopeit' = 0
	qui replace `slopeit' = `slopeit' + _v`vvit'_b_s_cons
	if ("`link'"=="probit") {
		qui gen double _v`vvit'_b_invroc_`i'_`j' = ///
			normal((1/`slopeit')*(invnormal(`num')-`interceptit'))
	}
	else {
		qui gen double _v`vvit'_b_invroc_`i'_`j' = ///
			1/(1+exp(-(-ln(1/`num'-1)-`interceptit')/`slopeit'))
	}
	qui replace _v`vvit'_b_invroc_`i'_`j' = 1 if `num' == 1
	qui replace _v`vvit'_b_invroc_`i'_`j' = 0 if `num' == 0
	qui replace _v`vvit'_b_invroc_`i'_`j' = . if `slopeit' < 1e-10
end

program IRGPMO
	syntax, o(string) 	///
		var(string) 	///
		num(string)	///
		link(string)
	tempname sinterceptit sslopeit 
	tempname bmat
	matrix `bmat' = e(b)
	scalar `sinterceptit' = `bmat'[1,colnumb(`bmat',"`var':i_cons")]
	scalar `sslopeit' = 0
	scalar `sslopeit' = `sslopeit' + ///
		`bmat'[1,colnumb(`bmat',"`var':s_cons")]
	if(`"`link'"'=="probit") {
		scalar `o' = normal(	///
			(1/`sslopeit')*(invnormal(`num')-`sinterceptit'))
		if (inlist(`num',1,0)) {
			scalar `o' = `num'
		} 				
	}
	else {
		scalar `o' = ///
			1/(1+exp(-(-ln(1/`num'-1)-`sinterceptit')/`sslopeit'))
		if (inlist(`num',1,0)) {
			scalar `o' = `num'
		}		
	}
end

program RGM 
	syntax, i(string)	/// 
		j(string) 	///
		rb_bs(string) 	///
		tb(string) 	///
		rse(string) 	///
		tse(string) 	///
		tcilba(string) 	///
		tciuba(string) 	///
		ciuba(string) 	///
		cilba(string) 	///
		rp(string) 	///
		rz0(string) 	///
		rci_bc(string) 	///
		var(string) 	///
		vvit(string)	///
		rb(string)

	local rci_percentile `rp'
	matrix `rb_bs'[1,colnumb(`rb_bs',`"`var':roc_`i'_`j'"')] = ///
		`tb'[1,colnumb(`tb',`"_v`vvit'_b_roc_`i'_`j'"')]
	matrix `rse'[1,colnumb(`rse',`"`var':roc_`i'_`j'"')] = ///
		`tse'[1,colnumb(`tse',`"_v`vvit'_b_roc_`i'_`j'"')]
	qui _pctile _v`vvit'_b_roc_`i'_`j', percentile(`tcilba' `tciuba')
	local rci = colnumb(`rci_percentile',`"`var':roc_`i'_`j'"')
	matrix `rci_percentile'[1,`rci'] = r(r1)
	matrix `rci_percentile'[2,`rci'] = r(r2) 
	qui count if _v`vvit'_b_roc_`i'_`j' <= ///
		`rb'[1,colnumb(`rb',`"`var':roc_`i'_`j'"')]
	tempname z0
	scalar `z0' = invnormal(r(N)/_N)
	local rzi = colnumb(`rz0',`"`var':roc_`i'_`j'"')
	matrix `rz0'[1,`rzi'] = `z0'
	local p1 = 100*normal(`z0'+ (`z0'-invnormal(`ciuba')))
	local p2 = 100*normal(`z0'+ (`z0'+invnormal(`ciuba')))
	local rcb = colnumb(`rci_bc',`"`var':roc_`i'_`j'"')
	if(`p1' == . | `p2' == .) {
		matrix `rci_bc'[1,`rcb'] = .
		matrix `rci_bc'[2,`rcb'] = .
	}
	else {
		_pctile _v`vvit'_b_roc_`i'_`j', percentile(`p1' `p2')
		matrix `rci_bc'[1,`rcb'] = r(r1)
		matrix `rci_bc'[2,`rcb'] = r(r2)
	}	
end

program IRGM
	syntax, rb_bs(string) 	///
		tb(string) 	///
		rse(string) 	///
		tse(string) 	///
		tcilba(string) 	///
		tciuba(string) 	///
		ciuba(string) 	///
		cilba(string) 	///
		rp(string) 	///
		rz0(string) 	///
		rci_bc(string) 	///
		i(string)	///
		j(string) 	///
		var(string) 	///
		vvit(string) 	///
		rb(string)

	local rci_percentile `rp'
	local rbi =colnumb(`rb_bs',`"`var':invroc_`i'_`j'"')
	local rbt =colnumb(`tb',`"_v`vvit'_b_invroc_`i'_`j'"')
	matrix `rb_bs'[1,`rbi'] = `tb'[1,`rbt']
	local rsi=colnumb(`rse',`"`var':invroc_`i'_`j'"')
	local rtsi=colnumb(`tse',`"_v`vvit'_b_invroc_`i'_`j'"')
	matrix `rse'[1,`rsi'] =	`tse'[1,`rtsi']
	qui _pctile _v`vvit'_b_invroc_`i'_`j', percentile(`tcilba' `tciuba')
	local rci =	colnumb(`rci_percentile',`"`var':invroc_`i'_`j'"')
	matrix `rci_percentile'[1,`rci'] = r(r1)
	matrix `rci_percentile'[2,`rci'] = r(r2) 
	qui count if _v`vvit'_b_invroc_`i'_`j' <= ///
		`rb'[1,colnumb(`rb',`"`var':invroc_`i'_`j'"')]
	tempname z0
	scalar `z0' = invnormal(r(N)/_N)
	local rz0i =colnumb(`rz0',`"`var':invroc_`i'_`j'"')
	matrix `rz0'[1,`rz0i'] = `z0'
	local p1 = 100*normal(`z0'+ (`z0'-invnormal(`ciuba')))
	local p2 = 100*normal(`z0'+ (`z0'+invnormal(`ciuba')))
	local rcb =colnumb(`rci_bc',`"`var':invroc_`i'_`j'"')
	if(`p1' == . | `p2' == .) {
		matrix `rci_bc'[1,`rcb'] = .
		matrix `rci_bc'[2,`rcb'] = .
	}
	else {
		_pctile _v`vvit'_b_invroc_`i'_`j', percentile(`p1' `p2')
		matrix `rci_bc'[1,`rcb'] = r(r1)
		matrix `rci_bc'[2,`rcb'] = r(r2)
	}	
end

program DC
        if (`"`e(clustvar)'"' != "" & `"`e(nobootstrap)'"'=="") {
                local a = e(N_clust)
                local b = string(`a',"%12.0fc")
                di ///
                        as text "{ralign 78:(Replications based on " ///
                        as result "`b'" as text " clusters in " ///
                        "`e(clustvar)')}"
        }
end

exit
