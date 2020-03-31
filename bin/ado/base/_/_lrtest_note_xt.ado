*! version 1.0.0  02feb2015
program define _lrtest_note_xt, sclass
	version 14

	syntax , msg(string)

	tempname pval
	scalar `pval' =  chiprob(1, e(chi2_c))*0.5
	if e(chi2_c)==0 scalar `pval'= 1
	if ((e(chi2_c) > 0.005) & (e(chi2_c)<1e4)) | (e(chi2_c)==0) {
		local fmt "%8.2f"
	}
	else    local fmt "%8.2e"

	local chi : di `fmt' e(chi2_c)
	local chi = trim("`chi'")

	di "{txt}`msg': " _c
	di "{help j_chibar##|_new:chibar2(01) = }{res}`chi'" _c ///
		_col(56) "{txt}Prob >= chibar2 = {res}" %5.3f `pval' _n
end
exit

