*! version 2.4.2  16feb2015
program define kwallis, rclass sort
	version 6, miss
	syntax varname [if] [in], BY(varname)
	marksample Touse
	markout `Touse' `by', strok
	qui count if `Touse'
	if r(N)==0 {
		error 2000
	}
	qui tab `by' if `Touse'
	cap assert r(r)>1 
	if _rc {
		di as err "at least two populations are required"
		exit 498
	}
	confirm new var _RankSum _Obs 
	tempvar RankSum Obs Grp Ties
	quietly {
		*replace `Touse' = . if `Touse'==0
		genrank `RankSum' = `varlist' if `Touse'==1
		gen long `Obs'=1 if `RankSum'<.
		format %12.0fc `Obs'
		sort `by'
		by `by': replace `RankSum'=cond(_n==_N,sum(`RankSum'),.)
		by `by': replace `Obs'=cond(_n==_N,sum(`Obs'),.)
		by `by': gen `c(obs_t)' `Grp'=1 if _n==_N & `Obs'>0 & `Obs'<.
		sort `Touse' `varlist'
 		by `Touse' `varlist': gen `c(obs_t)' `Ties' = _N  
		replace `Ties'=0 if `Ties'==1 
		noisily di _n in gr /*
		*/ "Kruskal-Wallis equality-of-populations rank test"
		format `RankSum' %9.2f

		char `RankSum'[varname] "Rank Sum"
		char `Obs'[varname] "Obs"
		sort `by'
		noisily l `by' `Obs' `RankSum' if `Obs'<. & `Obs'~=0, /*
				*/ noobs subvar div
		replace `RankSum'=sum(`RankSum'*`RankSum'/`Obs')
		replace `Obs'=sum(`Obs')
		local K=12/(`Obs'*(`Obs'+1))*`RankSum'-3*(`Obs'+1) in l
		replace `Obs'=`Obs'[_N]
		sort `Touse' `varlist'
		tempvar T
		tempname adj Kties
		gen double `T'=0 if `Touse'
		by `Touse' `varlist': replace `T'=`Ties'^3 - `Ties' /*
		*/ if _n==1 & `Touse'
		replace `T' = sum(`T')
		scalar `adj'= 1 - (`T'[_N] /(`Obs'^3 - `Obs')) in l
		scalar `Kties'=`K'/`adj' 
		sort `by'
		replace `Grp'=sum(`Grp')
		drop `T'
	}
	/* double save in S_# and r() */
	ret scalar chi2 = `K'
	ret scalar df = `Grp'[_N]-1
	ret scalar chi2_adj = `Kties'
	global S_1 `K'
	global S_2 = `Grp'[_N]-1
	#delimit ;
		di _new in gr "chi-squared = " in ye %9.3f `K'
		in gr " with " in ye `Grp'[_N]-1 in gr " d.f." _n
		"probability = " in ye
		%10.4f max(chiprob(`Grp'[_N]-1,`K'+(1e-20)),.0001);
		di _new in gr "chi-squared with ties = " in ye %9.3f `Kties'
 		in gr " with " in ye  `Grp'[_N]-1 in gr " d.f." _n
		"probability = " in ye
		%10.4f max(chiprob(`Grp'[_N]-1,`Kties'+(1e-20)),.0001)  ;
	#delimit cr
end
