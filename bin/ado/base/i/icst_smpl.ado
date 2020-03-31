*! version 1.0.2  08feb2017
program define icst_smpl 

	version 15

	args touse ltime rtime if in wgt rest

	mark `touse' `if' `in' `wgt'

	local 0 `rest' 

	syntax [, CLuster(varlist)  ///
		STrata(varname numeric fv) OFFset(varname) SHared(varname) * ]

	markout `touse' `cluster' `strata' `offset' `shared', strok
	qui replace `touse' = 0 if `ltime' < 0
	qui replace `touse' = 0 if `rtime' < 0
	qui replace `touse' = 0 if `ltime' >=. & `rtime' >= .
	qui replace `touse' = 0 if `ltime' ==0 & `rtime' >= .
	qui replace `touse' = 0 if `ltime' <. & `rtime' <. & `ltime' > `rtime'

end

