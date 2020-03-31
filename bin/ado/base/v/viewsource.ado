*! version 1.0.0  06jan2005
program viewsource
	version 9

	if ("`2'"!="") error 198
	quietly findfile `"`1'"'
	if "$S_CONSOLE"=="console" {
		type `"`r(fn)'"', asis
	}
	else 	view `"`r(fn)'"', asis
end
