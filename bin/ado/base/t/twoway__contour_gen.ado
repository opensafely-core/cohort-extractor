*! version 1.0.15  20oct2012
program twoway__contour_gen

	// Replaces the dataset with a dataset of contours

	syntax varlist(min=3 max=3 numeric) [if] [in], cuts(numlist) [	///
		gen(namelist min=4 max=4) ] [line] [heatmap] [Interp(string)]

	if (`"`if'`in'"' != `""')					///
		keep `if' `in'				// sic keep missings
	keep `varlist' 

	tempvar z y x
	tokenize `varlist'
	clonevar `z'=`1'		
	clonevar `y'=`2'		
	clonevar `x'=`3'

	tempvar levvar
	tempname cntmat
	tempname ct

	gen long `levvar' = 1
	mata: `ct' = J(1, 0, .)
	foreach cut of local cuts {
		mata: `ct' = (`ct', `cut')
	}
	mata: `ct' = (`ct')'

nobreak {
capture noisily nobreak {

	if (`"`line'"' == `""') {
  		if ( `"`heatmap'"' != `""') { 
mata:			`cntmat' = _contour_heatmap("`z'","`y'", "`x'", `ct', "`interp'")
		}
		else {
mata:			`cntmat' = _contour_filled("`z'","`y'", "`x'", `ct', "`interp'")
  		}
  	}
  	else {
  		if ( `"`heatmap'"' != `""') {
			exit 198 
		}
mata:		`cntmat' = _contour_line("`z'","`y'", "`x'", `ct', "`interp'")
  	}
  	keep if 0
  	getmata (`x' `y' `z' `levvar')=`cntmat', replace force
	keep `z' `y' `x' `levvar'

} // capture noisily nobreak
	local rc = c(rc)

	mata: rmexternal("`cntmat'")
	mata: rmexternal("`ct'")
} // nobreak
	if `rc' exit `rc'

	if ("`gen'" == "") local gen z y x levels
	tokenize `gen'
	rename `z' `1'
	rename `y' `2'
	rename `x' `3'
	rename `levvar' `4'
end

