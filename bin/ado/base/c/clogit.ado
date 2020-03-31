*! version 1.10.0  14mar2018
program clogit, eclass byable(onecall) prop(swml or svyb svyj svyr mi bayes)
	if _caller() >= 11 {
		local vv : di "version " string(_caller()) ":"
	}
	version 8.2, missing
	if _by() {
		local by "by `_byvars'`_byrc0':"
	}
	if _caller() < 8.2 {
		`by' _clogit `0'
		exit
	}
	qui syntax [anything] [fw iw pw] [if] [in] ,	///
	[						///
		GRoup(varname)				///
		STrata(varname)				///
		VCE(passthru)				///
		CLuster(varname)			///
		DOOPT					///
		*					///
	]

	if `"`vce'"' != "" {
		local k = ("`strata'" != "") + ("`group'" != "")
		if `k' == 2 {
			di as err "strata() and group() may not be " _c
			di as err "specified at the same time"
			exit 198
		}
		else if `k' == 0 {
			di as err "group() required"
			exit 198
		}
		else {
			local group `group'`strata'
		}

		local group0 `group'
		tempname id
		_vce_cluster clogit,		///
			groupvar(`group')	///
			newgroupvar(`id')	///
			groptname(group)	///
			`vce'			///
			cluster(`cluster')
		local vce `"`s(vce)'"'
		local idopt `s(idopt)'
		local clopt `s(clopt)'
		local gropt `s(gropt)'
		local bsgropt `s(bsgropt)'
		if "`weight'" != "" {
			local wgt [`weight'`exp']
		}
		local vceopts jkopts(`clopt') ///
			bootopts(`clopt' `idopt' `bsgropt') ///
			mark(GRoup OFFset CLuster)
		`vv' `by' _vce_parserun clogit, `vceopts' : ///
			`anything' `wgt' `if' `in', ///
			`gropt' `vce' `options'
		if "`s(exit)'" != "" {
			ereturn local group `group'
			ereturn local cluster `cluster'
			if "`cluster'" == "" {
				local cmd1 `"`e(command)'"'
				local cmd2 : ///
					subinstr local cmd1 "`id'" "`group'"
				ereturn local command `"`cmd2'"'
			}
			ereturn local cmdline `"clogit `0'"'
			exit
		}
	}

	if replay() {
		if "`e(cmd)'" != "clogit" {
			error 301
		}
		if "`:colnames(e(b))'" == "" |	///
		  !inlist("`e(opt)'", "ml", "moptimize") {
			// Replay null model or old results from disk.
			_clogit `0'
			exit 
		}
		if _by() { 	
			error 190  	
		}
		Display `0'
		error `e(rc)'
		exit
	}

	`vv' `by' clogit_82 `0'
	ereturn local cmdline `"clogit `0'"'
end

program clogit_82, eclass byable(recall) sort
	version 8.2, missing
// Parse. 

	syntax varlist(numeric ts fv) [fw iw pw] [if] [in] [, ///
		OR FROM(string) ///
		Level(cilevel) OFFset(varname numeric) ///
		GRoup(varname) STrata(varname) Robust CLuster(varname) ///
		NOLOg LOg noDISPLAY noHEADer SCore(string) noNEST ///
		VCE(passthru) DOOPT moptobj(passthru) * ]

	local tsops = "`s(tsops)'" == "true"
	if `tsops' {
		_xt, trequired
		local tvar `"`r(tvar)'"'
		if "`r(ivar)'" != "`group'" {
			di as err ///
"{p 0 2 2"} ///
"panel variable and group() option are inconsistent;{break}" ///
"time-series operators require that the {opt group()} variable is also " ///
"{helpb xtset} as the panel variable" ///
"{p_end}"
			exit 459
		}
	}
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11
	if `fvops' {
		if _caller() < 11 {
			local vv "version 11:"
		}
		else	local vv : di "version " string(_caller()) ":"
		local mm e2
		local negh negh
		local ml_method e2
		local fvexp "expand"
	}
	else {
		local vv "version 8.1:"
		local mm d2
	}

	if `:length local vce' {
		_vce_parse, argopt(CLuster) opt(OIM Robust OPG) old	///
			: [`weight'`exp'], `vce' `robust' cluster(`cluster')
		local cluster `r(cluster)'
		local robust `r(robust)'
		if "`robust'" != "" {
			// hide -vce(robust)- option from -ml model-, we will
			// be doing the robust calculation ourselves
			local vce
		}
	}

	_get_diopts diopts options, `options'
	mlopts mlopts, `options' `vce' `log' `nolog'
	local coll `s(collinear)'
	CheckScore, `mlopts' score(`score')
	local noscore `s(noscore)'
	if "`noscore'" != "" & "`mm'" == "e2" {
		local mm d2
		local noscore
	}
	else {
		local gropt group(`group')
	}

// Parse varlist. 

	gettoken depvar xvars : varlist 
	_fv_check_depvar `depvar'

// Check group() and strata() options. 

	local k = ("`strata'" != "") + ("`group'" != "")
	if `k' == 2 {
		di as err "strata() and group() may not be " _c
		di as err "specified at the same time"
		exit 198
	}
	else if `k' == 0 {
		di as err "group() required"
		exit 198
	}
	else {
		local group `group'`strata'
		global CLOG_gr `group'
	}

// Mark sample except for offset. 

	marksample touse
	markout `touse' `group', strok

// Process offset.

	if "`offset'"!="" {
		markout `touse' `offset'
		local offopt "offset(`offset')"
	}

// Cluster.

	if "`cluster'" != "" {
		markout `touse' `cluster', strok
		local robust robust
		if "`nest'" == "" {
			local clustopt cluster(`cluster') 
			cap noi CheckClusters `group' `cluster' `touse' 
			if _rc {
				exit _rc
			}
		}
	}
	else if "`nest'" != "" {
		di as err "option nonest requires the vce(cluster ...) option"
		exit 198
	}

// Weights.
	
	if "`weight'" != "" {
		if "`weight'"=="fweight" {
			local wgt `"[fw`exp']"'
		}
		else {
			local wgt `"[iw`exp']"'
			if "`weight'" == "pweight" {
				local robust robust
			}
		}
	}

// Generate y != 0 variable.

	tempvar y1
	qui gen byte `y1' = `depvar'!=0 if `touse'

// Remove collinear variables.

	`vv' ///
	_rmcoll `xvars' if `touse' `wgt', `coll' `fvexp'
	local xvars `r(varlist)'

// handle time-series operators

	local depname : copy local depvar
        local depname2 `depname':
        if strpos("`depname'", ".") {
		local depname2
	}
	local XVARS : copy local xvars
	if `tsops' {
		qui tsset, noquery

		tsrevar `depvar'
		local depvar `"`r(varlist)'"'

		fvrevar `xvars', tsonly
		local xvars `"`r(varlist)'"'
	}


// Ignore offending observations/groups. 

	`vv' ///
	cap noi CheckGroups `y1' `group' `touse' `"`xvars'"' `"`XVARS'"' ///
		`wgt', `offopt'
	if _rc {
		exit _rc
	}
	local xvars `r(varlist)'
	local XVARS `r(VARLIST)'
	local n `r(N)'
	local ng `r(ng)'
	local n_drop `r(n_drop)'
	local ng_drop `r(ng_drop)'
	local multiple `r(multiple)'
	if !`r(useoffset)' {
		local offopt
	}

// Count clusters once offending observations have been removed.

	if "`cluster'" != "" {
		tempvar nc
		qui bysort `touse' `cluster': gen `nc' = _n==1 if `touse'
		qui count if `nc' == 1
		local nc = r(N)
	}

	if "`robust'" != "" {
		local critopt "crittype(log pseudolikelihood)"
	}

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
// Check for null model once offending variables/offset removed.
	if `"`xvars'"' == "" {   // Old clogit can deal with no beta
				 // ml can't.
		_clogit `depvar' if `touse' `wgt', `offopt' ///
			group(`group') `log' `display' nowarn ///
			`critopt'
		exit
	}

// Get final sort for sped-up likelihood evaluator

	tempvar nn
	qui gen `c(obs_t)' `nn' = _n if `touse'
	gsort -`touse' `group' `y1' `nn'

// Check for initial values. 
		
	if `"`from'"'!="" {
		local initopt `"init(`from')"'
	}
	else {
		tempname b0 lfs
		local k : word count `xvars'
		if `fvops' {
			local doopt doopt nonrtol
		}
		`vv' ///
		cap logit `y1' `xvars' if `touse' `wgt', `offopt' `doopt' ///
			iter(20)
		if !_rc {
			mat `b0' = e(b)
			if colsof(`b0') == `k' + 1 {
				mat `b0' = `b0'[1,1..`k']
				qui _clogit_lf `y1' `xvars' if `touse' ///
                                        `wgt', `offopt' group(`group') ///
                                        lnf(`lfs') beta(`b0') sorted 
                                // likelihood from logit for all intents and
                                // purposes missing
                                if abs(scalar(`lfs')) > 1e50 {
                                        mat `b0' = J(1,`k',0)
                                }
			}
			else {
				mat `b0' = J(1,`k',0)
			}
		}
		else {
			mat `b0' = J(1,`k',0)
		}
		local initopt `"init(`b0', copy)"'
	}

// Get likelihood for null model.
	tempname lf0
	qui _clogit_lf `y1' if `touse' `wgt',  ///
		group(`group') `offopt' lnf(`lf0') sorted 
	local ll = scalar(`lf0')   
	if `ll' < . {
		if "`robust'" == "" {
			local ll0 "lf0(0 `ll')"
		}
	}
	else {
		di in txt "note: could not compute log likelihood for " _c 
		di in txt "the null model."
	}

	local title "Conditional (fixed-effects) logistic regression"

// Maximize.
	global GLIST : all globals "CLOG_*"
	
	`vv' ///
	ml model `mm' clogit_lf (`depname2' `depvar' = `xvars', ///
		noconstant `offopt') `wgt' if `touse', collinear search(off) ///
		nopreserve missing max `mlopts' `initopt' `ll0' ///
		`noscore' title("`title'") `critopt' `gropt' `negh' `moptobj'


// Robust variance calculation.

	eret local group `group'
	eret local multiple `multiple'
	if `:length local n_drop' {
		eret scalar N_drop = `n_drop'
		eret scalar N_group_drop = `ng_drop'
	}
	else {
		eret scalar N_drop = 0
		eret scalar N_group_drop = 0
	}
	if "`robust'`score'" != "" {
		if "`score'" == "" {
			tempvar score
			local tmpscore yes
		}
		tempname b
		mat `b' = e(b)
		qui _clogit_lf `y1' `xvars' if `touse',  ///
			group(`group') `offopt' score(`score') ///
			beta(`b') sorted 
		if "`tmpscore'" == "" {
			label var `score' "Score index from clogit"
		}
	}

	if `tsops' {
		qui tsset, noquery

		tempname b
		matrix `b' = e(b)
		version 12: matrix colnames `b' = `XVARS'
		version 12: matrix coleq `b' = `depname'
		ereturn repost b=`b', rename
	}

	if "`robust'" != "" {
		eret scalar ll_0 = scalar(`lf0')   // Pseudo R2 okay 
		if "`cluster'" != "" {
			local copt cluster(`cluster')
			local nopt ng(`nc')
		}
		else {
			local nopt ng(`ng')
		}
		Robust `score' `wgt' if `touse', `copt' `nopt'

		qui test [#1]
		local df = r(df)
		eret scalar chi2 = r(chi2)
		eret scalar p = r(p) 
		if `e(df_m)' != `df' {	          // singular test 
			eret scalar chi2 = .	
			eret scalar p = .
			eret scalar df_m = `df'
		}
		eret local vcetype "Robust"
		if "`cluster'" != "" {   
			eret local clustvar `cluster'
			eret scalar N_clust = `nc'
			eret local vce "cluster"
		}
		else eret local vce "robust"

		if "`weight'" == "pweight" {
			eret local wtype `weight'
		}
	}
	else {
		ereturn repost, buildfvinfo ADDCONS
	}

// Possibly change model df and p-value in LR test.

	else {     
		if `e(rank)' != `e(df_m)' {
			eret scalar df_m = `e(rank)'
			eret scalar p = chi2tail(e(rank),e(chi2))
		}
	}

// Save.

	eret scalar r2_p = 1 - e(ll)/e(ll_0)
	if "`offopt'" != "" {
		eret local offset "`offset'"
		eret local offset1
	}
	if `:length local ml_method' {
		eret local ml_method `ml_method'
	}
	eret hidden local marginsprop	addcons
	eret local marginsdefault	predict(pu0)
	eret local marginsok	PU0 XB
	eret local marginsnotok	default		///
				Pc1		///
				STDP		///
				DBeta		///
				DX2		///
				GDBeta		///
				GDX2		///
				Hat		///
				Residuals	///
				RSTAndard	///
				SCore
	eret local predict "clogit_p"
	eret local cmd "clogit"

	if "`display'" == "" {
		Display, level(`level') `or' `header' `diopts'
	}

	cap mac drop CLOG_gr
end

program Display
	syntax [, Level(cilevel) OR noHEADer *]
	_get_diopts diopts, `options'
	if "`or'"!="" {
		local eopt "eform(Odds Ratio)"
	}

	version 9: ml di, level(`level') `eopt' `header' nofootnote `diopts'
	_prefix_footnote
end

program CheckGroups, rclass
	local caller = _caller()
	version 8.2, missing
	syntax anything [fw iw] [, offset(varname)]
	gettoken y anything : anything
	gettoken group anything : anything
	gettoken touse anything : anything 
	gettoken xvars anything : anything
	gettoken XVARS empty : anything

	if "`empty'" != "" {
		exit 198
	}

	sort `touse' `group'

	// Check weights.

	if "`weight'" != "" {
		tempvar w 
		qui gen double `w'`exp' if `touse'
		cap by `touse' `group':assert `w'==`w'[1] if `touse'
		if _rc {
			error 407
		}	
		if "`weight'"=="fweight" {
			local freq `w'
		}
	}

	// Check at least one good group.

	cap by `touse' `group': assert `y'==`y'[1] if `touse' 
	if !_rc {
		di as txt "outcome does not vary in any group"
		exit 2000 
	}	

	// Check for multiple positive outcomes within groups.

	tempvar sumy 
	qui by `touse' `group': gen double `sumy' = cond(_n==_N, ///
		sum(`y'), .) if `touse'
	qui count if `sumy' > 1 & `sumy' < .
	if `r(N)' {
		di as txt "note: multiple positive outcomes within " _c
		di as txt "groups encountered."
		local multiple multiple
	}

	// Delete groups where outcome doesn't vary.

	CountObsGroups `touse' `group' `freq'
	local n_orig = r(n)
	local ng_orig = r(ng)

	tempvar varies rtouse
	qui by `touse' `group': gen byte `varies' = cond(_n==_N, ///
		sum(`y'!=`y'[1]), .) if `touse'
	qui by `touse' `group': gen byte `rtouse' = (`varies'[_N]>0) & `touse'
	qui replace `touse' = `rtouse'
	sort `touse' `group'

	CountObsGroups `touse' `group' `freq'
	local n = r(n)
	local ng = r(ng)
	
	if `n' < `n_orig' {
		if `ng_orig'-`ng' > 1 {
			local s s
		}
		di as txt "note: " string(`ng_orig'-`ng', "%12.0fc") _c
		di as txt " group`s' (" _c
		di as txt string(`n_orig'-`n', "%12.0fc") _c 
		di as txt " obs) dropped because of all positive or"
		di as txt "      all negative outcomes."
		local ng_drop	= `ng_orig' - `ng'
		local n_drop	= `n_orig' - `n'
	}

	// Check that each xvar varies in at least 1 group.

	if `"`xvars'"' != "" {
		tempvar tt
		quietly gen `tt' = . in 1
		foreach v of local xvars {
			gettoken V XVARS : XVARS
			_ms_parse_parts `V'
			if !r(omit) {
                                if r(type) == "variable" {
					local vv : copy local v
				}
				else {
                                        qui replace `tt' = `v'
                                        local vv : copy local tt
                                }
				cap by `touse' `group':	///
				assert `vv'==`vv'[1] if `touse'
				if !_rc {
					di as txt ///
"note: `V' omitted because of no within-group variance."		
					if `caller' < 11 {
						local v
						local V
					}
					else {
						// omit the "tempvar"
						_ms_put_omit `v'
                                                local v `s(ospec)'
						
						// omit the original var
						_ms_put_omit `V'
						local V `"`s(ospec)'"'
					}
				}
			}
			local xs `xs' `v'
			local XS `XS' `V'
		}
	}	

	// Check that offset varies in at least 1 group.

	local useoffset 0
	if "`offset'" != "" {
		cap by `touse' `group': assert `offset'==`offset'[1] if `touse'
		if !_rc {
			di as txt "note: offset `offset' omitted " _c
			di as txt "because of no " _c
			di as txt "within-group variance."
		}
		else {
			local useoffset 1
		}
	}

	return local multiple `multiple'
	return local varlist `xs'
	return local VARLIST `XS'
	return local useoffset `useoffset'
	return scalar N = `n'
	return scalar ng = `ng'
	if `:length local n_drop' {
		return scalar n_drop = `n_drop'
		return scalar ng_drop = `ng_drop'
	}
end

program CountObsGroups, rclass 
	args touse group freq

	tempvar i
	if "`freq'" == "" {
		qui count if `touse'
		return scalar n = r(N)
		qui by `touse' `group': gen byte `i' = _n==1 & `touse'
		qui count if `i'
		return scalar ng = r(N)
	}
	else {
		qui summ `freq' if `touse', meanonly
		return scalar n = r(sum)
		qui by `touse' `group': gen double `i' = (_n==1&`touse')*`freq'
		qui summ `i' if `touse', meanonly
		return scalar ng = r(sum)
	}
end

program CheckClusters
	args group cluster touse
	
	sort `touse' `group'
	cap by `touse' `group': assert `cluster'==`cluster'[1] if `touse'
	if _rc {
		di as err "groups (strata) are not nested within clusters"
		exit 459
	}
end

program Robust, eclass 
	syntax varname [fw iw/] [if] [, CLuster(varname) ng(int -1)]

	marksample touse
	if "`weight'" != "" {
		if "`cluster'"=="" & "`weight'"=="fweight" {
			local exp `"sqrt(`exp')"'
		}
		local w `"[iw=`exp']"'
	}

	if "`cluster'" == "" {
		local cluster `e(group)'
	}
	
	tempname V vmb
	mat `V' = e(V)
	mat `vmb' = e(V)
	_robust2 `varlist' `w', var(`V') minus(0) cluster(`cluster')
	mat `V' = `ng'/(`ng'-1) * `V'

	eret matrix V_modelbased `vmb'
	eret repost V = `V', buildfvinfo ADDCONS
end

program CheckScore, sclass
	syntax [, SCore(string) TECHnique(string) VCE(string) * ]
	if "`score'" != "" {
		if `:word count `string'' > 1 {
			di as err "score() requires one new variable name"
			exit 198
		}
		confirm new var `score'
	}
	if `"`technique'"' != "" {
		local bhhh bhhh
		if `:list bhhh in technique' {
			exit
		}
	}
	if `"`vce'"' != "" {
		local l : length local vce
		if "`vce'" == bsubstr("opg",1,`l') {
			exit
		}
	}
	sreturn local noscore noscore
end

exit

