*! version 7.1.8  09feb2015
prog def roctab_7, rclass sortpreserve
	version 7, missing
	syntax varlist(numeric min=2 max=2) [if] [in] [ fweight] [, BAMber /*
	*/ noBIASadj Detail Level(cilevel) LORenz TABle Graph /*
	*/ HANley BINOmial SUMmary SPECificity * ]
	if "`specificity'"~="" {
		local graph graph
	}
	if "`graph'"=="" {
		syntax varlist [if] [in] [fweight]  [, BAMber /*
		*/ noBIASadj Detail Level(cilevel) LORenz TABle /*
 		*/ HANley BINOmial SUMmary Graph ]
	}
	marksample touse
	tokenize `varlist'
	local D = `"`1'"'
	local C = `"`2'"'
	cap assert `D'==0 | `D'==1 if `touse'
	if _rc~=0 {
		noi di in red "true status variable `D' must be 0 or 1"
		exit 198
	}
	if "`bamber'"~="" & "`hanley'"~="" {
		di in red "bamber and hanley not allowed together"
                exit 198
	}
	if `"`lorenz'"'~="" {
		if "`graph'"~="" {
			local lgraph="graph"
			local graph="" 
		}
		if "`bamber'"~="" | "`hanley'"~="" {
			di in red /*
			*/ "option lorenz not allowed with bamber or hanley"
                	exit 198 
		}
		if "`binomial'"~="" {
			di in red "option lorenz not allowed with binomial"
			exit 198 
		}
	}

	qui summ `D' if `touse', meanonly
	if r(min) == r(max) {
		di in red "outcome does not vary"
		exit 2000 
	}
	if `"`weight'"' =="" {
		tempvar wv
		qui gen int `wv' = 1 if `touse'
		local weight="fweight"
	}
	else {
		tempvar wv
		qui gen double `wv' `exp'
	}

	tempvar newwt
	sort `touse' `D' `C'
	qui by `touse' `D' `C': gen `newwt'=sum(`wv') if `touse'
	qui by `touse' `D' `C': replace `newwt'=. if _n~=_N
	qui replace `newwt'=. if `newwt'==0
	qui replace `touse'=0 if `newwt'>=.
	qui replace `wv'=`newwt'
	local wt=`"[fweight=`wv']"'
	tempvar MN
	sort `touse' `D' `C'
	qui by `touse' `D' : gen long `MN' = sum(`wv')
	qui by `touse' `D' : replace `MN' = `MN'[_N]
	qui replace `MN'=. if `touse'==0
	if "`table'"~="" {
		noi cap tabulate `D' `C' `wt' if `touse'
		if _rc~=0 {
			tabulate `C' `D' `wt' if `touse'
		}
		else {
			tabulate `D' `C' `wt' if `touse'
		}
	}
	tempvar p
	qui logistic `D' `C' `wt' if `touse', asis
	tempname b
	mat `b'=e(b)
	local bc= colsof(`b') 	
	qui predict double `p' if e(sample), p
	if `bc'>1 {
		if _b[`C']<0 {
			qui MYLRoc, `options' `graph' `specificity' class
		}
		else {
        		qui MYLRoc , `options' `graph' `specificity'
		}
	}
	else {
       		qui MYLRoc , `options' `graph' `specificity'
	}
	tempname area
	scalar `area'= r(area)
	local N=r(N)
	qui sum `D' `wt' if `touse', meanonly
	local na=r(sum)
	local nn=`N'-`na'
	if `"`detail'"'~="" {
	        tempvar prob sens spec
	        qui sum `p', meanonly
	        cap assert reldif(`p', r(min))<1e-12 if `p'<.
	        if _rc==0 {
	                qui _rocsen if `touse', class(`C') genprob(`prob') /*
			*/ gensens(`sens') genspec(`spec')
		}
		else {
			qui lsens if `touse', nograph genprob(`prob') /*
			*/ gensens(`sens') genspec(`spec')
		}
		if _b[`C']<0 {
			tempvar mark
			qui gen int `mark'=1 if `sens'==1 & `spec'==1
			qui replace `mark'=1 if `sens'==0 & `spec'==0
			qui replace `sens' = 1 -`sens' if `mark'!=1
			qui replace `spec' = 1 -`spec' if `mark'!=1
		}
		sort `prob'
		MYDETail `prob' `sens' `spec' `D' `C' `touse' `wt'
		qui replace `sens'=. if `prob'==0 | `prob'==1
		qui replace `spec'=. if `prob'==0 | `prob'==1
		qui replace `prob'=. if `sens'>=. | `spec'>=.
		sort `prob'
		qui replace `prob'=. if `sens'==1 & `spec'==0 & _n==1
	}
	if `"`lorenz'"'~="" {
		tempvar cuma cumn
		qui gen double `cuma'=.
		qui gen double `cumn'=.
		LORenz `cuma' `cumn' `C' `D' `area' `touse' `na' `nn' `wv'
		nobreak {
			local Nmax=_N+2
			qui set obs `Nmax'
			tempvar drp
			qui gen `drp'=1 if _n>`Nmax'-2
			qui replace `cuma'=0 if _n==`Nmax'-1
			qui replace `cumn'=0 if _n==`Nmax'-1
			qui replace `cuma'=1 if _n==`Nmax'
			qui replace `cumn'=1 if _n==`Nmax'
			label var `cuma' "cumulative % of `D'=1"
			label var `cumn' "cumulative % of `D'=0"
			if `"`t1title'"'=="" {
				local t1opt="t1title(Lorenz curve)"
			}
			if "`lgraph'"~="" {
				noi gr7 `cuma' `cumn' `cumn' /*
				*/ , c(ll) s(oi) sort `t1opt' /*
				*/  xlab(0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1) /*
				*/ border /*
				*/  ylab(0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1) /*
				*/ `options'
			}
			qui drop if `drp'==1
		}
		GIni `cuma' `cumn' `C'
 		if "`lgraph'"=="" | "`summary'"~="" {
			noi di _n in gr " Lorenz curve "
			noi di in smcl in gr "{hline 27}"
			noi di in gr "  Pietra index = " in ye %8.4f `s(pietra)'
			noi di in gr "  Gini index   = " in ye %8.4f `s(gini)'
		}
		return scalar gini=`s(gini)'
		return scalar pietra=`s(pietra)'
	}
	else {
		if `"`bamber'"'~= "" | `"`biasadj'"'~="" {
			BAMberSE `C' `D' `area' `touse' `na' `nn' `wv' `biasadj'
			local SEtype="Bamber"
		}
		else if `"`hanley'"' ~="" {
			HANleySE `C' `D' `area' `touse' `na' `nn' `wv'
			local SEtype="Hanley"
		}
		else {
			tempvar v01 v10
			qui gen double `v01'=.
			qui gen double `v10'=.
			preserve
			qui keep if `touse'
			DeLongSE `D' `C' `wv' `na' `nn' `area' `v01' `v10'
			*rename `v01' v01`i'
			*rename `v10' v10`i'
			local SEtype="      "
			restore

		}
		if `"`binomial'"'~="" {
			local CItype="binom"
		}		
		tempname se
		scalar `se'= `s(se)'
		local mygr="`graph'"
		if "`table'"~="" | "`detail'"~="" | "`summary'"~="" {
			local mygr="not"
		}
		if "`mygr'"=="" {
			local mygr="not"
		}
		MYDIspl `N' `area' `se' `level' `mygr' `SEtype' `CItype'
		return scalar ub = `s(ub)'
		return scalar lb = `s(lb)'
		return scalar se = `se'
		return scalar area = `area'
		return scalar N = `N'
	}
end

prog def MYLRoc, rclass
	tempvar touse p w spec sens
	lfit_p `touse' `p' `w' `0'
	local y `"`s(depvar)'"'
	ret scalar N = `s(N)'
	local 0 `", `s(options)'"'
	sret clear
	syntax [, Graph T2title(string) Symbol(string) class /*
	*/ Bands(string) XLAbel(string) YLAbel(string) XLIne(string) /*
	*/ YLIne(string) noREFline SPECificity *]
	if `"`graph'"' ~= `""' {
		if `"`symbol'"' == `""' { local symbol `"o"' }
		if `"`bands'"' == `""' { local bands `"10"' }
		if `"`xlabel'"' == `""' { local xlabel `"0,.25,.5,.75,1"' }
		if `"`ylabel'"' == `""' { local ylabel `"0,.25,.5,.75,1"' }
		if `"`xline'"' == `""' { local xline `".25,.5,.75"' }
		if `"`yline'"' == `""' { local yline `".25,.5,.75"' }
	}
	local old_N = _N
	capture {
		lsens_x `touse' `p' `w' `y' `sens' `spec' one
		replace `p' = sum((`spec'-`spec'[_n-1])*(`sens'+`sens'[_n-1]))
		if `"`class'"'~="" {
			return scalar area = 1 - `p'[_N]/2
		}
		else {
			return scalar area = `p'[_N]/2
		}
		global S_2 `"`return(area)'"'
		if `"`t2title'"' == `""' {
			local area : di %6.4f return(area)
			local t2title `"Area under ROC curve = `area'"'
		}
		if `"`graph'"' ~= `""' {
			if `"`refline'"'=="" {
				replace `w' = /*
				*/ cond(`spec'==0, 0, cond(`spec'==1, 1, .))
			}
			else {
				replace `w'=.
			}
			if `"`class'"'~="" {
				tempvar mark
				qui gen int `mark'=1 if `sens'==1 & `spec'==1
				qui replace `mark'=1 if `sens'==0 & `spec'==0
				replace `sens' = 1 -`sens' if `mark'!=1
				replace `spec' = 1 -`spec' if `mark'!=1
			}
			if `"`specificity'"'~="" {
				replace `spec' = 1 -`spec'
				label var `spec' "Specificity"
			}
			format `sens' `w' `spec' %4.2f
			noi gr7 `sens' `w' `spec', c(ll) s(`symbol'i) /*
			*/ border t2(`"`t2title'"') bands(`bands') /*
			*/ xlabel(`xlabel') ylabel(`ylabel') xline(`xline') /*
			*/  yline(`yline') sort `options'
		}
	}
	nobreak {
		local rc = _rc
		if _N > `old_N' {
			qui drop if `touse' >=.
		}
		if `rc' { error `rc' }
	}
end

prog def LORenz, sclass
	args cuma cumn C D area touse na nn wv
	tempvar lr numb cum lr1 lr2
	quietly {
		sort `touse' `D' `C'
		by `touse' `D' `C': gen double `numb' = sum(`touse'*`wv')
		qui replace `numb' = . if `touse' == 0
		by `touse' `D' `C': replace `numb'= `numb'[_N]
		qui gen double `lr1' = `numb'/`nn' if `D'==0
		qui gen double `lr2' = `numb'/`na' if `D'==1
		sort `touse' `C' `D'
		by `touse' `C' : replace `lr1' = `lr1'[_n-1] if `lr1'>=.
		qui by `touse' `C' : replace `lr2' = `lr2'[_n+1] if `lr2'>=.
		qui gen double `lr' = `lr2'/`lr1'
		drop `lr1' `lr2'
		replace `lr'=. if `touse'~=1
		sort `touse' `C' `D'
		by `touse' `C' `D': replace `lr'=. if _n~=_N
		sort `touse' `C' `lr'
		by `touse' `C': replace `lr'=`lr'[_n-1] if `lr'>=.
		tempvar cum1 cum0
		sort `touse' `lr' `D' `C'
		tempvar order
		qui gen `c(obs_t)' `order'=_n
		compress `order'
		replace `order'=. if `lr'>=.
		cumul `order' [fw=`wv'] if `touse' & `D'==0, gen(`cum0')
		sort `order'
		cumul `order' [fw=`wv'] if `touse' & `D'==1, gen(`cum1')
		qui gen double `cum'=`cum0' if `D'==0
		qui replace `cum'=`cum1' if `D'==1
		drop `cum0' `cum1' `order'
		sort `touse' `C' `D' `cum'
		by `touse' `C' `D': replace `cum'=`cum'[_N]
		replace `cumn'=`cum' if `D'==0
		replace `cuma'=`cum' if `D'==1
		sort `touse' `C' `D'
		by `touse' `C': replace `cumn'=`cumn'[_n-1] if `cumn'>=.
		sort `touse' `C' `cumn'
		by `touse' `C': replace `cumn'=. if _n~=_N
		by `touse' `C': replace `cuma'=. if _n~=_N
	}
end

prog def GIni, sclass
	args cuma cumn C
	tempvar diff
	qui gen double `diff'=`cumn'-`cuma'
	qui sum `diff', meanonly
	sreturn local pietra=r(max)
	qui replace `cumn'=. if `cuma'>=.
	qui replace `cuma'=. if `cumn'>=.
	sort `cuma' `C'
	tempvar g
	qui gen double `g'=(`cumn'*`cuma'[_n+1])-(`cuma'*`cumn'[_n+1])
	qui replace `g'=sum(`g')
	sreturn local gini=`g'[_N]
end

prog def MYLR, sclass
	args C sens spec prob touse i max
	tempvar g
	qui egen `g'=group(`C') if `touse'
	local space =12-length("`C'")
	sort `prob' `sens'
	tempvar lrp lrn lrnp
	qui gen double `lrp'=`sens'/(100-`spec')
	qui gen double `lrn'=(100-`sens')/`spec'
	qui gen double `lrnp'=(`sens'[_n-1]-`sens')/(`spec'-`spec'[_n-1])
	sret local lrn=`lrn'[`i']
	sret local lrp=`lrp'[`i']
	sret local lrnp=`lrnp'[`i']
end

prog def MYDETail
	args prob sens spec D C touse wt
	qui replace `prob'=. in 1
	tempvar g
	qui egen `g'=group(`C') if `touse'
	noi di 
	noi di in gr "Detailed report of Sensitivity and Specificity"
	noi di in smcl in gr "{hline 78}"
	noi di in gr  _col(43) " Correctly"
	noi di in gr "Cut point     " "Sensitivity   Specificity" /*
	*/ "   Classified          LR+          LR-"
	noi di in smcl in gr "{hline 78}"
	qui sum `g', meanonly
	local max=r(max)
	local min=r(min)
	qui replace `sens'=`sens'*100
	qui replace `spec'=`spec'*100
	qui sum `D' `wt' if `D'==1 & `touse'
	local N1=r(N)
	qui sum `D' `wt' if `D'==0 & `touse'
	local N0=r(N)
	local i 1
	while `i'<= `max' + 1 {
		tempvar A name1 name2
		qui gen `A'=1 if `touse'
		qui replace `A'=2 if `g'>`i'-1 & `touse'
		qui tab `D' `A' if `touse'
		qui gen `name1'= `C' if `g'==`i'-1 & `touse'
		qui gen `name2'= `C' if `g'==`i' & `touse'
		qui sum `A' `wt' if `touse' & `A'==1, meanonly
		local n1=r(N)
		qui sum `A' `wt' if `touse' & `A'==2, meanonly
		local n2=r(N)
		qui replace `name1'=`name1'[_n-1] if `name1'>=.
		qui replace `name2'=`name2'[_n-1] if `name2'>=.
		qui replace `name1'=`name1'[_N] if `name1'>=.
		qui replace `name2'=`name2'[_N] if `name2'>=.
		if `i' == `min' {
			* local sim1 "  "
			local cut : di %8.0g `name2'[`i']
			local cut `cut'
			local cut =`"( >= `cut' )"'
		}
		else if `i'== `max'+1 {
			* local sim2 "  "
			local cut : di %8.0g `name1'[`i']
			local cut `cut'
			local cut =`"( >  `cut' )"'
		}
		else {
			local cut2 : di %8.0g `name2'[`i']
			local cut2 `cut2'
			local cut ="( >= `cut2' )"
		}

		MYLR `C' `sens' `spec' `prob' `touse' `i' `max'
		local lrn=`s(lrn)'
		local lrp=`s(lrp)'
		local lrnp=`s(lrnp)'
		if `lrp'>=. {
			local lrp="         "
		}
		if `lrn'>=. {
			local lrn="         "
		}

		local corr (`sens'[`i']*`N1' + `spec'[`i']*`N0') /(`N1'+`N0')

			/* sort the data so that the sensitivity is in 
			   descending order */
		tempvar temp
		qui gen double `temp'=1-`sens'
		sort `prob' `temp'

		di in ye "`cut'" _col(17) /*
		*/ %8.2f `sens'[`i'] `"%"' _col(31) %8.2f `spec'[`i'] `"%"' /*
		*/  _col(44) %8.2f `corr' `"%"' _col(58) %8.4f `lrp' /*
		*/ _col(71) %8.4f `lrn' 
		local i= `i'+1

		qui drop `A' `name1' `name2' `temp'
	}
	noi di in smcl in gr "{hline 78}"
	noi di 
	qui replace `sens'=`sens'/100
	qui replace `spec'=`spec'/100
end

prog def MYDIspl, sclass
	args N area nse level graph SEtype CItype
	if `"`CItype'"'=="" & `"`SEtype'"'=="binom"{
		local CItype="binom"
		local SEtype=""
	}
	tempname ub lb
	if `"`CItype'"'== "binom" {
		qui cii `N' `area', level(`level')
		scalar `ub'=r(ub)
		scalar `lb'=r(lb)
		local citype = "{hline 2} Binomial Exact {hline 2}"
	}
	else {
		local alpha=invnorm(.5+`level'/200)
		scalar `ub' = `area' + `alpha'*`nse'
		scalar `lb' = `area' - `alpha'*`nse'
		if `ub'>1 {
			scalar `ub' = 1
		}
		if `lb'<0 {
			scalar `lb' = 0
		}
		local citype = "{hline 1}Asymptotic Normal{hline 2}"
	}
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	if `cil' == 2 {
		local spaces "      "
	}
	else if `cil' == 4 {
		local spaces "    "
	}
	else {
		local spaces "   "
	}
	if "`graph'"=="not" {
		di in smcl in gr _n  _col(23) "ROC" _col(32) "`SEtype'" /*
		*/ _col(46)  "`citype'"
		di in smcl in gr "           Obs       Area     Std. Err." /*
*/ `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"' _n "         " /*
		*/ "{hline 56}"
		di in gr _col(7) in yel %8.0f `N' _col(18) %8.4f `area' /*
		*/_col(31) /*
		*/ %8.4f `nse' _col(46) %8.5f `lb' _col(58) %8.5f `ub'
	}
	sreturn local lb=`lb'
	sreturn local ub=`ub'
end

prog def HANleySE, sclass
	args C D W touse na nn wv
	tempvar row1 row2 row3 row4 row5 row6 row7 temp
	tempname Q1 Q2 SE_W
	quietly {
	sort `touse' `C'
	by `touse' `C': gen `row1' = sum(`touse'*(1-`D')*`wv')
	by `touse' `C': replace `row1' = . if _n != _N | `touse' == 0
	by `touse' `C': gen `row3' = sum(`touse'*`D'*`wv')
	by `touse' `C': replace `row3' = . if _n != _N | `touse' == 0
	markout `touse' `row1' `row3'
	sort `touse' `C'
	gen `temp' = sum(`row1') if `touse'
	gen `row4' = `temp'[_n-1] if `touse'
	replace `row4' = 0 if `touse' & `row4' >=.
	replace `temp' = sum(`row3') if `touse'
	gen `row2' = `na' - `temp' if `touse'
	gen `row5' = `row1'*(`row2' + 0.5*`row3') if `touse'
	summ `row5' if `touse', meanonly
	gen `row6' = `row3'*(`row4'*(`row4'+`row1')+(1/3)*`row1'^2) if `touse'
	summ `row6' if `touse', meanonly
	scalar `Q2' = r(sum)/(`na'*`nn'^2)
	gen `row7' = `row1'*(`row2'*(`row2'+`row3')+(1/3)*`row3'^2) if `touse'
	summ `row7' if `touse', meanonly
	scalar `Q1' = r(sum)/(`nn'*`na'^2)
	scalar `SE_W' = sqrt(( `W'*(1-`W') + (`na'-1)*(`Q1'-`W'^2) /*
	*/ + (`nn'-1)*(`Q2'-`W'^2))/(`na'*`nn'))
	}
	sret local se=`SE_W'
end

prog def BAMberSE, sclass
	args C D W touse na nn wv biasadj
	tempvar x y ux uy vx vy
	preserve
	qui keep if `touse'
	qui gen double `ux'=.
	qui gen double `vx'=.
	qui gen double `uy'=.
	qui gen double `vy'=.
	local i=1
	while `i'<=_N {
		tempvar uxt vxt uyt vyt
		tempname val
		scalar `val'=`C'[`i']
		qui gen double /*
		*/ `uxt'=`wv' if `C'<`val' & `D'[`i']==1 & `D'==0 & `touse'
		qui gen double/*
		*/  `vxt'=`wv' if `C'>`val' & `D'[`i']==1 & `D'==0 & `touse'
		qui gen double/*
		*/  `uyt'=`wv' if `C'<`val' & `D'[`i']==0 & `D'==1 & `touse'
		qui gen double /*
		*/ `vyt'=`wv' if `C'>`val' & `D'[`i']==0 & `D'==1 & `touse'
		qui replace `uxt'=sum(`uxt')
		qui replace `vxt'=sum(`vxt')
		qui replace `uyt'=sum(`uyt')
		qui replace `vyt'=sum(`vyt')
		qui replace `ux'=`uxt'[_N] if _n==`i'
		qui replace `vx'=`vxt'[_N] if _n==`i'
		qui replace `uy'=`uyt'[_N] if _n==`i'
		qui replace `vy'=`vyt'[_N] if _n==`i'
		local i=`i'+1
		qui drop `uxt' `vxt' `uyt' `vyt'
	}
	sort `D'
	tempvar sumwt bxny byyx1 bxxy1
	tempname pxny byyx bxxy var bse
	qui gen double `bxny'=`ux'+`vx'
	qui replace `bxny'=sum(`bxny'*`wv')
	scalar `pxny'=(`bxny'[_N])/(`na'*`nn')
	drop `bxny'
	qui gen double `bxxy1' /*
	*/  = (`uy'*(`uy'-1)+`vy'*(`vy'-1)-2*`uy'*`vy') if `uy'<.
	qui replace `bxxy1'=sum(`bxxy1'*`wv')
	scalar `bxxy'=(`bxxy1'[_N])/(`na'*(`na'-1)*`nn')
	drop `bxxy1'
	qui gen double `byyx1'/*
	*/ = `ux'*(`ux'-1)+`vx'*(`vx'-1)-2*`ux'*`vx' if `ux'<.
	qui replace `byyx1'=sum(`byyx1'*`wv')
	scalar `byyx'=(`byyx1'[_N])/(`nn'*(`nn'-1)*`na')
	drop `byyx1'
	if "`biasadj'"~="" {     /* bias not adjusted */
		scalar `var'=1/(4*`na'*`nn')*(`pxny'+(`na'-1)* `bxxy' /*
		*/ +(`nn'-1) * `byyx' -4*(`na'+`nn'-1)*((`W'-.5)^2))
	}
	else {  /* bias adjusted - default */
		scalar `var'=(1/(4*(`na'-1)*(`nn'-1)))*(`pxny'+(`na'-1)* /*
		*/ `bxxy' +(`nn'-1) * `byyx' -4*(`na'+`nn'-1)*((`W'-.5)^2))
	}
	sret local se = sqrt(`var')
end

prog def DeLongSE, sclass
        args D C wv na nn area v01 v10
        tempvar Phi
        qui gen double `Phi'=.
        sort `D' `C'
        local i=1
        while `i'<=_N {
                tempvar phi
                local x=`C'[`i']
                if `D'[`i']==1  {
                        qui gen float `phi'=`wv' if `C'<`x' & `D'==0
                        qui replace   `phi'= 0.5*`wv'  if `C'==`x' & `D'==0
                        qui replace   `phi'= 0  if `C'>`x' & `D'==0
                        qui sum `phi', meanonly
                        qui replace `Phi'=r(sum) if _n==`i'
                }
                else {
                        qui gen float `phi'=`wv' if `C'>`x' & `D'==1
                        qui replace   `phi'= 0.5*`wv'  if `C'==`x' & `D'==1
                        qui replace   `phi'= 0  if `C'<`x' & `D'==1
                        qui sum `phi', meanonly
                        qui replace `Phi'=r(sum) if _n==`i'
                }
                qui drop `phi'
        local i=`i'+1
        }
        qui replace `v10'=`Phi'/(`nn') if `D'==1
        qui replace `v01'=`Phi'/(`na') if `D'==0

        qui drop `Phi'
        qui replace `v01'=(`v01'-`area')
        qui replace `v10'=(`v10'-`area')
	tempname S10 S01 S
	tempvar pd01 pd10 sd01 sd10
	qui gen double `pd01'=`v01'*`v01'
	qui gen double `pd10'=`v10'*`v10'
	qui egen double `sd01'=sum(`pd01'*`wv')
	qui egen double `sd10'=sum(`pd10'*`wv')
	qui replace `sd10'=`sd10'/(`na'-1)
	qui replace `sd01'=`sd01'/(`nn'-1)
	local S10=`sd10'
	local S01=`sd01'
	scalar `S'=(1/`na')*`S10' + (1/`nn')*`S01'
	sret local se = sqrt(`S')
end

