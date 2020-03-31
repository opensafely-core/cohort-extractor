*! version 6.4.5  18sep2017
program define prais, eclass byable(recall)
	version 6.0, missing

	if replay() { 
		syntax [ , Level(cilevel) noDW CORC *]

		if _by() {
			error 190
		}
		if !("`e(cmd)'" == "prais" | /*
			*/ ("`e(cmd)'" == "corc" & "`corc'" == "corc")) { 
			error 301
		} 
		_get_diopts diopts, `options'
		local cfmt `"`s(cformat)'"'
	}
	else {
		local vv : display "version " string(_caller()) ", missing:"
		local cmdline : copy local 0
		if _caller()<=5 { 
			local t "t(varname)"
		}
		syntax varlist(fv ts) [if] [in] [fw aw]                 /*
			*/ [ , Beta noCONstant CORC                     /*
			*/ DEPname(varname) DETail noDW Hascons		/*
			*/ ITerate(integer 100) Level(cilevel)		/*
			*/ noLOg SAVEspace SCore(string)		/* 
			*/ RHOtype(string) SSEsearch TRace WEIGHTS	/*
			*/ TOLerance(real 1e-6) TWOstep `t'		/*
			*/ VCE(passthru) Robust CLuster(passthru) hc2 hc3 * ]

		local fvops = "`s(fvops)'" == "true" | _caller() >= 11
		_get_diopts diopts options, `options'
		opts_exclusive "`hc2' `hc3'"
		if `"`vce'"' != "" {
			opts_exclusive "`vce' `hc2' `hc3'"
		}
		else if "`hc2'`hc3'" != "" {
			local vce "vce(`hc2' `hc3')"
		}
		_vce_parse, argopt(CLuster) opt(OLS Robust HC2 HC3) old	///
			: [`weight'`exp'], `vce' `robust' `cluster'
		if "`r(cluster)'" != "" {
			local options `options' cluster(`r(cluster)')
		}
		else if "`r(vce)'" != "ols" {
			local options `options' `r(vce)'
		}
		local vce = cond("`r(vce)'" != "", "`r(vce)'", "ols")
		if `"`s(fvops)'"' == "true" & "`savespa'" != "" {
			di as err ///
"option savespace is not allowed with factor variable operators"
			exit 198
		}

		if "`t'"!="" { 		/* meaning _caller()==5, too */
			qui tsset `t', noquery
			local t
		}
		
		if "`weight'" != "" & "`weights'"=="" {
			di as error "weights not allowed"
			exit 101
		}

					/* Process syntax errors */
		if "`depname'" != "" {
			di in red "Options beta, depname() not allowed"
			exit 198
		}

		if "`twostep'" != "" & "`ssesear'" != "" {
di in red "options twostep and ssesearch are mutually exclusive"
			exit 198
		}
					/* Process options */
					/*  Note: global T_ variables used to 
					 *  communicate w/ the estimation 
					 *  routine prais_e */
		if "`twostep'" != "" { local iterate = 1 }
		if "`ssesear'" != "" { local ssesear "SSE search" }
		if "`log'" == "nolog" { local logout "*" }
		if "`constan'" != "noconstant"  {
			global T_tsscon "tsscons"
			if "`hascons'" == "" { global T_cons  "_cons" }
		}
		if "`score'" != "" {
			confirm new var `score'
			global T_score `score'
			local score "score(`score')" 
		}
		global T_opts `options' `score'
		global T_corc `corc'

		if "`weight'" != "" {
			tempvar myw
			qui gen double `myw'`exp'
			qui xtsum `myw'
			if r(sd_w) > 1e-10 {
di as error "weight must be constant within panel"
exit 198 
			}
		}	


					/* Set sample */
		marksample touse
		_ts timevar panvar, panel
		markout `touse' `timevar'
		gettoken depvar : varlist
		_fv_check_depvar `depvar'
		if `fvops' {
			local rmdcoll "version 11: _rmdcoll"
		}
		else	local rmdcoll _rmdcoll
		if "`hascons'" == "" {
			`rmdcoll' `varlist'  if `touse', `constan'
		}
		else	`rmdcoll' `varlist'  if `touse', nocons
		if `fvops' {
			fvexpand `r(varlist)' if `touse'
			local varlist `depvar' `r(varlist)'
		}
		else	local varlist `depvar' `r(varlist)'

		if "`savespa'" != "" {
			preserve
			tsrevar `varlist', list
			keep `r(varlist)' `touse' `timevar' `panvar'
			sort `panvar' `timevar'
		}

					/* Report time gaps */
		tsreport if `touse', report `detail'
		local gaps `r(N_gaps)'
		if `gaps' > 0 {
			di in bl "(note: computations for rho "	/*
				*/ "restarted at each gap)" 
		}

					/*  Estimation loop */

		tempname one rho lastrho dw0 dw_fin b unused
		tempvar resid
		gen double `one' = 1
		global T_fullv `varlist'
		if "$T_cons" != "" { global T_fullv "$T_fullv `one'" }
		local k : word count $T_fullv
		gettoken (global) T_depv (global) T_indv : varlist
		global T_touse `touse'


		`vv' ///
		qui _regress `varlist' [`weight'`exp'] if `touse' , /*
			*/ `constan' `options'
		local nobs1 = e(N)

		if "`ssesear'" != "" {
			if "`weight'" != "" {
di as error "weights may not be used with ssesear"
exit 198
			}
			
			tempname it_ct
			qui predict double `resid'  if `touse' , resid
			DW `dw0' : `resid'            /* durbin-watson */
			_linemax `rho' `unused' `it_ct' :  "prais_e" "rho" /*
				*/ -1 .2 `iterate' `toleran' , `log' `trace'
		}
		else {
			di
			scalar `rho' = 0
			scalar `lastrho' = 2
			local it_ct = 0

			while `it_ct' < `iterate' & /*
			*/ abs(`rho'-`lastrho') > `toleran' {

						/*  Estimate rho */
				scalar `lastrho' = `rho'
				cap drop `resid'
				qui predict double `resid'  if `touse' , resid
				if "`weight'" != "" {
					`vv' ///
					getrho `resid' [`weight'`exp'], /*
						*/ `rhotype' rho(`rho') /*
						*/ touse(`touse')
				}		
				else {
					_crcar1 `rho' rhotype : `resid',  /*
						*/ k(`k') `rhotype'
				}
						/* First iteration items */
				if `it_ct' == 0 { 
					DW `dw0' : `resid' 
`logout' di in gr "Iteration `it_ct':  rho = " in ye %6.4f 0
				}

						/* Estimate model */
				if "`weight'" == "" {		
					prais_e `unused' : `rho'
				}
				else {
					prais_e2 , weight(`weight') exp(`exp')/*
						*/ negsse(`unused') rho(`rho')
				}	

				local it_ct = `it_ct' + 1
				`logout' di in gr /*
					*/ "Iteration `it_ct':  rho = " /*
					*/ in ye %6.4f `rho'
			}
		}

					/* Saved results */
		est scalar N_gaps = `gaps'
		est scalar tol  = `toleran'
		est scalar max_ic = `iterate'
		est scalar ic = `it_ct'
		if bsubstr("`e(vcetype)'",1,6) == "Robust" { 
			est local vcetype = /*
				*/ "Semir" + bsubstr("`e(vcetype)'", 2, .)
		}
		est local vce `vce'
		est local cons `constan'
		if `"`dw'"' == `""' & "`weight'"=="" {
					/* transformed durbin-watson */
			DWdiff `dw_fin' : `rho'

			est scalar dw = `dw_fin'
			est scalar dw_0 = `dw0'
			global S_E_dw = e(dw)
			global S_E_dwo = `dw0'                      /* sic */
		}
		est local rhotype `rhotype'
		est scalar rho = `rho'
		est local estat_cmd ""		/* reset to blank */
		est local predict "prais_p"
		est local depvar `"$T_depv"'
		est local marginsok "XB default"
		global S_E_in `"`in'"'
		global S_E_if `"`if'"'
		global S_E_rho `rho'
		global S_E_nobs `nobs'
		global S_E_tdf `dof'
		global S_E_vl `"`varlist'"'
		global S_E_depv `"`depv'"'
		est local method "`twostep'`ssesear'"
		if "`e(method)'" == "" { est local method "iterated" }
		est local tranmeth = cond("`corc'"!="", "corc", "prais")
		if `it_ct' == `iterate' & "`twostep'" == "" {
			est local converge "false"
		}
		est local model ""
		version 10: ereturn local cmdline `"prais `cmdline'"'
		est local title "Prais-Winsten AR(1) regression"
		if "`e(V_modelbased)'" == "matrix" {
			tempname vmb
			matrix `vmb' = e(V_modelbased)
			version 11: matrix colna `vmb' = $T_indv $T_cons
			version 11: matrix rowna `vmb' = $T_indv $T_cons
			est local V_modelbased
			est matrix V_modelbased `vmb'
		}
		capture mac drop T_*
		_post_vce_rank, checksize
		est local cmd "prais" 
		global S_E_cmd "prais"
	}

					/* Display results */
	if "`e(tranmeth)'" == "corc" {
di _n in gr  "Cochrane-Orcutt AR(1) regression -- `e(method)' estimates"
	}
	else {
di _n in gr  "Prais-Winsten AR(1) regression -- `e(method)' estimates"
	}
	regress, level(`level') plus `diopts'
	if c(noisily) == 0 {
		if "`e(converge)'" == "false" { 
			error 430
		}
		exit
	}

	if `"`cfmt'"' != "" {
		local rho : display `cfmt' e(rho)
	}
	else {
		local rho : display %9.0g e(rho)
	}
	local c1 = `"`s(width_col1)'"'
	local w = `"`s(width)'"'
	capture {
		confirm integer number `c1'
		confirm integer number `w'
	}
	if c(rc) {
		local c1 13
		local w 78
	}
	local c = `c1' - 1
	local rest = `w' - `c1' - 1
        di in smcl in gr %`c's "rho" " {c |} " in ye %10s "`rho'"
	di in smcl in gr "{hline `c1'}{c BT}{hline `rest'}"

	if `"e(dw)"' != `""' & `"`dw'"' == `""' & "`weight'"== "" {
		di in gr `"Durbin-Watson statistic (original)    "' /*
			*/ in ye %8.6f e(dw_0)
		di in gr `"Durbin-Watson statistic (transformed) "' /*
			*/ in ye %8.6f e(dw)
	}
	if "`e(converge)'" == "false" { 
		error 430
	}

end


/* Compute Durbin-Watson statistic -- over all resids */

program define DW 
	args    scl_dw          /*  scalar name to hold DW result 
		*/  colon			/*  :
		*/  resids          /*  residuals */

	tempvar tres
	tempname esqlag

	qui gen double `tres' = (`resids' - l.`resids')^2
	sum `tres', meanonly
	scalar `esqlag' = r(sum)

	drop `tres'
	qui gen double `tres' = `resids' * `resids'
	sum `tres', meanonly

	scalar `scl_dw' = `esqlag' / r(sum)

end


/* Compute the DW statistic over the current model with the variables
 * rho-differenced */

program define DWdiff, eclass
	args    dw       /*  scalar name to receive the DW stat 
		*/  colon    /*  :
		*/  rho      /*  value of rho for differencing */

	tempname b
	tempvar resid

	local diflist
	tokenize $T_fullv
	local i 1
	while "``i''" != "" {
		tempname tvar
		qui gen double `tvar' = ``i'' - `rho'*l.``i'' /*
			*/ if $T_touse & l.$T_touse
		if "$T_corc" == "" {
			qui replace `tvar' = ``i'' * sqrt(1 - `rho'^2)  /*
				*/ if $T_touse & l.$T_touse != 1
		}
		local diflist  `diflist' `tvar'
		local i = `i' + 1
	}

	mat `b' = get(_b)
	gettoken depdelt difind : diflist
	version 11: mat colnames `b' = `difind'
	mat repost _b=`b', rename
	qui predict double `resid'  if e(sample)
	qui replace `resid' = `depdelt' - `resid'
	DW `dw' : `resid'

	mat `b' = get(_b)
	version 11: mat colnames `b' = $T_indv $T_cons
	mat repost _b=`b', rename buildfvinfo
	
end

program define getrho 
	local vv : display "version " string(_caller()) ", missing:"
	version 6.0, missing
	syntax varname [aw iw fw], rho(string) touse(string) [REGress FREG]

	if "`regress'`freg'" == "" {
		di as error "rhotype must be regress or freg with weights"
		exit 198 
	}
	if "`regress'" != "" & "`freg'" != "" {
		di as error "specify either regress or freg, not both"	
		exit 198
	}	

	if "`regress'" != "" {
		qui _regress `varlist' l.`varlist' [`weight'`exp'] ///
			if `touse', nocons 
		scalar `rho'=_b[L.`varlist']
	}
	if "`freg'" != "" {
		`vv' ///
		qui _regress `varlist' f.`varlist' [`weight'`exp'] ///
			if `touse', nocons
		scalar `rho'=_b[F.`varlist']
	}
end

program define gapRpt				/* not currently used */
	args 	    gapmacr	/*  macro to hold number of gaps
		*/  colon	/*  ":"
		*/  resids	/*  residual variable
		*/  touse 	/*
		*/  detail	/*  "detail" for table results, or "" */

	tempvar gaps
	qui gen byte `gaps' = `touse' & f.`resids' >= .  | _n == _N

					/* final obs in touse is not a gap */
	sum `touse', meanonly, if `touse'
	qui replace `gaps' = 0 if sum(`touse') == r(sum)

	sum `gaps', meanonly, if `touse'
	c_local `gapmacr' r(sum)

	if r(sum) > 0 {
		di in gr "Number of gaps in computing rho:  " in ye r(sum)
	}

	if r(sum) > 0 & "`detail'" != "" {
		_ts timevar panel, panel

		tempvar recnum
		qui gen byte `recnum' = _n  if `gaps'
		lab var `recnum' "Record"

		if "`panel'" != "" {
di in gr "Observations with gaps to next record (includes panel changes)"
			tabdisp `recnum', cell(`panel' `timevar'), if `gaps'
		}
		else {
			di in gr "Observations with gaps to next record"
			tabdisp `recnum', cell(`timevar'), if `gaps'
		}
		di
	}
end

exit
