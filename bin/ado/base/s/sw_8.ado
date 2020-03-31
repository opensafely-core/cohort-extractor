*! version 5.4.6  04feb2015
program define sw_8, byable(recall)
	version 8.2, missing
	version 6.0, missing

	if replay() {
		if _by() { error 190 }
		if `"`e(cmd2)'"'=="streg" | `"`e(cmd2)'"'=="stcox" {
			local cmd `e(cmd2)'
		}
		else {
			local cmd = /*
			*/ cond(`"`e(cmd)'"'=="","$S_E_cmd",`"`e(cmd)'"')
			if `"`cmd'"'=="" { error 301 }
		}
		di in blue `"->`cmd'"'
		`cmd' `0'
		exit
	}

	if _by() {
		tempvar touse
		mark `touse'
	}

	RmGlobal
	global HSW_call : display string(_caller())
	global HSW_n 0
	global HSW_tu0 `touse'
	capture noisily DoEst `0'
	local rc = _rc

	RmGlobal
	exit `rc'
end


program define RmGlobal
	capture confirm integer number $HSW_n
	if _rc==0 {
		if $HSW_n < 2050 {
			local i 1
			while `i' <= $HSW_n {
				global HSW_`i'		/* term */
				local i=`i'+1
			}
		}
	}
	global HSW_n		/* total number of terms	*/

				/* <cmd>-specific macros	*/
	global HSW_cmd		/* estimation command		*/
	global HSW_pcmd		/* postestimation command or "" */
	global HSW_op0		/* estimation-time options	*/
	global HSW_op1		/* reply options		*/
	global HSW_typ		/* "reg" or "ml", for testing	*/
	global HSW_res		/* if "ml": pgmname to unload*/
	global HSW_cons		/* "chkcons" or ""		*/

	global HSW_w		/* "[<weight>]" or ""		*/
	global HSW_tu		/* touse tempvar 		*/
	global HSW_cmdX		/* $HSW_cmd varlist $HSW_cmdX	*/

	global HSW_Pr
	global HSW_Pe
	global HSW_hier		/* 0,1: hierarchical model	*/


				/* current model macros		*/
	global HSW_dv		/* dependent variable		*/
	global HSW_cur		/* current indep. vars.		*/
	global HSW_k		/* current # of terms		*/
	global HSW_base


				/* temporary macros		*/
	global HSW_ll0
	global HSW_ll1
	global HSW_d0
	global HSW_d1
	global HSW_AddT		/* 0,1: AddT added a term	*/
	global HSW_RmT		/* 0,1: RmT removed term	*/

				/* to be deleted 		*/
	global HSW_opt
	global HSW_ropt

	global HSW_tu0		/* master touse by var if by'd 	*/

	capture estimates drop HSW_last
end


program define DoEst /* cmd varlist [if|in|,|[weight]] */
	gettoken tok 0 : 0
	local command `tok'
	SetCmd `command'

	if `"`command'"'!="streg" & `"`command'"'!="stcox" {
		gettoken tok 0 : 0
		unabbrev `tok'
		global HSW_dv "`s(varlist)'"
	}

	/* HSW_cur already empty, will contain full term list */
	global HSW_n 0


	gettoken tok : 0, parse(" ,[")
	IfEndTrm "`tok'"
	while `s(IsEndTrm)'==0 {
		gettoken tok 0 : 0, parse(" ,[")
		if bsubstr("`tok'",1,1)=="(" {
			local list
			while bsubstr("`tok'",-1,1)!=")" {
				if "`tok'"=="" {
					di in red "varlist invalid"
					exit 198
				}
				local list "`list' `tok'"
				gettoken tok 0 : 0, parse(" ,[")
			}
			local list "`list' `tok'"
			unabbrev `list'
			global HSW_n = $HSW_n + 1
			global HSW_$HSW_n "`s(varlist)'"
			global HSW_cur "$HSW_cur `s(varlist)'"
		}
		else {
			unabbrev `tok'
			local i 1
			local w : word 1 of `s(varlist)'
			while "`w'" != "" {
				global HSW_n = $HSW_n + 1
				global HSW_$HSW_n "`w'"
				local i = `i' + 1
				local w : word `i' of `s(varlist)'
			}
			global HSW_cur "$HSW_cur `s(varlist)'"
		}
		gettoken tok : 0, parse(" ,[")
		IfEndTrm "`tok'"
	}
	local list		/* done with list, save memory 	*/
	local i			/* done with i			*/
	local w			/* done with w			*/
	local tok		/* done with tok		*/

	syntax [if] [in] [fw pw aw iw] [, /*
		*/ FORWard HIER LR PE(real -1) PR(real -1) LOCkterm1 * ]
	CmdOpts, `options'

	if `pe'== -1 & `pr'== -1 {
		di in red "must specify pr(#) and/or pe(#) option"
		exit 198
	}
	if `pe'!= -1 & (`pe'<=0 | `pe'>=1) {
		di in red "pe(#) invalid"
		exit 198
	}
	if `pr'!= -1 & (`pr'<=0 | `pr'>=1) {
		di in red "pr(#) invalid"
		exit 198
	}
	if `pe'!= -1 & `pr'!= -1 {
		if "`hier'"!="" {
			di in red "hier pe(#) pr(#) invalid"
			exit 198
		}
		if `pe' >= `pr' {
			di in red "pr(`pr') <= pe(`pe') invalid"
			exit 198
		}
	}
	if "`forward'" != "" & `pe'== -1 {
		di in red "option forward invalid  or  option pe(#) missing"
		exit 198
	}

	if "`weight'" != "" {
		global HSW_w `"[`weight'`exp']"'
	}

	if "$HSW_typ"=="ml" & "`lr'"=="" {
		global HSW_typ "reg"
	}
	else if "$HSW_typ"=="reg" & "`lr'"!="" {
		di in red "lr not allowed with $HSW_cmd estimator"
		exit 198
	}

	tempvar touse
	mark `touse' `if' `in' $HSW_w
	markout `touse' $HSW_dv $HSW_cur
	if "$HSW_tu0" != "" {
		quietly replace `touse' = 0 if $HSW_tu0 == 0
	}
	global HSW_tu "`touse'"

	global HSW_cmdX "$HSW_w if `touse', $HSW_op0"

	SetVandS		/* set variables and sample		*/
				/* full model now estimated & set 	*/
	$HSW_cons		/* optionally check _se[_cons] 		*/

	global HSW_Pr `pr'
	global HSW_Pe `pe'
	global HSW_hier = ("`hier'" != "")
	global HSW_AddT 0
	global HSW_RmT 0
	if "`lockter'"!="" {
		global HSW_base "$HSW_1"
		DelTerm 1
		MakeList $HSW_n
	}

	if $HSW_Pr > 0 {
		if $HSW_Pe < 0 {
			DoBSel
		}
		else if "`forward'" != "" {
			DoFSW
		}
		else	DoBSW
	}
	else	DoFSel

	if $HSW_call < 6 {
		preserve, changed
		capture drop _sample
		rename `touse' _sample
		restore
		label var _sample "sw $HSW_cmd"
		local touse _sample
	}

	if "$HSW_Pcmd"=="" {
		version $HSW_call, missing: $HSW_cmd, $HSW_op1
	}
	else {
		version $HSW_call, missing: $HSW_Pcmd $HSW_dv $HSW_base $HSW_cur /*
			*/ $HSW_w if `touse', $HSW_op0 $HSW_op1
		label var `touse' "sw $HSW_Pcmd"
	}
end

program define IfEndTrm, sclass
	sret local IsEndTrm 1
	if "`1'"=="," | "`1'"=="in" | "`1'"=="if" | /*
	*/ "`1'"=="" | "`1'"=="[" { exit }
	sret local IsEndTrm 0
end


program define DoBSel
	FullMdl
	RmT$HSW_typ 1
	while $HSW_RmT {
		RmT$HSW_typ 0
	}
end

program define DoFSel
	NullMdl
	AddT 1
	while $HSW_AddT {
		AddT 0
	}
end

program define DoBSW
	FullMdl
	RmT$HSW_typ 1
	if !$HSW_RmT { exit }
	RmT$HSW_typ 0
	while $HSW_RmT | $HSW_AddT {
		AddT 0
		RmT$HSW_typ 0
	}
end

program define DoFSW
	NullMdl
	AddT 1
	if !$HSW_AddT { exit }
	AddT 0
	while $HSW_AddT | $HSW_RmT {
		RmT$HSW_typ 0
		AddT 0
	}
end

program define FullMdl
	if "$HSW_typ"=="ml" {
		local tt "    LR test"
	}
	di in gr "`tt'" _col(23) "begin with full model"
end

program define NullMdl
	if "$HSW_typ"=="ml" {
		local tt "    LR test"
	}
	if "$HSW_base" == "" {
		local typ "empty"
	}
	else	local typ "term 1"
	di in gr "`tt'" _col(23) "begin with `typ' model"
	global HSW_k 0
	global HSW_cur
	quietly version $HSW_call, missing: $HSW_cmd $HSW_dv $HSW_base $HSW_cmdX
end



/*
	SetVandS			(set variables and sample)

	remove collinearity from terms.
	verify can estimate full model.
	further restrict sample if estimator does and iterate.
	Return with full model estimated and set.
*/


program define SetVandS /* */
	quietly count if $HSW_tu
	local n00 = r(N)
	local n0 `n00'
	/* MakeList $HSW_n */	/* not nesc., already set by DoEst 	*/
	while 1 {
		local n : word count $HSW_cur

		qui summ $HSW_tu /* $HSW_w */ if $HSW_tu /* obtain obs count */
		if r(N)+2 < `n' {
			error cond(r(N)==0,2000,2001)
		}
		FixColl			/* may update HSW_cur */
		CheckEst		/* may update touse */
		if r(IsChange)==0 {	/* did not update touse this time */
			quietly count if $HSW_tu
			if r(N) != `n00' {
				di in blu "(" `n00'-r(N) /*
				*/ " obs. dropped due to estimability)"
			}
			exit
		}
		local n0 = r(N)
	}
end


/*
	FixColl

	remove collinearity from terms
	sets HSW_cur and HSW_k to full model
*/

program define FixColl
	tempname cov

	global HSW_cur		/* rebuild full list	*/
	local i 1
	while `i' <= $HSW_n {
		tokenize ${HSW_`i'}
		local n : word count ${HSW_`i'}
		if `n' == 1 {
			qui summ `1' /* $HSW_w */ if $HSW_tu
			if r(min)==r(max) {
				di in blu "(`1' dropped because constant)"
				DelTerm `i'
				local i = `i' - 1
				local 1
			}
		}
		else {
			qui mat accum `cov' = `*' $HSW_w if $HSW_tu
			qui mat `cov' = syminv(`cov')

			local j 1
			while `j' < colsof(`cov') {
				if `cov'[`j',`j']==0 {
					di in blu /*
					*/ "(``j'' dropped due to collinearity)"
					local `j' " "
				}
				local j=`j'+1
			}
			local n : word count `*'
			if `n'==0 {
				DelTerm `i'
				local i=`i'-1
			}
			else	{
				tokenize `*'
				global HSW_`i' "`*'"
			}
		}
		global HSW_cur "$HSW_cur `*'"
		local i=`i'+1
	}
	global HSW_k $HSW_n
	tokenize $HSW_cur
	qui mat accum `cov' = `*' $HSW_w if $HSW_tu
	qui mat `cov' = syminv(`cov')
	local j 1
	while `j' < colsof(`cov') {
		if `cov'[`j',`j']==0 {
			di in red "between-term collinearity, variable ``j''"
			exit 498
		}
		local j=`j'+1
	}
end

/*
	CheckEst

	Given HSW_cur, estimate current model.
	Remove variables dropped by estimator.
	Remove from estimation sample observations dropped by estimator

	Returns:
	r(IsChange)==0	sample did not change
			HSW_cur correctly set and model estimated

	r(IsChange)==1	sample did change
			HSW_cur not nesc. set, model not nesc. estimated.
			(meaning CheckEst must be called again, but
			 only after collinearity is reconsidered.)
*/


program define CheckEst, rclass /* */
	capture version $HSW_call, missing: $HSW_cmd $HSW_dv $HSW_base $HSW_cur $HSW_cmdX
	if _rc {
		di in red "could not estimate full model"
		error _rc
	}

	tokenize $HSW_cur
	local deletes 0
	local i 1
	while "``i''" != "" {
		local x .
		capture local x = _se[``i'']
		local rc = _rc
		if `x'>=. | `x'==0 {
			DelVar ``i''
			local deletes 1
		}
		local i = `i'+1
	}
	capture assert e(sample) if $HSW_tu
	if _rc {
		quietly replace $HSW_tu = 0 if e(sample)==0
		ret scalar IsChange = 1
		exit			/* we will be called again */
	}
	if `deletes' {
		MakeList $HSW_n
		quietly version $HSW_call, missing: $HSW_cmd $HSW_dv $HSW_base /*
				*/ $HSW_cur $HSW_cmdX
	}
	ret scalar IsChange = 0
end

program define BI
	* quietly version $HSW_call: $HSW_cmd
	global `1' = e(ll)
	global `2' = e(df_m)
end

program define ADO
	global `1' $S_E_ll
	global `2' $S_E_mdf
end


program define tswap /* j k */
	local hold "${HSW_`1'}"
	global HSW_`1' `"${HSW_`2'}"'
	global HSW_`2' `"`hold'"'
end


/*
	MakeList #

	set HSW_cur, HSW_k to reflect first # terms
*/

program define MakeList /* k */
	global HSW_k `1'
	global HSW_cur
	local i 1
	while `i' <= $HSW_k {
		global HSW_cur "$HSW_cur ${HSW_`i'}"
		local i = `i' + 1
	}
end



/*
	SetCmd <cmdname>

	Preprocessor, calls <cmd>_sw to set command macros.
	See notes at eof
*/


program define SetCmd /* cmdname */
	global HSW_Pcmd
	global HSW_cons
	global HSW_op1 "Level(integer $S_level)"

					/* built-in abbreviations */
	if "`1'"=="reg" {
		local 1 "regress"
	}

					/* set	*/
	local cmd = substr("`1'",1,5)+"_sw"
	capture `cmd'
	if _rc {
		local rc = _rc
		capture confirm var `1'
		if _rc == 0 {
			di in red "syntax is  sw EST-COMMAND termlist ..."
			exit 198
		}
		if `rc'==199 {
			di in red "estimation command `1' not supported by sw"
			exit 199
		}
		di in red "error in `1' sw-interface `cmd':"
		error `rc'
	}
	if `"$HSW_res"'=="" {
		global HSW_res BI
	}
end

program define regre_sw
	global HSW_cmd "regress"
	global HSW_typ "reg"
	global HSW_op0 "CLuster(string) HC2 HC3 Robust"
	global HSW_op1 "$HSW_op1 Beta"
end

program define fit_sw
	global HSW_cmd "regress"
	global HSW_Pcmd "fit"
	global HSW_typ "reg"
end

program define logit_sw
	global HSW_cmd "logit"
	global HSW_op0 "CLuster(string) Robust"
	global HSW_op1 "$HSW_op1 OR"
	global HSW_typ "ml"
	global HSW_cons "chkcons"
end

program define logis_sw
	global HSW_cmd "logit"
	global HSW_Pcmd "logistic"
	global HSW_op0 "CLuster(string) Robust"
	global HSW_typ "ml"
	global HSW_cons "chkcons"
end

program define probi_sw
	global HSW_cmd "probit"
	global HSW_op0 "CLuster(string) Robust"
	global HSW_typ "ml"
	global HSW_cons "chkcons"
end


program define DelTerm /* i */
	local i `1'
	local j `i'
	while `j' < $HSW_n {
		local k = `j'+1
		global HSW_`j' "${HSW_`k'}"
		local j = `j'+1
	}
	global HSW_`j'
	global HSW_n = $HSW_n - 1
end


program define DelVar /* varname */
	local vn "`1'"
	di in blu "(`vn' dropped due to estimability)"
	local i 1
	while `i' <= $HSW_n {
		tokenize ${HSW_`i'}
		local j 1
		while "``j''" != "" {
			if "``j''"=="`vn'" {
				local `j' " "
				local n : word count `*'
				if `n'==0 {
					DelTerm `i'
					exit
				}
				tokenize `*'
				global HSW_`i' "`*'"
				exit
			}
			local j=`j'+1
		}
		local i=`i'+1
	}
	di in red "sw failure: could not find variable `vn'"
	exit 9498
end

program define chkcons
	capture local x = _se[_cons]
	if _rc {
		local x .
	}
	if `x'==0 | `x'>=. {
		di in red "could not estimate _cons"
		exit 498
	}
end


/*
	CmdOpts [, <remaining options>]

		Converts predefined option masks $HSW_op0 and $HSW_op1
		to actual option lists.
*/


program define CmdOpts /*, <remaining options> */
	syntax [, $HSW_op0 $HSW_op1 * ]
	if `"`options'"' != "" {
		di in red `"`options' not allowed"'
		exit 198
	}

	local h0 `"$HSW_op0"'
	local h1 `"$HSW_op1"'
	syntax [, `h1' *]
	global HSW_op0 `"`options'"'

	syntax [, `h0' *]
	global HSW_op1 `"`options'"'
end


/*
	AddT

	possibly add another term and leave it defined as current model.
	works for both ml and reg models.
	returns HSW_AddT==1 if term added, else HSW_AddT==0.
*/

program define AddT /* first */
	local first `1'
	if $HSW_k == $HSW_n {
		global HSW_AddT 0
		exit
	}
	if "$HSW_typ" == "ml" {
		$HSW_res HSW_ll0 HSW_d0
	}
	estimates hold HSW_last
	local k = $HSW_k + 1
	local p1 2		/* find min sig */
	local kept 0
	while `k' <= cond($HSW_hier, $HSW_k+1, $HSW_n) {
		quietly version $HSW_call, missing: $HSW_cmd $HSW_dv $HSW_base /*
				*/ $HSW_cur ${HSW_`k'} $HSW_cmdX
		if "$HSW_typ" == "ml" {
			$HSW_res HSW_ll1 HSW_d1
			local p = chiprob($HSW_d1-$HSW_d0, /*
					*/ -2*($HSW_ll0-$HSW_ll1))
		}
		else {
			quietly test ${HSW_`k'}
			local p = cond(r(df_r)>=., /*
				*/ chiprob(r(df),r(chi2)), /*
				*/ fprob(r(df),r(df_r),r(F)) )
		}
		if `p'< `p1' {
			local k1 `k'
			local p1 `p'
			if `p' < $HSW_Pe {
				local kept 1
				capture estimates drop HSW_last
				capture estimates hold HSW_last
			}
		}
		local k = `k'+1
	}
	estimates unhold HSW_last
	if `kept' {
		global HSW_cur "$HSW_cur ${HSW_`k1'}"
		di in gr "p = " in ye %5.4f `p1' _c
		di in gr " <  " %5.4f $HSW_Pe "  adding   " in ye "${HSW_`k1'}"
		global HSW_k = $HSW_k + 1
		tswap $HSW_k `k1'
		global HSW_AddT 1
	}
	else {
		if $HSW_hier {
			di in gr "p = " in ye %5.4f `p1' in gr /*
				*/ " >= " %5.4f $HSW_Pe "  testing  " /*
				*/ in ye "${HSW_`k1'}"
		}
		else if `first' {
			di in gr "p >=" %5.4f $HSW_Pe _col(23) /*
			*/ "for all terms in model"
		}
		global HSW_AddT 0
	}
end

program define RmTreg
	local first `1'
	if $HSW_k == 0 {
		global HSW_RmT 0
		exit
	}
	local k = cond($HSW_hier,$HSW_k,1)
	local k1 .
	local p1 -1
	while `k' <= $HSW_k {
		quietly test ${HSW_`k'}
		local p = cond(r(df_r)>=., /*
			*/ chiprob(r(df),r(chi2)), /*
			*/ fprob(r(df),r(df_r),r(F)) )
		if `p' > `p1' {
			local k1 `k'
			local p1 `p'
		}
		local k = `k' + 1
	}
	if `p1' < $HSW_Pr {
		if $HSW_hier {
			di in gr "p = " in ye %5.4f `p1' _c
			di in gr " <  " %5.4f $HSW_Pr "  keeping  " in ye /*
				*/ "${HSW_`k1'}"
		}
		else if `first' {
			di in gr "p < " %5.4f $HSW_Pr _col(23) /*
			*/ "for all terms in model"
		}
		global HSW_RmT 0
		exit
	}
	di in gr "p = " in ye %5.4f `p1' _c
	di in gr " >= " %5.4f $HSW_Pr "  removing " in ye "${HSW_`k1'}"
	tswap `k1' $HSW_k
	global HSW_k = $HSW_k - 1
	MakeList $HSW_k
	quietly version $HSW_call, missing: $HSW_cmd $HSW_dv $HSW_base $HSW_cur $HSW_cmdX
	global HSW_RmT 1
end

program define RmTml
	local first `1'
	if $HSW_k == 0 {
		global HSW_RmT 0
		exit
	}
	$HSW_res HSW_ll1 HSW_d1
	local oldcur "$HSW_cur"
	estimates hold HSW_last

	local k = cond($HSW_hier, $HSW_k, 1)
	local k1 .
	local p1 -1
	local kept 0
	local truk $HSW_k
	local modk = $HSW_k - 1
	while `k' <= `truk' {
		tswap `k' `truk'
		MakeList `modk'
		quietly version $HSW_call, missing: $HSW_cmd $HSW_dv $HSW_base /*
					*/ $HSW_cur $HSW_cmdX
		$HSW_res HSW_ll0 HSW_d0
		local p = chiprob($HSW_d1-$HSW_d0, -2*($HSW_ll0-$HSW_ll1))
		if `p' > `p1' {
			local p1 `p'
			local k1 `k'
			if `p' >= $HSW_Pr {
				capture estimates drop HSW_last
				estimates hold HSW_last
				local oldcur "$HSW_cur"
				local kept 1
			}
		}
		tswap `k' `truk'
		local k = `k'+1
	}
	global HSW_k `truk'
	if `kept' {
		di in gr "p = " in ye %5.4f `p1' _c
		di in gr " >= " %5.4f $HSW_Pr "  removing " in ye "${HSW_`k1'}"
		tswap `k1' $HSW_k
		global HSW_k = $HSW_k - 1
		global HSW_RmT 1
	}
	else {
		if $HSW_hier {
			di in gr "p = " in ye %5.4f `p1' _c
			di in gr " <  " %5.4f $HSW_Pr "  keeping  " in ye /*
				*/ "${HSW_`k1'}"
		}
		else if `first' {
			di in gr "p < " %5.4f $HSW_Pr _col(23) /*
			*/ "for all terms in model"
		}
		global HSW_RmT 0
	}
	estimates unhold HSW_last
	global HSW_cur "`oldcur'"
end

exit


Command macros set by <cmd>_sw:

	global macro	contents
	-----------------------------------------------------------------
	HSW_cmd		command to perform estimation

	HSW_Pcmd	postestimation command (optional)

	HSW_typ 	"reg" | "ml"
			"reg" means always use -test- to test terms
			"ml"  means use -test- or likelihood-ratio test

	HSW_res		to be set by version<6 programs only!
			to be set only if "$HSW_typ"=="ml".
			If not set, e(ll) and e(df_m) are assumed to be the
			log-likelihood value and model dof.  Otherwise:
			name of program to unload ll and dof.  May use
			"BI":  ll in e(ll) and dof in e(df_m)
			"ADO": ll in $S_E_ll    and dof in $S_E_mdf
			any other program:  however you write it


	HSW_cons	"chkcons" | ""
			check that _se[_cons] defined, refuse if not.

	HSW_op0		option mask for estimation-time $HSW_cmd
			default: ""

	HSW_op1		option mask for reply $HSW_cmd
			default: "Level(integer $S_level)"
