*! version 7.5.2  21oct2019
program define ml_model, sclass
	version 6, missing
	sret clear
/*
... "caller 6 tempnames" <method> <userprob> <equations> <std syntax>
*/
	gettoken tvars 0: 0
	gettoken caller tvars: tvars
	global ML_vers "version `caller':"

	gettoken (global) ML_meth 0: 0
	gettoken (global) ML_user 0: 0
	capture IsName $ML_meth
	if _rc {
		di in red `""$ML_meth" invalid method"'
		exit 198
	}
	local w1 : word 1 of $ML_user
	capture IsName `w1'
	if _rc {
		di in red `""$ML_user" invalid evaluation-program name"'
		exit 198
	}
	global ML_ouser `"$ML_user"'
	local w1

	if `"$ML_meth"'=="" | `"$ML_user"'=="" {
		error 198
	}

/*
... <equations> <std syntax>
*/

	gettoken next 0: 0, parse(" [],()/")
	IsLast `next'
	global ML_n 0
	while `s(cont)' {
		global ML_n = $ML_n + 1
		local n = `n' + 1
		if `"`next'"'=="(" {
			/* Now, there might be an option with parens */
			local flag 1
			gettoken next 0: 0, parse("()")
			while `flag' > 0 & `"`next'"' != "" {
				if `"`next'"' == "(" {
					local flag = `flag' + 1
				}
				if `"`next'"' == ")" {
					local flag = `flag' - 1
				}
				if `flag' {
					local eq `"`eq'`next'"'
					gettoken next 0: 0, parse("()")
				}
			}
			if `flag' {
				di in red "unbalanced parentheses"
				exit 198
			}
			ParseIL `eq'
			local eq
		}
		else if `"`next'"' == "/" {
			gettoken next 0: 0, parse(" ,")
			ParsePrm `next'
		}
		else {
			eq ?? `next'
			ParseIL $S_3: $S_1
		}
		gettoken next 0: 0, parse(" [],()/")
		IsLast `next'
	}

/*
... <std syntax>
*/

	local 0 `"`next' `0'"'

	syntax [fweight aweight iweight pweight] [if] [in] /*
	*/ [, BRACKET noCLEAR CLuster(passthru) COLlinear CONTinue	/*
	*/    INIt(string)  LF0(string) MAXimize MISSing OBS(integer 0)	/*
	*/    noPREserve Robust noSCVARS TItle(string) WALDtest(int -1)	/*
	*/    TECHnique(passthru) VCE(passthru) CONSTraints(string)	/*
	*/    TOUSEv(string) WEIGHTv(string) MATSv(string) noOUTput	/*
	*/	CRITTYPE(string)					/*
	*/	svy				/* -svy- options 
 	*/	STRata(varname)			/* not allowed with svy option
 	*/	psu(varname)			/*
	*/	fpc(varname numeric)		/*
	*/	noSVYadjust			/* allowed with svy option
	*/	SUBpop(passthru)		/*
	*/	SRSsubpop			/*
	*/	svarconst			/* force constraints for svar
	*/	noCNSNOTEs			/* -makecns- option
	*/	dzeros(name)			/* opt to set ML_d0_S
	*/	NOSCORE				/* not documented
	*/	PREITERpgm(name)		/* NOT documented
	*/	GROUP(varname)			/*
	*/	*				/* other options
	*/	]

	if "`colline'" != "" {
		// option -collinear- might be specified twice
		CheckCollinear, `options'
	} 
	_vce_parse, old argopt(CLuster)			///
		opt(OIM Opg Hessian NATIVE Robust)	///
		: [`weight'`exp'], `vce' `cluster' `robust'
	local robust `r(robust)'
	local cluster `r(cluster)'
	if "`robust'`cluster'" == "" {
		local vce `"`r(vceopt)'"'
	}
	else	local vce
	global ML_grp `group'

	local output		/* ignore output/nooutput */

	if `"`preiterpgm'"' != "" {
		capture which `preiterpgm'
		if c(rc) {
			capture program list `preiterpgm'
			if c(rc) {
				quietly which `preiterpgm'
			}
		}
		global ML_evalp `preiterpgm'
	}

	if "`dzeros'" != "" {
		confirm matrix `dzeros'
		global ML_00_S `dzeros'
	}

	// put -diparm()- options into globals ML_diparm#
	ParseDiparmOpts `options'
	local options `"`s(options)'"'

/* handle svy options */
	if `"`svy'"' != "" {
		if "`weight'" != "" {
			version 7: di in red /*
*/ "option {bf:svy} not allowed with weights"
			exit 198
		}
		if "`psu'`strata'`fpc'" != "" {
			version 7: di in red /*
*/ "option {bf:svy} not allowed with options {bf:psu()}, {bf:strata()}, or {bf:fpc()}"
			exit 198
		}
		/* pick up -svyset-ings */
		if _caller() < 9 {
			quietly version 8.2: svyset
			local strata `r(strata)'
			local psu `r(psu)'
			local fpc `r(fpc)'
			local weight `r(wtype)'
			local wvar `r(`r(wtype)')'
			local exp "`r(wexp)'"
			if `"`r(_svy)'"' != "" {
				local oldsvy yes
			}
		}
		if "`oldsvy'" == "" {
			quietly version 9: svyset
			if `"`r(settings)'"' == ", clear" {
				version 7: di in red ///
				"option {bf:svy} requires the data to be {bf:svyset}"
				exit 198
			}
			global ML_svy2 svy
			local weight `r(wtype)'
			local exp `"`r(wexp)'"'
			local wvar : word 2 of `exp'
			local strata `r(strata1)'
		}
	}
	else {
		if   "`psu'`strata'`fpc'" != "" {
			local svy0 svy
			if `"`weight'"' != "" {
				gettoken junk wvar : exp
			}
		}
	}

	if "`noscore'" != "" {
		global ML_nosc `noscore'
		if !inlist("$ML_meth", "d1", "d2") {
			version 7: di as err ///
"option {bf:noscore} is allowed only with method d1 and d2 likelihood evaluators"
			exit 198
		}
		if `"`svy'`svy0'"' != "" {
			opts_exclusive "svy noscore"
		}
		if `"`cluster'"' != "" {
			opts_exclusive "cluster() noscore"
		}
		if `"`weight'"' == "pweight" {
			version 7: di as err "{bf:pweight}s not allowed with option {bf:noscore}"
			exit 198
		}
		if `"`robust'"' != "" {
			opts_exclusive "robust noscore"
		}
	}

/* common settings for -svy- data */
	if "`svy'`svy0'" != "" {
		local lf0
		if "`cluster'" != "" {
			opts_exclusive "cluster() svy" cluster
		}
		if inlist("$ML_meth","d0","rdu0") {
			version 7: di as err ///
			"option {bf:svy} is not allowed with method $ML_meth"
			exit 198
		}
		if "`vce'" != "" {
			opts_exclusive "vce() svy" vce
		}

		global ML_svy svy
		global ML_sadj `svyadju'
		local zerow zeroweight
		local robust robust
		if "$ML_svy2" == "" {
			global ML_str `strata'
		}
		global ML_clust `psu'	/* instead of ML_psu */
		global ML_fpc `fpc'

		if `"`weight'"' != "" {
			// weights are saved in two places for -svy- data
			// because of -subpop()-, which requires one weight
			// var for estimation that takes -subpop()- into
			// account, and a second that does not for -_robust-
			// (which takes the -subpop()- option itself)
			global ML_swty `weight'
			global ML_sw `wvar'
			if `"`weight'"' != "iweight" & /*
			*/ `"`weight'"' != "pweight" {
				di in red /*
				*/ "`weight's may not be used with svy options"
				exit 198
			}
			local weight iweight
		}
	}
	else {
		if `"`subpop'"' != "" {
			version 7: di in red /*
*/ "option {bf:subpop()} requires option {bf:svy}, {bf:strata()}, {bf:psu()}, or {bf:fpc()}"
			exit 198
		}
	}

/* do not allow -ml maximize-'s -noclear- option */
	if "`clear'"!="" {
		version 7: di in red "option {bf:noclear} not allowed"
		exit 198
	}
/* end do not allow -ml maximize-'s -noclear- option */

/* "$ML_mksc" != "" -> user needs score variables */
	if "`scvars'"=="" {
		global ML_mksc "yes"
	}

	if `waldtes'>0 & "`lf0'"!="" {
		version 7: di in red /*
*/ "may not specify both option {bf:lf0()} and option {bf:waldtest(}{it:k}{bf:)}, {it:k}>0"
		exit 198
	}


/*
	begin -continue- option:
		-continue- just fills in -lf0()- and perhaps -init-
*/
	if "`continu'" != "" {
		if "`init'"=="" {		/* no init() option */
			tempname init		/* ... then fill it in */
			local ub0 `init'
		}
		else	tempname ub0
		mat `ub0' = get(_b)

		// -svy- option does not allow the LR test
		if "`svy'`svy0'" == "" {
			tempname v0 iv0		/* vce of the first model */
			mat `v0' = e(V)
			mat `iv0' = syminv(`v0')
			global ML_rank0 = colsof(`v0') - diag0cnt(`iv0')
			if "`lf0'"=="" & e(ll)< . {
				local np = matrix(colsof(`ub0'))
				local lf0 `np' `e(ll)'
				local ub0
				local np
			}
		}
	}
/* end of -continue- option */

/* begin -cluster()-, part 1 processing  */
	if `"`cluster'"'!="" {
		unabbrev `cluster', max(1)
		global ML_clust `cluster'
	}
/* end -cluster()-, part 1 processing  */


/* obtain touse and weight variable names in $ML_samp and $ML_w */
	if "`maximiz'"=="" {
		SetTmpV ML_samp <- _MLtu `"`tousev'"'
		SetTmpV ML_w <- _MLw `"`weightv'"'
	}
	else {
		global ML_samp : word 1 of `tvars'
		global ML_w : word 2 of `tvars'
	}
	// remember original weight variable, poststratification adjustments
	// require two weight variables, one for estimation that takes
	// -subpop()- into account, and a second that does not for -_robust-
	// (which takes the -subpop()- option itself)
	global ML_wo $ML_w

	if `"`weight'"' != "" {
		local w [`weight'`exp']
	}

/* obtain names for ML_b, ML_f, ML_g, ML_V, ML_dfp_b, ML_dfp_g */
	if "`matsv'"!="" {		// UNDOCUMENTED option -matsv()-
		local n : word count `matsv'
		if `n'!=6 {
			error 198
		}
		global ML_b	: word 1 of `matsv'
		global ML_f	: word 2 of `matsv'
		global ML_g	: word 3 of `matsv'
		global ML_V	: word 4 of `matsv'
		global ML_dfp_b	: word 5 of `matsv'
		global ML_dfp_g	: word 6 of `matsv'
		IsName $ML_b
		IsName $ML_f
		IsName $ML_g
		IsName $ML_V
		IsName $ML_dfp_b
		IsName $ML_dfp_g
	}
	else {
		if "`maximiz'"!="" {
			global ML_b	: word 3 of `tvars'
			global ML_f	: word 4 of `tvars'
			global ML_g	: word 5 of `tvars'
			global ML_V	: word 6 of `tvars'
			global ML_dfp_b	: word 7 of `tvars'
			global ML_dfp_g	: word 8 of `tvars'
			global ML_subv 	: word 9 of `tvars'
		}
		else {
			global ML_b ML_b
			global ML_f ML_f
			global ML_g ML_g
			global ML_V ML_V
			global ML_dfp_b ML_dfp_b
			global ML_dfp_g ML_dfp_g
			global ML_subv 	ML_subv
		}
	}
	scalar $ML_f = .
/* end obtain names for ML_b, ML_f, ML_g, ML_V, ... */


/* mark estimation subsample */
	mark $ML_samp `w' `if' `in' , `zerow'
	if "`missing'"=="" {
		MarkOut /* variables from equations */
	}
	markout $ML_samp $ML_clust $ML_str $ML_fpc, strok

/* fill in weight variable */
	quietly {
		if "`weight'"!="" {
			global ML_wexp `"`exp'"'
			gen double $ML_w `exp' if $ML_samp
			if "`weight'"=="aweight" {
				qui sum $ML_w if $ML_samp, meanonly
				qui replace $ML_w = $ML_w/r(mean)
			}
			compress $ML_w
			global ML_wtyp `weight'
		}
		else 	gen byte $ML_w = 1 if $ML_samp
		if "$ML_svy" != "" {
			if `"`weight'"' == "pweight" {
				capture assert $ML_w >= 0
				if _rc {
					error 402
				}
			}
			// e(N_pop) should not be affected by omitted strata
			sum $ML_w, mean
			global ML_pop `r(sum)'
		}
	}

/* Handle subpop. */
	if `:length local svy' {
		// _svy_setup can decrease the sample size due to missing
		// values in the survey design variables
		_svy_setup $ML_samp $ML_subv, `svy'
		capture drop $ML_subv
	}
	if `"`subpop'`srssubpop'"' != "" {
		// _svy_subpop can decrease the sample size by omitting strata
		_svy_subpop $ML_samp $ML_subv, ///
			strata(`strata') `subpop' `srssubpop' wvar($ML_w)
		global ML_srsp `r(srssubpop)'	/* srssubpop option flag */
		global ML_subp `r(subpop)'
		quietly replace $ML_w = 0 if $ML_subv==0
	}
	else	global ML_subv

/* Compute total #obs. */
	if "$ML_svy" != "" {
		quietly count if $ML_samp
		if r(N) == 0 {
			error 2000
		}
		if `"`weight'"' != "" {
			quietly count if $ML_samp & $ML_w != 0
			if r(N) == 0 {
				di in red "all observations have zero weight"
				exit 2000
			}
		}
	}

/* count number of observations, deal with obs() option  */
	if `obs' {
		if `obs'<0 {
			version 7: di in red "option {bf:obs(`obs')} invalid"
			exit 198
		}
		global ML_N `obs'
		local obs
	}
	else {
		if "`weight'"=="fweight" {
			qui sum $ML_w if $ML_samp, meanonly
			global ML_N = `r(sum)'
		}
		else {
			qui count if $ML_samp
			global ML_N = r(N)
		}
	}
/* end count number of observations, deal with obs() option  */


/* set -robust- option */
	global ML_vce `robust'
	if "$ML_clust"!="" {
		if "`vce'" != "" {
			version 7: di as err ///
			"options {bf:vce()} and {bf:cluster()} may not be specified together"
			exit 198
		}
		global ML_vce "robust"
	}
	if "$ML_wtyp"=="pweight" {
		if "`vce'" != "" {
			version 7: di as err ///
			"option {bf:vce()} and {bf:pweight}s may not be combined"
			exit 198
		}
		global ML_vce "robust"
	}

	if `"`crittype'"' == "" {
		if "$ML_vce" == "robust" {
			global ML_crtyp "log pseudolikelihood"
		}
		else	global ML_crtyp "log likelihood"
	}
	else {
		global ML_crtyp = trim(bsubstr(`"`crittype'"',1,32))
	}
	if "$ML_vce" == "robust" {
		if "`vce'" != "" {
			version 7: di as err ///
			"options {bf:vce()} and {bf:robust} may not be specified together"
			exit 198
		}
		local vce vce(oim)
	}
/* end set -robust- option */


/* set -bracket- option for computation of numeric derivative */
	global ML_brack `bracket'
/* end set -bracket- option */


/* ---- begin method description processing -- routine m<method>_.ado */
	local methi = "m" + bsubstr("$ML_meth",1,30) + "_"
	if `"`technique'`vce'"'!="" {
		global ML_tech `", `technique' `vce'"'
		local methi `"`methi', `technique' `vce'"'
		local techniq
		local vce
	}
	capture `methi'
	if _rc | `"`r(method)'"' != "$ML_meth" {
		if _rc!=199 { 
			`methi'
		}
		di in red "unknown method $ML_meth"
		exit 199
	}
	global ML_opt `"`r(opt)'"'
	global ML_tnql `"`r(techlist)'"'	// list of techniques to use
	global ML_tnqk `"`r(numlist)'"'		// steps within each technique
	global ML_tnqi 1			// index for current technique
	global ML_tnqj 1			// step in current technique
	global ML_eval `"`r(eval)'"'
	global ML_evali `"`r(evali)'"'
	global ML_evalf `"`r(evalf)'"'
	global ML_noinv `"`r(noinv)'"'
	global ML_noinf `"`r(noinf)'"'
	global ML_score `"`r(score)'"'
	global ML_vscr `"`r(vscore)'"'
	if "$ML_vce" == "" {
		global ML_vce `"`r(vce)'"'
	}
	global ML_vce2 `"`r(vce2)'"'
	if "`r(scvars)'" != "" {
		global ML_mksc
	}
	local methi
	if `"$ML_opt"'=="" | `"$ML_eval"'=="" {
		if `"$ML_opt"'=="" {
			di in red "method $ML_meth does not specify optimizer"
		}
		if `"$ML_eval"'=="" {
			di in red "method $ML_meth does not specify evaluator"
		}
		di in red "method $ML_meth, program ${ML_eval}_, has an error"
		exit 198
	}
	if "`noscore'" != "" {
		local bhhh bhhh
		local tqlist $ML_tnql
		if "$ML_opt" == "ml_e1_bhhh" | `:list bhhh in tqlist' {
			version 7: di as err ///
"technique {bf:bhhh} is not allowed with option {bf:noscore}"
			exit 198
		}
	}
/* ---- end method description processing -- routine ml_<method>_.ado */


/* process -nopreserve- option */
	global ML_save
	if r(preserve)==1 {
		global ML_save "true"
	}
	else if r(preserve)>=. {
		if "`preserv'"=="" {	/* -nopreserve- not specified */
			global ML_save "maybe"
		}
	}
/* end process -nopreserve- option */


/* process whether robust, cluster(), and pweights allowed */
	if "$ML_vce"=="robust" {
		if `"$ML_score"' == "" {
			version 7: di in red /*
	*/ "method $ML_meth does not allow {bf:pweight}s, option {bf:robust}, or option {bf:cluster()}"
			exit 101
		}
		if "`scvars'" != "" {
			#delimit ;
			version 7: di in red
"{p}method $ML_meth does not allow {bf:pweight}s, option {bf:robust}, or option {bf:cluster()} because "
"you specified option {bf:noscvars}{p_end}" ;
			#delimit cr
			exit 101
		}
	}
/* end process whether robust, cluster(), and pweights allowed */

/* process whether wald test */
	if `waldtes'!=0 {
		if ("$ML_vce"=="robust" | "`lf0'"=="") & `waldtes'<0 {
			local waldtes = abs(`waldtes')
		}
		if `waldtes'>0 {
			global ML_wald `waldtes'
		}
		else	global ML_waldt `waldtes'
	}
/* end process whether wald test */


/* optionally remove collinearity */
	if "`colline'" == "" {
		RmColl
	}
	if "$ML_fvops" == "true" {
		FVexpand
	}
/* end optionally remove collinearity */


/* save dependent variable names in $ML_y`i' */
	tokenize $ML_y
	local i 1
	if "$ML_yn" == "" {
		global ML_yn 0
	}
	while `i' <= $ML_yn {
		global ML_y`i' ``i''
		local i = `i' + 1
	}

	global ML_title `"`title'"'

/* build coefficient vector */
	Build_b

/* set -constraints- option */
	global ML_C 0		// default for no constraints
	if "`constraints'" != "" {
		if (`caller' <= 8.0) {
			if ( ("$ML_x1" != "") | ("`svarconst'" != "") ) {
				tempname b V T a C
				mat `b' = $ML_b
				mat `V' = `b''*`b'
				mat post `b' `V'
				capture mat makeCns `constraints'
				if _rc {
					di in red "Constraints invalid:"
					mat makeCns `constraints'
					exit _rc
				}
				global ML_cns `constraints'  
			}
		}
		else {
			tempname b V T a C
			mat `b' = $ML_b
			mat `V' = `b''*`b'
			mat post `b' `V'
			$ML_vers makecns `constraints', `cnsnotes'
			global ML_cns `r(clist)'
		}
		if "$ML_cns" != "" {
			matcproc `T' `a' `C'
			global ML_C 1
			global ML_CT ML_CT
			global ML_Ca ML_Ca
			global ML_CC ML_CC
			mat $ML_CT = `T'
			mat $ML_Ca = `a'
			mat $ML_CC = `C'
			// constraints imply a model Wald test
			if "$ML_wald" == "" {
				if "`waldtes'" != "" {
					global ML_wald = abs(`waldtes')
				}
				else {
					global ML_wald 1
				}
			}
			local lf0
		}
	}
/* end set -constraints- option */

/* process -lf0()- (or -continue-) option */
	if "`lf0'" != "" {
		local n : word count `lf0'
		if `n'!=2 {
			version 7: di in red "option {bf:lf0(`lf0')} invalid"
			exit 198
		}
		global ML_k0 : word 1 of `lf0'
		global ML_ll_0 : word 2 of `lf0'
		confirm number $ML_ll_0
		confirm integer number $ML_k0
		if $ML_k0 < 0 {				// was $ML_k0 < 1
			version 7: di in red "option {bf:lf0(`lf0')} invalid"
			exit 198
		}
	}

/* Probably fully defined; set status variable ML_stat to "model" */
	global ML_stat "model"


/* determine whether we run (or request our caller run) other routines */

	if `"`init'"'!="" {
		ml_init `init'
	}
	if "`maximiz'"!="" {
		sret local maxcmd `"ml_max, nooutput `options'"'
	}
	else if `"`options'"' != "" {
		local ops = plural(`:word count `options'', "option")
		version 7: di in red "`ops' {bf:`options'} not allowed"
		exit 198
	}
end

program define ParseIL /* [name:] [y1 y2 ... =] [x1 x2 ...] 
				[, nocons offset() linear ]
*/
	tokenize `"`0'"', parse(":[]=,")
	if "`2'" == ":" {
		IsNewEqN `1'
		global ML_eq$ML_n `1'
		mac shift 2
	}
	else 	global ML_eq$ML_n eq$ML_n

	local haseq 0
	while "`1'" != "," & "`1'"!="" {
		if "`1'" == "=" {
			if `haseq' {
				di in red `"(`0')"'
				error 198
			}
			local haseq 1
			global ML_y $ML_y `list'
			local list
		}
		else 	local list `list' `1'
		mac shift
	}

	if "$ML_y" != "" {
		tsunab myy: $ML_y
		global ML_y `myy'
		if "`s(tsops)'" != "" {
			global ML_tsops "true"
		}
		local myy
	}
	global ML_yn : word count $ML_y

	if "`list'" != "" {
		fvunab list: `list'
		global ML_x$ML_n `list'
		if "`s(tsops)'" != "" {
			global ML_tsops "true"
		}
		if "`s(fvops)'" != "" {
			global ML_fvops "true"
		}
	}

	local 0 "`*'"
	syntax [, noCONStant OFFset(varname) EXPosure(varname) Linear ]

	if "`constan'" != "" {
		global ML_xc$ML_n "nocons"
		if "${ML_x$ML_n}" == "" {
			di in red `"(`0')"'
			error 198
		}
	}
	if "`offset'"!="" | "`exposur'"!="" {
		if "`offset'" != "" & "`exposur'" != "" {
version 7: di in red "options {bf:offset()} and {bf:exposure()} may not be specified together"
			error 198
		}
		global ML_xo$ML_n "`offset'"
		global ML_xe$ML_n "`exposure'"
	}
	global ML_xl$ML_n "`linear'"
end

program define ParsePrm /* name */
	IsNewEqN `0'
	global ML_eq$ML_n `0'
end


program define IsName
	local n : word count `0'
	if `n' == 1 {
		capture confirm var `0'
		if _rc == 0 {
			exit
		}
		capture confirm new var `0'
		if _rc ==0 {
			exit
		}
	}
	di in red `"`0' invalid name"'
	exit 198
end

program define IsNewEqN /* name */
	IsName `0'
	local i 1
	while `i' < $ML_n { 		/* <, sic, filling in $ML_n */
		if "`0'" == "${ML_eq`i'}" {
			di in red "Equation/parameter /`0'/ multiply defined"
			exit 110
		}
		local i = `i' + 1
	}
end

                       /*    1     2    3        4      */
program define SetTmpV /* macname <- namestub [varname] */
	args macn junk stub name
	if `"`name'"' != "" {
		local n : word count `name'
		if `n'!=1 {
			error 198
		}
		confirm new var `name'
		global `macn' `"`name'"'
		exit
	}
	local i 1
	capture confirm new var `stub'`i'
	while _rc {
		local i = `i' + 1
		capture confirm new var `stub'`i'
	}
	global `macn' `stub'`i'
end


program define IsLast /* token */, sclass
	if `"`0'"'=="[" | `"`0'"'=="if" | `"`0'"'=="in" | `"`0'"'=="," | /*
	*/ | `"`0'"'=="" {
		sret local cont 0
	}
	else	sret local cont 1
end


program define RmColl
	if "$ML_fvops" == "true" {
		local vv "version 11:"
	}
	local i 1
	while `i' <= $ML_n {
		if "${ML_x`i'}" != "" {
			`vv' _rmcoll ${ML_x`i'} if $ML_samp, ${ML_xc`i'}
			global ML_x`i' "`r(varlist)'"
			global S_1 /* cleanup after out-of-date rmcoll */
		}
		local i = `i' + 1
	}
end

program define MarkOut
	markout $ML_samp $ML_y
	local i 1
	while `i' <= $ML_n {
		markout $ML_samp ${ML_x`i'} ${ML_xo`i'} ${ML_xe`i'}
		if "${ML_xe`i'}" != "" {
			qui replace $ML_samp = 0 if ${ML_xe`i'}<=0
		}
		local i = `i' + 1
	}
end

program define FVexpand
	local i 1
	while `i' <= $ML_n {
		if `"${ML_x`i'}"' != "" {
			fvexpand ${ML_x`i'} if $ML_samp
			global ML_x`i' `r(varlist)'
		}
		local ++i
	}
end

program define Build_b
	if "$ML_fvops" == "true" {
		local vv "version 11:"
	}
	global ML_k 0
	local i 1
	capture mat drop $ML_b
	tempname bi
	while `i' <= $ML_n {
		if "${ML_xc`i'}"=="" {
			local names ${ML_x`i'} _cons
		}
		else	local names ${ML_x`i'}
		global ML_k`i' : word count `names'
		if ${ML_k`i'}==1 & "${ML_xc`i'}"=="" {
			global ML_ip`i' 1
		}
		else	global ML_ip`i' 0
		global ML_fp`i' = $ML_k + 1
		global ML_lp`i' = $ML_k + ${ML_k`i'}

		mat `bi' = J(1,${ML_k`i'},0)
		`vv' mat coleq `bi' = ${ML_eq`i'}
		`vv' mat colnames `bi' = `names'
		mat $ML_b = nullmat($ML_b), `bi'
		global ML_k = $ML_k + ${ML_k`i'}
		local i = `i' + 1
	}
end

program define Init_b /* {skip|error} {check|doit} b0 */
	args skip doit b0
	capture di matrix(`b0'[1,1])
	if _rc {
		di in red "matrix `b0' not found"
		exit 111
	}
	if matrix(rowsof(`b0')!=1 & colsof(`b0')!=1) {
		di in red "`b0': " matrix(rowsof(`b0')) " x " /*
		*/ matrix(colsof(`b0')) " is not a vector"
		exit 503
	}
	if matrix(rowsof(`b0')) != 1 {
		tempname c
		mat `c' = `b0' '
		local b0 `c'
	}
	local eqs : coleq(`b0')
	local nms : colnames(`b0')
	local i 1
	while `i' <= matrix(colsof(`b0')) {
		local eq : word `i' of `eqs'
		local nm : word `i' of `nms'
		local j = matrix(colnumb($ML_b, "`eq':`nm'"))
		if `j'>=. & "`eq'"=="_" {
			local eq ${ML_eq1}
			local j = matrix(colnumb($ML_b, "`eq':`nm'"))
		}
		if `j' < . & "`doit'"=="doit" {
			mat $ML_b[1,`j'] = `b0'[1,`i']
		}
		else if `j'>=. & "`skip'"=="error" {
			di in red "parameter `eq':`nm' not found"
			exit 111
		}
		local i = `i' + 1
	}
end

// Parse the -diparm()- options, putting the contents into globals of the form
// ML_diparm#.  The global ML_diparms contains the number of -diparm()-
// options.
program ParseDiparmOpts
	version 9, missing
	_get_diparmopts, diparmopts(`0') soptions syntaxonly
	forval k = 1/`s(k)' {
		global ML_diparm`k' `"`s(diparm`k')'"'
	}
	global ML_diparms `s(k)'
end

program CheckCollinear
	syntax [, COLlinear *]
	c_local options `"`options'"'
end
exit
