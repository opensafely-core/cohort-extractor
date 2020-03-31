*! version 7.3.10  15oct2019
program define stci, rclass byable(recall) sort
	version 7, missing
	if _caller() < 8 {
		stci_7 `0'
		return add
		exit
	}

	local vv : display "version " string(_caller()) ", missing:"

	st_is 2 analysis

	local ops BY(varlist) CCorr Emean Median /*
		*/ P(numlist >0 <100 integer max=1) /*
		*/ Rmean noSHow Level(cilevel) /*
		*/ Tmax(numlist >0 max=1) DD(integer -100) 

	syntax [if] [in] [, `ops' Graph * ]
	if "`graph'"=="" {
		syntax [if] [in] [, `ops' ]
	}
	local ops

	local wv  : char _dta[st_wv]
	if "`wv'"~="" {
		noi di as err "weights not allowed"
		exit 101
	}
	if `dd'==-100 {
		local dec="0g"
	}
	else {
		if `dd'<0 | `dd'>8 { 
			di as err "option {bf:dd()} must be between 0 and 8"
			exit 198
		}
		local dec="`dd'f"
	}
	if "`emean'`median'`p'`rmean'"=="" {
		local median="median"
	}

	if (("`emean'"!="") + ("`median'"~="") + ("`p'"~="") /*
		*/ + ("`rmean'"~="") )>1 {
		noi di as err 
		di as err /*
		*/ "only one of options " /*
		*/ "{bf:rmean}, {bf:median}, {bf:emean}, or {bf:p()} may be specified at a time"
		exit 198	
	}
	if "`ccorr'"~="" & "`rmean'"==""  {
		di as err "option {bf:ccorr} allowed only with option {bf:rmean}"
		exit 198	
	}
	if "`graph'"~="" & "`emean'"==""  {
		di as err "option {bf:graph} allowed only with option {bf:emean}"
		exit 198	
	}
	if "`graph'"~="" & "`by'"~="" {
		di as err /*
		*/ "option {bf:graph} not valid with option {bf:by()}"
		exit 198	
	}
	if "`tmax'"~="" & "`graph'"==""  {
		di as err "option {bf:tmax()} allowed only with option {bf:graph}"
		exit 198	
	}
	if "`saving'"~="" & "`graph'"==""  {
		di as err "option {bf:saving()} allowed only with option {bf:graph}"
		exit 198	
	}
	preserve
	st_show `show'
	if "`median'"~="" | "`p'"=="50" {
		local p=50
		local ttlhead "Median survival time"
		local median 1
		local mytype= " 50%"
		di
		DispHdr `level' `mytype' "`'" `by'
	}
	else if "`p'"~="" {
		local ttlhead "`p'th percentile of survival time"
		local median 2
		local mytype=" `p'%"
		di
		DispHdr `level' `mytype' "`'" `by'
	}
	else if "`rmean'"~="" {
		local ttlhead "Restricted mean survival time"
		local median 3
		local mytype1="restricted"
		local mytype="mean"
		di
		DispHdr `level' `mytype' `mytype1' `by'
	}
	else {
		local ttlhead "Exponentially extended mean survival time"
		local median 4
		local mytype1="extended"
		local mytype="mean"
		if "`graph'"=="" {
			di
			DispHdr `level' `mytype' `mytype1' `by'
		}
	}
	tempvar touse
	st_smpl `touse' `"`if'"' `"`in'"' `"`by'"' `""'
	if _by() {
		local byind "`_byindex'"
		qui replace `touse'=0 if `byind'!=_byindex()
		local byind
	}
	quietly {
		tempvar atrisk
		gen double `atrisk' = _t - _t0 if `touse'
	}
	if `median'<3 {
		if `"`by'"' != "" {
			tempvar grp subuse
			sort `touse' `by' 
			qui by `touse' `by': gen `c(obs_t)' `grp'=1 if _n==1 & `touse'
			qui replace `grp'=sum(`grp') if `touse'
			local ng = `grp'[_N]
			local i 1
			while `i' <= `ng' {
				qui gen byte `subuse'=`touse' & `grp'==`i'
				MYStats /*
				*/ `subuse' `atrisk' `"`by'"' `p' `level' `dec'
				drop `subuse'
				local i = `i' + 1
			}
			di as txt "{hline 13}{c +}{hline 61}"
		}
		MYStats `touse' `atrisk' `""' `p' `level' `dec'
		ret add
		exit
	}
	else {              /* median= 3 or 4 */
		if "`graph'"~="" {
			if  "`tmax'"=="" {
				local flag2= -1
			}
			else {
				local flag2=`tmax'
			}
		}
		else {
			local flag2 0
		}
		local flag1=0
		if `"`by'"' != "" {
			tempvar grp subuse N d
			sort `touse' `by' 
			qui by `touse' `by': gen `c(obs_t)' `grp'=1 if _n==1 & `touse'
			qui replace `grp'=sum(`grp') if `touse'
			local ng = `grp'[_N]
			local i 1
			while `i' <= `ng' {
				qui `vv' sts gen `N'=n if `touse' & `grp'==`i'
				qui `vv' sts gen `d'=d if `touse' & `grp'==`i'
				qui gen byte `subuse'=`touse' & `grp'==`i'
				qui compress `N' `d'
				MYStats1 `subuse' `atrisk'  `"`by'"' "`'" /* 
				*/ `level' `median' `N' `d'  `flag1' /* 
				*/`flag2' "`ccorr'" `"`options'"' "`dec'"
				drop `subuse' `N' `d'
				if `median'>= 3 {
					if `r(f1)'~=0 {
						local flag1=`r(f1)'
					}
				}
				local i = `i' + 1
			}
			if `median'== 4 & "`graph'"=="" {
				di as txt "{hline 13}{c +}{hline 22}"
			}
			else if `median'== 3 {
				di as txt "{hline 13}{c +}{hline 61}"
			}
		}
		tempvar N d
		qui `vv' sts gen `N'=n if `touse'
		qui `vv' sts gen `d'=d if `touse'
		qui compress `N' `d'
		MYStats1 `touse' `atrisk' `""' "`'" `level'  `median' `N' /* 
		*/ `d' `flag1' `flag2' "`ccorr'"  `"`options'"' "`dec'"
		if `median'>= 3 & `flag1'==0 {
			if `r(f1)'~=0 {
				local flag1=`r(f1)'
			}
		}
		if `flag1'==1 {
                        noi di as txt _n "(*) largest observed analysis time " /*
			*/ "is censored, mean is underestimated"

		}
		if `flag1'==2 {
                        noi di as txt _n "(*) no extension needed"
		}
		ret local f1
		ret add
	}
end

program define MYStats, rclass /* touse atrisk by p level */
	args touse atrisk by p level dec

	local id : char _dta[st_id]
	local wv  : char _dta[st_wv]

	tempname tatr m s j0 lb ub
	quietly {
		if `"`wv'"'==`""' {
			summ `atrisk' if `touse'
			scalar `tatr' = r(sum)
			summ _d if `touse'
			local fail = r(sum)
			if `"`id'"'==`""' {
				count if `touse'
				local nsubj = r(N)
			}
			else {
				sort `touse' `id'
				by `touse' `id': /*
				*/ gen byte `m'=1 if _n==1 & `touse'
				summ `m'
				local nsubj = r(sum)
			}
		}
		else {
			tempvar z
			gen double `z' = `wv'*`atrisk'
			summ `z' if `touse'
			scalar `tatr' = r(sum)
			replace `z' = `wv'*_d
			summ `z' if `touse'
			local fail = r(sum)
			drop `z'
			if `"`id'"'==`""' {
				summ `wv' if `touse'
				local nsubj = r(sum)
			}
			else {
				sort `touse' `id'
				by `touse' `id': /*
				*/ gen double `z'=`wv' if _n==1 & `touse'
				summ `z' if `touse'
				local nsubj = r(sum)
			}
		}

		Settitle `touse' `"`by'"'
		local ttl `"$S_1"'
		tempvar  greenV psl psu tb1 tb2
		tempname tb1 tb2
		`vv' sts gen `greenV'=se(s) if `touse'
		qui `vv' sts gen `lb'=lb(s) if `touse', level(`level')
		qui `vv' sts gen `ub'=ub(s) if `touse', level(`level')
		capture GetS `touse' `s'
		if _rc==0 { 
			replace `touse' = 0 if `s'>=.
			sort `touse' _t 
			gen `c(obs_t)' `j0' = _n if `touse'==0
			summ `j0'
			local j0 = cond(r(max)>=.,1,r(max)+1)
			Findptl (1-`p'/100) `s' `j0'
			local ps $S_1
			local s2 $S_2
			Findptl (1-`p'/100) `lb' `j0' 
			scalar `psl'= $S_1
			Findptl (1-`p'/100) `ub' `j0' 
			scalar `psu'= $S_1
			Findptl (1-`p'/100-0.05) `s' `j0' 
			scalar `tb1'= $S_1
			Findptl2 (1-`p'/100+0.05) `s' `j0' 
			scalar `tb2'= $S_1
			
			summ `s'  if abs(_t-`psl')<1e-8  , meanonly
			local sl=r(mean) 
			summ `s'  if abs(_t-`psu')<1e-8  , meanonly
			local su=r(mean) 
			summ `s'  if abs(_t-`tb1')<1e-8  , meanonly
			local su1=r(mean) 
			summ `s'  if abs(_t-`tb2')<1e-8  , meanonly 
			local sl1=r(mean) 

			summ `greenV'  if abs(_t-`ps')<1e-8, meanonly
			local sv=r(mean) 
			tempname f se nse
			scalar `f'= (`sl1' - `su1')/(`tb1'-`tb2')
			/* from Collett: being used */
			scalar `se'= `sv'/`f'
			/* from Klein */
			scalar `nse'= (`p'/100)*`sv'/(sqrt(`s2')*`f')
		}
		else {
			local ps .
			local se .
			local nse .
			local psl .
			local psu .
		}
	}

	Displine /*
	*/ `"`ttl'"' `nsubj' `ps' `se' `psl' `psu' "`median'" "`flag'" `dec'
	ret scalar ub = `psu'
	ret scalar lb = `psl'
	ret scalar se = `se'
	ret scalar p`p' = `ps'
	ret scalar N_sub = `nsubj'
	
end
program define MYStats1, rclass 
	args touse atrisk by p level median N d flag1 flag2 ccorr options dec

	_get_gropts , graphopts(`options') getallowed(plot addplot) gettwoway
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	local twopts  `"`s(twowayopts)'"'
	local options `"`s(graphopts)'"'

	local id : char _dta[st_id]
	local wv  : char _dta[st_wv]

	tempname tatr m s j0 lb ub

quietly {

	if `"`wv'"'==`""' {
		summ `atrisk' if `touse'
		scalar `tatr' = r(sum)
		summ _d if `touse'
		local fail = r(sum)
		if `"`id'"'==`""' {
			count if `touse'
			local nsubj = r(N)
		}
		else {
			sort `touse' `id'
			by `touse' `id': /*
			*/ gen byte `m'=1 if _n==1 & `touse'
			summ `m'
			local nsubj = r(sum)
		}
	}
	else {
		tempvar z
		gen double `z' = `wv'*`atrisk'
		summ `z' if `touse'
		scalar `tatr' = r(sum)
		replace `z' = `wv'*_d
		summ `z' if `touse'
		local fail = r(sum)
		drop `z'
		if `"`id'"'==`""' {
			summ `wv' if `touse'
			local nsubj = r(sum)
		}
		else {
			sort `touse' `id'
			by `touse' `id': /*
			*/ gen double `z'=`wv' if _n==1 & `touse'
			summ `z' if `touse'
			local nsubj = r(sum)
		}
	}

	Settitle `touse' `"`by'"'
	local ttl `"$S_1"'

	capture GetS `touse' `s'
	if _rc==0 { 
		tempvar prior gap area sarea ns
		tempname a1 a2 mt msurv lamb area2
		gsort -`s' _t
		gen double `prior'=_t0 in 1
		gen double `ns'=1 in 1
		replace `prior'=_t[_n-1] if `prior'>=. & `touse'
		replace `ns'=`s'[_n-1] if `ns'>=. & `touse'
		gen double `gap'=_t-`prior' if `touse'
		gen double `area'=`gap'*`ns' if `touse'
		gen double `sarea'=sum(`area')
		sum `sarea' if `touse'
		scalar `a1'=r(max)
		if `median'== 4 {
			sum _t if `touse'
			scalar `mt'=r(max)
			tempvar ms
			gen double `ms'=`s' if _t==`mt' & `touse'
			sum `ms' if `touse'
			scalar `msurv'=r(max)
			scalar `lamb'=-log(`msurv')/`mt'
			scalar `area2'=(1/`lamb')*exp(-`lamb'*`mt')
			if `flag2'~=0 {
				if `flag2'==-1 {
					local tmax= /*
					*/ -log(`msurv'/100)/`lamb'
				}
				else {
					local tmax=`flag2'
				}
			
				preserve
				tempname ns
				count 
				local nn=r(N)
				local xn=`nn'+21
				set obs `xn'	
				replace _t= /*
				*/ _t[_n-1]+ (`tmax'-`mt')/20 if _n>`nn'
				replace _t=`tmax' if _n==_N
				drop if _t>`tmax'
				replace `s'=. if _t>`mt'
				replace `ms'=. if _t>`mt'
				gen `ns'=exp(-`lamb'*_t) if _t>=`mt'
				label var `ns' "Exponential extension"
				local xn=_N+1
				set obs `xn'
				replace `s'=1 if _n==_N
				replace _t=0 if _n==_N
				label var _t "analysis time"
				if `"`plot'`addplot'"' == "" {
					local legend legend(nodraw)
				}
				else	local draw nodraw
				version 8: graph twoway			///
				(line `s' _t, 				///
					sort 				///
					connect(stairstep)		///
					lstyle(p1)			///
					`options'			///
				)					///
				(line `ns' _t,				///
					connect(direct)			///
					lstyle(p1)			///
					ylabel(0(.2)1)			///
					ytitle("Survival probability")	///
					title(				///
			"Exponentially extended survivor function"	///
					)				///
					`legend'			///
					`draw'				///
					`options'			///
				)					///
				, `twopts'
				restore
				if `"`plot'`addplot'"' != "" {
					version 8: graph addplot `plot'	///
						|| `addplot' || , norescaling
				}
			}
			if `lamb'>=. {
				local area2 0
			}
			scalar `a2'=`area2'
		}
		tempname ps nse psl psu
		if `median'== 4 {
			scalar `ps'=  `a1' + `a2'
		}
		else {
			scalar `ps'=`a1'
		
			tempvar narea  
			preserve
			keep if `touse'
			gsort -_t 
			qui gen double `narea'=sum(`area') 
			gsort `mtouse' _t -`narea'
			replace `narea'=`narea'[_n+1] if `touse'==1
			qui replace `narea'= /*
			*/ cond(_d==0,.,(`narea'^2)/(`N'*(`N'-`d')))
			qui sum `N', meanonly
			local tN=r(max)
			qui sum `narea', meanonly
			if "`ccorr'"=="" {
				scalar `nse'=sqrt(r(sum))
			}
			else {
				scalar /*
				*/ `nse'=sqrt( (`tN'/(`tN'-1))*r(sum))
			}

			local alpha=invnorm(.5+`level'/200)
			scalar `psu' = `ps' + `alpha'*`nse'
			scalar `psl' = `ps' - `alpha'*`nse'
		}
	}
	else {
		local ps .
		local nse .
		local psl .
		local psu .
	}

} // quietly

	local flag
	qui sum `s' if `touse'
	if r(min)>0 & `median'==3 {
		local flag=1 
		local flag1=1 
	} 
	else if r(min)<=0 & `median'==4 {
		local flag=2
		local flag1=2
	}

	if `flag2'==0 {
		Displine `"`ttl'"' `nsubj' `ps' /*
		*/ `nse' `psl' `psu' `median' "`flag'" `dec'
	}
	if `median'== 3 {
		ret scalar ub = `psu'
		ret scalar lb = `psl'
		ret scalar se = `nse'
		ret scalar rmean = `ps'
		ret hidden local f1 = `flag1'
	}
	else { 
		ret scalar emean = `ps' 
		ret hidden local f1 = `flag1'
	}
	ret scalar N_sub = `nsubj'
end


program define Findptl /* percentile s `j0' */
	args p s j0 
	if `j0'>=. {
		global S_1 . 
		exit
	}
	tempvar j
	quietly {
		gen `c(obs_t)'  `j' = _n if float(`s')<=float(`p') in `j0'/l
		summ `j' in `j0'/l
		local j=r(min)
	}
	local t : char _dta[st_t]
	global S_1 = _t[`j']
	global S_2 = `s'[`j']
end

program define Findptl2 /* percentile s `j0' */
	args p s j0 
	if `j0'>=. {
		global S_1 . 
		exit
	}
	tempvar j
	quietly {
		gen `c(obs_t)'  `j' = _n if float(`s')>=float(`p') in `j0'/l
		summ `j' in `j0'/l
		local j=r(max)
	}
	local t : char _dta[st_t]
	global S_1 = _t[`j']
	global S_2 = `s'[`j']
end

program define Settitle /* touse byvars */
	args touse byvars

	if `"`byvars'"'==`""' {
		global S_1 `"total"'
		exit
	}
	quietly {
		tempvar j
		gen `c(obs_t)' `j' = _n if `touse'
		summ `j'
		local j = r(min)
	}
	tokenize `"`byvars'"'
	while `"`1'"'!=`""' {
		local ty : type `1'
		if bsubstr(`"`ty'"',1,3)==`"str"' {
			local v = trim(udsubstr(trim(`1'[`j']),1,8))
		}
		else {
			local v = `1'[`j']
			local v : label (`1') `v' 8
		}
		local list `"`list' "`v'""'
		mac shift 
	}
	global S_1 `"`list'"'
end

program define DispHdr /* level mytype mytype1 by */
	gettoken level 0:0
	gettoken mytype  0:0
	gettoken mytype1  0:0
	local n : word count `0'
	tokenize `0'
	local i 1 
	while `i' <= `n'-2 {
		di as txt abbrev(`"`1'"',12) _col(14) `"{c |}"'
		mac shift 
		local i = `i' + 1
	}
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	if `cil' == 2 {
		local spaces "    "
	}
	else if `cil' == 4 {
		local spaces "  "
	}
	else {
		local spaces " "
	}
	if `"`2'"'==`""' {
		local ttl2 = abbrev(`"`1'"',12)
	}
	else {
		local ttl1 = abbrev(`"`1'"',12)
		local ttl2 = abbrev(`"`2'"',12)
	}
	if "`mytype1'"'=="extended" {
        	di as txt `"`ttl1'"' _col(14) /*
		*/ `"{c |}    no. of    `mytype1'"'
        	di as txt `"`ttl2'"' _col(14) /*
		*/ `"{c |}  subjects        `mytype'"'
		di as txt "{hline 13}{c +}{hline 22}"
	}
	else if "`mytype1'"'=="restricted"{
        	di as txt `"`ttl1'"' _col(14) /*
		*/ `"{c |}    no. of  `mytype1'"'
        	di as txt `"`ttl2'"' _col(14) /*
		*/ `"{c |}  subjects        mean      Std. Err."' /*
		*/ `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
		di as txt "{hline 13}{c +}{hline 61}"
	}
	else {
        	di as txt `"`ttl1'"' _col(14) /*
		*/ `"{c |}    no. of "'
        	di as txt `"`ttl2'"' _col(14) /*
		*/ `"{c |}  subjects         `mytype'     Std. Err."' /*
		*/ `" `spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
		di as txt "{hline 13}{c +}{hline 61}"
	}
end

program define Displine 
	args ttl nsubj ps nse lb ub median flag dec

	local ttl = trim(`"`ttl'"')

	if udstrlen(`"`ttl'"') > 12 + 2 {	/* +2 to account for quotes */
		local n : word count `ttl'
		local i 1
		while `i' < `n' {
			local this : word `i' of `ttl'
			di as txt %12s `"`this'"' " {c |}"
			local i = `i' + 1
		}
		local ttl : word `n' of `ttl'
	}
	else	{
		tokenize `"`ttl'"'	/* to strip the quotes */
		local ttl `*'

	}
		
	if "`median'"=="4" {
		if "`flag'"=="2" {
			di as txt %12s `"`ttl'"' " {c |} " as res /*
			*/ %9.0g `nsubj' `"   "' %9.`dec' `ps' "(*)"
		}
		else {
			di as txt %12s `"`ttl'"' " {c |} " as res /*
			*/ %9.0g `nsubj' `"   "' %9.`dec' `ps'
		}
	}
	else if "`median'"=="3" {   
		di as txt %12s `"`ttl'"' " {c |} " as res /*
		*/ %9.0g `nsubj' `"   "' %9.`dec' `ps' _c
		if "`flag'"=="1" {
			di as res "(*)"  _skip(2) %9.`dec' `nse' /* 
			*/_skip(5) %8.`dec' `lb' _skip(3) %8.`dec' `ub'
		}
		else {
			di as res   _skip(5)  %9.`dec' `nse' /* 
			*/ _skip(5) %8.`dec' `lb' _skip(3) %8.`dec' `ub'
		}
	}
	else {   
		di as txt %12s `"`ttl'"' " {c |} " as res /*
		*/ %9.0g `nsubj' `"   "' %9.`dec' `ps' _c
		if "`flag'"~="" {
			di as res "(*)"  _skip(2) %9.`dec' `nse' /* 
			*/_skip(5) %8.0g `lb' _skip(3) %8.0g `ub'
		}
		else {
			di as res   _skip(5)  %9.`dec' `nse' /* 
			*/ _skip(5) %8.0g `lb' _skip(3) %8.0g  `ub'
		}
	}
end

program define GetS /* touse s */
	args touse s 

	tempname prior
	capture {
		capture estimate hold `prior'
		stcox if `touse', estimate bases(`s')
	}
	local rc=_rc
	capture estimate unhold `prior'
	exit `rc'
end
exit
