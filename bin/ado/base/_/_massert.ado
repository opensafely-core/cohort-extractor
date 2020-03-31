*! version 1.0.0  16nov2009

program _massert
	syntax anything(id="matrices"), [ tol(real 1e-8) noSTOP ]

	gettoken m1 m2 : anything, bind

	confirm matrix `m1'
	/* allow m1 to be e()						*/
	tempname mm
	matrix `mm' = `m1'

	confirm matrix `m2'

	tempname diff
	scalar `diff' = mreldif(`mm', `m2')
	cap assert `diff' <= `tol'
	local rc = c(rc)

	if `rc' == 9 {
		di as err "assertion failure: " ///
		 `"mreldif(`m1',`m2') = "' `diff' " >" %7.1g `tol'
	}
	if ("`stop'"=="") exit `rc'
end
exit
