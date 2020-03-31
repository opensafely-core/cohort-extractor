*! version 1.0.5  28mar2017
program _spreg_match_id
/*
	o. _spreg_match_id will resort the data such that the id in the data is
	consistent with id in the spmatrix weighting matrix. 

	o. It must be called by a program with sortpreserve property
*/
	version 15.0

	syntax , id(string)			///
		touse(string)			///
		[lag_list(string)]		
	
						// step 1. sort data by id
	sort `id'

	if (`"`lag_list'"'=="") {
		exit
	}
						// step 2. get id signature in
						// data
	tempvar tmpid		
	qui gen double `tmpid' = `id' 
	qui _datasignature `tmpid' if `touse', nonames
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
 	capture noi spmatrix idmatch `w1' , 	///
		id(`id') 			///
		idsig_dta(`idsig_dta') 		///
		touse(`touse')
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
	CheckSpmat, w(`lag_list') id(`id') touse(`touse')
end
						//-- CheckSpmat --//
program CheckSpmat
	syntax [, w(string) id(string) touse(string)] 

	if `"`w'"'=="" { 
		exit(0)
	}
	foreach wi of local w {
		capture mata : _SPMATRIX_assert_object("`wi'")
		if _rc {
			di "{err}weighting matrix {bf:`wi'} not found"
			exit 111
		}

		mata:  _SPMATRIX_check_id(`"`wi'"', `"`id'"', `"`touse'"')
	}
end
