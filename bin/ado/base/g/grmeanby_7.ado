*! version 1.2.5  16feb2015  
program define grmeanby_7
	version 6, missing
	syntax varlist [if] [in] [aw fw], SUmmarize(varname) [ /*
		*/ B2title(string) MEDian /*
		*/ Symbol(string) T1title(string) T2title(string) /*
		*/ XSCale(string) XLAbel YLine(string) * ]

	if "`xlabel'"!="" { error 198 }		/* xlabel not allowed */

	if "`median'"=="" {
		local sumopts
		local sumres "r(mean)"  /* where result found after -summ- */
		local ttlhead "Means"
	}
	else {
		local sumopts ", detail"
		local sumres "r(p50)"   /* where result found after -summ- */
		local ttlhead "Medians"
	}
	
	tempvar touse x mean mean2 lbl grp strv id mine hi lo wgt
	mark `touse' [`weight'`exp'] `if' `in'

	quietly { 
		gen `x' = . 
		gen `mean' = . 
		gen `mean2'= .
		gen str16 `lbl' = ""
		gen `c(obs_t)' `id'=_n
		tokenize `varlist'
		local ttl "`1'"
		local o 1
		local i 1

		if "`weight'"!="" {
			gen `wgt' `exp' if `touse'
			local weight "[`weight'=`wgt']"
			local ttlhead = "Weighted " + /* 
				*/ lower(bsubstr(`"`ttlhead'"',1,1)) + /* 
				*/ bsubstr(`"`ttlhead'"',2,.)
		}

		while "``i''"!="" {
			if `i'!=1 {
				local ttl "`ttl', ``i''"
			}
			egen `grp'=group(``i'') if `touse'
			local t : type ``i''
			if bsubstr("`t'",1,3)=="str" {
				gen str8 `strv' = ``i''
			}
			else {
				local t : value label ``i''
				if "`t'"=="" {
					gen str10 `strv'=string(``i'')
				}
				else	decode ``i'', gen(`strv') maxlength(8)
			}
			sum `grp'
			local maxg=r(max)
			local j 1
			while `j'<=`maxg' {
				if `o'+1>_N { error 1001 }
				sum `summari' `weight' if `grp'==`j' `sumopts'
				replace `mean' = `sumres' if `id'==`o'
				replace `mean2'=`sumres' if `id'==`o'+1
				replace `x'=`i' if `id'==`o' | `id'==`o'+1
				gen `mine'=1 if `grp'==`j'
				sort `mine'
				replace `lbl'=`strv'[1] if `id'==`o'+1
				drop `mine' 
				local o=`o'+2
				local j=`j'+1
			}
			drop `strv' `grp'
			capture label drop `strv'
			local i=`i'+1
		}
		local adj=.18*(`i'-1)/3
		replace `x'=`x'-`adj' if `lbl'!=""
		sort `x' `mean'
		by `x': gen `lo' = `mean'[1] if `x'< .
		replace `mean'=-`mean'
		sort `x' `mean'
		replace `mean'=-`mean'
		by `x': gen `hi' = `mean'[1] if `x'< .
		sum `summari' `weight' if `touse'==1 `sumopts'
		local yli=`sumres'
	}
	if `"`t1title'"'=="" & `"`t2title'"'=="" {
		local t1 " "
		local t2 `"`ttlhead' of `summari'"'
		local t : variable label `summari'
		if "`t'"!="" {
			local t2 "`t2', `t'"
		}
	}
	else {
		if `"`t2title'"'=="" {
			local t1 " "
			local t2 `"`t1title'"'
		}
		else {
			local t1 `"`t1title'"'
			local t2 `"`t2title'"'
		}
	}
	if `"`b2title'"'=="" {
		local b2title `"`ttl'"'
	}

	if "`yline'"=="" {
		local yline "`yli'"
	}

	if "`xscale'"=="" {
	local losca=`i'-.5
		local xscale ".5,`losca'"
	}


	if "`symbol'"=="" {
		local symbol "s(O..[`lbl'])"
	}
	else {
		local symbol = "s(" + bsubstr("`symbol'",1,1)+"..[`lbl'])"
	}
	gr7 `mean' `hi' `lo' `mean2' `x', `symbol' c(.||.) trim(10) /*
		*/ border xsca(`xscale') t2(`"`t2'"') t1(`"`t1'"') /*
		*/ b2(`"`b2title'"') yline(`yline') `options'
end
