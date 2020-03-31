*! version 7.2.5  17mar2005
program define rocplot, rclass
	version 6
	if _caller() < 8 {
		rocplot_7 `0'
		return add
		exit
	}
	local vv : display "version " string(_caller()) ":"

	if "`e(cmd)'" != "rocfit" { 
		error 301
	}

        syntax [,				///
		CONFband 			///
		Level(cilevel)			///
		noREFline			///
		*				/// graph options
	]

	_get_gropts , graphopts(`options') ///
		getallowed(PLOTOPts LINEOPts CIOPts RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local plopts `"`s(plotopts)'"'
	local lopts `"`s(lineopts)'"'
	local ciopts `"`s(ciopts)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts ciopts , opt(`ciopts')
	_check4gropts rlopts , opt(`rlopts')
	if `"`ciopts'"' != "" {
		local confban confband
	}
	if `"`refline'"' != "" & `"`rlopts'"' != "" {
		di in red ///
		"option rlopts() is not allowed with norefline option"
		exit 198
	}

	preserve
	tempvar touse
	qui gen int `touse'=e(sample)
	qui keep if `touse'
	tempname B V Z a b va vb vab
	mat `B'=e(b)
	mat `V'=e(V)
	
	scalar `a' = `B'[1,1]
	scalar `b' = `B'[1,2]
	scalar `va'=`V'[1,1]
	scalar `vb'=`V'[2,2]
	scalar `vab'=`V'[1,2]
	scalar `Z'=`a'/sqrt(1+`b'^2)
	SEArea `a' `b' `Z' `va' `vb' `vab'
	*noi di "se = " `s(se)'
	*noi di "area = " `s(area)'
	local area= `s(area)'
	local se = `s(se)'
	local depvar=e(depvar)
	tokenize `depvar'
	local D=`"`1'"'
	local C=`"`2'"'
	/* BEGIN-create freq weighted summary data */

	if "`e(wexp)'" =="" {
		tempvar wv
	       	qui gen int `wv' = 1 if `touse'
	       	local weight="fweight"
       	}
       	else {
       		tempvar wv
       		qui gen double `wv' `e(wexp)'
       	}
	tempvar newwt
	sort `touse' `D' `C'
	qui by `touse' `D' `C': gen `newwt'=sum(`wv') if `touse'
	qui by `touse' `D' `C': replace `newwt'=. if _n~=_N
	qui replace `newwt'=. if `newwt'==0
	qui replace `touse'=0 if `newwt'==.
	qui keep if `touse'
	qui replace `wv'=`newwt'
	local wt=`"[fweight=`wv']"'
	drop `newwt'
	/* END -create freq weighted summary data */

	cap capture noisily break {
		estimates hold model1
		qui logistic `D' `C' `wt' if `touse', asis 
		tempvar prob sens spec p
		qui predict double `p', p 
		qui sum `p', meanonly
		cap assert reldif(`p', r(min))<1e-12 if `p'~=.
		if _rc==0 {
			qui _rocsen if `touse', class(`C') genprob(`prob') /*
			*/ gensens(`sens') genspec(`spec')
		}
		else {
			qui `vv' lsens if `touse',  nograph genprob(`prob') /*
			*/ gensens(`sens') genspec(`spec')
		}
		if _b[`C']<0 {
			tempvar mark
			qui gen int `mark'=1 if `sens'==1 & `spec'==1
			qui replace `mark'=1 if `sens'==0 & `spec'==0
			qui replace `sens' = 1 -`sens'  if `mark'!=1
			qui replace `spec' = 1 -`spec'  if `mark'!=1
		}

	}
	estimates unhold model1
	local rc = _rc
	if _rc!=0 {
		exit `rc'
	}

	qui replace `sens'=. if `prob'==0 | `prob'==1
	qui replace `spec'=. if `prob'==0 | `prob'==1
	qui replace `prob'=. if `sens'==. | `spec'==.
	sort `prob'
	qui replace `prob'=. if `sens'==1 & `spec'==0 & _n==1
	tempvar g
	qui egen `g'=group(`C') if `touse'
	qui sum `g' , meanonly 
	local max=r(max)
	local min=r(min)
	tempvar fpf zfpf ztpf tpf tnf ztnf yhat
	qui gen double `fpf'=1-`spec'
	qui gen double `tpf'=`sens' 
	qui gen double `tnf'=`spec'
	sort `tpf'
	qui gen double `ztpf'=invnorm(`tpf') 
	qui gen double `zfpf'=invnorm(`fpf')
	qui gen double `ztnf'=invnorm(`tnf')
	local N=_N
	local nobs=`N'+300
	qui set obs `nobs'
	tempvar k
	qui gen int `k'=1 if _n>`N'
	qui replace `fpf'=0 if `k'==1 & _n==`N'+1
	qui replace `fpf'=`fpf'[_n-1]+1/300 if `fpf'==. & `k'==1
	qui replace `zfpf'= invnorm(`fpf') if `k'==1
	qui gen double `yhat'=`b'*`zfpf' + `a'
	qui replace `yhat'=normprob(`yhat')
	qui replace `yhat'=0 if _n==_N
	qui replace `fpf'=0 if _n==_N
	qui replace `tpf'=0 if _n==_N
	qui replace `yhat'=1 if _n==_N-1
	qui replace `fpf'=1 if _n==_N-1
	qui replace `fpf'=1 if `tpf'==1 & `k'==1
	qui replace `tpf'=1 if `fpf'==1 & `k'==1
	label var `tpf'  "Sensitivity"
	local yttl : var label `tpf'
	local xttl "1 - Specificity"
	local narea : di %6.4f `area'
	local nse : di %6.4f `se'

	if `"`confband'"'~="" {
		tempvar ub lb
		qui gen double `ub'=.
		qui gen double `lb'=.
		CONF `a' `b' `zfpf' `va' `vb' `vab' `level' `ub' `lb'
		qui replace `ub'=. if `k'~=1
		qui replace `lb'=. if `k'~=1
		qui replace `ub'=1 if `tpf'==1
		qui replace `lb'=1 if `tpf'==1
		qui replace `ub'=0 if `tpf'==0
		qui replace `lb'=0 if `tpf'==0
		label var `lb' `"`=strsubdp("`level'")'% CI"'
		label var `ub' `"`=strsubdp("`level'")'% CI"'
		local cigraph				///
		(rarea `ub' `lb' `fpf',			///
			sort				///
			pstyle(ci)			///
			`ciopts'			///
		)
	}
	if `"`refline'"'=="" {
		local rlgraph			///
		(function y=x			///
			if `touse',		///
			range(`fpf')		///
			n(2)			///
			lstyle(refline)		///
			yvarlabel("Reference")	///
			`rlopts'		///
		)
	}
	else if `"`rlopts'"' != "" {
		di as err "options rlopts() and norefile may not be combined"
		exit 198
	}
	local note `"Area under curve = `narea'  se(area) = `nse'"'
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	else {
		local draw nodraw
	}
	label var `yhat' "ML ROC fit"
	version 8: graph twoway			///
	`cigraph'				///
	(scatter `tpf'  `fpf',			///
		ylabels(0(.25)1, grid)		///
        	ytitle(`"`yttl'"')		///
        	xtitle(`"`xttl'"')		///
		xlabels(0(.25)1, grid)		///
        	note(`"`note'"')		///
		`draw'				///
		`legend'			///
		`options'			///
		`plopts'			///
	)					///
	(line `yhat' `fpf', sort `lopts')	///
	`rlgraph'				///
	// blank

	return scalar se = `se' 
	return scalar area = `area' 
	return scalar N = e(N)
	if `"`plot'`addplot'"' != "" {
		restore
		version 8: graph addplot `plot' || `addplot' || , norescaling
	}
end

program def	SEArea, sclass
	args a b Z va vb vab
	tempname ga gb se 
	tempname area se
	scalar `area'=normprob(`Z')
	scalar `se'=sqrt(`area'*(1-`area')/e(N))
	scalar `ga'=normd(`Z')*(1/sqrt(1+`b'^2))
	scalar `gb'=normd(`Z')*(-`a'*`b')/((1+`b'^2)^(3/2))
	scalar `se'=(`ga'^2)*(`va')+(`gb'^2)*(`vb') + 2*`ga'*`gb'*`vab'
	scalar `se'=sqrt(`se')
	sret local se=`se'
	sret local area=`area'
end

prog def CONF, sclass
	args a b zfpf va vb vab level ub lb
	tempname kg
	tempvar sigma 
	local  delta = 1-`level'/100
	scalar `kg'= sqrt(-2*ln(`delta'))
	qui gen double `sigma' = /*
	*/ sqrt(`va'+ 2*`vab'*`zfpf' + `vb'*(`zfpf'^2))
	qui replace `ub' = `a' + `b'*`zfpf' +  `kg'*`sigma'
	qui replace `lb' = `a' + `b'*`zfpf' -  `kg'*`sigma'
	qui replace `ub'=normprob(`ub')
	qui replace `lb'=normprob(`lb')
end
