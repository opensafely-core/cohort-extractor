*! version 1.3.5  15apr2015
program define mlogit_p_10 /* predict for mlogit and svymlogit */
	if "`e(cmd)'"!="mlogit" & "`e(cmd)'"!="svymlogit" {
		error 301
	}
	if e(k_out) < . {
		global MLOG_ibs ibaseout
		global MLOG_cat out
	}
	else {
		assert e(k_cat) < .
		global MLOG_ibs ibasecat
		global MLOG_cat cat
	}
	cap noi MlogitPred `0'
	local rc = _rc
	mac drop MLOG_ibs 
	mac drop MLOG_cat
	exit `rc'
end

program MlogitPred
	version 6, missing

/* Parse. */

	ParseNewVars `0'
	local varspec `s(varspec)'
	local varlist `s(varlist)'
	local typlist `s(typlist)'
	local nvars : word count `varlist'
	local if `"`s(if)'"'
	local in `"`s(in)'"'
	local options `"`s(options)'"'

	ParseOptions, `options'
	local equatio `"`s(outcome)'"'
	local type `s(type)'
	if "`type'" != "" {
		local `type' `type'
	}
	else {
		if `"`equatio'"' != "" {
			version 8: di ///
			"{txt}(option {bf:pr} assumed; predicted probability)"
		}
		else {
			version 8: di ///
			"{txt}(option {bf:pr} assumed; predicted probabilities)"
		}
	}

/* Check syntax. */

	if `nvars' > 1 {
		if `"`equatio'"' != "" {
			if inlist("`type'", "", "pr") {
				local tt "p with outcome()"
			}
			else	local tt `type'
			Onevar "`tt'" `varlist'
		}
		else {
			MultVars `varlist'
		}
		if `"`equatio'"' != "" {
			di as err ///
"option outcome() is not allowed when multiple new variables are specified"
			exit 198
		}
		if !inlist("`type'","","pr","scores") {
			di as err ///
			"option `type' requires the outcome() option"
			exit 198
		}
	}
	else if inlist("`type'","","pr","scores") & `"`equatio'"' == "" {
		MultVars `varlist'
	}
	else if `"`equatio'"' == "" {
		di as err ///
		"option `type' requires the outcome() option"
		exit 198
	}

/* Process equation/outcome. */

	if `"`equatio'"'!="" {
		local eqorig `"`equatio'"'

		if "`e(cmd)'`e(prefix)'"!="mlogit" {
			EqNo "`type'" `equatio'
			local equatio `"`s(eqno)'"'
				/* this is empty if basecategory selected */
			if "`s(stddp)'"=="stdp" {
				local stddp "stdp"
			}
				/* local stddp is changed to stdp if
				   basecategory selected as one of the
				   equations
				*/
		}
		else if `"`type'"' == "stddp" {
			EqNo2 "`type'" `equatio'
			local equatio `"`s(eqno)'"'
		}

		local eqopt `"equation(`"`equatio'"')"'
	}

/* scores */

	if `"`type'"' == "scores" {
		if `"`equatio'"' != "" {
			local type `"equation(`equatio')"'
		}
		GenScores `varspec' `if' `in', `type'
		sret clear
		exit
	}

/* Index, XB, or STDP. */

	if "`type'"=="index" | "`type'"=="xb" | "`type'"=="stdp" /*
	*/ | "`type'"=="stddp" {

		Onevar `type' `varlist'

		if "`equatio'"!="" {
			_predict `typlist' `varlist' `if' `in', /*
			*/ ``type'' `eqopt' 
					/* note: `type' may be stddp,
					   but ``type'' may be stdp
					*/
		}
		else	Zero `typlist' `varlist' `if' `in' 

		if "`type'"=="index" | "`type'"=="xb"  {
			Outcome `equatio'
			label var `varlist' /*
		*/ `"Linear prediction, `e(depvar)'==`s(outcome)'"'
		}
		else if "`type'"=="stdp"  {
			Outcome `equatio'
			label var `varlist' /*
		*/ `"S.E. of linear prediction, `e(depvar)'==`s(outcome)'"'
		}
		else /* stddp */ label var `varlist' `"stddp(`eqorig')"'

		sret clear
		exit
	}

/* Probability with outcome() specified: create one variable. */

	if ("`type'"=="pr" | "`type'"=="") & `"`eqopt'"'!="" {
		Onevar "p with outcome()" `varlist'

		if "`e(cmd)'`e(prefix)'"=="mlogit" {
			_predict `typlist' `varlist' `if' `in', `eqopt' 
		}
		else { /* svymlogit */
			OnePsvy `typlist' `varlist' `if' `in', `eqopt' 
		}

		Outcome `equatio'
		label var `varlist' `"Pr(`e(depvar)'==`s(outcome)')"'
		sret clear
		exit
	}

/* Probabilities with outcome() not specified: create e(k_cat) variables. */

	tempvar touse
	mark `touse' `if' `in'

	if "`e(cmd)'`e(prefix)'"=="mlogit" {
		AllPmlog "`typlist'" "`varlist'" `touse' 
	}
	else if "`e(prefix)'" != "" {
		AllPsvy "`typlist'" "`varlist'" `touse' 
	}
	else { /* svymlogit */
		OldPsvy "`typlist'" "`varlist'" `touse' 
	}
end

program MultVars
	local nvars : word count `0'
	if "`s(type)'" == "scores" {
		local s_out = e(k_$MLOG_cat) - 1
		if `nvars' != `s_out' {
		capture noisily error cond(`nvars'<`s_out', 102, 103)
                di in red /*
                */ "`e(depvar)' has `e(k_$MLOG_cat)' outcomes and so you " /*
                */ "must specify `s_out' new variables with the score option
                exit cond(`nvars'<`s_out', 102, 103)
		}
	}
	else if `nvars' != e(k_$MLOG_cat) {
		capture noisily error cond(`nvars'<e(k_$MLOG_cat), 102, 103)
		di in red /*
		*/ "`e(depvar)' has `e(k_$MLOG_cat)' outcomes and so you " /*
		*/ "must specify `e(k_$MLOG_cat)' new variables, or " _n /*
		*/ "you can use the outcome() option and specify " /*
		*/ "variables one at a time"
		exit cond(`nvars'<e(k_$MLOG_cat), 102, 103)
	}
end

// generate a variable that identifies observations that take on a value
// identified by an mlogit equation
program GenD
	version 8.2, missing
	gettoken d 0 : 0
	syntax [if] [in] [, eq(string) ]
	local ieq = bsubstr("`eq'",2,.)
	marksample doit
	local depvar `e(depvar)'
	tempname cat
	mat `cat' = e($MLOG_cat)
	if e($MLOG_ibs) == 1 {
		mat `cat' = `cat'[1,2...]
	}
	else if e($MLOG_ibs) == colsof(`cat') {
		mat `cat' = `cat'[1,1..`=e($MLOG_ibs)-1']
	}
	else {
		mat `cat' = `cat'[1,1..`=e($MLOG_ibs)-1'], ///
			    `cat'[1,`=e($MLOG_ibs)+1'...]
	}
	scalar `cat' = `cat'[1,`ieq']
	gen byte `d' = (reldif(`cat',`depvar') < 1e-7) if `doit'
end

program define Outcome, sclass
	version 6
	if "`e(cmd)'`e(prefix)'"=="mlogit" {
		local o = trim(`"`0'"')
		if bsubstr(`"`o'"',1,1)=="#" {
			local i = bsubstr(`"`o'"',2,.)
			if `i' >= e($MLOG_ibs) {
				local i = `i' + 1
			}
			sret local outcome = el(e($MLOG_cat),1,`i')
		}
		else	sret local outcome `"`o'"'
		exit
	}

/* If here, command is svy[:]mlogit.

   Either "`0'"=="#`i'" (no spaces) or "`0'"=="" (meaning basecategory).
*/
	if "`0'"=="" {
		sret local outcome = bsubstr(`"`e(baselab)'"',1,8)
		exit
	}
	local i = bsubstr("`0'",2,.)
	local coleq : coleq e(b), quote
	local coleq : list clean coleq
	local coleq : list uniq coleq
	sret local outcome : word `i' of `coleq'
end

program define Onevar
	gettoken option 0 : 0
	local n : word count `0'
	if `n'==1 { exit }
	di in red "option `option' requires that you specify 1 new variable"
	error cond(`n'==0,102,103)
end

program define EqNo2, sclass
	sreturn clear
	gettoken type 0 : 0
	if `"`type'"' != "stddp" {
		sreturn local eqno `"`0'"'
		exit
	}

	gettoken eq1 0 : 0, parse(" ,")
	gettoken comma eq2 : 0, parse(",")
	if `"`comma'"' != "," {
		di in red "second equation not found"
		exit 303
	}
	sreturn local eqno `"`eq1',`eq2'"'
end

program define EqNo, sclass
	sret clear
	gettoken type 0 : 0
	if "`type'"!="stddp" {
		Eq `0'
		exit
	}

/* If here, "`type'"=="stddp". */

	gettoken eq1 0 : 0, parse(",")
	gettoken comma eq2 : 0, parse(",")
	if "`comma'"!="," {
		di in red "second equation not found"
		exit 303
	}

	Eq `eq1'
	local eq1 `"`s(eqno)'"'
	Eq `eq2'
	if `"`eq1'"'!="" & `"`s(eqno)'"'!="" {
		sret local eqno `"`eq1',`s(eqno)'"'
	}
	else {
		sret local eqno `"`eq1'`s(eqno)'"'
		sret local stddp "stdp"
	}
end

program define Eq, sclass /* returns nothing if basecategory */
	sret clear
	local eqlab = trim(`"`0'"')
	if bsubstr(`"`eqlab'"',1,1)=="#" {
		sret local eqno `"`eqlab'"'
		exit
	}
	capture confirm number `eqlab'
	if _rc == 0 {
		local i 1
		while `i' <= e(k_$MLOG_cat) {
			if `eqlab' == el(e($MLOG_cat),1,`i') {
				Match `i'
				exit
			}
			local i = `i' + 1
		}
	}
	else {
		if "`e(prefix)'" != "" & "`e(cmd)'" == "mlogit" {
			local coleq : coleq e(b), quote
			local coleq : list uniq coleq
			local qeqlab `"`"`eqlab'"'"'
			local xx :list qeqlab in coleq
			local baselab `"`e(baselab)'"'
			if `:list eqlab in baselab' {
				exit
			}
			if `:list qeqlab in coleq' {
				local i : list posof `"`eqlab'"' in coleq
				if `i' >= e($MLOG_ibs) {
					local ++i
				}
				Match `i'
				exit
			}
		}
		else {
			tempname cat cati
			mat `cat' = e($MLOG_cat)
			local i 1
			while `i' <= e(k_$MLOG_cat) {
				mat `cati' = `cat'[1,`i'..`i']
				local eqi : coleq `cati'
				if `"`eqlab'"'==trim(`"`eqi'"') {
					Match `i'
					exit
				}
				local i = `i' + 1
			}
		}
	}

	di in red `"equation `eqlab' not found"'
	exit 303
end

program define Match, sclass /* returns nothing if basecategory */
	args i
	if `i' != e($MLOG_ibs) {
		local i = cond(`i'<e($MLOG_ibs),`i',`i'-1)
		sret local eqno "#`i'"
	}
end

program define Zero
	syntax newvarname [if] [in] 
	tempvar xb
	qui _predict double `xb' `if' `in' 
	gen `typlist' `varlist' = 0 if `xb'<.
end

program define OnePsvy
	version 6, missing
	syntax newvarname [if] [in] [, Equation(string) ]
	tempvar touse den xb
	mark `touse' `if' `in'

/* This command is only called with equation() in #eqno form, or
   with equation() empty signifying basecategory.
*/
	local equatio = bsubstr(`"`equatio'"',2,.)

	quietly {

/* Compute denominator `den' = 1 + Sum(exp(`xb')). */

		gen double `den' = 1 if `touse'
		local i 1
		while `i' < e(k_$MLOG_cat) {
			_predict double `xb' if `touse', eq(#`i') xb 
			replace `den' = cond(`xb'<. & exp(`xb')>=., /*
			*/ cond(`den'<0,`den'-1,-1), `den'+exp(`xb')) /*
			*/ if `touse'

			if "`i'"=="`equatio'" {
				tempvar xbsel
				rename `xb' `xbsel'
			}
			else	drop `xb'

					/* If `den'<0, then `den'==+inf.

					   If `den'==-1, then there is just
					   one +inf: p=0 if exp(`xbsel')<.,
					   and p=1 if exp(`xbsel')>=. (i.e.,
					   requested category gave the +inf).

					   If `den' < -1, then there are two
					   or more +inf: p=0 if exp(`xbsel')<.;
					   and p=. if exp(`xbsel')>=. (since we
					   cannot say what its value should be).
					*/

			local i = `i' + 1
		}
	}


/* Noisily compute probability of selected category. */

	if "`equatio'"=="" { /* basecategory */
		gen `typlist' `varlist' = cond(`den'>0,1/`den',0) if `touse'
	}
	else if "`xbsel'"=="" { /* equation not found */
		di in red `"equation #`equation' not found"'
		exit 303
	}
	else {
		gen `typlist' `varlist' = cond(`den'>0,exp(`xbsel')/`den', /*
		*/ cond(exp(`xbsel')<.,0,cond(`den'==-1,1,.))) if `touse'
	}
end

program define AllPmlog
	args typlist varlist touse 
	quietly {
		tempname miss
		local same 1
		mat `miss' = J(1,`e(k_$MLOG_cat)',0)
		local i 1
		while `i' <= e(k_$MLOG_cat) {
			tempvar p`i'
			local typ : word `i' of `typlist'
			local val = el(e($MLOG_cat),1,`i')
			_predict `typ' `p`i'' if `touse', eq(`val') 
			count if `p`i''>=.
			mat `miss'[1,`i'] = r(N)
			if `miss'[1,`i']!=`miss'[1,1] {
				local same 0
			}
			label var `p`i'' `"Pr(`e(depvar)'==`val')"'
			local i = `i' + 1
		}
	}
	tokenize `varlist'
	local i 1
	while `i' <= e(k_$MLOG_cat) {
		rename `p`i'' ``i''
		local i = `i' + 1
	}
	ChkMiss `same' `miss' `varlist'
end

program define AllPsvy
	args typlist varlist touse 
	quietly {
		tempvar den tmp
		tempname miss cat

	/* Compute denominator `den' = 1 + Sum(exp(`xb')). */

		gen double `den' = 1 if `touse'
		local i 1
		while `i' < e(k_$MLOG_cat) {
			tempvar xb
			_predict double `xb' if `touse', eq(#`i') xb 
			replace `den' = cond(`xb'<. & exp(`xb')>=., /*
			*/ cond(`den'<0,`den'-1,-1), `den'+exp(`xb')) /*
			*/ if `touse'
					/* see comments in OnePsvy */

			if `i' < e($MLOG_ibs) {
				local p`i' `xb'
				local i = `i' + 1
			}
			else {
				local i = `i' + 1
				local p`i' `xb'
			}
		}

	/* Compute probabilities. */

		local same 1
		mat `miss' = J(1,`e(k_$MLOG_cat)',0)
		mat `cat' = e($MLOG_cat)
		local i 1
		while `i' <= e(k_$MLOG_cat) {
			local typ : word `i' of `typlist'

			if `i'==e($MLOG_ibs) { /* basecategory */
				tempvar p`i'
				gen `typ' `p`i'' = cond(`den'>0,1/`den',0) /*
				*/ if `touse'
				local eqi `"`e(baselab)'"'
			}
			else {
				gen `typ' `tmp' = cond(`den'>0, /*
				*/ exp(`p`i'')/`den', /*
				*/ cond(exp(`p`i'')<.,0, /*
				*/ cond(`den'==-1,1,.))) /*
				*/ if `touse'
				drop `p`i''
				rename `tmp' `p`i''
				if `i' < e($MLOG_ibs) {
					local eqi : word `i' of `e(eqnames)'
				}
				else {
					local ip1 = `i' - 1
					local eqi : word `ip1' of `e(eqnames)'
				}
			}

		/* Count # of missings. */

			count if `p`i''>=.
			mat `miss'[1,`i'] = r(N)
			if `miss'[1,`i']!=`miss'[1,1] {
				local same 0
			}

		/* Label variable. */

			label var `p`i'' `"Pr(`e(depvar)'==`eqi')"'

			local i = `i' + 1
		}
	}

	tokenize `varlist'
	local i 1
	while `i' <= e(k_$MLOG_cat) {
		rename `p`i'' ``i''
		local i = `i' + 1
	}
	ChkMiss `same' `miss' `varlist'
end

program define OldPsvy
	// NOTE: do not update this subroutine, it is for use with svymlogit
	// which has been replaced by svy:mlogit

	args typlist varlist touse 
	quietly {
		tempvar den tmp
		tempname miss cat cati

	/* Compute denominator `den' = 1 + Sum(exp(`xb')). */

		gen double `den' = 1 if `touse'
		local i 1
		while `i' < e(k_cat) {
			tempvar xb
			_predict double `xb' if `touse', eq(#`i') xb 
			replace `den' = cond(`xb'<. & exp(`xb')>=., /*
			*/ cond(`den'<0,`den'-1,-1), `den'+exp(`xb')) /*
			*/ if `touse'
					/* see comments in OnePsvy */

			if `i' < e(ibasecat) {
				local p`i' `xb'
				local i = `i' + 1
			}
			else {
				local i = `i' + 1
				local p`i' `xb'
			}
		}

	/* Compute probabilities. */

		local same 1
		mat `miss' = J(1,`e(k_cat)',0)
		mat `cat' = e(cat)
		local i 1
		while `i' <= e(k_cat) {
			local typ : word `i' of `typlist'

			if `i'==e(ibasecat) { /* basecategory */
				tempvar p`i'
				gen `typ' `p`i'' = cond(`den'>0,1/`den',0) /*
				*/ if `touse'
			}
			else {
				gen `typ' `tmp' = cond(`den'>0, /*
				*/ exp(`p`i'')/`den', /*
				*/ cond(exp(`p`i'')<.,0, /*
				*/ cond(`den'==-1,1,.))) /*
				*/ if `touse'
				drop `p`i''
				rename `tmp' `p`i''
			}

		/* Count # of missings. */

			count if `p`i''>=.
			mat `miss'[1,`i'] = r(N)
			if `miss'[1,`i']!=`miss'[1,1] {
				local same 0
			}

		/* Label variable. */

			mat `cati' = `cat'[1,`i'..`i']
			local eqi : coleq `cati'
			label var `p`i'' `"Pr(`e(depvar)'==`eqi')"'

			local i = `i' + 1
		}
	}

	tokenize `varlist'
	local i 1
	while `i' <= e(k_cat) {
		rename `p`i'' ``i''
		local i = `i' + 1
	}
	ChkMiss `same' `miss' `varlist'
end

program define ChkMiss
	args same miss
	macro shift 2
	if `same' {
		SayMiss `miss'[1,1]
		exit
	}
	local i 1
	while `i' <= e(k_$MLOG_cat) {
		SayMiss `miss'[1,`i'] ``i''
		local i = `i' + 1
	}
end

program define SayMiss
	args nmiss varname
	if `nmiss' == 0 { exit }
	if "`varname'"!="" {
		local varname "`varname': "
	}
	if `nmiss' == 1 {
		di in blu "(`varname'1 missing value generated)"
		exit
	}
	local nmiss = `nmiss'
	di in blu "(`varname'`nmiss' missing values generated)"
end

program ParseNewVars, sclass
	version 9, missing
	syntax [anything(name=vlist)] [if] [in] [, * ]
	local myif `"`if'"'
	local myin `"`in'"'
	local myopts `"`options'"'

	if `"`vlist'"' == "" {
		di as err "varlist required"
		exit 100
	}
	local varspec `"`vlist'"'
	local neq = e(k_$MLOG_cat)
	local stub 0
	if index("`vlist'","*") {
		if inlist("`myopts'" , "sc", "sco", "scor", "score", "scores") { 	
			local svars = `neq' - 1
			_stubstar2names `vlist', nvars(`svars')
		}
		else {
			_stubstar2names `vlist', nvars(`neq')
		}
		local varlist `s(varlist)'
		local typlist `s(typlist)'
		confirm new var `varlist'
	}
	else {
		syntax newvarlist [if] [in] [, * ]
	}
	local nvars : word count `varlist'

	sreturn clear
	sreturn local varspec `varspec'
	sreturn local varlist `varlist'
	sreturn local typlist `typlist'
	sreturn local if `"`myif'"'
	sreturn local in `"`myin'"'
	sreturn local options `"`myopts'"'
end

program ParseOptions, sclass
	version 9
	syntax [,			///
		Equation(string)	///
		Outcome(string)		///
		Index			///
		XB			///
		STDP			///
		STDDP			///
		Pr			///
		SCores			///
	]

	// check options that take arguments
	local rc 0
	if `"`equation'"' != "" & `"`outcome'"' != "" {
		local errmsg "equation() and outcome()"
		local rc 198
	}
	if `rc' {
		di as err "options `errmsg' may not be combined"
		exit `rc'
	}
	local eq `"`equation'`outcome'"'

	// check switch options
	local type `index' `xb' `stdp' `stddp' `pr' `scores'
	if `:word count `type'' > 1 {
		local type : list retok type
		di as err "the following options may not be combined: `type'"
		exit 198
	}

	// save results
	sreturn clear
	sreturn local type	`type'
	sreturn local outcome	`"`eq'"'
end

program GenScores, rclass
	version 9, missing
	local cmd = cond("`e(prefix)'"=="svy","svy:","")+"`e(cmd)'"
	syntax [anything] [if] [in] [, * ]
	marksample touse
	_score_spec `anything', `options'
	local varlist `s(varlist)'
	local typlist `s(typlist)'
	local nvars : word count `varlist'
	local spec = bsubstr("`s(eqspec)'",2,.)
	if "`spec'" == "" {
		numlist "1/`nvars'"
		local spec `r(numlist)'
	}
	tempvar p d

	forval i = 1/`nvars' {
		local typ : word `i' of `typlist'
		local var : word `i' of `varlist'
		local eq  : word `i' of `spec'
		if "`e(cmd)'`e(prefix)'"=="mlogit" {
			quietly	_predict `typ' `p' if `touse', eq(#`eq')
		}
		else { /* svymlogit */
			quietly OnePsvy `typ' `p' if `touse', eq(#`eq')
		}
		quietly GenD `d' if `touse', eq(#`eq')
		quietly gen `typ' `var' = (`d'-`p')

		version 6: Outcome #`eq'
		label var `var'	`"equation-level score from `cmd', `e(depvar)'==`s(outcome)'"'
		drop `d' `p'
	}
	return local scorevars `varlist'
end
