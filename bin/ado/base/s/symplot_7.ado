*! version 2.1.2  29sep2004
program define symplot_7, sort
	version 6, missing
	syntax varname [if] [in] [, *] 
	tempvar VAR ABOVE BELOW LINE CNT
	quietly {
		gen double `VAR' = `varlist' `if' `in'
		sort `VAR'
		gen long `CNT'=sum(`VAR'~=.)
		if `CNT'[_N]==0 { error 2000 } 
		local midpt = int(`CNT'[_N]+1)/2
		#delimit ;
		local median=cond(int(`CNT'[_N]/2)*2==`CNT'[_N],
				(`VAR'[`midpt']+`VAR'[`midpt'+1]) / 2,
				`VAR'[`midpt']) ;
		#delimit cr
		gen `BELOW'=`VAR'-(`median')
		drop `VAR'
		sort `BELOW'
		gen `ABOVE'=`BELOW'[`CNT'[_N]+1-_n]
		replace `BELOW'=abs(`BELOW')
		gen `LINE'=`BELOW'
		lab var `LINE' " "
		lab var `BELOW' "Distance below median"
		lab var `ABOVE' "Distance above median"
		local w : variable label `varlist'
		if "`w'"=="" {
			local w "`varlist'"
		}
	}
	gr7 `ABOVE' `LINE' `BELOW' if _n<=`midpt', /*
	      */    sy(oi) c(.l) sort `options' t2(`"`w'"')
end
