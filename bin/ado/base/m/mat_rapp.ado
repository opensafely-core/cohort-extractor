*! version 1.0.1  16jan2002
program define mat_rapp
	version 8

	syntax anything [, miss(passthru) cons ts]

	local b12   : word 1 of `anything'
	local colon : word 2 of `anything'
	local b1    : word 3 of `anything'
	local b2    : word 4 of `anything'

	if `"`colon'"' != ":" {
		di as err `"colon expected, `colon' found"'
		exit 198
	}
	confirm matrix `b1'
	confirm matrix `b2'

	tempname tb12 tb1 tb2

	matrix `tb1' = `b1''
	matrix `tb2' = `b2''
	mat_capp `tb12' : `tb1' `tb2' , `miss' `cons' `ts'

	matrix `b12' = `tb12''
end
exit
