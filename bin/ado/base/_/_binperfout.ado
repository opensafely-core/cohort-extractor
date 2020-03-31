*! version 1.1.1  01mar2009  (minor change 03jan2017)

/*	
	Displays rules applied by _binperfect
	
	Matrix of results is returned in r(rules)
	
	Number of rows in r(rules) = Max(Number of reductions done, 1)
	Rowname of r(rules) = variable affected
	
	There are four columns in r(rules)
	
	Column 1: Operator (e.g. is variable > column 2)
			1	Not equal
			2	Greater than
			3	Less than
			4	Variable omitted because of collinearity
			6	Less than or equal

	Column 2: Number on RHS of operator from column 1
	
	Column 3: Various interpretations
			 0	Negative outcome perfectly predicted
			 1	Positive outcome perfectly predicted
			-1	Keep only observations == column 2
			-2	Variable perfectly segments success
				or failure.  Model inestimable, abort.
			
	Column 4: Number of observations dropped
	
*/

program define _binperfout

	version 8.2

        args rules

	/* See if rules were applied: */
	if `rules'[1,1] == 0 & `rules'[1,2] == 0 & ///
	   `rules'[1,3] == 0 & `rules'[1,4] == 0 {
		exit
	}
        local m = rowsof(`rules')
        local n : rownames(`rules')
        forv i = 1/`m' {
        	local name : word `i' of `n'
        	if `rules'[`i', 1] == 4 {
	        	di as txt "note: " _c		
			di "`name' omitted because of collinearity"
		}
        	else if `rules'[`i', 3] == 0 {
	        	di as txt "note: " _c
			di "`name' != " `rules'[`i', 2] ///
				" predicts failure perfectly"
			di "      `name' dropped and " `rules'[`i', 4] ///
				" obs not used"
		}
        	else if `rules'[`i', 3] == 1 {
	        	di as txt "note: " _c		
			di "`name' != " `rules'[`i', 2] ///
				" predicts success perfectly"
			di "      `name' dropped and " `rules'[`i', 4] ///
				" obs not used"
		}
		else if `rules'[`i', 3] == -1 {
	        	di as txt "note: " _c
	        	if `rules'[`i', 1] == 2 {
				di "outcome `name' > " `rules'[`i', 2] ///
					" predicts data perfectly except for"
				di "      `name' == " `rules'[`i', 2] ///
					" subsample:"
				di "      `name' dropped and " ///
					`rules'[`i', 4] " obs not used"
			}
			else {
				di "outcome `name' < " `rules'[`i', 2] ///
					" predicts data perfectly except for"
				di "      `name' == " `rules'[`i', 2] ///
					" subsample:"
				di "      `name' dropped and " ///
					`rules'[`i',4] " obs not used"
			}
		}
		else if `rules'[`i', 3] == -2 {
			if `rules'[`i', 1] == 2 {
				di as txt ///
				"outcome = `name' > " `rules'[`i', 2] ///
					" predicts data perfectly"
			}
			else {
				di as txt ///
				"outcome = `name' <= " `rules'[`i', 2] ///
                                        " predicts data perfectly"
			}
		}
	}
end
