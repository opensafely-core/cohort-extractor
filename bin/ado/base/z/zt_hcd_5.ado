program define zt_hcd_5
	version 5.0

	di in gr "No. of subjects = " in ye %12.0g $S_E_subj /* 
	*/ in gr _col(51) "Log likelihood =  " in ye %10.0g $S_E_ll

	local l = 52-length("$S_E_mdf")
	di in gr "No. of failures = " in ye %12.0g $S_E_fail /*
	*/ in gr _col(`l') "chi2($S_E_mdf)" _col(66) "= " /* 
	*/ in ye %11.2f $S_E_chi2

	di in gr "Time at risk    = " in ye %12.0g $S_E_risk /* 
	*/ in gr _col(51) "Prob > chi2    = " /* 
	*/ in ye %11.4f chiprob($S_E_mdf, $S_E_chi2)
end
exit
/*
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
No. of subjects = 123456789012                    Log likelihood = 12345678911
No. of failures =           23                    chi2(1)        =        2.85
Time at risk    =        15737                    Prob > chi2    =      0.0916
*/
