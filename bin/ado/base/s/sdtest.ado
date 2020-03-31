*! version 3.0.9  20dec2004
program define sdtest, rclass byable(recall)
	version 6.0, missing

	/* turn "==" into "=" if needed before calling -syntax- */
	gettoken vn rest : 0, parse(" =")
	gettoken eq rest : rest, parse(" =")
	if "`eq'" == "==" {
		local 0 `vn' = `rest'
	}

	syntax varname [=/exp] [if] [in] [, /*
		*/  BY(varname) Level(cilevel) ]

	tempvar touse
	mark `touse' `if' `in'

	if `"`exp'"'!="" {
		if `"`by'"'!="" {
			di in red "may not combine = and by()"
			exit 198
		}

		capture confirm number `exp'
		if _rc == 0 { /* Do chi-squared test. */
			_ttest one sdtesti `level' `touse' `varlist' `exp'
			ret add
			exit
		}

		/* If here, do variance ratio test with 2 variables. */

		_ttest two sdtesti `level' `touse' `varlist' `exp'
		ret add
		exit
	}

	/* If here, do variance ratio test with by() variable. */

        if `"`by'"'=="" {
                di in red "by() option required"
                exit 100
        }

/*
        confirm variable `by'
        local nbyvars : word count `by'
        if `nbyvars' > 1 {
                di in red "only one variable allowed in by()"
                exit 103
        }
*/

	_ttest by sdtesti `level' `touse' `varlist' `by'
	ret add
end
