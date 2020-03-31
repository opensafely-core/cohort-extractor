*! version 1.0.0  25feb2004
program _small2dotz
	version 8
	args X tol junk

	confirm matrix `X'
	confirm number `tol'
	if `"`junk'"' != "" {
		di as error `"`junk' not allowed"'
		exit 198
	}

	forvalues i = 1 / `=rowsof(`X')' {
		forvalues j = 1 / `=colsof(`X')' {
			if abs(`X'[`i',`j']) < abs(`tol') {
				matrix `X'[`i',`j'] = .z
			}
		}
	}
end
exit

_small2dotz X tol

  Replaces elements of the matrix X smaller than abs(tol) to .z

  matrix list and matlist have an option nodotz that displays
  matrix elements .z as blanks.
