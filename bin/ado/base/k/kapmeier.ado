*! version 3.2.6  09feb2015
program define kapmeier
	ChkVer
	version 4.0
	local options /*
*/ "BY(string) L1title(string) OFfset Symbol(string) Title(string) YLAbel(string) Failure Adjustfor(string) *"
	local varlist "req ex min(2) max(2)"
	local if "opt"
	local in "opt"
	local weight "iweight aweight fweight"
	parse "`*'"
	parse "`varlist'", parse(" ")

	local time "`1'"
	local died "`2'"

	if "`weight'" != "" & "`adjustf'"=="" {
		di in red "weights allowed only with adjustfor()"
		exit 198
	}

	tempvar touse
	mark `touse' `if' `in' [`weight'`exp']
	markout `touse' `time' `died' `adjustf' `by'

	if "`failure'"=="" {
		if "`l1title'"=="" { 
			local l1title "Survival Probability" 
		}
		if "`adjustf'" != ""  {
			if "`title'"==""   { 
				local title "title(      Adjusted Kaplan-Meier Survival)" 
			}
		}
		else {
			if "`title'"=="" { local title /*
			*/ "      Kaplan-Meier Survival Curve" }
		}
	}
	else {
		if "`l1title'"=="" { 
			local l1title "Failure Probability" 
		}
		if "`adjustf'" != ""  {
			if "`title'"==""   { 
				local title "title(      Adjusted Kaplan-Meier Failure)" 
			}
		}
		else {
			if "`title'"=="" {
				local title "      Kaplan-Meier Failure Curve" 
			}
		}
	}

	if "`offset'"=="" { local myaxis "noaxis xline(0) yline(0)" }
	if "`ylabel'"=="" { local ylabel "ylab(0,.25,.5,.75,1)" }
	else if "`ylabel'"=="." {
		local ylabel
	}
	else	local ylabel "ylabel(`ylabel')"

	if "`symbol'"=="" { local symbol "STD" }


	preserve
	quietly keep if `touse'

	if "`adjustf'"!="" {
		tempvar ratio dd
		if ("`died'"=="") {
			tempvar dd
			local died `dd'
			qui gen byte `dd' = 1
		}
		if "`by'"!="" {
			qui tab(`by'), gen(__g)
			local ggg "__g*"
			local by "by(`by')"
			*list
		}
		qui cox `time' `adjustf' `ggg' [`weight'`exp'], dead(`died')
		cap drop __g*
		parse "`adjustf'", parse(" ")
		qui gen `ratio' = 1 
		while ("`1'"!="") {
			qui summ `1' [`weight'`exp']
			qui replace `ratio' = /*
			*/ `ratio'/exp(_b[`1']*(`1'-_result(3)))
			mac shift
		}
		if "`offset'"=="" { local myaxis "noaxis xline(0) yline(0)" }
		if "`symbol'"=="" { local symbol "STD" }
		wkapm `time' `died' [iw=`ratio'], `by' l1title("`l1title'") `offset' symbol(`symbol') `title' `ylabel' `failure' `options'
		exit
	}

	tempvar grp sc GRPN
	quietly {
		keep `time' `died' `by'
		_crcsrvc `time' `died' `by'
		by `by' `time': keep if _n==_N
		summarize `time'
		local MIN = min(_result(5),0)
		local NN = _N+1
		set obs `NN'  /* fake t=0 point */
		replace `time'=`MIN'-100 if _n==_N
		replace _surv=1 if _n==_N
		replace `died'=1 if _n==_N /* not censored */
		if "`by'"!="" {
			summarize `by'
			replace `by'=_result(5) if _n==_N
			drop if `by'==.
			sort `by' `time'
			replace `time' = `MIN' if _n==1
			by `by': gen `c(obs_t)' `grp' = (_n==1)
			replace `grp' = sum(`grp')
			local group 1
			local t : type `by'
			while `group'<=`grp'[_N] { 
				tempvar gsc gpp
				gen byte `sc'=(_n==1 | `group'==`grp')
				if "`failure'"=="" {
					gen `gsc'=_surv if `sc'
				}
				else {
					gen `gsc'=1-_surv if `sc'
				}
				gen `t' `GRPN'=`by' if `sc'
				replace `GRPN'=`GRPN'[_n-1] if !`sc'
				local temp=`GRPN'[_N]
				label var `gsc' "Group `temp'"
				gen str2 `gpp'=" "
				replace `gpp'="`temp'" if `died'==0 /*
					*/ & "`symbol'"=="STD"
				local vlist "`vlist' `gsc'"
				local syms "`syms'[`gpp']"
				local connect "`connect'J"
				drop `sc' `GRPN'
				local group = `group'+1
			}
			format `vlist' %9.2f
			#delimit ;
			noisily 
			gr7 `vlist' `time', c(`connect') title("`title'")
			     `ylabel' s(`syms') l1("`l1title'")
			     xsca(0,.) `myaxis' `options';
			#delimit cr
		}
		else {
			sort `time'
			replace `time' = `MIN' if _n==1
			gen str1 _pp=" "
			replace _pp="x" if `died'==0 & "`symbol'"=="STD"
			format _surv %9.2f
			if "`failure'" != "" {
				replace _surv = 1-_surv
			}
			#delimit ; 
			noisily 
			gr7 _surv `time', s([_pp]) c(J) ti("`title'")
			      xsca(0,.) `ylabel' l1("`l1title'")
			      `myaxis' `options' ;
			#delimit cr
		}
	}
end



program define wkapm
	version 4.0
	local options /*
*/ "BY(string) L1title(string) OFfset Symbol(string) Title(string) YLAbel(string) Failure *"
	local varlist "req ex min(2) max(2)"
	local weight "iweight fweight aweight"
	parse "`*'"
	parse "`varlist'", parse(" ")
	local time "`1'"
	local died "`2'"
	if "`offset'"=="" { local myaxis "noaxis xline(0) yline(0)" }
	if ("`weight'"!="") {
		tempvar wt
		gen float `wt' `exp'
		local weight "[`weight'=`wt']"
	}
	if "`symbol'"=="" { local symbol "STD" }

	tempvar grp sc GRPN
	quietly {
		local title "      `title'"
		keep `time' `died' `by' `wt'
		_crcwsrv `time' `died' "`by'" `weight'
		by `by' `time': keep if _n==_N
		summarize `time'
		local MIN = min(_result(5),0)
		local NN = _N+1
		set obs `NN'  /* fake t=0 point */
		replace `time'=`MIN'-100 if _n==_N
		replace _surv=1 if _n==_N
		replace `died'=1 if _n==_N /* not censored */
		gen byte `sc'=.
		if "`by'"!="" {
			summarize `by'
			replace `by'=_result(5) if _n==_N
			drop if `by'==.
			sort `by' `time'
			replace `time' = `MIN' if _n==1
			by `by': gen `c(obs_t)' `grp' = (_n==1)
			replace `grp' = sum(`grp')
			local group 1
			local t : type `by'
			while `group'<=`grp'[_N] { 
				tempvar gsc gpp
				replace `sc'=(_n==1 | `group'==`grp')
				if "`failure'"=="" {
					gen `gsc'=_surv if `sc'
				}
				else {
					gen `gsc'=1-_surv if `sc'
				}
				gen `t' `GRPN'=`by' if `sc'
				replace `GRPN'=`GRPN'[_n-1] if !`sc'
				local temp=`GRPN'[_N]
				label var `gsc' "Group `temp'"
				gen str2 `gpp'=" "
				replace `gpp'="`temp'" if `died'==0 /*
					*/ & "`symbol'"=="STD"
				local vlist "`vlist' `gsc'"
				local syms "`syms'[`gpp']"
				local connect "`connect'J"
				drop  `GRPN'
				local group = `group'+1
			}
			format `vlist' %9.2f
			#delimit ;
			noisily
			gr7 `vlist' `time', c(`connect') title("`title'")
			     ylab(`ylabel') s(`syms') l1("`l1title'")
			     xsca(0,.) `myaxis' `options';
			#delimit cr
			exit
		}
		else {
			sort `time'
			replace `time' = `MIN' if _n==1
			gen str1 _pp=" "
			replace _pp="x" if `died'==0 & "`symbol'"=="STD"
			format _surv %9.2f
			if "`failure'"!="" {
				replace _surv=1-_surv
			}
			#delimit ; 
			noisily 
			gr7 _surv `time', s([_pp]) c(J) ti("`title'")
			      xsca(0,.) ylab(`ylabel') l1("`l1title'")
			      `myaxis' `options' ;
			#delimit cr
		}
	}
end

program define ChkVer
	quietly version 
	if _result(1)<5 { 
		exit 
	}
	di as inp "kapmeier " as txt "is an out-of-date command.  Use " _c
	di as txt "{help sts} instead."
	exit 199
end
exit

kapmeier is an out-of-date command.  Use sts instead.
r(199);
