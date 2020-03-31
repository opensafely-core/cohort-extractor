*! version 1.0.0  03jan2005
program _jk_nlegend
	version 9
	args col1 nfunc
	if `"`nfunc'"' != "" {
		di as txt %`col1's "n()" ":  " as res `"`nfunc'"'
	}
	else {
		di as txt %`col1's "n()" ":  (not specified)" ///
		`"  <-- we strongly recommend that you specify"'
		di as txt _col(`=`col1'+4') "the "	///
		   as res "rclass" as txt ", "		///
		   as res "eclass" as txt ", or "	///
		   as res "n()" as txt " option"
	}
	di
end
exit
