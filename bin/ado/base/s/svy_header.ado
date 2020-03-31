*! version 1.0.4  01apr2005
program define svy_header /* display svy header */
	version 8
	syntax [, title(string) noFtest dash subexp(string) ]

	if `"`ftest'"' == "" {
		local col1 _col(51)
		local col2 _col(68)
	}
	else {
		local col1 _col(49)
		local col2 _col(68)
	}
	local wgt    "`e(wtype)'"
	local exp `"`e(wexp)'"'
	local exp : subinstr local exp "= "  ""
	local strata "`e(strata)'"
	local psu    "`e(psu)'"
	if "`wgt'"    == "" {
		local wgt    "pweight"
	}
	if `"`exp'"'  == "" {
		local exp    "<none>"
	}
	if "`strata'" == "" {
		local strata "<one>"
	}
	if "`psu'"    == "" {
		local psu    "<observations>"
	}

/* Title. */

	if `"`title'"' != "" {
		di _n as txt `"`title'"'
	}
	if "`dash'" != "" {
		di  in smcl _n as txt "{hline 78}"
	}
	else di /* newline */

/* Print lines 1-4 (see notes at end of file). */

	#delimit ;
	di as txt `"`wgt':  `exp'"'
	   as txt `col1' "Number of obs" `col2' "= "
	   as res %9.0f e(N) _n
	   as txt "Strata:   `strata'"
	   as txt `col1' "Number of strata" `col2' "= "
	   as res %9.0f e(N_strata) _n
	   as txt "PSU:      `psu'"
	   as txt `col1' "Number of PSUs" `col2' "= "
	   as res %9.0f e(N_psu) ;

	if "`e(fpc)'"!="" { ;
		di as txt "FPC:      `e(fpc)'"
		   as txt `col1' "Population size" `col2' "="
		   as res %10.0g e(N_pop) ;
	} ;
	else	di as txt `col1' "Population size" `col2' "="
		   as res %10.0g e(N_pop) ;

	if "`ftest'" != "" { ;
		if "`e(N_sub)'" != "" & "`e(N_sub)'" != "." { ;
			if `: length local subexp' > 20 { ;
				local subexp : piece 1 16 of `"`subexp'"' ;
				local subexp `"`subexp' ..."' ;
			} ;
			di as txt "Subpop.:" _col(11) "`subexp'"
			   as txt `col1' "Subpop. no. of obs" `col2' "="
			   as res %10.0f e(N_sub) _n
			   as txt `col1' "Subpop. size" `col2' "="
			   as res %10.0g e(N_subpop) ;
		} ;
		if "`dash'" != "" { ;
			di in smcl as txt "{hline 78}" ;
		} ;
		exit ;
	} ;

/* Set denominator df for F statistic and other stuff for F display. */

	#delimit cr
	if "`e(adjust)'"=="" { /* adjusted (default) */
		local df = e(df_r) - e(df_m) + 1
	}
	else 	local df = e(df_r)

/* Set up display for subpop() option obs and size. */

	if "`e(N_sub)'" != "" & "`e(N_sub)'" != "." {
		if "`e(fpc)'"=="" & "`e(r2)'"=="" { /* print up one line */
			local left5a "Subpopulation no. of obs = "
			local left5b : di %9.0f e(N_sub)
			local left6a "Subpopulation size       ="
			local left6b : di %10.0g e(N_subpop)
		}
		else {
			local left6a "Subpopulation no. of obs = "
			local left6b : di %9.0f e(N_sub)
			local left7a "Subpopulation size       ="
			local left7b : di %10.0g e(N_subpop)
		}
	}

/* Set up display for R-squared. */

	if "`e(r2)'"!="" {
		local right7a "R-squared        = "
		local right7b : di %9.4f e(r2)
	}

/* Print lines 5-7 (see notes at end of file). */
	#delimit ;
	if e(F) < . { ;
		di as txt "`left5a'" as res "`left5b'"
	   		as txt `col1' "F(" as res %4.0f e(df_m) as txt ","
	   		as res %7.0f `df' as txt ")" `col2' "= "
	   		as res %9.2f e(F) _n
	   		as txt "`left6a'" as res "`left6b'"
	   		as txt `col1' "Prob > F" `col2' "= "
	   		as res %9.4f fprob(e(df_m),`df',e(F)) ;
	};
	else {;
		/* local dfm_l= e(df_m);*/
		local dfm_l : di %4.0f e(df_m) ;
		local dfm_l2: di %7.0f `df';
		di _asis as txt "`left5a'" as res "`left5b'"
	in smcl `col1' "{help j_robustsingular##|_new:F(`dfm_l',`dfm_l2')}" 
			 _col(67) as text " = " _col(78) as result "." _n
			 _asis as txt "`left6a'" as res "`left6b'"
	   		as txt `col1' "Prob > F" `col2' "= "
	   		as res %9.4f fprob(e(df_m),`df',e(F)) ;

	};
	if "`left7a'`right7a'"!="" { ;
		di as txt "`left7a'" as res "`left7b'"
		   as txt `col1' "`right7a'" as res "`right7b'" ;
	} ;
	#delimit cr

	if "`dash'" != "" {
		di in smcl as txt "{hline 78}"
	}
	else	di
end
exit

There are 4 possible arrangements for the header after a regression:

------------------------------------------------------------------------------
pweight:  weight                                  Number of obs    =        21
Strata:   strata                                  Number of strata =         4
PSU:      psu                                     Number of PSUs   =        14
FPC:      Nh                                      Population size  =       189
                                                  F(   2,      9)  =      3.43
Subpopulation no. of obs =         8              Prob > F         =    0.0780
Subpopulation size       =        82              R-squared        =    0.4129
------------------------------------------------------------------------------
pweight:  weight                                  Number of obs    =        21
Strata:   strata                                  Number of strata =         4
PSU:      psu                                     Number of PSUs   =        14
                                                  Population size  =       189
                                                  F(   2,      9)  =      3.11
Subpopulation no. of obs =         8              Prob > F         =    0.0937
Subpopulation size       =        82              R-squared        =    0.4129
------------------------------------------------------------------------------
pweight:  weight                                  Number of obs    =        21
Strata:   strata                                  Number of strata =         4
PSU:      psu                                     Number of PSUs   =        14
FPC:      Nh                                      Population size  =       189
                                                  F(   2,      9)  =      3.43
Subpopulation no. of obs =         8              Prob > F         =    0.0780
Subpopulation size       =        82
------------------------------------------------------------------------------
pweight:  weight                                  Number of obs    =        21
Strata:   strata                                  Number of strata =         4
PSU:      psu                                     Number of PSUs   =        14
                                                  Population size  =       189
Subpopulation no. of obs =         8              F(   2,      9)  =      3.11
Subpopulation size       =        82              Prob > F         =    0.0937
------------------------------------------------------------------------------

The following results from the -noftest- option:

------------------------------------------------------------------------------
pweight:  headroom                              Number of obs      =        69
Strata:   <one>                                 Number of strata   =         1
PSU:      rep78                                 Number of PSUs     =         5
                                                Population size    =       207
Subpop.:  sub==1                                Subpop. no. of obs =        59
                                                Subpop. size       =     176.5
------------------------------------------------------------------------------

<end of file>
