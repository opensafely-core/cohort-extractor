*! version 2.8.6  16feb2015
program define ltable_9, sortpreserve
	version 6, missing
	if _caller() < 8 {
		ltable_7 `0'
		exit
	}

	local baopts 					/*
		*/ noAdjust BY(varname) noCONF 		/*
		*/ Failure Hazard Intervals(string) 	/*
		*/ Level(cilevel)	 		/*
		*/ SUrvival noTAble Test TVid(varname)
	if _caller() >= 8.2 {
		local baopts `baopts' SAVing(string asis)
	}
	local gropts Graph OVerlay *

	syntax varlist(min=1 max=2) [fw] [if] [in] [, `baopts' `gropts' ]
	if "`graph'`overlay'" == "" {
		cap noi syntax varlist(min=1 max=2) [fw] [if] [in] [, `baopts']
		if _rc { 
			di in red /*
	*/ "(option is invalid or you need to specify graph option, too)"
			exit _rc
		}
	}
	else {
		if "`overlay'" != "" {
			local graph graph
			if "`by'" == "" {
				di as err ///
"option overlay may not be specified without the by() option"
				exit 198
			}
		}
		if "`hazard'"!="" {	
			di as err "graph not allowed with hazard"
			di as err "use sts graph to graph hazard estimates"
			exit 198
		}
		_get_gropts , graphopts(`options')	///
			gettwoway			///
			getallowed(CIOPts plot addplot)
		local myopts `"`s(graphopts)'"'
		local twopts `"`s(twowayopts)'"'
		local ciopts `"`s(ciopts)'"'
		local plot `"`s(plot)'"'
		local addplot `"`s(addplot)'"'
		_check4gropts ciopts, opt(`ciopts')
		if `"`overlay'"' == "" & `"`by'"' != "" & `"`plot'"' != "" {
			di as err ///
			"options by() and plot() may not be combined"
			exit 198
		}
		if `"`overlay'"' == "" & `"`by'"' != "" & `"`addplot'"' != "" {
			di as err ///
			"options by() and addplot() may not be combined"
			exit 198
		}		
	}

	CheckSaving `saving'

	local baopts
	local gropts

	tempvar touse
	mark `touse' `if' `in' [`weight'`exp']
	markout `touse' `by', strok
	tokenize `varlist'

	qui count if `touse'
	if r(N)==0 {
		error 2000
	} 

	if `"`hazard'"'=="" & `"`failure'"'=="" { 
		local surviva "survival"
	}

	if `"`graph'"'!="" { 
		local type `hazard' `surviva' `failure'
		if 0`:word count `type''>1 {
			di in red "options `type' cannot be combined"
			exit 198
		}
	}

	tempvar Group I0 I1 dI Total tt td dead lost start atrisk fail 
	tempvar F seF loF upF S loS upS H seH loH upH
	tempvar sv1 st ss
	tempvar Imid sellS

	local t `1'
	if `"`2'"'=="" { 
		tempvar d 
		quietly gen byte `d'=1
	}
	else local d `2'

	if `"`exp'"'!="" { 
		tempvar wgt
		gen long `wgt' `exp'
		local wvar `wgt'
	}
	else 	local wgt 1

	preserve

quietly {

	keep if `touse'
	drop if `wgt'<=0
	drop if `t'>=.
	capture assert `t'>=0 
	if _rc { 
		noi di in red "time variable has negative values"
		exit 411
	}
	if `"`tvid'"'!="" { 
		sort `tvid' `t' `d'
		by `tvid': keep if _n==_N
	}
	count if `d'>=.
	if r(N) { 
		noisily di in blu /*
			*/ `"(warning:  `d' has missing values; "' /* 
			*/ r(N) " obs not used)" 
		drop if `d'>=.
	}

	local g `by'
	if `"`g'"'=="" {
		gen `Group' = 1
		local g `"`Group'"'
        }
	else {
		capture drop if `g'>=.
		local byopt by(`g')
	}

	if _N==0 {
		error 2000
	}
	keep `t' `d' `g' `wvar'


	/*
		Process intervals or set default intervals
	*/

	if `"`interva'"'=="" {
		local interva 1
	} 
	noisily _crcltab `t' `I0' `I1' `"`interva'"'

	sort `g' `I0' `t'

/*-------------------- CALCULATE STATISTICS -------------------------*/
	by `g': 	gen `Total'= sum(`wgt')
	by `g':		replace `Total'=`Total'[_N]
	by `g': 	gen `tt'   = sum(`wgt'*`t')
	by `g': 	gen `td'   = sum(`wgt'*(`d'!=0))
	by `g' `I0':	gen `dead' = sum(`wgt'*(`d'!=0))
	by `g' `I0':	gen `lost' = sum(`wgt')
	by `g' `I0':	keep if _n==_N

	local gtot=_N

	gen `start'  = `Total'
	drop `Total'
	by `g': replace `start'  = `start'[_n-1]-`lost'[_n-1] if _n>1
	if `"`adjust'"'=="" {
		gen double `atrisk' = `start'-(`lost'-`dead')/2
	}
	else	gen double `atrisk' = `start'
	gen double `fail' = `dead'/`atrisk'

				/* Hazard calculation		*/
	gen `dI'  = `I1'-`I0'
	if `"`adjust'"'=="" {
		gen `H'   = 2*`fail'/((2-`fail')*`dI')
		gen `seH' = `H'*sqrt((1-(`dI'*`H'/2)^2) /*
		*/	     / (`atrisk'*`fail'))
	}
	else {
		gen `H' = `fail'/`dI'
		gen `seH' = `H'/sqrt(`dead')
	}

				/* Fail calculation		*/
	gen double `S'=.
	by `g': replace `S'=cond(_n==1,1,`S'[_n-1])*(1-`fail')
	gen `F' = 1-`S'
	by `g': gen `sv1' = sum(`fail'/(`atrisk'-`dead'))
	by `g': gen `seF' = `S'*sqrt(`sv1') if `S'!=0

	by `g': gen `sellS'= /*
		*/ sqrt(sum(`dead'/(`atrisk'*(`atrisk'-`dead'))) / /*
		*/ (sum(ln((`atrisk'-`dead')/`atrisk'))^2))

	local iz=invnorm(1-(1-`level'/100)/2)
	gen `upS' = `S'^exp(-`iz'*`sellS') if `S'!=0
	gen `loS' = `S'^exp(`iz'*`sellS') if `S'!=0
	*gen `upS' = max(min(`S'+`iz'*`seF',1),0)
	*gen `loS' = max(min(`S'-`iz'*`seF',1),0)

	gen `upF' = 1-`loS'
	gen `loF' = 1-`upS'
	* gen `upF' = max(min(`F'+`iz'*`seF',1),0)
	* gen `loF' = max(min(`F'-`iz'*`seF',1),0)
	if `"`adjust'"'=="" {
		gen `upH' = `H'+`iz'*`seH'
		gen `loH' = `H'-`iz'*`seH'
	}
	else {
		gen `upH' = (`H'/`dead')*invgammap(`dead',(1+`level'/100)/2)
		gen `loH' = (`H'/`dead')*invgammap(`dead',(1-`level'/100)/2)
	}
	replace `upH'=0 if `upH'<0
	replace `loH'=0 if `loH'<0


/*------------------------- GRAPH -----------------------------------*/
	if `"`graph'"'!="" {

		local tlbl : var label `t'
		if `"`tlbl'"'=="" {
			local tlbl `"`t'"'
		}
		label var `I1' `"`tlbl'"'

		if `"`failure'"'!="" { 
			local yttl "Proportion Failed"
			label var `F' "`yttl'"
			local y `F'
			local x `I1'
			if `"`conf'"'=="" {
				label var `upF' "`level'% CI"
				label var `loF' "`level'% CI"
				local cigraph			///
				(rspike `upF' `loF' `x',	///
					sort			///
					pstyle(ci)		///
					`ciopts'		///
				)				///
				// blank
			}
		}
		else if `"`surviva'"'!="" {
			local yttl "Proportion Surviving"
			label var `S' "`yttl'"
			local y `S'
			local x `I1'
			if `"`conf'"'=="" {
				label var `upS' "`level'% CI"
				label var `loS' "`level'% CI"
				local cigraph			///
				(rspike `upS' `loS' `x',	///
					sort			///
					pstyle(ci)		///
					`ciopts'		///
				)				///
				// blank
			}
		}
		else {                      // dead code
			local yttl "Hazard"
			label var `H' "`yttl'"
			gen `Imid'=(`I0'+`I1')/2
			label var `Imid' `"`tlbl'"'
			local y `H'
			local x `Imid'
			if `"`conf'"'=="" {
				label var `upH' "`level'% CI"
				label var `loH' "`level'% CI"
				local cigraph			///
				(rspike `upH' `loH' `x',	///
					sort			///
					pstyle(ci)		///
					`ciopts'		///
				)				///
				// blank
			}
		}

		if `"`plot'`addplot'"' == "" {
			local legend legend(nodraw)
		}
		else {
			local 0 , `twopts'
			syntax [, noDRAW * ]
			local twopts `"`options'"'
			local draw nodraw
		}

		if "`overlay'" == "" {
			version 8: graph twoway			///
			`cigraph'				///
			(connected `y' `x',			///
				sort				///
				ytitle(`"`yttl'"')		///
				pstyle(p1)			///
				`legend'			///
				`draw'				///
				`myopts'			///
			)					///
			,					///
			`twopts'				///
			`byopt'					///
			// blank
		}
		else {
			tempvar byid bysize
			sort `by'
			by `by' : gen `byid' = _n==1
			by `by' : gen `c(obs_t)' `bysize' = _N
			quietly replace `byid' = sum(`byid')
			local nby = `byid'[_N]
			local j = 1
			forval i = 1/`nby' {
				if bsubstr("`:type `by''",1,3) == "str" {
					local yvl : display `by'[`j']
				}
				else {
					local yvl : label (`by') `=`by'[`j']'
					capture confirm number `yvl'
					if !c(rc) {
						local yvl `"`by' = `yvl'"'
					}
				}
				local lines `lines'		///
				(connected `y' `x'		///
					if `byid'==`i',		///
					sort			///
					yvarlabel(`"`yvl'"')	///
					ytitle(`"`yttl'"')	///
					`myopts'		///
				)
				local j = `j' + `bysize'[`j']
			}
			version 8: graph twoway			///
			`lines'					///
			|| ,					///
			`draw'					///
			`twopts'				///
			// blank
		}
	}


/*---------------------- TABLE PRESENTATION ----------------*/
	if `"`surviva'"'!="" & `"`table'"'=="" {
		local cil `=length("`level'")'
		local spaces "   "
		if `cil' == 4 {
			local spaces " "
		}
		if `cil' == 5 {
			local spaces ""
		}
		local cistr `"`spaces'[`=strsubdp("`level'")'"'
		#delimit ;
		noisily di _n in smcl in gr 
			_col(18) "Beg."
						_col(55) "Std."
			_n
			_col( 4) "Interval" 	_col(17) "Total"
			_col(25) "Deaths" 	_col(34) "Lost"
			_col(42) "Survival" 	_col(54) "Error"
			_col(61) `"`cistr'% Conf. Int.]"'
			_n
			"{hline 79}" ;
		#delimit cr
		local i 1
		while `i'<=_N { 
			if `"`g'"'~=`"`Group'"' & `g'[`i']!=`g'[`i'-1] {
				* noisily di in gr `"`g' "' `g'[`i']
				noisily Ghdr "`g'" `i'
			}
			#delimit ;
			noisily di in gr
				%5.0f `I0'[`i']
				%6.0f `I1'[`i']
			in ye
				%10.0f `start'[`i']
			 	%9.0f  `dead'[`i']
			 	%7.0f  `lost'[`i']-`dead'[`i']
				%11.4f    `S'[`i']
				%10.4f  `seF'[`i']
				%11.4f  `loS'[`i']
				%10.4f  `upS'[`i']
			;
			#delimit cr
			local i=`i'+1
		}
		noi di in smcl in gr "{hline 79}"
	}

	if `"`failure'"'!="" & `"`table'"'=="" {
		#delimit ;
		noisily di _n in smcl in gr 
			_col(18) "Beg."
			_col(44) "Cum." 	_col(55) "Std."
			_n
			_col( 4) "Interval" 	_col(17) "Total"
			_col(25) "Deaths" 	_col(34) "Lost"
			_col(42) "Failure" 	_col(54) "Error"
			_col(64) `"[`level'% Conf. Int.]"'
			_n
			"{hline 79}" ;
		#delimit cr
		local i 1
		while `i'<=_N { 
			if `"`g'"'~=`"`Group'"' & `g'[`i']!=`g'[`i'-1] {
				noisily di in gr `"`g' "' `g'[`i']
			}
			#delimit ;
			noisily di in gr
				%5.0f `I0'[`i']
				%6.0f `I1'[`i']
			in ye
				%10.0f `start'[`i']
			 	%9.0f  `dead'[`i']
			 	%7.0f  `lost'[`i']-`dead'[`i']
				%11.4f    `F'[`i']
				%10.4f  `seF'[`i']
				%11.4f  `loF'[`i']
				%10.4f  `upF'[`i']
			;
			#delimit cr
			local i=`i'+1
		}
		noi di in smcl in gr "{hline 79}"
	}

	if `"`hazard'"'!="" & `"`table'"'=="" {
		#delimit ;
		noisily di _n in smcl in gr 
			_col(18) "Beg."
			_col(27) "Cum."		_col(36) "Std."
			_col(56) "Std."		
			_n
			_col( 4) "Interval" 	_col(17) "Total"
			_col(25) "Failure"	_col(35) "Error"
			_col(44) "Hazard"	_col(55) "Error"
			_col(64) `"[`level'% Conf. Int.]"'
			_n
			"{hline 79}" ;
		#delimit cr
		local i 1
		while `i'<=_N {
			if `"`g'"'~=`"`Group'"' & `g'[`i']!=`g'[`i'-1] {
				noisily di in gr `"`g' "' `g'[`i']
			}
			#delimit ;
			noisily di in gr
				%5.0f     `I0'[`i']
				%6.0f     `I1'[`i']
				%10.0f  `start'[`i']
				%10.4f     `F'[`i']
			 	%8.4f    `seF'[`i']
			in ye
				%10.4f   `H'[`i'] 
				%10.4f `seH'[`i']
				%10.4f `loH'[`i']
				%10.4f `upH'[`i']
			;
			#delimit cr
			local i=`i'+1
		}
		noi di in smcl in gr "{hline 79}"
	}

	if `"`saving'"' != "" {
		SaveData "`by'" `I0' `I1' `start' `dead' `lost'	///
			`S' `sellS' `loS' `upS' `F' `seF'	///
			`loF' `upF' `H' `seH' `loH' `upH'	///
			`level' `"`saving'"'
	}

	
/*--------------FIRST SET OF CHI SQUARE STATISTICS ------------------*/
	if `"`g'"'~=`"`Group'"' & `"`test'"'!="" {
  		by `g': keep if _n==_N
  		gen `st'=sum(`td')*log(sum(`tt')/sum(`td'))
		gen `ss'= sum(`td'*log(`tt'/`td'))
		local chi2=2*(`st'[_N]-`ss'[_N])
		#delimit ;
  			noisily di _n(2) in gr  
		"Likelihood-ratio test statistic of homogeneity "
			`"(group=`g'):"' _n
  				"chi2( " 
			in ye _N-1	/* df */ 
			in gr " ) = " 
			in ye `chi2' 
			in gr ",   P = " 
			in ye chiprob(_N-1,`chi2') ;
		#delimit cr

/*------------- SECOND SET OF CHI SQUARE STATISTICS -----------------*/
		restore
		if `"`exp'"'!="" { 
		        local wtopt= "[`weight'`exp']"
		}
		noisily di " "
  			noisily di in gr /*
		*/ `"Logrank test of homogeneity (group=`g'):"'
  			noisily logrank `t' `d' `wtopt' if `touse', by(`g')
		
	}
	else	restore

	if `"`plot'`addplot'"' != "" {
		version 8: graph addplot `plot' || `addplot' || , norescaling
	}

} // quietly

end

program CheckSaving
	version 8.2
	capture syntax [anything(id="filename" equalok)] [, replace ]
	if c(rc) {
		di as err "invalid saving() option"
		syntax [anything(id="filename" equalok)] [, replace ]
		exit 198
	}
	if "`replace'" != "" & `"`anything'"' == "" {
		di as err "invalid saving() option, filename is required"
		exit 198
	}
end

program SaveData
	version 8.2
	preserve
	args	by I0 I1 start dead lost	///
		S sellS loS upS F seF		///
		loF upF H seH loH upH level
	macro shift 19
	local saving `"`*'"'

	local keep t0 t1 start deaths lost		///
		survival sesurvival lsurvival usurvival	///
		failure sefailure lfailure ufailure	///
		hazard sehazard lhazard uhazard		///
		// blank
	foreach var of local keep {
		capture {
			unab x : `var'
			if "`x'" == "`var'" {
				drop `var'
			}
		}
	}

	// `by' already has a valid name, if it exists
	rename `I0'	t0
	label var	t0 "start of time interval"
	rename `I1'	t1
	label var	t1 "end of time interval"
	rename `start'	start
	label var	start "beginning total"
	rename `dead'	deaths
	label var	deaths "deaths during interval"
	quietly gen	lost = `lost'-deaths
	label var	lost "lost during interval"

	// survival statistics
	rename `S'	survival
	label var	survival "survival estimates"
	rename `sellS'	sesurvival
	label var	sesurvival	///
			"standard error of survival log likelihood estimates"
	rename `loS'	lsurvival
	label var	lsurvival "lower `level'% CI limit for survival"
	rename `upS'	usurvival
	label var	usurvival "upper `level'% CI limit for survival"

	// cumulative failure statistics
	rename `F'	failure
	label var	failure "cumulative failure estimates"
	rename `seF'	sefailure
	label var	sefailure	///
			"standard error of cumulative failure estimates"
	rename `loF'	lfailure
	label var	lfailure	///
			"lower `level'% CI limit for cumulative failure"
	rename `upF'	ufailure
	label var	ufailure	///
			"upper `level'% CI limit for cumulative failure"
	// hazard statistics
	rename `H'	hazard
	label var	hazard "hazard estimates"
	rename `seH'	sehazard
	label var	sehazard "standard error of hazard estimates"
	rename `loH'	lhazard
	label var	lhazard "lower `level'% CI limit for hazard"
	rename `upH'	uhazard
	label var	uhazard	"upper `level'% CI limit for hazard"
	keep `by' `keep'
	order `by' `keep'
	save `saving'
end

program define _crcltab
	version 3.0
	local t "`1'"
	local I0 "`2'"
	local I1 "`3'"
	local interva "`4'"
	if "`interva'"=="w" { 
		_crcltab `t' `I0' `I1' "0 7 15 30 60 90 180 360 540 720"
		exit
	}
	version 8: numlist "`interva'"
	tokenize `r(numlist)'
	quietly gen float `I0'=0 
	quietly gen float `I1'=.
	if "`2'"=="" { 
		confirm number `1'
		if `1'<=0 | `1'>=. { 
			di in red "interval() invalid"
			exit 198
		}
		quietly replace `I0' = int(`t'/`1')*`1'
		quietly replace `I1' = `I0'+`1'
		exit
	}
	local last -1
	while "`1'"!="" { 
		if "`1'"!="," { 
			confirm number `1'
			if `1'<=`last' { 
				di in red "intervals must be ascending"
				exit 198
			}
			if `last'!= -1 {
				quietly replace `I0'=`last' /*
						*/ if `t'>=`last' & `t'<`1'
				quietly replace `I1'=`1' /*
						*/ if `t'>=`last' & `t'<`1'
			}
			local last `1'
		}
		mac shift
	}
	if `last'==0 { 
		di in red "intervals invalid"
		exit 198
	}
	quietly replace `I0'=`last' if `t'>=`last'
	quietly replace `I1'=. if `t'>=`last'
end

program define Ghdr /* varname idx */
	args varname i
	local typ : type `varname'
	if bsubstr("`typ'",1,3)=="str" { 
		di in ye `varname'[`i']
		exit
	}
	local val = `varname'[`i']
	local new : label (`varname') `val'
	if "`val'" != `"`new'"' { 
		di in ye `"`new'"'
		exit
	}
	local fmt : format `varname'
	local res : di `fmt' `val'
	local res = trim(`"`res'"')
	di in ye `"`varname' = `res'"'
end
