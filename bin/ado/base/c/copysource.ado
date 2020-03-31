*! version 1.0.0  13jan2005
program copysource
	version 9

	if ("`2'"!="") error 198
	quietly findfile `"`1'"'
	local fn `"`r(fn)'"'
	confirm new file `"`1'"'
	copy `"`fn'"' `"`1'"'
	di as txt `"`fn' copied to current directory"'
end
