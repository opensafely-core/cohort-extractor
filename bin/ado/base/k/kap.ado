*! version 3.2.8  22sep2004
program define kap, rclass
	version 6.0, missing
	syntax varlist(min=2) [if] [in] [fweight] [, Absolute Tab Wgt(string)]

	local n : word count `varlist'
	if `n' > 2 { 
		local opts "`absolut' `tab'"
		if "`wgt'" != "" {
			local opts "opts wgt(`wgt')"
		}
		kap_3 `varlist' [`weight'`exp'] `if' `in' , `opts'
		ret add
		exit
	}

	parse "`varlist'", parse(" ")
	local r `1'
	local c `2'
	if "`tab'"=="" { 
		local tab "*"
		local skip "noisily di"
	}
	else {	local tab "noisily tab" }
	tempvar touse fij sum fi fj wij wi wj ro co
	tempfile master tmp
	preserve
	quietly {
		if `"`if'"'!="" | "`in'"!="" { 
			keep `if' `in'
		}
		keep if `r'< . & `c'< . 
		if "`weight'"~="" { 
			gen double `fij' `exp' 
		}
		else 	gen double `fij'=1
		keep `r' `c' `fij'
		keep if `fij'>0 & `fij'< .
		if _N<2 { error 2001 } 
		capture assert `fij'==int(`fij') 
		if _rc { error 401 } 

					/* rectangularize	*/
		local rlbl : variable label `r'
		local clbl : variable label `c'
		save `"`master'"'
		keep `c'
		rename `c' `r'
		append using `"`master'"'
		keep `r'
		sort `r'
		by `r': keep if _n==1
		rename `r' `c'
		save `"`tmp'"'
		rename `c' `r'
		cross using `"`tmp'"'
		append using `"`master'"'
		replace `fij'=0 if `fij'>=.

		sort `r' `c'
		by `r' `c': replace `fij'=sum(`fij')
		by `r' `c': keep if _n==_N

		label var `r' `"`rlbl'"'
		label var `c' `"`clbl'"'
		if "`absolut'"=="" {	/* set k1=# of rows, k2=# of cols */
			tempvar ksum
			sort `r'
			by `r': gen `ksum' = 1 if _n==1
			summ `ksum', meanonly
			local k1 = r(sum)
			drop `ksum'
			sort `c'
			by `c': gen `ksum' = 1 if _n==1
			summ `ksum', meanonly
			local k2 = r(sum)
			drop `ksum'
		}
		else {
			capture assert `r'==int(`r') & `c'==int(`c') & /*
			*/ `r'>=1 & `c'>=1
			if _rc { 
				di in red /*
*/ "`r' and `c' not integers 1, ..., K" _n /*
*/ "this is required when option absolute is specified"
				exit 498
			}
			summ `r'
			local k1 = r(max)
			summ `c'
			local k2 = r(max)
		}
		local k = max(`k1',`k2')
		local k1
		local k2


		sort `r' `c'
		`tab' `r' `c' [fw=cond(`fij'==0,1,`fij')], sub(`fij')
		if `k'<2 { 
			noisily di in red "too few rating categories"
			exit 499
		}
		gen double `sum' = sum(`fij')
		replace `fij' = `fij'/`sum'[_N]
		local n = `sum'[_N]

		if "`wgt'"=="I" | "`wgt'"=="" {
			gen double `wij'=cond(`r'==`c',1,0) 
		}
		else { 
			if "`absolut'"=="" {
				by `r': gen int `co'=_n
				sort `c' `r'
				by `c': gen int `ro'=_n
				sort `r' `c'
			}
			else {
				gen int `ro' = `r'
				gen int `co' = `c'
			}
			if "`wgt'"=="w" { 
				gen double `wij'=1-abs(`ro'-`co')/(`k'-1)
			}
			else if "`wgt'"=="w2" { 
				gen double `wij'=1-((`ro'-`co')/(`k'-1))^2
			}
			else { 
				parse "$`wgt'", parse(" ")
				if "`1'"!="kapwgt" { 
					noisily di in red /*
						*/"kappawgt `1' not found"
					exit 111
				}
				if ("`absolut'"=="" & `2'!=`k') | /*
				*/ ("`absolut'"!="" & `2'<`k') {
					noisily di in red "`1' not `k' x `k'"
					exit 198
				}
				gen double `wij'=.
				mac shift 2
				local i 1
				while `i'<=`k' { 
					local j 1
					while `j'<=`i' {
						replace `wij'=`1' if /*
						*/ (`ro'==`i' & `co'==`j') | /*
						*/ (`ro'==`j' & `co'==`i')
						local j=`j'+1
						mac shift
					}
					local i=`i'+1
				}
			}
			drop `ro' `co'
		}

		if "`wgt'"!="" & "`wgt'"!="I" { 
			`skip'
			local skip "noisily di"
			noisily di in green "Ratings weighted by:"
			local i = 1 
			while `i'<=_N { 
				noisily di in ye %9.4f `wij'[`i'] _c 
				if `r'[`i']!=`r'[`i'+1] { noisily di } 
				local i = `i'+ 1
			}
		}

		replace `sum'=sum(`wij'*`fij')
		local p0 = `sum'[_N]

		by `r': gen double `fi'=sum(`fij')
		by `r': replace `fi'=`fi'[_N]
		sort `c' `r'
		by `c': gen double `fj'=sum(`fij')
		by `c': replace `fj'=`fj'[_N] 

		by `c': gen double `wj'=sum(`fi'*`wij')
		by `c': replace `wj'=`wj'[_N]
		sort `r' `c'
		by `r': gen double `wi'=sum(`fj'*`wij')
		by `r': replace `wi'=`wi'[_N]


		replace `sum'=sum(`wij'*`fi'*`fj')
		local pe=`sum'[_N]
		local k=(`p0'-`pe')/(1-`pe')
		replace `sum'=sum(`fi'*`fj'*(`wij'-(`wi'+`wj'))^2)
		local se=1/((1-`pe')*sqrt(`n'))*sqrt(`sum'[_N]-(`pe')^2)

 		/* double save in S_# and r() */
		ret scalar N = `n'
		ret scalar prop_o = `p0'
		ret scalar prop_e = `pe'
		ret scalar kappa = `k'
		ret scalar z = `k'/`se'
            ret scalar se = `se'
		global S_1 `n'
		global S_2 `p0'
		global S_3 `pe'
		global S_4 `k'
		global S_5 `return(z)'

		`skip'
		#delimit ;
		noisily di in smcl in gr _col(14) "Expected" _n
		"Agreement   Agreement     Kappa   Std. Err.         Z      Prob>Z"
		_n "{hline 65}" ;
		noisily di %7.2f `p0'*100 "%" %11.2f `pe'*100 "%"
		%11.4f `k' %11.4f `se' %11.2f return(z) %12.4f 1-normprob(return(z));
		#delimit cr
	}
end
