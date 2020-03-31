*! version 1.3.3  23nov2016
program define _crcshdr
	version 6.0
	#delimit ;
	di in gr _n "`e(title)'" _col(49) "Number of obs" 
		in gr _col(67) "=" 
		in ye _col(69) %10.0gc e(N) ;
	di in gr "`e(title2)'"
		in gr _col(49) "      Selected" 
		in gr _col(67) "=" 
		in ye _col(69) %10.0gc e(N_selected) ;
	di in gr _col(49) "      Nonselected" 
		in gr _col(67) "=" 
		in ye _col(69) %10.0gc e(N_nonselected) ;
	local chifmt = cond(e(chi2)<1e+6,"%9.2f","%9.2e") ;
	if !missing(e(df_r)) { ;
	 	di in gr _n _col(49) "F(" %4.0f in ye e(df_m) 
		in gr ","
		in ye %7.0f e(df_r)
		in gr ")"
		in gr _col(67) "="
		in ye _col(70) %9.2f e(F) ;
	} ;
	else if "`e(chi2type)'"=="Wald" & missing(e(chi2)) { ;
	        di in smcl _n _col(49)
	        "{help j_robustsingular##|_new:Wald chi2(`e(df_m)'){col 68}= }"
	          in ye _col(70) `chifmt' e(chi2) ;
	} ;
	else { ;
	 	di in gr _n _col(49) "`e(chi2type)' chi2(" in ye e(df_m) 
		in gr ")"
		in gr _col(67) "="
		in ye _col(70) `chifmt' e(chi2) ;
	} ;

	if "`e(ll)'" != "" { ;
		local crtype = upper(bsubstr(`"`e(crittype)'"',1,1)) + /*
		*/ bsubstr(`"`e(crittype)'"',2,.) ;
		if !missing(e(df_r)) { ;
			di in gr "`crtype' = " in ye %9.0g e(ll)
				in gr _col(49) "Prob > F"
				in gr _col(67) "=" 
				in ye _col(73) %6.4f
				Ftail(e(df_m),e(df_r),e(F))
				_n ;
		} ;
		else { ;
			di in gr "`crtype' = " in ye %9.0g e(ll)
				in gr _col(49) "Prob > chi2"
				in gr _col(67) "=" 
				in ye _col(73) %6.4f chiprob(e(df_m),e(chi2))
				_n ;
		} ;
		exit ;
	} ;
	if !missing(e(df_r)) { ;
		di in gr _col(49) "Prob > F"
			in gr _col(67) "=" 
			in ye _col(73) %6.4f
			Ftail(e(df_m),e(df_r),e(F))
			_n ;
	} ;
	else { ;
		di in gr _col(49) "Prob > chi2"
			in gr _col(67) "=" 
			in ye _col(73) %6.4f chiprob(e(df_m),e(chi2)) _n ;
	} ;
	#delimit cr

end
exit
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
Heckman selection model                         Number of obs      = 
                                                       Selected    = 
                                                       Nonselected =      

                                                Wald chi2(2)       =      0.61
Log likelihood = -66.372364                     Prob > chi2        =    0.7382

----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
Heckman selection model                         Number of obs      = 
                                                       Selected    = 
                                                       Nonselected =      

                                                Wald chi2(2)       =      0.61
Log pseudo likelihood = -66.372364              Prob > chi2        =    0.7382



