*! version 1.0.1  21may2015
program streghet_footnote
	version 10
	if "`e(ll_c)'"!="" {
		if ((e(chi2_c) > 0.005) & (e(chi2_c)<1e4)) /*
                            */ | (e(chi2_c)==0) { 
               		local fmt "%8.2f"
		}
		else local fmt "%8.2e"
		
	       	local chi : di `fmt' e(chi2_c)
		local chi = trim("`chi'")
	
		di as txt "LR test of theta=0: " ///
			as txt "{help j_chibar:chibar2(01) = }" ///
			as res "`chi'" ///
			as txt _col(55) " Prob >= chibar2 = " ///
			as res %5.3f e(p_c)
	}
	if "`e(sh_warn)'"=="sh_warn" {
		di as txt "Warning: Observations within subject "_c
		di as txt "belong to different frailty groups."
	}
end
exit
