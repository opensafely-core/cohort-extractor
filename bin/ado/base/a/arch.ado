*! version 7.5.0  28jan2019
program define arch, eclass byable(recall)
	version 6.0, missing
					/* limits, etc. */
	local mnonlin	50			/* sarch narch ... terms */
	local gtol	.05			/* gradient tolerance */
	local pow0	2.0

	if replay() {
		if _by() {
			error 190
		}
		if "`e(cmd)'" != "arch" {
			noi di in red "results of arch not found"
			exit 301
		}
		Display `0'
		exit
	}
	local cmdline : copy local 0

	syntax [varlist(ts fv)] [if] [in] [iw] [, /*
		*/ AArch(numlist int ascend >0 max=`mnonlin') /*
		*/ ABarch(numlist int ascend >0) /*
		*/ AParch(numlist int ascend >0 max=`mnonlin')	/*
		*/ AR(numlist int ascend >0) ARCH(numlist int ascend >0) /*
		*/ ARIMA(numlist int min=3 max=3 >-1)			/*
		*/ ARCH0(string) /*
		*/ ARCHM ARCHMLags(numlist int ascend >= 0) ARCHMExp(string) /*
		*/ ARMA0(string) /*
		*/ ATarch(numlist int ascend >0) /*
		*/ BHHH BHHHQ BFGS /*
		*/ BHHHBfgs(numlist min=2 max=2 integer >=0 <99999) /*
		*/ BHHHDfp(numlist min=2 max=2 integer >=0 <99999) /*
		*/ noBRacket	/*
		*/ CONDition CONDObs(integer 0) noCOEF noConstant /*
		*/ Constraints(string) /*
		*/ DETail DFP noDIFficult /*
		*/ EArch(numlist int ascend >0) EGarch(numlist int ascend >0) /*
		*/ FROM(string) GTOLerance(real `gtol')     /*
		*/ Garch(numlist int ascend >0) noHEAD    /*
		*/ DISTribution(string)			/*
		*/ SHOWNRtolerance SHOWTOLerance	/*
		*/ * ]
	
	if "`s(fvops)'" == "true" {
		di as err "factor variables not allowed"
		exit 101
	}
	
	local showtol `shownrtolerance' `showtolerance'
	if `:length local showtol' {
		local options `options' shownrtolerance
	}

	local varlst0 `varlist'
	local if0 `"`if'"'
	local in0 `in'
	local weight0 `weight'
	local exp0 `"`exp'"'
	local real0 `"`0'"'
	local 0 `", `options'"'
	syntax [, /*
		*/ HESsian /*
		*/ Het(varlist ts numeric)		/*
		*/ Interval(integer 1)	/*
		*/ Level(cilevel) /*
		*/ MA(numlist int ascend >0) /*
		*/ MLOpts(string) /*
		*/ NATIVE /*
		*/ NArch(numlist int ascend >0 max=`mnonlin')	/*
		*/ NARCHK(numlist int ascend >0 max=`mnonlin')	/*
		*/ NParch(numlist int ascend >0 max=`mnonlin')	/*
		*/ NPARCHK(numlist int ascend >0 max=`mnonlin')	/*
		*/ NR /*
		*/ OPG	/*
		*/ Parch(numlist int ascend >0) /*
		*/ PGarch(numlist int ascend >0) /*
		*/ Robust SCore(passthru) /*
		*/ SAArch(numlist int ascend >0) /*
		*/ SDgarch(numlist int ascend >0) /*
		*/ SAVEspace /*
		*/ TArch(numlist int ascend >0) /*
		*/ TParch(numlist int ascend >0) /*
		*/ TECHnique(string) /*
		*/ VCE(string) /*
		*/ * ]
	local varlist `varlst0'
	local if `"`if0'"'
	local in `in0'
	local weight `"`weight0'"'
	local exp `"`exp0'"'
	local 0 `"`real0'"'
	local varlst0
	local if0
	local in0
	local weight0
	local exp0
	local real0

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
	_ts timevar panvar, sort panel

	qui tsset, noquery
	ArchDrop
	global Tarchany = "`arch'`abarch'`atarch'`parch'`aparch'`nparch'`nparchk'`tarch'`tparch'`saarch'`aarch'`narch'`narchk'`earch'" != ""

					/* Other syntax errors */

	if "`earch'`egarch'" != "" &					/*
	*/ "`parch'`aparch'`nparch'`nparchk'`tparch'`pgarch'" != "" {
		di in red "parch(), aparch(), nparch(), nparchk(), "/*
		*/ "tparch(), or pgarch()"
		di in red "may not be specified with earch() or egarch()"
		exit 198
	}

	if "`archm'`archmlags'" != "" & !$Tarchany {
		di in red "options archm and archmlags() require that " /*
			*/ "some form of arch terms "
		di in red "be specified in the model"
		exit 198
	}
	if "`aarch'" != "" & "`tarch'`arch'" != "" {
		di in red "aarch() may not be specified with arch() or tarch()"
		di in red "because the resulting terms would be collinear"
		exit 198
	}
	if "`nparch'`nparchk'`narch'`narchk'" != "" & "`saarch'`arch'" != "" {
		di in red "nparch(), narch() or narchk() may not be "  /*
			*/ "specified with arch() or saarch()"
		di in red "because the resulting terms would be collinear"
		exit 198
	}
	if ("`nparch'"!="") + ("`narch'"!="") + ("`narchk'"!="") + /*
	*/ ("`nparchk'"!="") > 1 {
		di in red "nparch(), nparchk(), narch(), and narchk() may " /*
			*/ "not be specified together"
		di in red "because the resulting terms would be collinear"
		exit 198
	}
	if "`garch'`egarch'`pgarch'`sdgarch'" != "" & !$Tarchany {
		di in red "garch(), egarch(), sdgarch(), and pgarch() " /*
			*/ "options require that other"
		di in red "arch terms be specified in the model"
		exit 198
	}
	if "`tarch'" != "" & "`tparch'" != "" {
		di in red "tarch() and tparch() may not be specified together"
		di in red "because the resulting terms would be collinear"
		exit 198
	}
	if "`aparch'" != "" & "`aarch'" != "" {
		di in red "aparch() and aarch() may not be specified together"
		di in red "because the resulting terms would be collinear"
		exit 198
	}
	if "`archmexp'" != "" & "`archmlags'`archm'" == "" {
		di in red "option archmexp() requires that archm or " /*
			*/ "archmlags() be specified"
		exit 198
	}
	if "`robust'" != "" & "`opg'" != "" {
		local opg
		di in gr "(note:  option opg ignored when "  /*
			*/ "specified with robust)"
	}

	/*arma0 options*/
	local wdcnt : word count `arma0'
	if (`wdcnt'>1) {
	        di in red "only one argument allowed in arma0()"
		exit 198
	}
	
	local opt1 "p q pq zero"
	local in1 : list arma0 in opt1
	if !`in1' {
		capture confirm number `arma0'
		if _rc {
			di in red "allowable arguments for arma0() are " /*
				*/ "zero, p, q, pq, and #"
			exit 198
		}
	}
	
	/* condobs must be positive*/
	if (`condobs' < 0) {
		di in red "number of observations in condobs() must be " /*
			*/ "nonnegative"
		exit 198
	}
	
	/* parse distribution */
	PrsDist `distrib'
	local dist `s(dist)'
	local distdf `s(df)'
	if "`dist'" == "t" & "`distdf'" != "" {
		if `distdf' <= 2 {
			di in smcl as error 	/*
*/ "degrees of freedom for Student's {it:t} distribution must be greater than 2"
			exit 198
		}
	}
	if "`dist'" == "ged" & "`distdf'" != "" {
		if `distdf' <= 0 {
			di in smcl as error	/*
*/ "shape parameter for generalized error distribution must be positive"
			exit 198
		}
	}
	local distarg: word count `distrib'
	if `distarg' > 2 {
		di in red "may specify at most two arguments in distribution()"
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
	else local vce `vce' `hessian' `opg' `native'
	opts_exclusive "`vcetype'"
	if "`techniq'" == "" {
		local tmeth `bhhh' `bhhhq' `bfgs' `dfp' `nr'
		local ct : word count `tmeth'
		local ct = `ct' + ("`bhhhbfgs'" != "") + ("`bhhhdfp'" != "")
		if `ct' == 1 {
			if "`bhhhbfgs'" != "" {
				if "`vce'`robust'" == "" {
					local vce opg
				}
				local tmeth ///
					bhhh `:word 1 of `bhhhbfgs'' ///
					bfgs `:word 2 of `bhhhbfgs''
			}
			if "`bhhhdfp'" != "" {
				if "`vce'`robust'" == "" {
					local vce opg
				}
				local tmeth ///
					bhhh `:word 1 of `bhhhdfp'' ///
					dfp  `:word 2 of `bhhhdfp''
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
	else	local techniq "technique(`techniq')"		/* undoc */

	if "`vce'" != "" {
		local vce vce(`vce')
	}

	if "`nr'" != "" {
		if "`difficu'" != "" {			/* allow nodif */
			local difficu ""
		}
		else	local difficu "difficult"	/* default to dif */
	}
	
					/* Process arch-in-mean terms */
	if "`archm'" != "" {
		local archm "0 `archmla'"
		
	}
	else    local archm `archmla'

					/* other special parsing */
	if "`bracket'" == "" {
		local bracket bracket
	}
	else	local bracket

	if "`from'" == "archb0" {
		local archb0 "archb0"
		local from
	}
	else if "`from'" == "armab0" {
		local armab0 "armab0"
		local from
	}
	else if "`from'" == "armab0 archb0" | "`from'" == "archb0 armab0" {
		local archb0 "archb0"
		local armab0 "armab0"
		local from
	}

	local narch `narch'`narchk'
	local nparch `nparch'`nparchk'

				
	marksample touse		/* set sample */
	markout `touse' `het' `timevar' `panvar'
	if "`savespa'" != "" {
		preserve
		tsrevar `varlist' `het', list
		keep `r(varlist)' `touse' `timevar' `panvar'
		qui tsset, noquery
	}

					/* Remove collinearity */
	gettoken dep_m ind_m : varlist
	_rmdcoll `varlist' if `touse', `constan' `coll'
	local varlist `r(varlist)'
	_rmcoll `het'  if `touse', `coll'
	local het `r(varlist)'

	local COVARS `varlist' `het'
	if `:list sizeof COVARS' == 0 {
		local COVARS _NONE
	}

	local ind_m `varlist'

	global Tar `ar'			/* globals, see bottom of file */
	global Tma `ma'
	global Tarch `arch'
	global Tgarch `garch'
	global Tarchm `archm'
	global Ttarch `tarch'
	global Ttparch `tparch'
	global Tsaarch `saarch'
	global Tabarch `abarch'
	global Tatarch `atarch'
	global Tparch `parch'
	global Taarch `aarch'
	global Tnarch `narch'
	global Tearch `earch'
	global Tegarch `egarch'
	global Taparch `aparch'
	global Tnparch `nparch'
	global Tpgarch `pgarch'
	global Tsdgarch `sdgarch'

					/* Temporary variables for model
					 * components */
	tempvar u e_t e2 sigma2 tvar
	global Tu `u'			/* errors, may be ARMA */
	global Te `e_t'			/* white noise disturbances (innov) */
	global Te2 `e2'			/* squared innovations for arch */
	global Tsigma2 `sigma2'		/* sigma^2 for arch = S_e = S */
	global Ttvar `tvar'
	qui gen double $Ttvar = . in 1


	if "`dist'" == "gaussian" {	/* Gaussian default already set */
		glo TdistN ""
		glo Tdistt "*"
		glo TdistGED "*"
		glo Tdfopt "*"
	}
	else if "`dist'" == "t" {
		glo TdistN "*"
		glo TdistGED "*"
		glo Tdistt ""
		if "`distdf'" == "" {
			glo Tdfopt ""
		}
		else {
			glo Tdfopt "*"
			glo Ttdf `distdf'
		}
	}
	else if "`dist'" == "ged" {
		glo TdistN "*"
		glo Tdistt "*"
		glo TdistGED ""
		if "`distdf'" == "" {
			glo Tdfopt ""
		}
		else {
			glo Tdfopt "*"
			glo TGEDdf `distdf'
		}
	}
					/* Parse ARMA and ARCH conditioning */
	tempname sig2_0
	global Tsig2_0 `sig2_0'		/* scalar for priming values of s^2 */
	if "`aarch'`aparch'`abarch'`atarch'`nparch'`narch'" != "" {
		tempname abse_0
		global Tabse_0 `abse_0'
	}
	
					/* Parse and set-up priming values */
	tempname arprm maprm archprm garprm 
	if "$Tar$Tma" != "" { PrsArma0 , `arma0' }
	global Tskipobs = max(0$Tskipobs, `condobs')
	PrsArch0 , `arch0'


				/* Starting values, matrix stripe 
				 * and ML equations */

	local yprefix `dep_m'
					/* Xb */
	tempname b0 T

	if "`ind_m'" != "" | "`constan'" == "" {
		capture regress `dep_m' `ind_m'  if `touse' , `constan'
		ErrCheck
		qui predict double $Tu if `touse' , res
		mat `b0' = e(b)
		if index("`dep_m'", ".") == 0 {
			global TXbeq `dep_m'
		}
		else	global TXbeq "eq1"
		local xbeqn "($TXbeq:  `yprefix' = `ind_m', `constan')"
		local yprefix
		global Thasxb 1
					/* maintain name stripe */
		tsrevar `dep_m', list
		mat coleq `b0' = `r(varlist)'		
		local names : colfullnames `b0'
		local colnams `colnams' `names'
	}
	else {
		qui gen double $Tu = `dep_m'
		global Thasxb 0
		global Tdoxb "*"
	}
					/* arch-in-mean */
	if "`archm'" != "" {
		tempvar tarchm
		global Ttarchm `tarchm'
		qui gen double $Ttarchm = . in 1

		if "`archmex'" != "" {
			local archmx :  /*
				*/ subinstr local archmex "X" "$Tsigma2", all
			global Tarchmex `archmx'
			tempvar tarchme
			global Ttarchme `tarchme'
			qui gen double $Ttarchme = . in 1
			AddStrip colnams : "`colnams'" "`archm'" ARCHM sigma2ex
		}
		else {
			global Tdarchme "*"
			local tarchme $Tsigma2
			AddStrip colnams : "`colnams'" "`archm'" ARCHM sigma2
		}

		local ct : word count `archm'
		mat `b0' = nullmat(`b0') , J(1, `ct', 0)

		local ameaneq  /*
			*/ "(ARCHM: `yprefix' = l(`archm').`tarchme', nocons)"
		local yprefix
	}
	else {
		global Tdoarchm "*"
		global Tdarchme "*"
		global Ttarchm 0
	}

					/* AR, MA */

	if "$Tar$Tma" != "" {

		if "`ar'" != "" { local arterms "l(`ar').$Tu" }
		if "`ma'" != "" { local materms "l(`ma').$Te" }

		if "`armab0'" == "" {
			/* Get residuals from AR representation of errors */

			MinLag minlag : "$Tar" "$Tma"
			MaxLagS maxlag : 2 "$Tar" "$Tma"
			Monfort $Te : $Tu `minlag' `maxlag' `interva' `touse'

			/* Get consistent estimates of AR and MA parameters */

			capture regress $Tu `arterms' `materms'  /*
				*/ if `touse', nocons 
			if !_rc {
				mat `T' = e(b)
				FixARMA `T'
				mat `b0' = nullmat(`b0') , `T'
			}
			else	local armab0b "armab0"
		}
		if "`armab0'`armab0b'" != "" {
			local narma : word count $Tar $Tma
			mat `T' = J(1, `narma', 0)
			mat `b0' = nullmat(`b0') , `T'
			if "`armab0b'" == "" { qui gen double $Te = $Tu }
		}

					/* maintain name stripe */

		AddStrip colnams : "`colnams'" "$Tar" ARMA ar
		AddStrip colnams : "`colnams'" "$Tma" ARMA ma

					/* ML equation */

		local armaeqn "(ARMA: `yprefix' = `arterms' `materms', nocons )"
		local yprefix

	}
	else {
		global Tdoarma "*"
		qui gen double $Te = $Tu
		global Tu $Te
	}

				/* get estimate of e^2	*/
	qui gen double $Te2 = $Te^2

				/* handle some cases of ARCH priming */
	if "$Tarch0" == "xb0wt" | "$Tarch0" == "xbwt" {
		tempname wt_e2 adj
		global Ttimevar `timevar'
		qui tsset
		global Ttimemin = r(tmin)
		global Tadjt = r(tmax) - r(tmin)
		qui gen double `wt_e2' = .7^(`timevar'-r(tmin))*$Te2 /*
			*/ if `touse'
		sum `wt_e2'  if `touse', meanonly
		scalar `adj' = r(sum)
		sum $Te2  if `touse', meanonly
		scalar $Tsig2_0 = 0.7^$Tadjt*r(sum)/(r(N)-0) + 0.3*`adj'
		global Ts2_mayb = $Tsig2_0
	}
	else if "$Tarch0" == "xb0" | "$Tarch0" == "xb" {
		sum $Te2 if `touse', meanonly
		scalar $Tsig2_0 = r(mean)
		global Ts2_mayb = $Tsig2_0
	}

				/* ARMA priming if skipping initial obs */
	if "$Tskipobs" != "" {
		tempname touse2 tvar
		qui gen byte `tvar' = `touse'
		qui replace `tvar' = . if !`touse'
		qui gen byte `touse2' = `touse'
		markout `touse2' l(0/$Tskipobs).`tvar'
		drop `tvar'
	}
	else	{
		local touse2 `touse'
	}
	global Ttouse2 `touse2'

	qui count if `touse2'
	local nobs `r(N)'

				/* Report time gaps */
	tsreport if `touse2', report `detail'
	local gaps `r(N_gaps)'
	if `gaps' > 0 { di in gr "(note: conditioning reset at each gap)" _n }

				/* HET -- multiplicative heteroskedasticity */

	if "`het'" != "" {
		global Tmhet 1
		qui replace $Te2 = ln($Te2)
		capture regress $Te2 `het' if `touse'
		ErrCheck
		mat `T' = e(b)
					/* Harvey's (1976) adjustment */
		mat `T'[1,colsof(`T')] = `T'[1,colsof(`T')] + 1.2704
		mat `b0' = nullmat(`b0') , `T'
		mat repost _b=`T'
		local heteqn "(HET:  `yprefix' = `het', linear )"
		local yprefix
					/* maintain name stripe */
		mat `T' = e(b)
		mat coleq `T' = HET
		local names : colfullnames `T'
		local colnams `colnams' `names'

					/* back in e^2 space for ARCH terms */
					/* Tsigma2 used temporarily */
		qui predict double $Tsigma2 if `touse' 
		qui replace $Te2 = exp($Te2 - $Tsigma2)		/* must be >0 */
		drop $Tsigma2
		local archcon "nocons"
	}
	else if !$Tarchany {	
		local archcon "nocons"
		sum $Te2  if `touse', meanonly
		mat `T' = r(mean)
		mat `b0' = nullmat(`b0') , `T'
		local heteqn "(HET:  `yprefix' = )"
		local yprefix
		local colnams `colnams' SIGMA2:_cons
	}
	/* else	arch terms will have a constant for sigma2_cons	*/

					/* nonlinear terms and equation */
					/* b(|e_(t-i)| - a)		*/
					/* priming values are plug-ins	*/
					/* nesting means /` won't work  */
					/* for delayed substitution     */
	if "$Tnarch" != "" {
		tempname b
		capture local i0 = colsof(`b0')
		if _rc { local i0 0 }

		local lnum : word count $Tnarch
		tokenize $Tnarch
		local i 1
		global Tnarchex update $Tsigma2 = $Tsigma2 
		while "``i''" != "" {
			local i1 = `i0' + `i'
			if "`narchk'" == "" {
				local i2 = `i1' + `lnum'
			}
			else	local i2 = `i0' + `lnum' + 1
			global Tnarchex $Tnarchex + `b'[1,`i1'] *	    /*
			*/  abs(					    /*
			*/	cond(l``i''.$Te >= ., $Tabse_0,	l``i''.$Te) /*
			*/      - `b'[1,`i2']				    /*
			*/   )^2
			local i = `i' + 1
		}
		global Tnarchex : subinstr global Tnarchex "`b'" "\`b'", all

		local init = cond("`archb0'"=="", .05, .005)
		if "`narchk'" == "" {
			mat `T' = J(1, 2*`lnum', `init')
		}
		else	mat `T' = J(1, `lnum'+1, `init')
		mat `b0' = nullmat(`b0') , `T'

		tsunab naterms : l(`narch').$Te		/* var doesn't matter */
		if "`narchk'" == "" {
			local neqn (NARCH:  = `naterms' `naterms', nocons)
		}
		else	local neqn (NARCH:  = `naterms' $Te, nocons)

					/* maintain name stripe */
		AddStrip colnams : "`colnams'" "`narch'" ARCH narch
		if "`narchk'" == "" {
			AddStrip colnams : "`colnams'" "`narch'" ARCH narch_k
		}
		else	AddStrip colnams : "`colnams'" "0" ARCH narch_k
	}

					/* asymmetric terms and equation*/
					/* b(|e_(t-i)| + a*e_(t-i)	*/
					/* priming values are plug-ins	*/
	if "$Taarch" != "" {
		tempname b
		capture local i0 = colsof(`b0')
		if _rc { local i0 0 }

		local lnum : word count $Taarch
		tokenize $Taarch
		local i 1
		global Taarchex update $Tsigma2 = $Tsigma2 
		while "``i''" != "" {
			local i1 = `i0' + `i'
			local i2 = `i1' + `lnum'
			global Taarchex $Taarchex + `b'[1,`i1'] *	/*
			*/  (						/*
			*/	cond(l``i''.$Te >= .,			/*
			*/		$Tabse_0 , 			/*
			*/		abs(l``i''.$Te)			/*
			*/	) + 					/*
			*/	`b'[1,`i2'] *	 			/*
			*/	cond(l``i''.$Te >= ., 0, l``i''.$Te)	/*
			*/   )^2
			local i = `i' + 1
		}
		global Taarchex : subinstr global Taarchex "`b'" "\`b'", all

		mat `T' = J(1, 2*`lnum', cond("`archb0'"=="", .05, .005))
		mat `b0' = nullmat(`b0') , `T'

		local aaeqn (AARCH:  = l(`aarch').$Te l(`aarch').$Tu, nocons)
							/* vars don't matter */

					/* maintain name stripe */
		AddStrip colnams : "`colnams'" "`aarch'" ARCH aarch
		AddStrip colnams : "`colnams'" "`aarch'" ARCH aarch_e
	}
					/* Globals for power ARCH terms */

	if "$Tparch$Ttparch$Taparch$Tnparch$Tpgarch" != "" {
		tempname aparchb power 
		global Tpower `power'

		tempvar sig_pow 
		global Tsig_pow `sig_pow'
		qui gen double $Tsig_pow = . in 1

					/* Look ahead for Power terms */
		if "$Tparch$Ttparch$Tpgarch" != "" {
			local powrest "+ $Ttvar"
		}
	}


					/* APARCH terms and equation	*/
					/* (b(|e_(t-i)| + a*e_(t-i))^c	*/
	if "$Taparch" != "" {		/* priming values are plugins	*/
		tempname b
		capture local i0 = colsof(`b0')
		if _rc { local i0 0 }

		local lnum : word count $Taparch
		tokenize $Taparch
		local i 1
		global Taparchx update $Tsig_pow = $Tsigma2 `powrest'
		local powrest
		while "``i''" != "" {
			local i1 = `i0' + `i'
			local i2 = `i1' + `lnum'
			global Taparchx $Taparchx + `b'[1,`i1'] *	/*
			*/  (						/*
			*/	cond(l``i''.$Te >= .,			/*
			*/		$Tabse_0 ,			/*
			*/		abs(l``i''.$Te)			/*
			*/	) + 					/*
			*/	`b'[1,`i2'] * 				/*
			*/	cond(l``i''.$Te >= ., 			/*
			*/		$Tabse_0 ,			/*
			*/		l``i''.$Te			/*
			*/	)					/*
			*/   )^$Tpower
			local i = `i' + 1
		}
		global Taparchx : subinstr global Taparchx "`b'" "\`b'", all

		mat `T' = J(1, 2*`lnum', cond("`archb0'"=="", .05, .005))
		mat `b0' = nullmat(`b0') , `T'

		local apcheqn (APARCH:  = l(`aparch').$Te 		/*
			*/ l(`aparch').$Tu, nocons)	/* vars don't matter */

					/* maintain name stripe */
		AddStrip colnams : "`colnams'" "`aparch'" ARCH aparch
		AddStrip colnams : "`colnams'" "`aparch'" ARCH aparch_e
	}

					/* NPARCH terms and equation	*/
					/* (b(|e_(t-i)| - k)^c	*/
	if "$Tnparch" != "" {		/* priming values are plug-ins */
		tempname b
		capture local i0 = colsof(`b0')
		if _rc { local i0 0 }

		local lnum : word count $Tnparch
		tokenize $Tnparch
		local i 1
		if "$Taparch" == "" {
			global Tnparchx update $Tsig_pow = $Tsigma2 `powrest'
		}
		else	global Tnparchx update $Tsig_pow = $Tsig_pow `powrest'
		while "``i''" != "" {
			local i1 = `i0' + `i'
			if "`nparchk'" == "" {
				local i2 = `i1' + `lnum'
			}
			else	local i2 = `i0' + `lnum' + 1
			global Tnparchx $Tnparchx + `b'[1,`i1'] *	/*
			*/  abs(					/*
			*/	cond(l``i''.$Te >= .,			/*
			*/		$Tabse_0 , 			/*
			*/		l``i''.$Te			/*
			*/	) - `b'[1,`i2']				/*
			*/   )^$Tpower
			local i = `i' + 1
		}
		global Tnparchx : subinstr global Tnparchx "`b'" "\`b'", all

		local init = cond("`archb0'"=="", .05, .005)
		if "`nparchk'" == "" {
			mat `T' = J(1, 2*`lnum', `init')
		}
		else	mat `T' = J(1, `lnum'+1, `init')
		mat `b0' = nullmat(`b0') , `T'

		if "`nparchk'" == "" {
			local npcheqn (NPARCH:  = l(`nparch').$Te 	/*
				*/ l(`nparch').$Tu, nocons)	/* any vars */
		}
		else {
			local npcheqn (NPARCH:  = l(`nparch').$Te)
		}

					/* maintain name stripe */
		AddStrip colnams : "`colnams'" "`nparch'" ARCH nparch
		if "`nparchk'" == "" {
			AddStrip colnams : "`colnams'" "`nparch'" ARCH nparch_k
		}
		else	AddStrip colnams : "`colnams'" 0 ARCH nparch_k
	}

					/* EARCH terms (could use Monfort) */
					/* a*abs(u/sigma) + b*(u/sigma) */
					/*    a*abs(z)    +   b*z	*/
	if "$Tearch" != "" {
		tempvar z absz tearch tearcha
		global Tz `z'
		global Tabsz `absz'
		global Ttearch `tearch'
		global Ttearcha `tearcha'
		qui gen double $Tz = . in 1
		qui gen double $Tabsz = . in 1
		qui gen double $Ttearch = . in 1
		qui gen double $Ttearcha = . in 1
		global Tnormadj = sqrt(2 / _pi)

		local lnum : word count `earch'
		mat `T' = J(1, 2*`lnum', .0)
		mat `b0' = nullmat(`b0') , `T'

		local eaeqn1 (EARCH:  = l(`earch').$Tz, nocons)
		local eaeqn2 (EARCHa:  = l(`earch').$Tabsz, nocons)

					/* maintain name stripe */
		AddStrip colnams : "`colnams'" "`earch'" ARCH earch
		AddStrip colnams : "`colnams'" "`earch'" ARCH earch_a
	}
	else {
		global Tdoearch "*"
		global Ttearch 0
		global Ttearcha 0
	}

					/* EGARCH terms (could use Monfort) */
					/*   a*ln(sigma^2)		*/
	if "$Tegarch" != "" {
		tempvar lnsig2 tegarch
		global Tlnsig2 `lnsig2'
		global Ttegarch `tegarch'
		qui gen double $Tlnsig2 = . in 1
		qui gen double $Ttegarch = . in 1

		local lnum : word count `egarch'
		mat `T' = J(1, `lnum', .0)
		mat `b0' = nullmat(`b0') , `T'

		local egeqn (EGARCH:  = l(`egarch').$Tlnsig2, nocons)

					/* maintain name stripe */
		AddStrip colnams : "`colnams'" "`egarch'" ARCH egarch

	}
	else {
		global Tdoegrch "*"
		global Ttegarch 0
	}

	if "$Tearch$Tegarch" == "" { 
		global Tdoeaeg "*" 
	}
	else if "$Tparch$Tpgarch$Ttparch" == "" { qui replace $Te2 = ln($Te2) }
				/* prep u^2 for remaining initial comps */

				/* PGARCH, TPARCH, ABPARCH terms */

	if "$Ttparch" != "" {
		tempvar e_tpow
		global Te_tpow `e_tpow'
		qui gen double $Te_tpow = ($Te > 0)*abs($Te)^`pow0'
			*/ cond($Te > 0, abs($Te)^`pow0', 0)
		global Ttpowex  /*
			*/ "update $Te_tpow = ($Te > 0)*abs($Te)^$Tpower"
	}

	if "$Tparch" == "" { global Tdoabpow "*" }

	if "$Tparch$Tpgarch$Ttparch" != "" {
		tempvar e_abpow
		global Te_abpow `e_abpow'
		qui gen double $Te_abpow = $Te2^(`pow0'/2)
		if "$Tparch" != ""  {
			global Tabpowex "update $Te_abpow = abs($Te)^$Tpower"
		}

		if "$Tparch" != "" { local abterms "l($Tparch).$Te_abpow" }
		if "$Ttparch" != "" { local taterms "l($Ttparch).$Te_tpow" }
		if "$Tpgarch" != "" { local gaterms "l($Tpgarch).$Tsig_pow" }

		local docons = /*
*/ "`archcon'$Tarch$Tgarch$Ttarch$Tsaarch$Tabarch$Tatarch$Tearch$Tegarch$Tsdgarch"=="" 

		if "`archb0'" == "" {
			/* Get residuals from AR representation of errors */
			MinLag minlag : "$Tparch" "$Tpgarch" "$Ttparch" 
			if "$Tparch$Ttparch" != "" {
				numlist "$Tparch $Ttparch", sort
				MaxLagS maxlag : 2 "`r(numlist)'" "$Tpgarch"
			}
			else	MaxLagS maxlag : 1 "$Tpgarch"

			capture Monfort $Tsig_pow : $Te_abpow  /*
				*/ `minlag' `maxlag' `interva' `touse'

			/* Get b0 estimates of ABPARCH and PGARCH parameters */

			capture regress $Te_abpow `abterms' `taterms'  /*
				*/ `gaterms' if `touse'
			if !_rc {
				mat `T' = e(b)
				if !`docons' { 
					mat `T' = `T'[1,1..colsof(`T')-1] 
				}


if "$Tpgarch" != "" {			/* <=========== */
			/*  compute parch and pgarch params from regression */
	local nar : word count $Tparch $Ttparch
	local gar : word count $Tpgarch
	tokenize $Tparch
	local i 1 
	while "``i''" != "" {
		local done 0
		local j 1
		while !`done' & `j' <= `gar' {
			local glag : word `j' of $Tpgarch
			if ``i'' == `glag' {
				local gj = `nar' + `j'
				mat `T'[1,`i'] = `T'[1,`i'] + `T'[1,`gj']
				mat `T'[1,`gj'] =  -`T'[1,`gj']
				local done 1
			}
			local j = `j' + 1
		}
		local i = `i' + 1
	}
}					/* ===========> */

			mat `b0' = nullmat(`b0') , `T'
			}
			else	local archb0b "archb0"
		}
		if "`archb0'`archb0b'" != "" {
			local ct : word count $Tparch $Ttparch $Tpgarch
			mat `T' = J(1, `ct', 0)
			mat `b0' = nullmat(`b0') , `T'
			if `docons' {
				sum $Te_abpow, meanonly, if `touse'
				mat `b0' = `b0', r(mean)
			}
		}


					/* maintain name stripe */
		AddStrip colnams : "`colnams'" "$Tparch" ARCH parch
		AddStrip colnams : "`colnams'" "$Ttparch" ARCH tparch
		AddStrip colnams : "`colnams'" "$Tpgarch" ARCH pgarch
		if `docons' {
			local colnams `colnams' ARCH:_cons 
			local archcon "nocons"
		}
		else	local mycons "nocons" 

					/* ML equation */
		local powaeqn  ( PARCH:  `yprefix' = `abterms' `taterms'  /*
			*/ `gaterms' , `mycons' )
		local yprefix

					/* S^p updating in arch_dr */
		if "$Taparch$Tnparch" == "" {
			global Taparchx update $Tsig_pow = $Tsigma2 + $Ttvar
		}
		local abterms
		local taterms
		local gaterms
			
				/* prep u^2 for remaining initial comps */
		qui replace $Te2 = $Te2^(1/`pow0')
		if "$Tearch$Tegarch" != "" { qui replace $Te2 = ln($Te2) }
	}
	else if "$Taparch$Tnparch" == "" {
		global Tdopow  "*"
		global Tdopowa "*"
	}
	else	global Tdopow "*"

				/* ABARCH, ATARCH, SDGARCH */

	if "$Tabarch$Tatarch$Tsdgarch" != "" {

		tempvar abse
		global Tabse `abse'
		qui gen double $Tabse = abs($Te)
		if "$Tabarch" != "" {
			global Tabe_upd update $Tabse = abs($Te)
		}

		if "$Tatarch" != "" {
			tempvar tabse
			global Ttabse `tabse'
			qui gen double $Ttabse = abs($Te) * ($Te > 0)
			global Ttae_upd update $Ttabse = abs($Te)*($Te > 0)
		}

		tempvar sig
		global Tsig `sig'
		if "$Tsdgarch" != "" {
			qui gen double $Tsig = . in 1
			global Tsig_upd update $Tsig = sqrt($Tsigma2)
		}

		global Tsd_scr  /*
			*/ score $Tsig = \`b', eq("SDARCH") missval(\`sig_0')
		global Tsd_updt update $Tsigma2 = $Tsigma2 + $Tsig^2

		if "$Tabarch" != "" { local abterms "l($Tabarch).$Tabse" }
		if "$Tatarch" != "" { local atterms "l($Tatarch).$Ttabse" }
		if "$Tsdgarch" != "" { local sdterms "l($Tsdgarch).$Tsig" }

		local docons = "`archcon'$Tarch$Tgarch$Ttarch$Tsaarch"=="" 
		if "`archb0'" == "" {
			/* Get residuals from AR representation of errors */
			MinLag minlag : "$Tabarch" "$Tsdgarch" "$Tatarch" 
			if "$Tabarch$Tatarch" != "" {
				numlist "$Tabarch $Tatarch", sort
				MaxLagS maxlag : 2 "`r(numlist)'" "$Tsdgarch"
			}
			else	MaxLagS maxlag : 1 "$Tsdgarch"

			capture Monfort $Tsig : $Tabse `minlag' `maxlag'  /*
				*/ `interva' `touse'

			/* Get b0 estimates of ABARCH and SDGARCH parameters */

			capture regress $Tabse `abterms' `atterms'  /*
				*/ `sdterms' if `touse'
			if !_rc {
				mat `T' = e(b)
				if !`docons' { 
					mat `T' = `T'[1,1..colsof(`T')-1] 
				}


if "$Tsdgarch" != "" {			/* <=========== */
			/*  compute parch and pgarch params from regression */
	local nar : word count $Tabarch $Tatarch
	local gar : word count $Tsdgarch
	tokenize $Tsdgarch
	local i 1 
	while "``i''" != "" {
		local done 0
		local j 1
		while !`done' & `j' <= `gar' {
			local glag : word `j' of $Tsdgarch
			if ``i'' == `glag' {
				local gj = `nar' + `j'
				mat `T'[1,`i'] = `T'[1,`i'] + `T'[1,`gj']
				mat `T'[1,`gj'] =  -`T'[1,`gj']
				local done 1
			}
			local j = `j' + 1
		}
		local i = `i' + 1
	}
}					/* ===========> */

				mat `b0' = nullmat(`b0') , `T'
			}
			else	local archb0b "archb0"
		}
		if "`archb0'`archb0b'" != "" {
			local ct : word count $Tabarch $Tatarch $Tsdgarch
			mat `T' = J(1, `ct', 0)
			mat `b0' = nullmat(`b0') , `T'
			if `docons' {
				sum $Te2, meanonly, if `touse'
				mat `b0' = `b0', sqrt(r(mean))
			}
		}


					/* maintain name stripe */
		AddStrip colnams : "`colnams'" "$Tabarch" ARCH abarch
		AddStrip colnams : "`colnams'" "$Tatarch" ARCH atarch
		AddStrip colnams : "`colnams'" "$Tsdgarch" ARCH sdgarch
		if `docons' {
			local colnams `colnams' ARCH:_cons 
			local archcon "nocons"
			local mycons
		}
		else	local mycons "nocons" 

					/* ML equation */
		local sdeqn  ( SDARCH:  `yprefix' = 		/*
			*/ `abterms' `atterms' `sdterms', `mycons' )
		local yprefix

		local abterms
		local atterms
		local sdterms
	}
				/* ARCH, GARCH, TARCH, SAARCH, terms */

	if "$Ttarch" != "" {
		tempvar e_tarch
		global Te_tarch `e_tarch'
		qui gen double $Te_tarch = ($Te > 0)*$Te2
	}
	else	global Tdotarch "*"


	if "$Tarch$Tgarch$Ttarch$Tsaarch" != "" {

		if "$Tarch"  != "" { local acterms "l($Tarch).$Te2" }
		if "$Tgarch" != "" { local gaterms "l($Tgarch).$Tsigma2" }
		if "$Ttarch" != "" { local taterms "l($Ttarch).$Te_tarch" }
		if "$Tsaarch" != "" { local aaterms "l($Tsaarch).$Te" }

		if "`archb0'" == "" {
			/* Get residuals from AR representation of errors */
			MinLag minlag : "$Tarch" "$Tgarch" "$Ttarch" "$Tsaarch" 
			if "$Tarch$Ttarch$Tsaarch" != "" {
			   numlist "$Tarch $Ttarch $Tsaarch", sort
			   MaxLagS maxlag : 2 "`r(numlist)'" "$Tgarch"
			}
			else	MaxLagS maxlag : 1 "$Tgarch"

			capture Monfort $Tsigma2 : $Te2   /*
				*/ `minlag' `maxlag' `interva' `touse'

			/* Get b0 estimates of ARCH and GARCH parameters */

			capture regress $Te2 `acterms' `abterms' `atterms' /*
				*/ `taterms' `aaterms' `gaterms'	   /*
				*/ if `touse'
			if !_rc {
				mat `T' = e(b)
				if "`archcon'" != "" { 
					mat `T' = `T'[1, 1..colsof(`T')-1]
				}

if "$Tgarch" != "" {			/* <=========== */
			/*  compute arch and garch params from regression */
	local nar : word count $Tarch $Ttarch $Tsaarch 
	local gar : word count $Tgarch
	tokenize $Tarch
	local i 1 
	while "``i''" != "" {
		local done 0
		local j 1
		while !`done' & `j' <= `gar' {
			local glag : word `j' of `garch'
			if ``i'' == `glag' {
				local gj = `nar' + `j'
				mat `T'[1,`i'] = `T'[1,`i'] + `T'[1,`gj']
				mat `T'[1,`gj'] =  -`T'[1,`gj']
				local done 1
			}
			local j = `j' + 1
		}
		local i = `i' + 1
	}
}					/* ===========> */

				if "$Ttarch$Tsaarch" ==  "" {
					FixARCH `T' `archcon'
				}
				mat `b0' = nullmat(`b0') , `T'
			}
			else	local archb0b "archb0"
		}
		if "`archb0'`archb0b'" != "" {
			local ct : word count $Tarch $Ttarch $Tsaarch $Tgarch
			mat `T' = J(1, `ct', 0)
			mat `b0' = nullmat(`b0') , `T'
			if "`archcon'" == "" {
				sum $Te2, meanonly, if `touse'
				mat `b0' = `b0', r(mean)
			}
			if "`archb0b'" == "" { 
				qui gen double $Tsigma2 = . in 1
			}
		}


					/* maintain name stripe */
		AddStrip colnams : "`colnams'" "$Tarch" ARCH arch
		AddStrip colnams : "`colnams'" "$Ttarch" ARCH tarch
		AddStrip colnams : "`colnams'" "$Tsaarch" ARCH saarch
		AddStrip colnams : "`colnams'" "$Tgarch" ARCH garch
		if "`archcon'" == "" { local colnams `colnams' ARCH:_cons }

					/* ML equation */
		if "$Tarch$Tgarch$Ttarch$Tsaarch" != "" | "`archcon'"=="" {
			local archeqn  ( ARCH:  `yprefix' = `acterms'	/*
				*/ `abterms' `atterms' `taterms' 	/*
				*/ `aaterms' `gaterms' , `archcon' )
			local yprefix
		}
	}
	else if $Tarchany & "`archcon'" == "" {
				/* Special case where we need a constant */
				/* Te2 already on proper scale for
				 * egarch, pgarch, if specified */
		local archeqn  ( ARCH:  `yprefix' = )
		local yprefix
		sum $Te2, meanonly, if `touse'
		mat `b0' = nullmat(`b0') , `r(mean)'
		local colnams `colnams' ARCH:_cons
		qui gen double $Tsigma2 = . in 1
	}
	else {
		qui gen double $Tsigma2 = . in 1
		global Tdoarch "*"
	}

				/* Power parameter */

	if "$Tparch$Ttparch$Taparch$Tnparch$Tpgarch" != "" {
		global Tdopowi 1
		local poweqn (POWER: = )
		mat `b0' = nullmat(`b0') , `pow0'
		AddStrip colnams : "`colnams'" 0 POWER power
	}
	else	global Tdopowi 0
	
				/* degrees of freedom if t or GED dist'n
					and not specified a priori	*/
	if "$Tdfopt" != "*" {
		if "$Tdistt" == "" {
			local dfeqn /lndfm2
			mat `b0' = nullmat(`b0'), ln(28)
			AddStrip colnams : "`colnams'" 0 lndfm2 _cons
		}
		else if "$TdistGED" == "" {
			local dfeqn /lnshape
			mat `b0' = nullmat(`b0'), ln(2)	/* 2 -> normal dist */
			AddStrip colnams : "`colnams'" 0 lnshape _cons
		}
	}		
				/* End starting values and matrix stripe */

				/* Maximize -- ML */

					/* Get title and method */
	EstType ml_prog title title2 :
					/* Handle constraints, if any */
	if "`constra'" != "" { 
						/* make constraints using 
						 * dummy matrices */
		tempname b V T a C 
						/* set full model */
		version 8.1: ///
		ml model rdu0 `ml_prog'		/*
			*/  `xbeqn' `ameaneq' `armaeqn' 		/*
			*/ `heteqn' `neqn' `aaeqn' `apcheqn' `npcheqn'	/*
			*/ `eaeqn1' `eaeqn2' `egeqn' `sdeqn'		/*
			*/ `powaeqn' `abcheqn' `archeqn' `poweqn' 	/*
			*/ `dfeqn'					/*
			*/ , `technique' `vce' missing nopreserve 	/*
			*/   collinear

		mat `b' = $ML_b
		local cnsnams : colfullnames `b'
		mat colnames `b' = `colnams'
		mat `V' = `b'' * `b'
		mat post `b' `V'
		capture mat makeCns `constra'
		if _rc {
			local rc = _rc
			di in red "Constraints invalid:"
			mat makeCns `constra'
			exit _rc
		}
		matcproc `T' `a' `C'
		global TT `T'			/* globals for LL evaluator */
		global Ta `a'
		global Tstripe : colfullnames $ML_b

						/* constrain b0 */
		if "`from'" != "" & "`archb0'`armab0'" == "" {
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
		local ameaneq 
		local armaeqn
		local heteqn 
		local neqn 
		local aaeqn 
		local apcheqn 
		local npcheqn
		local eaeqn1 
		local eaeqn2 
		local egeqn 
		local sdeqn
		local powaeqn 
		local abcheqn 
		local archeqn 
		local poweqn
		local dfeqn
	}
					/* Set initial values */
	if "`from'" != "" & "`archb0'`armab0'" == "" & "`constra'" == "" { 
		_mkvec `b0', from(`from') first  colnames(`colnams') /*
			*/ error("from()")
	}
	local from "`b0', copy"

					/* Fit the model */
	if `nobs' < colsof(`b0') {
		di in gr "insufficient observations"
		exit 2000
	}
					/* Round the starting values */
	local cols = colsof(`b0')
	forval i=1/`cols' {
		mat `b0'[1,`i'] = round(`b0'[1,`i'],1e-9)
	}
	
	version 8.1: ///
	capture noi ml model rdu0 `ml_prog' `xbeqn' `ameaneq' `armaeqn'	 /*
		*/ `heteqn' `neqn' `aaeqn' `apcheqn' `npcheqn'		 /*
		*/ `eaeqn1' `eaeqn2' `egeqn' `sdeqn'			 /*
		*/ `powaeqn' `abcheqn' `archeqn' `poweqn' `dfeqn'	 /*
		*/ [`weight'`exp']  if `touse' ,			 /*
		*/ obs(`nobs') title(`title') `score' `robust'		 /*
		*/  missing maximize nooutput nopreserve collinear 	 /*
		*/  `technique' `vce' `difficult' gtolerance(`gtolera')	 /*
		*/  init(`from') search(off) `stdopts' `mlopts' 	 /*
		*/  `bracket'

	if _rc == 1400 & "`from'" == "`b0', copy" & "`archb0'`armab0'" == "" {
		di in gr "(note:  default initial values infeasible; "  /*
			*/ "starting ARCH/ARMA estimates from 0)"
		capture noi arch `0' from(armab0 archb0)
		if _rc == 198 {
			capture noi arch `0', from(armab0 archb0)
		}
		exit _rc
	}
	else if _rc {
		exit _rc
	}

	if "`constra'" != "" {		/* put problem back in original space */
		mat `b' = get(_b) * `T'' + `a'
		mat `V' = `T' * e(V) * `T''
		mat colnames `b' = `cnsnams'
		mat rownames `V' = `cnsnams'
		mat colnames `V' = `cnsnams'
		mat post `b' `V' `C', noclear
	}
					/* Fix-up names on matrices */
	mat `b0' = e(b)
	local eqnames : coleq `b0'		/* for saved results */
	mat colnames `b0' = `colnams'
	mat repost _b=`b0', rename
					/* Model Chi	*/
	if "`ind_m'"  != "" { 
		tsrevar `dep_m', list
		qui test [`r(varlist)'] 
		local accum accum
	}
	if "`ar'`ma'" != "" { 
		qui test [ARMA], `accum' 
		local accum accum
	}
	if "`archm'" != "" {
		qui test [ARCHM], `accum' 
	}
	if "`ar'`ma'`ind_m'`archm'" != "" { 
		qui test 
					/* Saved results */
		est scalar p = r(p)
		est scalar df_m = r(df)
		est scalar chi2 = r(chi2)
	}
	else {				/* Clear out -ml- results */
		est scalar p = .
		est scalar df_m = .
		est scalar chi2 = .
	}

					/* Saved results */

	sum `timevar' if `touse' , meanonly
	est scalar tmin = r(min)
	est scalar tmax = r(max)
	local fmt : format `timevar'
	est local tmins = trim(string(r(min), "`fmt'"))
	est local tmaxs = trim(string(r(max), "`fmt'"))

	est scalar archi  = $Tsig2_0
	if "$Tpower" != "" {est scalar power = $Tpower}
	est scalar N_gaps = `gaps'
	est scalar condobs = $Tskipobs

	est hidden local cond `conditi'		/* flag that called by arima */
	est scalar archany = $Tarchany
	est local eqnames `eqnames'
	est local archm $Tarchm
	est local archmexp `archmex'
	est local ar $Tar
	est local ma $Tma
	est local mhet $Tmhet
	est hidden local doarch $Tdoarch
	est local earch $Tearch
	est local egarch $Tegarch
	est local saarch $Tsaarch
	est local aarch $Taarch
	est local narch $Tnarch
	est local aparch $Taparch
	est local nparch $Tnparch
	est local saarch $Tsaarch
	est local parch $Tparch
	est local tparch $Ttparch
	est local abarch $Tabarch
	est local atarch $Tatarch
	est local tarch $Ttarch
	est local sdgarch $Tsdgarch
	est local pgarch $Tpgarch
	est local garch $Tgarch
	est local arch $Tarch
	est local title2 `title2'
	est local estat_cmd arch_estat
	est local predict arch_p
	est local tech `techniq'
	if "`e(vcetype)'" == "Robust" { 
		est local vcetype `e(vcetype2)' Semirobust 
	}
	if "`e(vce)'" == "oim" {
		est local vcetype "OIM"
	}

	mat `b0' = e(b)
	local k : coleq `b0'
	local k : list uniq k
	local k : word count `k'
	est scalar k_eq = `k'
	tempname shape
	if "$TdistN" == "" {
		est local dist "gaussian"
							/* SIGMA2 */
		est scalar k_aux = (($Tarchany==0) & ("$Tmhet"==""))
	}
	else if "$Tdistt" == "" {
		est local dist "t"
		if "$Tdfopt" == "" {
				// if we optimized df, cant rely on
				// $Ttdf having the final estimate
			mat `shape' = `b0'[1,"lndfm2:_cons"]
			sca `shape' = exp(trace(`shape')) + 2
			est scalar tdf = `shape'
			est local dfopt "yes"
			est scalar k_aux = 1 + 			/*
				*/  (($Tarchany==0) & ("$Tmhet"=="")) /*SIGMA2*/
			est hidden local diparm1 lndfm2, label(df) /*
				*/ f(exp(@)+2) derivative(exp(@))
		}
		else {
			est local dfopt "no"
			est scalar k_aux = (($Tarchany==0) &		/*
					*/  ("$Tmhet"==""))	/* SIGMA2 */
			est scalar tdf = $Ttdf
		}
	}
	else if "$TdistGED" == "" {
		est local dist "ged"
		if "$Tdfopt" == "" {
			mat `shape' = `b0'[1,"lnshape:_cons"]
			sca `shape' = exp(trace(`shape'))
			est scalar shape = `shape'
			est local dfopt "yes"
			est scalar k_aux = 1 + 			/*
				*/  (($Tarchany==0) & ("$Tmhet"=="")) /*SIGMA2*/
			est hidden local diparm1 lnshape, label("shape") exp
		}
		else {
			est local dfopt "no"
			est scalar k_aux = (($Tarchany==0) &		/*
					*/  ("$Tmhet"==""))	/* SIGMA2 */
			est scalar shape = $TGEDdf
		}
	}
	else {			/* Should not reach */
		exit 9999
	}
	est local marginsok xb y Variance Het default
	est local marginsnotok Residuals YResiduals
	est local covariates `"`COVARS'"'
	version 10: ereturn local cmdline `"arch `cmdline'"'
	est repost, buildfvinfo
	est local cmd "arch"

					/* Results */
	Display , `coef' `head' level(`level') `diopts'
	ArchDrop
end


program define Display
	syntax [, Level(cilevel) noCOEF noHEAD *]

	_get_diopts diopts, `options'
	if "`e(dist)'" == "gaussian" {
		local line2 in gr "Distribution: " in ye "Gaussian"
	}
	else if "`e(dist)'" == "t" {
		if "`e(dfopt)'" == "no" {
			local k : di %5.4g `e(tdf)'
			local line2 in gr /*
			    */ "Distribution: " in ye "t(" trim("`k'") ")"
		}
		else {
			local line2 in gr "Distribution: " in ye "t"
		}
	}
	else if "`e(dist)'" == "ged" {
		if "`e(dfopt)'" == "no" {
			local k : di %5.4g `e(shape)'
			local line2 in gr /*
			    */ "Distribution: " in ye "GED(" trim("`k'") ")"
		}
		else {
			local line2 in gr "Distribution: " in ye "GED"
		}
	}

	if "`head'" == "" { 
                DisplayHdr, line2(`"`line2'"')
	}


	if "`coef'" == "" { 
		_coef_table, level(`level') `diopts'
	}
	if e(rc) {
		exit `e(rc)'
	}
end


program define Check0	/* Remove 0's from lag numlists */ /* not used */
	args	    numlfix	/* local macro for numlist with " 0 " removed 
		*/  colon	/*  :
		*/  numl	/* original numlist
		*/  note	/* name to go on note of " 0 " found */

	local fixed : subinstr local numl "0" "", all word count(local ct)

	if `ct' > 0 {
		di in gr "note: 0 lag in `note' ignored"
	}
	c_local `numlfix' `fixed'
end


program define PrsArch0
	syntax [, Xb XB0 XB0wt XBWt Zero * ]

	global Tarch0 = trim("`xb0' `xb0wt' `xb' `xbwt' `zero' `options'")
	local ct : word count $Tarch0

	if `ct' == 0 {
		global Tarch0 xb
		exit
	}

	if `ct' > 1 {
		di in red "arch0() may contain one only from:  "
		di in red "xb, xb0, xb0wt xb, xbwt, zero, #"
		exit 198
	}

	if "`zero'" != "" { 
		scalar $Tsig2_0 = 0 
		exit
	}

	capture confirm number $Tarch0 
	if !_rc {
		scalar $Tsig2_0 = $Tarch0
		exit
	}

	if "`options'" != "" {
		di in red "invalid arch0($Tarch0)"
		exit 198
	}

	/* otherwise, just return the specified option */
end


program define PrsArma0
	syntax [, P Q PQ QP Zero 0 * ]

				/* Dont include `*' in next line */
	global Tarma0 = trim("`p' `q' `pq' `qp' `zero' `0'")

	global Tarma0v = 0 
	
	if "$Tarma0" == "" {
		global Tarma0 p
		exit
	}

	if "$Tarma0" == "p" {
		local end : word count $Tar
		if `end' != 0 { global Tskipobs : word `end' of $Tar }
		exit 
	}

	if "$Tarma0" == "q" {
		local end : word count $Tma
		if `end' != 0 { global Tskipobs : word `end' of $Tma }
		exit 
	}

	if "$Tarma0" == "pq" | "$Tarma0" == "qp" {
		local end : word count $Tar
		if `end' != 0 { global Tskipobs : word `end' of $Tar }

		local end : word count $Tma
		if `end' != 0 { local skipma : word `end' of $Tma }

		global Tskipobs = 0$Tskipobs + 0`skipma'
		if $Tskipobs == 0 { global Tskipobs }
		exit 
	}

	if "$Tarma0" == "zero" | "$Tarma0" == "0" {
		exit
	}

	if real("`options'") < . {
		global Tarma0v = real("`options'")
		exit
	}
	
	di in red "arma0() may contain one only from:  p, q, pq, qp, zero, 0"
	exit 198

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
	args	    b

	tempname bsum
	scalar `bsum' = 0

						/* AR terms */
	local nar : word count $Tar
	local i 1
	while `i' <=  `nar' {
		scalar `bsum' = `bsum' + `b'[1, `i']
		local i = `i' + 1
	}

	if abs(`bsum') > .95 {
		mat `b'[1,1] = (.95 / abs(`bsum')) * `b'[1,1..`nar']
	}

						/* MA terms */
	local nma : word count $Tma
	local narma = `nma' + `nar'
	local i = `nar' + 1
	while `i' <=  `narma' {
		if abs(`b'[1, `i']) > 0.95 {
			mat `b'[1, `i'] = .95 * `b'[1, `i'] / abs(`b'[1, `i'])
		}
		local i = `i' + 1
	}
end

program define FixARCH		/* only for arch/garch terms */
	args b nocons

	tempname bsum
	scalar `bsum' = 0

	local cols = colsof(`b') - ("`nocons'" == "")
	local i 1
	while `i' <= `cols' {
		if `b'[1,`i'] < .01 { mat `b'[1,`i'] = .01 }
		scalar `bsum' = `bsum' + `b'[1,`i']
		local i = `i' + 1
	}

	if "`nocons'" == "" {
		if `b'[1,colsof(`b')] <= 0 {
			mat `b'[1,colsof(`b')] = .01
		}
	}

	if `bsum' > .95 {
		mat `b'[1,1] = (.95 / `bsum') * `b'[1,1..`cols']
	}

end


program define EstType 
	args	    ml_prog	/*  likelihood evaluation program name
		*/  title	/*  primary title for the model
		*/  title2	/*  secondary title for the model
		*/  colon	/*  :					*/

	c_local `ml_prog' arch_dr

	if $Tarchany {
		local ltitle "ARCH family regression"
	}
	else	local ltitle "Time-series regression"

	if "$Tar$Tma" != "" & "$Tmhet" != "" {
local ltitle "`ltitle'  -- ARMA disturbances and mult. heteroskedasticity"
	}
	else if "$Tar" != "" & "$Tma" != "" { 
		local ltitle "`ltitle' -- ARMA disturbances" 
	}
	else if "$Tar" != "" { 
		local ltitle "`ltitle' -- AR disturbances" 
	}
	else if "$Tma" != "" { 
		local ltitle "`ltitle' -- MA disturbances" 
	}
	else if "$Tmhet" != "" {
		local ltitle "`ltitle' -- multiplicative heteroskedasticity"
	}

	c_local `title' `ltitle'
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

program define MaxLag		/* maxlag : numlist1 numlist2 ... numlistN */
	args maxlag colon

	mac shift 2
	
	numlist "`*'", sort

	local lastel : word count `r(numlist)'
	local lastval : word `lastel' of `r(numlist)'

	c_local `maxlag' `lastval'
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
			di in gr "(note:  insufficient memory or "	/*
				*/ "observations to estimate usual"
			di in gr "starting values [1])"
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
			di in gr "(note:  insufficient memory or "	/*
				*/ "observations to estimate usual"
			di in gr "starting values [2])"
			local vir 0
		}
		local usemax = `usemax' - 1
	}
	
	capture drop `u_var'
	qui gen double `u_var' = . in 1

	if `hold_rc' == 2000 { 
		di in red "insufficient observations"
		exit 2000
	}
	di in red "insufficient memory or observations to estimate " /*
		*/ "starting values"
	exit `hold_rc'
end


program define ErrCheck
	if _rc == 111 | _rc == 2000 {
		di in gr "insufficient observations"
		exit _rc
	}

	if _rc {
		error _rc
		exit
	}
end

program PrsDist, sclass

	local input `0'
	
	local udist : word 1 of `input'
	

	if strmatch(`"`udist'"', 		/*
		*/ bsubstr("gaussian", 1, max(3,length(`"`udist'"')))) {
		local dist "gaussian"
	}
	else if strmatch(`"`udist'"', 		/*
		*/ bsubstr("normal", 1, max(3,length(`"`udist'"')))) {
		local dist "gaussian"
	}
	else if strmatch(`"`udist'"', "ged") {
		local dist "ged"
	}
	else if strmatch(`"`udist'"', "t") {
		local dist "t"
	}
	else if `"`udist'"' == "" {
		local dist "gaussian"		// default
	}
	else {
		di in smcl as error /*
			*/ "invalid distribution in {cmd:distribution()}"
		exit 198
	}
	
	local udf : word 2 of `input'

	if "`udf'" != "" { 
		if "`dist'" == "gaussian" {
			di as error /*
*/ "cannot specify degrees of freedom or shape parameter with Gaussian errors"
			exit 198
		}
		capture confirm number `udf'
		if _rc {
			if "`dist'" == "t" {
				di in smcl as error /*
*/ "invalid degrees of freedom in {cmd:distribution()}"
			}
			else if "`dist'" == "ged" {
				di in smcl as error /*
*/ "invalid shape parameter in {cmd:distribution()}"
			}
			exit _rc
		}
	}

	sreturn local dist `dist'
	sreturn local df `udf'

end

program define DisplayHdr

	syntax  [, line2(string) ]		

	local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.)

	if e(N_gaps) > 0 { 
		local gapcoma ","
		if e(N_gaps) == 1 {
			local gaptitl "but with a gap"
		}
		else {
			local gaptitl "but with gaps"
		}
	}
	
	di _n in gr "`e(title)'"
	if `"`e(title2)'"' != "" { di in gr "`e(title2)'" }

	local x1 = strtrim(`"`e(tmins)'"')
	local x2 = strtrim(`"`e(tmaxs)'"')
	local smpl1 "Sample: " in ye "`x1' -"
			/* NB smpl has extra 9 chars for " in ye " */
	if (length(`"`smpl1'"') + length(`"`x2'`gapcoma' `gaptitl'"')) < 87 {
		local smpl1 "`smpl1' `x2'`gapcoma' `gaptitl'"
	}
	else if (length(`"`smpl1'"') + length(`"`x2'`gapcoma'"')) < 87 {
		local smpl1 "`smpl1' `x2'`gapcoma'"
		local smpl2 "`gaptitl'"
	}
	else if (length(`"`x2'`gapcoma' `gaptitl'"')) < 45 {
		local smpl2 "`x2'`gapcoma' `gaptitl'"
	}
	else {
		local smpl2 "`x2'`gapcoma'"
		local smpl3 "`gaptitl'"
	}
	
	if `"`smpl3'"' != "" {
		di in gr _n "`smpl1'"
		di in ye _col(10) "`smpl2'"
		if length(`"`smpl2'"') < 36 {	// cluttered otherwise
			local osmpl in ye _col(10) "`smpl3'"
		}
		else {
			di in ye _col(10) "`smpl3'"
		}
	}
	else if `"`smpl2'"' != "" {
		di in gr _n "`smpl1'"
		if length(`"`smpl2'"') < 36 {
				// will fit in line w/ # of obs
				// without being too cluttered
			di in ye _c
			local osmpl _col(10) "`smpl2'"
		}
		else {
				// won't fit, say it now
			di in ye _col(10) "`smpl2'"
		}
	}
	else {
		if length(`"`smpl1'"') < 56 {
			local osmpl in gr _n "`smpl1'"
		}
		else {
			di in gr _n "`smpl1'"
		}
	}
	local x1
	local x2

	di `osmpl'							/*
		*/ _col(51) in gr "Number of obs" in gr _col(67) "="	/*
		*/ in ye _col(69) %10.0gc e(N)

	if !missing(e(df_r)) {
		local model _col(51) as txt "F(" ///
			as res %3.0f e(df_m) as txt "," ///
			as res %6.0f e(df_r) as txt ")" _col(67) ///
			"=" _col(70) as res %9.2f e(F)
		local pvalue _col(51) as txt "Prob > F" _col(67) ///
			"=" _col(73) as res %6.4f Ftail(e(df_m),e(df_r),e(F))
	}
	else {
		if "`e(chi2type)'" == "" {
			local chitype Wald
		}
		else	local chitype `e(chi2type)'
		local model _col(51) as txt `"`chitype' chi2("' ///
			as res e(df_m) as txt ")" _col(67) ///
			"=" _col(70) as res %9.2f e(chi2)
		local pvalue _col(51) as txt "Prob > chi2" _col(67) ///
			"=" _col(73) as res %6.4f chiprob(e(df_m),e(chi2))
	}

	di `line2' `model'
	if "`e(ll)'" != "" {
		di in gr "`crtype' = " in ye %9.0g e(ll) `pvalue'
	}
	else {
		di `pvalue'
	}
	di

end

program define ArchDrop
	macro drop Tarchany Tar Tma Tarch Tgarch Tarchm Ttarch Ttparch 	///
		Tsaarch Tabarch Tatarch Tparch Taarch Tnarch Tearch 	///
		Tegarch Taparch Tnparch Tpgarch Tsdgarch Tu Te Te2 	///
		Tsigma2 Ttvar Tsig2_0 Tabse_0 Tskipobs TXbeq Thasxb 	///
		Tdoxb Ttarchm Tarchmex Ttarchme Tdoarchm Tdarchme 	///
		Tdoarma Ttimevar Ttimemin Ts2_mayb Ttouse2 Tmhet 	///
		Tnarchex Taarchex Tpower Tsig_pow Taparchx Tnparchx	///
		Tz Tabsz Ttearch Ttearcha Tnormadj Tdoearch Tlnsig2 	///
		Ttegarch Tdoegrch Tdoeaeg Te_tpow Ttpowex Tdoabpow 	///
		Te_abpow Tabpowex Tdopow Tdopowa Tabse Tabe_upd Ttabse	///
		Ttae_upd Tsig Tsig_upd Tsd_scr Tsd_updt Te_tarch	///
		Tdotarch Tdoarch Tdopowi TT Ta Tstripe Tic_hold 	///
		Tarch0 Tarma0 Tarma0v TdistN Tdistt TdistGED Tdfopt 	///
		Ttdf TGEDdf 
end




exit

partial list of globals set and used by arch_dr:
	Tar         numlist of AR terms in ARMA disturbances model
	Tma         numlist of MA terms in ARMA disturbances model
	Tarch       numlist of ARCH terms in ARCH variance model
	Tgarch      numlist of GARCH terms in ARCH variance model
	Tarchm      numlist of ARCH-in-mean terms in model
	Ttarch      numlist of threshold ARCH terms in ARCH variance model
	Tsaarch     numlist of simple asymmetric ARCH terms in ARCH model
	Taarch      numlist of asymmetric ARCH terms in ARCH variance model
	Tnarch      numlist of nonlinear NARCH terms in ARCH variance model
	Taparch     numlist of asym power APARCH terms in ARCH variance model
	Tpgarch     numlist of PGARCH terms in ARCH variance model (s^p)
	Tearch      numlist of EARCH terms in ARCH variance model a*z + b*|z|
	Tegarch     numlist of EGARCH terms in ARCH variance model (ln(s^2))
	Taarchex    evaluation expression for arch asymmetric terms
	Taarchb     global name to hold b for aarch terms
	Tnarchex    evaluation expression for narch terms
	Taparchx    evaluation expression for arch APARCH expression
	Tnparchx    evaluation expression for arch NPARCH expression
	Taparchb    global name to hold b for APARCH terms
	Tpower      global to hold scalar name for APARCH/NPARCH power
	Tarchany    1 if any Arch/Garch components specified 0 otherwise
	Tdopowi     1 if any power terms, 0 otherwise
	Tu          tempvar for regression disturbances (may be ARMA)
	Te          tempvar for white noise disturbances (MA and ARCH inputs)
	Te2         tempvar for ARCH white noise disturbances^2 
	Tsigma2     tempvar for ARCH/GARCH sigma2
	Te_tarch    tempvar for TARCH thresholded disturbances^2
	Tabse       tempvar for ABARCH variable |e|
	Tz          tempvar for Te / sqrt(Tsigma2)
	Tabsz       tempvar for abs(Tz)
	Ttearch     tempvar for temporary storage of a EARCH component
	Ttearcha    tempvar for temporary storage of an EARCH component
	Ttegarch    tempvar for temporary storage of an EGARCH component
	Ttpgarch    tempvar for temporary storage of an PGARCH component
	Ttarchm     tempvar for temporary storage of an ARCHM score
	Ttarchme    tempvar for temporary storage of an ARCHM expression var
	Tlnsig2     tempvar for ln(sigma^2)
	Tsig_pow    tempvar for sigma^p  -- power arch/garch
	Thasxb      1 ==> there is an B vector for the model mean
	Tmhet       has multiplicative heteroskedasticity terms
	Tarchmex    expression used to modify each arch-in-mean term
	Tsig2_0	    scalar to store priming values for sigma^2
	Tabse_0	    scalar to store priming values for |e|
	Ts2_mayb    holds Tsig2_0 for possible adoption at iteration change
	Tnormadj    holds the E(|u|) adjustment for EARCH terms
	Ttimevar    contains the name of the time variable 
	Ttimemin    the value of time for the first observation in the sample
	Tadjt       T-1 for computing weighted sigma_0^2 and e_0^2
	Tarch0      conditioning for ARCH:  xb0, xb, xbwt, zero, ...
	Tarma0      conditioning for ARCH:  xb0, xb, xbwt, zero, ...
	Tskipobs    number of observations at the beginning of the 
			sample to skip for conditioning
	Ttouse2     sample over which likelihood is actually calculated
			excludes p, q, or p+q startup obs for arma for
			every sample break.
	Tarma0v	   presample value of e(t) to be used in ARMA terms
	TXbeq      name of Xb equation
	
	Tdoarch     "*" if not doing ARCH/GARCH/TARCH/ABARCH/AARCH terms
	Tdoarma     "*" if not doing AR or MA
	Tdotarch    "*" if not doing TARCH
	Tdoarchm    "*" if not doing ARCHM
	Tdarchme    "*" if not doing ARCHM expression
	Tdoearch    "*" if not doing EARCH
	Tdoegrch    "*" if not doing EGARCH
	Tdoeaeg     "*" if doing neither EARCH nor EGARCH
	Tdopgrch    "*" if not doing PGARCH
	Tdopow      "*" if not doing parch, tparch, or pgarch
	Tdopowa     "*" if not doing any power ARCH
	
	TdistN      "*" if not normal errors
	Tdistt      "*" if not Student's t errors
	Ttdf        degrees of freedom if using Student's t errors
	TdistGED    "*" if not generalized error dist. errors
	TGEDdf 	    shape parameter if using GED errors
	Tdfopt	    "*" if using t or GED dist but not optimizing
		        over shape parameter

Notes
-----

e(sample) is the full count of observations, including any that are
        conditioned on, but who did not contribute to the likelihood.  I think
        this is right.

+
-
o  monfort starting values for egarch

arch:    L(1)(arch*e^2)
garch:   L(1)(garch*S^2)
aparch:  L(1)(aparch*(|e| + aparch_e*e)^power)
nparchk: L(1)(nparch*(e - k)^power)
