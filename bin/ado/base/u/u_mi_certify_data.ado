*! version 1.1.9  16feb2015
/*
	u_mi_certify_data, [
		acceptable		make data acceptable
		proper			make data proper
		updatemissonly		update _mi_miss variable (*)

	      noUPdate			skip making data proper
		sortok			okay to change sort order
		msgno(<tempname>)	scalar for message numbers (**)

	Options:
	    -acceptable-, -proper- and -updatemissonly- are the actions.

                Data must be acceptable to be made proper, so if specifying
                -proper-, also specify -acceptable-, or be sure to have
                previously made the data acceptable.

                -updatemissonly- is used to update quickly the _mi_miss
                variable if the data are known to be otherwise acceptable and
                _mi_miss may be out of date.  It would be self-defeating to
                specify -updatemissonly- with -acceptable-; just make the data
                acceptable.  It would be an error to specify -updatemissonly-
                with -proper- and not -acceptable- because you already
                admitted that the data may not be acceptable.
                -updatemissonly- is not allowed with flongsep data.  That is
                not checked.

		-noupdate- makes it as if you do not specify -proper- 
		even if you did.  This is an easy way to implement 
		the end-user option noUPdate.

		-sortok- specifies it's okay if sort order is changed.

		msgno() is a building block for the future, in case 
		it is decided to number update messages.
*/


program u_mi_certify_data
	version 11
	syntax [, ACCEPTABLE PROPER UPDATEMISSONLY MSGNO(name) noUPdate SORTOK]

	if ("`msgno'"=="") {
		tempname msgno
	}
	scalar `msgno' = 0

	if ("`updatemissonly'"!="") {
		novarabbrev nobreak  mi_`_dta[_mi_style]'_update_miss `msgno' `sortok'
		exit
	}

	if ("`acceptable'" != "") {
		mi_`_dta[_mi_style]'_acceptable `msgno' `sortok'
	}
	if ("`proper'" != "" & "`update'"=="") {
		mi_`_dta[_mi_style]'_proper `msgno' `sortok'
	}
end


/* -------------------------------------------------------------------- */
					/* editing utilities		*/
/*
	novarabbrev nobreak  mi_drop_dropped_rvars
		Acceptability A3.
		For use by:	wide, mlong, flong
*/

program mi_drop_dropped_rvars
	args msgno

	/* ------------------------------------------------------------ */
	local rvars `_dta[_mi_rvars]'
	if ("`rvars'"=="") {
		exit
	}
	capture confirm var `rvars'
	if (_rc==0) {
		exit
	}
	/* ------------------------------------------------------------ */

	local touse
	local todrop
	foreach v of local rvars {
		capture confirm var `v'
		if (_rc) {
			local todrop `todrop' `v'
		}
		else {
			local touse `touse' `v'
		}
	}
	char _dta[_mi_rvars] `touse'

	mi_editmsg_unregistered `msgno' regular "`todrop'"
end

program mi_editmsg_unregistered 
	args msgno regtype varnames 

	local n : word count `varnames'
	if (`n'==0) {
		exit
	}
	scalar `msgno' = `msgno' + 1
	local variables = cond(`n'==1, "variable", "variables")

	di as txt "{p}"
	di as smcl "(`regtype' `variables'"
	di as smcl as res "`varnames'"
	di as smcl as txt "unregistered because not in {it:m}=0)"
	di as smcl "{p_end}"
end




program mi_editmsg_values_updated
	args msgno varreg varname m n

	if (!(`n')) {
		exit
	}
	scalar `msgno' = `msgno' + 1

	local values = cond(`n'==1, "value", "values")
	local where  = cond(`m'==., "{it:m}>0", "{it:m}=`m'")

	di as smcl as txt "{p}"
	di as smcl "(`n' `values' of `varreg' variable"
	di as smcl as res "`varname'"
	di as smcl as txt "in `where' updated to"
	di as smcl "match values in {it:m}=0)"
	di as smcl "{p_end}"
end

program mi_editmsg_obs_markedas /* <#> {complete|incomplete} */
	args msgno n complete

	if (`n'==0) {
		exit
	}
	scalar `msgno' = `msgno' + 1

	di as smcl as txt "{p}"
	di as smcl "(`n' {it:m}=0 obs. now marked as `complete')"
	di as smcl "{p_end}"
end

program mi_editmsg_imps_added /* <#> */
	args msgno n

	if (`n') {
		scalar `msgno' = `msgno' + 1
		local imputations = cond(`n'==1, "imputation", "imputations")
		di as txt "(`n' `imputations' added)"
	}
end

program _mi_editmsg_mi_id
	args msgno

	scalar `msgno' = `msgno' + 1
	di as txt "{p}"
	di as txt ///
	"(system variable _mi_id updated due to changed number of obs.)"
	di as txt "{p_end}"
end

					/* editing utilities		*/
/* -------------------------------------------------------------------- */
	

/* -------------------------------------------------------------------- */
/*
	wide editing

	A1. (not relevant)
	A2. (not relevant)

	A3. novarabbrev nobreak  mi_drop_dropped_rvars
		Update _dta[_mi_rvars] to reflect dropped variables

	A4. novarabbrev nobreak  mi_wide_drop_dropped_pvars
		Update _dta[_mi_pvars] to reflect dropped variables

	A5. novarabbrev nobreak  mi_wide_drop_dropped_ivars
		Update _dta[_mi_ivars] to reflect dropped variables; 
		If any dropped, causes (P1) mi_wide_update_miss to run.

						/* acceptable		*/
	/* ------------------------------------------------------------ */
						/* proper 		*/

	P1. novarabbrev nobreak  mi_wide_update_miss
		Recalculate incomplete indicator and compare with original.
		If mismatch, causes mi_wide_update_values_ivars and 
		mi_wide_update_values_pvars to run

 	P2. (not relevant)

	P3. novarabbrev nobreak  mi_wide_update_values
		Compare passive and imputed values with orig variables 
		and fix any that do not match. Calls:

		mi_wide_update_values_ivars
			Compare imputed variables with orig values when 
			orig values != . and fix any that do not match.

		mi_wide_update_values_pvars
			Compare passive variables with orig values 
			for complete observations. Fix any that do not match.

*/


program mi_wide_acceptable
	args msgno

	novarabbrev nobreak  mi_drop_dropped_rvars      `msgno'
	novarabbrev nobreak  mi_wide_drop_dropped_pvars `msgno'
	novarabbrev nobreak  mi_wide_drop_dropped_ivars `msgno'
end

program mi_wide_proper
	args msgno

/*
	novarabbrev nobreak  mi_drop_dropped_rvars      `msgno'
	novarabbrev nobreak  mi_wide_drop_dropped_pvars `msgno'
	novarabbrev nobreak  mi_wide_drop_dropped_ivars `msgno'
*/
	novarabbrev nobreak  mi_wide_update_miss        `msgno'
	novarabbrev nobreak  mi_wide_update_values	 `msgno'
	u_mi_curtime set
end



/*
	novarabbrev nobreak  mi_wide_drop_dropped_pvars
		Acceptability A4
*/

program mi_wide_drop_dropped_pvars
	args msgno

	local vars `_dta[_mi_pvars]'
	/* ------------------------------------------------------------ */
	if "`vars'"=="" {
		exit
	}
	capture confirm var `vars'
	if (_rc==0) { 
		exit
	}
	/* ------------------------------------------------------------ */

	local M `_dta[_mi_M]' 
	local new 
	local dropped
	foreach v of local vars {
		capture confirm var `v'
		if (_rc) {
			local dropped `dropped' `v'
			forvalues j=1(1)`M' {
				capture drop _`j'_`v'
			}
		}
		else {
			local new `new' `v' 
		}
	}
	char _dta[_mi_pvars] `new'

	mi_editmsg_unregistered `msgno' passive "`dropped'"
end


/*
	novarabbrev nobreak  mi_wide_drop_dropped_ivars
		Acceptability A5.
*/

program mi_wide_drop_dropped_ivars
	args msgno

	local vars `_dta[_mi_ivars]'

	/* ------------------------------------------------------------ */
	if "`vars'"=="" {
		exit
	}

	capture confirm var `vars'
	if (_rc==0) { 
		exit
	}
	/* ------------------------------------------------------------ */

	local M `_dta[_mi_M]' 
	local new 
	local dropped
	foreach v of local vars {
		capture confirm var `v'
		if (_rc) {
			local dropped `dropped' `v'
			forvalues j=1(1)`M' {
				capture drop _`j'_`v'
			}
		}
		else {
			local new `new' `v' 
		}
	}
	char _dta[_mi_ivars] `new'
	/* ------------------------------------------------------------ */
	mi_editmsg_unregistered `msgno' imputed "`dropped'"
end



/*
	novarabbrev nobreak  mi_wide_update_miss
		Properness P1
*/

program mi_wide_update_miss
	args msgno

	/* ------------------------------------------------------------ */
	tempvar newmis
	local vars `_dta[_mi_ivars]'
	qui gen byte `newmis' = 0
	foreach v of local vars {
		qui replace `newmis' = 1 if `v'==.
	}
	capture assert `newmis' == _mi_miss
	if (_rc==0) {
		exit
	}

	/* ------------------------------------------------------------ */
	qui count if _mi_miss & `newmis'==0
	local notmiss = r(N)
	qui count if _mi_miss==0 & `newmis'
	local newmiss = r(N)

	drop _mi_miss
	rename `newmis' _mi_miss

	if (`notmiss') { 
		mi_editmsg_obs_markedas `msgno' `notmiss' complete
	}
	if (`newmiss') { 
		mi_editmsg_obs_markedas `msgno' `newmiss' incomplete
	}
	/* ------------------------------------------------------------ */
	mi_wide_update_values `msgno'
end

/*
	novarabbrev nobreak  mi_wide_update_values
		Properness P3.
*/

program mi_wide_update_values
	args msgno

	mi_wide_update_values_pvars `msgno'
	mi_wide_update_values_ivars `msgno'
end


/*
	mi_wide_update_values_pvars
		mi_wide_update_values subroutine
		Properness P3, part 1.
*/

program mi_wide_update_values_pvars
	args msgno

	local vars `_dta[_mi_pvars]'
	local M   `_dta[_mi_M]'
	foreach v of local vars {
		local upcnt 0
		forvalues m=1(1)`M' {
			capture confirm var _`m'_`v'
			if (_rc) {
				mi_wide_update_replace `msgno' `m' _`m'_`v' `v'
			}
			qui count if `v'!=_`m'_`v' & _mi_miss==0
			if (r(N)) {
				local upcnt = `upcnt' + r(N)
				qui replace _`m'_`v' = `v' if _mi_miss==0
			}
		}
		mi_editmsg_values_updated `msgno' passive `v' . `upcnt'
	}
end

program mi_wide_update_replace
	args msgno m newvar oldvar
	local ty : type `oldvar'
	qui gen `ty' `newvar' = `oldvar'
	scalar `msgno' = `msgno' + 1
	di as smcl as txt "{p}"
	di as smcl as txt "(variable `oldvar' in {it:m}=`m' recreated using"
	di as smcl as txt "{it:m}=0 because not found)"
	di as smcl as txt "{p_end}"
end
	

/*
	mi_wide_update_values_ivars
		mi_wide_update_values subroutine
		Properness P3, part 2
*/

program mi_wide_update_values_ivars
	args msgno

	local vars `_dta[_mi_ivars]'
	local M   `_dta[_mi_M]'
	foreach v of local vars {
		local upcnt 0
		forvalues m=1(1)`M' {
			capture confirm var _`m'_`v'
			if (_rc) {
				mi_wide_update_replace `msgno' `m' _`m'_`v' `v'
			}
			qui count if `v'!=_`m'_`v' & `v'!=.
			if (r(N)) {
				local upcnt = `upcnt' + r(N)
				qui replace _`m'_`v' = `v' if `v'!=.
			}
		}
		mi_editmsg_values_updated `msgno' imputed `v' . `upcnt'
	}
end
	
/* -------------------------------------------------------------------- */
/*
	mlong editing

	A1. novarabbrev nobreak  mi_mlong_check_m
		verifies 0 <= _mi_m <= _dta[_mi_M]
		does not fill in missing m
		resets _dta[_mi_N]
	
	A2. novarabbrev nobreak  mi_mlong_check_id
		verifies id dense, etc., fixes any problems, and
		drops unnecs. imputed obs.

	A3. novarabbrev nobreak  mi_drop_dropped_rvars
		Update _dta[_mi_rvars] to reflect dropped variables

	A4. novarabbrev nobreak  mi_mlong_drop_dropped_pvars
		Update _dta[_mi_rvars] to reflect dropped variables

	A5. novarabbrev nobreak  mi_mlong_drop_dropped_ivars
		Update _dta[_mi_ivars] to reflect dropped variables;
		if any dropped, executes (P1) mi_mlong_update_miss()


						/* acceptable		*/
	/* ------------------------------------------------------------ */
						/* proper		*/

	P1. novarabbrev nobreak  mi_mlong_update_miss
		Recalculate incomplete indicator and compare with original.
		If mismatch, causes (P2) mi_mlong_update_iobs 
		and (P3) mi_mlong_update_values to run
	
	P2. novarabbrev nobreak  mi_mlong_update_iobs
                Verifies that incomplete obs are set correctly (including
                that _mi_m is sufficiently large) and if not, causes 
                (P2 part 2) _mi_mlong_update_iobs_fix to run, and then
		(P3) mi_mlong_update_values

	P3. novarabbrev nobreak  mi_mlong_update_values
		compare passive variables and imputed variables 
		with orig values and update any that need to be
		This routine calls:

		   mi_mlong_update_values_ivars
			WARNING: DATA MUST BE SORTED AND _dta[_mi_n]>0
			Compare imputed variables with orig values when 
			orig_values != . and fix any that do not match

		   mi_mlong_update_values_pvars
			WARNING: DATA MUST BE SORTED AND _dta[_mi_n]>0
			Compare passive variables with orig values when 
			_mi_miss and fix any that do not match

		   mi_mlong_update_values_rvars
			WARNING: DATA MUST BE SORTED AND _dta[_mi_n]>0
			Compare regular variables with orig values
			and fix any that do not match
*/

program mi_mlong_acceptable
	args msgno

	novarabbrev nobreak  mi_mlong_check_m            `msgno'
	novarabbrev nobreak  mi_mlong_check_id           `msgno' `sortok'
	novarabbrev nobreak  mi_drop_dropped_rvars       `msgno'
	novarabbrev nobreak  mi_mlong_drop_dropped_pvars `msgno'
	novarabbrev nobreak  mi_mlong_drop_dropped_ivars `msgno' `sortok'
end

program mi_mlong_proper
	args msgno sortok

/*
	novarabbrev nobreak  mi_mlong_check_m            `msgno'
	novarabbrev nobreak  mi_mlong_check_id           `msgno' `sortok'
	novarabbrev nobreak  mi_drop_dropped_rvars       `msgno'
	novarabbrev nobreak  mi_mlong_drop_dropped_pvars `msgno'
	novarabbrev nobreak  mi_mlong_drop_dropped_ivars `msgno' `sortok'
*/

	novarabbrev nobreak  mi_mlong_update_miss        `msgno' `sortok'
	novarabbrev nobreak  mi_mlong_update_iobs        `msgno' `sortok'
	novarabbrev nobreak  mi_mlong_update_values      `msgno' `sortok'
	u_mi_curtime set
end


/*
	novarabbrev nobreak  mi_mlong_check_m
		Acceptability A1
*/

program mi_mlong_check_m
	args msgno

	/* ------------------------ M bounded by [0, _dta[_mi_M]] --- */
	qui count if _mi_m<0 | _mi_m>`_dta[_mi_M]'
	if (r(N)==0) {
		qui count if _mi_m==0
		char _dta[_mi_N] `r(N)'
		if (_N | (r(N)==0 & _N==0)) {
			exit
		}
		scalar `msgno' = `msgno' + 1
		di as smcl as txt ///
	"(`=_N' {it:m}>0 marginal obs. dropped due to dropped obs. in {it:m}=0)"
		qui drop in f/l
		char _dta[_mi_n] 0
		exit
	}
		
	scalar `msgno' = `msgno' + 1
	di as smcl as err "{p 0 4 2}"
	di as smcl as err "system variable {bf:_mi_m} has values outside"
	di as smcl as err "[0,`_dta[_mi_M]']{break}"
	di as smcl as err "{p_end}"
	di as smcl as err "{p 4 4 2}"
	di as smcl as err "Did you change this important variable?{break}"
	di as smcl as err "One fix would be"
	di as smcl as err "{bf:drop if _mi_m<0 | _mi_m>`_dta[_mi_M]'}"
	di as smcl as err "{p_end}"
	exit 459
end

/*
	novarabbrev nobreak  mi_mlong_check_id [sortok]
		Acceptability A2
*/

program mi_mlong_check_id 
	args msgno sortok

	/* ------------------------------------------------------------ */
				/* determine whether 
				  _mi_id = 1, ..., _dta[_mi_N] & dense 
				*/
	qui summ _mi_id, meanonly
	if (r(min)==1 & r(max)==`_dta[_mi_N]') { 
		tempvar touse 
		gen byte `touse' = (_mi_m==0)
		capture mata: check_id_dense("`touse'")
		if (_rc==0) {
			exit
		}
	}
	/* ------------------------------------------------------------ */
				/* _mi_id violates requirements; fix	*/

	quietly {
		if ("`sortok'"=="") {
			local sortedby : sortedby
			tempvar recnum
			gen `c(obs_t)' `recnum' = _n
			compress `recnum' 
			local sortback u_mi_sortback `sortedby' `recnum'
		}
		sort _mi_m _mi_id

		local N0 `_dta[_mi_N]'
		if (`N0') {
			/* Note: in what follows:
				`N0' is # of obs in m==0
				_N > `N0'   ->  has _mi>0
				in 1/`N0'   ==  if _mi==0 
				in `N0p1'/l ==  if _mi>0
			*/
			local dropped_m_gt_0 0
			if (_N > `N0') {
				summ _mi_id in 1/`N0'
				local min_id = r(min)
				local max_id = r(max)
				local N0p1 = `N0' + 1
				count if _mi_id<`min_id' | _mi_id>`max_id' ///
							in `N0p1'/l
				if (r(N)) {
					local dropped_m_gt_0 = r(N)
					drop if _mi_id<`min_id' | 	///
					        _mi_id>`max_id' in `N0p1'/l
				}
			}
			mata: make_id_dense(`_dta[_mi_N]')
			count if _mi_id==.
			if (r(N)) {
				local dropped_m_gt_0 = `dropped_m_gt_0' + r(N)
				drop if _mi_id==.
			}
		}
		else {
			local dropped_m_gt_0 = _N 
			drop if 1
		}

		`sortback'
	}
	/* ------------------------------------------------------------ */
	_mi_editmsg_mi_id `msgno'
	if (`dropped_m_gt_0') {
		scalar `msgno' = `msgno' + 1
		di as smcl as txt ///
"(`dropped_m_gt_0' {it:m}>0 marginal obs. dropped due to dropped obs. in {it:m}=0)"
	}
end


program u_mi_sortback
	capture syntax varlist
	if (_rc) { 
		if (_rc != 111) { 
			error _rc
		}
		local varlist
		foreach el of local 0 {
			capture confirm var `el'
			if (_rc==0) { 
				local varlist `varlist' `el'
			}
		}
		if ("`varlist'"=="") {
			exit
		}
	}
	sort `varlist'
end
				

version 11
mata:
void check_id_dense(string scalar tousevar)
{
	real colvector  id, check, ones

	id = st_data(., "_mi_id", tousevar)
	check = J(rows(id), 1, 0)
	check[id] = ones = J(rows(id), 1, 1)
	if (check != ones) exit(459)
}

void make_id_dense(real scalar N)
{
	real scalar	oldN
	real colvector	curid, id

	if (N==0) return

	pragma unset curid 
	st_view(curid, (1,N), "_mi_id")		/* view of _mi_m==0 	*/
	oldN     = curid[N]
	id       = J(oldN, 1, .)
	id[curid] = (1::N)

	st_view(curid, ., "_mi_id")		/* view of all _mi_m */
	curid[.] = id[curid]
}
end

/*
	novarabbrev nobreak  mi_mlong_drop_dropped_pvars
		Acceptability A4
*/
		
program mi_mlong_drop_dropped_pvars
	args msgno

	local pvars `_dta[_mi_pvars]'
	/* ------------------------------------------------------------ */
	if ("`pvars'"=="") {
		exit
	}

	capture confirm var `_dta[_mi_pvars]'
	if (_rc==0) {
		exit
	}
	/* ------------------------------------------------------------ */

	local tokeep 
	local dropped
	foreach v of local pvars {
		capture confirm var `v'
		if (_rc) {
			local dropped `dropped' `v'
		}
		else {
			local tokeep `tokeep' `v'
		}
	}
	char _dta[_mi_pvars] `tokeep'

	mi_editmsg_unregistered `msgno' passive "`dropped'"
end


/*
	novarabbrev nobreak  mi_mlong_drop_dropped_ivars [sortok]
		Acceptability A5
*/



program mi_mlong_drop_dropped_ivars
	args msgno sortok

	local ivars `_dta[_mi_ivars]'
	/* ------------------------------------------------------------ */
	if ("`ivars'"=="") {
		exit
	}

	capture confirm var `_dta[_mi_ivars]'
	if (_rc==0) {
		exit
	}
	/* ------------------------------------------------------------ */

	local tokeep 
	local dropped
	foreach v of local ivars {
		capture confirm var `v'
		if (_rc) {
			local dropped `dropped' `v'
		}
		else {
			local tokeep `tokeep' `v'
		}
	}
	char _dta[_mi_ivars] `tokeep'

	mi_editmsg_unregistered `msgno' imputed "`dropped'"

	/* already novarabbrev nobreak */ mi_mlong_update_miss `msgno' `sortok'
end


/*
	novarabbrev nobreak  mi_mlong_update_miss [sortok]
		Properness P1
*/
	
program mi_mlong_update_miss
	args msgno sortok

	tempvar miss
	quietly {
		gen byte `miss' = cond(_mi_m, ., 0)
		local ivars `_dta[_mi_ivars]'
		foreach v of local ivars {
			replace `miss' = 1 if (`v'==.) & _mi_m==0
		}

		count if `miss'==1
		char _dta[_mi_n] `r(N)'
		count if `miss' != _mi_miss
		if (r(N)==0) { 
			exit
		}
	}
	/* ------------------------------------------------------- */ 
	quietly {
		count if `miss' != _mi_miss & _mi_m==0
		local Nb = r(N)
		if (`Nb') { 
			count if `miss' & !_mi_miss & _mi_m==0
			local Nb_nowincomplete = r(N)
			count if !`miss' & _mi_miss & _mi_m==0
			local Nb_nowcomplete = r(N)
		}
	}
	drop _mi_miss
	rename `miss' _mi_miss

	if (`Nb') {
		if (`Nb_nowcomplete') { 
			mi_editmsg_obs_markedas `msgno' `Nb_nowcomplete' complete
		}
		if (`Nb_nowincomplete') {
			mi_editmsg_obs_markedas `msgno' `Nb_nowincomplete' incomplete
		}
		mi_mlong_update_iobs `msgno' `sortok' 
		mi_mlong_update_values `msgno' `sortok'
	}
end

/*
	novarabbrev nobreak  mi_mlong_update_iobs [sortok]
		Properness P2
*/

program mi_mlong_update_iobs 
	args msgno sortok 

	tempvar tmpname
	capture mata: checkiobs(`_dta[_mi_M]', "`tmpname'")
	if (_rc) { 
		mi_mlong_update_iobs_fix `msgno' `sortok'
	}
end

program mi_mlong_update_iobs_fix
	args msgno sortok

	/* ------------------------------------------------------------ */
	if (`_dta[_mi_n]'==0) {		// known to be correct
		qui count if _mi_m!=0
		if (r(N)) {
			scalar `msgno' = `msgno' + 1
			di as txt "(`r(N)' {it:m}>0 marginal obs. dropped)"
			qui drop if _mi_m!=0
			exit
		}
	}

	/* ------------------------------------------------------------ */
	quietly {
		local M `_dta[_mi_M]'

		if ("`sortok'"=="") { 
			tempvar recnum
			gen `c(obs_t)' `recnum' = _N
			compress `recnum'
			local sortedby : sortedby
			local sortedby `sortedby' `recnum'
		}

		sort _mi_m _mi_id
		preserve

		local topM = _mi_m[_N]

		keep if _mi_m==0 & _mi_miss
		drop _mi_m
		sort _mi_id
		tempfile base 
		save "`base'"
		local N_in_base = _N

		if (`topM'>0) {
			restore, preserve 
			keep if _mi_m
			sort _mi_m _mi_id

			tempfile xtra
			save "`xtra'", replace
		}
		
		tempvar mervar
		local addedobs 0
		forvalues i=1(1)`M' {
			if (`i'<=`topM') {
				if (`i'!=1) { 
					use "`xtra'", clear
				}
				keep if _mi_m==`i'
				sort _mi_id
				qui merge 1:1 _mi_id using "`base'", ///
					sorted norep nonotes gen(`mervar')
				drop if `mervar'==1
				count if `mervar'==2
				local addedobs = `addedobs' + r(N)
				drop `mervar' 
				replace _mi_m = `i'
			}
			else {
				use "`base'", clear 
				gen int _mi_m = `i'
				compress _mi_m
				local addedobs = `addedobs' + `N_in_base'
			}
			replace _mi_miss = .
			tempfile file`i'
			save "`file`i''", emptyok
		}
		noi mi_mlong_mgt0_obs_added `msgno' `addedobs'
		restore, preserve
		keep if _mi_m==0
		forvalues i=1(1)`M' {
			append using "`file`i''"
		}
		if ("`sortok'"=="") {
			sort `sortedby'
		}
		restore, not
	}
end

program mi_mlong_mgt0_obs_added
	args msgno n

	if (`n'==0) {
		exit
	}

	scalar `msgno' = `msgno' + 1
	di as txt "(`n' {it:m}>0 marginal obs. added)"
end


version 11
mata:
function checkiobs(real scalar M, string scalar tmpname)
{
	real scalar	i
	real colvector	iobsno
	real colvector	subobsno

	if (!st_nobs()) return

	stata("qui gen byte " + tmpname + " = _mi_m==0 & _mi_miss")
	iobsno = sort(st_data(., "_mi_id", tmpname),1)
	st_dropvar(tmpname)
	

	for(i=1; i<=M; i++) { 
		stata(sprintf("qui gen %s = _mi_m==%g", tmpname, i))
		subobsno = sort(st_data(., "_mi_id", tmpname),1)
		st_dropvar(tmpname)
		if (iobsno!=subobsno) exit(459)
	}
}
end

/*
	novarabbrev nobreak  mi_mlong_update_values [sortok]
		Properness P3
*/

program mi_mlong_update_values
	args msgno sortok

	if ("`sortok'"=="") {
		quietly {
			local sortedby : sortedby
			tempvar recnum
			gen `c(obs_t)' `recnum' = _n
			compress `recnum'
			local sortback u_mi_sortback `sortedby' `recnum'
		}
	}
	sort _mi_m _mi_id 
	mi_mlong_update_values_pvars `msgno'
	mi_mlong_update_values_ivars `msgno'
	mi_mlong_update_values_rvars `msgno'
	`sortback'
end
       
	

program mi_mlong_update_values_ivars
	args msgno

	/* data assumed sorted, assumed _dta[_mi_n]>0 */
	local ivars `_dta[_mi_ivars]'
	foreach v of local ivars {
		qui count if `v'!=`v'[_mi_id] & ///
			_mi_m & `v'[_mi_id]!=.
		if (r(N)) { 
			mi_editmsg_values_updated `msgno' imputed `v' . `r(N)'
			qui replace `v' = `v'[_mi_id] ///
				if _mi_m & `v'[_mi_id]!=.
		}
	}
end

program mi_mlong_update_values_pvars
	args msgno

	/* data assumed sorted, assumed _dta[_mi_n]>0 */
	local pvars `_dta[_mi_pvars]'
	foreach v of local pvars {
		qui count if `v'!=`v'[_mi_id] & ///
			_mi_m & _mi_miss[_mi_id]==0
		if (r(N)) { 
			mi_editmsg_values_updated `msgno' passive `v' . `r(N)'
			qui replace `v' = `v'[_mi_id] ///
				if _mi_m & _mi_miss[_mi_id]
		}
	}
end

program mi_mlong_update_values_rvars
	args msgno

	/* data assumed sorted, assumed _dta[_mi_n]>0 */
	local rvars `_dta[_mi_rvars]'
	foreach v of local rvars {
		qui count if `v'!=`v'[_mi_id]
		if (r(N)) {
			local n = r(N)
			mi_editmsg_values_updated `msgno' regular `v' . `r(N)'
			qui replace `v' = `v'[_mi_id] 
		}
	}
end

	
	
/* -------------------------------------------------------------------- */
/*
	flong editing

	A1. novarabbrev nobreak  mi_flong_check_m
		verifies 0 <= _mi_m <= _dta[_mi_M]
		does not fill in missing m
		Resets _dta[_mi_N]
	
	A2. novarabbrev nobreak  mi_flong_check_id
		verifies id dense, etc., fixes any problems.

	A3. novarabbrev nobreak  mi_drop_dropped_rvars
		update _dta[_mi_rvars] to reflect dropped variables

	A4. novarabbrev nobreak  mi_flong_drop_dropped_pvars
		update _dta[_mi_pvars] to reflect dropped variables

	A5. novarabbrev nobreak  mi_flong_drop_dropped_ivars
		update _dta[_mi_rvars] to reflect dropped variables;
		if any dropped, executes (P1) mi_flong_update_miss()


						/* acceptable		*/
	/* ------------------------------------------------------------ */
						/* proper		*/

	P1. novarabbrev nobreak  mi_flong_update_miss
		Reset _dta[_mi_N].
		Recalculate incomplete indicator and compare with original.
		If mismatch, causes (P2) mi_flong_update_iobs 	
		and (P3) mi_flong_update_values to run

	P2. novarabbrev nobreak  mi_flong_update_iobs
                Verifies that incomplete obs are set correctly (including
                that _mi_m is sufficiently large) and if not, causes 
                (P2 part 2) _mi_mlong_update_iobs_fix to run, and then
		(P3) mi_mlong_update_values

	P3. novarabbrev nobreak 
		compare passive variables and imputed variables 
		with orig values and update any that need to be
		This routine calls:

		   mi_flong_update_values_ivars
			WARNING: DATA MUST BE SORTED AND _dta[_mi_n]>0
			Compare imputed variables with orig values when 
			orig_values != . and fix any that do not match

		   mi_flong_update_values_pvars
			WARNING: DATA MUST BE SORTED AND _dta[_mi_n]>0
			Compare passive variables with orig values when 
			_mi_miss and fix any that do not match

		   mi_flong_update_values_rvars
			WARNING: DATA MUST BE SORTED AND _dta[_mi_n]>0
			Compare regular variables with orig values
			and fix any that do not match
*/

program mi_flong_acceptable
	args msgno

	novarabbrev nobreak  mi_flong_check_m            `msgno'
	novarabbrev nobreak  mi_flong_check_id           `msgno' `sortok'
	novarabbrev nobreak  mi_drop_dropped_rvars       `msgno'
	novarabbrev nobreak  mi_flong_drop_dropped_pvars `msgno'
	novarabbrev nobreak  mi_flong_drop_dropped_ivars `msgno' `sortok'
end

program mi_flong_proper
	args msgno sortok

/*
	novarabbrev nobreak  mi_flong_check_m            `msgno'
	novarabbrev nobreak  mi_flong_check_id           `msgno' `sortok'
	novarabbrev nobreak  mi_drop_dropped_rvars       `msgno'
	novarabbrev nobreak  mi_flong_drop_dropped_pvars `msgno'
	novarabbrev nobreak  mi_flong_drop_dropped_ivars `msgno' `sortok'
*/
	novarabbrev nobreak  mi_flong_update_miss        `msgno' `sortok'
	novarabbrev nobreak  mi_flong_update_iobs        `msgno' `sortok'
	novarabbrev nobreak  mi_flong_update_values      `msgno' `sortok'
	u_mi_curtime set
end


/*
	novarabbrev nobreak  mi_flong_check_m
		Acceptability A1
*/

program mi_flong_check_m
	args msgno

	/* ------------------------ M bounded by [0, _dta[_mi_M]] --- */
	qui count if _mi_m<0 | _mi_m>`_dta[_mi_M]'
	if (r(N)==0) {
		qui count if _mi_m==0
		char _dta[_mi_N] `=r(N)'
		if (_N | (r(N)==0 & _N==0)) {
			exit
		}
		scalar `msgno' = `msgno' + 1
		di as smcl as txt ///
	"(`=_N' {it:m}>0 obs. dropped due to dropped obs. in {it:m}=0)"
		drop in f/l
		exit
	}

	scalar `msgno' = `msgno' + 1
	di as smcl as err "{p 0 4 2}"
	di as smcl as err "system variable {bf:_mi_m} has values outside"
	di as smcl as err "[0,`_dta[_mi_M]']{break}"
	di as smcl as err "Did you change this important variable?{break}"
	di as smcl as err "One fix would be"
	di as smcl as err "{bf:drop if _mi_m<0 | _mi_m>`_dta[_mi_M]'}"
	di as smcl as err "{p_end}"
	exit 459
end

/*
	novarabbrev nobreak  mi_flong_check_id [sortok]
		Acceptability A2
*/

program mi_flong_check_id 
	args msgno sortok
	/* ------------------------------------------------------------ */
				/* determine whether 
				  _mi_id = 1, ..., _dta[_mi_N] & dense 
				*/
	qui summ _mi_id, meanonly
	if (r(min)==1 & r(max)==`_dta[_mi_N]') {
		tempvar touse 
		gen byte `touse' = (_mi_m==0)
		capture mata: check_id_dense("`touse'")
		if (_rc==0) {
			exit
		}
	}
	/* ------------------------------------------------------------ */
				/* _mi_id violates requirements; fix	*/

	quietly {
		if ("`sortok'"=="") {
			local sortedby : sortedby
			tempvar recnum
			gen `c(obs_t)' `recnum' = _n
			compress `recnum' 
			local sortback u_mi_sortback `sortedby' `recnum'
		}
		sort _mi_m _mi_id

		local N0 = `_dta[_mi_N]'
		if (`N0') {
			/* Note: in what follows:
				`N0' is # of obs in m==0
				_N > `N0'   ->  has _mi>0
				in 1/`N0'   ==  if _mi==0 
				in `N0p1'/l ==  if _mi>0
			*/
			local dropped_m_gt_0 0
			if (_N > `N0') {
				summ _mi_id in 1/`N0'
				local min_id = r(min)
				local max_id = r(max)
				local N0p1   = `N0' + 1
				count if _mi_id<`min_id' | _mi_id>`max_id' ///
							in `N0p1'/l
				if (r(N)) {
					local dropped_m_gt_0 = r(N)
					drop if _mi_id<`min_id' |	///
						_mi_id>`max_id' in `N0p1'/l
				}
			}
			mata: make_id_dense(`_dta[_mi_N]')
			count if _mi_id==.
			if (r(N)) {
				local dropped_m_gt_0 = `dropped_m_gt_0' + r(N)
				drop if _mi_id==.
			}
		}
		else {
			local dropped_m_gt_0 = _N
			drop if 1
		}
		`sortback'
	} 
	_mi_editmsg_mi_id `msgno'
	if (`dropped_m_gt_0') {
		scalar `msgno' = `msgno' + 1
		di as smcl as txt ///
"(`dropped_m_gt_0' {it:m}>0 obs. dropped due to dropped obs. in {it:m}=0)"
	}
end

/*
	novarabbrev nobreak  mi_flong_drop_dropped_pvars
		Acceptability A4
*/

		
program mi_flong_drop_dropped_pvars
	args msgno

	/* ------------------------------------------------------------ */
	local pvars `_dta[_mi_pvars]'
	if ("`pvars'"=="") {
		exit
	}

	capture confirm var `_dta[_mi_pvars]'
	if (_rc==0) {
		exit
	}
	/* ------------------------------------------------------------ */

	local tokeep 
	local dropped
	foreach v of local pvars {
		capture confirm var `v'
		if (_rc) {
			local dropped `dropped' `v'
		}
		else {
			local tokeep `tokeep' `v'
		}
	}
	char _dta[_mi_pvars] `tokeep'

	mi_editmsg_unregistered `msgno' passive "`dropped'"
end

/*
	novarabbrev nobreak  mi_flong_drop_dropped_ivars
		Acceptability A5
*/

program mi_flong_drop_dropped_ivars
	args msgno sortok

	local ivars `_dta[_mi_ivars]'
	/* ------------------------------------------------------------ */
	if ("`ivars'"=="") {
		exit
	}

	capture confirm var `_dta[_mi_ivars]'
	if (_rc==0) {
		exit
	}
	/* ------------------------------------------------------------ */

	local tokeep 
	local dropped
	foreach v of local ivars {
		capture confirm var `v'
		if (_rc) {
			local dropped `dropped' `v'
		}
		else {
			local tokeep `tokeep' `v'
		}
	}
	char _dta[_mi_ivars] `tokeep'

	mi_editmsg_unregistered `msgno' imputed "`dropped'"

	/* already novarabbrev nobreak */ mi_flong_update_miss `msgno' `sortok'
end

/*
	novarabbrev nobreak  mi_mlong_update_miss [sortok]
		Properness P1
*/

program mi_flong_update_miss
	args msgno sortok

	tempvar miss
	quietly {
		gen byte `miss' = cond(_mi_m, ., 0)
		local ivars `_dta[_mi_ivars]'
		foreach v of local ivars {
			replace `miss' = 1 if (`v'==.) & _mi_m==0
		}

		count if `miss' != _mi_miss
		if (r(N)==0) { 
			exit
		}
	}
	/* ------------------------------------------------------- */ 
	quietly {
		count if `miss' != _mi_miss & _mi_m==0
		local Nb = r(N)
		if (`Nb') { 
			count if `miss' & !_mi_miss & _mi_m==0
			local Nb_nowincomplete = r(N)
			count if !`miss' & _mi_miss & _mi_m==0
			local Nb_nowcomplete = r(N)
		}
	}
	drop _mi_miss
	rename `miss' _mi_miss

	if (`Nb') {
		if (`Nb_nowcomplete') { 
			scalar `msgno' = `msgno' + 1
			mi_editmsg_obs_markedas `msgno' ///
					`Nb_nowcomplete' complete
		}
		if (`Nb_nowincomplete') {
			scalar `msgno' = `msgno' + 1
			mi_editmsg_obs_markedas `msgno' ///
					`Nb_nowincomplete' incomplete
		}
		mi_flong_update_iobs   `msgno' `sortok'
		mi_flong_update_values `msgno' `sortok'
	}

end


/*
	novarabbrev nobreak  mi_flong_update_iobs [sortok]
		Properness P2
*/

program mi_flong_update_iobs 
	args msgno sortok 

	if (_N==0) {
		exit
	}
			
	if ("`sortok'"=="") {
		tempvar recnum 
		qui gen `c(obs_t)' `recnum' = _N
		qui compress `recnum'
		local sortedby : sortedby
		local sortback u_mi_sortback `sortedby' `recnum'
	}
	sort _mi_m _mi_id 
	mi_flong_update_iobs_prob prob 
	if (`prob') {
		mi_flong_update_iobs_fix `msgno'
	}
	else {
		capture by _mi_m: assert _mi_id==_n
		if (_rc) {
			mi_flong_update_iobs_fix `msgno'
		}
	}
	`sortback'
end
		
		
/*static*/ program mi_flong_update_iobs_fix
	args msgno


	/* ------------------------------------------------------------ */
	if (`_dta[_mi_N]'==0) { 		// known to be correct
		if (_N) {
			scalar `msgno' = `msgno' + 1
			di as smcl as txt "(`=_N' {it:m}>0 obs. dropped)"
			qui drop in f/l
		}
		exit
	}
	/* ------------------------------------------------------------ */

	/* sort _mi_m _mi_id */ 		/* already true		*/

	local filename `"`c(filename)'"'
	preserve

	local topM = _mi_m[_N]
	local M      `_dta[_mi_M]'
	quietly {
		keep if _mi_m==0 
		drop _mi_m 
		sort _mi_id
		tempfile origdta
		save "`origdta'"
		local N_in_base = _N

		if (`topM'>0) {
			restore, preserve
			keep if _mi_m
			drop _mi_miss
			tempfile imputationdta
			save "`imputationdta'"
		}

		tempvar mervar
		forvalues i=1(1)`M' {
			if (`i'<=`topM') {
				if (`i'!=1) { 
					use "`imputationdta'", clear
				}
				keep if _mi_m==`i'

				sort _mi_id
				qui merge 1:1 _mi_id using "`origdta'", ///
					sorted norep nonotes gen(`mervar')
				count if `mervar'==2
				if (r(N)) {
					noi mi_flong_update_added ///
					`msgno' `r(N)' `i'
				}
				drop `mervar'
				replace _mi_m = `i'
			}
			else {
				if (`i'!=1) {
					use "`origdta'", clear 
				}
				gen int _mi_m = `i'
				compress _mi_m
				noi mi_flong_update_added ///
					`msgno' `N_in_base' `i'
			}
			replace _mi_miss = .
			tempfile file`i'
			save "`file`i''", emptyok
		}
		use "`origdta'", clear 
		gen int _mi_m = 0
		forvalues i=1(1)`M' {
			append using "`file`i''"
		}

		global S_FN `"`filename'"'
		restore, not
	}
end

program mi_flong_update_added
	args msgno n m

	if (`n'==0) {
		exit
	}

	scalar `msgno' = `msgno' + 1
	di as txt as smcl "{p}"
	di as txt as smcl "(`n' {it:m}=0 obs. added to {it:m}=`m'"
	di as txt as smcl "because physically missing)"
	di as txt as smcl "{p_end}"
end

program mi_flong_update_iobs_prob
	args probname

	local M `_dta[_mi_M]'
	local N `_dta[_mi_N]'

	c_local `probname' 0
	forvalues m=1(1)`M' {
		local f = `N'*`m' + 1
		local l = `f' + `N' - 1
		capture assert _mi_m==`m' in `f'/`l'
		if (_rc) {
			c_local `probname' 1
			continue, break 
		}
	}
end


/*
	novarabbrev nobreak  mi_flong_update_values [sortok]
		Properness P3
*/

program mi_flong_update_values
	args msgno sortok

	if ("`sortok'"=="") {
		quietly {
			local sortedby : sortedby
			tempvar recnum
			gen `c(obs_t)' `recnum' = _n
			compress `recnum'
			local sortback u_mi_sortback `sortedby' `recnum'
		}
	}
	sort _mi_m _mi_id `recnum'
	mi_flong_update_values_pvars `msgno'
	mi_flong_update_values_ivars `msgno'
	mi_flong_update_values_rvars `msgno'
	`sortback'
end
	

program mi_flong_update_values_ivars
	args msgno

	/* data assumed sorted */
	local ivars `_dta[_mi_ivars]'
	foreach v of local ivars {
		qui count if `v'!=`v'[_mi_id] & ///
			_mi_m & `v'[_mi_id]!=.
		if (r(N)) { 
			mi_editmsg_values_updated `msgno' imputed `v' . `r(N)'
			qui replace `v' = `v'[_mi_id] ///
				if _mi_m & `v'[_mi_id]!=.
		}
	}
end

program mi_flong_update_values_pvars
	args msgno

	/* data assumed sorted */
	local pvars `_dta[_mi_pvars]'
	foreach v of local pvars {
		qui count if `v'!=`v'[_mi_id] & ///
			_mi_m & _mi_miss[_mi_id]==0
		if (r(N)) { 
			mi_editmsg_values_updated `msgno' passive `v' . `r(N)'
			qui replace `v' = `v'[_mi_id] ///
				if _mi_m & _mi_miss[_mi_id]==0
		}
	}
end

program mi_flong_update_values_rvars
	args msgno

	/* data assumed sorted */
	local rvars `_dta[_mi_rvars]'
	foreach v of local rvars {
		qui count if `v'!=`v'[_mi_id]
		if (r(N)) {
			mi_editmsg_values_updated `msgno' regular `v' . `r(N)'
			qui replace `v' = `v'[_mi_id] 
		}
	}
end


/* -------------------------------------------------------------------- */
					/* flongsep editing		*/
/*
	flongsep editing

	A1. novarabbrev nobreak  mi_flongsep_check_m
		verifies 0 <= _mi_m <= _dta[_mi_M]
		does not fill in missing m
	
	A2. novarabbrev nobreak  mi_flongsep_check_id
		verifies id dense, etc., fixes any problems, and
		drops unnecs. imputed obs.

	novarabbrev nobreak  mi_flongsep_drop_keep_miss <checktype> [sortok]
		(1) checks existence of ivars, pvars, rvars
		(2) if <checktype>==proper or ivars updated, checks _mi_miss

		if any problems in (1) or (2), or if <checktype>==proper,
		updates values of _mi_miss, ivars, pvars, and rvars.

		in addition, if <checktype>==proper, any new unregistered
		variables in original are propagated to the imputation 
		datasets
*/

program mi_flongsep_acceptable
	args msgno sortok

	novarabbrev nobreak  mi_flongsep_check_m                   `msgno'
	novarabbrev nobreak  mi_flongsep_check_id                  `msgno' `sortok'
	novarabbrev nobreak  mi_flongsep_drop_keep_miss acceptable `msgno' `sortok'
end

program mi_flongsep_proper
	args msgno sortok

/*
	novarabbrev nobreak  mi_flongsep_check_m
	novarabbrev nobreak  mi_flongsep_check_id
*/
	novarabbrev nobreak  mi_flongsep_drop_keep_miss proper `msgno' `sortok'
	u_mi_curtime set
end


/*
	novarabbrev nobreak  mi_flongsep_check_m
		Acceptability A1
*/

program mi_flongsep_check_m
	args msgno

	local M    `_dta[_mi_M]'
	local name `_dta[_mi_name]'

	local err 0
	forvalues m=1(1)`M' {
		capture confirm file _`m'_`name'.dta
		if (_rc) {
			local err 1
			di as err "file _`m'_`name'.dta not found"
		}
	}
	if (`err') {
		exit 601
	}
		
	local Mp1 = `M' + 1
	capture confirm file _`Mp1'_`_dta[_mi_name]'.dta
	if (_rc) {
		exit
	}

	mata: u_mi_flongsep_erase("`name'", `Mp1', 0)
	scalar `msgno' = `msgno' + 1
	di as smcl as txt "{p}"
	di as smcl "(imputation datasets _#_`_dta[_mi_name]'.dta" 
	di as smcl ///
	"for # > `_dta[_mi_M]' erased because {it:M} = `_dta[_mi_M]')"
	di as smcl "{p_end}"
end

/*
	novarabbrev nobreak  mi_flongsep_check_id
		Acceptability A2
*/

program mi_flongsep_check_id 
	args msgno sortok


	/* ----------------------------------------- handle _N==0 --- */
	if (_N==0 & `_dta[_mi_N]') {
		char _dta[_mi_N] 0

		if (`_dta[_mi_M]') {
			local   M `_dta[_mi_M]'
			local name `_dta[_mi_name]'
			preserve
			u_mi_zap_chars
			drop _mi_miss
			char _dta[_mi_style] "flongsep_sub"
			char _dta[_mi_name]  "`name'"
			char _dta[_mi_marker] _mi_ds_1
			forvalues i=1(1)`M' {
				char _dta[_mi_m] `i'
				qui save _`i'_`name', replace
			}
			scalar `msgno' = `msgno' + 1
			di as smcl as txt "{p}"
			di as smcl "(all obs. in {it:m}>0 dropped"
			di as smcl "in order to match {it:m}=0 data)"
			di as smcl "{p_end}"
		}
		exit
	}
	/* ------------------------------------------------------------ */

	local makepass = (_N != `_dta[_mi_N]')
	char _dta[_mi_N] `=_N'

	if (`makepass'==0) {
		qui summ _mi_id, meanonly
		if (r(min)<1 | r(max)>`_dta[_mi_N]') {
			local makepass 1
		}
		else {
			tempvar touse 
			qui gen byte `touse' = 1
			capture mata: check_id_dense("`touse'")
			local makepass = _rc
			drop `touse'
		}
	}

	if (`makepass'==0) {
		exit
	}
	/* ------------------------------------------------------------ */

	/* ---------------------------------------------------- fix --- */

	if ("`sortok'"=="") {
		local sortedby : sortedby
		tempvar recnum
		qui gen `c(obs_t)' `recnum' = _n
		qui compress `recnum' 
		local sortback u_mi_sortback `sortedby' `recnum'
		local drop_recnum drop `recnum'
	}
	sort _mi_id 

	local M    `_dta[_mi_M]'
	local name `_dta[_mi_name]'
	quietly {
		preserve 
		u_mi_zap_chars
		drop _mi_miss
		tempfile tokeepdta 
		qui save "`tokeepdta'"
		local Nd 0
		local Na 0
		tempvar mervar
		forvalues m=1(1)`M' {
			use _`m'_`name', clear
			sort _mi_id
			merge 1:1 _mi_id using "`tokeepdta'", ///
				sorted norep nonotes gen(`mervar')
			count if `mervar'==1
			local Nd = `Nd' + r(N)
			keep if `mervar'==3
			drop `mervar'
			sort _mi_id
			replace _mi_id = _n
			`sortback'
			`drop_recnum'
			save _`m'_`name', replace
		}
		restore
		replace _mi_id = _n
		`sortback'
		`drop_recnum'
		save `name', replace
	}

	_mi_editmsg_mi_id `msgno'
	if (`Nd') {
		scalar `msgno' = `msgno' + 1
		di as smcl as txt "{p}"
		di as smcl "`Nd' obs. in {it:m}>0 datasets dropped"
		di as smcl "in order to match {it:m}=0 data)"
		di as smcl "{p_end}"
	}
end


program u_mi_flongsep_keep_drop
	args u_keep u_drop colon  vars

	local keep
	local drop
	foreach v of local vars {
		capture confirm var `v'
		if (_rc) {
			local drop `drop' `v'
		}
		else {
			local keep `keep' `v'
		}
	}
	c_local `u_keep' `keep'
	c_local `u_drop' `drop'
end

	
		
program mi_flongsep_drop_keep_miss
	args checktype msgno sortok


	local todrop       /* empty list */
	local makepass     0
	local ivars_updated 0
	local pvars_updated 0
	local rvars_updated 0


	/* ------------------------------------------------------------ */
			/* check for dropped ivars, pvars, rvars 	*/
			/* fix will occur if makepass set 1		*/

	if ("`_dta[_mi_rvars]'"!="") {
		capture confirm var `_dta[_mi_rvars]'
		if (_rc) {
			u_mi_flongsep_keep_drop keep drop : "`_dta[_mi_rvars]'"
			mi_editmsg_unregistered `msgno' regular "`drop'"
			char _dta[_mi_rvars] `keep'
			local rvars_updated 1
			local todrop `todrop' `drop'
			local makepass 1
		}
	}

	if ("`_dta[_mi_pvars]'"!="") {
		capture confirm var `_dta[_mi_pvars]'
		if (_rc) {
			u_mi_flongsep_keep_drop keep drop : "`_dta[_mi_pvars]'"
			mi_editmsg_unregistered `msgno' passive "`drop'"
			char _dta[_mi_pvars] `keep'
			local pvars_updated 1
			local todrop `todrop' `drop'
			local makepass 1
		}
	}

	if ("`_dta[_mi_ivars]'"!="") {
		capture confirm var `_dta[_mi_ivars]'
		if (_rc) {
			u_mi_flongsep_keep_drop keep drop : "`_dta[_mi_ivars]'"
			mi_editmsg_unregistered `msgno' imputed "`drop'"
			char _dta[_mi_ivars] `keep'
			local ivars_updated 1
			local todrop `todrop' `drop'
			local makepass 1
		}
	}

	/* ------------------------------------------------------------ */
				/* check and perhaps update _mi_miss	*/

	if (`ivars_updated' | "`checktype'"=="proper") {

		local ivars `_dta[_mi_ivars]'
		tempvar miss
		quietly {
			gen byte `miss' = 0 
			foreach v of local ivars {
				replace `miss'=1 if `v'==. /*sic*/
			}
		}
		qui count if `miss'!=_mi_miss
		if (r(N)) {
			local makepass 1
			qui count if !`miss' & _mi_miss
			local N_nowcomplete = r(N)
			qui count if `miss' & !_mi_miss
			local N_nowincomplete = r(N)
			if (`N_nowcomplete') {
				mi_editmsg_obs_markedas `msgno' `N_nowcomplete' complete
			}
			if (`N_nowincomplete') {
				mi_editmsg_obs_markedas `msgno' ///
						`N_nowincomplete' incomplete
			}
			drop _mi_miss
			rename `miss' _mi_miss
		}
		else {
			drop `miss'
		}
	}
	/* ------------------------------------------------------------ */
	if (`makepass' | "`checktype'"=="proper") {
			/* 
			  we save if proper and makepass==0
			  because there might be new unregistered
			  variables
			*/
		qui save `name', replace
	}
	/* ------------------------------------------------------------ */
	if (`makepass'==0 & "`checktype'"!="proper") {
		exit
	}
	/* ------------------------------------------------------------ */
			/* 
			  fix dropped ivars, pvars, and rvars and 
			  update values of remaining ivars, pvars, 
			  and rvars
			*/

	local M    `_dta[_mi_M]'
	local name `_dta[_mi_name]'
	local ivars `_dta[_mi_ivars]'
	local pvars `_dta[_mi_pvars]'
	local rvars `_dta[_mi_rvars]'
	unab m_vars : _all

	/* list todrop already contains variables to be dropped */

	/* All updates below have to do with M>0 */
	if (`M'==0) {
		exit
	}

	preserve

	if ("`sortok'"=="") {
		tempvar recnum
		qui gen `c(obs_t)' `recnum' = _n
		qui compress `recnum'
		local sortedby : sortedby
		local sortback u_mi_sortback `sortedby' `recnum'
		local drop_recnum drop `recnum'
	}

	local vars `pvars' `rvars' `ivars'
	foreach v of local vars {
		rename `v' _0_`v'
	}
	sort _mi_id
	u_mi_zap_chars
	tempfile basedta
	qui save "`basedta'"

	mata: u_mi_chars_save("charindex", "Char")

	local tormvars _mi_miss

	quietly { 
		local Na 0
		local Nd 0
		local Npas 0
		local Nreg 0
		local Nimp 0

		local replaced 

		tempvar mervar
		forvalues m=1(1)`M' { 
			use _`m'_`name', clear 
			unab m_m_vars : _all
			sort _mi_id 

			merge 1:1 _mi_id using "`basedta'", ///
						sorted nonotes gen(`mervar')
			count if `mervar'==1
			local Nd = `Nd' + r(N)
			count if `mervar'==2
			local Na = `Na' + r(N)
			keep if `mervar'==2 | `mervar'==3
			drop `mervar' 

			foreach v of local todrop {
				capture drop `v'
			}

			foreach v of local pvars {
				capture confirm var `v'
				if (_rc) {
					local replaced `replaced' `v'
					local ty : type _0_`v'
					gen `ty' `v' = _0_`v'
				}
				else {
					count if `v'!=_0_`v' & !_mi_miss
					if (r(N)) { 
						local Npas = `Npas' + r(N)
						replace `v'=_0_`v' if !_mi_miss
					}
				}
			}

			foreach v of local rvars {
				capture confirm var `v'
				if (_rc) {
					local replaced `replaced' `v'
					local ty : type _0_`v'
					gen `ty' `v' = _0_`v'
				}
				else {
					count if `v'!=_0_`v'
					if (r(N)) {
						local Nreg = `Nreg' + r(N)
						replace `v'=_0_`v' 
					}
				}
			}

			foreach v of local ivars {
				capture confirm var `v'
				if (_rc) {
					local replaced `replaced' `v'
					local ty : type _0_`v'
					gen `ty' `v' = _0_`v'
				}
				else {
					count if `v'!=_0_`v' & _0_`v'!=.
					if (r(N)) {
						local Nimp = `Nimp' + r(N)
						replace `v'=_0_`v' if _0_`v'!=.
					}
				}
			}

			capture drop _0_*
			drop _mi_miss
			`sortback'
			`drop_recnum'

			unab u_vars : _all
			local rm_vars : list u_vars - m_vars
			capture drop `rm_vars'
			mata: u_mi_rm_dta_chars()
			mata: u_mi_chars_put("charindex", "Char")
			save _`m'_`name', replace

			if ("`rm_vars'"!="") {
				noi mi_flongsep_update_dropmsg ///
					`msgno' "`rm_vars'" `m'
			}

			local dif : list m_vars - m_m_vars
			local dif : list dif - tormvars
			if ("`dif'"!="") {
				noi mi_flongsep_update_addvarmsg ///
					`msgno' "`dif'" `m'
			}
		}
	}
	restore

	if (`Nd') {
		scalar `msgno' = `msgno' + 1
		di as smcl as txt "{p 0 4}"
		di as smcl "(`Nd' obs. in {it:m}>0 dropped"
		di as smcl "in order to match {it:m}=0 data)"
		di as smcl "{p_end}"
	}
	if (`Na') {
		scalar `msgno' = `msgno' + 1
		di as smcl as txt "{p 0 4}"
		di as smcl "(`Na' obs. in {it:m}>0 added"
		di as smcl "in order to match {it:m}=0 data)"
		di as smcl "{p_end}"
	}

	if ("`replaced'"!="") {
		scalar `msgno' = `msgno' + 1
		local replaced : list uniq replaced
		local n : word count `replaced'
		local variables = cond(`n'==1, "variable", "variables")
		di as smcl as txt "{p 4 4}"
		di as smcl "(`variables'"
		di as smcl as res "`replaced'"
		di as smcl as txt "created with {it:m}=0 values in one or more"
		di as smcl "{it:m}>0 datasets"
		di as smcl "because `variables' did not exist)"
		di as smcl "{p_end}"
	}


	if (`Nimp') { 
		scalar `msgno' = `msgno' + 1
		di as smcl as txt "{p 0 4 1}"
		di as smcl "(imputed variables updated in `Nimp'"
		di as smcl "obs. in {it:m}>0"
		di as smcl "in order to match {it:m}=0 data)"
		di as smcl "{p_end}"
	}
	if (`Npas') { 
		scalar `msgno' = `msgno' + 1
		di as smcl as txt "{p 0 4 1}"
		di as smcl "(passive variables updated in `Npas'"
		di as smcl "obs. in {it:m}>0"
		di as smcl "in order to match {it:m}=0 data)"
		di as smcl "{p_end}"
	}
	if (`Nreg') { 
		scalar `msgno' = `msgno' + 1
		di as smcl as txt "{p 0 4 1}"
		di as smcl "(regular variables updated in `Nreg'"
		di as smcl "obs. in {it:m}>0"
		di as smcl "in order to match {it:m}=0 data)"
		di as smcl "{p_end}"
	}
end


program mi_flongsep_update_dropmsg
	args msgno vars m

	scalar `msgno' = `msgno' + 1
	local n : word count `vars'
	local variables = cond(`n'==1, "variable", "variables")
	di as smcl as txt "{p 0 4}"
	di as smcl "(`variables'"
	di as smcl as res "`vars'"
	di as smcl as txt "dropped in {it:m}=`m')"
	di as smcl "{p_end}"
end

program mi_flongsep_update_addvarmsg
	args msgno dif m

	scalar `msgno' = `msgno' + 1

	local n : word count `dif'
	local variables = cond(`n'==1, "variable", "variables")

	di as smcl as txt "{p}"
	di as smcl as txt "(`variables'"
	di as smcl as res "`dif'"
	di as smcl as txt "added to {it:m}=`m')"
	di as smcl as txt "{p_end}"
end


local RS	real scalar
local SS	string scalar
local SC	string colvector
local SR	string rowvector

version 11
mata:

void u_mi_chars_save(`SS' indexname, `SS' prefix)
{
	`RS'	i, j
	`SR'	list
	`SC'	fulllist

	fulllist = st_dir("char", "_dta", "*", 0)
	list     = J(1, length(fulllist), "")
	j        = 0
	for (i=1; i<=length(fulllist); i++) { 
		if (bsubstr(fulllist[i], 1, 4)!="_mi_") list[++j] = fulllist[i]
	}

	if (!j) {
		st_local(indexname, "")
		return
	}
	st_local(indexname, invtokens(list))

	for (i=1; i<=j; i++) { 
		st_local(sprintf("%s%g", prefix, i), 
				st_global("_dta[" + list[i] + "]"))
	}
}

void u_mi_chars_put(`SS' indexname, `SS' prefix)
{
	`RS'	i
	`SR'	list

	list = tokens(st_local(indexname))
	for (i=1; i<=length(list); i++) {
		st_global("_dta["+list[i]+"]", 
				st_local(sprintf("%s%g", prefix, i)))
	}
}
end

					/* flongsep editing		*/
/* -------------------------------------------------------------------- */
