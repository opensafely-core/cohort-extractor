*! version 7.5.1  21feb2019
program define arima, eclass byable(recall)
	version 7, missing
					/* limits, etc. */
	local gtol	.05			/* gradient tolerance	*/
	local infty	1e9			/* diffuse P_0 diagonal	*/

	if replay() {
		if _by() {
			error 190
		}
		if "`e(cond)'" != "" {
			arch `0'
			exit
		}
		if "`e(cmd)'" != "arima" {
			noi di in red "results of arima not found"
			exit 301
		}
		Display `0'
		exit
	}

	local cmdline : copy local 0

	syntax [varlist(ts fv)] [if] [in] [iw] [,				/*
		*/ AR(numlist int ascend >0)				/*
		*/ ARIMA(numlist int min=3 max=3 >-1)			/*
		*/ SARIMA(numlist int min=4 max=4 >-1)			/*
		*/ BHHH BHHHQ BFGS					/*
		*/ BHHHBfgs(numlist min=2 max=2 integer >=0 <99999)	/*
		*/ BHHHDfp(numlist min=2 max=2 integer >=0 <99999)	/*
		*/ noBRacket Constraints(string) noCOEF 		/*
		*/ CONDition noConstant DIffuse DFP DETail		/*
		*/ FROM(string) GTOLerance(real `gtol') noHEAD HESsian	/*
		*/ Interval(integer 1) Level(cilevel) 		/*
		*/ MA(numlist int ascend >0)  				/*
		*/ MAR1(string) MAR2(string) MAR3(string) MAR4(string)	/*
		*/ MAR5(string) MAR6(string) MAR7(string) MAR8(string)	/*
		*/ MMA1(string) MMA2(string) MMA3(string) MMA4(string)	/*
		*/ MMA5(string) MMA6(string) MMA7(string) MMA8(string)	/*
		*/ MLOpts(string) P0(string)				/*
		*/ NATIVE NR OPG Robust SCore(passthru) SAVEspace	/*
		*/ STATE0(string) TECHnique(string) VCE(string)		/*
		*/ SHOWNRtolerance SHOWTOLerance			/*
		*/ * ]

	if "`s(fvops)'" == "true" {
		di as err "factor variables not allowed"
		exit 101
	}

	local showtol `shownrtolerance' `showtolerance'
	if `:length local showtol' {
		local options `options' shownrtolerance
	}

	if _by() {
		_byoptnotallowed score() `"`score'"'
	}

					/* if conditional, just use arch */
	if "`condition'" != "" { 
		if "`mar1'`mma1'`sarima'" != "" {
			di as error "may not use condition with seasonal models"
			exit 198
		}
		
		arch `0' 
		est local seasons "1"
		est local estat_cmd arima_estat
		est local predict arima_p
		MaxLag maxar : `e(ar)'
		MaxLag maxma : `e(ma)'
		local r = max(`maxar', `maxma' + 1)
		tempname p0 b
		mat `b' = e(b)
		mat `p0' =  `b'[1, colnumb(`b',"SIGMA2:_cons")] * I(`r')
		est matrix P0 `p0'
		est scalar ar_max = `maxar'
		est scalar ma_max = `maxma'
		est scalar sigma = sqrt(_b[SIGMA2:_cons])
		local eqnames `e(eqnames)'
		local ct : word count `e(ar)'
		local i 1
		while `i' <= `ct' {
		    local eqnames : subinstr local eqnames "ARMA" "AR1_terms"
		    local i = `i' + 1
		}
		local eqnames : subinstr local eqnames "ARMA" "MA1_terms", all
		local eqnames : subinstr local eqnames "HET" "SIGMA"
		est local eqnames `eqnames'

					/* Must return scalar k1 */
		marksample touse
		_rmcoll `varlist' if `touse', `constant' `coll'
		local varlist `r(varlist)'
		gettoken dep_m ind_m : varlist
		local ct : word count `ind_m'
		est scalar k1 = `ct' + ("`constant'" == "")

		exit
	}

					/* Handle arima() option	*/
	if "`arima'" != "" {

		if "`ar'`ma'" != "" {
			di in red "ar() and ma() not allowed with arima()"
			exit 198
		}
		tokenize `arima'
		local p `1'
		local d `2'
		local q `3'

		tokenize `varlist'
		local varlist 
		local i 1
		while "``i''" != "" {
			local varlist `varlist' D`d'.``i''
			local i = `i' + 1
		}
		if `p' != 0 { 
			numlist "1/`p'" 
			local ar `r(numlist)'
		}
		if `q' != 0 { 
			numlist "1/`q'" 
			local ma `r(numlist)'
		}
	}

	if "`sarima'" != "" {
		if "`mma1'`mar1'" != "" {
			di as error "mma() and mar() not allowed with sarima()"
			exit 198
		}
		tokenize `sarima'
		local sp `1'
		local sd `2'
		local sq `3'
		local ss `4'
		if `ss' <= 1 {
			di as error "sarima() seasonality term must be > 1"
			exit 198
		}
		/* S4S4 is NOT the same as S8! */
		local seasop
		forvalues i = 1/`sd' {
			local seasop "S`ss'`seasop'"
		}
		
		tokenize `varlist'
		local varlist
		local i 1
		while "``i''" != "" {
			if "`seasop'" != "" {
				local varlist `varlist' `seasop'.``i''
			}
			else {
				local varlist `varlist' ``i''
			}
			local i = `i' + 1
		}
		if `sp' != 0 {
			numlist "1/`sp'"
			local sar `r(numlist)'
		}
		if `sq' != 0 {
			numlist "1/`sq'"
			local sma `r(numlist)'
		}
		if "`sar'" != "" {
			local mar1 "`sar', `ss'"
		}
		if "`sma'" != "" {
			local mma1 "`sma', `ss'"
		}

		
	}

	mac drop Tseasons Tstate0 Tp0 Tdepvar TT Ta Tstripe

					/* Other syntax errors */

	if "`robust'" != "" & "`opg'" != "" {
		local opg
		di in blue "(note:  option opg ignored when "  /*
			*/ "specified with robust)"
	}
	if "`diffuse'" != "" & "`state0'`p0'" != "" {
		di in red "diffuse may not be specified with state() or p0()"
		exit 198
	}


					/* Handle ML options */
	_get_diopts diopts options, `options'
	mlopts stdopts, `options'	
	local coll `s(collinear)'

	local vcetype `hessian' `opg' `native' `robust'
	local nvce : word count `vcetype'
	if "`vce'" != "" {
		local vcetype `vcetype' vce(`vce')
	}
	if (`nvce' + (`"`vce'"' != "")) > 1 {
		di in red "options `:list retok vcetype' may not be combined"
		exit 198
	}
	else	local vce `vce' `hessian' `opg' `native'

	if "`technique'" == "" { /* undoc*/
		local tmeth `bhhh' `bhhhq' `bfgs' `dfp' `nr'
		local ct : word count `tmeth'
		local ct = `ct' + ("`bhhhbfgs'" != "") + ("`bhhhdfp'" != "")
		if `ct' == 1 {
			if "`bhhhbfgs'" != "" {
				if "`vce'`robust'" == "" {
					local vce opg
				}
				gettoken c1 c2 : bhhhbfgs
				local tmeth `"bhhh `c1' bfgs `c2'"'
			}
			if "`bhhhdfp'" != "" {
				if "`vce'`robust'" == "" {
					local vce opg
				}
				gettoken c1 c2 : bhhhdfp
				local tmeth `"bhhh `c1' dfp `c2'"'
			}
			local techniq "technique(`tmeth')"
		}
		else if `ct' == 0 {
			if "`vce'`robust'" == "" {
				local vce opg
			}
			local techniq "technique(bhhh 5 bfgs 10)" 
		}
		else {
			di in red "may only specify one optimization method"
			di in red "from:  bhhh bfgs dfp nr bhhhbfgs() bhhhdfp()"
			exit 198
		}
	}
	else	local techniq "technique(`technique')"	
	if "`vce'" != "" {
		local vce vce(`vce')
	}

	if "`bracket'" == "" {
		local bracket bracket
	}
	else	local bracket

					/* other special parsing */

	if "`from'" == "armab0" {
		local armab0 "armab0"
		local from
	}


	marksample touse		/* set sample */
	_ts timevar panvar if `touse', sort onepanel
	qui tsset, noquery
	markout `touse' `timevar' `panvar'
	if "`savespace'" != "" {
		preserve
		tsrevar `varlist' , list
		keep `r(varlist)' `touse' `timevar' `panvar'
		qui tsset, noquery
	}

					/* Remove collinearity */
	_rmcoll `varlist' if `touse', `constant' `coll'
	local varlist `r(varlist)'

	gettoken dep_m ind_m : varlist

	MaxLag maxmar : `ar'		/* track max lags */
	MaxLag maxmma : `ma'
					/* mma#() and mar#() options */
	if "`ar'`ma'" != "" { 
		local mdeltas 1 
	}
	foreach m in mma mar {
		forvalues i = 1/8 {
			if "``m'`i''" != "" {
				gettoken lst delta : `m'`i' , parse(,)
				gettoken c delta : delta , parse(,)
				local delta = trim("`delta'")
				if `"`delta'"'=="" {
di as error "`m'(``m'`i'') is badly specified"
exit 198
				}
				capture confirm integer number `delta'
				if `delta' <= 1 {
di as error "`m'(``m'`i'') seasonality term must be > 1"
exit 198
				}
				local rc1 = _rc
				capture numlist "`lst'" , ascending /*
					*/ integer min(1)
				if _rc | `rc1' {
					di as error `"`m'(``m'`i'') invalid"'
					exit 198
				}
				local t : subinstr local mdeltas "`delta'" /*
					*/ "" , word count(local ct)
				if ! `ct' { 
					local mdeltas `mdeltas' `delta' 
				}
				if "``m'_`delta'_d'" != "" {
di as error "cannot define multiple `m' terms with same seasonality"
exit 198
				}
				MaxLag t : `lst'				
				local `m'_`delta'_d `delta'
				local max`m' = `max`m'' + `delta'*`t'
				local `m'_`delta'       `r(numlist)'
				
				/* Reformatted for later eret macro */
				local `m'`i'_n "`r(numlist)', `delta'"
			}
			else {		/* No more terms */
				continue, break
			}
		}
	}
	global Tseasons `mdeltas'

					/* handle special priming options */

	if "`diffuse'`state0'`p0'"!="" { 
		local r = max(`maxmar', `maxmma' + 1) 
		tempname p0m state0m
	}

	if "`diffuse'" != "" {			/* diffuse prior */
		global Tstate0 `state0m'
		global Tp0 `p0m'
		mat $Tstate0 = J(`r', 1, 0)
		mat $Tp0 = `infty' * I(`r')
	}

	if "`state0'" != "" {			/* user supplied state (Xi) */
		global Tstate0 `state0m'
		local r = max(`maxmar', `maxmma' + 1)

		capture confirm number `state0'
		if _rc {
			if rowsof(`state0')!=`r' | colsof(`state0')!=1 {
				if `r' != 1 { local s "s" }
				di in red "matrix `state0' must " /*
					*/ "have `r' row`s' and 1 column"
				exit 198
			}
			mat $Tstate0 = `state0'
		}
		else	mat $Tstate0 = J(`r', 1, `state0')
	}

	if "`p0'" != "" {			/* user supplied P_(1|0)   */
		global Tp0 `p0m'
		local r = max(`maxmar', `maxmma' + 1)

		capture confirm number `p0'
		if _rc {
			if colsof(`p0')!=`r' | rowsof(`p0')!=`r' {
				if `r' != 1 { 
					local s "s" 
				}
				else	local s
				di in red "matrix `p0' must have `r' row`s' " /*
					*/ " and `r' column`s'"
				exit 198
			}
			mat $Tp0 = `p0'
		}
		else	mat $Tp0 = `p0' * I(`r')
	}

					/* check matdim, ^2 for init cond. */
	if "$Tp0" == "" {
		local m = max(`maxmar', `maxmma' + 1)
		if c(max_matdim) < `m'^2 {
			version 16
			di as err "unable to allocate matrix;"
			di as err "required matrix dimension is max(AR, MA+1)^2"
			di as err "consider using {bf:diffuse} option"
			exit 915
		}
	}

					/* expand TS ops in depvar for kalman */
	tsrevar `dep_m'
	if "`dep_m'" != "`r(varlist)'" {
		tempvar depvar
		global Tdepvar `depvar'
		qui gen double $Tdepvar = `dep_m' if `touse'
	}
	else	global Tdepvar `dep_m'


	tempvar u e_t			/* disturbance temp vars	*/


				/* Starting values, matrix stripe 
				 * and ML equations */

	local yprefix `dep_m'

					/* Xb */
	tempname b0 T

	if "`ind_m'" != "" | "`constant'" == "" {

					/* starting values */
		capture regress `dep_m' `ind_m'  if `touse' , `constant'
		ErrCheck
		qui predict double `u' if `touse' , res
		mat `b0' = e(b)
		local sigma = sqrt(e(rmse)^2*(e(df_r)/e(N)))

					/* ML equation */
		if index("`dep_m'", ".") == 0 {
			local xbeqn "(`dep_m': `yprefix' = `ind_m', `constant')"
		}
		else	local xbeqn "(eq1:  `yprefix' = `ind_m', `constant')"
		local yprefix

					/* maintain name stripe */
		tsrevar `dep_m', list
		mat coleq `b0' = `r(varlist)'			
		local colnams : colfullnames `b0'
	}
	else {
		qui gen double `u' = `dep_m'
		qui sum `dep_m'
		local sigma = sqrt(r(Var))
	}
					/* AR, MA */
	if "`ar'`ma'" != "" {
						/* could combine w/ mdeltas
						 * except initial values */

		if "`ar'" != "" { local arterms "l(`ar').`u'" }
		if "`ma'" != "" { local materms "l(`ma').`e_t'" }

		if "`armab0'" == "" {
			/* Get residuals from AR representation of errors */
/* won't do mma mar -- start vals will be hard for those models -- use 0*/

			MinLag minlag : `ar' `ma'
			MaxLagS maxlag : 2 `ar' `ma'
			Monfort `e_t' : `u' `minlag' `maxlag' `interval' `touse'

			/* Get consistent estimates of AR and MA parameters */

			capture regress `u' `arterms' `materms'  /*
				*/ if `touse', nocons 
			if !_rc {
				mat `T' = e(b)
				FixARMA `T' "`ar'" "`ma'"
				mat `b0' =  nullmat(`b0') , `T'
				local sigma = sqrt(e(rmse)^2*(e(df_r)/e(N)))
			}
			else	local armab0b "armab0"
		}
		if "`armab0'`armab0b'" != "" {
			local narma : word count `ar' `ma'
			mat `T' = J(1, `narma', 0)
			mat `b0' = nullmat(`b0') , `T'
			if "`armab0b'" == "" { qui gen double `e_t' = `u' }
		}

					/* maintain name stripe */

		AddStrip colnams : "`colnams'" "`ar'" ARMA ar
		AddStrip colnams : "`colnams'" "`ma'" ARMA ma

					/* ML equation */

		if "`ar'" != "" {
		    local areqn "(AR1_terms: `yprefix' = `arterms', nocons )"
		    local yprefix
		}
		if "`ma'" != "" {
		    local maeqn "(MA1_terms: `yprefix' = `materms', nocons )"
		    local yprefix
		}
	}
/*
Don't think this is needed, since we always stick
sigma at the end of `b0' -- see about 25 or 30 lines
down.
	else {
		qui sum `u'  if `touse'
		mat `b0' = nullmat(`b0') , sqrt(`r(Var)'*(r(N)-1)/r(N))
	}
*/
				/* name stripe, eqns, and inits for mar mma */
	foreach d in `mdeltas' {	
		if `d' == 1 & "`ar'`ma'" != "" { continue }
		if `d' == 1 {
			AddStrip colnams : "`colnams'" "`mar_`d''" ARMA ar
			AddStrip colnams : "`colnams'" "`mma_`d''" ARMA ma
		}
		else {
			AddStrip colnams : "`colnams'" "`mar_`d''" ARMA`d' ar
			AddStrip colnams : "`colnams'" "`mma_`d''" ARMA`d' ma
		}
		
		if "`mar_`d''" != "" {
			local arterms "l(`mar_`d'').`u'"
			local multeqns `multeqns' 			/*
			    */ (AR`d'_terms: `yprefix' = `arterms', nocons )
			local yprefix
		}
		if "`mma_`d''" != "" {
			local materms "l(`mma_`d'').`e_t'"
			local multeqns `multeqns' 			/*
		    	    */ (MA`d'_terms: `yprefix' = `materms', nocons )
			local yprefix
		}
		mat `T' = J(1, `:word count `mar_`d'' `mma_`d''', 0)
		mat `b0' = nullmat(`b0') , `T'
		capture confirm numeric variable `e_t'
		if _rc { 
			qui gen double `e_t' = `u' 
		}
	}
	local colnams `colnams' sigma:_cons
	local sigeqn "(SIGMA: `yprefix' = )"
	local yprefix

	mat `b0' = nullmat(`b0'), `sigma'

				/* Report time gaps */
	tsreport if `touse', report `detail'
	local gaps `r(N_gaps)'
	if `gaps' > 0 { 
		di in bl "(note: filtering over missing observations)" 
	}

	qui count if `touse'
	local nobs `r(N)'

				/* End starting values and matrix stripe */

				/* Maximize -- ML */

				/* Handle constraints, if any */
	if "`constraints'" != "" {
						/* make constraints using 
						 * dummy matrices */
		tempname b V T a C 
						/* set full model */
		version 8.1: ///
		ml model rdu0 arima_dr `xbeqn' `areqn' `maeqn' `multeqns'  /*
			*/ `sigeqn', `techniq' missing nopreserve collinear /*
			*/ `vce'
		mat `b' = $ML_b
		local eqnames : coleq `b'		/* for saved results */
		mat colnames `b' = `colnams'
		mat `V' = `b'' * `b'
		mat post `b' `V'
		capture mat makeCns `constraints'
		if _rc {
			local rc = _rc
			di in red "Constraints invalid:"
			mat makeCns `constraints'
			exit _rc
		}
		matcproc `T' `a' `C'
		global TT `T'			/* globals for LL evaluator */
		global Ta `a'
		global Tstripe : colfullnames $ML_b

						/* constrain b0 */
		if "`from'" != "" & "`armab0'" == "" {
			_mkvec `b0', from(`from') first  /*
				*/ colnames(`colnams') error("from()")
		}
		mat `b0' = (`b0' - `a') * `T'

  						/* for constrained model, 
						 * just feed ml first varnames
						 * of unconstrained model */
		tempname one
		qui gen byte `one' = . in 1
		mat `b' = $ML_b[1, 1..colsof(`b0')]
		local cnsvars : colnames `b'
		local cnsvars : subinstr local cnsvars "_cons" "`one'", all w

						/* give ML constrained model */
		local xbeqn "(`dep_m' = `cnsvars', nocons)"
		local areqn
		local maeqn
		local multeqns
		local sigeqn
	}

					/* Set initial values */
	if "`from'" != "" & "`armab0'" == "" & "`constraints'" == "" { 
		_mkvec `b0', from(`from') first  colnames(`colnams') /*
			*/ error("from()")
	}
	local from "`b0', copy" 

	// Create temporary time variable with delta=1; _kalman needs this
	if `=`: char _dta[_TSdelta]'' != 1 {
		qui tsset, noquery
		local tsspanv  `r(panelvar)'
		local tssvar   `r(timevar)'
		local tssdelta `r(tdelta)'
		local tssfmt   `r(tsfmt)'
		
		tempvar normt
		summ `tssvar', mean
		gen double `normt' = (`tssvar' - r(min)) / `tssdelta'
		qui tsset `tsspanv' `normt', noquery
	}

					/* Fit the model */
	version 8.1: ///
	noi ml model rdu0 arima_dr 					   /*
		*/ `xbeqn' `areqn' `maeqn' `multeqns' `sigeqn'	   	   /*
		*/ [`weight'`exp']  if `touse' , obs(`nobs')		   /*
		*/ title(ARIMA regression) 				   /*
		*/ init(`from') `score' `robust'			   /*
		*/ `stdopts' `mlopts' `techniq' gtolerance(`gtolerance')   /*
		*/ `bracket' search(off) missing maximize nooutput 	   /*
		*/ nopreserve collinear `vce'
	if "`constraints'" != "" {	/* put problem back in original space */
		mat `b' = get(_b) * `T'' + `a'
		mat `V' = `T' * e(V) * `T''
		mat post `b' `V' `C', noclear
	}

	// Restore user's -tsset-tings
	if `"`tssdelta'"' != "" {
		qui tsset `tsspanv' `tssvar', delta(`tssdelta') ///
			format(`tssfmt') noquery
	}
					/* Fix-up names on matrices */
	mat `b0' = e(b)
	local k = colsof(`b0')
	est scalar sigma = `b0'[1, `k']
	if "`constraints'" == "" {
		local eqnames : coleq `b0'		/* for saved results */
	}
	mat colnames `b0' = `colnams'
	mat repost _b=`b0', rename

	_b_pclass PCVAR : VAR
	if `k' > 1 {
		_b_pclass PCDEF : default
		mat `b0' = (J(1,`k'-1,`PCDEF'),`PCVAR')
	}
	else {
		mat `b0' = J(1,1,`PCVAR')
	}

	mat colnames `b0' = `colnams'
	est hidden mat b_pclass = `b0'
					/* Model Chi	*/
	if "`ind_m'"  != "" { 
		tsrevar `dep_m', list
		qui test [`r(varlist)'] 
		local accum accum
	}
	foreach i of global Tseasons {
		if `i' == 1 {
			qui test [ARMA], `accum'
			local accum accum
		}
		else {
			qui test [ARMA`i'], `accum'
			local accum accum
		}
	}
					/* Saved results */
	est scalar p = e(p)
	est scalar df_m = r(df)
	est scalar chi2 = r(chi2)

	if "$Tp0" != "" { est matrix P0 $Tp0 }
	if "$Tstate0" != "" { 
		mat `T' = $Tstate0' * $Tstate0
		if `T'[1,1] != 0 { est matrix Xi0 $Tstate0 }
	}

	local ct : word count `ind_m'
	est scalar k1 = `ct' + ("`constant'" == "")

	sum `timevar' if `touse' , meanonly
	est scalar tmin = r(min)
	est scalar tmax = r(max)
	local fmt : format `timevar'
	est local tmins = trim(string(r(min), "`fmt'"))
	est local tmaxs = trim(string(r(max), "`fmt'"))

	est scalar k_eq = ("`ind_m'"!=""|"`constant'"=="") + 		/*
		*/ `:word count `mdeltas'' + 1
	est scalar N_gaps = `gaps'
	est scalar ar_max = `maxmar'
	est scalar ma_max = `maxmma'
	foreach m in mma mar {
		forvalues i = 1/8 {
			if "``m'`i'_n'" != "" {
				est local `m'`i' ``m'`i'_n'
			}
		}
	}
	est local seasons $Tseasons
	if "$Tbadstic" != "" { est local unsta "possibly nonstationary" }
	est local cnslist `constraints'
	est local eqnames `eqnames'
	est local diffuse `diffuse'
	est local ar `ar'
	est local ma `ma'
	est local marginsok xb y default
	est local marginsnotok stdp mse Residuals YResiduals
	if `:list sizeof ind_m' == 0 {
		est local covariates _NONE
	}
	else {
		est local covariates `"`ind_m'"'
	}
	est local estat_cmd arima_estat
	est local predict arima_p
	est local tech `technique'
	if "`e(vcetype)'" == "Robust" { 
		est local vcetype `e(vcetype2)' Semirobust 
	}
	if "`e(vce)'" == "oim" {
		est local vcetype "OIM"
	}
	version 10: ereturn local cmdline `"arima `cmdline'"'
	version 10: ereturn hidden local k_aux = 1
	qui tsset
	version 10: ereturn hidden local tsfmt = r(tsfmt)
	version 10: ereturn hidden local timevar = r(timevar)
	est repost, buildfvinfo
	est local cmd "arima"

					/* Results */
	Display , `coef' `head' level(`level') `diopts'
	mac drop Tseasons Tstate0 Tp0 Tdepvar TT Ta Tstripe
	
end


program define Display
	syntax [, Level(cilevel) noCOEF noHEAD noCNSReport *]

	_get_diopts options, `options'
	local options : list options - cnsreport
	if "`head'" == "" {
		_tsheadr, `cnsreport'
	}
	if "`coef'" == "" { 
		version 9: ///
		ml display , level(`level') showeqns noheader nocnsreport ///
		`options'
		di as smcl "{p 0 6 0 79}" ///
		 "Note: The test of the variance against " ///
		 "zero is one sided, and the two-sided confidence interval " ///
		 "is truncated at zero.{p_end}"
	}

	if "`e(unsta)'" != "" {
		di in blue "attempts were made to step into nonstationary "  /*
		*/ "regions during optimization"
		di in blue "solution constrained to be stationary, but "    /*
		*/ "may not be global maximum likelihood"
		di in blue "may wish to re-run model with -diffuse- option"
	}
end


program define DropDup	/* Remove duplicate tokens from a sorted list */
	args	    listfix	/*  a macro name to hold the fixed list
		*/  colon	/*  :
		*/  list	/*  original list */

	tokenize `list'
	local prev `1'
	local i 2
	while "``i''" != "" {
		if "``i''" == "`prev'" {
			local ``i''
		}
		else    local prev ``i''

		local i = `i' + 1
	}

	c_local `listfix' `*'
end

program define AddStrip 
	args	    stripe	/* macro to contain full matrix names
		*/  colon	/* :
		*/  stripe0	/* current contents of strip
		*/  laglist	/* list of lags
		*/  eqname	/* equation name for this part of stripe
		*/  varname	/* variable name for this part of stripe */

	tokenize `laglist'
	local i 1
	while "``i''" != "" {
		local part `part' `eqname':L``i''.`varname'
		local i = `i' + 1
	}

	c_local `stripe' `stripe0' `part'
end


program define FixARMA
	args b ar ma

	tempname bsum
	scalar `bsum' = 0

						/* AR terms */
	local nar : word count `ar'
	local i 1
	while `i' <=  `nar' {
		scalar `bsum' = `bsum' + `b'[1, `i']
		local i = `i' + 1
	}

	if abs(`bsum') > .95 {
		mat `b'[1,1] = (.95 / abs(`bsum')) * `b'[1,1..`nar']
	}

						/* MA terms */
	local nma : word count `ma'
	local narma = `nma' + `nar'
	local i = `nar' + 1
	while `i' <=  `narma' {
		if abs(`b'[1, `i']) > 0.95 {
			mat `b'[1, `i'] = .95 * `b'[1, `i'] / abs(`b'[1, `i'])
		}
		local i = `i' + 1
	}
end


program define MinLag		/* minlag : numlist1 numlist2 ... numlistN */
	args minlag colon

	mac shift 2
	local i 1

	numlist "`*'", sort
	local nlist `r(numlist)'
	gettoken minval : nlist

	c_local `minlag' `minval'
end


program define MaxLagS		/* sumlag : N "nlist1" "nlist2" ... "nlistN" */
	args maxlag colon k_list

	mac shift 3
	local maxsum 0

	local i 1
	while `i' <= `k_list' {
		if "``i''" != "" {
			local lastel : word count `i'
			local last : word `lastel' of `i'
			local maxsum = `maxsum' + `last'
		}
		local i = `i' + 1
	}

	c_local `maxlag' `maxsum'
end


program define MaxLag		/* maxlag : numlist1 numlist2 ... numlistN */
	args maxlag colon

	mac shift 2

	if "`*'" == "" { 
		c_local `maxlag' 0
		exit
	}
	
	numlist "`*'", sort

	local lastel : word count `r(numlist)'
	local lastval : word `lastel' of `r(numlist)'

	c_local `maxlag' `lastval'
end


/* Obtain whitened residuals of a series from an "infinite" AR regression
 * regression.  Used to get a disturbance estimate that can be used for
 * the MA component of a regression; a'la Monfort & Gourieux TS p 188 
*/

program define Monfort
	args	    u_var	/* variable to hold whitened resids
		*/  colon	/* :
		*/  e_var	/* variable with ARMA resids
		*/  minlag	/* minimum lag 
		*/  maxlag	/* smallest maximum lag value	
		*/  inter	/* true interval of time variable 
		*/  touse	/* touse variable */

	/* search for a reasonable lag for infinite AR representation */
	/* a space problem here since k doubles are created in regress. */

	tempvar touse2
	qui gen byte `touse2' = . in 1

	local vir 1
	local done 0
	local k = 30				/* would prefer 40 */
	while ! `done' & `k' > 0 {
		if `k' > 10 {
			local usemin = min(`minlag', `inter')
		}
		else    local usemin `minlag'

		local usemax = max(`maxlag', `usemin'+`k'*`inter')

		qui replace `touse2' = `touse'
		capture  markout `touse2' `e_var' /*
			*/ l(`usemin'(`inter')`usemax').`e_var'
		if !_rc {
			qui count if `touse2'
			if r(N) > 2*`k' { local done 1 }
		}
		else if `vir' {
			di in blue "(note:  insufficient memory or "	/*
				*/ "observations to estimate usual"
			di in blue "starting values [1])"
			local vir 0
		}
		local k = `k' - 5

	}

		/* Obtain near white u's from "infinite" AR regress */

	while `usemax' > `usemin' {
		capture regress `e_var' l(`usemin'(`inter')`usemax').`e_var' /* 
			*/ if `touse'
		local hold_rc = _rc
		if !`hold_rc' { 
			capture drop `u_var'
			qui predict double `u_var' if `touse', res
			exit
		}

		if `vir' {
			di in blue "(note:  insufficient memory or "	/*
				*/ "observations to estimate usual"
			di in blue "starting values [2])"
			local vir 0
		}
		local usemax = `usemax' - 1
	}

	if `hold_rc'==2000 | `hold_rc'==2001 { 
		di in red "insufficient observations"
	}
	else {
		di in red "insufficient memory or observations to estimate "  /*
			*/ "starting values"
	}
	exit `hold_rc'
end


program define ErrCheck
	if _rc == 111 | _rc == 2000 {
		di in blue "insufficient observations"
		exit _rc
	}

	if _rc {
		error _rc
		exit
	}
end

program define SetConst
end


exit


