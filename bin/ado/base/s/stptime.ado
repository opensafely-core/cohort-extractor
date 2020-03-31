*! version 7.1.13  21feb2015
program define stptime, rclass sortpreserve byable(recall) 
	version 7, missing

	local vv : display "version " string(_caller()) ":"

	st_is 2 analysis
	syntax [if], [ by(varname) AT(numlist >=0 sort) OUTput(string asis) /*
	*/ DD(integer -100) Level(cilevel) Title(string) PER(real 1) /*
	*/ TRIM noSHow SMR(string) Using(string) Jackknife]

	if `"`_dta[st_id]'"' == "" {
		di as err /*
		*/ "stptime requires that you have previously stset an id() variable"
		exit 198
	}

	_nostrl error : `by'
       
	if `dd' <= 0 & `dd' ~= -100 {
		di as err "dd() should be a positive integer"
		exit 198
	}
 
	if `per' <= 0 {
		di as err "per() should be greater than zero"
		exit 198
	}
	local options `"per(`per')"'
	if `"`smr'"' ~= "" {
		local options `"`options' smr(`"`smr'"')"'
	}
	if `"`using'"' ~= "" {
		local options `"`options' using(`"`using'"')"'
	}
	if "`at'"~="" {
		if "`trim'" == "" {
			tokenize `at'
			if `1'>0 {
				local at= `"0 `at'"'
			}
			local at= `"`at' 1.0x+3fe"'
		}
		local atopt "at(`at')"	
	}
	if `"`output'"'~="" {
			if "`by'"~="" {
				noi di as err /*
				*/ "output() option not valid in" /*
				*/ " combination with by() option"
				exit 198
			}
			local outopt=`"output(`output')"'
	}

	if "`dd'"~="-100" {
		local ddopt="dd(`dd')"
	}
	if "`title'"=="" {
		local titpos="_col(15)"
		local title= "person-time"
	}
	else {
		local title= udsubstr(`"`title'"',1, 13)
		local titlng=26 - udstrlen(`"`title'"')
		local titpos="_col(`titlng')"
	}
	tempvar touse
        st_smpl `touse' `"`if'"' `"`in'"' `"`by'"' `""'
        if _by() {
                qui replace `touse'=0 if `_byindex'!=_byindex()
        }
	if `"`if'"'~="" {
		local if=`"``if'' & `touse'"'
	}
	else {
		local if= "if `touse'"
	}

	if "`by'"=="" {              /* CASE 1: no by() with or without at() */

		Mstptime `if', `outopt' title(`"`title'"') titpos(`titpos') /*
		*/ `atopt' `options' `ddopt' level(`level') `trim' `show' /*
		*/ `jackknife'
		if `"`r(method)'"'=="jackknife" {
			jckknife_note1
			if r(flag)==1 {
				jckknife_note2
			}
		}
		ret add
		exit	
	}
	else if "`at'"=="" {            /* CASE 2: by() without at() */
		st_show `show'
		if `dd'==-100 {
			local dec="0g"
		}
		else {
			local dec="`dd'f"
		}
		tempvar group
		egen `group'=group(`by')
		sum `group', meanonly
		local max=r(max)
		if `"`if'"'~="" {
			local sif=`"`if' &"' 
		}
		else {
			local sif="if"
		}
		local cil `=string(`level')'
		local cil `=udstrlen("`cil'")'
		if `cil' < 5 {
			local space ""
			local cilabel "Conf. Interval"
		}
		else {
			local space " "
			local cilabel "Conf.Interval"
		}
 		di as txt _n %10s abbrev("`by'",9) /*
		*/ _col(12) "{c |}" `titpos' `"`title'"' /* 
		*/ _col(29) "failures"  _col(45) "rate"  /* 
*/ _col(`=54-`cil'') `"`space'[`=strsubdp("`level'")'% `cilabel']"' /*
		*/ _n "{hline 11}{c +}{hline 59}"
		tempvar one
		qui gen int `one'=.
		local i 1
		local flag 0
		while `i'<=`max' {
			qui replace `one'=cond(`group'==`i',1,.)
			sort `one'
			cap confirm str var `by'
			if _rc~=0 {
				local varl:value label `by'
				if "`varl'"~="" {
					local posb=`by'[1]
					local disp: label `varl' `posb'
				}
				else {
					local disp=string(`by'[1])
				}
			}
			else {
				local disp=`by'[1]
			}
			local mif=`"`sif' `group'==`i'"'
			cap qui Mstptime `mif', /*
			*/  title(`"`title'"') titpos(`titpos') /*
			*/  `options' `ddopt' level(`level') `trim' `show' /*
			*/  `jackknife'

			if `"`r(method)'"'=="jackknife" {
				local flag = `flag' + r(flag)
			}
			if r(ptime)~=. {
	 			di as txt %10s abbrev("`disp'",9) /*
				*/ _col(12) "{c |}" _col(16) /*
				*/ as res %10.`dec' r(ptime) /*
				*/ _col(29) %8.0g r(failures) /*
				*/ _col(39) %10.`dec' /*
				*/ r(rate) _col(51) %9.`dec' r(lb) /*
				*/ _col(63) %9.`dec' r(ub) 
			}
			local i=`i'+1
		}
		
		qui Mstptime `if', title(`"`title'"') titpos(`titpos') /*
		*/  `options' `ddopt' level(`level') `trim' `show' `jackknife'
		if `"`r(method)'"'=="jackknife" {
			local flag = `flag' + r(flag)
			local method "jackknife"
		}
		di as txt "{hline 11}{c +}{hline 59}"
		di as txt "     total" _col(12) "{c |}" _col(16) /*
                                */ as res %10.`dec' r(ptime) /*
                                */ _col(29) %8.0g r(failures) /*
                                */ _col(39) %10.`dec' /*
                                */ r(rate) _col(51) %9.`dec' r(lb) /*
                                */ _col(63) %9.`dec' r(ub)
		ret add

		if "`method'"=="jackknife" {
			jckknife_note1
			if `flag' > 0 {
				ret hidden scalar flag = 1
				jckknife_note2
			}
			else ret hidden scalar flag = 0
			ret hidden local method "jackknife"
		}
		exit	
	}
	else if "`at'"~="" {		/* CASE 3: by() with at() */
		st_show `show'
                if `dd'==-100 {
                        local dec="0g"
                }
                else {
                        local dec="`dd'f"
                }
                tempvar group
                egen `group'=group(`by')
                sum `group', meanonly
                local max=r(max)
                if `"`if'"'~="" {
                        local sif=`"`if' &"'
                }
                else {
                        local sif="if"
                }
		local cil `=string(`level')'
		local cil `=udstrlen("`cil'")'
		if `cil' < 5 {
			local space ""
			local cilabel "Conf. Interval"
		}
		else {
			local space " "
			local cilabel "Conf.Interval"
		}
		if index(`"`options'"',"smr")==0 {
                	di as txt _n  abbrev("`by'",9) /*
			*/ _col(12) "{c |}" `titpos' `"`title'"' /* 
                	*/ _col(29) "failures"  _col(45) "rate"  /*
*/ _col(`=54-`cil'') `"`space'[`=strsubdp("`level'")'% `cilabel']"' /*
                	*/ _n "{hline 11}{c +}{hline 59}"
		}
		else {
			di as txt _n _col(12) /*
			*/ "{c |}" _col(29) "observed" _col(39)  "expected"
        		di as txt abbrev("`by'",9) _col(12) /*
			*/ "{c |}" `titpos' `"`title'"' _col(29) "failures" /*
			*/ _col(39) "failures" /*
        		*/ _col(54) "SMR" /*
*/ _col(`=62-`cil'') `"`space'[`=strsubdp("`level'")'% `cilabel']"' /*
                	*/ _n "{hline 11}{c +}{hline 67}"
		}
		qui sum _t, meanonly
		local maxt=r(max)
                tempvar one
                qui gen int `one'=.
                local i 1
                while `i'<=`max' {
                        qui replace `one'=cond(`group'==`i',1,.)
                        sort `one'
                        cap confirm str var `by'
                        if _rc~=0 {
				local varl:value label `by'
				if "`varl'"~="" {
					local posb=`by'[1]
					local disp: label `varl' `posb'
				}
				else {
					local disp=string(`by'[1])
				}
                        }
                                else {
                                local disp=`by'[1]
                        }
			di as txt abbrev("`disp'",9) _col(12) "{c |}" 
			local atcnt: word count `at'
			tokenize `at'
			local j 2
			local flag 0
			while `j'<=`atcnt' {
				local k=`j'-1
                        	local mif= /*
			        */ `"`sif' `group'==`i' & _t>``k'' & _t<=``j''"'
                        	local mif1= /*
			        */ `"`sif' `group'==`i'"'
                        	local matsmr= "``k'' ``j''"
				preserve
				if index(`"`options'"',"smr")==0 {
					tempvar cat
					qui stsplit `cat', /*
					*/ at(`at') `trim' nopreserve
                        		cap qui Mstptime `mif', /*
                        		*/ `options' `ddopt' level(`level') /*
					*/ title(`"`title'"') /*
					*/ titpos(`titpos') `show' `jackknife'
					if `"`r(method)'"'== "jackknife" {
						local flag = `flag' + r(flag)
					}
                        		if r(ptime)~=. {
					if ``j''~=. & ``j''<=`maxt'{
						di as txt _col(1) /*
						*/ "(" %-4.0g ``k'' "-" /* 
						*/ %4.0g ``j'' "]" _c
					}
					else {
 						di as txt _col(6) ">" /*
						*/ %4.0g ``k'' " " _c
					}
                        	        di as txt "{c |}" _skip(3) /*
                        	        */ as res %10.`dec' r(ptime) /*
                        	        */ _skip(3) %8.0g r(failures) /*
                        	        */ _skip(2) %10.`dec' /*
                        	        */ r(rate) _skip(2) %9.`dec' r(lb) /*
                                	*/ _skip(3) %9.`dec' r(ub)
                        		}
					local mdup 59
				}
				else {
					if  ``j''>`maxt' {
                        			local matsmr= "``k'' `maxt'"
					}
					cap qui Mstptime `mif1', at(`matsmr') /*
					*/ trim `show' `jackknife'/*
					*/ title(`"`title'"') /*
					*/ titpos(`titpos') /*
               				*/ `options' `ddopt' level(`level') 
					if `"`r(method)'"'=="jackknife" {
						local flag = `flag' + r(flag)
					}
                        		if r(ptime)~=. {
					if ``j''~=. & ``j''<=`maxt' {
						di as txt _col(1) /*
						*/ "(" %-4.0g ``k'' "-" /* 
						*/ %4.0g ``j'' "]" _c
					}
					else {
 						di as txt _col(6) ">" /* 
						*/ %4.0g ``k'' " " _c
					}
                        	        di as txt "{c |}" _skip(3) /*
                        	        */ as res %10.`dec' r(ptime) /*
                        	        */ _skip(3) %8.0g r(failures) /*
                        	        */ _skip(2) %8.`dec' /*
                        	        */ r(expected) _skip(1) /*
					*/ %9.`dec' r(smr) /*
                                	*/ _skip(2) %9.`dec' r(lb) /*
                                	*/ _skip(3) %9.`dec' r(ub) 
                        		}
					local mdup 67
				}
				
				restore
                       		local j=`j'+1
			}
                	di as txt "{hline 11}{c +}{hline `mdup'}"
                       	local i=`i'+1
                }	
		if index(`"`options'"',"smr")==0 {
        	      	 qui Mstptime `if', at(`at') `trim' /*
			*/ `show' title(`"`title'"') titpos(`titpos') /*
        	       	*/ `options' `ddopt' level(`level') `jackknife'
			if `"`r(method)'"'=="jackknife" {
				local flag = `flag' + r(flag)
				local method "jackknife"
			}
                	di as txt "     total" _col(12) "{c |}" _col(16) /*
                                */ as res %10.`dec' r(ptime) /*
                                */ _col(29) %8.0g r(failures) /*
                                */ _col(39) %10.`dec' /*
                                */ r(rate) _col(51) %9.`dec' r(lb) /*
                                */ _col(63) %9.`dec' r(ub)
		}
		else {
        	      	qui Mstptime `if', at(`at') `trim' /*
			*/ `show' title(`"`title'"') titpos(`titpos') /*
        	       	*/ `options' `ddopt' level(`level') `jackknife'
			if `"`r(method)'"'=="jackknife" {
				local flag = `flag' + r(flag)
				local method "jackknife"
			}
                	di as txt "     total" _col(12) "{c |}" _col(16) /*
			*/ as res %10.`dec' r(ptime) /*
			*/ _col(29) %8.0g r(failures) /*
			*/ _col(39) %8.`dec' /*
			*/ r(expected) _col(48) /*
			*/ %9.`dec' r(smr) /*
			*/ _col(59) %9.`dec' r(lb) /*
			*/ _col(71) %9.`dec' r(ub) 
		}
                ret add
		
		if "`method'"=="jackknife" {
			jckknife_note1
			if `flag' > 0 {
				ret hidden scalar flag =1
				jckknife_note2
			}
			else ret hidden scalar flag = 0
			ret hidden local method "jackknife"
		}
	}
end

program define Mstptime, rclass 
	syntax [if], /*
	*/ [ AT(numlist >=0 sort) noPREserve DD(integer -100) TRIM  /*
	*/ OUTput(string asis) SMR(string) Using(string) title(string) /*
	*/ titpos(string) Level(cilevel) PER(real 1) noSHow Jackknife ]
	if `dd'==-100 {
                local dec="0g"
        }
        else {
                local dec="`dd'f"
        }
	if "`per'"~="" {
		local mper="* `per'"
	}
	tempvar touse
	st_smpl `touse' `"`if'"' `"`in'"' `"`by'"' `""'
	preserve
	qui keep if `touse'
	qui keep _*  `_dta[st_id]' `_dta[st_wv]' 
	if `"`smr'"'~="" {      /* smr(filename varname ) */
		tokenize `"`smr'"'
		if `"`2'"'=="" | `"`3'"'~="" {
			di as err /*
			*/"option smr() requires two variable:" /*
			*/  "a grouping variable and a rate variable"
			exit 198
		}
		local mergvar=`"`1'"'
		local ratevar=`"`2'"'
		if "`using'"=="" {
			di as err /*
			*/"option smr requires option using() containing" /*
			*/ _n "the reference population filename"
			exit 198
		}
		
		local file=trim(`"`using'"')
	}
	if "`using'" != "" & `"`smr'"' == "" {
		di as err "smr() option required when specifying using() option"
		exit 198
	}
	if "`at'"=="" {
		if "`trim'"~="" {
			noi di as err /*
			*/ "at() option required when specifying trim option"
			exit 198
		}
		qui sum _t
		local at=r(max)
		local atflg 1
	}
	qui stsplit _group if  `touse' , at(`at') nopreserve `trim' 
	if "`trim'"~="" {
		qui count if _st
		if r(N)==0 {
			di as err "invalid combination of at() and trim options"
			di as err "no observations remaining"
			exit 2000
		}
	}
	local myat="0"
	tokenize `at'
	while "`1'"~="" {
		local myat "`myat',`1'"
		mac shift
	}
	local mgrp=max(`myat')
	if `"`smr'"'~="" {
		qui gen `mergvar'=_group
		sort `mergvar'
		qui merge `mergvar' using `"`file'"'
		local smropt="smr(`ratevar')"
		qui keep if _merge==3
		qui count
		if r(N)==0 {
                        noi di as err "no observations merged, at()" /*
                        */ " option not specified or incorrectly specified "
			exit 2000
		}
		drop _merge
	}
	st_show `show'
	tempfile myfile1
	local outopt=`"output(`myfile1')"'
	qui `vv' strate _group, `outopt' level(`level') per(`per') `jackknife'
	if `"`r(method)'"'=="jackknife" {
		local flag = r(flag)
		local method = r(method)
	}

	tempfile myfile2
	local outopt=`"output(`myfile2')"'
	qui `vv' strate, `outopt' level(`level') per(`per') `jackknife'
	if `"`r(method)'"'=="jackknife" {
		local flag = `flag' + r(flag)
	} 
	if "`smr'"=="" {
		qui use `"`myfile1'"', clear
		qui append using `"`myfile2'"'
		if "`trim'"~="" {
			qui replace _group=`mgrp' if _group==.
		}
		else {	
			qui replace _group=1.0x+3fe    if _group==.
		}
		sort _group
		qui save `"`myfile2'"', replace
		MYdisp /*
		*/ `level' "`trim'" `dec' "`atflg'" `titpos' "`title'" "`mper'"
		if `"`output'"'~="" {
			qui save `output'
		}
		ret scalar ub=_Upper[_N]
		ret scalar lb=_Lower[_N]
		ret scalar rate=_Rate[_N]
		ret scalar failures=_D[_N]
		ret scalar ptime=_Y[_N]

		if `"`method'"'== "jackknife" {
			if `flag' > 0 {
				ret hidden scalar flag= 1
			}
			else ret hidden scalar flag = 0
			ret hidden local method = "`method'"
		}
		exit
	}
	else {
		tempfile myfile3
		local outopt=`"output(`myfile3')"'
		qui `vv' strate _group, /*
		*/ `outopt' level(`level') per(`per') `smropt' `jackknife'
		if `"`r(method)'"'=="jackknife" {
			local flag = r(flag)
			local method = r(method)
		}

		tempfile myfile4
		local outopt=`"output(`myfile4')"'
		qui `vv' strate, `outopt' level(`level') /*
		*/ per(`per') `smropt' `jackknife'
		if `"`r(method)'"'=="jackknife" {
			local flag = `flag' + r(flag)
			local method = r(method)
		}

		qui use `"`myfile1'"', clear
		qui append using `"`myfile2'"'
		qui replace _group=1.0x+3fe    if _group==.
		keep _Y _group
		sort _group
		qui save `"`myfile2'"', replace
		qui use `"`myfile3'"', clear
		qui append using `"`myfile4'"'
		qui replace _group=1.0x+3fe    if _group==.
		sort _group
		merge _group using `"`myfile2'"'
		qui keep if _merge==3
		if "`trim'"~="" {
			qui replace _group=`mgrp' if _group>=1e+307   
		}
		MYdisp2 /*
		*/ `level' "`trim'" `dec' "`atflg'" `titpos' `title' "`mper'"
		if `"`output'"'~="" {
			qui save `output'
		}
		ret scalar ub=_Upper[_N]
		ret scalar lb=_Lower[_N]
		ret scalar smr=_SMR[_N]
		ret scalar expected=_E[_N]
		ret scalar failures=_D[_N]
		ret scalar ptime=_Y[_N]

		if `"`method'"'== "jackknife" {
			if `flag' > 0 {
				ret hidden scalar flag= 1
			}
			else ret hidden scalar flag = 0
			ret hidden local method = "`method'"
		}
	}
end
prog def MYdisp	
	args level trim	dec atflg titpos title mper
	qui replace _Y=_Y `mper'
	local cil `=string(`level')'
	local cil `=udstrlen("`cil'")'
	if `cil' < 5 {
		local space ""
		local cilabel "Conf. Interval"
	}
	else {
		local space " "
		local cilabel "Conf.Interval"
	}
	noi di 
 	di as txt "Cohort" _col(12) "{c |}" `titpos' `"`title'"' /*
	*/ _col(29) "failures"/*
	*/  _col(45) "rate" /*
*/ _col(`=54-`cil'') `"`space'[`=strsubdp("`level'")'% `cilabel']"' _n /*
	*/ "{hline 11}{c +}{hline 59}"
	local i 1
	while `i'<_N-1 {
		 di as txt _col(1) "(" %-4.0g _group[`i'] "-" /* 
		*/ %4.0g _group[`i'+1] "]" /*
		*/ _col(12) "{c |}" _col(16) as res %10.`dec' _Y[`i'] /*
		*/ _col(29) %8.0g _D[`i'] _col(39) %10.`dec' _Rate[`i'] /*
		*/ _col(51) %9.`dec' _Lower[`i'] /*
		*/ _col(63) %9.`dec' _Upper[`i']
		local i=`i'+1
	}
	local i=_N-1
	if "`trim'"=="" & "`atflg'"=="" {
		 di as txt _col(6) ">" %4.0g _group[`i'] _col(12) "{c |}" /*
		*/ _col(16) as res %10.`dec' _Y[`i'] /*
		*/ _col(29) %8.0g _D[`i'] _col(39) %10.`dec' _Rate[`i'] /*
		*/ _col(51) %9.`dec' _Lower[`i'] /*
		*/ _col(63) %9.`dec' _Upper[`i'] /*
		*/ as txt _n "{hline 11}{c +}{hline 59}"
	}
	else if "`atflg'"=="" {
		 di as txt _col(1) "(" %-4.0g _group[`i'] "-" /*
		*/ %4.0g _group[`i'+1] "]" /*
		*/ _col(12) "{c |}" _col(16) as res %10.`dec' _Y[`i'] /*
		*/ _col(29) %8.0g _D[`i'] _col(39) %10.`dec' _Rate[`i'] /*
		*/ _col(51) %9.`dec' _Lower[`i'] /*
		*/ _col(63) %9.`dec' _Upper[`i'] /*
		*/ as txt _n "{hline 11}{c +}{hline 59}"
	}

	local i=_N
	 di as txt "     total" _col(12) "{c |}" _col(16) as res %10.`dec' _Y[`i'] /*
	*/ _col(29) %8.0g _D[`i'] _col(39) %10.`dec' _Rate[`i'] /*
	*/ _col(51) %9.`dec' _Lower[`i'] /*
	*/ _col(63) %9.`dec' _Upper[`i'] 
end
prog def MYdisp2
	args level trim dec atflg titpos title mper
	qui replace _Y=_Y `mper'
	local cil `=string(`level')'
	local cil `=udstrlen("`cil'")'
	if `cil' < 5 {
		local space ""
		local cilabel "Conf. Interval"
	}
	else {
		local space " "
		local cilabel "Conf.Interval"
	}
	noi di 
	di as txt _col(12) /* 
	*/ "{c |}" _col(29)              "observed" _col(39)  "expected"
 	di as txt "Cohort" _col(12) "{c |}" `titpos' `"`title'"' /*
	*/  _col(29) "failures" _col(39) "failures" /* 
	*/ _col(54) "SMR" /*
*/ _col(`=62-`cil'') `"`space'[`=strsubdp("`level'")'% `cilabel']"' _n /*
	*/ "{hline 11}{c +}{hline 67}"
	local i 1
	while `i'<_N-1 {
		 di as txt _col(1) "(" %-4.0g _group[`i'] "-" /*
		*/ %4.0g _group[`i'+1] "]" /* 
		*/ _col(12) "{c |}" _col(16) as res %10.`dec' _Y[`i'] /*
		*/ _col(29) %8.0g _D[`i'] _col(39) %8.0g _E[`i'] /* 
		*/ _col(50) %7.`dec' _SMR[`i'] _col(59) %9.`dec' _Lower[`i'] /*
		*/ _col(71) %9.`dec' _Upper[`i']
		local i=`i'+1
	}
	local i=_N-1
	if "`trim'"=="" & "`atflg'"=="" {
	 	di as txt _col(6) ">" %4.0g _group[`i'] _col(12) "{c |}" /* 
		*/ _col(16) as res %10.`dec' _Y[`i'] /*
		*/ _col(29) %8.0g _D[`i'] _col(39) %8.0g _E[`i'] /* 
		*/ _col(50) %7.`dec' _SMR[`i'] _col(59) %9.`dec' _Lower[`i'] /*
		*/ _col(71) %9.`dec' _Upper[`i'] /*
		*/ as txt _n "{hline 11}{c +}{hline 67}"
	}
	else if "`atflg'"=="" {
		 di as txt _col(1) "(" %-4.0g _group[`i'] "-" %4.0g /*
		*/ _group[`i'+1] "]" /*
		*/ _col(12) "{c |}" _col(16) as res %10.`dec' _Y[`i'] /*
		*/ _col(29) %8.0g _D[`i'] _col(39) %8.0g _E[`i'] /* 
		*/ _col(50) %7.`dec' _SMR[`i'] _col(59) %9.`dec' _Lower[`i'] /*
		*/ _col(71) %9.`dec' _Upper[`i'] /*
		*/ as txt _n "{hline 11}{c +}{hline 67}"
	}

	local i=_N
	 di as txt "     total" _col(12)  _col(12) "{c |}" /* 
	*/ _col(16) as res %10.`dec' _Y[`i'] /*
	*/ _col(29) %8.0g _D[`i'] _col(39) %8.0g _E[`i'] /* 
	*/ _col(50) %7.`dec' _SMR[`i'] _col(59) %9.`dec' _Lower[`i'] /*
	*/ _col(71) %9.`dec' _Upper[`i']
end

program define jckknife_note1
	di
	di as txt "{p}Note: The jackknife was used to calculate "	///
		"confidence intervals.{p_end}"	     
end

program define jckknife_note2
	di as smcl "{p 0 6}Note: Jackknife confidence intervals "	     ///
		 "are missing because of an {help stptime_j:insufficient} " ///
		  "number of failures in the dataset.{p_end}"
end
