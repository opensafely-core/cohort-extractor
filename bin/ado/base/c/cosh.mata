*! version 2.0.0  10oct2008
version 11.0
mata:

/*
	cosh() is built-in as of Stata 11.
	The library function below is included so that programs
	compiled by releases prior to 11 do not need to be recompiled.
*/

numeric matrix (doppelganger) cosh(numeric matrix u) return(cosh(u))

end
