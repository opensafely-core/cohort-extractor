*! version 7.6.0  19feb2019
program define sts_9, sort
	if _caller() < 8 {
		sts_7 `0'
		exit
	}
	version 6, missing
	local vv : display "version " string(_caller()) ":"

	st_is 2 analysis
	gettoken cmd : 0, parse(" ,")
	if `"`cmd'"'=="," | "`cmd'"=="" {
		local cmd graph
	}
	else	gettoken cmd 0 : 0, parse(" ,")

	local l = length("`cmd'")
	if bsubstr("list",1,`l')==`"`cmd'"' {
		List `0'
	}
	else if bsubstr("graph",1,`l')=="`cmd'" {
		Graph `0'
	}
	else if bsubstr("generate",1,`l')=="`cmd'" {
		Gen `0'
	}
	else if bsubstr("test",1,`l')=="`cmd'" {
		Test `0'
	}
	else if "`cmd'"=="if" | "`cmd'"=="in" {
		Graph `cmd' `0'
	}
	else {
		di in red "unknown sts subcommand `cmd'"
		exit 198
	}
end

program define Test, rclass
	local wt : char _dta[st_wt]
	if "`wt'"=="pweight" {
		local options "Cox"
	}
	else	local options "Logrank Breslow Cox Wilcoxon TWare Peto"
	syntax varlist [if] [in] /*
	*/ [, `options' BY(string) Detail noSHow TRend /*
	*/ Fh(numlist min=2 max=2) * ]

	if "`trend'"!="" {
		local n: word count `varlist'
		if `n'>1 {
di in red "only one grouping variable allowed for trend tests"
di in red "use egen, group() to generate one group variable"
			exit 198
		}
		confirm numeric variable `varlist'
	}

	if "`by'"!="" {
		di in red "by() not allowed"
		exit 198 
	}
	local by "by(`varlist')"

	local n1 = ("`fh'"!="")+ /*
	*/ ("`breslow'"!="")+("`wilcoxo'"!="")+("`tware'"!="")+("`peto'"!="")
	if `n1'+("`cox'"!="")+("`logrank'"!="")>1 {
		di in red /*
	    */ "options logrank, wilcoxon, tware, peto, fh and cox are alternatives"
		di in red "they may not be specified together"
		exit 198
	}
	if "`wilcoxo'"!="" {
		local cmd "wilc_st"
	}
	else if "`cox'"!="" | "`wt'"=="pweight" {
		if "`trend'"~="" {
			di in red "trend not valid with option cox or pweight"
			exit 198
		}
		local cmd "ctst_st"
	}
	else if "`tware'"~="" {
		local cmd "tware_st"
	}
	else if "`peto'"~="" {
		local cmd "peto_st"
	}
	else if "`fh'"~="" {
		local cmd "fh_st"
		tokenize `fh'
		if `1'<0 | `2'<0 {
			noi di in red "p and q must be nonnegative"
			exit 198	
		}
		local p="p(`1')"
		local q="q(`2')"

	}
	else	local cmd "logrank"

	st_show `show'
	tempvar touse
	st_smpl `touse' `"`if'"' "`in'"

	if "`cmd'"=="ctst_st" {
		tempname oldest 
		capture {
			capture estimate hold `oldest'
			noisily `vv' `cmd' `varlist' if `touse', `options'
			ret add
		}
		local rc = _rc
		capture estimate unhold `oldest'
		exit `rc'
	}

	local w  : char _dta[st_w]
	if `"`_dta[st_id]'"' != "" {
		local id `"id(`_dta[st_id]')"'
	}
	`vv' `cmd' _t _d `w' if `touse', /*
		*/ t0(_t0) `id' `by' `options' `detail' `trend' `p' `q'
	ret add
	if ("`fh'"!="")+("`tware'"!="")+("`peto'"!="")>0 {
		ret local by
	}
end



/* 
	gen var=thing [var=thing] ...
*/

program define Gen

	local rest `"`0'"'
	gettoken varname rest : rest, parse(" =,")
	gettoken eqsign  rest : rest, parse(" =,")
	gettoken thing   rest : rest, parse(" =,")

	if `"`eqsign'"' != "=" { error 198 }
	while `"`eqsign'"' == "=" {
		confirm new var `varname'
		local thing = lower(`"`thing'"')

		if `"`thing'"' == "s" {
			local Surv `varname'
		}
		else if `"`thing'"' == "ns" {
			local nSurv "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="se(s)" {
			NotPw "se(s)"
			local Se "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="h" | `"`thing'"'=="dchaz" {
			local Haz "`varname'"
		}
		else if `"`thing'"'=="se(lls)" {
			NotPw "se(lls)"
			local sllS "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="ub(s)" | `"`thing'"'=="ub" {
			NotPw "ub(s)"
			local ub "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="lb(s)" | `"`thing'"'=="lb" {
			NotPw "lb(s)"
			local lb "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="n" {
			local Pop "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="na" | `"`thing'"'=="cumrisk" {
			local Aalen "`varname'"
			local notcox `"`varname'=`thing'"'
			local risk "`thing'"
		}
		else if `"`thing'"'=="se(na)" {
			NotPw "se(na)"
			local saalen "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="ub(na)" {
			NotPw "ub(na)"
			local uba "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="lb(na)" {
			NotPw "lb(na)"
			local lba "`varname'"
			local notcox `"`varname'=`thing'"'
		}
		else if `"`thing'"'=="d" { 
			local Die "`varname'"
			local notcox `"`varname'==`thing'"'
		}
		else {
			di in red `"`thing' unknown function"'
			exit 198
		}
		local 0 `"`rest'"'
		gettoken varname rest : rest, parse(" =,")
		gettoken eqsign  rest : rest, parse(" =,")
		gettoken thing   rest : rest, parse(" =,")
	}

	syntax /* ... */ [if] [in] [,  Adjustfor(varlist) BY(varlist) /*
	       */  Level(cilevel) noSHow STrata(varlist)]

	ByStAdj "`by'" "`strata'" "`adjustf'"

	* st_show `show'

	if "`adjustf'" != "" {
		if "`notcox'" != "" {
			di in red "cannot calculate `notcox' with adjustfor()"
			exit 198
		}
		qui DoAdjust "`by'" "`strata'" "`adjustf'" `"`if'"' "`in'" /* 
			*/ -> "`Haz'" "`Surv'"
		if "`Surv'"!="" {
			label var `Surv' "S(t+0), adjusted"
		}
		if "`Haz'"!="" {
			label var `Haz' "Delta_H(t), adjusted"
		}
		exit
	}

	if "`Pop'"=="" { tempvar Pop }
	if "`Die'"=="" { tempvar Die }
	tempvar touse mresult
	st_smpl `touse' `"`if'"' "`in'" "`by'" ""
	preserve 
	quietly {
		keep if `touse'
		st_ct "`by'" -> _t `Pop' `Die' 
		count if `Die'
		if r(N) {		/* keep all obs if no failures */
			keep if `Die'
		}
		AddSurv "`by'" _t `Pop' `Die' `level' -> /* 
		*/ "`Haz'" "" "`Surv'" "`Se'" "`sllS'" "`lb'" "`ub'" /*
		*/ "`Aalen'" "`saalen'" "`uba'" "`lba'" "`nSurv'"
		if "`Haz'" != "" {
			qui sum `Haz', meanonly
			if r(max)==0 {
				qui replace `Haz'=.
			}
		}

		keep `by' _t `Haz' `Surv' `Se' `sllS' `lb' `ub' /*
			*/ `Pop' `Die' `Aalen' `saalen' `uba' `lba' `nSurv'
		gen byte `touse' = 1
		sort `touse' `by' _t
	
		tempfile one 
		save "`one'"
		restore, preserve
		sort `touse' `by' _t 
		merge `touse' `by' _t using "`one'", _merge(`mresult')
		keep if `mresult'==1 | `mresult'==3
		drop `mresult'
		sort `touse' `by' _t 
		local byp "by `touse' `by':"
		if "`Surv'" != "" {
			`byp' replace `Surv' = cond(_n==1,1,`Surv'[_n-1]) /*
				*/ if `Surv'>=. & `touse'
			replace `Surv' = . if `touse'==0
			label var `Surv' "S(t+0)"
		}
		if "`nSurv'" != "" {
			`byp' replace `nSurv' = cond(_n==1,1,`nSurv'[_n-1]) /*
				*/ if `nSurv'>=. & `touse'
			replace `nSurv' = . if `touse'==0
			label var `nSurv' "Modified K-M
		}
		if "`Se'" != "" {
			`byp' replace `Se' = `Se'[_n-1] if `Se'>=. & `touse'
			label var `Se' "se(S) (Greenwood)"
		}
		if "`sllS'" != "" {
			`byp' replace `sllS' = `sllS'[_n-1] if /* 
				*/ `sllS'>=. & `touse'
			label var `sllS' "se(-ln ln S)"
		}
		if "`lb'" != "" {
			`byp' replace `lb' = `lb'[_n-1] if `lb'>=. & `touse'
label var `lb' `"S() `=strsubdp("`level'")'% lower bound"'
		}
		if "`ub'" != "" {
			`byp' replace `ub' = `ub'[_n-1] if `ub'>=. & `touse'
label var `ub' `"S() `=strsubdp("`level'")'% upper bound"'
		}
		if "`Haz'" != "" {
			label var `Haz' "Delta_H(t)"
		}
		if "`Aalen'"!="" {
			`byp' replace `Aalen' = cond(_n==1,0,`Aalen'[_n-1]) /*
				*/ if `Aalen'>=. & `touse'
			replace `Aalen' = . if `touse'==0
			label var `Aalen' "Nelson-Aalen cumulative hazard"
			if "`risk'" == "cumrisk" {
		       		replace `Aalen'=-expm1(-`Aalen') if `touse'
			       label var `Aalen' "Nelson-Aalen cumulative risk"
			}
		}
		if "`saalen'" != "" {
			`byp' replace `saalen' = sqrt(`saalen') 
			`byp' replace `saalen' = `saalen'[_n-1] /*
			*/ if `saalen'>=. & `touse'
			label var `saalen' "se(Nelson-Aalen)"
		}
		if "`lba'" != "" {
			`byp' replace `lba' = `lba'[_n-1] if `lba'>=. & `touse'
label var `lba' `"Nelson-Aalen `=strsubdp("`level'")'% lower bound"'
		}
		if "`uba'" != "" {
			`byp' replace `uba' = `uba'[_n-1] if `uba'>=. & `touse'
label var `uba' `"Nelson-Aalen `=strsubdp("`level'")'% upper bound"'
		}
		label var `Pop' "N, entering population"
		label var `Die' "d, number of failures"
	}
	restore, not
end

program define NotPw /* text */
	if `"`_dta[st_wt]'"' == "pweight" {
		di in red "`*' not possible with pweighted data"
		exit 404
	}
end
		

program define AddSurv /* by t Pop Die lvl -> Haz VHaz Surv Se sllS lb ub */
	args by t N D lvl ARROW h Vh S Se sllS lb ub Aalen saalen uba lba NS
	if "`h'"=="" {
		tempvar h 
	}
	tempvar nh
	gen double `h' = cond(`N'==0,0,`D'/`N')
	gen double `nh' = cond(`N'==0,0,`D'/(`N'+1))
	sort `by' _t
	if "`by'" != "" {
		local byp "by `by':"
	}
	if "`Vh'" == "" {
		tempvar Vh
	}
	gen double `Vh' = cond(`N'==0,0,`D'/(`N'*`N'))
	if "`lba'"!="" | "`uba'"!="" { 
		if "`Aalen'"=="" { tempvar Aalen }
		if "`saalen'"=="" { tempvar saalen }
	}
	if "`Aalen'"!="" {
		`byp' gen double `Aalen' = `h'
		`byp' replace `Aalen' = `Aalen'[_n-1]+`h' if _n>1
	}
	if "`saalen'"!="" {
		tempvar sh
		gen double `sh' =  cond(`N'==0,0,`D'/(`N'^2))
		`byp' gen double `saalen' = `sh'
		`byp' replace `saalen' = `saalen'[_n-1]+`sh' if _n>1
	}
	if "`lba'"!="" | "`uba'"!="" {
		
		local z = invnorm(1-(1-`lvl'/100)/2)
		tempvar phi
		gen double `phi'=(sqrt(`saalen')/`Aalen') if `Aalen'!=0
		if "`lba'" != "" {
			gen double `lba'=(`Aalen')*exp(-`z'*`phi')
			replace `lba'=0 if `lba'<0
		}
		if "`uba'"!="" {
			gen double `uba'=(`Aalen')*exp(`z'*`phi')
		}
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
	if "`NS'" != "" {
		`byp' gen double `NS' = 1-`nh'
		`byp' replace `NS' = `NS'[_n-1]*(1-`nh') if _n>1
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
	syntax [if] [in] [, ADjustfor(varlist) AT(numlist sort) NA/*
		*/ BY(varlist) Compare Enter Failure /*
		*/ Level(cilevel) noSHow STrata(varlist) ]

	local w  : char _dta[st_w]
	local wt : char _dta[st_wt]

	if "`na'"!="" & "`adjustf'"!="" {
		di in red "cannot specify adjustfor() with na option"
		exit 198
	}
	if "`na'"!="" & "`failure'"!="" {
		di in red "failure invalid with na option"
		exit 198
	}

	ByStAdj "`by'" "`strata'" "`adjustf'"
	local sb "`s(sb)'"
	if "`compare'" != "" {
		if "`at'" == "" { 
			local at "10"
		}
		if "`sb'"=="" {
			if "`na'"!="" {
				di in red "compare requires by()"
				exit 198
			}
			di in red "compare requires by() or strata()"
			exit 198
		}
	}


	if "`at'" != "" { 
		Procat `at'
		local at `"`s(at)'"'
	}

	st_show `show'


	tempvar touse  mark n d cens ent  s se lb ub aal saalen uba lba
	st_smpl `touse' `"`if'"' "`in'" "`sb'" "`adjustf'"
	preserve
	quietly {
		keep if `touse'
		if "`adjustf'"=="" {
			st_ct "`by'" -> _t `n' _d `cens' `ent'
			if "`enter'"=="" {
				replace `cens' = `cens' - `ent'
				drop if _d==0 & `cens'==0
				replace `ent' = 0 
			}
			AddSurv "`by'" _t `n' _d `level' -> /* 
		       */ "" "" `s' `se' "" `lb' `ub' `aal' `saalen' `uba' `lba'
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
		if "`na'" != "" {
			replace `s'=`aal'
			replace `lb'=`lba'
			replace `ub'=`uba'
			replace `se'=sqrt(`saalen')
			drop `aal' `lba' `uba' `saalen'
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
		Reat _t `at'
		if "`s(at)'"!="" {
			local at "`s(at)'"
		}
		if "`adjustf'"=="" {
			drop `n' _d `cens' `ent' `se' `lb' `ub'
		}
		if "`na'"!="" {
			local failure "aalen"
		}
		Licomp "" "`sb'" "`grp'" _t `s' "`at'" "`failure'" "`adjustf'"
		exit
	}
	if "`na'"!="" {
		local ttl "Nelson-Aalen"
		local blnk " "
	}	
	else if "`failure'"!="" { 
		local ttl "Failure"
		local blnk " "
		local attl " Adjusted Failure Function"
	}
	else {
		local ttl "Survivor"
		local attl "Adjusted Survivor Function"
	}

	if "`at'"!="" {
		Reat _t `at'
		if "`s(at)'"!="" {
			local at "`s(at)'"
		}
		if "`adjustf'"=="" {
			Listat "`sb'" "`grp'" _t `n' _d `cens' `ent' /*
*/ `s' `se' `lb' `ub' "`at'" `"`=strsubdp("`level'")'"' /*
			*/ "`ttl'" 
		}
		else	Listata "`sb'" "`grp'" _t `s' "`at'" /*
			*/ "`ttl'" "`blnk'" "`adjustf'"
		exit
	}


	if "`adjustf'"=="" {
		if "`enter'"!="" {
			local ettl "Enter"
			local liste 1
		}
		else {
			qui drop if _t==0
			local ettl "     "
			local liste 0
			local net "Net"
		}
		local cil `=string(`level')'
		local cil `=length("`cil'")'
		if `cil' == 2 {
			local spaces "     "
		}
		else if `cil' == 4 {
			local spaces "   "
		}
		else {
			local spaces "  "
		}
		if "`wt'"!="pweight" {
			if "`na'"=="" {
				di in gr _n _col(12) "Beg." _col(26) "`net'" /*
				*/ _col(41) "`ttl'" _col(55) "Std." _n /*
				*/ "  Time    Total   Fail   Lost  `ettl'" /*
				*/ _col(41) /*
*/ `"Function     Error`spaces'[`=strsubdp("`level'")'% Conf. Int.]"'
				local dupcnt 79
			}
			else {
				di in gr _n _col(12) "Beg." _col(26) "`net'" /*
				*/ _col(39) "`ttl'" _col(55) "Std." _n /*
				*/ "  Time    Total   Fail   Lost  `ettl'" /*
				*/ _col(41) /*
*/ `"Cum. Haz.    Error`spaces'[`=strsubdp("`level'")'% Conf. Int.]"'
				local dupcnt 79
			}
		}
		else  {
			di in gr _n _col(12) "Beg." _col(26) "`net'" /*
			*/ _col(39) "`ttl'" _n /*
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
	di in smcl in gr "{hline `dupcnt'}"

	local i 1
	while `i' <= _N {
		if "`sb'" != "" {
			if `grp'[`i'] != `grp'[`i'-1] {
				sts_sh `grp' "`grp'[`i']" "`sb'"
				di in gr "$S_3"
			}
		}
		if "`adjustf'"=="" {
			di in gr %6.0g _t[`i'] " " in ye /*
			*/ %8.0g `n'[`i'] " " /*
			*/ %6.0g (_d[`i']) " " /*
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
			di in gr %6.0g _t[`i'] "     " in ye /* 
			*/ %11.4f `s'[`i']
		}
		local i = `i'+1
	}
	di in smcl in gr "{hline `dupcnt'}"
	if "`adjustf'" != "" {
		di in gr "`ttl' function adjusted for `adjustf'"
	}
end


program define GetVal /* grpvar g# var maxlen */
	args grp g v maxlen


	tempvar obs newv
	quietly {
		gen `c(obs_t)' `obs' = _n if `grp'==`g'

		summ `obs', mean
		local j = r(min)

		local typ : type `v'
		local val = `v'[`j']

		global S_2
		if bsubstr("`typ'",1,3)!="str" {
			local lbl : value label `v'
			if "`lbl'" != "" {
				local val : label `lbl' `val'
			}
			else {
				global S_2 "`v'="
				local val=string(`val')
			}
		}
		global S_1 = udsubstr(trim("`val'"),1,`maxlen')
	}
end


program define sts_sh /* grp g# <byvars> */
	args grp g by

	tokenize "`by'"
	global S_3
	while "`1'" != "" {
		GetVal `grp' `g' `1' 20
		global S_3 "$S_3$S_2$S_1 "
		* di in gr "$S_2$S_1 " _c
		mac shift
	}
	* di
end

program define Reat /* t <processed at-list> */, sclass
	sret clear
	if "`2'"!="reat" {
		exit
	}
	quietly { 
		local t "`1'"
		local n = `3'
		local n = cond(`n'-2<1, 1, `n'-2)
		qui summ _t if _t!=0
		local tmin = r(min)
		local tmax = r(max)
		local dt = (`tmax' -`tmin')/`n'
		if `dt'>=1 {
			local dt = int(`dt')
		}
		local v = int(`tmin')
		/* s(at) contains nothing right now */
		while `v' < `tmax' {
			sret local at "`s(at)' `v'"
			local v = `v' + `dt'
		}
		sret local at "`s(at)' `v'"
	}
end
	

program define Procat /* at-list */, sclass
	sret clear
	local i : word count `0'
	if `i'==1 {
		capture confirm integer numb `0'
		if _rc == 0 { 
			capture assert `0' >= 1
		}
		if _rc {
			di in red `"at(`0') invalid"'
			exit 198
		}
		sret local at "reat `0'"
	}
	else	sret local at `"`0'"'
end


program define Listata
	args by grp t s at ttl blnk adjustf

	if "`by'"!="" {
		local byp "by `by':"
	}
	di in gr _n "                  Adjusted"
	di in smcl in gr /*
	*/ "    Time    `blnk'`ttl' Function" _n "{hline 29}"

	if "`grp'"=="" {
		tempvar grp
		qui gen byte `grp' = 1
		local ngrp 1
	}
	else {
		qui summ `grp'
		local ngrp = r(max)
	}

	tokenize "`at'"

	tempvar obs
	local g 1
	while `g' <= `ngrp' {
		/* set i0, i1: bounds of group */
		qui gen `c(obs_t)' `obs' = _n if `grp'==`g'
		qui summ `obs'
		local i0 = r(min)
		local i1 = r(max)
		drop `obs'

		if "`by'" != "" {
			sts_sh `grp' `g' "`by'"
			di in gr "$S_3"
		}

		local j 1
		while "``j''" != "" {
			qui gen `c(obs_t)' `obs' = _n if _t>``j'' in `i0'/`i1'
			qui summ `obs'
			local i = cond(r(min)>=.,`i1',r(min)-1)
			drop `obs'
			if `i'<`i0' {
				di in gr %8.0g ``j'' "     " in ye /* 
				*/ %11.4f 1
			}
			else if `i'==`i1' & ``j''>_t[`i1'] {
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
	di in smcl in gr "{hline 29}" _n /*
	*/  "`ttl' function adjusted for `adjustf'"
end



program define Listat
	args by grp t n d cens ent s se lb ub at level ttl
	/* ttl is "Survival" "Failure" "Nelson-Aalen" */

	if "`by'"!="" {
		local byp "by `by':"
	}
	quietly {
		`byp' replace _d=sum(_d)
		`byp' replace `cens'=sum(`cens')
		`byp' replace `ent' = sum(`ent')
	}
	if "`ttl'"=="Nelson-Aalen" {
		local pos 39
		local func "Cum. Haz."
	}
	else {  
		local pos 41
		local func "Function "
	}
	di in smcl in gr _n _col(15) "Beg." /*
	*/ _col(`pos') "`ttl'" _col(55) "Std." _n /*
	*/ "    Time     Total     Fail" /*
*/ _col(41) `"`func'    Error     [`=strsubdp("`level'")'% Conf. Int.]"' _n /* 
	*/ "{hline 79}"

	if "`grp'"=="" {
		tempvar grp
		qui gen byte `grp' = 1
		local ngrp 1
	}
	else {
		qui summ `grp'
		local ngrp = r(max)
	}

	tokenize "`at'"

	tempvar obs
	local g 1
	while `g' <= `ngrp' {
		/* set i0, i1: bounds of group */
		qui gen `c(obs_t)' `obs' = _n if `grp'==`g'
		qui summ `obs'
		local i0 = r(min)
		local i1 = r(max)
		drop `obs'

		if "`by'" != "" {
			sts_sh `grp' `g' "`by'"
			di in gr "$S_3"
		}

		local lfail 0
		local j 1
		while "``j''" != "" {
			qui gen `c(obs_t)' `obs' = _n if _t>``j'' in `i0'/`i1'
			qui summ `obs'
			local i = cond(r(min)>=.,`i1',r(min)-1)
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
			else if `i'==`i1' & ``j''>_t[`i1'] {
				local ifail = _d[`i'] - `lfail'
				local lfail = _d[`i'] 
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
				local ifail = _d[`i'] - `lfail'
				local lfail = _d[`i']
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
	di in smcl in gr "{hline 79}"
	#delimit ;
	di in gr 
"Note:  `ttl' function is calculated over full data and evaluated at" _n
"       indicated times; it is not calculated from aggregates shown at left.";
	#delimit cr
end


program define Licomp 
	args mark by grp t s at failure adjustf
	/* failure contains "failure", "aalen" or "" */

	qui summ `grp'
	local ngrp = r(max)

	local ng 1
	while `ng' <= `ngrp' {
		local nglast=min(`ng'+5,`ngrp')
		Licompu "`mark'" "`by'" "`grp'" _t `s' "`at'" `ng' `nglast' /*
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
	args IGNORE by grp t s at g0 g1 failure adjustf
	/* failure contains "failure", "aalen" or "" */
	di
	if "`failure'"=="" {
		local ttl "Survivor"
	}
	else if "`failure'"=="aalen" {
		local ttl "Nelson-Aalen"
	}
	else	local ttl "Failure"
	if "`adjustf'" != "" { 
		local ttl `"Adjusted `ttl'"'
	}
	if "`failure'"=="aalen" {
		local ttl `"`ttl' Cum. Haz."'
	}
	else local ttl `"`ttl' Function"'
	local tl = length(`"`ttl'"')

	local wid = (`g1'-`g0'+1)*11-5
	local ldash = int((`wid' - `tl')/2)
	local rdash = `wid' - `tl' - `ldash' 

	if `ldash'>0 & `rdash'>0 {
		di in smcl in gr /*
		*/ _col(18) "{hline `ldash'}`ttl'{hline `rdash'}"
	}
	else {
		local skip = max(17 + `wid' - `tl', 0)
		di in gr _skip(`skip') "`ttl'"
	}
	tokenize `"`by'"'
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
	di in smcl in gr "{hline `ndash'}"

	tempvar obs
	tokenize `"`at'"'
	local j 1 
	local thead "time"
	while "``j''" != "" {
		di in gr "`thead'" %8.0g ``j'' _c
		local thead "    "
		local g `g0'
		while `g'<=`g1' {
			qui gen `c(obs_t)' `obs' = _n if `grp'==`g'
			qui summ `obs'
			local i0 = r(min)
			local i1 = r(max)
			drop `obs'
			qui gen `c(obs_t)' `obs' = _n if _t>``j'' in `i0'/`i1'
			qui summ `obs'
			local i = cond(r(min)>=.,`i1',r(min)-1)
			drop `obs'
			if `i'<`i0' {
				local res 1
			}
			else if `i'==`i1' & _t[`i']!=``j'' {
				local res .
			}
			else 	local res = `s'[`i']
			di in ye %11.4f `res' _c
			local g=`g'+1
		}
		di
		local j=`j'+1
	}
	di in smcl in gr "{hline `ndash'}"
end

program define ChkYScale4Log, sclass
	syntax [, YLOg LOG * ]

	sreturn clear
	if "`ylog'`log'" != "" {
		sreturn local log log
	}
	sreturn local options `"`s(log)' `options'"'
end

program define Graph
	syntax [if] [in] [,		///
		ADjustfor(varlist)	///
		NA			///
		CENsored(string)	///
		CNA			///
		Hazard 			///
		Enter			///
		Failure 		///
		Gwood			///
		Level(integer $S_level)	///
		LOST			///
		noORIgin		///
		SEParate 		///
		noSHow			///
		STrata(varlist)		///
		TMIn(real -1)		///
		TMAx(real -1)		///
		TRim(integer 32)	///
		per(real 1.0)		///
		YLOg			///
		ATRisk			///
		Kernel(string)          ///
		width(string)		///
		CIHazard		///
		*			///
	]

	local gropts `"`options'"'
	_get_gropts , graphopts(`options')	///
		grbyable			///
		getallowed(			///
			CIOPts			///
			ATRISKOPts		///
			LOSTOPts		///
			plot			///
			addplot			///
			YSCale			///
		)				///
		getbyallowed(LEGend TItle)
	local by `s(varlist)'
	local byttl `"`s(by_title)'"'
	local bylgnd `"`s(by_legend)'"'
	local byopts `"`s(byopts)'"'
	local options `"`s(graphopts)'"'
	local ciopts `"`s(ciopts)'"'
	local atopts `"`s(atriskopts)'"'
	local lstopts `"`s(lostopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	local yscale `"`s(yscale)'"'
	_check4gropts ciopts, opt(`ciopts')

	if `"`atopts'"' != "" {
		local atrisk atrisk
	}
	if `"`lstopts'"' != "" {
		local lost lost
	}

	ChkYScale4Log , `ylog' `yscale'
	local ylog `s(log)'
	if "`s(options)'" != "" {
		local options `"yscale(`s(options)') `options'"'
		local yscale
	}

	if "`hazard'"!="" {
		if `per' != 1.0 {
			di in red "option hazard not allowed with per()"
			exit 198
		}
		foreach x in na cna enter failure gwood ///
			lost atrisk {
			ForbidOpt ``x''
		}
		if `"`censored'"'!="" {
			di in red "censored() not allowed with hazard plots"
			exit 198
		}
		local origin noorigin
		local conopt connect(l ...)
	}
	else {
		local conopt connect(J ...)
		local ylabopt ylabel(\`ylab', grid)
	}
	if "`cihazard'"!="" & "`hazard'"=="" {
		di in red "cihazard may only be specified with hazard"
		exit 198
	}

	local w  : char _dta[st_w]
	if "`enter'"!="" & "`lost'"=="" {
		local lost="lost"
	}	
	if "`cna'"!="" {
		local na="na"
	}
	if `level'<10 | `level'>99 { 
		di in red "level() invalid"
		exit 198
	}
	if `"`kernel'"' != "" {
		if "`hazard'" == "" {
			di in red "kernel() allowed only with hazard"
			exit 198
		}
	}
	if `"`width'"' != "" {
		if "`hazard'" == "" {
			di in red "width() allowed only with hazard"
			exit 198
		}
	}
	if "`na'"!="" & "`adjustf'"!="" {
		di in red "cannot specify adjustfor() with na or cna options"
		exit 198
	}
	if "`cihazard'"!="" & "`adjustf'"!="" {
		di in red "cannot specify adjustfor() with cihazard"
		exit 198
	}
	if "`na'"!="" & "`failure'"!="" {
		di in red "failure invalid with na or cna options"
		exit 198
	}
	if "`na'"!="" & "`gwood'"!="" {
		di in red "gwood invalid with na or cna options"
		exit 198
	}
	if "`na'"!="" & `per' != 1.0 {
		di in red "option na not allowed with per()"
		exit 198
	}
/*	if "`failure'"!="" & `per' != 1.0 {
		di in red "option failure not allowed with per()"
		exit 198
	}
*/
	if "`gwood'"!="" {
		if "`_dta[st_wt]'"=="pweight" { 
			di in red "option gwood not allowed with pweighted data"
			exit 198
		}
		if `per' != 1.0 {
			di in red "option gwood not allowed with per()"
			exit 198
		}
	}
	if "`cna'"!="" {
		if `per' != 1.0 {
			di in red "option cna not allowed with per()"
			exit 198
		}
		if "`_dta[st_wt]'"=="pweight" { 
			di in red "option cna not allowed with pweighted data"
			exit 198
		}
	}
	if `per' != 1.0 {
		if "`atrisk'"!="" {
			di in red "option atrisk not allowed with per()"
			exit 198
		}
		if "`lost'"!="" {
		di in red "options lost and enter not allowed with per()"
			exit 198
		}
	}
	if "`ylog'"!="" & `per' != 1.0 {
		di in red "option ylog not allowed with per()"
		exit 198
	}
	if "`na'"!="" {
		local origin "noorigin"
		local ttlpos 5
	}
	else	local ttlpos 1
	ByStAdj "`by'" "`strata'" "`adjustf'"
	local sb "`s(sb)'"

	if "`sb'" != "" {
		local n : word count `sb'
		if `n'>1 & ///
			("`separat'"!="" | "`gwood'"!="" | ///
			 "`hazard'"!="" | "`cna'"!="" | "`cihazard'"!="" ) {
			di in red "may not specify " _c
			if "`separat'"!="" {
				di in red "separate" _c
			}
			else if "`gwood'"!="" {
				di in red "gwood" _c
			}
			else if "`hazard'"!="" {
				di in red "hazard" _c
			}
			else  di in red "cna" _c
			di in red " with more than one by/strata variable;"
			di in red /* 
*/ "use " _quote "egen ... = group(`strata')" _quote /*
*/ " to make a single variable"
			exit 198
		}
	}

	if  "`censored'"!="" & ("`lost'"!="" | "`enter'"!="" | "`atrisk'"!="") {
		di in red /*
		*/ "censored() not possible with lost, enter, or atrisk" 
		exit 198
	}
	if "`censored'"~="" {
		local l = length("`censored'")
		if bsubstr("numbered",1,max(1,`l')) == "`censored'" {
			local censt= "numbered"
		}
		else if bsubstr("single",1,max(1,`l')) == "`censored'" {
			local censt= "single"
		}
		else if bsubstr("multiple",1,max(1,`l')) == "`censored'" {
			local censt= "multiple"
		}
		else {
			di in red "invalid option censored(`censored')"
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
		if "`lost'"!="" | "`enter'"!="" | "`atrisk'"!="" /*
		*/ | "`censored'"!="" {
			di in red /*
		*/ "atrisk, censored, lost, or enter not possible with adjustfor()"
			exit 198
		}
	}

	st_show `show'

	tempvar touse  mark n d cens ent h Vh s lb ub aal uba lba
	st_smpl `touse' `"`if'"' "`in'" "`sb'" "`adjustf'"

	preserve

quietly {

	keep if `touse'
	if "`adjustf'"=="" {
		if "`censored'"~="" {
			tempvar mycens
			st_ct "`by'" -> _t `n' _d "" `ent' `mycens'
			local enter="enter"
			local notreal="notreal"
			gen double `cens'=`mycens'
			drop `mycens'
		}
		else {
			st_ct "`by'" -> _t `n' _d `cens' `ent'
		}
		if "`enter'"=="" & "`atrisk'"=="" {
			replace `cens' = `cens' - `ent' if _t
			drop if _d==0 & `cens'==0
			replace `ent' = 0 
		}
		if "`atrisk'"!="" {
			replace `ent' = `n'[_n+1] if _d
			if "`lost'"=="" {
				replace `cens'=0
			}
		}
		AddSurv "`by'" _t `n' _d `level' -> /* 
		*/ `h' `Vh' `s' "" "" `lb' `ub' `aal' ""  `uba' `lba'

	}
	else { 
		DoAdjust "`by'" "`strata'" "`adjustf'" "" "" -> `h' `s'
		if "`hazard'"=="" {
			KeepDead "`sb'"
		}
		gen `Vh' = 1 // not used with adjustfor
		gen `ub' = . // not used with adjustfor
		gen `lb' = . // not used with adjustfor
	}
	if "`hazard'" != "" {
		keep if _d
		sort `sb' _t 
		by `sb' _t: keep if _n==1
		tempvar ub1 lb1
		SmoothHazard  _t `h' `Vh' "`kernel'" `"`width'"' `tmin' ///
			`tmax' `"`sb'"' `"`ub1'"' `"`lb1'"' `level'
		sort `sb' _t 
		qui replace `s' = `h'
		qui replace `ub' = `ub1'
		qui replace `lb' = `lb1'
	}
	label var `s' "Survivor function"
	if "`failure'" != "" {
		replace `s'=1-`s'
		if "`adjustf'" == "" {
			replace `lb'=1-`lb'
			replace `ub'=1-`ub'
			local hold "`lb'"
			local lb "`ub'"
			local ub "`hold'"
		}
		label var `s' "Failure function"
	}
	if "`hazard'"!="" {
		label var `s' "Smoothed hazard function"
	}
	if "`na'" != "" {
		replace `s'=`aal'
		replace `lb'=`lba'
		replace `ub'=`uba'
		drop `aal' `lba' `uba' 
		label var `s' "Cumulative hazard"
	}
	cap confirm var `lb'
	if !_rc {
		label var `lb' `"`=strsubdp("`level'")'% CI"'
		label var `ub' `"`=strsubdp("`level'")'% CI"'
	}

	if `tmin' != -1 {
		drop if _t<`tmin'
	}
	if `tmax' != -1 { 
		drop if _t>`tmax'
	}
	qui count 
	if r(N)<1 { 
		di in red "no observations"
		exit 2000
	}

	if "`lost'"=="" & "`atrisk'"=="" {
		if "`adjustf'"=="" {
			drop _d 
		}
	}
	else {
		summ `s'
		local eps = max( (r(max)-r(min))/30, .0)
		tempvar dj tnext s2 s3 newt
		sort `sb' _t _d
		if "`sb'"!="" {
			local byst "by `sb':"
		}

		`byst' replace _d=1 if _d==0 & (_n==1 | _n==_N)
		`byst' gen `c(obs_t)' `dj' = _n if _d 
		`byst' replace `dj'=`dj'[_n-1] if `dj'>=.
		sort `sb' `dj' _d
		by `sb' `dj': replace `cens'=sum(`cens')
		by `sb' `dj': replace `ent' =sum(`ent')
		by `sb' `dj': keep if _n==_N
		drop `dj'
		sort `sb' _t
		`byst' gen `tnext'=_t[_n+1]
		`byst' replace `tnext'=_t if _n==_N
		expand 3 
		sort `sb' _t
		by `sb' _t: gen `newt' = cond(_n==1, _t, /*
				*/ (_t+`tnext')/2)
		drop `tnext'
		by `sb' _t: gen `s2' = `s'+`eps' if _n==2
		by `sb' _t: gen `s3' = `s'-`eps' if _n==3
		by `sb' _t: replace `s'=. if _n>1
		by `sb' _t: replace `cens' = 0 /*
			*/ if _n==1 | _n==3
		by `sb' _t: replace `ent' = 0 /*
			*/ if _n==1 | _n==2
		by `sb' _t: keep if _n==1 | /*
			*/ (_n==2 & `cens') | (_n==3 & `ent')
		local lbl : var label _t
		drop _t 
		rename `newt' _t
		label var _t `"`lbl'"'
		local lbl
		sort `sb' _t
		sum `s2', mean
		if r(N) > 0 {
			label var `s2' "Number lost"
			local s2l `cens'
		}
		else	local s2
		sum `s3', mean
		if r(N) > 0 {
			label var `s3' "Number entered"
			local s3l `ent'
		}
		else	local s3
		if `"`s2'"' != "" {
			local mgraph			///
			(scatter `s2' _t,		///
				sort			///
				connect(none)		///
				msymbol(none)		///
				mlabel(`s2l')		///
				mlabposition(0)		///
				pstyle(p1)		///
				\`ysca'			/// yet to exist
				`lstopts'		///
			)				///
			// blank
		}
		if `"`s3'"' != "" {
			local mgraph			///
			`mgraph'			///
			(scatter `s3' _t,		///
				sort			///
				connect(none)		///
				msymbol(none)		///
				mlabel(`s3l')		///
				mlabposition(0)		///
				pstyle(p1)		///
				\`ysca'			/// yet to exist
				`atopts'		///
			)				///
			// blank
		}
	}

} // quietly

	if "`sb'"=="" | "`gwood'"!="" | "`cna'"!="" | "`cihazard'"!="" {
		local separat "separate"
	}

	if "`separat'"=="" & `"`byopts'"' != "" {
		local 0 , `byopts'
		syntax [, ZZ_OPTION_TO_GET_ERROR_MESSAGE ]
		error 198	// should not get here
	}

	if "`separat'"=="separate" {
		local svars "`s'"
		if "`gwood'" != "" | "`cna'"!="" | "`cihazard'"!="" {
			local cigraph			///
			(rline `lb' `ub' _t,		///
				sort			///
				connect(J)		///
				pstyle(ci)		///
				\`ysca'			/// yet to exist
				`ciopts'		///
			)				///
			// blank
		}
	}
	else {

		quietly { 

			tempvar grp id
			by `sb': gen int `grp' = 1 if _n==1
			replace `grp' = sum(`grp')
			gen `id' = _n
			local ng = `grp'[_N]
			local i 1
			local j 1
			while `i' <= `ng' {
				tempvar x
				gen float `x'=`s'*`per' if `grp'==`i'
				local svars "`svars' `x'"
				GetGroupLabel `sb' if `grp'==`i', id(`id')
				label var `x' `"`r(label)'"'
				local i = `i' + 1
			}
		} // quietly
	}

	if "`na'" == "" & "`hazard'" == "" {    // survival
		if "`ylog'"!="" {
			local ylab ".01 .05 .10 .25 .50 .75 1"
		}
		else {
			local yfact= .25*`per'
			local ylab "0(`yfact')`per'"
		}
	}

	// format the first var to be graphed, this makes the yaxis labels
	// look nice

	if "`hazard'"=="" {
		local fvar : word 1 of `svars'
		format `fvar' %9.2f
	}

	if "`na'"!="" {
		local ttl "Nelson-Aalen cumulative hazard estimate"
	}
	else if "`hazard'"!="" {
		local ttl "Smoothed hazard estimate"
		if "`cihazard'"!="" {
			local cigraph			///
			(rline `lb' `ub' _t,		///
				sort			///
				`conopt'  		///
				pstyle(ci)		///
				\`ysca'			/// yet to exist
				`ciopts' 		///
			)				///
			// blank 
		}
	}
	else if "`failure'"=="" {
		if "`adjustf'"!="" {
			local ttl "Survivor function"
		}
		else{
			local ttl "Kaplan-Meier survival estimate"
		}
	}
	else {
		if "`adjustf'"!="" {
			local ttl "Failure function"
		}
		else {
			local ttl "Kaplan-Meier failure estimate"
		}
	}

	if "`sb'"!="" {
		if `per' != 1 {
			local ttl `"`ttl's per `per', by `sb'"'
		} 
		else local ttl `"`ttl's, by `sb'"'
	}
	else {
		if `per' != 1 {
			local ttl `"`ttl' per `per'"'
		}
	}


	if "`adjustf'"!="" {
		if length("`adjustf'")>50 {
			local adjustf = usubstr("`adjustf'",1,47)
			local adjustf "`adjustf'..."
		}
		local ttl2 "adjusted for `adjustf'"
	}

	if "`ylog'" != "" {
       		local varcnt: word count  `svars'
		local i 1
		while `i' <= `varcnt' {
			local varn: word `i' of `svars' 
			qui replace `varn'=. if `varn'<=0 
			local i=`i'+1
		}
		local ysca yscale(log)
	}

	/*** new by mac *****/
	if "`origin'"=="" {
		tempvar last flg
		local N = _N
		if "`by'"=="" & "`strata'"=="" {
			qui gen byte `last'=2 if _n==_N
			qui expand `last'
			qui gen `flg'=1 if _n>`N'
			qui replace _t=0 if `flg'==1
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
			qui replace _t=0 if `flg'==1
			local varcnt: word count  `svars'
			local i 1
			while `i' <= `varcnt' {
				local varn: word `i' of `svars' 
				if "`failure'" == "" {
					qui replace `varn'=1*`per' if _t==0 
				}
				else qui replace `varn'=0 if _t==0
				local i=`i'+1
			}
		}
		if `"`sttl'"' != "" {
			qui replace `sttl' = "" if `flg'==1
		}
		if "`gwood'"!="" {
			qui replace  `lb'=. if `flg'==1
			qui replace  `ub'=. if `flg'==1
		}
		if "`notreal'"=="" {
			if "`lost'" !="" | "`enter'" !=""  {
				tempvar tempce
				qui gen str8 `tempce' = string(`cens')
				qui replace `tempce'="" if `flg'==1	
				qui drop `cens'
				qui rename `tempce' `cens'
				qui replace `cens'=trim(`cens')
			}
		}
	}
	if "`na'"~="" | "`origin'"~="" { 
		tempvar flg
		qui gen int `flg'=.
	}
	if `"`censt'"'== "numbered" | `"`censt'"'=="single" {
		tempvar tmvars tsym expw tu nextt mins
		qui gen double `mins'=1-`s' 
		sort `mins' _t
		qui gen double `nextt'=_t[_n+1]
		qui by `mins': replace `nextt'=`nextt'[_N]
		qui sum _t, meanonly
		local adjd=(r(max)-r(min))/450
		qui gen int `expw'=2  if `cens'>0 & `cens'<. & `flg'>=.
		local N=_N
		qui expand `expw'
		qui replace `expw'=cond(_n>`N',2,.)
		sort   _t `s' `expw'
		qui by _t: replace _t=_t+`adjd' if `expw'==2 & _n==1 & /*
		*/ _t+`adjd'<`nextt'
		qui gen double `tmvars'=`s' if `expw'==2
		format `tmvars' %9.2f
		label var `tmvars' "Censored"
		if "`na'"=="" & "`cna'"=="" {
			qui gen `tu'=`tmvars'+.02 if `expw'==2
		}
		else {
			noi sum `s', meanonly
			qui gen `tu'=`tmvars'+ (r(max)-r(min))/45 if `expw'==2
		}
		label var `tu' "Censored"
		local tmvars="`tmvars' `tu'"
		if "`sttl'"!="" {
			qui replace `sttl'="" if `expw'==2
		}
		if  `"`censt'"'=="numbered" {
			local N=_N
			qui expand `expw'
			qui replace `expw'=cond(_n>`N',2,.)
			qui replace `s'=.  if `expw'==2
			qui replace `cens'=. if `expw'~=2
			local ctgraph			///
			(scatter `tu' _t,		///
				sort			///
				connect(none)		///
				msymbol(none)		///
				mlabel(`cens')		///
				mlabpos(12)		///
				pstyle(p1)		///
				`ysca'			///
			)
			if "`sttl'"!="" {
				qui replace `sttl'="" if `expw'==2
			}
		}
		local ctgraph				///
		(rspike `tmvars' _t,			///
			sort				///
			`ysca'				///
		)					///
		`ctgraph'				///
		// blank
	}
	else if  `"`censt'"'=="multiple" {
		tempvar tmvars tsym expw tu nextt mins
		qui gen double `mins'=1-`s' 
		sort `mins' _t
		qui gen double `nextt'=_t[_n+1]
		qui by `mins': replace `nextt'=`nextt'[_N]
	

		qui sum _t, meanonly
		local adjd=(r(max)-r(min))/350
		qui gen int `expw'=`cens'+1  if `cens'>0 & `cens'<. & `flg'>=.
		local N=_N
		qui expand `expw'
		qui replace `expw'=cond(_n>`N',2,.)
		qui gen double `tmvars'=`s' if `expw'==2
		sort  _t `s' `expw'
		tempvar move ttime 
		qui by  _t: gen int `move'=1 if _t+`adjd'*_n<=`nextt' /*
		*/ & `expw'==2
		qui by  _t: replace `move'=2 if `move'>=. & /*
		*/ _t-`adjd'*_n>=_t[1] & `expw'==2
		qui by  _t: gen double `ttime'= _t+`adjd'*_n if `move'==1
		qui by  _t: replace `ttime'= _t-`adjd'*_n if `move'==2
		qui replace _t= `ttime' if `ttime'<.
		drop `ttime' `move' 


		sort  `s' _t `expw'
		format `tmvars' %9.2f
		if "`na'"=="" & "`cna'"=="" {
			qui gen `tu'=`tmvars'+.02 if `expw'==2
		}
		else {
			noi sum `s', meanonly
			qui gen `tu'=`tmvars'+ (r(max)-r(min))/45 if `expw'==2
		}
		label var `tmvars' "Censored"
		local tmvars="`tmvars' `tu'"
		label var `tu' "Censored"
		if "`sttl'"!="" {
			qui replace `sttl'="" if `expw'==2
		}
		local ctgraph				///
		(rspike `tmvars' _t,			///
			sort				///
			`ysca'				///
		)					///
		// blank
	}

	if `"`cigraph'"' == "" {
		local lb
		local ub
	}
	local nv : word count `svars' `lb'
	if `nv' > 1 {
		numlist "1/`nv'"
		local legend legend(order(`r(numlist)'))
	}
	else if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}

	if `"`separat'"' != "" {
		if "`sb'"!="" {
			local byopt `"by(`sb' , \`byann' `byopts')"'
		}
	}

	if `"`byopt'"' != "" {
		if `"`byttl'"' == "" {
			local byttl `"title(`"`ttl'"' `"`ttl2'"')"'
		}
		if `"`bylgnd'"' == "" {
			local bylgnd `"`legend'"'
			local legend
		}
		local byann `"`byttl' `bylgnd'"'
	}
	else {
		local title `"title(`"`ttl'"' `"`ttl2'"')"'
	}

	if `"`plot'`addplot'"' != "" {
		local draw nodraw
	}
	local nvars : word count `svars'
	local nvars = min(`nvars',15)
	forval i = 1/`nvars' {
		local pseries `"`pseries' p`i'line"'
	}
	quietly replace `s' = `s'*`per'
	if `"`tmin'"' != "" {
		foreach svar of local svars {
			qui replace `svar' = . if _t < `tmin'
		}
	}
	version 8: graph twoway			///
	`cigraph'				///
	(line `svars' _t,			///
		sort				///
		`conopt'			///
		`ylabopt'       		///
		ytitle(`""')			///
		`ysca'				///
		xtitle(`"analysis time"')	///
		pstyle(`pseries')		///
		`title'				///
		`legend'			///
		`draw'				///
		`byopt'				///
		`options'			///
	)					///
	`mgraph'				/// labels censored, lost
	`ctgraph'				/// censor ticks
	// blank
	if `"`plot'`addplot'"' != "" {
		restore
		version 8: graph addplot `plot' || `addplot' || , norescaling
	}
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
			local hopt "basehc(`haz')"
		}
		stcox `adjustf' `if' `in', /*
			*/ `stopt' `sopt' `hopt' estimate norobust
		exit
	}
	if "`haz'" != "" {
		tempvar hi
		local hopt "basehc(`hi')"
		gen double `haz' = . 
	}
	if "`s'" != "" {
		tempvar si
		local sopt "bases(`si')"
		gen double `s' = .
	}
	if !(`"`if'"'=="" & "`in'"=="") {
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
	args strata

	local d : char _dta[st_d]
	if `"`_dta[st_d]'"'!="" {
		/* keep if `_dta[st_d]' */
		drop `_dta[st_d]'
	}
	sort `strata' _t
	by `strata' _t: keep if _n==1
end

program define MarkPt /* t strata s -> ttl s2 */
	args t strata s ARROW ttl s2

quietly {

	tempvar mark marksum ls

	summarize `t', mean
	local tval = r(min) + (r(max)-r(min))*2/3

	gen byte `mark' = cond(`t'<`tval', 1, 0)
	by `strata': replace `mark'=0 if `mark'[_n+1]==1
	by `strata': gen byte `marksum' = sum(`mark')
	by `strata': replace `mark'=1 if _n==_N & `marksum'==0
	drop `marksum'

	summarize `s', mean
	local eps = 0 // this use to be "= max( (r(max)-r(min))/20, 0)"
	gen float `ls' = `s'
	by `strata': replace `ls' = `ls'[_n-1] if `ls'>=.
	gen float `s2' = `ls'+`eps' if `mark'
	replace `s2' = `ls'[_n-1]+`eps' if `mark' & `strata'==`strata'[_n-1]

	summarize `s2', mean

	capture confirm string variable `strata'
	if _rc {
		gen str20 `ttl' = "`strata' " + trim(string(`strata')) if `mark'
		local lab : value label `strata'
		if "`lab'" != "" {
			tempvar delab
			decode `strata', gen(`delab') maxlen(20)
			replace `ttl' = `delab' if `mark'
		}
	}
	else	gen str20 `ttl' = trim(`strata') if `mark'
	compress `ttl'

} // quietly

end

program define ByStAdj, sclass
	args by strata adjustf

	sret clear
	if "`strata'"!="" {
		if "`adjustf'"=="" {
			di in red /*
		*/ "strata() requires adjustfor(); perhaps you mean by()"
			exit 198 
		}
	}

	if !("`by'"=="" & "`strata'"=="") {
		if "`by'"!="" & "`strata'"!="" { 
			sret local sb "`by' `strata'"
		}
		else if "`by'"!="" { 
			sret local sb "`by'" 
		}
		else 	sret local sb "`strata'"
	}
end

program define GetGroupLabel, rclass
	syntax varlist [if] , id(varname)

	sum `id' `if', mean
	local n = r(min)
	foreach var of local varlist {
		cap confirm numeric var `var'
		if _rc {		// string variable
			local ll = usubstr(`var'[`n'],1,20)
		}
		else {			// numeric variable
			sum `var' `if', mean
			local ll `"`var' = `: label (`var') `=r(min)''"'
		}
		local lab `"`lab'`sep'`ll'"'
		local sep "/"
	}
	return local label `"`lab'"'
end

program define SmoothHazard
	args time deltah deltaVh kernel width tmin tmax sb ub lb level

	local by `"`sb'"'
	if `"`by'"' != "" {
		local byLabel : value label `by'
	}

	drop if `deltah' == 0 | `deltah' == .
	tempvar tvar group id
	if `"`width'"' != "" {
		foreach j of local width {
			if "`j'"!="." {
				confirm number `j'
			}
		}
	}
	if "`by'" != "" {
		qui egen `group' = group(`by')
		qui summarize `group', meanonly
		local ngroup = r(max)
		qui gen `id' = _n
	}
	else {
		qui gen `group' = `time'<.
		local ngroup = 1
	}
	if _N < 101 {
		set obs 101
	}
	qui summarize `time'
	if `tmin' == -1 {
		local tmin = r(min)
	}
	if `tmax' == -1 {
		local tmax = r(max)
	}
	qui gen `tvar' = `tmin' + (_n-1)/100*(`tmax'-`tmin') in 1/101
	forvalues i = 1/`ngroup' {
		local w : word `i' of `width'
		if `"`w'"' != "" {
			if `"`w'"' == "." {
				local wopt 
			}
			else {
				local wopt width(`w')
			}
		}
		else {
			local wopt
		}
		version 8: qui kdensity `time' [iw=`deltah'] ///
			if `group'==`i', ///
			`kernel' `wopt' ///
			gen(__y`i') at(`tvar') ///
			nograph
		qui summ `time' if `group'==`i'
		qui replace __y`i'=. if `tvar'<r(min) | `tvar'>r(max)
		qui gen __yy`i' = .
		if `"`wopt'"' == "" {
			quietly summ `time' if ///
				`group'==`i', detail
			local wid2 = min(r(sd), (r(p75)-r(p25))/1.349)
			if `wid2' <= 0.0 {
				local wid2 = r(sd)
			}
			local wid2 = 0.9*`wid2'/(r(N)^.20)
			local wopt width(`wid2')
		}
		di `" --wopt is--`wopt'"'
		_KDE2 `time' [iw=`deltaVh'] if `group'==`i', `kernel' ///
			at(`tvar') kde(__yy`i') `wopt'
		if "`by'"!="" {
			qui summ `id' if `group'==`i'
			local index r(min)
			version 8: qui gen __by`i' = `by'[`index'] in 1/101
			qui label values __by`i' `byLabel'
		}
		local z = invnorm(1-(1-`level'/100)/2)
		quietly generate   __lb`i'= __y`i'* 		///
				exp(-`z'*sqrt(__yy`i')/__y`i') if __y`i'<.
		quietly generate   __ub`i' = __y`i'* 		///
				exp(`z'*sqrt(__yy`i')/__y`i')  if __y`i'<.
	}
	keep in 1/101
	if "`by'"!="" {
		qui replace `id' = _n
		reshape long __y __yy __ub __lb __by, i(`id')
	}
	drop `time' `deltah' `deltaVh' 
	if "`by'"!="" {
		drop `by'
		rename __y `deltah'
		rename __yy `deltaVh'
		rename __by `by'
		rename __ub `ub'
		rename __lb `lb'
	}
	else {
		rename __y1 `deltah'
		rename __yy1 `deltaVh'
		rename __ub `ub'
		rename __lb `lb'
	}
	rename `tvar' `time'
end

program define ForbidOpt
	if `"`1'"'!="" {
		di in red `"`1' not allowed with hazard plots"'
		exit 198
	}
end

exit
