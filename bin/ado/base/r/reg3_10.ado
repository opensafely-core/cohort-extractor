*! version 6.5.0  13mar2018
program define reg3_10, eclass byable(recall)
	version 6.0, missing

	if replay() {
		if "`e(cmd)'" != "reg3" & /*
			*/ !("`e(cmd)'" == "sureg" & /*
			*/ inlist("`e(method)'", "sure", "isure")) {
			error 301
		}
		if _by() {
			error 190
		}
		syntax [ , noFOoter noHeader noTable Level(cilevel) ]
	} 
	else {
		local cmdline : copy local 0
		/*  Parse (y1 x1 x2) (y2 y1 x2 x3) structure.
		 *  Pick up full varlist (flist), y-array (y`i'), independent
		 *  variables (ind`i') left-hand  sides (lhslist), 
		 *  equation names (eqnm`i') 
		*/
		local neq = 0
		
		/*  Parse the equations ([eqname:] y1 [y2 y3 =] x1 x2 x3) 
		 *  and fill in the structures required for estimation */

		gettoken fulleq 0 : 0, parse(" ,[") match(paren)
		IsStop `fulleq'
		while `s(stop)' == 0 { 
			if "`paren'" != "(" {		/* must be eq */
				eq ?? `fulleq' 
				local fulleq "`r(eqname)': `r(eq)'"
			} 
			parseEqn `fulleq'

			/* Set-up equation bookkeeping structures */
			local flist `flist' `depvars' `indvars'
			tokenize `depvars'
			local i 1
			while "``i''" != "" {
				local neq = `neq' + 1
				local y`neq' ``i''
				local lhslist `lhslist' ``i''
				local ind`neq' `indvars'
				local cons`neq' = ("`constan'" == "")
				nameEq "`eqname'" "``i''" "`eqlist'" `neq'
				local eqnm`neq' = "`s(eqname)'"
				local eqlist `eqlist' `s(eqname)'
				local i = `i' + 1
			}

			gettoken fulleq 0 : 0, parse(" ,[") match(paren)
			IsStop `fulleq'
		}
		local 0 `"`fulleq' `0'"'

		if `neq' < 1 { 
			di in red "equation(s) required" 
			exit 198
		}

		/*  process options */

		/* kludge to pull nodfk and nosmall */
                /* Do quietly to avoid two "(analytic weights assumed)"
                   msgs. if you specify [w = <wtvar>] */
		qui syntax [if] [in] [aw fw] [, noDFK noSMall * ]
		local nodfk `dfk'
		local nosmall `small'

		syntax [if] [in] [aw fw] [, 2sls 3sls Allexog noConstant    /*
			*/ Constraints(string) CORr(string) DFK DFK2	    /*
			*/ EXog(varlist) First noFOoter ENdog(varlist)      /*
			*/ noHeader INst(varlist) ITerate(int `c(maxiter)') /*
			*/ IReg3 Level(cilevel) Mvreg NOLOg LOg Ols SMall   /*
			*/ SUre noTable TOLerance(real 1e-6) TRace *]

		_get_diopts diopts, `options'
		/*  Process the estimation method options */
		local method `2sls' `3sls' `ols' `sure' `mvreg'
		local i : word count `method'
		if ( `i' > 1 ) {
disp in red "cannot specify more that one estimation method: `method'"
			exit 198
		}
		if "`method'" == "" {
			local method = "3sls"
		}
		if "`method'" == "ols" | "`method'" == "mvreg" | /*
		*/ "`method'" == "2sls" {
			if "`dfk2'" == "" {
				local dfk dfk
			}
			local small small
			if "`method'" == "ols" | "`method'" == "2sls" {
				local corr independent
			}
		}
		if "`method'" == "ols"  | "`method'" == "mvreg" | /*
			*/ "`method'" == "sure" {
			local allexog allexog
		}

		if "`dfk'" != "" & "`dfk2'" != "" {
			di in red "cannot specify both dfk and dfk2"
			exit 198
		}

		/*  Process some options and implied settings */

		if `iterate' != `c(maxiter)' {
			local ireg3 ireg3
		}

		setCorr corr : "`corr'"

		/* allow over-ride for some default re-settings */
		if "`nodfk'" != "" {
			local dfk ""
		}
		if "`nosmall'" != "" {
			local small ""
		}

		/*  Errors in command */
		if "`inst'" != "" & ("`endog'" != "" | "`exog'" != "") {
di in red "cannot specify an instrument list with an " /* 
*/ "exogenous or endogenous list."
			exit 198
		}

		/* Process exog list and endog lists. Full endogenous list 
		   may exceed number of left-hand sides.  */
		DropDup flist : "`flist'"
		if "`allexog'" != "" {
			local exlist "`flist'"
		}
		else {
			if "`inst'" == "" {
				Subtract extendg : "`endog'" "`flist'"
				if "`extendg'" != "" {
					di in blue /*
*/ "note:  additional endogenous variables not in the system have no effect" 
DispVars "       and are ignored:  " "`extendg'" 13 78 blue
				}

				/*  Allow an exogenous over-ride of 
				 *  endogenous variables */
				Subtract enlist : "`lhslist'" "`exog'"
				local enlist `enlist' `endog'
				DropDup enlist : "`enlist'"
				Matches both : "`exog'" "`enlist'"
				if "`both'" != "" {
DispVars "cannot specify variables as both endogenous and exogenous:  " /*
*/ "`both'" 10 78 red
					exit 198
				}
				local flist `flist' `exog'
				DropDup flist : "`flist'"

				/*  No endog-exog matches, safe to assume 
				 *  all non-endog are exog */
				Subtract exlist : "`flist'" "`enlist'"
			}
			else {
				DropDup exlist : "`inst'"
				Subtract enlist : "`flist'" "`exlist'"
			}
		}
			
		/*  Set obs to use */
		marksample touse, novarlist
		markout `touse' `enlist' `exlist'
		tempvar one				/* used later too */
		g byte `one' = 1
		sum `one' [`weight'`exp'] if `touse', meanonly
		local t = r(N)
		qui count if `touse'
		local covpat = r(N)
		local nex : word count `exlist'
		local nex = `nex' + ("`constan'" == "")
		if `covpat' <= `nex' &  /*
		*/ ("`method'" == "3sls" | "`method'" == "2sls") { 
			noi error 2001 
		} 

		/* Process information about equations. Set up temporary 
		 * storage. */
		tempname DF
		mat `DF' = I(`neq')

		local i 1
		while `i' <= `neq' {
			local k`i' : word count `ind`i''
			local k`i' = `k`i'' + `cons`i''
			local k_tot = `k_tot' + `k`i''
			if `k`i'' > `covpat' {
				noi error 2001
			}

			testIdnt "`ind`i''" "`exlist'" `eqnm`i'' `y`i''

			/*  Residual vars and list disturbance cov */
			tempvar res`i'
			local reslist `reslist' `res`i''

			/*  Build matrix column and equation name lists */
			local matcols `matcols' `ind`i''
			if `cons`i'' {
				local matcols "`matcols' _cons"
			}
			local j 1
			while `j' <= `k`i'' {
				local coleq `coleq' `eqnm`i''
				local j = `j' + 1
			}

			/*  Matrix of denominators for residual covariance */
			if "`dfk'" == "dfk" {
				local j 1
				while `j' <= `i' {
					mat `DF'[`i',`j'] = 1 / /*
					*/ sqrt((`t' - `k`i'') * (`t' - `k`j''))
					if `i' != `j' {
						mat `DF'[`j', `i'] = /*
						*/ `DF'[`i', `j'] 
					}
					local j = `j' + 1
				}
			}
			local i = `i' + 1
		}

		if "`dfk2'" != "" {
			GetDFK2adjust ,		/*
			*/ k(`k_tot')		/*
			*/ keq(`neq')		/*
			*/ colnames(`matcols')	/*
			*/ coleqs(`coleq')	/*
			*/ clist(`constra')	/*
			*/
			local df_adj = 1 / (`t' - r(adj))
		}
		else {
			local df_adj = 1 / `t'
		}

		/*  Perform OLS to get the instrumental estimates of the Y's 
		 *  (for all non-exogenous terms). Build a list of instrument 
		 * names (it is aligned with enlist. */
		if "`first'" != "" {
			di in gr _newline "First-stage regressions"
			di in gr          "-----------------------"
			local show1 = "noi"
		}
		tokenize `enlist'
		local i 1
		while "``i''" != "" {
			cap `show1' reg ``i'' `exlist' if `touse' /*
				*/ [`weight'`exp'], `constan'
			if _rc != 0 {
				di in red "1st stage failure."
				DispVars "    Equation:  ``i'' " "`exlist'" /*
					*/ 10 78 red
				exit _rc
			}
			tempvar iv`i'
			local inlist `inlist' `iv`i''
			qui _predict double `iv`i'' if `touse'
			local i = `i' + 1
		}

		/*  Form the indep variable lists with the instrumental 
		 *  variables in place of the endogenous variables.
		 */
		local i 1
		while `i' <= `neq' {
			Subst indi`i' : "`ind`i''" "`enlist'" "`inlist'"
			if `cons`i'' {
				local indi`i' `indi`i'' `one'
			} 
			local i = `i' + 1
		}

/* <<==========  */
/* 
 *  Disturbance matrix ==> (B, VCE) ==> Disturbance matrix loop
 *  Acts like a do ... while
*/

tempname EpE EpEi EpEiB V b bhold errll
tempname sZpZ Zpy sZpy ZpZ ZpyS sigma

_parse_iterlog, `log' `nolog'
local log "`s(nolog)'"
local iterate = max(1, `iterate')
mat `EpE' = I(`neq')         /* prime for first-pass cov est */
local done 0
local itcnt 0
while !`done' {

	/*  Get the inverse covariance matrix of errors.  On first pass, 
	 *  just let the 2SLS/OLS cov.  matrix result */
	if `itcnt' != 0 { 
		qui mat accum `EpE' = `reslist' if `touse' /*
			*/ [`weight'`exp'], nocons
	}
	cap drop `reslist'

	if "`dfk'" != "" {		/* this is not common, will be slow */
		mElMult "`EpE'" "`DF'"
	}
	else {
		mat `EpE' = `EpE' * `df_adj'
	}
	mat `EpEi' = syminv(`EpE')
	if "`corr'" == "independent" {
		mat `EpEiB' = syminv(diag(vecdiag(`EpE')))
	} 
	else { 
		mat `EpEiB' = `EpEi' 
	}
	chkDiag "`EpEiB'"

	/*  Get the Covariance matrix of the 3SLS estimator.  We build it 
	 *  in pieces extracting only portions of the Z_1'Z_2 accumulated 
	 *  matrices for each equation pair.  Get the (EpEi (X) I) y too.  
	 *  The latter is built separately looping over the full row and 
	 *  column combinations to avoid extra storage and bookkeeping.  
	 *  Could make this a bit faster by using the Z_1'Z_1 and Z_n'Z_n 
	 *  computed with the 2nd and next to last accums. 
	 */
	local ktot : word count `matcols'
	mat `sZpZ' = J(`ktot', `ktot', 0)
	cap {
		mat drop `sZpy'
	}

	local at_i 1
	local i 1
	while `i' <= `neq' {
		local frm = `k`i'' + 1
		mat `ZpyS' = J(1, `k`i'', 0)

		local at_j 1
		local j 1
		while `j' <= `neq' {
			scalar `sigma' = `EpEiB'[`i',`j']

			/*  Get Cov. matrix. */
			if `j' <= `i' {
				qui mat accum `ZpZ' = `indi`i'' `indi`j'' /*
					*/ if `touse' [`weight'`exp'], /*
					*/ noconstant
				mat `sZpZ'[`at_i',`at_j'] = /*
					*/ `ZpZ'[1..`k`i'',`frm'...]*`sigma'
				if `i' != `j' {
					mat `sZpZ'[`at_j',`at_i'] = /*
					*/ `ZpZ'[1..`k`i'',`frm'...]'*`sigma'
				}
			}

			/*  Get sum(sigma Z_i y_j) */
			mat vecaccum `Zpy' = `y`j'' `indi`i'' if `touse' /*
				*/ [`weight'`exp'], noconstant
			mat `ZpyS' = `ZpyS' + `Zpy'*`sigma'

			local at_j = `at_j' + `k`j''
			local j = `j' + 1
		}
		/*  Build (EpEiB (X) I) y    */
		mat `sZpy' = nullmat(`sZpy') \ `ZpyS''
		
		local at_i = `at_i' + `k`i''
		local i = `i' + 1
	}

	/*  Get variance-covariance matrix and vector of 
	 *  coefficients. Post results.   
	 */
	mat `V' = syminv(`sZpZ') 
	mat `b' = `sZpy'' * `V''
	mat rownames `V' = `matcols'
	mat roweq `V' = `coleq'
	mat colnames `V' = `matcols'
	mat coleq `V' = `coleq'
	mat colnames `b' = `matcols'
	mat coleq `b' = `coleq'

	if "`small'" == "small" {
		local tdof = `t'*`neq' - `k_tot' 
		estimates post `b' `V', dof(`tdof') esample(`touse')
	} 
	else { 
		local tdof = `t'
		estimates post `b' `V', obs(`t') esample(`touse')
	}
	gen byte `touse' = e(sample)

	/*  Apply constraints */
	if "`constra'" != "" {
		Constrn "`constra'" "`small'" `tdof'
	}

	mat `b' = get(_b)
	if `itcnt' == 0 {
		mat `bhold' = 2 * `b'
	}
	local rdiff = mreldif(`b', `bhold')
	mat `bhold' = `b'

	/* Evaluate stopping conditions */
	if ("`ireg3'" != "ireg3" & `itcnt' != 0) | `itcnt' >= `iterate' | /*
		*/ `rdiff' < `toleran' {
		local done 1
	}
	else {
		/*  Get new residual vectors for error covariance matrix */
		local i 1
		while `i' <=`neq'  {
			qui _predict double `res`i'', eq(`eqnm`i''), if `touse'
			qui replace `res`i'' = `y`i'' - `res`i''
			local i = `i' + 1
		}
	}
	if "`ireg3'" == "ireg3" & "`log'" != "nolog" {
		if `itcnt' > 0 {
			disp in gr "Iteration `itcnt':   " /*
				*/ "tolerance = " in ye %10.7g `rdiff'
			if "`trace'" == "trace" {
				mat list `b'
			}
		}
		else	di
	}
	local itcnt = `itcnt' + 1

}   /* end while -- iteration loop */

		if `iterate' != 1 & `itcnt'-1 == `iterate' {
			di in blu "convergence not achieved"
		}

		/*  Equation summary statistics and retained globals */
		est local eqnames
		tempvar errs res
		local i 1
		while `i' <= `neq' {
			est scalar cons_`i' = `cons`i''
			if `k`i'' > 1 | !`cons`i'' {
				qui test [`eqnm`i'']
			} 
			else {
				qui test [`eqnm`i'']_cons
			}
			if "`small'" == "small" {
				est scalar F_`i' = r(F)
				est scalar p_`i' = r(p)
			} 
			else { 
				est scalar chi2_`i' = r(chi2)
				est scalar p_`i' = r(p)
			}
			est scalar df_m`i' = r(df)
			
			// Get RSS
			capture drop `res'
			qui _predict double `res', 		///
				 eq(`eqnm`i''), if `touse'
			qui replace `res' = (`y`i'' - `res')^2
			qui su `res' [`weight'`exp'] if `touse'
			est scalar rss_`i' = r(sum)*r(N)/r(sum_w)
			est scalar rmse_`i' = sqrt(e(rss_`i')/r(N))
			// Get MSS = TSS - RSS
			if `cons`i'' {
				qui su `y`i'' [`weight'`exp'] if `touse'
				est scalar mss_`i' = r(Var)*(r(N)-1) -	///
							e(rss_`i')
			}
			else {
				qui replace `res' = `y`i''^2
				qui su `res' [`weight'`exp'] if `touse'
				est scalar mss_`i' = r(sum)*r(N)/r(sum_w) - ///
							e(rss_`i')
			}
			if "`small'" == "small" { 
				est scalar rmse_`i' = e(rmse_`i')* ///
					sqrt(r(N) / (r(N) - `k`i''))
			}
			est scalar r2_`i' = e(mss_`i') / 	///
					(e(mss_`i') + e(rss_`i'))
			est local eqnames `e(eqnames)' `eqnm`i''
			// Store residuals for log-likelihood computation later
			qui _predict double `res`i'', 		///
				 eq(`eqnm`i''), if `touse'
			qui replace `res`i'' = `y`i'' - `res`i''
			local i = `i' + 1
		}
		est scalar k_eform = `neq'
		est scalar k = `ktot'
		est scalar ic =  `itcnt' - 1
		if "`ireg3'" == "" {
			est scalar ic = 0
		}
		est scalar N = `t'
		if "`small'" != "" {
			est scalar df_r = `tdof'
		}
		est scalar k_eq = `neq'
		est scalar dfk2_adj = 1/`df_adj'

		mat rowname `EpE' = `eqlist'
		mat colnames `EpE' = `eqlist'
		est mat Sigma `EpE'
		qui mat accum `EpE'=`reslist' if `touse' [`weight'`exp'], nocons
 		if "`corr'" == "independent" {
			mat `EpE'=diag(vecdiag(`EpE'))
		}
		setLL `EpE'
		est local wtype `weight'
		est local wexp "`exp'"
		est local depvar `lhslist'
		est local exog `exlist'
		est local endog `enlist'
 		est local dfk "`dfk'`dfk2'"
		est local corr `corr'
		est local small `small'
		est local predict reg3_p
		est local method `method'
		version 10: ereturn local cmdline `"reg3 `cmdline'"'
		est local cmd "reg3"
	}

	/* Display results */

	if "`header'" != "" {
		local noh "*"
	}
	if "`table'" != "" {
		local not "*"
	}
	if "`footer'" != "" {
		local nof "*"
	}

	local testtyp  "  chi2"
	if "`e(small)'" == "small" { 
		local testtyp "F-Stat" 
		local testpfx F
	} 
	else {
		local testtyp "  chi2"
		local testpfx chi2
	}


	local method Three-stage least-squares
	if "`e(method)'" == "ols" | "`e(method)'" == "mvreg" { 
		local method Multivariate
	}
	if "`e(method)'" == "2sls" {
		local method Two-stage least-squares
	}
	if "`e(method)'" == "sure" {
		local method Seemingly unrelated
	}
		
	di
	if "`noh'" == "" {
		di in gr "`method' regression" _c
		if `e(ic)' > 0 { 
			di in gr ", iterated "
		}
		else	di
	}
	matrix dispCns, r
	if "`r(k)'" != "0" { 
		`noh' di in gr _newline "Constraints:"
		`noh' matrix dispCns
	}
	`noh' di in smcl in gr "{hline 70}"
	`noh' di in gr "Equation          Obs  Parms        RMSE    " /*
		*/ _quote "R-sq" _quote "     `testtyp'        P"
	`noh' di in smcl in gr "{hline 70}"
	tokenize `e(eqnames)'
	local i 1
	while "``i''" != "" {
		`noh' di in ye abbrev("``i''",12) /*
			*/ _col(15) %7.0g e(N) %7.0g e(df_m`i') /*
			 */ "   " %9.0g e(rmse_`i') %10.4f e(r2_`i') "  "   /*
			 */ %9.2f e(`testpfx'_`i') %9.4f e(p_`i')
		local i = `i' + 1
	}
	`noh' di in smcl in gr "{hline 70}"
	`noh' di
	`not' estimates display, level(`level')

	if "`e(method)'" == "2sls" | "`e(method)'" == "3sls" {
		`nof' DispVars "Endogenous variables:  " "`e(endog)'" 6 78 green
		`nof' DispVars "Exogenous variables:   " "`e(exog)'"  6 78 green
		`nof' di in smcl in gr "{hline 78}"
	}

end

program define GetDFK2adjust, rclass
	version 8.0
	syntax  ,					/*
	*/	k(numlist integer min=1 max=1 >0)	/*
	*/	keq(numlist integer min=1 max=1 >0)	/*
	*/	colnames(string)			/*
	*/	coleqs(string)				/*
	*/	[					/*
	*/	clist(string)				/*
	*/	]

	local nc : word count `colnames'
	local ne : word count `coleqs'
	if `k' != `nc' {
		di as err "internal error in reg3"
		exit 198
	}
	if `ne' != `nc' {
		di as err "internal error in reg3"
		exit 198
	}

	if `"`clist'"' != "" {
		tempname b T a C
		mat `b' = J(1,`k',1)
		mat colnames `b' = `colnames'
		mat coleq `b' = `coleqs'
		Post4Cns `b'
		matrix makeCns `clist'
		matcproc `T' `a' `C'
		local cols = colsof(`T')
		mat `b' = syminv(`T'*I(`cols')*`T'')
		local k = `k' - diag0cnt(`b')
	}
	return scalar adj = `k' / `keq'
end

program define Post4Cns, eclass
	args b
	tempname v
	mat `v' = `b''*`b'
	eret post `b' `v'
end

/*  Sets the local macros containing equation information in the caller 
 *  Equations may take the form:  
 *
 *           [eqname:] y1 [y2 y3 =] x1 x2 x3 [, noconstant] 
 *
 *  Sets the callers local macros:  eqname, depvars, indvars and constan  */ 
 					/* might form basis of a _parseeq */

program define parseEqn        

	/* see if we have an equation name */
	gettoken token uu : 0, parse(" =:")   /* rare, pull twice if found */
	gettoken token2 : uu, parse(" =:")     /* rare, pull twice if found */
	if index("`token2'", ":") != 0 {
		gettoken token  0 : 0, parse(" =:")      /* sic, to set 0 */
		gettoken token2 0 : 0, parse(" =:")      /* sic, to set 0 */
		c_local eqname  `token'
	} 
	else    c_local eqname 

	/* search just for "=" */
	gettoken token 0 : 0, parse(" =")
	while "`token'" != "=" & "`token'" != "" {
		local depvars `depvars' `token'
		gettoken token 0 : 0, parse(" =")
	}

	if "`token'" == "=" {
		tsunab depvars : `depvars'
		syntax [varlist(ts)] [ , noConstant ]
	} 
	else {				/* assume single depvar */
		local 0 `depvars'
		syntax varlist(ts) [ , noConstant ]
		gettoken depvars varlist : varlist
	}

	c_local depvars `depvars'
	c_local indvars `varlist'
	c_local constan `constan'
end


/*  determine equation name */

program define nameEq, sclass
	args	    eqname	/* user specified equation name
		*/  depvar	/* dependent variable name
		*/  eqlist	/* list of current equation names 
		*/  neq		/* equation number */
	
	if "`eqname'" != "" {
		if index("`eqname'", ".") {
di in red "may not use periods (.) in equation names: `eqname'"
		}
		local eqlist : subinstr local eqlist "`eqname'" "`eqname'", /*
			*/ word count(local count)    /* overkill, but fast */
		if `count' > 0 {
di in red "may not specify duplicate equation names: `eqname'"
			exit 198
		}
		sreturn local eqname `eqname'
		exit
	}
	
	local depvar : subinstr local depvar "." "_", all

	if ustrlen("`depvar'") > 32 {
		local depvar "eq`neq'"
	}
	Matches dupnam : "`eqlist'" "`depvar'"
	if "`dupnam'" != "" {
		sreturn local eqname = usubstr("`neq'`depvar'", 1, 32)
	}
	else {
		sreturn local eqname `depvar'
	}
end


program define IsStop, sclass
	if 	     `"`0'"' == "[" /*
		*/ | `"`0'"' == "," /*
		*/ | `"`0'"' == "if" /*
		*/ | `"`0'"' == "in" /*
		*/ | `"`0'"' == "" {
		sret local stop 1
	}
	else	sret local stop 0
end


/*  Drop all duplicate tokens from list */

program define DropDup   /* <newlist> : <list> */
	args	    newlist	/*  name of macro to store new list
		*/  colon	/*  ":"
		*/  list	/*  list with possible duplicates */

	gettoken token list : list
	while "`token'" != "" {
		local fixlist `fixlist' `token'
		local list : subinstr local list "`token'" "", word all
		gettoken token list : list
	}

	c_local `newlist' `fixlist'
end


/*  Remove all tokens in dirt from full */
 *  Returns "cleaned" full list in cleaned */

program define Subtract   /* <cleaned> : <full> <dirt> */
	args	    cleaned     /*  macro name to hold cleaned list
		*/  colon	/*  ":"
		*/  full	/*  list to be cleaned 
		*/  dirt	/*  tokens to be cleaned from full */
	
	tokenize `dirt'
	local i 1
	while "``i''" != "" {
		local full : subinstr local full "``i''" "", word all
		local i = `i' + 1
	}

	c_local `cleaned' `full'       /* cleans up extra spaces */
end

/*  Returns tokens found in both lists in the macro named by matches.
 *  Duplicates must be duplicated in both lists to be considered
 *  matches a 2nd, 3rd, ... time.  */

program define Matches   
	args	    matches     /*  macro name to hold cleaned list
		*/  colon	/*  ":"
		*/  list1	/*  a list of tokens
		*/  list2	/*  a second list of tokens */

	tokenize `list1'
	local i 1
	while "``i''" != "" {
		local list2 : subinstr local list2 "``i''" "", /*
			*/ word count(local count)
		if `count' > 0 {
			local matlist `matlist' ``i''
		}
		local i = `i' + 1
	}

	c_local `matches' `matlist'
end

/*  Find all occurrences in List of tokens in FindList and replace with 
 *  corresponding token from SubstList.  Assumes FindList and SubstList 
 *  have same number of elements.
*/ 

program define Subst, sclass    /*  <NewList> : <List> <FindList> <SubstList> */
	args	    newname	/*  macro name to hold list after replacements
		*/  colon	/*  ":"
		*/  list	/*  varlist with tokens to be replaced
		*/  fndList	/*  list of tokens to be replaced 
		*/  subList	/*  varlist with replacement tokens */

	tokenize `fndList'
	local i 1
	while "``i''" != "" {
		gettoken repltok subList : subList
		local list : subinstr local list "``i''" "`repltok'", word all
		local i = `i' + 1
	}

	c_local `newname' `list'
end


/* Set disturbance covariance matrix structure. */
/* Using syntax would be nice here, but 10 character limit is problematic. */

program define setCorr   /* <corrMacro> : <corrString> */
	args	    corrmac	/*  macro name to contain corr type
		*/  colon	/*  ":"
		*/  corrstr	/*  String containing correlation words */

	if length("`corrstr'") == 0 {
		c_local `corrmac' unstructured
		exit
	}

	if bsubstr("unstructured",1,length("`corrstr'"))=="`corrstr'" {
		c_local `corrmac' unstructured
		exit
	}

	if bsubstr("independent",1,length("`corrstr'"))=="`corrstr'" {
		c_local `corrmac' independent
		exit
	}

	di in red "Unsupported disturbance correlation specified: `corrstr'"
	exit 198
end

/*  Test if equation is identified -- order condition */

program define testIdnt  /* <eqn> <exlist> */
	args	    rhs		/* rhs variables for an equation 
		*/  exlist	/* full list of exogenous variables
		*/  eqname	/*  equation name (for error display)
		*/  depvar      /*  dependent variable (for display) */

	Subtract endog : "`rhs'" "`exlist'"
	local endcnt : word count `endog'
	Subtract exog : "`exlist'" "`rhs'"
	local excnt : word count `exog'
	if `endcnt' > `excnt' {
dis in red "Equation is not identified -- does not meet order conditions"
	DispVars `"    Equation `eqname':  `depvar'  "' "`rhs'" 10 78 red
	DispVars `"    Exogenous variables:   "' "`exlist'" 10 78 red
		exit 481
	}
end

/*  Display a list of variables breaking line nicely */
/*  With new quotes `"..."' no longer need prefix, but kept */

program define DispVars  
	args	     prefix	/* prefix string for first line 
		*/   varlist	/* variable list 
		*/   strtcol	/* starting column for all lines but first 
		*/   maxlen	/* final column for writing 
		*/   color	/* color for writing */

	di in `color' `"`prefix'"' _c
	local curlen = length(`"`prefix'"')

	tokenize `varlist'
	local i = 1
	while "``i''" != "" {
		local len = length("``i''")
		if (`curlen' + `len' + 1) > `maxlen' { 
			di ""
			di _col(`strtcol') _c
			local curlen `strtcol'
		}
		di in `color' "``i'' " _c
		local curlen = `curlen' + `len' + 1
		local i = `i' + 1
	}
	disp ""
end

/*  Element-by-element matrix multiplication.  Result left in <mat1> */

program define mElMult            /* <mat1> <mat2> */
	args mat1 mat2

	local rows = rowsof(`mat1')
	local cols = colsof(`mat1')

	if `rows' != rowsof(`mat2') | `cols' != colsof(`mat2') {
		exit 503
	}

	local i 1
	while `i' <= `rows' {
		local j 1
		while `j' <= `cols' {
			mat `mat1'[`i',`j'] = `mat1'[`i',`j'] * `mat2'[`i',`j']
			local j = `j' + 1
		}
		local i = `i' + 1
	}
end

/*  sum all of the elements in a matrix */

program define mSumEls            /* <scalar_sum> : <matrix> */
	args sum colon matrix

	local rows = rowsof(`matrix')
	local cols = colsof(`matrix')

	scalar `sum' = 0
	local i 1
	while `i' <= `rows' {
		local j 1
		while `j' <= `cols' {
			scalar `sum' = `sum' + `matrix'[`i',`j']
			local j = `j' + 1
		}
		local i = `i' + 1
	}
end

/*  Check the diagonal of a matrix for missings */

program define chkDiag         /*  <matrix> */
	args mat

	local dim = rowsof(`mat')
	if `dim' != colsof(`mat') {
		exit 503
	}
	
	local i 1
	while `i' <= `dim' {
		if `mat'[`i',`i'] == 0 {
			dis in red "Covariance matrix of errors is singular"
			mat list `mat'
			exit 506
		}
		local i = `i' + 1
	}
end


/*  Apply constraints to the system */

program define Constrn        /* <constraints> <smallsmplstat> <dof> */
	args	     constr     /*  list of constraint numbers
		*/   small	/*  non-blank ==> t-stat, not z-stat
		*/   dof 	/*  degrees of freedom			*/


	tempname A beta C IAR j R Vbeta touse

	matrix makeCns `constr'
	matrix `C' = get(Cns)

	local cdim = colsof(`C')
	local cdim1 = `cdim' - 1

	matrix `R' = `C'[1...,1..`cdim1']
	matrix `A' = syminv(`R'*get(VCE)*`R'')
	local a_size = rowsof(`A')

	scalar `j' = 1
	while `j' <= `a_size' {
		if `A'[`j',`j'] == 0 {
			error 412
		} 
		scalar `j' = `j' + 1
	}
	matrix `A' = get(VCE)*`R''*`A'
	matrix `IAR' = I(colsof(get(VCE))) - `A'*`R'
	matrix `beta' = get(_b) * `IAR'' + `C'[1...,`cdim']'*`A''
	matrix `Vbeta' = `IAR' * get(VCE) * `IAR''

	gen byte `touse' = e(sample)
	if "`small'" == "small" {
		estimates post `beta' `Vbeta' `C', dof(`dof') esample(`touse')
	} 
	else { 
		estimates post `beta' `Vbeta' `C', obs(`dof') esample(`touse')
	}
end

program define setLL, eclass
	args	    EpE		/* accum of residuals  (is modified)*/

	tempname SIGi
	mat `SIGi' = (1/(e(N))) * `EpE'

	est scalar ll = -0.5 * (e(N)*e(k_eq)*ln(2*_pi) +  /*
		*/  e(N)*ln(det(`SIGi')) + e(N)*e(k_eq))

/*  Blunt, inefficient method.
	mat `SIG'  = syminv(`SIGi')
	mElMult `EpE' `SIG'
	mSumEls  `ll_err' : `EpE'
	est scalar ll = -0.5 * (e(N)*e(k_eq)*ln(2*_pi) +  /*
		*/  e(N)*ln(det(`SIGi')) + `ll_err')
*/

end

exit

- Requires double storage for the total number of endogenous variables
  (left hand side or otherwise) + double storage for the errors from each
  equation.

-  Currently constraints are tested after the first stage.  This is
	a matter of convenience, since the full model has not been constructed 
	until that point.  However, it could cause some wasted time if the 
	specified constraints are invalid for the model.

-  Due to the way constraints are applied, constrained models cannot be 
	estimated if the unconstrained model is not identified and has 
	sufficient data.

