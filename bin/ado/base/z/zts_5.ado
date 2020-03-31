*! version 6.1.9  16feb2015
program define zts_5
	version 5.0, missing

	di in gr "(you are running sts from Stata version 5)"

	zt_is_5

	if bsubstr("`1'",length("`1'"),1)=="," {
		local 2 ", `2'"
		local 1 = substr("`1'",1,length("`1'")-1)
	}
	local cmd "`1'"
	mac shift

	if "`cmd'"=="" {
		local cmd "graph"
	}

	local l = length("`cmd'")
	if bsubstr("list",1,`l')=="`cmd'" {
		List `*'
	}
	else if bsubstr("graph",1,`l')=="`cmd'" {
		Graph `*'
	}
	else if bsubstr("generate",1,`l')=="`cmd'" {
		Gen `*'
	}
	else if bsubstr("test",1,`l')=="`cmd'" {
		Test `*'
	}
	else if "`cmd'"=="if" | "`cmd'"=="in" {
		Graph `*'
	}
	else {
		di in red "unknown sts subcommand `cmd'"
		exit 198
	}
end

program define Test 
	local varlist "req ex"
	local if "opt"
	local in "opt"
	local options "BY(string) Detail noSHow *"
	local wt : char _dta[st_wt]
	if "`wt'"=="pweight" {
		local options "`options' Cox"
	}
	else	local options "`options' Breslow Cox Wilcoxon"
	parse "`*'"

	if "`by'"!="" {
		di in red "by() not allowed
		exit 198 
	}
	local by "by(`varlist')"

	local n1 = ("`breslow'"!="")|("`wilcoxo'"!="")
	if `n1'+("`cox'"!="")+("`logrank'"!="")>1 {
		di in red "options logrank, wilcoxon, and cox are alternatives"
		di in red "they may not be specified together"
		exit 198
	}
	if `n1' {
		local cmd "wilc_st"
	}
	else if "`cox'"!="" | "`wt'"=="pweight" {
		local cmd "ctst_5"
	}
	else	local cmd "logrank"

	zt_sho_5 `show'

	if "`cmd'"=="ctst_5" {
		tempname oldest 
		capture {
			capture estimate hold `oldest'
			noisily `cmd' `varlist' `if' `in', `options'
		}
		local rc = _rc
		capture estimate unhold `oldest'
		exit `rc'
	}


	tempvar touse
	zt_smp_5 `touse' "`if'" "`in'"

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_w]
	if "`t0'" != "" {
		local t0 "t0(`t0')"
	}
	if "`id'" != "" {
		local id "id(`id')"
	}
	`cmd' `t' `d' `w' if `touse', `t0' `id' `by' `options' `detail'
end



/* 
	gen var=thing [var=thing] ...
*/

program define Gen
	parse "`*'", parse(" =,") 
	if "`2'" != "=" { error 198 }
	while "`2'" == "=" { 
		confirm new var `1'
		local 3 = lower("`3'")
		if "`3'" == "s" {
			local Surv `1'
		}
		else if "`3'"=="se(s)" {
			NotPw "se(s)"
			local Se "`1'"
			local notcox "`1'=`3'"
		}
		else if "`3'"=="h" {
			local Haz "`1'"
		}
		else if "`3'"=="se(lls)" {
			NotPw "se(lls)"
			local sllS "`1'"
			local notcox "`1'=`3'"
		}
		else if "`3'"=="ub(s)" | "`3'"=="ub" {
			NotPw "ub(s)"
			local ub "`1'"
			local notcox "`1'=`3'"
		}
		else if "`3'"=="lb(s)" | "`3'"=="lb" {
			NotPw "lb(s)"
			local lb "`1'"
			local notcox "`1'=`3'"
		}
		else if "`3'"=="n" {
			local Pop "`1'"
			local notcox "`1'=`3'"
		}
		else if "`3'"=="d" { 
			local Die "`1'"
			local notcox "`1'==`3'"
		}
		else {
			di in red "`3' unknown function"
			exit 198
		}
		mac shift 3
	}

	local if "opt"
	local in "opt"
	local options "Adjustfor(string) BY(string) Level(integer $S_level) noSHow STrata(string)"
	parse "`*'"

	ByStAdj "`by'" "`strata'" "`adjustf'"
	local by "$S_1"
	local strata "$S_2"
	local adjustf "$S_3"

	* zt_sho_5 `show'

	if "`adjustf'" != "" {
		if "`notcox'" != "" {
			di in red "cannot calculate `notcox' with adjustfor()"
			exit 198
		}
		qui DoAdjust "`by'" "`strata'" "`adjustf'" "`if'" "`in'" /* 
			*/ -> "`Haz'" "`Surv'"
		if "`Surv'"!="" {
			label var `Surv' "S(t+0), adjusted"
		}
		if "`Haz'"!="" {
			label var `Haz' "h(t), adjusted"
		}
		exit
	}


	if "`Pop'"=="" { tempvar Pop }
	if "`Die'"=="" { tempvar Die }
	tempvar touse 
	zt_smp_5 `touse' "`if'" "`in'" "`by'" ""
	preserve 
	quietly {
		keep if `touse'
		local t : char _dta[st_t]
		qui zt_ct_5 "`by'" -> `t' `Pop' `Die' 
		keep if `Die'
		AddSurv "`by'" `t' `Pop' `Die' `level' -> /* 
			*/ "`Haz'" "`Surv'" "`Se'" "`sllS'" "`lb'" "`ub'"
		keep `by' `t' `Haz' `Surv' `Se' `sllS' `lb' `ub' `Pop' `Die'
		tempfile one 
		save "`one'"
		restore, preserve
		sort `by' `t' 
		merge `by' `t' using "`one'"
		keep if _merge==1 | _merge==3
		drop _merge
		sort `by' `t' 
		if "`by'" != "" {
			local byp "by `by':"
		}
		if "`Surv'" != "" {
			`byp' replace `Surv' = /* 
				*/ cond(_n==1,1,`Surv'[_n-1]) if `Surv'>=.
			replace `Surv' = . if `touse'==0
			label var `Surv' "S(t+0)"
		}
		if "`Se'" != "" {
			`byp' replace `Se' = `Se'[_n-1] if `Se'>=. 
			label var `Se' "se(S) (Greenwood)"
		}
		if "`sllS'" != "" {
			`byp' replace `sllS' = `sllS'[_n-1] if `sllS'>=.
			label var `sllS' "se(-ln ln S)"
		}
		if "`lb'" != "" {
			`byp' replace `lb' = `lb'[_n-1] if `lb'>=.
			label var `lb' "S() `level'% lower bound"
		}
		if "`ub'" != "" {
			`byp' replace `ub' = `ub'[_n-1] if `ub'>=.
			label var `ub' "S() `level'% upper bound"
		}
		if "`Haz'" != "" {
			label var `Haz' "h(t)"
		}
		label var `Pop' "N, entering population"
		label var `Die' "d, number of failures"
	}
	restore, not
end

program define NotPw /* text */
	local w : char _dta[st_wt]
	if "`w'"=="pweight" { 
		di in red "`*' not possible with pweighted data"
		exit 404
	}
end
		

program define AddSurv /* by t Pop Die lvl -> Haz Surv Se sllS lb ub */
	local by "`1'" /*  1 2   3   4   5      7    8  9   10 11 12 */
	local t  "`2'"
	local N  "`3'"
	local D  "`4'"
	local lvl "`5'"

	local h    "`7'"
	local S    "`8'"
	local Se   "`9'"
	local sllS "`10'"
	local lb   "`11'"
	local ub   "`12'"

	if "`h'"=="" {
		tempvar h
	}
	gen double `h' = cond(`N'==0,0,`D'/`N')
	sort `by' `t'
	if "`by'" != "" {
		local byp "by `by':"
	}

	if "`Se'"!="" | "`lb'"!="" | "`ub'"!="" { 
		if "`S'"=="" { tempvar S }
		if "`lb'"!="" | "`ub'"!="" {
			if "`sllS'"=="" { tempvar sllS }
		}
	}


	if "`S'" != "" {
		`byp' gen double `S' = 1-`h'
		`byp' replace `S' = `S'[_n-1]*(1-`h') if _n>1
	}
	if "`Se'" != "" {
		`byp' gen double `Se' = /*
		*/ `S'*sqrt(sum(`D'/(`N'*(`N'-`D')))) if `S'!=0
		replace `Se' = . if `S'==1
	}
	if "`sllS'" != "" {
		`byp' gen double `sllS' = sqrt( /*
		*/ sum(`D'/(`N'*(`N'-`D'))) / (sum(ln((`N'-`D')/`N'))^2) )
	}
	if "`lb'"!="" | "`ub'"!="" {
		local z = invnorm(1-(1-`lvl'/100)/2)
		if "`lb'" != "" {
			gen double `lb'=(`S')^(exp(`z'*`sllS')) if `S'!=0
		}
		if "`ub'"!="" {
			gen double `ub'=(`S')^(exp(-`z'*`sllS')) if `S'!=0
		}
	}
end


program define List
	local if "opt"
	local in "opt"
	local options "ADjustfor(string) AT(string) BY(string) Compare Enter Failure Level(integer $S_level) noSHow STrata(string)"
	parse "`*'"

/* begin unload.h */
	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_w]
	local wt : char _dta[st_wt]
/* end unload.h */

	if `level'<10 | `level'>99 { 
		di in red "level() invalid"
		exit 198
	}

	ByStAdj "`by'" "`strata'" "`adjustf'"
	local by "$S_1"
	local strata "$S_2"
	local adjustf "$S_3"
	local sb "$S_4"

	if "`compare'" != "" {
		if "`at'" == "" { 
			local at "10"
		}
		if "`sb'"=="" {
			di in red "compare requires by() or strata()"
			exit 198
		}
	}


	if "`at'" != "" { 
		Procat `at'
		local at "$S_1"
	}

	zt_sho_5 `show'


	tempvar touse  mark n d cens ent  s se lb ub
	zt_smp_5 `touse' "`if'" "`in'" "`sb'" "`adjustf'"
	preserve
	quietly {
		keep if `touse'
		if "`adjustf'"=="" {
			zt_ct_5 "`by'" -> `t' `n' `d' `cens' `ent'
			if "`enter'"=="" {
				replace `cens' = `cens' - `ent'
				drop if `d'==0 & `cens'==0
				replace `ent' = 0 
			}
			AddSurv "`by'" `t' `n' `d' `level' -> /* 
				*/ "" `s' `se' "" `lb' `ub'
		}
		else { 
			DoAdjust "`by'" "`strata'" "`adjustf'" "" "" -> "" `s'
			KeepDead "`sb'"
		}
		if "`failure'" != "" {
			replace `s'=1-`s'
			if "`adjustf'"=="" {
				replace `lb'=1-`lb'
				replace `ub'=1-`ub'
				local hold "`lb'"
				local lb "`ub'"
				local ub "`hold'"
			}
		}
	}

	if "`sb'"!="" {
		quietly {
			tempvar grp
			by `sb': gen `grp'=1 if _n==1
			replace `grp' = sum(`grp')
		}
	}


	if "`compare'"!="" { 
		Reat `t' `at'
		if "$S_1"!="" {
			local at "$S_1"
		}
		if "`adjustf'"=="" {
			drop `n' `d' `cens' `ent' `se' `lb' `ub'
		}
		Licomp "" "`sb'" "`grp'" `t' `s' "`at'" "`failure'" "`adjustf'"
		exit
	}


	if "`failure'"!="" { 
		local ttl "Failure"
		local blnk " "
		local attl " Adjusted Failure Function"
	}
	else {
		local ttl "Survivor"
		local attl "Adjusted Survivor Function"
	}

	if "`at'"!="" {
		Reat `t' `at'
		if "$S_1"!="" {
			local at "$S_1"
		}
		if "`adjustf'"=="" {
			Listat "`sb'" "`grp'" `t' `n' `d' `cens' `ent' /*
			*/ `s' `se' `lb' `ub' "`at'" "`level'" /*
			*/ "`ttl'" 
		}
		else	Listata "`sb'" "`grp'" `t' `s' "`at'" "`ttl'" "`blnk'" "`adjustf'"
		exit
	}


	if "`adjustf'"=="" {
		if "`enter'"!="" {
			local ettl "Enter"
			local liste 1
		}
		else {
			qui drop if `t'==0
			local ettl "     "
			local liste 0
			local net "Net"
		}

		if "`wt'"!="pweight" {
			di in gr _n _col(12) "Beg." _col(26) "`net'" /*
			*/ _col(41) "`ttl'" _col(55) "Std." _n /*
			*/ "  Time    Total   Fail   Lost  `ettl'" /*
			*/ _col(41) /*
			*/ "Function     Error     [`level'% Conf. Int.]" 
			local dupcnt 79
		}
		else {
			di in gr _n _col(12) "Beg." _col(26) "`net'" /*
			*/ _col(41) "`ttl'" _n /*
			*/ "  Time    Total   Fail   Lost  `ettl'" /*
			*/ _col(41) "Function"
			local dupcnt 48
		}
	}
	else { 
		di in gr _n "               Adjusted" /*
		*/ _n "  Time    `blnk'`ttl' Function"
		local dupcnt 27
	}
	di in gr _dup(`dupcnt') "-"

	local i 1
	while `i' <= _N {
		if "`sb'" != "" {
			if `grp'[`i'] != `grp'[`i'-1] {
				sts_sh `grp' "`grp'[`i']" "`sb'"
				di in gr "$S_3"
			}
		}
		if "`adjustf'"=="" {
			di in gr %6.0g `t'[`i'] " " in ye /*
			*/ %8.0g `n'[`i'] " " /*
			*/ %6.0g `d'[`i'] " " /*
			*/ %6.0g `cens'[`i'] " "  _c 
			if `liste' {
				di in ye %6.0g `ent'[`i'] _c
			}
			else	di _skip(6) _c
			di in ye " " /*
			*/ %11.4f `s'[`i'] " " _c
			if "`wt'"!="pweight" {
				di in ye /*
				*/ %9.4f  `se'[`i'] /* standard error */ " " /*
				*/ %10.4f `lb'[`i'] /* lower cb */ " " /*
				*/ %9.4f `ub'[`i'] /* upper cb */
			}
			else	di
		}
		else {
			di in gr %6.0g `t'[`i'] "     " in ye /* 
			*/ %11.4f `s'[`i']
		}
		local i = `i'+1
	}
	di in gr _dup(`dupcnt') "-"
	if "`adjustf'" != "" {
		di in gr "`ttl' function adjusted for `adjustf'"
	}
end


program define GetVal /* grpvar g# var maxlen */
	local grp "`1'"
	local g "`2'"
	local v "`3'"
	local maxlen "`4'"

	tempvar obs newv
	quietly {
		gen `c(obs_t)' `obs' = _n if `grp'==`g'

		summ `obs'
		local j = _result(5)

		local typ : type `v'
		local val = `v'[`j']

		global S_2
		if bsubstr("`typ'",1,3)!="str" {
			local lbl : value label `v'
			if "`lbl'" != "" {
				local val : label `lbl' `val'
			}
			else	global S_2 "`v'="
		}
		global S_1 = substr(trim("`val'"),1,`maxlen')
	}
end


program define sts_sh /* grp g# <byvars> */
	local grp "`1'"
	local g "`2'"
	local by "`3'"

	parse "`by'", parse(" ")
	global S_3
	while "`1'" != "" {
		GetVal `grp' `g' `1' 20
		global S_3 "$S_3$S_2$S_1 "
		* di in gr "$S_2$S_1 " _c
		mac shift
	}
	* di
end

program define Reat /* t <processed at-list> */
	if "`2'"!="reat" {
		global S_1
		exit
	}
	quietly { 
		local t "`1'"
		local n = `3'
		local n = cond(`n'-2<1, 1, `n'-2)
		qui summ `t' if `t'!=0
		local tmin = _result(5)
		local tmax = _result(6)
		local dt = (`tmax' -`tmin')/`n'
		if `dt'>=1 {
			local dt = int(`dt')
		}
		global S_1
		local v = int(`tmin')
		while `v' < `tmax' {
			global S_1 "$S_1 `v'"
			local v = `v' + `dt'
		}
		global S_1 "$S_1 `v'"
	}
end
	

program define Procat /* at-list */
	parse "`*'", parse(" ;:,")
	local i : word count `*'
	if `i'==1 {
		capture confirm integer numb `*'
		if _rc == 0 { 
			capture assert `*' >= 1
		}
		if _rc {
			di in red "at(`*') invalid"
			exit 198
		}
		global S_1 "reat `*'"
		exit
	}

	local i 1 
	while "``i''" != "" {
		if "``i''" == "," {
			local `i' " "
		}
		local i=`i'+1
	}
	capture noisily Procatu `*'
	if _rc {
		di in red "at() invalid"
		exit _rc 
	}
end

program define Procatu /* at-list */
	while "`1'" != "" {
		if "`1'"==":" | "`1'"==";" | "`1'"=="..." | "`1'"==".." {
			if "`l0'"=="" | "`2'"=="" { exit 198 }
			mac shift 
			local cnt 1
		}
		else	local cnt 0
		capture confirm number `1'
		if _rc { exit 198 }
		if "`l1'" != "" {
			if `1'<=`l1' { exit 198 }
		}
		if `cnt' {
			local d = `l1'-`l0'
			local i = `l1'+`d'
			while `i' <= `1' {
				local l0 `l1'
				local l1 `i'
				local list "`list' `i'"
				local i=`i'+`d'
			}
		}
		else {
			local l0 `l1'
			local l1 `1'
			local list "`list' `1'"
		}
		mac shift
	}
	global S_1 "`list'"
end


program define Listata
	local by 	"`1'"
	local grp 	"`2'"
	local t 	"`3'"
	local s		"`4'"
	local at	"`5'"
	local ttl	"`6'"
	local blnk	"`7'"
	local adjustf	"`8'"

	if "`by'"!="" {
		local byp "by `by':"
	}
	di in gr _n "                  Adjusted"
	di in gr    "    Time    `blnk'`ttl' Function" _n _dup(29) "-"

	if "`grp'"=="" {
		tempvar grp
		qui gen byte `grp' = 1
		local ngrp 1
	}
	else {
		qui summ `grp'
		local ngrp = _result(6)
	}

	parse "`at'", parse(" ")

	tempvar obs
	local g 1
	while `g' <= `ngrp' {
		/* set i0, i1: bounds of group */
		qui gen `c(obs_t)' `obs' = _n if `grp'==`g'
		qui summ `obs'
		local i0 = _result(5)
		local i1 = _result(6)
		drop `obs'

		if "`by'" != "" {
			sts_sh `grp' `g' "`by'"
			di in gr "$S_3"
		}

		local j 1
		while "``j''" != "" {
			qui gen `c(obs_t)' `obs' = _n if `t'>``j'' in `i0'/`i1'
			qui summ `obs'
			local i = cond(_result(5)>=.,`i1',_result(5)-1)
			drop `obs'
			if `i'<`i0' {
				di in gr %8.0g ``j'' "     " in ye /* 
				*/ %11.4f 1
			}
			else if `i'==`i1' & ``j''>`t'[`i1'] {
				di in gr %8.0g ``j'' "     " in ye /*
				*/ %11.4f .
			}
			else {
				di in gr %8.0g ``j'' "     " in ye /*
				*/ %11.4f `s'[`i']
			}
			local j=`j'+1
		}
		local g=`g'+1
	}
	di in gr _dup(29) "-" _n  "`ttl' function adjusted for `adjustf'"
end



program define Listat
	local by 	"`1'"
	local grp 	"`2'"
	local t 	"`3'"
	local n 	"`4'"
	local d 	"`5'"
	local cens	"`6'"
	local ent	"`7'"
	local s		"`8'"
	local se	"`9'"
	local lb	"`10'"
	local ub	"`11'"
	local at	"`12'"
	local level	"`13'"
	local ttl	"`14'"		/* "Survival" or " Failure" */

	if "`by'"!="" {
		local byp "by `by':"
	}
	quietly {
		`byp' replace `d'=sum(`d')
		`byp' replace `cens'=sum(`cens')
		`byp' replace `ent' = sum(`ent')
	}

	di in gr _n _col(15) "Beg." /*
	*/ _col(41) "`ttl'" _col(55) "Std." _n /*
	*/ "    Time     Total     Fail" /*
	*/ _col(41) "Function     Error     [`level'% Conf. Int.]" _n /* 
	*/ _dup(79) "-"

	if "`grp'"=="" {
		tempvar grp
		qui gen byte `grp' = 1
		local ngrp 1
	}
	else {
		qui summ `grp'
		local ngrp = _result(6)
	}

	parse "`at'", parse(" ")

	tempvar obs
	local g 1
	while `g' <= `ngrp' {
		/* set i0, i1: bounds of group */
		qui gen `c(obs_t)' `obs' = _n if `grp'==`g'
		qui summ `obs'
		local i0 = _result(5)
		local i1 = _result(6)
		drop `obs'

		if "`by'" != "" {
			sts_sh `grp' `g' "`by'"
			di in gr "$S_3"
		}

		local lfail 0
		local j 1
		while "``j''" != "" {
			qui gen `c(obs_t)' `obs' = _n if `t'>``j'' in `i0'/`i1'
			qui summ `obs'
			local i = cond(_result(5)>=.,`i1',_result(5)-1)
			drop `obs'
			if `i'<`i0' {
				di in gr %8.0g ``j'' "  " in ye /*
				*/          /*
				*/ %8.0g 0 " " /*
				*/ %8.0g 0 " " /*
				*/ _skip(8) /* 
				*/ %11.4f 1 " " /*
				*/ %9.4f  . " " /*
				*/ %10.4f . " " /*
				*/ %9.4f .
			}
			else if `i'==`i1' & ``j''>`t'[`i1'] {
				local ifail = `d'[`i'] - `lfail'
				local lfail = `d'[`i'] 
				di in gr %8.0g ``j'' "  " in ye /*
				*/          /*
				*/ %8.0g `n'[`i'] " " /*
				*/ %8.0g `ifail' " " /*
				*/ _skip(8) /*
				*/ %11.4f . " " /*
				*/ %9.4f  . " " /*
				*/ %10.4f . " " /*
				*/ %9.4f .
			}
			else {
				local ifail = `d'[`i'] - `lfail'
				local lfail = `d'[`i']
				di in gr %8.0g ``j'' "  " in ye /*
				*/          /*
				*/ %8.0g `n'[`i'] " " /*
				*/ %8.0g `ifail' " " /*
				*/ _skip(8) /* 
				*/ %11.4f `s'[`i'] " " /*
				*/ %9.4f  `se'[`i'] " " /*
				*/ %10.4f `lb'[`i'] " " /*
				*/ %9.4f `ub'[`i']
			}
			local j=`j'+1
		}
		local g=`g'+1
	}
	di in gr _dup(79) "-"
	#delimit ;
	di in gr 
"Note:  `ttl' function is calculated over full data and evaluated at" _n
"       indicated times; it is not calculated from aggregates shown at left.";
	#delimit cr
end


program define Licomp 
	local mark	"`1'"
	local by	"`2'"
	local grp	"`3'"
	local t		"`4'"
	local s		"`5'"
	local at	"`6'"
	local failure	"`7'"		/* "failure" or "" */
	local adjustf   "`8'"


	qui summ `grp'
	local ngrp = _result(6)

	local ng 1
	while `ng' <= `ngrp' {
		local nglast=min(`ng'+5,`ngrp')
		Licompu "`mark'" "`by'" "`grp'" `t' `s' "`at'" `ng' `nglast' /*
			*/ "`failure'" "`adjustf'"
		local ng=`ng'+6
	}
	if "`adjustf'"!="" {
		if "`failure'"=="" {
			local ttl "Survivor"
		}
		else	local ttl "Failure"
		di in gr "`ttl' function adjusted for `adjustf'"
	}
end

program define Licompu
	local by	"`2'"
	local grp	"`3'"
	local t		"`4'"
	local s		"`5'"
	local at	"`6'"
	local g0	`7'
	local g1	`8'
	local failure	"`9'"		/* "failure" or "" */
	local adjustf	"`10'"

	di
	if "`failure'"=="" {
		local ttl "Survivor"
	}
	else	local ttl "Failure"
	if "`adjustf'" != "" { 
		local ttl "Adjusted `ttl'"
	}
	local ttl "`ttl' Function"
	local tl = length("`ttl'")

	local wid = (`g1'-`g0'+1)*11-5
	local ldash = int((`wid' - `tl')/2)
	local rdash = `wid' - `tl' - `ldash' 

	if `ldash'>0 & `rdash'>0 {
		di in gr _col(18) _dup(`ldash') "-" "`ttl'" _dup(`rdash') "-"
	}
	else {
		local skip = max(17 + `wid' - `tl', 0)
		di in gr _skip(`skip') "`ttl'"
	}
	parse "`by'", parse(" ")
	while "`1'" != "" {
		di in gr "`1'" _col(13) _c
		local g `g0'
		while `g' <= `g1' {
			GetVal `grp' `g' `1' 9
			local skip = 11 - length("$S_1")
			di in gr _skip(`skip') "$S_1" _c
			* di in gr "12" %9.0g 1 _c
			local g = `g'+1
		}
		di
		mac shift
	}


	local ndash = 12+(`g1'-`g0'+1)*11
	di in gr _dup(`ndash') "-"

	tempvar obs
	parse "`at'", parse(" ")
	local j 1 
	local thead "time"
	while "``j''" != "" {
		di in gr "`thead'" %8.0g ``j'' _c
		local thead "    "
		local g `g0'
		while `g'<=`g1' {
			qui gen `c(obs_t)' `obs' = _n if `grp'==`g'
			qui summ `obs'
			local i0 = _result(5)
			local i1 = _result(6) 
			drop `obs'
			qui gen `c(obs_t)' `obs' = _n if `t'>``j'' in `i0'/`i1'
			qui summ `obs'
			local i = cond(_result(5)>=.,`i1',_result(5)-1)
			drop `obs'
			if `i'<`i0' {
				local res 1
			}
			else if `i'==`i1' & `t'[`i']!=``j'' {
				local res .
			}
			else 	local res = `s'[`i']
			di in ye %11.4f `res' _c
			local g=`g'+1
		}
		di
		local j=`j'+1
	}
	di in gr _dup(`ndash') "-"
end

program define Graph
	local if "opt"
	local in "opt"
	local options "ADjustfor(string) noBorder BY(string) Enter Failure Gwood noLAbel Level(integer $S_level) LOST noORIgin SEParate noSHow STrata(string) T1title(string) T2title(string) TMIn(real -1) TMAx(real -1) TRim(integer 32) XASis XLAbel(string) YASis YLAbel(string) YLOg ATRisk *"
	parse "`*'"

	local t : char _dta[st_t]
	local t0 : char _dta[st_t0]
	local d : char _dta[st_d]
	local id : char _dta[st_id]
	local w  : char _dta[st_w]

	if `level'<10 | `level'>99 { 
		di in red "level() invalid"
		exit 198
	}

	if "`gwood'"!="" {
		local wt : char _dta[st_wt]
		if "`wt'"=="pweight" { 
			di in red "option gwood not allowed with pweighted data"
			exit 198
		}
		local wt
	}

	ByStAdj "`by'" "`strata'" "`adjustf'"
	local by "$S_1"
	local strata "$S_2"
	local adjustf "$S_3"
	local sb "$S_4"

	if "`sb'" == "" { local label "nolabel" }
	else {
		local n : word count `sb'
		if `n'>1 { local label "nolabel" }
		if `n'>1 & ("`separat'"!="" | "`gwood'"!="") {
			di in red "may not specify " _c
			if "`separat'"!="" {
				di in red "separate" _c
			}
			else 	di in red "gwood" _c
			di in red " with more than one by/strata variable."
			di in red /* 
*/ "use " _quote "egen ... = group(`strata')" _quote /*
*/ " to make a single variable"
			exit 198
		}
	}
	if  "`enter'"!="" & "`atrisk'"!="" {
		di in red /*
		*/ "atrisk and enter not possible at the same time"
		exit 198
	}
	if "`adjustf'"!="" {
		if "`gwood'"!="" {
			di in red "gwood not possible with adjustfor()"
			exit 198
		}
		if "`lost'"!="" | "`enter'"!="" | "`atrisk'"!="" {
			di in red /*
			*/ "atrisk, lost and enter not possible with adjustfor()"
			exit 198
		}
	}

	zt_sho_5 `show'

	tempvar touse  mark n d cens ent  s lb ub
	zt_smp_5 `touse' "`if'" "`in'" "`sb'" "`adjustf'"
	preserve
	quietly {
		keep if `touse'
		if "`adjustf'"=="" {
			zt_ct_5 "`by'" -> `t' `n' `d' `cens' `ent'
			if "`enter'"=="" & "`atrisk'"=="" {
				replace `cens' = `cens' - `ent' if `t'
				drop if `d'==0 & `cens'==0
				replace `ent' = 0 
			}
			if "`atrisk'"!="" {
				replace `ent' = `n'[_n+1] if `d'
				if "`lost'"=="" { replace `cens'=0 }
			}
			AddSurv "`by'" `t' `n' `d' `level' -> /* 
				*/ "" `s' "" "" `lb' `ub'
		}
		else { 
			DoAdjust "`by'" "`strata'" "`adjustf'" "" "" -> "" `s'
			KeepDead "`sb'"
		}
		if "`failure'" != "" {
			replace `s'=1-`s'
			if "`adjustf'" == "" {
				replace `lb'=1-`lb'
				replace `ub'=1-`ub'
				local hold "`lb'"
				local lb "`ub'"
				local ub "`hold'"
			}
		}
	}

	if `tmin' != -1 {
		qui drop if `t'<`tmin'
	}
	if `tmax' != -1 { 
		qui drop if `t'>`tmax'
	}
	qui count 
	if _result(1)<1 { 
		di in red "no observations"
		exit 2000
	}

	quietly {
		if "`lost'"=="" & "`atrisk'"=="" {
			if "`adjustf'"=="" {
/*
				drop if `d'==0
*/
				drop `d' 
			}
		}
		else {
			summ `s'
			local eps = max( (_result(6)-_result(5))/50, 0)
			local nps = max( (_result(6)-_result(5))/25,  0)
			tempvar dj tnext s2 s3 newt
			sort `sb' `t' `d'
			if "`sb'"!="" {
				local byst "by `sb':"
			}

			`byst' replace `d'=1 if `d'==0 & (_n==1 | _n==_N)
			`byst' gen `c(obs_t)' `dj' = _n if `d' 
/* above is new */
			`byst' replace `dj'=`dj'[_n-1] if `dj'>=.
			sort `sb' `dj' `d'
			by `sb' `dj': replace `cens'=sum(`cens')
			by `sb' `dj': replace `ent' =sum(`ent')
			by `sb' `dj': keep if _n==_N
			drop `dj'
			sort `sb' `t'
			`byst' gen `tnext'=`t'[_n+1]
`byst' replace `tnext'=`t' if _n==_N
			expand 3 
			sort `sb' `t'
			by `sb' `t': gen `newt' = cond(_n==1, `t', /*
					*/ (`t'+`tnext')/2)
			drop `tnext'
			by `sb' `t': gen `s2' = `s'+`eps' if _n==2
			by `sb' `t': gen `s3' = `s'-`nps' if _n==3
			by `sb' `t': replace `s'=. if _n>1
			by `sb' `t': replace `cens' = 0 /*
				*/ if _n==1 | _n==3
			by `sb' `t': replace `ent' = 0 /*
				*/ if _n==1 | _n==2
			by `sb' `t': keep if _n==1 | /*
				*/ (_n==2 & `cens') | (_n==3 & `ent')
			label var `s2' " " 
			label var `s3' " "
			local mvars "`s2' `s3'"
			local msym "[`cens'][`ent']"
			local mcon ".."
			local mpen "11"
			local lbl : var label `t'
			drop `t' 
			rename `newt' `t'
			label var `t' "`lbl'"
			local lbl
			sort `sb' `t'
		}
	}

	if "`sb'"=="" | "`gwood'"!="" {
		local separat "separate"
	}

	if "`separat'"=="separate" {
		local svars "`s'"
		local ssym "i"
		local scon "J"
		local spen "2"
		if "`sb'"!="" {
			local byopt "by(`sb')"
		}
		if "`gwood'" != "" {
			local svars "`svars' `lb' `ub'"
			local ssym "`ssym'ii"
			local scon "`scon'JJ"
			local spen "`spen'11"
		}
	}
	else {
		quietly { 
			tempvar grp
			by `sb': gen int `grp' = 1 if _n==1
			replace `grp' = sum(`grp')
			local ng = `grp'[_N]
			local i 1 
			local pen 1
			while `i' <= `ng' {
				tempvar x
				gen float `x'=`s' if `grp'==`i'
				local svars "`svars' `x'"
				local ssym "`ssym'i"
				local scon "`scon'J"
				local pen=cond(`pen'<=8,`pen'+1,2)
				local spen "`spen'`pen'"
				local i = `i' + 1
			}
		}
		if "`label'"=="" {
			tempvar smark sttl
			qui MarkPt `t' "`sb'" `s' -> `sttl' `smark'
			local pen 1
			local i 1
			while `i' <= `ng' { 
				tempvar x 
				qui gen float `x'=`smark' if `grp'==`i'
				local pen=cond(`pen'<=8,`pen'+1,2)
				local svars "`svars' `x'"
				local ssym "`ssym'[`sttl']"
				local scon "`scon'."
				local spen "`spen'`pen'"
				local i = `i' + 1
			}
			drop `smark'
		}
	}

	if "`ylabel'"=="" {
		if "`yasis'"=="" {
                       if "`ylog'"!="" {
                                local ylabel "ylabel(.01,.05,.10,.25,.50,.75,1)"
                        }
                        else {
                                local ylabel "ylabel(0,.25,.50,.75,1)"
                        }
			local fvar : word 1 of `svars'
			format `fvar' %9.2f
		}
		else {
			qui summ `s'
                        if "`ylog'"!="" {
                                local min = cond(_result(5)==0,.001,_result(5))
                        }
                        else {
                                local min=_result(5)
                        }
			local max=cond("`origin'"=="",1,_result(6))
			local ylabel "ylabel(`min',`max')"
		}
	}
	else 	local ylabel "ylabel(`ylabel')"

	if "`xlabel'"=="" {
		if "`xasis'"=="" {
			local xlabel "xlabel"
		}
	}
	else	local xlabel "xlabel(`xlabel')"

	if "`border'"=="" { local border "border" }
	else local border

	if "`t1title'"=="" {
		if "`fail'"=="" {
			if "`adjustf'"!="" {
				local t1title "Survivor function"
			}
			else	local t1title "Kaplan-Meier survival estimate"
		}
		else {
			if "`adjustf'"!="" {
				local t1title "Failure function"
			}
			else 	local t1title "Kaplan-Meier failure estimate"
		}
		if "`sb'"!="" {
			local t1title "`t1title's, by `sb'"
		}
		local t1title "t1(`t1title')"
	}
	else {
		if "`t1title'"=="." { 
			local t1title
		}
		else local t1title "t1(`t1title')"
	}

	if "`t2title'"=="" {
		if "`adjustf'"!="" {
			if length("`adjustf'")>50 {
				local adjustf = substr("`adjustf'",1,47)
				local adjustf "`adjustf'..."
			}
			local t2title "t2(adjusted for `adjustf')"
		}
		else if "`gwood'"!="" {
			local t2title "t2(`level'%, pointwise confidence band shown)"
		}
	}
	else {
		if "`t2title'"=="." { 
			local t2title
		}
		else local t2title "t2(`t2title')"
	}
        if "`ylog'" != "" {
                local varcnt: word count  `svars'
                local i 1
                while `i' <= `varcnt' {
                        local varn: word `i' of `svars'
                        qui replace `varn'=.001 if `varn'==0
                        local i=`i'+1
                }
        }
	/*** new by mac *****/
	if "`origin'"=="" {
        	tempvar last flg
        	local N = _N
		if "`by'"=="" & "`strata'"=="" {
			qui gen byte `last'=2 if _n==_N
			qui expand `last'
			qui gen `flg'=1 if _n>`N'
			qui replace `t'=0 if `flg'==1
			if "`failure'" == "" {
				qui replace `s'=1 if `flg'==1
			}
			else qui replace `s'=0 if `flg'==1
		}
		else {
			sort `by' `strata'
			qui by `by' `strata':  gen byte `last'=2 if _n==_N
			qui expand `last'
			qui gen `flg'=1 if _n>`N'
			qui replace `t'=0 if `flg'==1
        		local varcnt: word count  `svars'
			local i 1
			while `i' <= `varcnt' {
				local varn: word `i' of `svars' 
				if "`failure'" == "" {
					qui replace `varn'=1 if `t'==0 
				}
				else qui replace `varn'=0 if `t'==0
                		if bsubstr("`ssym'",-1,1)!="i" &  /*
					*/ `i'> (`varcnt'/2 ) {
					qui replace `varn'=. if `t'==0
				}
				local i=`i'+1
			}
		}
		if "`gwood'"!="" {
			replace  `lb'=. if `flg'==1
			replace  `ub'=. if `flg'==1
		}
		if "`byopt'"!="" {
			 sort `sb'
		 }
		if "`lost'" !="" | "`enter'" !=""  {
			qui replace `cens'=. if `flg'==1	
		}
	}
	gr7 `svars' `mvars' `t', c(`scon'`mcon') s(`ssym'`msym') /*
	*/ pen(`spen'`mpen') `byopt' `ylabel' `xlabel' `border' /*
	*/ `t1title' `t2title' trim(`trim') `ylog' `options' sort
end


program define DoAdjust /* by strata adjustf if in -> haz s */
	local by     "`1'"		/* optional 	*/
	local strata "`2'"		/* optional 	*/
	local adjustf "`3'"		/* required	*/
	local if      "`4'"		/* optional	*/
	local in      "`5'"		/* optional	*/

/* */
	local haz "`7'"			/* optional 	*/
	local s   "`8'"			/* optional 	*/

	if "`strata'"!="" {
		local stopt "strata(`strata')"
	}

	if "`by'"=="" {
		if "`s'" != "" {
			local sopt "bases(`s')"
		}
		if "`haz'" != "" {
			local hopt "baseh(`haz')"
		}
		stcox `adjustf' `if' `in', /*
			*/ `stopt' `sopt' `hopt' estimate norobust
		exit
	}
	if "`haz'" != "" {
		tempvar hi
		local hopt "baseh(`hi')"
		gen double `haz' = . 
	}
	if "`s'" != "" {
		tempvar si
		local sopt "bases(`si')"
		gen double `s' = .
	}
	if !("`if'"=="" & "`in'"=="") {
		tempvar touse 
		mark `touse' `if' `in'
		local cond "if `touse'"
		local andcond "& `touse'"
	}
	tempvar grp
	sort `touse' `by'
	by `touse' `by': gen int `grp' = 1 if _n==1 `andcond'
	replace `grp'=sum(`grp') `cond'
	local ng = `grp'[_N]
	local i 1
	while `i' <= `ng' { 
		capture stcox `adjustf' if `grp'==`i', /*
			*/ `stopt' `sopt' `hopt' estimate norobust
		if _rc==0 {
			if "`hopt'"!="" {
				replace `haz' = `hi' if `grp'==`i' 
				drop `hi'
			}
			if "`sopt'"!="" {
				replace `s' = `si' if `grp'==`i'
				drop `si'
			}
		}
		local i = `i' + 1
	}
end


program define KeepDead /* strata */
	local strata "`1'"

	local t : char _dta[st_t]
	local d : char _dta[st_d]
	if "`d'"!="" {
		/* keep if `d' */
		drop `d'
	}
	sort `strata' `t'
	by `strata' `t': keep if _n==1
end
	


program define MarkPt /* t strata s -> ttl s2 */
	local t "`1'"
	local strata "`2'"
	local s "`3'"
	local ttl "`5'"
	local s2 "`6'"

	tempvar tval mark marksum ls

	summarize `t'
	gen float `tval' = _result(5) + (_result(6)-_result(5))*2/3

	gen byte `mark' = cond(`t'<`tval', 1, 0)
	by `strata': replace `mark'=0 if `mark'[_n+1]==1
	by `strata': gen byte `marksum' = sum(`mark')
	by `strata': replace `mark'=1 if _n==_N & `marksum'==0
	drop `tval' `marksum'

	summarize `s'
	local eps = max( (_result(6)-_result(5))/20,0)
	gen float `ls' = `s'
	by `strata': replace `ls' = `ls'[_n-1] if `ls'>=.
	gen float `s2' = `ls'+`eps' if `mark'
	replace `s2' = `ls'[_n-1]+`eps' if `mark' & `strata'==`strata'[_n-1]

	summarize `s2' 
	replace `s2' = max(`s2'-8*`eps',0) if `s2'==_result(5)
	replace `s2' = `s2'+`eps' if `s2'==_result(6)

	capture confirm string variable `strata'
	if _rc {
		gen str20 `ttl' = "`strata' " + trim(string(`strata')) if `mark'
		local lab : value label `strata'
		if "`lab'" != "" {
			tempvar delab
			decode `strata', gen(`delab')
			replace `ttl' = `delab' if `mark'
		}
	}
	else	gen str20 `ttl' = trim(`strata') if `mark'
	compress `ttl'
end


program define ByStAdj /* by strata adjustf */
	local by      "`1'"
	local strata  "`2'"
	local adjustf "`3'"

	if "`by'" != "" {
		unabbrev `by'
		local by "$S_1"
	}

	if "`strata'"!="" {
		if "`adjustf'"=="" {
			di in red /*
		*/ "strata() requires adjustfor(); perhaps you mean by()"
			exit 198 
		}
		unabbrev `strata'
		local strata "$S_1"
	}

	if "`adjustf'" != "" {
		unabbrev `adjustf'
		local adjustf "$S_1"
	}

	if !("`by'"=="" & "`strata'"=="") {
		if "`by'"!="" & "`strata'"!="" { local sb "`by' `strata'" }
		else if "`by'"!="" { local sb "`by'" }
		else local sb "`strata'"
	}

	global S_1 "`by'"
	global S_2 "`strata'"
	global S_3 "`adjustf'"
	global S_4 "`sb'"
end
exit
