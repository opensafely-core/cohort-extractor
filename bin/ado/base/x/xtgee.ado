*! version 4.11.2  21oct2019
program define xtgee, eclass byable(onecall) prop(xt xtbs mi)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun xtgee, wtypes(iw fw pw) panel	///
		mark(I T Exposure OFFset) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"xtgee `0'"'
		exit
	}

	version 6.0, missing
	if replay() {
		if _by() { error 190 }
		di
                geerpt `0'
                exit
        }
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	`vv' ///
	capture noisily `by' TSEstimate `0'
	version 10: ereturn local cmdline `"xtgee `0'"'
	mac drop S_X_*
	exit _rc
end

program define TSEstimate, eclass byable(recall)

	version 6.0, missing
	syntax varlist(ts fv) [if] [in] [iw fw pw] [, HASCONS /*
		*/	noCONstant noDISplay I(varname) T(varname) /*
		*/	EForm LEvel(cilevel) /*
		*/	Link(string) Family(string) Corr(string) ASIS *]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11 
	local tsops = "`s(tsops)'" == "true"
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local fvexp expand
	}

	_get_diopts diopts options, `options'
	marksample touse	/* needed here so by: works */

	tokenize `varlist'
	local dep `1'
	_fv_check_depvar `dep'
	mac shift
	local ind `*'
	
	/* Record names, then tsrevar */
	local depname `dep'
	local depstr : subinstr local depname "." "_"
	local indname `ind'
	if `tsops' {
		qui tsset, noquery
		local myi `r(panelvar)'
		local myt `r(timevar)'
		if ("`i'" != "" & "`i'" != "`myi'") | /*
		*/ ("`t'" != "" & "`t'" != "`myt'") {
			version 7: di as error /*
*/ "time and panel variables previously {bf:xtset} -- may not be changed by" /*
*/ _newline "options {bf:t()} and {bf:i()} -- use command {bf:xtset} to change them"
			exit 198
		}
		local i "i(`myi')"
		local t "t(`myt')"			
	}
	else {
		if "`i'" != "" {
			local i "i(`i')"
		}
		if "`t'" != "" {
			local t "t(`t')"
		}
	}

	local options `options' link(`link') family(`family') corr(`corr')
	GetName `"`link'"' `"`family'"' `"`corr'"'
	local is_bin = "$S_2" == "binom"
	if "`asis'" != "" {
		if !`is_bin' {
			version 7: di in smcl as err		///
"{p 0 0 2}"						///
"option {bf:asis} not allowed;{break}"			///
"option {bf:asis} is allowed only with option {bf:family(binomial)} "	///
"with a denominator of 1"				///
"{p_end}"
			exit 198
		}
		local is_bin 0
	}
	if !`fvops' {
		local is_bin 0
	}
	if `is_bin' {
		if "$S_4" != "" {
			capture assert $S_4 == 1 if `touse'
			if c(rc) {
				local is_bin = 0
			}
		}
	}
	if `is_bin' {
		capture assert inrange(`dep', 0, 1) if `touse'
		if c(rc) {
			local is_bin 0
		}
		quietly count if `dep' == 0
		if r(N) == 0 {
			local is_bin 0
		}
	}

	/* Remove collinear vars and issue error message */	
	local inclcon ""
	if "`hascons'`constant'" != "" {
		local inclcon "noconstant"
	}
	if `is_bin' {
		`vv' _rmcoll `dep' `ind' if `touse' [`weight'`exp'] ,	///
			`inclcon' `fvexp' logit touse(`touse') noskipline
		local ind `r(varlist)'
		gettoken dep ind : ind
	}
	else {
		`vv' _rmcoll `ind' if `touse' [`weight'`exp'] ,	///
			`inclcon' `fvexp'
		local ind `r(varlist)'
	}
	local oind : copy local ind
	if `tsops' {
		tsrevar `dep'
		local dep `r(varlist)'
		fvrevar `ind', tsonly
		local ind `r(varlist)'
	}

	/* Fit the model on the tsrevar'ed data */
	`vv' ///
	Estimate `dep' `ind' if `touse' [`weight'`exp'], `hascons' /*
		*/	`constant' `options' depname(`depname') `i' `t'
	
	/* Doctor up stripes on b and V	*/
	tempname b V
	_ms_eq_info
	local haseq = r(k_eq) > 1
	if `haseq' {
		local eq "`depname':"
	}
	mat `b' = e(b)
	mat `V' = e(V)
	local rest : colfu e(b)
	local p : list sizeof oind
	forval i = 1/`p'{
		gettoken x rest : rest
		gettoken x oind : oind
		local STRIPE `STRIPE' `eq'`x'
	}
	if `haseq' {
		local rest : list retok rest
		if "`rest'" == "_cons" {
			local rest `eq'`rest'
		}
	}
	`vv' mat colnames `b' = `STRIPE' `rest'
	`vv' mat colnames `V' = `STRIPE' `rest'
	`vv' mat rownames `V' = `STRIPE' `rest'
	est local depvar "`depname'"
	_ms_op_info `b'
	if r(tsops) {
		quietly tsset, noquery
	}
	est repost b=`b' V=`V' , rename buildfvinfo

	est hidden scalar noconstant= ///
		cond("`constant'" == "noconstant",1,0)
	est hidden scalar consonly = cond("`ind'"!="",0,1)	
	global S_E_depv = "`=trim("`depname'")'"
	global S_E_vl = "`=trim("`depname'")' `indname'"
	
	if "`display'" == "" {
		geerpt , `eform' level(`level') `diopts'
	}
	
	if "`e(rc)'" == "" {
		error `e(rc)'
	}


end

program define Estimate, eclass byable(recall) sort
	version 6.0, missing
	syntax varlist(fv) [if] [in] [iw fw pw] [, /*
		*/ Link(string) Family(string) Corr(string) /*
		*/ I(varname) ITERate(int 100) TOLerance(real 1e-6) NMP RGF/*
		*/ Exposure(varname numeric) OFFset(varname numeric) Robust /*
		*/ HASCONS noCONstant TRace RC0 FROM(string) /*
		*/ EForm FIXed(string) T(varname) Scale(string) /*
		*/ NOLOg LOg noDISplay SCore(string) FORCE /*
		*/ /* undocumented -> */ DEPNAME(string) VCE(passthru) ]

	local fvops = "`s(fvops)'" == "true" | _caller() >= 11 
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local fvexp expand
	}

	// vce(conventional) is the default
	_vce_parse, opt(CONVENTIONAL Robust) old : [`weight'`exp'], `robust' `vce'
	local robust `r(robust)'
	local vce = cond("`r(vce)'" != "", "`r(vce)'", "conventional")

	local iter "`iterate'"
	local iterate

	local tol "`tolerance'"
	local toleran

	GetName `"`link'"' `"`family'"' `"`corr'"'
	local link = "$S_1"				/* OK to use S_ here */
	local family  = "$S_2"				/* OK to use S_ here */
	local corr = "$S_3"				/* OK to use S_ here */
	local oarg = "$S_4"				/* OK to use S_ here */
	local band "$S_5"	/* default -1 */	/* OK to use S_ here */
	local fixed "$S_6"				/* OK to use S_ here */
	tempname canon
	scalar `canon' = 0	
	if ("`family'" == "gauss" & "`link'" == "ident") {
		scalar `canon' = 1
	}
	else if ("`family'"=="igauss" & ///
		("`link'"=="power" & "$S_X_pow"=="-2")) {
		scalar `canon' = 1
	}
	else if ("`family'" == "poiss" & "`link'" == "log") {
		scalar `canon' = 1
	}
	else if ("`family'" == "nbinom" & "`link'" == "nbinom") {
		scalar `canon' = 1
	}
	else if ("`family'" == "binom" & "`link'" == "logit") {
		scalar `canon' = 1
	}
	else if ("`family'" == "gamma" & ///
		(("`link'" == "power" & "$S_X_pow" == "-1") | ///
		  "`link'" == "recip")) {
		scalar `canon' = 1
	}

	if "`nmp'"=="" {
		local nmp 0
	}
	else {
		local nmp 1
	}

	if "`rgf'" != "" {
		if "`weight'" != "pweight" & "`robust'" =="" {
			version 7: noi di in red "option {bf:rgf} may only be specified with "/*
				*/ "option {bf:vce(robust)}"
			error 198
		}
		if "$S_2" != "gauss" {
			version 7: noi di in red "option {bf:rgf} may only be specified with "/*
				*/ "option {bf:family(gaussian)}"
			error 198
		}
	}
	if "`constan'" != "" {
		local cons "nocons"
		local nocons "nocons"
	}
	checkfam "`family'" "`link'"

        if "`corr'"=="statm" | "`corr'"=="nonst" | "`corr'"=="arm" /*
		*/ | "`corr'"=="unstr" | "`corr'"=="fixed" {
		_xt, i(`i') t(`t') trequired
		local tvar  "`r(tvar)'"
	}
	else {
		_xt, i(`i')
	}
	local rivar "`r(ivar)'"

	global S_X_scp = "`scale'"

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" == "" {
		local prel "noi di "
		global S_LOG 1
	}
	else {
		local prel "*"
	}

	if "`score'" != "" {
		local n : word count `score'
		if `n'!=1 {
			version 7: di as err "option {bf:score()} requires specification of one " /*
			*/ "new variable"
			exit 198
		}
		confirm new var `score'
	}


	ChkSyn `tol' `iter' "`hascons'" "`cons'"

	tempvar mui recid bb binom

	if "`exposur'"!="" {
		if "`offset'"!="" {
version 7: di in red "options {bf:exposure()} and {bf:offset()} may not be specified together"
			exit 198
		}
		local offstr "ln(`exposur')"
		tempvar offset
		qui gen double `offset' = ln(`exposur')
	}

	if "`offset'" != "" {
		local addoff "replace `mui' = `mui' + `offset'"
		local glmarg "off(`offset')"
		if "`offstr'"=="" {
			local offstr "`offset'"
		}
	}

	if "`oarg'"!="" & "`family'" != "binom" & "`family'" != "nbinom" {
		version 7: noi di in red /*
            */ "option {bf:family(`family')} does not allow a parameter"
                exit 198
	}

	marksample touse
	tokenize `varlist'
	if "`oarg'"!="" {
		cap confirm number `oarg'
		if _rc {
			if "`family'" == "binom" {
	                	capture confirm variable `oarg'
                        	if _rc {
					version 7: noi di in red /*
					*/ "option {bf:family(binomial)} requires a " /*
					*/ "positive number or variable name"
        	                        exit 198
				}
				markout `touse' `offset' `rivar' `tvar' `oarg'
				capture assert `oarg' > 0 if `touse'
				if _rc {
					version 7: di as err /*
					*/ `"variable {bf:`oarg'} has nonpositive values"'
					exit 499
				}
                        	unabbrev `oarg', max(1)
	                        local oarg "`s(varlist)'"
				qui gen `binom' = `oarg'
        	        }
		}
	        else {
			if `oarg'<=0 {
				version 7: noi di in red /*
				*/ "option {bf:family(binomial)} requires a " /*
				*/ "positive number or variable name"
                        	exit 198
			}
			qui gen `binom' = `oarg'
			markout `touse' `offset' `rivar' `tvar' `binom'
                }
        }
	else {
		qui gen byte `binom' = 1
		markout `touse' `offset' `rivar' `tvar' `binom'
		if "`family'" == "binom" {
			cap assert `1'== 1 | `1' == 0 if `touse'
			if _rc { local oarg=1 }
		}
	}
	if "`family'" == "binom" {	
		capture assert `1'<= `binom' if `touse'
		if _rc {
			if "`oarg'"=="" {
				version 7: di as err /*
				*/ `"variable {bf:`1'} > 1 in some cases"'
				exit 499
			}
			else {
				version 7: di as err /*
				*/ `"variable {bf:`1'} > {bf:`oarg'} in some cases"'
				exit 499
			}
		}
	}
	qui count if `touse'
	if r(N) <= 1 {
		di in red "insufficient observations"
		exit 2001
	}

	if "`score'"!= "" {
		tempvar merge
		qui gen `merge' = _n
	}

	qui { 
		if "`tvar'"!="" {
			tempvar tord
			sort `tvar'
			by `tvar' : gen `tord' = 1 if _n==1
			replace `tord' = sum(`tord')
		}

		sort `touse' `rivar' `tvar'

		if "`tvar'"!="" {
			if "`corr'"=="unstr" | "`corr'"=="fixed" {
				local abst "`tord'"
				local topt "t(`tord')"
			}
			else {
				noi KeepMode `rivar' "`tvar'" "`force'" /* 
				 */ `touse'
				noi KeepMin "`corr'" `rivar' `band' `touse'
				local band `r(band)'
				if "`corr'"=="nonst" {
					local abst "`tord'"
					local topt "t(`tord')"
				}
			}
			noi Checkt `rivar' `tord' `tvar' `touse'
		}
		preserve
		keep if `touse'
		sort `rivar' `tvar'
					/* Observation sample fixed */
		noi BigEnuf `rivar' `abst'
		local minni `r(min)'
		global S_X_maxn `r(xmax)'
		local avgni `r(mean)'
		local maxni $S_X_maxn
		local rmaxni `r(max)'
		local nclust `r(N)'
		local keep   `r(N)'

		if "`corr'" == "fixed" {
			local g = rowsof(`fixed')
			if `maxni' != `g' {
				noi di in red /*
			*/ "correlation matrix must be `maxni'x`maxni'"
				exit 198
			}
		}
		if `nclust' == 1 & "`robust'" != "" {
			version 7: noi di in red /*
				*/ "cannot specify option {bf:vce(robust)} with only one panel"
			exit 198
		}

		tempname sumw
		if "`weight'" != "" {

			if "`weight'" == "pweight" {
				local robust "robust"
			}

/* comment A */
			* Generate weights
			tempvar ww
			gen double `ww' `exp'

			* Scale weights if not iweight
/* comment B */
			summ `ww', mean
			if "`weight'" == "aweight" & 0 {
				replace `ww' = `ww'/r(mean)
				scalar `sumw' = _N
			}
			else {
				scalar `sumw' = r(sum)
			}

			* Get avg panel size and number of groups
			noi ChkWt `rivar' `ww'
			if "`weight'" != "aweight" {
				local avgni  `r(mean)'
				local nclust `r(sum)'
			}

			local wtex  "[`weight'=`ww']"
			/* weights for initial estimates	*/
			if "`weight'" == "pweight" {
				local iwtex "[iweight=`ww']"
			}
			else {
				local iwtex `wtex'
			}
		}
		else {
			tempvar ww
			gen byte `ww' = 1
			scalar `sumw' = _N
		}
		local warg "wvar(`ww')"

		unopvarlist `varlist'
		keep `r(varlist)' `rivar' `tvar' `offset' `merge' /*
			*/ `ww' `tord' `binom'

		if "`tvar'"=="" {
			local ivar "`rivar'"
		}
		else {
			tempvar ivar
			xtgee_makeivar `rivar' `tvar' `tord' `maxni' -> `ivar'
			sort `ivar' `tvar'
		}

		tempvar obs
		gen `c(obs_t)' `obs' = _n
		local nobs = _N

		tokenize `varlist'
		global S_X_depv "`1'"
		mac shift
		global S_X_idep "`*'"

		if $S_X_con == 0 {
			local hascons 1
			if "`eform'" == "" {
				`vv' _rmcoll $S_X_idep `wtex', ///
					nocons `fvexp'
			}
			else    `vv' _rmcoll $S_X_idep `wtex', `fvexp'
			global S_X_idep "`r(varlist)'"
			local idep1 "`r(varlist)'"
			`vv' _rmcoll $S_X_idep, `fvexp'
			local idep2 "`r(varlist)'"
			local has : list idep1 - idep2
			if "`has'" == "" & "`constant'"=="" {
				noi di as txt "(note: hascons false)"
			}
			local idep2 : list idep1 - has
			global S_X_HAS "`idep2'"
		}
		else {
			`vv' _rmcoll $S_X_idep `wtex', `fvexp'
			global S_X_idep "`r(varlist)'"
			global S_X_HAS "`r(varlist)'"
		}
		noi di

		local p : word count $S_X_idep
		local p = `p' + $S_X_con
		if `p' <= 0 {
			error 102
		}
		if `p' >= _N {
			di in red "insufficient observations"
			exit 2001
		}

		if `sumw' < `p' {
			noi di in red /*
			*/ "sum of weights must be larger than P, the number of coefficients estimated"
			exit 198
		}

		global S_X_link "`link'"
		global S_X_mvar "`family'"
		global S_X_corr "`corr'"
		global S_X_ivar "`ivar'"

		sort `ivar' `tvar' `obs'

		* the following may not be necessary
		if `band' < 0 {
			local band = `minni'-1
		}

		if "`corr'" == "fixed" {
			local R "`fixed'"
		}
		else {
			tempname R
			mat `R' = J(`maxni',`maxni',0)
		}

		tempname b0 b1 phi alpha S1 S2 zi

		if "`family'" == "binom" {
			local xarg "`binom'"
		}

		if "`from'" == "" {
			`vv' ///
			GetIval "`hascons'" "`nocons'" "`iwtex'" /*
				*/ "`xarg'" "`oarg'" -> `b1' "`glmarg'"
		}
		else {
			local names $S_X_idep
			if $S_X_con {
				local names `names' _cons
			}
			`vv' ///
			noi _mkvec `b1', from(`from') colnames(`names') /*
				*/ error("from()")
		}
		local sna : colnames(`b1')

		local XXn : word count `sna'
		if `XXn' != `p' {
			noi di in red "Unable to identify sample"
			exit 198
		}
		_ms_omit_info `b1'
		local p = `p' - r(k_omit)

		local iterate 1
		local diff 1000

                if "`trace'" != "" {
                        local aanames ""
                        local i 0
                        while `i' <= `band' {
                                local aanames `aanames' `i'
                                local i = `i'+1
                        }
                }

		tempvar ei t cc lagw

		sort `ivar' `tvar' `obs'
		while `iterate' <= `iter' & `diff' > `tol' {
			local areset = 0	// for corr(exch) alpha
			mat `b0' = `b1'
			scalar `phi' = 0.0

			* switch(link) page 4

			cap drop `mui'
			mat score double `mui' = `b1'
			`addoff' /* replace `mui' = `mui' + `offset' */
			xtgee_plink "`link'" `mui' `binom'

			* switch (var_mean_rel) page 4

			cap drop `ei'
			gen double `ei' = $S_X_depv - `mui'
			xtgee_elink "`family'" `mui' `ei' `binom'

			cap drop `cc'

			gen double `cc' = `ww'*`ei'*`ei'
			cap drop `t'

/* Use Liang Zeger 1986 moment estimators instead of Karim estimators */
			summ `cc'
			if r(N) != `nobs' {
				noi di in red "estimates diverging " /*
					*/ "(missing predictions)"
				exit 430
			}

/* N-p changed to N */
			scalar `phi' = (`sumw'-`nmp'*`p') / r(sum)

			by $S_X_ivar : gen `t' = /*
				*/ .5*`ww'[_N]*_N*(_N-1) if _n==_N
			summ `t'
			tempname cF
/* N-p changed to N */
			scalar `cF' = r(sum) - `nmp'*`p'

			cap drop `lagw'
			local bw1 = `band'+1
			by $S_X_ivar : gen double `lagw' = _N/(_N-_n+1) /*
			*/ if _n <= `bw1'

			_GEEUC `ei' `ww', a(`alpha') ty(`corr') n(`maxni') /*				*/ b(`band') l(`lagw') `topt' by($S_X_ivar) /*
				*/ fixsing

			if "`trace'" != "" {
                                tempname traa aa
                                mat `traa' = `b1'`addme'
                                mat coleq `traa' = beta
                        }

			if "`corr'" == "exchan" {
				scalar `alpha' = `alpha'*`phi'/`cF'

                                if "`trace'" != "" {
                                        local aaa = `alpha'
                                        mat `aa'  = (`aaa')
                                        mat colnames `aa' = alpha
                                        mat `traa' = `traa',`aa'
                                }
/* comment C
				if ((`alpha'<-1) | (`alpha'>1)) {
					noi di in red "estimates diverging " /*
					*/ "(absolute correlation > 1)"
					exit 430

				}
*/
				if (`alpha' > 1) {
					noi di in red "estimates diverging " /*
					*/ "(correlation > 1)"
					exit 430
				}
				else if (`alpha' < (-1/(`maxni'-1))) {
					local areset = 1
					sca `alpha' = 0.99*(-1/(`maxni'-1))
noi di in gr "(resetting alpha to " %6.4f 0.99*(-1/(`maxni'-1)) ")"
				}
			}
			else if "`corr'" != "fixed" & "`corr'" != "indep" {
				if "`corr'"=="statm" | "`corr'"=="arm" {
					local kk = colsof(`alpha')
					tempname ttt
					local i 1

/*                        noi mat list `alpha'
			noi di in red `phi' */

					while `i' <= `kk' {
						scalar `ttt' = `phi' / /*
					*/ (`sumw'+`nclust'-`nclust'*`i'-/*
							*/ `nmp'*`p') /*
						p out with nmp option
							*/
						if `alpha'[1,`i'] != 0 {
						mat `alpha'[1,`i'] = /*
					*/ `alpha'[1,`i'] * `ttt'
						}
						local i = `i'+1
					}

/*                        noi mat list `alpha'
			noi di in red `ttt' */
                                        if "`trace'" != "" {
                                                mat `aa' = `alpha'[1,1..`bw1']
                                                mat colnames `aa' = `aanames'
                                                mat coleq `aa' = alpha
                                                mat `traa' = `traa',`aa'
                                        }
				}
				else if "`corr'" == "nonst" {
					tempname ttt
					scalar `ttt' = `phi' / (`nclust')
					mat `alpha' = `ttt' * `alpha'
				}
				else {
					/* unstructured */
					tempname ttt
					scalar `ttt' = `phi' / (`nclust')
					mat `alpha' = `ttt' * `alpha'
				}
			}

                        if "`trace'" != "" {
                                mat rownames `traa' = " "
                                noi mat list `traa', noheader
                        }

			* switch (corstruct) page 6

			if "`corr'" == "arm" {
				rarm `R' `maxni' `alpha' `bw1'
			}
			else _GEERC , c(`corr') r(`R') n(`maxni') /*
			*/ a(`alpha') b(`bw1')

			* Bottom of page 6

			cap drop `mui'
			mat score double `mui' = `b1'
			`addoff' /* replace `mui' = `mui' + `offset' */

			_GEEBT $S_X_idep, mui(`mui') N(`binom') by(`ivar') /*
			*/ `warg' xy(`S1') xx(`S2') R(`R') /*
			*/ b1(`b1') depv($S_X_depv) n(`maxni') `topt'

			* get S1 and S2 page 8
			mat `b1' = syminv(`S2')
			mat `b1' = `b1'*`S1'
			mat `b1' = `b1''

			`vv' mat colnames `b1' = `sna'

			* now get max diff between oldbeta and newbeta
			local diff = mreldif(`b1', `b0')
			`prel' in gr "Iteration " `iterate' /*
			*/ ": tolerance = " in ye `diff'
			local iterate = `iterate'+1
		}
		if (`iterate'>`iter' & `diff'>`tol')  | `areset' == 1 {
			local finalrc 430
		}
		else {
			local finalrc 0
		}

		* Page 9 loop
		cap drop `zi'

		scalar `phi' = 0.0
		cap drop `mui'
		mat score double `mui' = `b1'
		`addoff' /* replace `mui' = `mui' + `offset' */

		if "`score'" != "" {
			qui gen double `score' = .
			local sarg "score(`score')"
		}

		/* Get final variance estimates */

		if "`weight'" == "fweight" {
			local fwt "fwt"
		}
		_GEEBT $S_X_idep, mui(`mui') N(`binom') by(`ivar') /*
		*/ `warg' phi(`phi') `sarg' `robust' xy(`S1') xx(`S2') /*
		*/ R(`R') b1(`b1') depv($S_X_depv) n(`maxni') `topt' `fwt'

		scalar `phi' = `avgni'*`phi' / (`sumw' -`nmp'*`p') /*  N-p */

		global S_E_dof = `sumw'-`nmp'*`p' /* N-p */
		local mydof $S_E_dof
		global S_E_scp "$S_X_scp"

		local wtex  "[aweight=`ww']"
		FixScale $S_X_depv `mui' `binom' "`wtex'"
		if "$S_X_fix" != "" {
			scalar `phi' = $S_1
		}

		mat `S2' = syminv(`S2')

		tempname nse rse

		mat `nse' = `phi'*`S2'
		mat `rse' = `S2'*`S1'
		mat `rse' = `rse'*`S2'
		mat drop `S1'
		mat drop `S2'
	}
	`vv' mat colnames `nse' = `sna'
	`vv' mat rownames `nse' = `sna'
	`vv' mat colnames `rse' = `sna'
	`vv' mat rownames `rse' = `sna'

	if "`weight'" == "fweight" {
		local nobs = `sumw'
	}
	else if "`weight'" == "aweight" {
		local nclust `keep'
	}

	if "`robust'" != "" & "`weight'" !="fweight" {
		local nclust `keep'
	}

	global S_X_9 = "$S_E_dis"
	global S_X_A = "$S_E_scp"
	if "`robust'" != "" {
		local df = `nclust'-1
		local factor = (`nclust')/(`df')
		/* The usual adjustment for regression includes this as well*/
		/* Making this adjustment prevents Robust Var. estimate from
		   being invariant to scale of weights. Only make it when
		   asked via RGF option */
		if "`rgf'" != "" {
 			if "`family'"=="gauss" {
 				local factor =`factor'*(`sumw'-1)/(`sumw'-`p')
 			}
		}
		mat `rse' = `rse' * `factor'
		mat `rse' = (`rse' + `rse'')/2
		est post `b1' `rse', depname(`depname') obs(`nobs')
		est matrix V_modelbased `nse'
		if `canon' == 0 {
			global S_X_vce "Semirobust"
		}
		else {
			global S_X_vce "Robust"		
		}	
	}
	else {
		est post `b1' `nse', depname(`depname') obs(`nobs')
	}

	if "`corr'" == "arm" {
		rarm `R' `maxni' `alpha' `bw1'
	}
	else _GEERC , c(`corr') r(`R') n(`maxni') a(`alpha') b(`bw1')
	if _caller() < 6 {
		mat S_E_R = `R'
	}
	// _GEERC stores `R' such that it is guaranteed symmetric
	tempname eigvec eigval
	mat symeigen `eigvec' `eigval' = `R'
	forvalues i = 1/`maxni' {
		if `eigval'[1,`i'] < 0 {
			local finalrc `=cond(`finalrc' > 0, `finalrc', 430)'
			est scalar nonpdcorr = 1	// undocumented
			continue, break
		}
	}
	version 10: ereturn matrix R `R', copy
	if `areset' == 1 {
		est scalar alphareset = 1		// undocumented
	}

	_prefix_model_test xtgee
	
	// take care of hascons option	
	if "`hascons'" != "" {
		if "$S_X_HAS" == "" {
			est scalar chi2 = .
			est scalar df_m = 0
		}
		else {
			qui test $S_X_HAS
			est scalar chi2 = r(chi2)
			est scalar df_m = r(df)
		}
	}
		
	global S_E_chi2 = e(chi2)	/* double saves */
	global S_E_chdf = e(df_m)	/* double saves */
	global S_E_prob = chiprob(e(df_m),e(chi2))	/* double saves */

	if "$S_LOG" != "" & "`display'" == "" {
		noi di
	}

	/* Save results */

	SaveMac `mydof' `nobs' `nclust' `rmaxni' `minni' `avgni' `tol' `diff' /*
		*/ `phi' `family' `link' `corr' "`tvar'" "`band'" "`level'" /*
		*/ "`vce'"
	est local model "pa"
	est local ivar "`rivar'"
	if "`nmp'" == "1" {
		est local nmp "nmp"
	}
	est local rgf "`rgf'"
	global S_E_ivar "`rivar'"  /* double saves */
	fixwords
	if "`robust'" != "" {
		global S_E_cvn "`rivar'"
	}

	est local offset "`offstr'"
	est local denom "`oarg'"

	if "`weight'" != "" {
		est local wtype "`weight'"
		est local wexp "`exp'"
	}

	est local estat_cmd "xtgee_estat"
	est local predict "xtgee_p"
	est local marginsnotok SCore STDP
	est hidden local marginsprop nolinearize
	est hidden local robust_prolog "xtgee_robust_prolog"
	est hidden local robust_epilog "xtgee_robust_epilog"
	est local cmd "xtgee"
	global S_E_cmd "`e(cmd)'"		/* double saves */

	global S_LOG

	if "`score'" != "" {
		qui replace `score' = `score'/sqrt(`phi')
		keep `merge' `score'
		sort `merge'
		tempfile tmpf
		qui save `"`tmpf'"'
		restore
		cap confirm variable _merge
		if _rc==0 {
			tempvar _merge1
			rename _merge `_merge1'
		}
		sort `merge'
		cap merge `merge' using `"`tmpf'"'
		if _rc {
			if _rc==1 { exit 1 }
			version 7: noi di in red "Unable to generate score {bf:`score'}"
			exit 198
		}
		drop _merge
		cap rename `_merge1' _merge
		est local scorevars `score'
	}
	else {
		restore
	}
	est hidden scalar canonical = `canon'
	est scalar rc = `finalrc'
	mat repost, esample(`touse')
	_post_vce_rank

end

program define geerpt
	global S_X_maxn
	global S_X_corr
	global S_X_mvar
	global S_X_link
	global S_X_idep
	global S_X_depv
	global S_X_con
	global S_X_9
	syntax [, LEvel(cilevel) EForm *]

	_get_diopts diopts, `options'
	if `"`e(cmd)'"'!="xtgee" { error 301 }

	global S_E_ef
	if "`eform'" != "" {
		if bsubstr("`e(family)'",1,3) == "neg" {
			local eform "eform(IRR)"
		}
		else if "`e(family)'"=="Poisson" & "`e(link)'" != "probit" & /*
		*/ "`e(link)'" != "logit" {
			local eform "eform(IRR)"
		}
		else if "`e(link)'" == "probit" & "`e(family)'" != "Poisson" {
			local eform "eform(exp(b))"
		}
		else if "`e(link)'" == "logit" & "`e(family)'" != "Poisson" {
			local eform "eform(Odds Ratio)"
		}
		else if "`e(link)'" == "opower" {
			local eform "eform(Odds Ratio)"
		}
		else {
			local eform "eform(exp(b))"
		}
		global S_E_ef "`eform'"		/* double save */
	}

	local q "_col(67)"
	local l = 71 + 8 - length("`e(ivar)'")
	noi di in green "GEE population-averaged model"  /*
	*/ in gr _col(49) "Number of obs" `q' "=" in ye _col(69) %10.0fc e(N)

	local ivar = abbrev("`e(ivar)'", 12)
	if "`e(tvar)'"!="" {
		local tvar = abbrev("`e(tvar)'", 12)
		local skip = max(43-length("`ivar' `tvar'"),1)

		di in gr "Group and time vars:" in ye _col(`skip') /*
		*/ "`ivar' `tvar'" /*
		*/ in gr _col(49) "Number of groups" `q' "=" /*
		*/ in ye _col(69) %10.0fc e(N_g)
	}
	else {
		local skip = max(43-length("`ivar'"),1)
		di in gr "Group variable:" in ye _col(`skip')  /*
		*/ "`ivar'" /*
		*/ in gr _col(49) "Number of groups" `q' "=" /*
		*/ in ye _col(69) %10.0fc e(N_g)
	}

	local skip = max(43 - length("`e(link)'"),1)
	noi di in green "Link:" in ye _col(`skip') "`e(link)'" /*
	*/ in gr _col(49) "Obs per group:"

	local skip = max(43 - length("`e(family)'"),1)
	noi di in green "Family:" in ye _col(`skip') "`e(family)'" /*
	*/ in gr _col(63) "min" `q' "=" in ye _col(69) /*
	*/ %10.0f e(g_min)

	local skip = max(43 - length("`e(corr)'"),1)
	noi di in green "Correlation:" in ye _col(`skip') /*
	*/ "`e(corr)'" in gr _col(63) "avg" `q' "=" /*
	*/ in ye _col(69) %10.1fc e(g_avg)

	noi di in gr _col(63) "max" `q' "=" /*
	*/ in ye _col(69) %10.0fc e(g_max)

	if e(chi2)>999999 {
		local cfmt "%9.0g"
	}
	else	local cfmt "%9.2f"

	if !missing(e(df_r)) {
		local model as txt _col(49) "F(" ///
			as res %4.0f e(df_m) as txt "," ///
			as res %7.0f e(df_r) as txt ")" ///
			`q' "=" _col(70) as res %9.2f abs(e(F))
		local pvalue _col(49) as txt "Prob > F" `q' "=" ///
			as res _col(73) %6.4f Ftail(e(df_m),e(df_r),e(F))
	}
	else {
		if !missing(e(chi2)) {
			local model as txt _col(49) "Wald chi2(" ///
				as res e(df_m) as txt ")" ///
				`q' "=" _col(70) as res `cfmt' e(chi2)
			local pvalue _col(49) as txt "Prob > chi2" `q' "=" ///
				as res _col(73) %6.4f ///
				chiprob(e(df_m),abs(e(chi2)))
		}
		else {
			local model as txt _col(49) in smcl ///
	"{help j_robustsingular##|_new:`e(chi2type)' chi2(`e(df_m)')}" ///
                                `q' "=" _col(70) as res `cfmt' e(chi2)
                        local pvalue _col(49) as txt "Prob > chi2" `q' "=" ///
                                as res _col(73) %6.4f ///
                                chiprob(e(df_m),abs(e(chi2)))
	}

	noi di `model'
	noi di in green /*
	*/ "Scale parameter: "  _col(34) in ye %9.0g e(phi) `pvalue'

	if "`e(deviance)'" != "" & "`e(corr)'" == "independent" {
		if e(deviance)>999999 {
			local cfmt "%10.0g"
		}
		else	local cfmt "%10.2f"
		noi di in gr _n "Pearson chi2(" in ye e(df_pear) in gr "):" /*
		*/ in ye _col(33) `cfmt' e(chi2_dev) /*
		*/ in gr _col(49) "Deviance" `q' "=" in ye _col(69) /*
		*/ `cfmt' e(deviance)

		noi di in gr "Dispersion (Pearson):" in ye _col(34) /*
		*/ %9.0g e(chi2_dis) /*
		*/ in gr _col(49) "Dispersion" `q' "=" in ye _col(70) /*
		*/ %9.0g e(dispers)
	}

	di
	_coef_table, level(`level') `eform' `diopts'
	if "`e(disp)'" == "`e(phi)'" {
		cap confirm number `e(scale)'
		local j = _rc
		if "`e(scale)'" == "dev" {
			local mm "deviance based dispersion"
		}
		else if "`e(scale)'" == "x2" {
			local mm "Pearson X2-based dispersion"
		}
		else {
			local mm "`e(scale)'"
		}
		if /*
*/ (("`e(family)'"=="Gaussian" | "`e(family)'"=="gamma") & /*
*/ "`e(scale)'"!="x2") | /*
*/ (("`e(family)'"=="Poisson" | "`e(family)'"=="binomial") & /*
*/ "`e(scale)'"!="1") {
			noi di in gr  /*
			*/ "(Standard errors scaled using square root of `mm')"
		}
	}
	_prefix_footnote
	if e(rc) & !missing(e(rc)) {
		if e(alphareset) & !missing(e(alphareset)) {
			di in smcl 	/*
*/ `"{helpb j_exchangeable:exchangeable working correlation matrix not positive definite}"'
		}
		else if e(nonpdcorr) & !missing(e(nonpdcorr)) {
			di in smcl	/*
*/ `"{helpb j_geenonpd:working correlation matrix not positive definite}"'
		}
		error e(rc)
	}
end

program define rarm
	args R n a b

	mat `a'[1,1] = 1
	tempname tmp wt al
	local b2 = `b'-1
	mat `tmp' = J(1,`n',0)
	local i 1
	while `i' <= `n' {
		mat `tmp'[1,`i'] = `a'[1,`i']
		local i = `i'+1
	}
	mat `wt' = J(`b2',`b2',0)
	local i 1
	while `i' <= `b2' {
		local j = `i'
		while `j' <= `b2' {
			local k = `j'-`i'+1
			mat `wt'[`j',`i'] = `tmp'[1,`k']
			mat `wt'[`i',`j'] = `tmp'[1,`k']
			local j = `j'+1
		}
		local i = `i'+1
	}

	mat `wt' = syminv(`wt')
	mat `al' = J(1,`b2',0)
	local i 1
	while `i' <= `b2' {
		local j = `i'+1
		mat `al'[1,`i'] = `a'[1,`j']
		local i = `i'+1
	}
	mat `al' = `al'*`wt'
	mat drop `wt'

	tempname scnm
	local i = `b'
	while `i' <= `n' {
		scalar `scnm' = 0
		local j 1
		while `j' <= `b2' {
			local k = `i'-`j'
			scalar `scnm' = `scnm' + `al'[1,`j']*`tmp'[1,`k']
			local j = `j'+1
		}
		mat `tmp'[1,`i'] = `scnm'
		local i = `i'+1
	}
	_GEERC , c(arm) r(`R') n(`n') a(`tmp') b(`b')
end


program define checkcm
	args cmat

	cap local nrow = rowsof(`cmat')
	if _rc {
		version 7: noi di in red "{bf:`cmat'} not a matrix"
		exit 198
	}

	local ncol = colsof(`cmat')

	if `ncol' != `nrow' {
		noi di in red "correlation matrix not square"
		exit 198
	}

	local i 1
	while `i' < `nrow' {
		if `cmat'[`i',`i'] != 1.0 {
			version 7: noi di in red "matrix {bf:`cmat'} not a correlation matrix"
			exit 198
		}
		local j = `i' + 1
		while `j' <= `nrow' {
			if `cmat'[`i',`j'] != `cmat'[`j',`i'] {
				version 7: noi di in red "matrix {bf:`cmat'} not symmetric"
				exit 198
			}
			if `cmat'[`i',`j'] > 1 | `cmat'[`i',`j'] < -1 {
				version 7: noi di in red "matrix {bf:`cmat'} not a correlation matrix"
				exit 198
			}
			local j = `j'+1
		}
		local i = `i'+1
	}
	if `cmat'[`i',`i'] != 1.0 {
		version 7: noi di in red "matrix {bf:`cmat'} not a correlation matrix"
		exit 198
	}
end


program define checkfam /* family link */
	args family link

	local flag 0

	if "`link'" == "power" {
		local flag 0
	}

	else if "`family'"=="binom" {
		if "`link'"=="nbinom" {
			local flag 1
		}
	}
	else if "`family'"=="gauss" {
		if "`link'"!="ident" & "`link'"!="log"  & "`link'"!="recip" {
			local flag 1
		}
	}

	else if "`family'"=="poiss" {
		if "`link'"!="ident"&"`link'"!="log" & "`link'"!="recip" {
			local flag 1
		}
	}

	else if "`family'" == "gamma" {
		if "`link'"!="ident" & "`link'"!="log" & "`link'" != "recip" {
			local flag 1
		}
	}

	else if "`family'" == "nbinom" {
		if "`link'"!="ident" & "`link'"!="log" & "`link'"!="nbinom"{
			local flag 1
		}
	}

	else if "`family'" == "igauss" {
		if "`link'"!="ident" & "`link'"!="log" {
			local flag 1
		}
	}

	if `flag' == 1 {
		noi di in red "unsupported family-link combination"
		exit 198
	}
end

program define GetName
	args link fam corr

	global S_1	/* link		*/
	global S_2	/* family	*/
	global S_3	/* corr		*/
	global S_4	/* family arg	*/
	global S_5 -1	/* corr lag	*/
	global S_6	/* corr mat	*/

	local l = length("`link'")
	local f = lower(trim("`link'"))
	local f : word 1 of `f'
	local l = length("`f'")

	if "`f'" == bsubstr("identity",1,max(`l',1))     { global S_1 "ident" }
	else if "`f'" == bsubstr("log",1,max(`l',3))     { global S_1 "log"   }
	else if "`f'" == bsubstr("logit",1,max(`l',4))   { global S_1 "logit" }
	else if "`f'" == bsubstr("power",1,max(`l',3))   { global S_1 "power" }
	else if "`f'" == bsubstr("opower",1,max(`l',3))  { global S_1 "opower" }
	else if "`f'" == bsubstr("cloglog",1,max(`l',2)) { global S_1 "cloglog" }
	else if "`f'" == bsubstr("probit",1,max(`l',1))  { global S_1 "probit"}
	else if "`f'" == bsubstr("nbinomial",1,max(`l',2)){ global S_1 "nbinom"}
	else if "`f'"==bsubstr("reciprocal",1,max(`l',3)){ global S_1 "recip" }
	else if "`f'" != "" {
		version 7: noi di in red "unknown link {bf:`link'} in option {bf:link()}"
		exit 198
	}

	global S_X_pow
	if "$S_1" == "power" | "$S_1" == "opower" {
		tokenize `link'
		global S_X_pow "`2'"
		if "$S_X_pow" == "" { global S_X_pow 1 }
		capture confirm number $S_X_pow
		if _rc {
			version 7: noi di in red "{bf:$S_1} link requires numeric argument"
			exit 198
		}
	}

	local l = length("`fam'")
	local f = lower(trim("`fam'"))
	local f : word 1 of `f'
	local l = length("`f'")

	if "`f'" == bsubstr("gaussian",1,max(`l',3))      { global S_2 "gauss" }
	else if "`f'" == bsubstr("normal",1,max(`l',3))   { global S_2 "gauss" }
	else if "`f'" == bsubstr("igaussian",1,max(`l',2)){ global S_2 "igauss"}
	else if "`f'" == bsubstr("poisson",1,max(`l',1))  { global S_2 "poiss" }
	else if "`f'" == bsubstr("nbinomial",1,max(`l',2)){ global S_2 "nbinom"}
	else if "`f'" == bsubstr("binomial",1,max(`l',1)) { global S_2 "binom" }
	else if "`f'" == bsubstr("gamma",1,max(`l',3))    { global S_2 "gamma" }
	else if "`f'" != "" {
		version 7: noi di in red "unknown family {bf:`fam'} in option {bd:family()}"
		exit 198
	}
	
	tokenize `fam'
	global S_4 "`2'"
	global S_X_nba
	if "$S_2" == "nbinom" {
		if "$S_4" == "" { global S_4 1 }
		capture confirm number $S_4
		if _rc{  
			version 7: noi di in red /*
			*/ "option {bf:family(nbinomial} {it:#}{bf:)} requires {it:#} to be positive"
			exit 198
		}
		else if $S_4 <=0 {
			version 7: noi di in red /*
			*/ "option {bf:family(nbinomial} {it:#}{bf:)} requires {it:#} to be positive"
			exit 198
		}
		global S_X_nba = 1/$S_4
		global S_4
	}

	GetCorr "`corr'" /* sets S_3, S_5, S_6 */

	if "$S_3" == "" {
		global S_3 "exchan"
	}

	if "$S_2" == "" {
		global S_2 "gauss"
	}

	if "$S_1" == "" {
		if "$S_2" == "gauss"  { global S_1 "ident" }
		if "$S_2" == "poiss"  { global S_1 "log"   }
		if "$S_2" == "binom"  { global S_1 "logit" }
		if "$S_2" == "gamma"  { global S_1 "recip" }
		if "$S_2" == "igauss" {
			global S_1 "power"
			global S_X_pow = -2
		}
		if "$S_2" == "nbinom" { global S_1 "log"   }
	}

end

program define GetCorr /* correlation <#> */
/*
	We parse
		<correlation>
		<correlation>[ ]#
		<correlation> <matname>
*/
	ReTok `*'
	local f = lower(trim("$S_3"))
	local l = length("`f'")
	local rest "$S_5"

	global S_3	/* corr */
	global S_5 -1	/* lag */
	global S_6	/* matname */

	if "`f'"=="" { exit }

	if "`f'" == bsubstr("independent",1,max(`l',3))	     {
		global S_3 "indep"
		NoLag `f' `rest'
	}
	else if "`f'" == bsubstr("arm",1,max(`l',2))   {
		global S_3 "arm"
		SetLag `f' `rest'
	}
	else if "`f'" == bsubstr("exchangeable",1,max(`l',3))   {
		global S_3 "exchan"
		NoLag `f' `rest'
	}
	else if "`f'" == bsubstr("statm",1,max(`l',3))   {
		global S_3 "statm"
		SetLag `f' `rest'
	}
	else if "`f'" == bsubstr("stationary",1,max(`l',3))   {
		global S_3 "statm"
		SetLag `f' `rest'
	}
	else if "`f'" == bsubstr("nonstationary",1,max(`l',3))   {
		global S_3 "nonst"
		SetLag `f' `rest'
	}
	else if "`f'" == bsubstr("unstructured",1,max(`l',3))   {
		global S_3 "unstr"
		NoLag `f' `rest'
	}
	else if "`f'" == bsubstr("fixed",1,max(`l',3))   {
		global S_3 "fixed"
		SetMat `f' `rest'
		checkcm $S_6
	}
	else if "`f'" != "" {
		version 7: noi di in red "unknown correlation structure {bf:`f'} in option {bf:corr()}"
		exit 198
	}
end

program define ReTok
	if "`2'"=="" {
		local c = bsubstr("`1'",length("`1'"),1)
		while "`c'">="0" & "`c'"<="9" {
			local 1 = bsubstr("`1'",1,length("`1'")-1)
			local 2 "`c'`2'"
			local c = bsubstr("`1'",length("`1'"),1)
		}
	}
	global S_3 "`1'"
	mac shift
	global S_5 "`*'"
end

program define NoLag
	if "`2'"!="" {
		BadCorr `*'
	}
end

program define BadCorr
	version 7: di in red "option {bf:corr(`*')} invalid"
	exit 198
end

program define SetLag
	if "`3'" != "" {
		BadCorr `*'
	}
	if "`2'"=="" {
		global S_5 1
		exit
	}
	cap confirm integer number `2'
	if _rc {
		BadCorr `*'
	}
	if `2'<1 {
		BadCorr `*'
	}
	global S_5 `2'
end

program define SetMat
	if "`3'"!="" {
		BadCorr `*'
	}
	cap mat list `2'
	if _rc {
		if _rc==111 {
			version 7: di in red "matrix {bf:`2'} not found in option {bf:corr()}"
			exit 111
		}
		BadCorr `*'
	}
	global S_6 `2'
end

program define FixScale
	args y mu m wtexp

	global S_X_fix
	if "$S_E_scp" == "" {
		global S_X_fix 1
		if "$S_X_mvar" == "gauss" | "$S_X_mvar" == "gamma" | /*
			*/ "$S_X_mvar" == "igauss" {
			global S_E_scp "x2"
		}
		else {
			global S_E_scp 1
		}
	}

	tempvar dj
	if "$S_X_mvar" == "gauss" {
		if "$S_E_scp" == "dev" {
			gen double `dj' = (`y'-`mu')^2
			global S_X_fix 1
		}
		else if "$S_E_scp" == "x2" {
			gen double `dj' = (`y'-`mu')
		}
	}
	else if "$S_X_mvar" == "igauss" {
		if "$S_E_scp" == "dev" {
			gen double `dj' = (`y'-`mu')^2 / (`mu'^2*`y')
			global S_X_fix 1
		}
		else if "$S_E_scp" == "x2" {
			gen double `dj' = (`y'-`mu') / sqrt(`mu'^3)
		}
	}
	else if "$S_X_mvar" == "gamma" {
		if "$S_E_scp" == "dev" {
			gen double `dj' = -2*(log(`y'/`mu')-(`y'-`mu')/`mu')
			global S_X_fix 1
		}
		else if "$S_E_scp" == "x2" {
			gen double `dj' = (`y'-`mu')/sqrt((`mu')^2)
		}
	}
	else if "$S_X_mvar" == "poiss" {
		if "$S_E_scp" == "dev" {
			gen double `dj' = 2*`mu'
			replace `dj' = 2*(`y'*log(`y'/`mu')-(`y'-`mu')) if `y'
			global S_X_fix 1
		}
		else if "$S_E_scp" == "x2" {
			gen double `dj' = (`y'-`mu')/sqrt(`mu')
			global S_X_fix 1
		}
	}
	else if "$S_X_mvar" == "binom" {
		if "$S_E_scp" == "dev" {
			gen double `dj' = 2*`y'*log(`y'/`mu')+ /*
			*/ 2*(`m'-`y')*log((`m'-`y')/(`m'-`mu'))
			replace `dj' = 2*`m'*log(`m'/(`m'-`mu')) if `y'==0
			replace `dj' = 2*`y'*log(`y'/`mu') if `y'==`m'
			global S_X_fix 1
		}
		else if "$S_E_scp" == "x2" {
			gen double `dj' = (`y'-`mu')/sqrt(`mu'*(1-`mu'/`m'))
			global S_X_fix 1
		}
	}
	else if "$S_X_mvar" == "nbinom" {
		local k = $S_X_nba
		if "$S_E_scp" == "dev" {
			gen double `dj' = 2*ln1p(`k'*`mu')/`k'
			replace `dj' = 2*(`y'*ln(`y'/`mu')-(1+`k'*`y')/`k'* /*
				*/ ln((1+`k'*`y')/(1+`k'*`mu'))) if `y'
			global S_X_fix 1
		}
		else if "$S_E_scp" == "x2" {
			gen double `dj' = (`y'-`mu')/sqrt(`mu'+`k'*`mu'^2)
			global S_X_fix 1
		}
	}

	if "$S_E_scp" == "x2" {
		replace `dj' = (`dj')^2
	}

	if "$S_E_scp" != "phi" {
		cap confirm number $S_E_scp
		if _rc {
			summ `dj' `wtexp'
			global S_1 = r(sum)/$S_E_dof
			global S_E_dis = $S_1
		}
		else {
			global S_1 = $S_E_scp
		}
		global S_X_fix 1
	}
        else    global S_1


	if "$S_X_mvar" == "gauss" {
		cap drop `dj'
		gen double `dj' = (`y'-`mu')^2
		summ `dj' `wtexp', meanonly
		global S_X_D1 = r(sum)
		global S_X_D2 = r(sum)/$S_E_dof
		cap drop `dj'
		gen double `dj' = (`y'-`mu')
		replace `dj' = (`dj')^2
		summ `dj' `wtexp'
		global S_X_P1 = r(sum)
		global S_X_P2 = r(sum)/$S_E_dof
	}
	else if "$S_X_mvar" == "igauss" {
		cap drop `dj'
		gen double `dj' = (`y'-`mu')^2 / (`mu'^2*`y')
		summ `dj' `wtexp', meanonly
		global S_X_D1 = r(sum)
		global S_X_D2 = r(sum)/$S_E_dof
		cap drop `dj'
		gen double `dj' = (`y'-`mu') / sqrt(`mu'^3)
		replace `dj' = (`dj')^2
		summ `dj' `wtexp', meanonly
		global S_X_P1 = r(sum)
		global S_X_P2 = r(sum)/$S_E_dof
	}
	else if "$S_X_mvar" == "poiss" {
		cap drop `dj'
		gen double `dj' = 2*`mu'
		replace `dj' = 2*(`y'*log(`y'/`mu')-(`y'-`mu')) if `y'
		summ `dj' `wtexp', meanonly
		global S_X_D1 = r(sum)
		global S_X_D2 = r(sum)/$S_E_dof
		cap drop `dj'
		gen double `dj' = (`y'-`mu')/sqrt(`mu')
		replace `dj' = (`dj')^2
		summ `dj' `wtexp', meanonly
		global S_X_P1 = r(sum)
		global S_X_P2 = r(sum)/$S_E_dof
	}
	if "$S_X_mvar" == "gamma" {
		cap drop `dj'
		gen double `dj' = -2*(log(`y'/`mu')-(`y'-`mu')/`mu')
		summ `dj' `wtexp', meanonly
		global S_X_D1 = r(sum)
		global S_X_D2 = r(sum)/$S_E_dof
		cap drop `dj'
		gen double `dj' = (`y'-`mu')/sqrt((`mu')^2)
		replace `dj' = (`dj')^2
		summ `dj' `wtexp', meanonly
		global S_X_P1 = r(sum)
		global S_X_P2 = r(sum)/$S_E_dof
	}
	else if "$S_X_mvar" == "binom" {
		cap drop `dj'
		gen double `dj' = 2*`y'*log(`y'/`mu')+ /*
		*/ 2*(`m'-`y')*log((`m'-`y')/(`m'-`mu'))
		replace `dj' = 2*`m'*log(`m'/(`m'-`mu')) if `y'==0
		replace `dj' = 2*`y'*log(`y'/`mu') if `y'==`m'
		summ `dj' `wtexp', meanonly
		global S_X_D1 = r(sum)
		global S_X_D2 = r(sum)/$S_E_dof
		cap drop `dj'
		gen double `dj' = (`y'-`mu')/sqrt(`mu'*(1-`mu'/`m'))
		replace `dj' = (`dj')^2
		summ `dj' `wtexp', meanonly
		global S_X_P1 = r(sum)
		global S_X_P2 = r(sum)/$S_E_dof
	}
	else if "$S_X_mvar" == "nbinom" {
		local k = $S_X_nba
		cap drop `dj'
		gen double `dj' = 2*ln1p(`k'*`mu')/`k'
		replace `dj' = 2*(`y'*ln(`y'/`mu')-(1+`k'*`y')/`k'* /*
			*/ ln((1+`k'*`y')/(1+`k'*`mu'))) if `y'
		summ `dj' `wtexp', meanonly
		global S_X_D1 = r(sum)
		global S_X_D2 = r(sum)/$S_E_dof
		cap drop `dj'
		gen double `dj' = (`y'-`mu')/sqrt(`mu'+`k'*`mu'^2)
		replace `dj' = (`dj')^2
		summ `dj' `wtexp', meanonly
		global S_X_P1 = r(sum)
		global S_X_P2 = r(sum)/$S_E_dof
	}
end

program define ChkWt /* ivar wv */, rclass
	args ivar v
	cap by `ivar': assert `v'==`v'[_n-1] if _n>1
	if _rc {
		version 7: noi di in red "weight must be constant within variable {bf:`ivar'}"
		exit 199
	}
	tempname cc
	tempvar aa bb
	qui by `ivar': gen double `aa' = `v' if _n==_N
	qui by `ivar': gen double `bb' = _N*`v' if _n==_N
	qui capture qui summ `aa'
	qui capture scalar `cc' = r(sum)
	qui capture qui summ `bb'
	if _rc {
		noi di in red "insufficient observations"
		exit 2000
	}
	ret scalar mean = r(sum)/`cc'
	ret scalar sum  = `cc'
end

program define ChkSyn
	args tol iter hascons cons

	if `tol' <= 0 {
		version 7: noi di in red "option {bf:tolerance()} must be positive"
		exit 198
	}
	if `iter' < 1 {
		version 7: noi di in red "option {bf:iterate()} must be positive"
		exit 198
	}

	if "$S_X_scp" != "" {
		cap confirm number $S_X_scp
		if _rc {
			if "$S_X_scp" != "dev" & "$S_X_scp" != "x2" /*
			*/ & "$S_X_scp" != "phi" {
				version 7: noi di in red /*
			*/ "option {bf:scale()}: invalid specification"
				exit 198
			}
		}
	}

	if "`hascons'" != "" & "`cons'" != "" {
		version 7: noi di in red /*
		*/ "options {bf:hascons} and {bf:nocons} may not be specified together"
		exit 198
	}

	if "`hascons'" != "" | "`cons'" != "" {
		global S_X_con 0
	}
	else    global S_X_con 1

end

program define fixwords, eclass
	if "$S_E_fam" == "gauss" { global S_E_fam "Gaussian" }
	if "$S_E_fam" == "binom" { global S_E_fam "binomial" }
	if "$S_E_fam" == "poiss" { global S_E_fam "Poisson" }
	if "$S_E_fam" == "gamma" { global S_E_fam "gamma" }
	if "$S_E_fam" == "nbinom"{
		local val = round($S_X_nba,.0001)
		global S_E_fam "negative binomial(k=`val')"
	}
	if "$S_E_fam" == "igauss"{
		global S_E_fam "inverse Gaussian"
	}

	if "$S_E_lnk" == "ident"  { global S_E_lnk "identity" }
	if "$S_E_lnk" == "log"    { global S_E_lnk "log" }
	if "$S_E_lnk" == "logit"  { global S_E_lnk "logit" }
	if "$S_E_lnk" == "cloglog"{ global S_E_lnk "cloglog" }
	if "$S_E_lnk" == "recip"  { global S_E_lnk "reciprocal" }
	if "$S_E_lnk" == "probit" { global S_E_lnk "probit" }
	if "$S_E_lnk" == "power"  {
		local val = round($S_X_pow,.0001)
		global S_E_lnk "power(`val')"
	}
	if "$S_E_lnk" == "opower"  {
		local val = round($S_X_pow,.0001)
		global S_E_lnk "odds power(`val')"
	}
	if "$S_E_lnk" == "nbinom"{
		global S_E_lnk "negative binomial"
	}

	if "$S_E_cor" == "indep"   { global S_E_cor "independent" }
	if "$S_E_cor" == "exchan"  { global S_E_cor "exchangeable" }
	if "$S_E_cor" == "statm"   { global S_E_cor "stationary($S_E_bw)" }
	if "$S_E_cor" == "arm"     { global S_E_cor "AR($S_E_bw)" }
	if "$S_E_cor" == "nonstat" { global S_E_cor "nonstationary($S_E_bw)" }
	if "$S_E_cor" == "unstr"   { global S_E_cor "unstructured" }
	if "$S_E_cor" == "fixed"   { global S_E_cor "fixed (specified)" }

	est local family "$S_E_fam"
	est local corr   "$S_E_cor"
	est local link   "$S_E_lnk"
end

program define KeepMode /* ivar tvar [force] */
	args ivar tvar force touse

	if "`force'"!="" { exit }
	tempvar bb
	capture tsset
	tempname tsdelta
	if !_rc {
		scalar `tsdelta' = `r(tdelta)'
		local tsunits "`r(tdeltas)'"
	}
	else {
		scalar `tsdelta' = 1
		local tsunits "unit"
	}
	qui {
		sort `touse' `ivar' `tvar'
		by `touse' `ivar': gen double `bb' = (`tvar'-`tvar'[_n-1]) /*
			*/ if `touse'
		by `touse' `ivar': replace `bb' = `bb'[2] if _n==1 & `touse'
		summ `bb' if `touse', mean
		cap assert `bb' == r(min) | `bb'>=. if `touse'
		if _rc==0 { exit }

		tempname mesh
		tempvar freq bad
		sort `touse' `bb'
		by `touse' `bb': gen `c(obs_t)' `freq'=_N if _n==_N & `touse'
		summ `freq' if `touse', mean
		summ `bb' if `freq'==r(max) & `touse', mean
		scalar `mesh' =  r(min)
		sort `touse' `ivar' `tvar'
		drop `freq'
		gen byte `bad' = 0
		by `touse' `ivar': replace `bad' = /*
			*/ cond(_n==1,0,`bb'!=`mesh') if `touse'
		by `touse' `ivar': replace `bad' = /*
			*/ cond(_n==_N,sum(`bad')!=0,0) if `touse'
		summ `bad', mean
	}
	di in gr _n /*
		*/ "note:  observations not equally spaced" _n 		/*
		*/ _col(8) "modal spacing is delta `tvar' = " _c
	if `mesh' == `tsdelta' {
		di in gr "`tsunits'"
	}
	else {
		di in gr `mesh'
		di in gr _col(8) "spacing declared with tsset is " `tsdelta'
	}
	if r(sum) != 1 {
		local adds "s"
	}
	di in gr _col(8) r(sum) " group`adds' omitted from estimation"
	qui by `touse' `ivar': replace `touse' = cond(`bad'[_N],0,`touse') /*
		*/ if `touse'
	qui count if `touse'
	if r(N)==0 {
		di in red "no observations"
		exit 2000
	}
end

program define TooFewMg /* band */
	di in gr "note:  some groups have fewer than " /*
	*/ `1'+1 " observations" _n  _col(8) /*
	*/ "not possible to estimate correlations for those groups" _n /*
	*/ _col(8) r(sum) " groups omitted from estimation" _n
end

program define SaveMac, eclass
	est scalar df_pear   = `1'
	est scalar N      = `2'
	est scalar N_g    = `3'
	est scalar g_max  = `4'
	est scalar g_min  = `5'
	est scalar g_avg  = `6'
	est scalar tol    = `7'
	est scalar dif    = `8'
	est scalar phi    = `9'
	est local family  = trim("`10'")
	est local link    = trim("`11'")
	est local corr    = trim("`12'")
	est local tvar = trim("`13'")
	est local depvar  = trim("$S_X_depv")
	est local vcetype "$S_X_vce"
	est hidden local crittype "tolerance"

	* global X_level = `15'
	est local vce "`16'"
	if "$S_X_9" != "" {
		est hidden scalar disp     = $S_X_9
	}
	est local scale       "$S_X_A"
	est scalar deviance = $S_X_D1
	est scalar dispers  = $S_X_D2
	est scalar chi2_dev = $S_X_P1
	est scalar chi2_dis = $S_X_P2

	est local power $S_X_pow

	/* Double saves below here */
	global S_E_rdf = e(df_pear)
	global S_E_nobs = e(N)
	global S_E_ncl = e(N_g)
	global S_E_ntmx = e(g_max)
	global S_E_ntmn = e(g_min)
	global S_E_ntav = e(g_avg)
	global S_E_tol = e(tol)
	global S_E_dif = e(dif)
	global S_E_phi = e(phi)
	global S_E_fam = trim("`e(family)'")
	global S_E_lnk = trim("`e(link)'")
	global S_E_cor = trim("`e(corr)'")
	global S_E_tvar = trim("`e(tvar)'")
	global S_E_depv = trim("`e(depvar)'")
	global S_E_vl "$S_X_depv $S_X_idep"
	global S_X_ivar
	global S_E_bw "`14'"
	* global X_level = `15'
	global S_E_dis "$S_X_9"
	global S_E_scp "$S_X_A"
	global S_E_D1 "$S_X_D1"
	global S_E_D2 "$S_X_D2"
	global S_E_P1 "$S_X_P1"
	global S_E_P2 "$S_X_P2"
	global S_E_vce "$S_X_vce"
	if "$S_X_nba" != "" {
		global S_E_nba = 1/$S_X_nba
		est local nbalpha $S_E_nba
	}
	global S_E_pow $S_X_pow
end

program define BigEnuf, rclass /* ivar [tord] */
	args ivar tord
	tempvar bb
	tempname chkme
	quietly {
		by `ivar': gen `c(obs_t)' `bb' = _N if _n==_N
		capture summ `bb', meanonly
		if _rc {
			noi di in red "insufficient observations"
			exit 2000
		}
		ret scalar min = r(min)
		ret scalar max = r(max)
		ret scalar mean = r(mean)
		ret scalar xmax = r(max)
		ret scalar N = r(N)

		if "`tord'"!="" {
			drop `bb'
			by `ivar': gen float `bb' = `tord' if _n==_N
			summ `bb'
			ret scalar xmax = r(max)
		}
		mat `chkme' = I(`return(xmax)')
		mat drop `chkme'
	}
end

program define KeepMin, rclass /* corr ivar band */
	args corr ivar band touse

	if ("`corr'"!="statm" & "`corr'"!="arm" & "`corr'"!="nonst" ) {
		ret local band `band'
		exit
	}
	if `band' < 0 {
		local band 1
	}
	tempvar bb c
	quietly {
		sort `touse' `ivar'
		by `touse' `ivar': gen int `c' = _N if `touse'
		summ `c'
		if `band'<r(min) {
			ret local band `band'
			exit
		}
		by `touse' `ivar' : gen byte `bb' = 1 if `c'<=`band' & _n==1 /*
			*/ & `touse'
		summ `bb', mean
		noi TooFewMg `band'
		drop `bb'
		qui replace `touse' = cond(`c'>`band',`touse',0)
	}
	ret local band `band'
end

program define GetIval /* hascons nocons wexp xarg oarg -> b1 */
	version 6.0, missing
	local vv : di "version " string(_caller()) ", missing:"
	args hascons nocons wtex xarg oarg ARROW b1 offarg

	if "`offarg'" != "" {
		local options "OFFset(string)"
		parse ",`offarg'"
		local moff "-`offset'"
	}

	*local xtra 1
	if "$S_X_nba" != "" {
		local xtra = 1/$S_X_nba
	}
	local link "$S_X_link"
	local family "$S_X_mvar"
	local xarg "`xarg' `xtra'"

	local cap "capture"

	if "`hascons'" == "" & "`nocons'" == "" {
		local glink = trim("`link' $S_X_pow")
		if "`family'" == "gauss" & "`link'" == "ident" {
			tempvar jwh
			gen double `jwh' = $S_X_depv `moff'
			`cap' `vv' _regress `jwh' $S_X_idep `wtex'
		}
		else if "`family'" == "binom" & "`link'" == "probit" /*
		*/ & "`oarg'" == "" {
			`cap' `vv' probit $S_X_depv $S_X_idep `wtex', /*
				*/ nolog nocoef `offarg' asis /*
				*/ iter(`=min(1000,c(maxiter))')
		}
		else if "`family'" == "binom" & "`link'" == "logit" /*
		*/ & "`oarg'" == "" {
			`cap' `vv' logit $S_X_depv $S_X_idep `wtex', /*
				*/ `offarg' asis iter(`=min(1000,c(maxiter))')
		}
		else if "`family'" == "binom" & "`link'" == "cloglog" /*
		*/ & "`oarg'" == "" {
			`cap' `vv' cloglog $S_X_depv $S_X_idep `wtex', /*
				*/ `offarg'
		}
		else {
			if "`glink'" == "recip" {
				local glink = "power -1"
			}
*noi di in red "`cap' glm $S_X_depv $S_X_idep `wtex', fam(`family' `xarg') link(`glink') `offarg'"
			if _caller() > 6 {
				local myopt nonrtol
			}
			`vv' `cap' glm $S_X_depv $S_X_idep `wtex', /*
			*/ fam(`family' `xarg') link(`glink') `offarg' `myopt'
		}
		if _rc & _rc!=430 {
			if _rc==1 { exit 1 }
			tempvar jwh
			gen double `jwh' = $S_X_depv `moff'
			`cap' `vv' _regress `jwh' $S_X_idep
		}
		LoadMat `b1'
		exit
	}

	local glink = trim("`link' $S_X_pow")
	if "`glink'" == "recip" {
		local glink = "power -1"
	}
	`vv' `cap' glm $S_X_depv $S_X_idep `wtex', /*
	*/ fam(`family' `xarg') link(`glink') nocons `offarg'
	if _rc & _rc!=430 {
		if _rc==1 { exit 1 }
		tempvar jwh
		gen double `jwh' = $S_X_depv `moff'
		`cap' _regress `jwh' $S_X_idep, nocons
	}
	LoadMat `b1'
end

program define LoadMat /* matname */
	capture mat `1' = get(_b)
	if _rc==0 { exit }
	if _rc != 301 { error _rc }
	di in red "family/link inappropriate for this data"
	exit 2001
end

program define Checkt
	args ivar tvar rtvar touse
	qui {
		tempvar bb
		gen float `bb' = .
		sort `touse' `ivar'
		by `touse' `ivar': replace `bb' = `tvar'-`tvar'[_n-1] /*
			*/ if !`touse'
		by `touse' `ivar': replace `bb' = `bb'[2] if _n==1 & !`touse'
		summ `bb' if `touse', mean
		local rmin "`r(min)'"
		if "`rmin'" != "" {
			if `rmin' == 0 {
				noi di in red /*
				*/ "`rtvar' has duplicate values within panel"
				exit 198
			}
		}
	}
end


exit

note:  observations not equally spaced
       modal spacing is delta timevar = xxx
       14 groups omitted from estimation

note:  some groups have fewer than xx observations
       not possible to estimate correlations for those groups
       15 groups omitted from estimation

Took this out for logit and probit links:
	noi di in red "estimates diverging for logistic model"
	exit 198

comment A
/* Changed dmd 02/16/00  this code was used to map pweights and
	iweights robust to aweights.  The purpose being that aweights
	have the average n per panel and the number of panels calculated
	differently.  This is not correct.  pweights and iweights robust
	do affect the number of panels, just like they affect `the number of
	obs. in calculating a mean.

	if "`weight'" == "pweight" {
				local weight = "aweight"
				local robust "robust"
			}
			else if "`weight'" == "iweight" & "`robust'" != "" {
				local weight "aweight"
			}

*/
comment B

/* changed 0 -> 1 02/16/00 dmd
We wanted to allow aweights, but
that created a need for two different definitions of the sum of
the weights.  Since this proved difficult and aweights in this
particular context have dubious use, we removed aweights.  So,
the fact that we "and 0" reinforces the fact that we do NOT allow
aweights above (at the initial parse).
*/

comment C

/* Changed bpp 10/23/2006.
For the exchangeable correlation matrix, the alpha parameter must
be at least -1/(N - 1), where N is the size of the largest panel,
in order for the correlation matrix to be positive definite.  If
alpha is less than this critical value, we reset alpha to 99% of 
this c.v.  If we reset alpha on the final iteration, convergence
was not achieved, and we throw an r(430).

I also added a few lines of code further down to make sure that
regardless of the structure of the correlation matrix, the final 
estimate of it be positive definite, or, equivalently, that all
the eigenvalues be positive.
*/
