*! version 1.7.3  23apr2019
program define pkexamine, byable(onecall) sortpreserve
	version 7, missing
	if _by() {
		local by `"by `_byvars'`_byrc0' :"'
	}
	if _caller() < 8 {
		`by' pkexamine_7 `0'
		exit
	}
	`by' PKexamine `0'
end

program define PKexamine, rclass byable(recall)
	syntax varlist(numeric min=2 max=2)	///
		[if] [in]			///
		[,				///
		Trapezoid			///
		fit(integer 3)			///
		line log exp(real -1)		///
		noZero 				///
	        Graph				///
		*				/// graph opts
		]

	_get_gropts , graphopts(`options') getallowed(plot addplot)
	local options `"`s(graphopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'

	if "`graph'" == "" {
		syntax varlist(numeric min=2 max=2)	///
			[if] [in]			///
			[,				///
			Trapezoid			///
			fit(integer 3)			///
			line log exp(real -1)		///
			noZero 				///
			]
	}

	marksample touse
	qui count if `touse'
	if r(N) == 0 {
		error 2000
	}
	tokenize `varlist'
	local time "`1'"
	local conc "`2'"

	tempvar lnc toest
	tempname auc_ln auc0_tm slope cmax auc_ex auc_lg /* 
		*/ lpt b0 b1 lastconc lc_cons

	if `fit' < 2 | `fit' > _N { 
		di as err /*
		*/ "fit() must be at least 2 and less than or equal to _N=" _N
		exit 198
	}

	qui count if `touse' 
	if `fit'>r(N) { 
		if "`if'"~="" {
			local myif=`"`if'"'
			gettoken myif2 myif: myif  
			local ifmsg="with`myif'"
		}

		di as err "fit() is greater than the number of obs. `ifmsg'"
		error cond(r(N)==0,2000,2001) 
	}

	if "`exp'" != "-1" { 
		qui su `time', meanonly
		capture assert `exp' >= r(max) | `exp' == 0
		if _rc { 
			di as err /*
*/ "exp must be 0 or greater than or equal to tmax= " r(max)
			exit 198
		}
	}
	else local exp = ""	

	if ("`log'"!="") + ("`exp'"!="") + ("`line'"!="") > 1 { 
		di as err /*
		*/ "only one of options log, exp, and line may be specified"
		exit 198
	}

	sort `touse' `time'
	capture by `touse' `time': assert _N==1 if `touse'
	if _rc { 
		di as err "time variable takes on repeated values"
		exit 459
	}
	capture assert `time'>=0 if `touse'
	if _rc { 
		di as err "time variable takes on negative values"
		exit 459
	}

	if "`zero'" == "" {	
		qui sort `touse' `time'
		capture assert `time' != 0 if `touse'
		if _rc == 0 {
			di
			di as txt _col(5) /*
*/ "Warning: the point (0, 0) is not in your data.  It will be added."
			preserve
			local obs = _N + 1
			qui set obs `obs'
			qui replace `time' = 0 in l
			qui replace `conc' = 0 in l
			qui replace `touse' = 1 in l
		
		}
		// do not add (0,0) point
		/*capture assert `time' == `conc' if `time' == 0 & `touse'
		if _rc {
			di as err _col(5) /*
*/ "Warning: the point (0, 0) is not in your data. It will be added."
			cap preserve
			local obs = _N + 1
			qui set obs `obs'
			qui replace `time' = 0 in l
			qui replace `conc' = 0 in l
			qui replace `touse' = 1 in l
		}*/
		sort `touse' `time'
	}

				/* parsing ends */

	qui {
		scalar `lastconc' = `conc'[_N] 
		return scalar tmax = `time'[_N]
		gen byte `toest' = 0 
		replace `toest' = 1 in -`fit'/l


		gen double `lnc' = ln(`conc') if `touse'
		
		integ `conc' `time' if `touse', `trapezoid' 
		scalar `auc0_tm' = r(integral)

		regress `lnc' `time' if `toest'
		scalar `slope' = _b[`time']
		scalar `lc_cons' = _b[_cons]
		capture assert `slope' < 0
		if _rc {
			scalar `slope' = .
		}
		
		sum `conc' if `touse', meanonly
		scalar `cmax' = r(max)
		sum `time' if `touse' & `conc'==`cmax', meanonly
		return scalar tomc = r(max)

		MYLine `time' `conc' `toest' `touse'
		scalar `auc_ln' = `auc0_tm' + r(area)
		scalar `lpt' = r(l_point)

		MYExp `time' `conc' `toest' `touse'
		scalar `auc_ex' = `auc0_tm' + r(area)
		scalar `b0' = r(b0)
		scalar `b1' = r(b1)

		scalar `auc_lg' = `auc0_tm' + (`lastconc' / (-`slope'))
	}



	return scalar cmax = `cmax'
	/* return scalar tmax */ 
	return scalar ke = -`slope'
	return scalar half = ln(2) / -`slope'
	return scalar auc = `auc0_tm'
	return scalar auc_ln = `auc_lg'
	return scalar auc_exp = `auc_ex'
	return scalar auc_line = `auc_ln'



#delimit ;

	di ;
	di as txt _col(5) "                                      Maximum concentration = " 
		as res %9.0g return(cmax) ;
	di as txt _col(5) "                              Time of maximum concentration = " 
		as res %9.0g return(tomc) ;

	di as txt _col(5) "                            Time of last observation (Tmax) = "
		as res %9.0g return(tmax) ;
	di as txt _col(5) "                                           Elimination rate = " 
		as res %9.4f return(ke) ;
	di as txt _col(5) "                                                  Half life = " 
		as res %9.4f return(half) ; 

	di _n as txt _col(5)
	"Area under the curve" ;
	di as txt _col(5) /*
	*/ "{hline 16}{c TT}{hline 21}{c TT}{hline 15}{c TT}{hline 16}" ;
	di as txt _col(21) 
	"{c |}    AUC [0, inf.)    {c |} AUC [0, inf.) {c |}  AUC [0, inf.)" ;

	di as txt _col(5) 
	" AUC [0, Tmax]  {c |} Linear of log conc. {c |}   Linear fit  {c |} Exponential fit" ;

	di as txt _col(5) /*
	*/ "{hline 16}{c +}{hline 21}{c +}{hline 15}{c +}{hline 16}" ;

	di _col(6) as res %9.2f return(auc) 
			as txt "      {c |}      " as res %9.3f return(auc_ln)
			as txt "      {c |}  " as res %9.3f return(auc_line)
			as txt "    {c |}   " as res %9.3f return(auc_exp) ;
	di as txt _col(5) /*
	*/ "{hline 16}{c BT}{hline 21}{c BT}{hline 15}{c BT}{hline 16}" ;
	di as txt	_col(5) "Fit based on last " as res `fit' " {gr}points." ;

#delimit cr

	if "`graph'"=="" { 
		exit
	}

	local xttl : var label `time'
	if `"`xttl'"' == "" {
		local xttl "Analysis Time"
	}

	local yttl : variable label `conc'
	if `"`yttl'"' == "" {
		local yttl "Concentration"
	}

	if "`log'" != "" {
		local lnlab "Log Concentration"
		local yttl Log `yttl'
	}
	label var `lnc' "`lnlab'"

	if "`log'" == "" & "`line'" == "" & "`exp'" == "" {
		local yvars `conc'
	}
	else if "`log'" != "" {
		if `auc_lg'>=. {
			noi di as err /*
		*/ "unable to compute area under extension, graph not produced"
			exit 459
		}
		capture preserve
		local obs = _N+1
		qui set obs `obs'
		qui replace `lnc' = 0 if _n == _N
		qui replace `time' = -`lc_cons' / `slope' if _n == _N
		local yvars `lnc'
	}
	else if "`line'" != "" {
		if `auc_ln'>=. {
			noi di as err /*
		*/ "unable to compute area under extension, graph not produced"
			exit 459
		}
		qui {
			capture preserve
			local obs = _N+1
			set obs `obs'
			replace `conc' = 0 if _n == _N
			replace `time' = `lpt' if _n == _N
			replace `touse' = 1 if _n == _N
			local yvars `conc'
		}
	}
	else if "`exp'" != "" {
		if `auc_ex'>=. {
			noi di as err /*
		*/ "unable to compute area under extension, graph not produced"
			exit 459
		}
		qui {
			if "`exp'" == "0" {
				local exp = `lpt'
			}

			capture preserve
			local org = _N
			local obs = _N+10
			set obs `obs'
			local inc = (`exp' - return(tmax)) / 10

			replace `time' = `time'[_n-1] + `inc' if _n > `org'

			tempvar conc1
			gen double `conc1' = /*
			*/ exp((`b0' + `b1' * `time')) if _n > `org'
			replace `conc1' = `conc' if _n == `org'
			replace `touse' = 1 if _n > `org'
			local yvars `conc' `conc1'
			label var `conc1' `"`yttl'"'
		}
	}
	if `"`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	version 8: graph twoway			///
	(connected `yvars' `time'		///
		if `touse'==1,			///
		msymbol(. none)			///
		ytitle(`"`yttl'"')		///
		xtitle(`"`xttl'"')		///
		pstyle(p1 p1)			///
		`legend'			///
		`options'			///
	)					///
	|| `plot' || `addplot'			///
	// blank
end


program define MYLine, rclass
	args time conc toest touse
	tempvar time1 conc1

	regress `conc' `time' if `toest'
	capture assert _b[`time'] < 0
	if _rc {
		return scalar area = .
		exit
	}
	return scalar l_point = -_b[_cons]/_b[`time']
	sort `touse' `time'
	gen double `time1' = `time'[_N] in 1
	replace `time1' = return(l_point) in 2
	gen double `conc1' = `conc'[_N] in 1
	replace `conc1' = 0 in 2
	return scalar area = .5 * `conc1'[1] * (`time1'[2] - `time1'[1])
end


program define MYExp, rclass
	args time conc toest touse

	ereg `conc' `time' if `toest' & `conc'!=0
	capture assert _b[`time'] < 0
	if _rc {
		return scalar area = .
		exit
	}
	ret scalar b0 = _b[_cons]
	ret scalar b1 = _b[`time']
	tempvar time1
	sort `touse' `time' /* in case ereg changed sort order */
	gen double `time1' = `time'[_N] in 1
	ret scalar area = /*
	*/ (-1 / _b[`time']) * exp((_b[_cons] + _b[`time']*`time1'[1]))
end
