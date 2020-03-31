*! version 6.3.1  14nov2013 
program define strate_7, rclass sortpreserve 
	version 6.0, missing
	st_is 2 analysis

	local missing = cond(_caller()<=5, "noMissing", "Missing")

	local baopts /*
		*/ Jackknife CLuster(varname) PER(real 1) 		/*
		*/ noLIst `missing' SMR(varname) Level(cilevel) 	/*
		*/ OUTput(string asis)

	local gropts /*
		*/ Graph L1(string) B2(string) noWhisker Connect(string) /* 
		*/ key1(string) key2(string) *

	syntax [varlist(default=none)] [in] [if] [, `baopts' `gropts' ]
	if "`graph'"=="" {
		cap noi syntax [varlist(default=none)] [in] [if] [, `baopts']
		if _rc { 
			di in red /*
	*/ "(option is invalid or you need to specify graph option, too)"
			exit _rc
		}
	}
	local baopts
	local gropts

	local missing = cond(_caller()>5, ///
		cond("`missing'"=="","nomissing",""),"`missing'")
	local ev `varlist'
	local nvar : word count `ev'

	if "`jackknife'" != "" {
		local jack "jack"
	}

	if "`cluster'" == "" {
		if "`jack'" != "" {
			local cluster : char _dta[st_id]
		}
	}
	else 	local jack "jack"


				/* output(filename[, replace]) */
	if `"`output'"'!="" {
		gettoken outnam output : output, parse(",")
		gettoken comma output : output, parse(",") 
		if `"`comma'"' == "," { 
			gettoken outrepl output : output, parse(" ,")
			gettoken comma output : output, parse(" ,")
			if `"`outrepl'"' != "replace" | `"`comma'"'!="" { 
				di in red "option output() invalid"
				exit 198
			}
		}
		else if `"`comma'"' != "" {
			di in red "option output() invalid"
			exit 198
		}
		else 	confirm new file `"`outnam'.dta"'
	}

	local aw : char _dta[st_w]
	st_show

	if "`list'"=="nolist" & "`graph'"=="" & `"`outnam'"'=="" {
		exit
	}

	local ttype : type _t 
	local timin : char _dta[st_t0]
	tempvar d y
	qui gen `ttype' `y' = _t
	qui replace `y' = `y' - _t0

	qui replace `y'=`y'/`per'

	local weight : char _dta[st_wt]
	if "`weight'"!="" {
        	local wt: char _dta[st_wv]
		tempvar W
		qui gen double `W' = `wt'
	}
	if "`weight'" == "iweight" | "`weight'" == "pweight"  {
		local jack "jack"
	}

	tempvar touse D Y wd wy rate jm jv jn cll clh 

	mark  `touse'  `if'  `in' 
	if "`missing'"=="nomissing" {
		markout `touse' `W' `smr' _d  `y' `ev' 
	}
	else 	markout `touse' `W' `smr' _d  `y'
	qui replace `touse'=0 if _st==0

	if "`W'"=="" {
		local W = 1
	}

	qui {
		if "`smr'"!="" {
			replace `y' = `smr'*`y' if `touse'
		}
		count if `touse'
		local inc =r(N)
		gen double `wd' = `W'*_d  if `touse'
		gen double `wy' = `W'*`y' if `touse'
		sort `touse' `ev' `cluster', stable
		tempvar last nonzero NON
		if "`jack'"!="" {
			 if "`cluster'"!="" {
				by `touse' `ev' `cluster': /*
					*/ replace `wd' = sum(`wd') if `touse'
				by `touse' `ev' `cluster': /*
					*/ replace `wy' = sum(`wy') if `touse' 
				by `touse' `ev' `cluster': /*
					*/ gen byte `last'=( _n==_N) if `touse'
				by `touse' `ev' `cluster': /*
					*/ gen byte `nonzero' = 1 /*
					*/ if `wd'[_N] != 0 & `touse'
			}
			else {
				gen byte `last' = `touse'
				gen byte `nonzero' = 1 if `wd'!=0 & `touse'
			}

			count if `last'==1 /* & `touse' implied */
			local cin =r(N) 
				
			if "`ev'"!="" {
				replace `wd'=. if `last'~=1
				replace `wy'=. if `last'~=1
				replace `nonzero'=. if `last'~=1
				by `touse' `ev': /*
					*/ gen double `D' = sum(`wd') if `touse'
				by `touse' `ev': /*
					*/ gen double `Y' = sum(`wy') if `touse'
				by `touse' `ev': /*
					*/ gen byte `NON' = sum(`nonzero') /*
					*/ if `touse'
				by `touse' `ev': gen `jn' = sum(`touse') 
				by `touse' `ev': /*
					*/ replace `jn' = sum(`last') if `touse'
				by `touse' `ev': gen double `jm' = /*
					*/ (`D'[_N]-(`wd'))/(`Y'[_N]-(`wy')) /*
					*/  if `touse' 
				by `touse' `ev': replace `jm' =/*
					*/ `jn'[_N]*log(`D'[_N]/`Y'[_N]) /*
					*/ - (`jn'[_N]-1)*log(`jm') /*
					*/  if `touse' 
				gen double `jv' = `jm'^2 if `touse'
				by `touse' `ev': replace `jm' = sum(`jm') /*
					*/ if `touse'
				by `touse' `ev': replace `jv' = sum(`jv') /*
					*/ if `touse'
				by `touse' `ev': replace `last'= ( _n==_N) /*
					*/ if `touse'
			}
			else {
				replace `wd'=. if `last'~=1
				replace `wy'=. if `last'~=1
				replace `nonzero'=. if `last'~=1
				gen double `D' = sum(`wd') /* sic */
				gen double `Y' = sum(`wy') /* sic */
				gen byte `NON' = sum(`nonzero')
				gen `jn' = sum(`last')
				gen double `jm' = /*
					*/ (`D'[_N]-(`wd'))/(`Y'[_N]-(`wy')) /*
					*/ if `touse'
				replace `jm' = `jn'[_N]*log(`D'[_N]/`Y'[_N]) /*
					*/ - (`jn'[_N]-1)*log(`jm') if `touse'
				gen double `jv' = `jm'^2 if `touse'

				replace `jm' = sum(`jm') /* sic */
				replace `jv' = sum(`jv') /* sic */
				replace `last'= ( _n==_N) /* sic */
			}
			gen double `rate' = `D'/`Y' if `touse'

			replace `jm' = cond(`touse', `jm'/`jn', .)
			replace `jv' = cond(`touse', /*
			*/ sqrt((`jv' - `jn'*(`jm'^2))/(`jn'*(`jn' - 1))),.)

			local z = invnorm(0.5 + `level'/200)  
			gen double `cll' = /*
			*/ cond((`NON'==0|`NON'==1), ., exp(`jm' - `z'*`jv')) 
			gen double `clh' = /*
			*/ cond((`NON'==0|`NON'==1), ., exp(`jm' + `z'*`jv')) 
		}
		else {
			if "`ev'"!="" {
				by `touse' `ev': gen double `D' = sum(`wd') /*
					*/ if `touse'
				by `touse' `ev': gen double `Y' = sum(`wy') /*
					*/ if `touse'
				by `touse' `ev': gen byte `last'= ( _n==_N) /*
					*/ if `touse'
			}
			else {
				gen double `D' = sum(`wd') /* sic */
				gen double `Y' = sum(`wy') /* sic */
				gen byte `last'= ( _n==_N) /* sic */
			}
			gen double `rate' = `D'/`Y' if `touse'
			gen double `jm' = log(`D'/`Y') if `touse'
			gen double `jv' = sqrt(1/`D') if `touse'
			
			
			local z = invnorm(0.5 + `level'/200)  
			gen double `cll' = /*
				*/ cond(`D'==0, ., exp(`jm' - `z'*`jv')) 
			gen double `clh' = /*
				*/ cond(`D'==0, ., exp(`jm' + `z'*`jv')) 
		} 

	}
	di
	if "`smr'" != "" {
		di in gr "Estimated SMRs and lower/upper bounds" /*
		*/ `" of `=strsubdp("`level'")'% confidence intervals"'
	}
	else {
		di in gr "Estimated rates " _continue 
		if `per'!=1 {
			di in gr "(per `per') " _continue
		}
		di in gr /*
*/ `"and lower/upper bounds of `=strsubdp("`level'")'% confidence intervals"'
	}
	di in gr "(" in ye `inc' in gr " records included in the analysis)"
	if "`jack'"!="" {
		di in gr /*
		*/ "The jackknife was used to calculate confidence intervals"
		if "`cluster'" != "" {
			if ("`ev'"=="") {	
				di in ye `cin' in gr _col(8) "clusters " /*
					*/  "identified by " /*
					*/ in ye "`cluster'"
			}
			else {
				if (`nvar'==1) {
					di in ye `cin' in gr _col(8) /*
					*/ "total clusters identified by " /*
					*/ in ye "`cluster'" /*
					*/ in gr " and " in ye "`ev'"
				}
				else {
					di in ye `cin' in gr _col(8) /*
					*/ "total clusters identified by " /*
					*/ in ye "`cluster'" /*
					*/ in gr " and the strata variables"
				}
			}
		}
	}
	if "`ev'"=="" & "`graph'"!="" {
		di in bl /*
		*/ "Warning: graphical output suppressed - no groups to plot"
		local graph
	}
	if "`graph'"!="" {
		tokenize `ev'
		if "`2'"!="" {
			tempvar g
			qui egen `g'=group(`ev')
			local b2 "Groups by: `ev'"
		}
		else {
			local g "`ev'"
			local b2 "`ev'"
			local listg "noobs"
		}
	}
	else {
		local listg "noobs"
	}

	if "`key1'"=="" {
		local key1 = " "
	}
	if "`key2'"=="" {
		local key2 = " " 
	}
	capture noisily {
		rename `D' _D
		char _D[varname] "D"
		rename `cll' _Lower
		rename `clh' _Upper
		format _D %4.0f
		
		if "`jack'" != "" {
			qui count if `last'==1 & (`NON'==0 | `NON'==1)
			local missflg = r(N)
		}
 
		if "`smr'"!="" {
			rename `Y' _E
			format _E %8.2f
			char _E[varname] "E"
			rename `rate' _SMR
			char _SMR[varname] "SMR"
			SEtfmt _SMR _Lower _Upper, w(8) s(4) l(`last')
			char _Lower[varname] "Lower"
			char _Upper[varname] "Upper"
			if "`list'"!="nolist" {
				list `ev' _D _E _SMR _Lower _Upper /*
				*/ if `last'==1 & `touse', `listg' subvar
				
				if "`jack'" != "" {
					if `missflg' {
						jckknife_note
					}
				}	 
			}
			if "`graph'"!="" {
				if "`l1'"=="" {
					local l1 "SMR"
				}
				if "`whisker'"=="nowhisker" {
					if "`connect'"!="" {
						local conopt="c(`connect')"
					}
					else local conopt="c(.)"
					gr7 _SMR `g' if `last'==1, /*
					*/ s(o) `conopt' /*
					*/ l1("`l1'") b2("`b2'") /* 
					*/ key1("`key1'") key2("`key2'") /*
					*/ `options' 
				}
				else {
					if "`connect'"!="" {
						local conopt="c(`connect')"
					}
					else local conopt="c(.||)"
					gr7 _SMR _Lower _Upper `g'/*
					*/  if `last'==1, /*
					*/ s(oii) `conopt' /*
					*/ l1("`l1'") b2("`b2'") /*
					*/ key1("`key1'") key2("`key2'") /*
					*/ `options' 
				}
			}
		}
		else {
			rename `Y' _Y
			SEtfmt _Y, w(8) s(5) l(`last')
			qui gen str13 _NY=string(_Y,"%8.4f")
			qui rename _Y _MY
			rename _NY _Y
			qui compress
			rename `rate' _Rate
			char _Y[varname] "Y"
			SEtfmt _Rate _Lower _Upper, w(8) s(5) l(`last')
			char _Rate[varname] "Rate"
			char _Lower[varname] "Lower"
			char _Upper[varname] "Upper"
			if "`list'"!="nolist" {
				list `ev' _D _Y _Rate _Lower _Upper /*
				*/ if `last'==1 & `touse', `listg' nodisp subvar
				
				if "`jack'" != "" {
					if `missflg' {
						jckknife_note
					}
				}

			}
			qui drop _Y
			qui rename _MY _Y
			if "`graph'"!="" {
				if "`l1'"=="" {
					if `per'!=1 {
						local l1 "Rate (per `per')"
					}
					else {
						local l1 "Rate"
					}
				}
				if "`whisker'"=="nowhisker" {
					if "`connect'"!="" {
						local conopt="c(`connect')"
					}
					else local conopt="c(.)"
					gr7 _Rate `g' /*
					*/ if `last'==1, s(o) `conopt' /*
				        */ l1("`l1'") b2("`b2'") /* 
					*/ key1("`key1'") key2("`key2'") /*
					*/ `options' 
				}
				else {
					if "`connect'"!="" {
						local conopt="c(`connect')"
					}
					else local conopt="c(.||)"
					gr7 _Rate _Lower _Upper /*
					*/ `g' if `last'==1, /*
					*/ s(oii) `conopt' /*
					*/ l1("`l1'") b2("`b2'") /*
					*/ key1("`key1'") key2("`key2'") /*
					*/ `options' 
				}
			}
		}
		di
		if `"`outnam'"' != "" {
			preserve
			qui keep if `last'==1 & `touse'
			label var _D "# Failures"
			label var _Lower /*
			   */ `"Lower `=strsubdp("`level'")'% confidence limit"'
			label var _Upper /*
			   */ `"Upper `=strsubdp("`level'")'% confidence limit"'
			if "`smr'"=="" {
				keep `ev' _D _Y _Rate _Lower _Upper
				label var _Y "Person-time observation"
				label var _Rate "Rate estimate" 
			}
			else {
				keep `ev' _D _E _SMR _Lower _Upper
				label var _E "Expected # failures"
				label var _SMR "SMR estimate" 
			} 
			stset, clear
			qui save `"`outnam'"', `outrepl'
			restore
		}
		
	}

	if "`jack'" !="" {
		return hidden scalar flag = `missflg'
		return hidden local method "jackknife"
	}

	local rc = _rc

	capture drop _D
	capture drop _E
	capture drop _SMR
	capture drop _Lower
	capture drop _Upper
 	capture drop _Y
	capture drop _Rate	
	capture drop _MY
	capture drop _NY

	exit `rc'
end

* Program to compute output format

program define SEtfmt
	syntax varlist [, Width(int 8) Sigfig(int 3) Last(varname) ]
	tokenize "`varlist'"
	tempvar lv 
	qui gen double `lv' = .
	local after = 0
	local minus = 0
	while "`1'"!="" {
		local v "`1'"
		mac shift
		quietly {
			count if `v'<0 & `last'==1
			local minus = (r(N)>0) | `minus'

			replace `lv' = log10(abs(`v')) if `v'!=0 & `last'==1
			summ `lv' 
			local count = r(N) 
			if `count'>0 {
				local aneed = int(`sigfig' - _result(5))
				if `aneed' > `after' {
					local after "`aneed'"
				}
			}
			local lname = length("`v'")
			if `lname'>`width' {
				local width  "`lname'"
			}
		}
	}
	local amax = `width' - `minus' - 1
	if `after' > `amax' {
		local after = `amax'
	}
	format `varlist' %`width'.`after'f
end

program define jckknife_note
	di as smcl "{p 0 6}Note: Jackknife confidence intervals "	     ///
		  "are missing because of an {help strate_j:insufficient} " ///
		  "number of failures in the dataset.{p_end}"
end
