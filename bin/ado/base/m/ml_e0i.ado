*! version 3.1.0  23aug2019
program define ml_e0i
	if "`1'"=="init" {
		if "$ML_00_S" == "" {
			mat ML_d0_S = J(1,$ML_k,1)
		}
		else {
			mat ML_d0_S = $ML_00_S
			if colsof(ML_d0_S) != $ML_k {
				di as err ///
				"invalid number of columns in matrix $ML_00_S"
				exit 503
			}
			if rowsof(ML_d0_S) != 1 {
				di as err "too many rows in matrix $ML_00_S"
				exit 503
			}
		}
	}
	else if "`1'"=="close" { 
		capture mat drop ML_d0_S
	}
end
exit
/*
	ML_lf globals:

	matrix ML_d0_S		1 x $ML_k vector of scales

	ML_d0_S is a *REAL* name, not a tempname, would require
	going all the way back to ml.ado ==> ml_model.ado s.t. the
	tempname is in-place for all ml.... programs.
*/
