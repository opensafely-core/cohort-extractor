*! version 3.1.9  17nov2017
program define xtile, sort
	version 6.0, missing
        
					/* parse weights if any */
	_parsewt "aweight fweight pweight" `0' 
	local 0  "`s(newcmd)'" /* command minus weight statement */
	local wt "`s(weight)'"  /* contains [weight=exp] or nothing */

	syntax newvarname =/exp [if] [in] [, /*
	*/ Nquantiles(string) Cutpoints(varname numeric) ALTdef ]
	
/* Mark. */
        
	tempvar touse x

	mark `touse' `wt' `if' `in'


	if `"`wt'"'!="" & "`altdef'"!="" {
		di in red "altdef option cannot be used with weights"
		exit 198
	}
	if "`nquanti'"!="" {
		if "`cutpoin'"!="" {
			di in red "both nquantiles() and cutpoints() " /*
			*/ "cannot be specified"
			exit 198
		}
		if `nquanti' < 2 {
			di in red "nquantiles() must be greater than or " /*
			*/ "equal to 2"
			exit 198
		}
		
		qui count if `touse'
		if `nquanti' > r(N) + 1 {
			di in red "nquantiles() must be less than or " /*
			*/ "equal to number of observations plus one"
			exit 198
		}
	}
	else if "`cutpoin'"=="" {
		local nquanti 2
	}

/* Set up variable to give quantiles. */
        
	qui gen double `x' = `exp' if `touse'

	drop `touse'
	qui count if `x'<.
	if r(N) == 0 { error 2000 }

/* Call routines to do work. */

	if "`cutpoin'"=="" { /* use quantiles of `x' */
		MakeQuan "`wt'" `x' `varlist' `nquanti' `altdef'
		label var `varlist' "`nquanti' quantiles of `exp'"
	}
	else { /* use cutpoints to form categories */
		MakeCut `x' `varlist' `cutpoin'
		label var `varlist' "`exp' categorized by `cutpoin'"
	}
end

program define MakeCut
	args x newvar cutvar

	tempvar m q p

	quietly {
		count if `cutvar'<.
		if r(N) == 0 {
			di in red "cutpoints() all missing"
			exit 2000
		}
		local ncut = r(N)
		sort `x'
		gen `c(obs_t)' `m' = _n
		sort `cutvar'
		gen double `q' = `cutvar'[`m']
		sort `m'
		drop `m'

	/* Number cutpoints omitting duplicates and those < `x'[1]. */ 

        	gen `c(obs_t)' `p' = _n if `q'!=`q'[_n-1] & `q'>=`x'[1] & `q'<.
		
		count if `p' <.
		if r(N) < `ncut' {
			if r(N) == 0 {  
				gen byte `m' = . in 1
					/* for automatic promotion later */
				replace `m' = `ncut' + 1 if `x'<. 
				rename `m' `newvar'
				exit
			}
        		Moveup `p' `q' if `p'<. /* purge nonunique values
				                    without disturbing sort
						    order
						 */
		}
        	
	/* Data `x'[_n] is in the category given by 
	   `q'[`m'[_n-1]] < `x'[_n] <= `q'[`m'[_n]].
	*/
		gen byte `m' = 1 in 1
		replace `m' = cond(`x'<=`q'[`m'[_n-1]], `m'[_n-1], /*
		*/	`m'[_n-1] + cond(`x'<=`q'[`m'[_n-1]+1], 1,   /*
		*/	cond(`x'<=`q'[`m'[_n-1]+2],2,3))) if _n>1 & `x'<.
		
		local i  1
		local rc 1
		while `rc' & `i' <= `ncut' {
			capture assert `x' <= `q'[`m']
						/* `q'[`m'] may be missing */
			local rc = _rc
			if _rc {
				replace `m' = `m' + cond(`x'<=`q'[`m'+1],1, /*
				*/	cond(`x'<=`q'[`m'+2],2,      /*
				*/	cond(`x'<=`q'[`m'+3],3,      /*
				*/	cond(`x'<=`q'[`m'+4],4,5)))) /*
				*/	if `x' > `q'[`m']
			}
			local i = `i' + 1
		}

		replace `m' = cond(`x'<.,cond(`p'[`m']<.,`p'[`m'],`ncut'+1),.)
		rename `m' `newvar'
	}
end

program define MakeQuan /* make categories based on quantiles */
	args wt x newvar nq altdef

	tempvar q p m

	quietly {
		sort `x'
		pctile double `q' = `x' `wt', n(`nq') `altdef'
        
	/* Number quantiles omitting nonunique quantiles. */

		gen `c(obs_t)' `p' = _n if `q'!=`q'[_n-1] & `q'<.
		
		count if `p' <.
		if r(N) < `nq' - 1 { /* purge nonunique values
				              without disturbing sort order */  
			Moveup `p' `q' if `p'<.
		}
        	
	/* Data `x'[_n] is in the quantile given by 
	   `q'[`m'[_n-1]] < `x'[_n] <= `q'[`m'[_n]].
	*/

		gen byte `m' = .
		forvalues i = 1/`r(N)' {
			if `i'==1 {
				replace `m' = `p'[`i'] if `x'<=`q'[`i'] /*
				*/ & `x' <.
			}
			else {
				replace `m' = `p'[`i'] if `x'> /*
				*/ `q'[`i'-1] & `x' <= `q'[`i'] & `x'<.
			}
		}
		replace `m' = `nq' if `x' > `q'[`r(N)'] & `x'<.
		rename `m' `newvar'
	}
end

program define Moveup
	syntax [varlist] [if] [in]
	tokenize `varlist'
	tempvar doit m mm
	mark `doit' `if' `in'
	quietly {
		gen `c(obs_t)' `mm' = cond(`doit'[_N],_N,.) in 1
		replace  `mm' = cond(`doit'[_N-_n+1],_N-_n+1,`mm'[_n-1]) in 2/l
		gen `c(obs_t)' `m' = `mm'[_N] in 1
		replace  `m' = `mm'[_N-`m'[_n-1]] in 2/l
		local i 1
		while "``i''" != "" {
			replace ``i'' = ``i''[`m']
			local i = `i' + 1
		}
	}
end

exit

what "Moveup" does:

. l x

             x  
  1.         .  
  2.         2  
  3.         .  
  4.         6  
  5.         7  

. moveup x if x<.

. l x

             x  
  1.         2  
  2.         6  
  3.         7  
  4.         .  
  5.         .  

