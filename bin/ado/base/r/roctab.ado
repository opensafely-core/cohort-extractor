*! version 7.5.4  25sep2017
prog def roctab, rclass sortpreserve
	version 7, missing
	if _caller() < 8 {
		roctab_7 `0'
		return add
		exit
	}
        
	local vv : display "version " string(_caller()) ", missing:"

	syntax varlist(numeric min=2 max=2)	///
		[if] [in] [ fweight]		///
		[,				///
		BAMber				///
		noBIASadj			///
		Detail				///
		Level(cilevel)			///
		LORenz				///
		TABle				///
		HANley				///
		BINOmial			///
		SUMmary				///
		Graph				/// graph opts
		SPECificity			///
		noLABel				///
		*				///
		]

	if `"`specificity'"' != "" {
		local graph graph
	}

	if "`graph'"=="" {
		qui syntax varlist(numeric min=2 max=2)	///
			[if] [in] [ fweight]		///
			[,				///
			BAMber				///
			noBIASadj			///
			Detail				///
			Level(cilevel)			///
			LORenz				///
			TABle				///
			HANley				///
			BINOmial			///
			SUMmary				///
			Graph				///
			noLABel				///
			useado				///  undocumented
			]
	}

	marksample touse
	tokenize `varlist'
	local D = `"`1'"'
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

	tempvar newwt C
	if "`detail'`table'" == "" {
		qui egen int `C' = group(`2') if `touse'
	}
	else {
		qui egen int `C' = group(`2') if `touse', label
		label var `C' `2'
	}
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
			tabulate `C' `D' `wt' if `touse', `label'
		}
		else {
			tabulate `D' `C' `wt' if `touse', `label'
		}
	}
	tempvar p
	tempname esthold
	cap estimates hold `esthold'
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
	        tempvar prob sens spec pcnt
		// use _rocsen if some probabilities are equal
		sort `p'
		qui by `p': egen byte `pcnt' = count(`p')
		cap assert `pcnt' == 1
	        if _rc {
	                qui _rocsen if `touse', class(`C') genprob(`prob') /*
			*/ gensens(`sens') genspec(`spec')
		}
		else {
			qui `vv' lsens if `touse', nograph genprob(`prob') /*
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
		MYDETail `prob' `sens' `spec' `D' `C' `touse' `wt' `label'
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
			_get_gropts , graphopts(`options')	///
				getallowed(PLOTOPts RLOPts plot addplot)
			local options `"`s(graphopts)'"'
			local rlopts `"`s(rlopts)'"'
			local plotopts `"`s(plotopts)'"'
			local plot `"`s(plot)'"'
			local addplot `"`s(addplot)'"'
			_check4gropts rlopts, opt(`rlopts')
			_check4gropts plotopts, opt(`plotopts')
			if `"`plot'`addplot'"' == "" {
				local legend legend(nodraw)
			}

			local yttl : var label `cuma'
			local xttl : var label `cumn'
			noi				///
			version 8: graph twoway		///
			(connected `cuma' `cumn',	///
				sort			///
				title("Lorenz curve")	///
				ylabel(0(.1)1)		///
				ytitle(`"`yttl'"')	///
				xtitle(`"`xttl'"')	///
				xlabel(0(.1)1)		///
				`legend'		///
				`options'		///
				`plotopts'		///
			)				///
			(function y=x			///
				if `touse',		///
				range(`cumn')		///
				n(2)			///
				lstyle(refline)		///
				yvarlabel("Reference")	///
				`rlopts'		///
			)				///
			|| `plot' || `addplot'		///
			// blank
		}
		qui drop if `drp'==1
} // nobreak
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
			preserve
			qui keep if `touse'
			if "`useado'" == "useado" {
				BAMberSE `C' `D' `area' `na' `nn' `wv' `biasadj'
			}
			else {
				mata: _bamberse_wrk("`C'","`D'","`wv'","`area'")
			}			
			local SEtype="Bamber"
			restore
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
			if "`useado'" == "useado" {
				DeLongSE `D' `C' `wv' `na' `nn' `area' `v01' `v10'
			}
			else {
				mata: _delongse_wrk("`C'","`D'","`wv'","`area'")
			}
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
		return scalar level = `level'
		return scalar ub = `s(ub)'
		return scalar lb = `s(lb)'
		return scalar se = `se'
		return scalar area = `area'
		return scalar N = `N'
		if `"`detail'"'~="" {
			return mat detail Details
			return local cutpoints = `"$cutpoints"'
		}
	}
	cap estimates unhold `esthold'
  	if _rc!=0 {
		estimates clear
	}
end

prog def MYLRoc, rclass
	tempvar touse p w spec sens
	lfit_p `touse' `p' `w' `0'
	local y `"`s(depvar)'"'
	ret scalar N = `s(N)'
	local 0 `", `s(options)'"'
	sret clear
	syntax [, Graph class noREFline SPECificity *]

	_get_gropts , graphopts(`options') ///
		getallowed(PLOTOPts RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local plotopts `"`s(plotopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')
	_check4gropts plotopts, opt(`plotopts')
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
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
	if `"`graph'"' ~= `""' {
		local note : display	///
			`"Area under ROC curve = "' %6.4f return(area)
		if `"`class'"'~="" {
			tempvar mark
			qui gen int `mark'=1 if `sens'==1 & `spec'==1
			qui replace `mark'=1 if `sens'==0 & `spec'==0
			replace `sens' = 1 -`sens' if `mark'!=1
			replace `spec' = 1 -`spec' if `mark'!=1
		}
		
		// for sorting
		local sortsens `sens'
		if `"`specificity'"' != "" {
			// for sorting
			tempvar nsens
			qui gen double `nsens' = -`sens'
			local sortsens `nsens'
			replace `spec' = 1 -`spec'
			label var `spec' "Specificity"
			local yofx "y=1-x"
		}
		else	local yofx "y=x"
		if `"`refline'"'=="" {
			local rlgraph			///
			(function `yofx',		///
				range(`spec')		///
				n(2)			///
				lstyle(refline)		///
				yvarlabel("Reference")	///
				`rlopts'		/// graph opts
			)				///
			// blank
		}
		else {
			replace `w'=.
			local w
		}
		format `sens' `w' `spec' %4.2f
		local yttl : var label `sens'
		local xttl : var label `spec'
		noi					///
		version 8: graph twoway			///
		(connected `sens' `spec',		///
			sort(`spec' `sortsens')		///
			ylabel(0(.25)1, grid)		///
			xlabel(0(.25)1, grid)		///
			ytitle(`"`yttl'"')		///
			xtitle(`"`xttl'"')		///
			note(`"`note'"')		///
			`legend'			///
			`options'			///
			`plotopts'			///
		)					///
		`rlgraph'				///
		|| `plot' || `addplot'			///
		// blank
	}

} // capture

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
	tempvar temp
	qui gen double `temp'= 1-`sens'
	sort `prob' `temp' `spec'
	tempvar lrp lrn lrnp
	qui gen double `lrp'=`sens'/(100-`spec')
	qui gen double `lrn'=(100-`sens')/`spec'
	qui gen double `lrnp'=(`sens'[_n-1]-`sens')/(`spec'-`spec'[_n-1])
	sret local lrn=`lrn'[`i']
	sret local lrp=`lrp'[`i']
	sret local lrnp=`lrnp'[`i']
end

prog def MYDETail
	args prob sens spec D C touse wt label
	qui replace `prob'=. in 1
	if _b[`C']<0 {
		qui replace `prob' = 1 - `prob'
	}
	noi di 
	noi di in gr "Detailed report of sensitivity and specificity"
	noi di in smcl in gr "{hline 78}"
	noi di in gr  _col(43) " Correctly"
	noi di in gr "Cutpoint      " "Sensitivity   Specificity" /*
	*/ "   Classified          LR+          LR-"
	noi di in smcl in gr "{hline 78}"
	qui label list `C'
	local max = r(k)
	qui replace `sens'=`sens'*100
	qui replace `spec'=`spec'*100
	qui sum `D' `wt' if `D'==1 & `touse'
	local N1=r(N)
	qui sum `D' `wt' if `D'==0 & `touse'
	local N0=r(N)
	local i 1
	matrix Details = J(`max'+1,6,.) 
	matrix colnames Details = cutpoint sensitivity specificity correct lr+ lr-
	global cutpoints = ""
	while `i'<= `max' + 1 {
		tempvar A
		qui gen `A'=1 if `touse'
		qui replace `A'=2 if `C'>`i'-1 & `touse'
		qui tab `D' `A' if `touse'
		qui sum `A' `wt' if `touse' & `A'==1, meanonly
		local n1=r(N)
		qui sum `A' `wt' if `touse' & `A'==2, meanonly
		local n2=r(N)
		if `i' <= `max' {
			* local sim1 "  "
			if "`label'" != "nolabel" {
				local cut1 : label `C' `i'
				local cut2 : label `C' `i'
				if udstrlen("`cut1'") > 7 {
					local cut1 = udsubstr("`cut1'",1,5) + ".."
				}
			}
			else {
				local cut1 `i'
				local cut2 `i'
			}
			local cut    = `"( >= `cut1' )"'
			local cut_ra = `"( >= `cut2' )"' /* used for r(cutpoints) */
		}
		else {
			* local sim2 "  "
			local cut    =`"( >  `cut1' )"'
			local cut_ra =`"( >  `cut2' )"'
		}

		global cutpoints `"$cutpoints `i':`cut_ra'"'

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
			   descending order and the specificity is in ascending 
			   order */
		tempvar temp
		qui gen double `temp'=1-`sens'
		sort `prob' `temp' `spec'
		di in ye "`cut'" _col(17) /*
		*/ %8.2f `sens'[`i'] `"%"' _col(31) %8.2f `spec'[`i'] `"%"' /*
		*/  _col(44) %8.2f `corr' `"%"' _col(58) %8.4f `lrp' /*
		*/ _col(71) %8.4f `lrn' 

		mat Details[`i',1] = `i'
		mat Details[`i',2] = `sens'[`i']
		mat Details[`i',3] = `spec'[`i']
		mat Details[`i',4] = `corr'
		mat Details[`i',5] = real("`lrp'")
		mat Details[`i',6] = real("`lrn'")

		local i= `i'+1

		qui drop `A' `temp'
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
		if (`area'==1) {
			qui cii `N' `N', level(`level')
		}
		else {
			qui cii `N' `area', level(`level')
		}
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
*/ `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"' _n "     " /*
		*/ "{hline 60}"
		di in gr _col(5) in yel %10.0fc `N' _col(18) %8.4f `area' /*
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
	args C D area na nn wv biasadj
	tempvar x y ux uy vx vy
	qui gen double `ux'=.
	qui gen double `vx'=.
	qui gen double `uy'=.
	qui gen double `vy'=.
	local i=1
	while `i'<=_N {
		tempvar uxt vxt uyt vyt
		tempname val
		scalar `val'=`C'[`i']
		qui gen double `uxt'=`wv' if `C'<`val' & `D'[`i']==1 & `D'==0
		qui gen double `vxt'=`wv' if `C'>`val' & `D'[`i']==1 & `D'==0
		qui gen double `uyt'=`wv' if `C'<`val' & `D'[`i']==0 & `D'==1
		qui gen double `vyt'=`wv' if `C'>`val' & `D'[`i']==0 & `D'==1
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
		*/ +(`nn'-1) * `byyx' -4*(`na'+`nn'-1)*((`area'-.5)^2))
	}
	else {  /* bias adjusted - default */
		scalar `var'=(1/(4*(`na'-1)*(`nn'-1)))*(`pxny'+(`na'-1)* /*
		*/ `bxxy' +(`nn'-1) * `byyx' -4*(`na'+`nn'-1)*((`area'-.5)^2))
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

version 14.0
mata:

void _delongse_wrk(string scalar Cs, Ds, wvs, areas) {

	real scalar i, N, x, s, sd01, sd10, na, nn, area
	real vector Phi, D, C, wv, f, D0, D1, wv0, wv05, wv1, wv15, phi
	real vector clex, ceqx, cgrx, clex0, ceqx0, ceqx1, cgrx1
	real vector Phi0, Phi1, v10, v01, pd01, pd10
	real matrix data
	
	na = strtoreal(st_local("na"))
	nn = strtoreal(st_local("nn"))
	area = st_numscalar(areas)
	
	data = st_data(.,(Ds,Cs,wvs))
	data = uniqrows(data,1)	// extra column will contain frequencies
	
	D = data[.,1]
	C = data[.,2]
	wv = data[.,3]		// fweights
	f = data[.,4]
	wv = wv:*f 		// multiply fweights by frequencies
	
	i = 1
	N = rows(data)
	
	Phi = J(N,1,.)
	
	D0 = (D:==0)
	D1 = (D:==1)
	wv0 = select(wv,D0)
	wv05 = 0.5:*wv0
	wv1 = select(wv,D1)
	wv15 = 0.5:*wv1

	while (i <= N) {
		x = C[i]
		
		clex = (C:<x)
		ceqx = (C:==x)
		cgrx = (C:>x)
		
		clex0 = select(clex,D0)
		ceqx0 = select(ceqx,D0)
		ceqx1 = select(ceqx,D1)
		cgrx1 = select(cgrx,D1)

		if (D[i]==1) {
			phi = wv0:*clex0 :+ wv05:*ceqx0
			phi = sum(phi)
			Phi[i] = phi
		}
		else {
			phi = wv1:*cgrx1 :+ wv15:*ceqx1
			phi = sum(phi)
			Phi[i] = phi
		}
		i++
	}
	
	Phi0 = select(Phi,D0)
	Phi1 = select(Phi,D1)

	v10 = (Phi1 :/ nn) :- area
	v01 = (Phi0 :/ na) :- area
	
	pd01 = v01:^2
	pd10 = v10:^2

	sd01 = sum(pd01:*wv0) / (nn-1)
	sd10 = sum(pd10:*wv1) / (na-1)

	s = (1/na)*sd10 + (1/nn)*sd01
	s = sqrt(s)

	st_global("s(se)",strofreal(s,"%21.18f"))
}

void _bamberse_wrk(string scalar Cs, Ds, wvs, areas) {

	real scalar i, N, x, s, na, nn, area, bias, pxny, bxxy, byyx
	real vector D, C, wv, f, D0, D1, wv0, wv1
	real vector clex, cgrx, clex0, cgrx0, clex1, cgrx1, vy, uy, vx, ux
	real matrix data
	
	na = strtoreal(st_local("na"))
	nn = strtoreal(st_local("nn"))
	bias = (st_local("biasadj") != "")
	area = st_numscalar(areas)
	
	data = st_data(.,(Ds,Cs,wvs))
	data = uniqrows(data,1)	// extra column will contain frequencies
	
	D = data[.,1]
	C = data[.,2]
	wv = data[.,3]		// fweights
	f = data[.,4]
	wv = wv:*f 		// multiply fweights by frequencies
	
	i = 1
	N = rows(data)
	
	ux = vx = uy = vy = J(N,1,0)
	
	D0 = (D:==0)
	D1 = (D:==1)
	wv0 = select(wv,D0)
	wv1 = select(wv,D1)

	while (i <= N) {	
		x = C[i]
		
		clex = (C:<x)
		cgrx = (C:>x)
		
		clex0 = select(clex,D0)
		cgrx0 = select(cgrx,D0)
		clex1 = select(clex,D1)
		cgrx1 = select(cgrx,D1)

		if (D[i]==1) {
			ux[i] = sum( select(wv0,clex0) )
			vx[i] = sum( select(wv0,cgrx0) )
		}
		else {
			uy[i] = sum( select(wv1,clex1) )
			vy[i] = sum( select(wv1,cgrx1) )
		}
		i++
	}
	
	pxny = sum(wv:*(ux:+vx)) / (na*nn)
	
	bxxy = uy:*(uy:-1) + vy:*(vy:-1) - 2:*uy:*vy
	bxxy = sum(bxxy:*wv) / (na*(na-1)*nn)
	
	byyx = ux:*(ux:-1) + vx:*(vx:-1) - 2:*ux:*vx
	byyx = sum(byyx:*wv) / (nn*(nn-1)*na)
	
	s = pxny + (na-1)*bxxy + (nn-1)*byyx - 4*(na+nn-1)*(area-.5)^2
	if (bias) s = s / (4*na*nn)
	else	  s = s / (4*(na-1)*(nn-1))
	
	s = sqrt(s)
	
	st_global("s(se)",strofreal(s,"%21.18f"))
}

end
exit

