*! version 1.1.1  04oct2002
program define varirf_erase
	version 8.0
	syntax anything(id="varirf file" name=filename)
/* anything passes strings asis, local clears quotes
*/
	local filename `filename'
	_virf_fck `"`filename'"'
	erase `"`r(fname)'"'
	di as txt `"`r(fname)' removed"'
end

exit

