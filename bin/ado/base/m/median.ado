*! version 7.0.5  10jun2008
program define median, rclass byable(recall)
	version 7, missing
        syntax varlist(max=1) [if] [in] [fweight], by(varname) /*
	*/ [ Exact MEDianties(string) ]
	
        capture confirm numeric variable `by'
        if _rc {
                tempvar numby
                encode `by', generate(`numby')
                local by "`numby'"
        }
		
        marksample touse, strok
        markout `touse' `by'

	local x "`varlist'"
	tempname hilab
	tempvar median hi smed
	if "`medianties'"~="" {
		if "`medianties'"~="drop" & "`medianties'"~= "above" & /*
		*/ "`medianties'"~="below" & "`medianties'"~= "split" {
			di in red `"medianties(`medianties') option invalid"'
			exit 198
		}
	}
	else {
		local medianties="below"
	}
	if "`weight'"!="" {
		local wtopt="[fw `exp']"
	}
	quietly {
		summarize `by' if `touse' `wtopt', meanonly
		if r(N) == 0 { noisily error 2000 }
		if r(min) == r(max) {
			di in red "1 group found, 2 required"
			exit 499
		}

		sum `x' if `touse' `wtopt', detail
		gen double `median' = r(p50) if `touse'

		count if `x' == `median' & `touse'
		if r(N) == 0 & "`medianties'"=="split" {
			local medianties "drop"
		}

		gen double `hi' = 0 if `touse'
		if "`medianties'"=="drop" {
			replace `hi' = . if `x'==`median' & `touse'
			replace `touse' = 0 if `x'==`median' 
			replace `hi' = 1 if `x'>`median' & `touse'
			label var `hi' "Greater than the median"
		}
		else if "`medianties'"== "above" {
			replace `hi' = 1 if `x'>=`median' & `touse'
			label var `hi' "Greater or equal to the median"
		}
		else if "`medianties'"=="split" {
			preserve
			keep if `touse'
			if  "`weight'"!~="" {
				tokenize `exp'
				expand `2'
				local wtopt
			}
			count if `x'==`median' & `touse'
			local med = r(N)
			replace `hi'=1 if `x'>`median' & `touse'
			set seed0 879543489
			gen `smed' = .
			replace `smed' = uniform0() if `x'==`median'
			sort `smed'
			local medeven = `med'/2
			local medodd1 = (`med'-1)/2
			local medodd2 = (`med'+1)/2
			if mod(`med',2)==0 {
			replace `hi'=1 in 1/`medeven'
			}
			if mod(`med',2)==1 { 
			replace `hi'=1 in 1/`medodd1' 
			replace `hi'=. in `medodd2' 
			replace `touse'=0 in `medodd2' 
			}
			label var `hi' "Greater than the median"
		}
		else {
		  	replace `hi' = 1 if `x'>`median' & `touse'
			label var `hi' "Greater than the median"
		}	
		label def `hilab'  0 "no" 1 "yes"
		label values `hi' `hilab'
	}
	tempname CM
	di in gr _n "Median test" 
	tab `hi' `by' if `touse' `wtopt' , chi `exact' matcell(`CM')
	local N = r(N)
	local numcol=r(c)
	ret scalar p1_exact = r(p1_exact)
	ret scalar p_exact = r(p_exact)
	*ret add
	if `numcol' == 2 {
		di in gr _n "   Continuity corrected:"
		local A=`CM'[1,1]
		local B=`CM'[1,2]
		local C=`CM'[2,1]
		local D=`CM'[2,2]
		tempname chi2 
		scalar `chi2'=`N'* (abs(`A'*`D' - `B'*`C')-(`N'/2))^2 
		scalar `chi2'=`chi2'/((`A'+`B')*(`C'+`D')*(`A'+`C')*(`B'+`D')) 
		noi di in gr "          Pearson chi2(" in ye "1" in gr ") = " /*
		*/ in ye %8.4f `chi2' /*
		*/ in gr "   Pr = " in ye %5.3f chiprob(1,`chi2') 
		ret scalar p_cc = chiprob(1,`chi2')
       		ret scalar chi2_cc = `chi2'
	}
	ret scalar p = r(p)
	ret scalar chi2 = r(chi2)
	ret scalar groups= `numcol'  
	ret scalar N= `N'
end
