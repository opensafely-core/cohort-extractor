*! version 1.0.2  07feb2012
program twoway__patch_serset, sortpreserve

	// Creates a serset for a contour view.  Runs from an immediate log.

	syntax , sersetname(string) touse(string)			///
		 x(string) y(string) z(string) 				///
		 [ cuts(numlist) weight(string) ]

	tempvar levvar
	local lev = 1
	gen long `levvar' = `lev'  if `touse'
	foreach cut of local cuts {
		replace `levvar' = `++lev' if `z' > `cut' & `touse'
	}

	// Create some things we can pretend are contour lines.  We create
	// just one per level.  This will not be true for contours.

	tempvar order
	gen double `order' = `x' if `touse'
	
	sum `levvar'
	forvalues i = 1/`r(max)' {
		sum `y' if `touse' & `levvar' == `i'
		replace `order' = -`x' if `touse' & `levvar' == `i' &	///
					  `x' < r(mean)
	}

					// Create the serset and pretty it up

	sort `levvar' `order'

	if ("`byreference'" != "")  local ref ".ref"

	.`sersetname'`ref' = .serset.new `z' `y' `x' `levvar' if `touse',  ///
		`.omitmethod' nocount

	.`sersetname'.sers[4].name = "levels"

end


exit
