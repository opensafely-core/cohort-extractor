*! version 1.0.5  27mar2017
program _spxtreg_match_id
/*
	o. _spxtreg_match_id will resort the data such that the id in the data
	is consistent with id in the weighting matrix. 

	o. It must be called by a program with sortpreserve property

	o. check if the data is strongly balanced
*/

	version 15.0

	syntax, id(string)		///
		touse(string)		///
		[lag_list(string)	///
		timevar(string)		///
		timevalues(string)]
						// step 1. sort data by time and
						// by id
	sort `timevar' `id'

	if (`"`lag_list'"'=="") {
		exit
	}
						// step 2. get id signature in
						// one time period
	tempvar tmpid
	qui gen double `tmpid' = `id' 
	local time1 : word 1 of `timevalues'
	qui _datasignature `tmpid' if `touse' & `timevar' == `time1', nonames
	local idsig_dta `r(datasignature)'
						// step 3. resort data to match
						// id in the first element of
						// lag list

	local w1 : word 1 of `lag_list'
	capture mata : _SPMATRIX_assert_object("`w1'")
	if _rc {
		di "{err}weighting matrix {bf:`w1'} not found"
		exit 111
	}

	capture noi spmatrix xtidmatch `w1',	///
		id(`id')			///
		idsig_dta(`idsig_dta')		///
		touse(`touse')			///
		timevar(`timevar')		///
		timevalues(`timevalues')
	if _rc {
		di as err "_IDs in weighting matrix {bf:`w1'} "	///
			"do not match _IDs in estimation sample"
		di "{p 4 4 2}"
		di as err "There are places in {bf:`w1'} not in "	///
			"estimation sample and places in estimation "	///
			"sample not in {bf:`w1'}."
		di "{p_end}"
		exit 459
	}
						// step 4. check all the other
						// spmat against resorted data
	CheckSpmat, w(`lag_list') id(`id') touse(`touse')	///
		timevar(`timevar') timevalues(`timevalues')
end
						//-- CheckSpmat --//
program CheckSpmat
	syntax [, 			///
		w(string) 		///
		id(string) 		///
		touse(string) 		///
		timevar(string)		///
		timevalues(string)] 

	if `"`w'"'=="" { 
		exit(0)
	}
	
	tempvar touse_time
	qui gen `touse_time' = 0
	foreach wi of local w {
		capture mata : _SPMATRIX_assert_object("`wi'")
		if _rc {
			di "{err}weighting matrix {bf:`wi'} not found"
			exit 111
		}
		if (`"`timevar'"'!="") {
			foreach time of local timevalues {
				qui replace `touse_time' = 0
				qui replace `touse_time' = 1 	///
					if `touse' & `timevar'==`time'
				capture mata : _SPMATRIX_check_id(`"`wi'"',  ///
					`"`id'"', `"`touse_time'"')
				if _rc {
di as err `"{bf:id()} in time {bf:`time'} is inconsistent with {bf:`wi'}"'
					exit 498
				}
			}
		}
		else {
			qui replace `touse_time' = 1  if `touse'
			capture mata : _SPMATRIX_check_id(`"`wi'"',  ///
				`"`id'"', `"`touse_time'"')
			if _rc {
di as err `"{bf:id()} is inconsistent with {bf:`wi'}"'
				exit 498
			}
		}
	}
end
