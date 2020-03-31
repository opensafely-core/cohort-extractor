*! version 6.1.0  10sep2019
program define symmetry, rclass
	version 6, missing
	syntax varlist(min=2 max=2) [if] [in] [fweight] /*
                                   */ [, CONtrib EXact MH noTable TRend cc]
	marksample touse, strok

qui {
	count if `touse'
	if `r(N)'==0 {
		di in red "no observations"
		exit 2000
	}
	tokenize "`varlist'"
	if "`trend'"!="" {
		cap confirm string var `1'
        	if _rc==0 {
			di in red "trend not allowed with string variable `1'"
			exit 198	
		}
		cap confirm string var `2'
        	if _rc==0 {
			di in red "trend not allowed with string variable `2'"
			exit 198	
		}
	}

	if "`cc'"!="" & "`trend'"=="" {
		di in red "cc option allowed only with trend option"
			exit 198	
	}
		
	tempvar cnt
	if "`weight'" != "" { 
		gen double `cnt' `exp'
		compress `cnt'
	}
	else	gen byte `cnt' = 1

	preserve
	keep if `touse'
	stack `1' `2' , into(`2') clear
	keep `2' 
	sort `2'
	qui by `2': keep if _n==1 
	tempfile tt
	save `"`tt'"'
	rename `2' `1'
	Mcross `"`tt'"'
	sort `1' `2'
	save `"`tt'"', replace

	restore, pres
	keep if `touse'
	keep `1' `2' `cnt'

	sort `1' `2'
	merge `1' `2' using `"`tt'"'
	drop _merge
	replace `cnt'=0 if `cnt'>=.
	/* ROUTINE FOR DISPLAYING CROSS TABULATION" */
	if "`table'"== ""  {
		noi table `1' `2',c(sum `cnt') row col center f(%5.0f)
	}

	/*
	The rest of this code uses a strange mix of temporary 
	and permanent variables.  The only user variables we are 
	using are `1' and `2'.  To prevent collision, we will rename 
	the original variables to temporary names 
	*/

	tempvar user1 user2
	rename `1' `user1'
	rename `2' `user2'

	tempvar scnt
	sort `user1' `user2'     
	by `user1' `user2': gen `scnt' = sum(`cnt')
	by `user1' `user2': keep if _n == _N

	/*END OF CROSS TABULATION ROUTINE*/ 

	/* SET UP TABLE*/
	tempvar gro gco
	sort `user1'
	by `user1': gen int `gro' = 1 if _n==1
	replace `gro' = sum(`gro')
	sort `user2'
	by `user2': gen int `gco' = 1 if _n==1
	replace `gco' = sum(`gco')
	sum `gro', meanonly
	local r=r(max)

	rename `gro' i
	rename `gco' j
	rename `scnt' cv

	sort i j
	*keep i j cv
	gen double ncv = cv[_n+(`r'-1)*(j-i)]


	if "`trend'"!="" {
		if "`cc'"!="" {
			MTrend `user1' `user2' ccor
		}
		else 	MTrend `user1' `user2'
		local ptrend=chiprob(1, r(trend))
		local trend=r(trend)
	}
	keep i j cv ncv
	/* END SET UP TABLE */

	/* ROUTINE FOR MARGINAL HOMOGENEITY*/
	sort i
	gen diag=cv if i==j
	by i: gen mr=sum(cv)
	by i: replace mr=mr[_N]
	gen mmr=mr-diag

	sort j
	by j: gen mc=sum(cv)
	by j: replace mc=mc[_N]
	gen mmc=mc-diag
        gen  nd=mc-mr

	sort i j
	tempname d
        mkmat nd if i==j,mat(`d')
	drop nd
	drop diag 
	if "`mh'"=="mh" {
		gen double m =  ((mr-mc)^2)/(mr+mc)      if i==j
		gen double mm = ((mmr-mmc)^2)/(mmr+mmc)  if i==j
		sum m, meanonly
	        local k = r(N)   	
		local m = r(sum)
		local df2 = `k'-1
		gen tdf = 1 if i==j
		replace tdf =. if mmr==0 & mmc==0
		count if tdf==1
		drop tdf
	        local df3 = r(N)-1	
		sum mm, meanonly
		local mm = r(sum)
		local p2 = chiprob(`df2',`m')
		local p3 = chiprob(`df3',(`k'-1)*`mm'/`k')
	}

	/* ROUTINE FOR STUART-MAXWELL MARGINAL HOMOGENEITY*/
	tempname V Vi U  X
	gen vii = mmr+mmc
	drop mmr mmc
        replace vii = -1*(cv+ncv) if i~=j
       	matrix `V' = J(`r',`r',0)
	sort i j
        local i 1
	local ob 1	
	while `i'<=`r' {
		local j 1
		while `j'<=`r' {
			mat `V'[`i',`j']= vii[`ob']
			local ob=`ob'+1
			local j=`j'+1
		}
	   local i=`i'+1
	}
        mat `Vi'=syminv(`V')
        mat `U'=`d''*`Vi'
        mat `X'=`U'*`d'
        local  bmd=`X'[1,1]
	local df1=`r'-1
	local p4=chiprob(`df1',`bmd')
	/* ROUTINE FOR SYMMETRY TEST */
	gen double sym = ((cv-ncv)^2)/(-1*vii) if i<j  
	drop vii
	replace sym=0 if sym>=. & i<j         
	sort i j
	if "`contrib'"=="contrib" {
		local i  1
		local ob 1
		noi di
		noi di in green "                  Contribution" 
		noi di in green "                   to symmetry" 
		noi di in green "   Cells           chi-squared" 

		noi di in smcl in green "{hline 14}  {hline 14}" 
		while `ob'<=_N {
			if sym[`ob']<. {
				noi di  " n" i[`ob'] "_" j[`ob'] " & n" /*
				*/ j[`ob'] "_" i[`ob'] "       " %9.4f sym[`ob']
			}	
			local ob=`ob'+1
		}
	}
	gen d=0 if i<j
	replace d=1 if cv==0 & ncv==0 & d==0
	gen long nd=sum(d)
	sum sym, meanonly
	local x2 = r(sum)
	local df = (`r'*(`r'-1)/2)-nd[_N]
	local p = chiprob(`df',`x2')
	drop d nd
	/* END SYMMETRY TEST */

	sum cv, meanonly 
	local totpair = r(sum) 

	/* EXACT TEST ALGORITHM nxn tables */
	gen pval=.
	if "`exact'"!="" {
		keep if i<j
		keep i j  cv ncv  
		rename cv v1
		rename ncv v2
		*order i j v1 v2
		sort i j
		gen den= v1+v2
		 /* OBSERVED TABLE'S  probability */
		tempname obsval
		gen double  oval=comb(den,v1)*(0.5)^den
		gen double obval=oval
		replace obval=oval*obval[_n-1] if _n>1
		scalar  `obsval'=obval[_N]
		drop obval oval
		gen double pval = .        /* if obsval>=. */
		if `obsval'<. {
			gen long nv1=den
			gen long nv2=0
			gen u = (den - (mod(den,2)~=0)) / 2 
			gen negu= -u
			sort negu i j 
			drop negu
			local i 1
			while `i'<=_N {
				local den`i'=den[`i']
				local u`i'=u[`i'] /* upper bound per variable */
				local i=`i'+1
			}
			local r=_N  /* variables go from 1 to r=# of columns */
			drop _all   /* First Observation */
			set obs 1   /* set to zero vector */
			local i 1
			while `i'<=`r'{
				gen v`i'= 0
				local i = `i'+1
			}
			expand `u1' + 1
			replace v1 = _n - 1
			local i 2
			local myval "v1"
			gen double  nnp = 1
			while `i' <= `r' {
				expand `u`i'' + 1
				local myval "`myval' v`i'"
				sort `myval'
				by `myval': replace v`i'=_n-1
				replace  nnp=1
				local j 1
				while `j'<=`r' {
					replace nnp= nnp /*
					*/ * comb(`den`j'',v`j')*(0.5)^`den`j''
					local j=`j'+1
				}
				drop  if nnp>`obsval'
				local i=`i'+1
			}
			drop nnp
                	local i 1
                	gen double np=1
                	gen eq=0
                	while `i'<=`r' {
                	        replace np=np*comb(`den`i'',v`i')*(0.5)^`den`i''
                	        replace eq=eq+1 if `den`i'' - v`i' == v`i'
                	        local i=`i'+1
                	}
			keep  if np< = `obsval'
			replace np=np*2^(`r'-eq)
			gen double pval=sum(np)
		}
	} /*end of exact for nxn */	

	noi di
	noi di in green _col(8) /*
	*/ "                                      chi2     df      Prob>chi2" 
	noi di in smcl in gr "{hline 38}{c TT}{hline 33}"
	noi di in smcl in gr "Symmetry (asymptotic)                 {c |} " /*
		*/ in ye %9.2f `x2' _col(56)  `df'  _col(66) %5.4f `p' 
	noi di in smcl in gr "Marginal homogeneity (Stuart-Maxwell) {c |} " /*
                */ in ye %9.2f `bmd' /*
                */ _col(56)  `df1' _col(66) %5.4f `p4'

	if "`mh'"!="" {
		noi di in smcl in gr /*
			*/ "Marginal homogeneity (Bickenboller)   {c |} " /*
			*/ in ye %9.2f `m'  /*
			*/ _col(56)  `df2' _col(66) %5.4f `p2' 
		noi di in smcl in gr /*
			*/ "Marginal homogeneity (no diagonals)   {c |} " /*
			*/ in ye %9.2f (`k'-1)*`mm'/`k' /*
			*/ _col(56)  `df3' _col(66) %5.4f `p3' 

		ret scalar p_nd =	`p3'
		ret scalar df_nd = 	`df3'
		ret scalar chi2_nd = 	(`k'-1)*`mm'/`k'
		ret scalar p_b = 	`p2'
		ret scalar df_b =  	`df2'
		ret scalar chi2_b =	`m'
	}
	if "`trend'" == "" { noi di in smcl in gr "{hline 38}{c BT}{hline 33}" }
	else {
		noi di in smcl in gr "{hline 38}{c +}{hline 33}" 
		noi di in smcl in gr /*
			*/ "Linear trend in the (log) RR          {c |} " /*
			*/ in ye %9.2f `trend'  /*
			*/ _col(56)  "1" _col(66) %5.4f `ptrend' 
		noi di in smcl in gr "{hline 38}{c BT}{hline 33}" 
		ret scalar  chi2_t= `trend'
		ret scalar  p_trend= `ptrend'
        }

	if "`exact'"!="" {
		noi di in gr "Symmetry (exact significance probability) " /*
			*/ in ye _col(66) %5.4f  pval[_N]
		if pval[_N]>=. {
       	 	     noi di in gr  "(Too many observations for exact test," /*
			*/ " asymptotic result should hold)"
        	}
		ret scalar p_exact=	pval[_N]
	}

	ret scalar p_sm =	`p4'
	ret scalar df_sm =	`df1'
	ret scalar chi2_sm =	`bmd'
	ret scalar p =		`p'
	ret scalar df = 	`df'
	ret scalar chi2 =	`x2'
	ret scalar N_pair =	`totpair'
}
end

program define Mcross          /* using `tt' */
	args using
        local nob = _N
        tempfile cross2
        tempvar order midx
        preserve
        quietly use `"`using'"', clear
        quietly {
                gen `c(obs_t)' `order'=_n
                expand `nob', clear
                sort `order'
                by `order': gen `c(obs_t)' `midx' = _n
                sort `midx' `order'
                drop `order'
                save `"`cross2'"', replace
                restore, preserve
                gen `c(obs_t)' `midx' = _n
                sort `midx'
                merge `midx' using "`cross2'"
                drop `midx' _merge
                restore, not
        }
end

program define MTrend, rclass         /* r(trend)*/
	args case control ccor
	if "`ccor'"!="" {
		local cc=0.5
	}
	else local cc 0	
	tempvar diff dexp N num snum den sden 
	qui gen long `diff' = cv-ncv if i<j
	qui gen `dexp' = `case' - `control' if i<j
	qui gen `N'    = cv+ncv if i<j
	qui gen double `num'  =`diff'*`dexp'
	qui gen double `snum'=sum(`num')
	qui replace `num'=(`snum'[_N] - `cc')^2
	qui gen double `den'=`N'*(`dexp'^2)
	qui gen double `sden'=sum(`den')
	ret scalar trend =`num'/`sden'[_N]
end
exit

