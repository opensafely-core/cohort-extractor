*! version 2.14.2  19feb2019
program define biprobit, eclass byable(onecall) ///
		prop(ml_score svyb svyj svyr bayes)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun biprobit, mark(OFFSET1 OFFSET2 CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"biprobit `0'"'
		exit
	}

	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 6.0, missing
	if replay() {
		if "`e(cmd)'" != "biprobit" {
			noi di in red "results for biprobit not found"
			exit 301
		}
		if _by() { error 190 } 
		Display `0'
		exit `rc'
	}
	`vv' `BY' Estimate `0'
	version 10: ereturn local cmdline `"biprobit `0'"'
end

program define Estimate, eclass byable(recall)
	version 6.0, missing
	/* two syntax, handle one at a time */

	gettoken first : 0, match(paren)
	
	if "`paren'" == "" {
		/* syntax 1, bivariate probit models */

		gettoken dep1 0:0, parse (" =,[")
		_fv_check_depvar `dep1'
		tsunab dep1 : `dep1'
		rmTS `dep1'
		confirm variable `r(rmTS)'
		gettoken dep2 0:0, parse (" =,[")
		_fv_check_depvar `dep2'
		tsunab dep2 : `dep2'
		rmTS `dep2'
		confirm variable `r(rmTS)'
		gettoken junk left :0, parse ("=")
		if "`junk'" == "=" {
			local 0 "`left'"
		}
		syntax [varlist(default=none ts fv)] [if] [in] [pw fw iw] /*
			*/[, Robust CLuster(varname) SCore(string)  	/*
			*/ offset1(varname) offset2(varname) PARtial    /*
			*/ noCONstant noSKIP/*undoc*/ LRMODEL  		/*
			*/ Level(cilevel)				/* 
			*/ NOLOg LOg MLOpts(string) FROM(string)		/*
			*/ ITERate(passthru) VCE(passthru) 		/*
			*/ moptobj(passthru) * ]

		local fvops = "`s(fvops)'" == "true" | _caller() >= 11

		if _by() {
			_byoptnotallowed score() `"`score'"'
		}
		
		local ind1 `varlist'
		local ind2 `varlist'
		local title "Bivariate probit regression"
                local dep1n "`dep1'"
                local dep1n : subinstr local dep1 "." "_"
                local dep2n "`dep2'"
                local dep2n : subinstr local dep2 "." "_"
                local e_neq = 2
		local nc1 `constant'
		local nc2 `constant'
		local option0 `options'
		marksample touse
		markout `touse' `dep1' `dep2' `offset1' `offset2', strok
	}
	else {
		/* syntax 2, seemingly unrelated bivariate probit model */

					/* get first equation */
		gettoken first 0:0, parse(" ,[") match(paren)
		local left "`0'"
		local junk: subinstr local first ":" ":", count(local number)
		if "`number'" == "1" {
			gettoken dep1n first: first, parse(":")
			gettoken junk first: first, parse(":")
		}
		local first : subinstr local first "=" " "
		gettoken dep1 0: first, parse(" ,[") 
		_fv_check_depvar `dep1'
		tsunab dep1: `dep1'
		rmTS `dep1' 
		confirm variable `r(rmTS)'
		if "`dep1n'" == "" {
			local dep1n "`dep1'"
		}
		syntax [varlist(default=none ts fv)] [, /*
			*/	OFFset(varname numeric) noCONstant]

		local fvops = "`s(fvops)'" == "true" | _caller() >= 11

		local ind1 `varlist'
		local offset1 `offset' 
		local nc1 `constant'

					/* get second equation */
		local 0 "`left'"
		gettoken second 0:0, parse(" ,[") match(paren)
		if "`paren'" != "(" {
			dis in red "two equations required"
			exit 110
		}
		local left "`0'"
		local junk : subinstr local second ":" ":", count(local number)
		if "`number'" == "1" {
			gettoken dep2n second: second, parse(":")
			gettoken junk second: second, parse(":")
		}
		local second : subinstr local second "=" " "
		gettoken dep2 0: second, parse(" ,[") 
		_fv_check_depvar `dep2'
		tsunab dep2: `dep2' 
		rmTS `dep2'
		confirm variable `r(rmTS)'
		if "`dep2n'" == "" {
			local dep2n "`dep2'"
		}
		syntax [varlist(default=none ts fv)] [, /*
			*/  OFFset(varname numeric) noCONstant ]

		if !`fvops' {
			local fvops = "`s(fvops)'" == "true"
		}

		local ind2 `varlist'
		local offset2 `offset' 
		local nc2 `constant'

					/* remain options */
		local 0 "`left'"
		syntax [if] [in] [pw fw iw] [, Robust Cluster(varname)    /*
			*/ SCore(string) ITERate(passthru) /*
			*/ PARtial noSKIP/*undoc*/ LRMODEL Level(cilevel) /*
			*/ NOLOg LOg MLOpts(string) FROM(string) VCE(passthru) /*
			*/ moptobj(passthru) * ]
		local title "Seemingly unrelated bivariate probit"
		local option0 `options'
		marksample touse
		markout `touse' `dep1' `dep2' `ind1' `ind2' `offset1'	  /*
          		*/ `offset2'
	}
	
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}
					
	if "`partial'" != "" {
		local title "Partial observability bivariate probit"
	}        
	
	local wtype `weight'
        local wtexp `"`exp'"'
        if "`weight'" != "" { local wgt `"[`weight'`exp']"'  }
	
	_get_diopts diopts option0, `option0'
	mlopts stdopts, `option0'
	local coll `s(collinear)'
	local cns `s(constraints)'
	
	if "`cluster'" ! = "" { local clopt "cluster(`cluster')" }
	_vce_parse, argopt(CLuster) opt(Robust oim opg) old: ///
                [`weight'`exp'], `vce' `clopt' `robust'	
	local vceopt  `r(vceopt)'
        local cluster `r(cluster)'
        local robust `r(robust)'
	if "`cluster'" ! = "" { local clopt "cluster(`cluster')" }
	
	if `"`robust'"' != "" {
		local crtype crittype("log pseudolikelihood")
	}
	if _caller() < 15 {
		local parm athrho:_cons
	}
	else {
		local parm /:athrho
	}
	local diparm "diparm(athrho, tanh label(rho))"

	if "`cns'" != "" & !`fvops' {
		local vv "version 11: "
		local mm e2
		local negh negh
	}
					/* test collinearity */
	`vv' ///
	_rmcoll `ind1' `wgt' if `touse', `nc1' `coll'
	local ind1 "`r(varlist)'"
	`vv' ///
	_rmcoll `ind2' `wgt' if `touse', `nc2' `coll'
	local ind2 "`r(varlist)'"

	if "`level'" != "" {
		local level "level(`level')"
	}

	if "`score'" != "" {
		local n : word count `score'
		if `n'==1 & bsubstr("`score'",-1,1)=="*" {
			local score = /*
	 		*/ bsubstr("`score'",1,length("`score'")-1)
	 		local score `score'1 `score'2 `score'3
	 		local n
		}
	}

	local scvar `"`score'"'

	if "`scvar'" != "" {
		local n : word count `scvar'
		if `n'!=3 {
			noi di in red "score() requires that 3 variables " /*
			*/ "be specified"
			exit 198
		}
		confirm new var `scvar'
                local scvar1 : word 1 of `scvar'
                local scvar2 : word 2 of `scvar'
                local scvar3 : word 3 of `scvar'
                tempvar sc1 sc2 sc3
                local scopt "score(`sc1' `sc2' `sc3')"
        }

	if "`offset1'" != "" { local offo1 "offset(`offset1')" }
        if "`offset2'" != "" { local offo2 "offset(`offset2')" }

	if "`lrmodel'" != "" {
		_check_lrmodel, `skip' `constant' constraints(`cns') ///
			options(`clopt' `robust' `nc1' `nc2') ///
			indep(`ind1' `ind2')
		local skip noskip
	}
	local skip = cond("`skip'"!="","","skip")

	* -mllog- passed to command to let -log- overwrite c(iterlog) off
	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	qui {
		if "`log'" == "" {
                        local log "noisily"
                }
                else    local log "quietly"

		count if `touse' 
		local N = r(N)
		count if `dep1'==0 & `touse'
		local d10 = r(N)
		count if `dep2'==0 & `touse'
		local d20 = r(N)
		if `d10' == 0 {
			di in red "`dep1' is never zero"
			exit 2000
		}
		else if `d10' == `N' {
			di in red "`dep1' is always zero"
			exit 2000
		}
		else if `d20' == 0 {
			di in red "`dep2' is never zero"
			exit 2000
		}
		else if `d20' == `N' {
			di in red "`dep2' is always zero"
			exit 2000
		}

		if "`partial'" != "" {
			tempvar p1
			gen `p1' = (`dep1'!=0)*(`dep2'!=0)
			local ddd1 "`p1'"
			local ddd2 "`p1'"
		}
		else {
			local ddd1 "`dep1'"
			local ddd2 "`dep2'"
		}
		
		if "`from'" == "" {
			local log0 `log'
			if "`partial'" != "" {
				local log qui
			}
			`log' di in gr _n /*
		        */	"Fitting comparison equation 1:" 
			`vv' ///
			capture `log' probit `ddd1' `ind1' `wgt' /*
			*/ if `touse', `offo1'   `nc1' asis nocoef /*
			*/ `crtype' iter(`=min(1000,c(maxiter))') /*
			*/ `stdopts' `mllog'
			if _rc == 0 {
				tempname b1
				mat `b1' = get(_b)
				local ll1 = e(ll)
				`vv' ///
				mat coleq `b1' = `dep1n'
			}
			`log' di in gr _n /*
			*/ "Fitting comparison equation 2:" 
			`vv' ///
			capture `log' probit `ddd2' `ind2' `wgt' /*
			*/ if `touse', `offo2'   `nc2' asis nocoef /*
			*/ `crtype' iter(`=min(1000,c(maxiter))') /*
			*/ `stdopts' `mllog'
			local ll_str `e(crittype)'
			if _rc == 0 {
				tempname b2
				mat `b2' = get(_b)
				local ll2 = e(ll)
				`vv' ///
				mat coleq `b2' = `dep2n'
			}
			local llp = `ll1' + `ll2'
			local log `log0'
			if "`b1'`b2'" != "" {
				tempname from
				if "`b1'" != "" & "`b2'" != "" { 
					mat `from' = `b1' , `b2'
					if "`partial'" == "" {
					`log' di in gr _n /*
					*/ "Comparison:    `ll_str' = " /*
                                        */ in ye %10.0g `llp'
					}
				}
				else if "`b1'" != "" {
					mat `from' = `b1'
					local lrtest "nolrtest"
				}
				else {
					mat `from' = `b2'
					local lrtest "nolrtest"
				}
				local getvals 1
			}
			if "`partial'" != "" {
				`log' di in gr _n /*
				*/	"Fitting comparison model: "
				#delimit ;
				`vv'
				`log' ml model lf bip0_lf 
				   (`dep1n' : `dep1' = `ind1', `nc1' `offo1')
				   (`dep2n' : `dep2' = `ind2', `nc2' `offo2')
				   if `touse' `wgt', collinear missing max
				   nooutput nopreserve init(`from') `crtype'
				   `stdopts' `iterate' `mllog';
				#delimit cr
				local llp = e(ll)
			}
		}

		if "`nc1'`nc2'" != ""   { local skip "skip" }
		if "`ind1'`ind2'" == "" { local skip "skip" }
		if "`robust'" != ""     { local skip "skip" }

		tempname a0
		if "`skip'" == "" {
			tempname a from0
			`vv' ///
			capture probit `ddd1' if `touse' `wgt', `offo1' /*
				*/ asis iter(`=min(1000,c(maxiter))') /*
				*/ `stdopts'
			if _rc == 0 {
				tempname cb1
				mat `cb1' = get(_b)
				mat coleq `cb1' = `dep1n'
			}
			`vv' ///
			capture probit `ddd2' if `touse' `wgt', `offo2' /*
				*/ asis iter(`=min(1000,c(maxiter))') /*
				*/ `stdopts'
			if _rc == 0 {
				tempname cb2
				mat `cb2' = get(_b)
				mat coleq `cb2' = `dep2n'
			}
			mat `a' = (-.3)
			mat colnames `a' = `parm'
			if "`cb1'" != "" & "`cb2'" != "" {
				mat `from0' = `cb1',`cb2'
			}
			else if "`cb1'" != "" { mat `from0' = `cb1' }
			else if "`cb2'" != "" { mat `from0' = `cb2' }
			mat `from0' = `from0',`a'

			`log' di in gr _n "Fitting constant-only model:"
			if "`partial'" != "" {
				#delimit ;
				`vv'
				`log' ml model `mm' bipp_lf 
					(`dep1n': `dep1' = , `nc' `offo1'  )
					(`dep2n': `dep2' = , `nc' `offo2'  )
					/athrho	
					if `touse' `wgt', collinear missing 
					max nooutput nopreserve wald(0) 
					init(`from0') search(off) `lrtest'
					`mlopts' `stdopts' `level' `diopts'
					nocnsnotes `crtype' `diparm' `negh' 
					`iterate' `mllog';

				#delimit cr
			}
			else {
				#delimit ;
				`vv'
				`log' ml model `mm' bipr_lf 
					(`dep1n': `dep1' = , `nc' `offo1'    )
					(`dep2n': `dep2' = , `nc' `offo2'  )
					/athrho	
					if `touse' `wgt', collinear missing 
					max nooutput nopreserve wald(0) 
					init(`from0') search(off) `lrtest'
					`level' `mlopts' `stdopts' `diopts'
					nocnsnotes `crtype' `diparm' `negh'
					`iterate' ;
				#delimit cr
			}
			local cont "continue"
			if "`getvals'" != "" {
				mat `a0' = get(_b)
				mat `a0' = `a0'[1,3]
				mat colnames `a0' = `parm'
				mat `from' = `from',`a0'
			}
		}
		else {
			if "`getvals'" != "" {
				mat `a0' = (0)
				mat colnames `a0' = `parm'
				mat `from' = `from',`a0'
			}
		}
		if "`cns'" != "" | "`skip'" != "" {
			local cont `cont' wald(2)
		}
	}

	`log' di in gr _n "Fitting full model:"
	if "`partial'" != "" {
		#delimit ;
		`vv'
		`log' ml model `mm' bipp_lf 
			(`dep1n': `dep1' = `ind1', `nc1' `offo1'  )
			(`dep2n': `dep2' = `ind2', `nc2' `offo2'  )
			/athrho	
			if `touse' `wgt', collinear missing max nooutput 
			nopreserve `cont' title(`title') `scopt' `vceopt'
			init(`from') search(off) `lrtest' `diopts'
			`level' `mlopts' `ll0' `stdopts' `diparm' `negh'
			`iterate' `moptobj' `mllog';
		#delimit cr
	}
	else {
		#delimit ;
		`vv'
		`log' ml model `mm' bipr_lf 
			(`dep1n': `dep1' = `ind1', `nc1' `offo1'  )
			(`dep2n': `dep2' = `ind2', `nc2' `offo2'  )
			/athrho	
			if `touse' `wgt', collinear missing max nooutput 
			nopreserve `cont' title(`title') `scopt' `vceopt'
			init(`from') search(off) `lrtest' `diopts'
			`level' `mlopts' `ll0' `stdopts' `diparm' `negh'
			`iterate' `moptobj' `mllog';
		#delimit cr
	}
	
	tempname junk
	capture matrix `junk' = get(Cns)
	if !_rc { local hascns hascns }
	
	local r = _b[/athrho]
	est scalar rho = (expm1(2*`r'))/(exp(2*`r')+1)
        if "`scvar'" != "" { 
		rename `sc1' `scvar1' 
		rename `sc2' `scvar2' 
		rename `sc3' `scvar3' 
		est local scorevars `scvar'
	}
	
	if "`llp'" != "" & "`robust'`lrtest'`hascns'" == "" {
		est scalar ll_c = `llp'
		est scalar chi2_c = abs(-2*(e(ll_c)-e(ll)))
		est local chi2_ct "LR"
	}
	else {
		qui test _b[/athrho] = 0
		est scalar chi2_c = r(chi2)
		est local chi2_ct "Wald"
	}
	est scalar k_aux = 1
	est scalar k_eq_model = 2
	est local marginsok 	default		///
				P11		///
				p10		///
				p01		///
				p00		///
				pmarg1		///
				pmarg2		///
				pcond1		///
				pcond2		///
				xb1		///
				xb2
	est local marginsnotok stdp1 stdp2
	est hidden local marginsderiv	default	///
					P11	///
					P01	///
					P10	///
					P00	///
					pmarg1	///
					pmarg2	///
					pcond1	///
					pcond2
	est local predict "bipr_p"
        est local cmd "biprobit"

        Display ,`level' `diopts'
	exit `e(rc)'
end

program define Display
	syntax [,Level(cilevel) *]
	_get_diopts diopts, `options'
	version 9.1: ml di, level(`level') nofootnote `diopts'
	DispLr
	_prefix_footnote
end

program define DispLr
	
	if "`e(ll_c)'`e(chi2_c)'" == "" {
		exit
	}
	
	local chi : di %8.0g e(chi2_c)
	local chi = trim("`chi'")
	
	if "`e(ll_c)'"=="" {
		di in green "Wald test of rho=0: " ///
			in green "chi2(" in ye "1" in gr ") = " ///
			in ye "`chi'" ///
			in green _col(59) "Prob > chi2 = " in ye %6.4f ///
			chiprob(1,e(chi2_c))
		exit
	}
	
        di in green "LR test of rho=0: " ///
        	in green "chi2(" in ye "1" in gr ") = " in ye `chi' ///
        	in green _col(59) "Prob > chi2 = " in ye %6.4f ///
		chiprob(1,e(chi2_c))
end

program define rmTS, rclass

	local tsnm = cond( match("`0'", "*.*"),  		/*
			*/ bsubstr("`0'", 			/*
			*/	  (index("`0'",".")+1),.),     	/*
			*/ "`0'")

	return local rmTS `tsnm'
end
