*! version 7.2.6  21may2015
program define _nlogit, eclass byable(onecall)
	version 8.2, missing
	version 7.0, missing
	local caller : display string(_caller())

	if replay() {
		if "`e(cmd)'" != "_nlogit" { error 301 }
		if _by() { error 190 }
		Replay `0'
		exit
	}
	if _by() {
		cap noi by `_byvars' `_byrc0': Estimate `0'
	}
	else version `caller', missing: cap noi Estimate `0'
	local rc = _rc
	mac drop nlog_*
	exit `rc'
end

program define Estimate, eclass byable(recall) sort
	version 7.0, missing
	local caller : display string(_caller())
							/* BEGIN parse */
	gettoken dep 0 : 0, parse(" (")	/* dependent variable (0,1) */
	unab dep : `dep'
	confirm numeric variable `dep'

	gettoken first rest : 0, match(par) parse(" [,")
	global nlog_iv 0
	local k = 0
	while "`par'" == "(" {
		local k = `k' + 1
		gettoken level`k' second : first, parse(" =")
		confirm numeric var `level`k''
		unab level`k' : `level`k''
		gettoken eq left : second, parse(" =")
		if "`eq'" == "=" {
			local second `left'
		}
		local 0 `second'
		syntax varlist(numeric) 
		local ind`k' `varlist'
		local inds `inds' `ind`k''	/* full independent variables */
		local levels `levels' `level`k''
		local 0 `rest'
		gettoken first rest : 0, match(par) parse(" [,")
	}
	syntax [if] [in] [fw iw], GRoup(varname) [noTRee noLABel CLOgit   /*
		*/ Level(passthru) noLOg  Robust  d1 from(string)	  /*
		*/ IVConstraints(string) CONSTraints(numlist) debug       /*
		*/ vce(string) * ]

	// -vce(ROBust)- is a synonym for -ROBust-
	if `"`vce'"' == bsubstr("robust",1,max(1,length("`vce'"))) {
		local robust robust
		local vce
	}
	else if `"`vce'"' != "" {
		local vce `"vce(`vce')"'
	}

	/* undocumented from() option used for quicker testing */
						/* END parse */

						/* mark sample */
	marksample touse
	markout `touse' `dep' `deps' `inds' `group' `levels'

	if ("`tree'" == "") & (`k' >= 2) {	/* BEGIN display tree */
	 	nlogittree `levels' if `touse', `label' nobranch
	}
	tempvar dep1
	qui gen byte `dep1' = (`dep' != 0) if `touse'
	qui tab `dep1'
	if r(r) != 2 {
		dis as err "outcome does not vary in any group"
		exit 2000
	}
						/* END display tree */
	tempvar junk newgp
	qui gen double `newgp' = `group' if `touse'
	qui bysort `newgp': gen `junk' = sum(`touse')
	qui by `newgp' : replace `touse' = 0 if `junk'[_N] < _N
	ChkDta `level1' `newgp'	`touse'		/* check data balance */
	tempname kmin kmax kmean ngroup
	scalar `kmin' = r(min)
	scalar `kmax' = r(max)
	scalar `kmean' = r(mean)
	scalar `ngroup' = r(N)
	qui count if `touse'
	local n0 = r(N)
					/* assert 1 positive outcome
					   per group. markout otherwise */

	qui bysort `newgp': replace `junk' = sum(`dep1')
	qui by `newgp' :  replace `touse' = 0 if `junk'[_N] != 1
	qui count if `touse'
	local ndrop = `n0' - r(N)
	if `ndrop' > 0 {
		ChkDta `level1' `newgp' `touse'

		local dgroup = `ngroup'-`r(N)'
		scalar `kmin' = r(min)
		scalar `kmax' = r(max)
		scalar `kmean' = r(mean)
		scalar `ngroup' = r(N)
		dis as txt _n ///
"note: `dgroup' groups (`ndrop' obs) dropped because of no positive outcome"
dis as txt "      or multiple positive outcomes per group"
	}

	local wtype `weight'
	local wtexp `"`exp'"'
						/* check weight */
	if "`weight'" != "" {
		tempvar chkwght
		qui gen `chkwght' `exp'
		cap bysort `newgp': assert `chkwght' == `chkwght'[1] if `touse'
		if _rc {
			dis as err /*
		*/ "weights must be the same for all observations in a group"
			exit 407
		}
	 	local wgt `"[`weight'`exp']"'
	}

	mlopts mlopts, `options'
	local coll `s(collinear)'
	local cns "`s(constraints)'"
	if "`s(technique)'" == "" {
		local tech technique(bfgs)
	}

				/* model checking
				1. drop ind if it has no within-group variance
				2. exit if ind is not a characteristic of
				   the corresponding utility */
	local i 1
	while `i' <= `k' {
		local inds
		foreach ind of local ind`i' {
			cap bysort `newgp' : assert `ind' == `ind'[1] if `touse'
			if !_rc {
				dis as txt /*
				*/ "note: `ind' omitted because of no" /*
				*/ " within-group variance"
			}
			else local inds `inds' `ind'
			cap bysort `newgp' `level`i'': ///
				assert `ind' == `ind'[1] if `touse'
			if _rc {
				dis as err "`ind' is not a characteristic of"/*
				*/ " `level`i'', model is unidentified."
				exit 459
			}
		}
		if "`inds'" == "" {
			dis as err /*
			*/ "no independent variables for `level`i'' model"
			exit 102
		}
		/* remove collinearity */
		_rmcoll `inds' if `touse', `coll'
		local ind`i' `r(varlist)'
		local inda `inda' `inds'
		local i = `i' + 1
	}

	if `caller' <= 8.0 {
		// overide technique() only under version control
		if "`s(technique)'" == "" & ///
		("`cns'" != "" | "`d1'" == "d1" | `k' > 3) {
			local tech technique(nr)
		}
	}

	local d1	// ignored, but kept for backward compatibility
	forvalues i=1/`k' {
		Tabulate `level`i'' if `touse'
		if r(r) == 1 {
			dis as err "choice of `level`i'' does not vary"
			exit 459
		}
		tempvar temp`i'
		qui egen `temp`i'' = group(`level`i'') if `touse', label
	}
	if `k' < 2 {
	dis as txt "note: nonnested model, results are the same as -clogit-"
	}
					/* BEGIN getting initial values
					         setting up ml models */
	tempname tm
	local bylist
	local i `k'
	while `i' > 1 {
		local taui
 		local bylist `bylist' `level`i''
		tempvar dep`i'			/* dep for level i */
		version 8: _labels2names `temp`i'' if `touse', /* 
			*/ stub(`level`i'') noint
		local labels `"`s(names)'"'
		local m = `s(n_cat)'
		local tn  `m' `tn'
		local i1 = `i'-1
		if `i' == `k' {
			tempname Tlev`i1' T`i1'
			qui tab `temp`i'' if `touse', matrow(`Tlev`i1'')
			matrix `T`i1'' = J(1,1,0)
			matrix `T`i1''[1,1] = `m'
			matrix `Tlev`i1'' = `Tlev`i1'''
			global nlog_T`i1' `T`i1''
			global nlog_Tlev`i1' `Tlev`i1''
		}
		
		local i2 = `i1'-1
		if `i2' > 0 {
			tempname T`i2' Tlev`i2'
			matrix `T`i2'' = J(1,`m',0)
			global nlog_T`i2' `T`i2''
			global nlog_Tlev`i2' `Tlev`i2''
		}
		local j 1
		while `j' <= `m' {		/* taus for level i */
			local tauij : word `j' of `labels'
			local taui `taui' /`tauij'
		
			if `i2' > 0 {	
				qui tab `temp`i1'' if `touse' & /*
					*/ `temp`i''==`j', matrow(`tm')
				matrix `T`i2''[1,`j'] = r(r)
				matrix `Tlev`i2'' = (nullmat(`Tlev`i2''),`tm'')
			}
				
			local j = `j' + 1
		}

		local tau `taui' `tau'       /* taus for ml */
		qui sort `newgp' `bylist'
		qui by `newgp' `bylist' : gen `dep`i'' = sum(`dep1')
		qui by `newgp' `bylist' : replace `dep`i'' = `dep`i''[_N]

						/* ml main eqs */
		local maineq (`level`i'': `dep`i'' `temp`i'' = `ind`i'', /*
			*/ nocons)   `maineq'
		preserve
		cap noi {
			qui by `newgp' `bylist' : keep if _n == _N
			qui clogit `dep`i'' `ind`i'' `wgt' if `touse', ///
				group(`newgp')
		}
		restore
		if _rc { exit _rc }
		tempname b`i' V`i' s`i'
		mat `b`i'' = e(b)
		mat coleq `b`i'' = `level`i''
		mat `V`i'' = e(V)
		mat `s`i'' = vecdiag(`V`i'')
		local i = `i' - 1
	}
	qui clogit `dep' `ind1' `wgt' if `touse', group(`newgp')
	local maineq (`level1': `dep1' `temp1' = `ind1', nocons) `maineq'
	tempname b0 V0 s0
	mat `b0' = e(b)
	mat coleq `b0' = `level1'
	mat `V0' = e(V)
	mat `s0' = vecdiag(`V0')
	local i = 2
	while `i' <= `k' {
		mat `b0' = `b0', `b`i''
		mat `s0' = `s0', `s`i''
		local i = `i' + 1
	}
	mat `V0' = diag(`s0')
	local rname : colfullnames `b0'
	mat rownames `V0' = `rname'
	mat colnames `V0' = `rname'
	tempname b
	mat `b' = `b0'
	est post `b' `V0'
	if "`clogit'" != "" {
		dis _n
		dis as txt "Initial values obtained using clogit" _c
		dis as txt _col(14) "Dependent variable = " _c
		dis as res %8s abbrev("`dep'",8)
		est display
	}
	if `"`constraints'"' != "" {
		foreach j of local constraints {
			cons get `j'
			if !r(defined) {
				di as err "constraint `j' undefined"
				exit 198
			}
		}
		version 8.2: makecns `constraints', nocnsnotes

		tempname T a C
		cap matcproc `T' `a' `C'
		if _rc == 0 {
			qui mat drop `T' `a'
			local conopt constraints(`C')
			local waldopt waldtest(`k')
		}
	}
	local t : word count `tau'
	local name : subinstr local tau "/" "", all
	if "`ivconstraints'" != "" {
		Ivset "`name'" "`ivconstraints'"
		local ivcons `s(ivlist)'
	}
	if `"`constraints'"' != "" | "`ivcons'" != "" {
		local constr "constraints(`constraints' `ivcons')"
	}
	if `k' > 1 {
		tempname T
		mat `T' = J(1,`t',1)
		mat colnames `T' = `name'
		mat `b0' = `b0',`T'
	}
	tempname TN
	global nlog_l = `k'		/* # of levels */
	global nlog_t = `t'		/* # of taus */
	global nlog_T nlog_T
	mat input `TN' = (`tn')
	mat $nlog_T = `TN'
	global nlog_id `group'
					/* END getting initial values
					       setting up ML eqs */
	if "`constr'" != "" {
		di
		dis as txt "User-defined constraints: "
		if `"`constraints'"' != "" {
			constraint list `constraints'
		}
		if `"`ivcons'"' != "" {
			dis as txt "    IV constraints:"
			foreach j of local ivcons {
				cons get `j'
				di _col(10) as res `"`r(contents)'"'
			}
		}
	}
					/* get ll_0 constant only
					   and ll_clogit */

	version 8.2: qui clogit `dep' `inda' `wgt' if `touse', ///
		group(`newgp') `conopt'
	local ll_c = e(ll)
	local ll_0 = e(ll_0)
	local df_mc = e(df_m)
	forvalues i=1/`=`k'+`t'' {
		global nlog_clist $nlog_clist c`i'
	}
	if "`from'" != "" {
		local initopt init(`from') search(off) 
	}
	else {
		local initopt init(`b0',copy)
	}
	if "`robust'" != "" {
		forvalues i=1/`=`k'+`t'' {
			tempname s`i'
			local slist `slist' `s`i''
		}
		local critopt "crittype(log pseudolikelihood)"
		local scropt score(`slist') nopreserve
	}
					/* BEGIN calling ml model */
	if "`debug'" == "" {
		version 8.1: ///
		ml model d1 nlog_rd `maineq' `tau' `wgt' if `touse',    /*
                */ `constr' `initopt' `tech' `scropt' `waldopt' max     /*
                */ miss `mlopts' `log' title("Nested logit regression") /*
		*/ `critopt'
	}
	else {
		version 8.1: ///
		ml model d1debug nlog_rd `maineq' `tau' `wgt' if `touse', /*
                */ `constr' `initopt' trace gradient showstep max miss    /*
                */ `waldopt' `mlopts' title("Nested logit regression")    /*
		*/ `scropt' `critopt'
	}
	if "`robust'" != "" {
		if "`weight'" != "" {
			gettoken tok exp : exp, parse("=") 
			if "`weight'"=="fweight" {
				local exp `"sqrt(`exp')"'
			}
			local wopt `"[iw=`exp']"'
		}
		tempname V
		mat `V' = e(V)
		_ROBUST `slist' `wopt' if `touse', var(`V') minus(0) ///
			cluster(`newgp') 
		mat `V' = `ngroup'/(`ngroup'-1) * `V'

		est repost V = `V'
		est local vcetype "Robust"
	}
	if "`waldopt'" == "" {
		local chi2 = -2*(`ll_0'- e(ll) )
		est scalar ll_0 = `ll_0'
		est scalar chi2 = `chi2'
		est scalar p = chiprob(e(rank), `chi2')
		est local chi2type "LR"
		est scalar df_m = e(rank)
	}
	else {
		est local k_eq_model
	}
	local chi2_c = -2 * (`ll_c' - e(ll))
	est scalar N_g = `ngroup'
	est scalar levels = `k'
	est scalar ll_c = `ll_c'
	est scalar df_mc = `df_mc'
	est scalar chi2_c = `chi2_c'
	est scalar p_c = chiprob(e(rank)-`df_mc', `chi2_c')
	est scalar alt_min = `kmin'
	est scalar alt_max = `kmax'
	est scalar alt_avg = `kmean'
	est local k
	est local k_dv
	est local predict "_nlogit_p"
	est local group "`group'"
	est local iv_names "`name'"
	forvalues i = 1/`k' {
		local j = `k' - `i' + 1
		est local level`j' "`level`i''"
	}
	est local depvar "`dep'"
	est matrix n_alters  $nlog_T
	est local cmd "_nlogit"
	if `"`ivcons'"' != "" {
		constraint drop `ivcons'
	}
	Replay, `level'

	mac drop nlog_*
end

program define ChkDta, rclass
	args dep group touse
	Tabulate `dep' if `touse'
	local r = r(r)
	tempvar junk
	qui bysort `group': gen `c(obs_t)' `junk' = _N
	cap by `group': assert `junk'[1] == `r' if `touse'
	global nlog_unbal = (_rc > 0)
	if $nlog_unbal {
		cap by `group': assert `junk'[1] <= `r' if `touse'
		if _rc {
di as error "variable `dep' has replicate alternatives for one or more groups; this is not allowed"
                	exit 459
	        }
	}
	qui bysort `group': replace `junk' = . if _n>1
	summarize `junk' if `touse', meanonly

	return add
end

program define Ivset, sclass
	args name content
	gettoken first rest : content, parse(" =,")
	while "`first'" != "" {
		local junk : subinstr local name "`first'" "`first'", /*
		*/ all count(local t)
		if ! `t' {
			dis as err "`first' not found"
			exit 198
		}
		gettoken eq rest : rest, parse(" =,")
		if "`eq'" != "=" {
			dis as err "'`eq'' found where '=' is expected"
			exit 198
		}
		gettoken second rest: rest, parse(" =,")
		cap confirm number `second'
		constraint free
		local i `r(free)'
		if _rc {
			local junk: subinstr local name "`second'"   /*
			*/ "`second'",	all count(local t)
			if !`t' {
				dis as err "`second'" not found"
				exit 198
			}
			qui constraint define `i'  /*
			*/ [`first']_cons=[`second']_cons
		}
		else {
			qui constraint define `i'  [`first']_cons = `second'
		}
		local ivlist `ivlist' `i'
		gettoken first rest : rest, parse(" =,")
		if "`first'" == "," {
			gettoken first rest : rest, parse(" =,")
		}
	}
	sret local ivlist `ivlist'
end

program define Replay
	syntax [, level(passthru)]
	#delimit ;
	di as txt _n "`e(title)'";
	di as txt "Levels             = " as res %10.0f e(levels)
		as txt _col(49) "Number of obs"
		as txt _col(68) "="
		as res _col(70) %9.0g e(N) ;
	di as txt "Dependent variable =   "
		as res %8s abbrev("`e(depvar)'", 8)
		as txt _col(49) "`e(chi2type)' chi2(" as res e(df_m) as txt ")"
		as txt _col(68) "="
		as res _col(70) %9.0g e(chi2) ;
	di as txt "Log likelihood     = " as res %10.0g e(ll)
		as txt _col(49) "Prob > chi2"
		as txt _col(68) "="
		as res _col(73) %6.4f chiprob(e(df_m),e(chi2)) _n ;
	#delimit cr
	local k = e(levels)
	estimates display, `level' neq(`k') plus
	dis as txt "(incl. value" as txt _col(14) "{c |}"
	dis as txt " parameters)" as txt _col(14) "{c |}"
	local i = `k' - 1
	if `i' == 0 {
		dis as txt %12s "(none)" as txt " {c |}"
	}
	tempname nalt
	mat `nalt' = e(n_alters)
	local name "`e(iv_names)'"
	tokenize `name'
	local point = 1
	while `i' > = 1 {
		local varname "`e(level`i')'"
		dis as res abbrev("`varname'", 12) as txt _col(14) "{c |}"
		local j = `k' - `i'
		local s = `nalt'[1,`j']
		local h = 1
		while `h' <= `s' {
			_diparm ``point'', `level'
			local h = `h' + 1
			local point = `point' + 1
		}
		local i = `i' - 1
	}

	di in smcl as txt "{hline 13}{c BT}{hline 64}"

	if e(rank)-e(df_mc) > 0 {
		local chi : di %8.2f e(chi2_c)
		local chi = trim("`chi'")
		
		di as txt "LR test of homoskedasticity (iv=1): " ///
			 "chi2(" as res e(rank)-e(df_mc) as txt ") = " ///
			 as res "`chi'" ///
			 _col(59) as txt "Prob > chi2 = " as res %6.4f e(p_c)
	}
end

program Tabulate, rclass
	syntax varname [if]
	
	cap tab `varlist' `if'
	if _rc == 134 {
		di as err "{p}exceeded the limits of {cmd:tabulate} when " ///
		 "tabulating the number of alternatives in variable "     ///
		 "`varlist'; you probably misspecified the variable; "  ///
		 "see help {help limits}{p_end}"
		exit 134
	}
	else if _rc {
		local rc = _rc
		di as err "{p}tabulate failed when attempting to count " ///
		 "the number of alternatives in variable `varlist'{p_end}"
		exit `rc'
	}
	return add
end

exit

ml model :

main eqs:

(dep1 level1 = ind1 ) (dep2 level2 = ind2) ... (depk levelk
= ind8)

taus : the labels for each cat of each level.


ml method:

d0 for models have higher levels ( >3 )
rdu1, for levels <= 3, it is faster than d1, but not as well behaved as d1.
d1 for levels <= 3 & `constraints' != "", or if user specifies d1.


