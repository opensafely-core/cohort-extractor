*! version 1.0.0  31may2019

/////////////////////////////////////////////////////////////////////////////
//
//	Syntax
//
//		vl set [<varlist>] [, options ]
//
//		vl set   	<-- classifies all numeric variables
//		vl set *	<-- same as above
//		vl set _all   	<-- same as above
//
//		vl set ..., clear    <-- clears vl first
//
//		vl set ..., dummy    <-- includes vldummy classification
//
//		vl set ..., update   <-- updates varname chars but does not
//				         change classification;
//					 varname[_vlsysname] is unchanged
//
/////////////////////////////////////////////////////////////////////////////

program vl_set
	version 16

	// allow varlist for update, but error if not already classified

	// vl ..., clear

	syntax [anything]             ///
		[, 		      ///
		DUMmy		      ///
		CATegorical(passthru) ///
		UNCERtain(passthru)   ///
		noNOTEs		      ///
		LIST1		      ///
		LIST(string)	      ///
		CLEAR		      ///
		REDO		      ///
		UPDATE		      ///
		]

	if (c(k) == 0) {
		di as error "no variables defined"
		exit 111
	}
	
	if (c(N) == 0) {
		error 2000
	}

	if (`"`list'"' != "") {
		CheckListOptions, `list'
		local is_list 1
	}
	else if ("`list1'" != "") {
		local is_list 1
	}
	else {
		local is_list 0
	}

	CheckCutoffs, `categorical' `uncertain'
	local categorical `s(categorical)'
	local uncertain   `s(uncertain)'

	opts_exclusive "`clear' `redo' `update'"

	// Done with syntax checking.

	if ("`clear'" != "") {
		vl clear, system
	}

	// Create .vl_util class instance.

	tempname vl stmp utmp
	.`vl' = .vl_util.new, sysmat(`stmp') usermat(`utmp')

	// Check settings dependent on whether an update.

	if ("`update'" != "" | "`redo'" != "") {

		.`vl'.assert_vlsys_set
		local is_set 1
		
		// Need to check if vldummy exists.
		
		.`vl'.is_vldummy is_vldummy
		
		if (`is_vldummy') {
			local dummy dummy
		}

		ParseVarlistUpdate `anything', class(`vl')
		local varlist `r(varlist)'
		
		if ("`redo'" != "") {
			qui vl drop (`varlist')
			local is_update 0
		}
		else {
			local is_update 1
		}
		
		local notes "nonotes"
	}
	else {
		.`vl'.is_vlsys_set is_set
		local is_update 0

		ParseVarlist `anything', class(`vl')
		local varlist `r(varlist)'
	}
	
	// Chars are set when not set and reset when an update (because
	// uncertain cutoff may have changed or vldummy added).

	if (`is_set' & !`is_update') {

		// Adding unclassified variables to vlsys.

		.`vl'.assert_variables_not_in_vlsys `varlist', short

		// Add vldummy class if necessary.

		AddDummyToChars, `dummy'

		.`vl'.update

		// Matrix of counts.

		.`vl'.get_number_of_vlsysnames n

		tempname K

		matrix `K' = J(1, `n', 0)
	}
	else {
		SetChars, `dummy' uncertain(`uncertain')

		.`vl'.update
	}

	// The following is called only to set flags for checks so that
	// every call to -vl list- does not do unnecessary checks.

	.`vl'.assert_vlsys_set

	// Header for -list- option.

	if (`is_list') {
		.`vl'.get_max_length_names varlen : `varlist'
		local list `list' varlength(`varlen')

		vl list, class(`vl') `list' set headeronly
	}

	// Classify varlist.

	foreach x of local varlist {

		local vlsysname  // erase macro

		.`vl'.is_numeric_variable numeric : `x'

		if (`numeric') {

			varclassify `x', categorical(`categorical') ///
					 uncertain(`uncertain')

			SetVLsys vlsysname : `x' `is_update'

			if (`is_set' & !`is_update') {
				.`vl'.get_index_of_vlsysname i : `vlsysname'

				matrix `K'[1, `i'] = `K'[1, `i'] + 1
			}

			if (`is_list') {
				vl list (`x'), class(`vl') `list' sys ///
					       set noheader
			}
		}
		else  {
			SetN `x'

			if (`is_list') {
				vl list (`x'), class(`vl') `list' sys all ///
					       set noheader
			}
		}
	}

	if (`is_list') {
		vl list, class(`vl') `list' set footeronly
		di

		if (!`is_set' | `is_update') {
			di as txt "Summary"
		}
	}
	else {
		di
	}

	if (`is_set' & !`is_update' & "`redo'" == "") {
		di as txt "Added variables"
	}
	else if ("`redo'" != "") {
		di as txt "Reclassified variables"
	}

	vl dir, noblank counts(`K') sys

	if ("`notes'" != "nonotes") {
		DisplayNotes
	}
end

program ParseVarlist, rclass
	syntax [anything] , class(name)

	local vl `class'
	local is_in 0

	if (`"`anything'"' != "") {
		.`vl'.is_namelist_in_master is_in : `"`anything'"' "_all *"
	}

	if (`"`anything'"' == "" | `is_in') {
		.`vl'.get_numeric_variables varlist
		return local varlist `varlist'
		exit
	}

	ParseVarlistNumeric `anything'

	return add
end

program ParseVarlistNumeric, rclass
	syntax varlist(numeric)

	local nvars_before : list sizeof varlist
	local varlist      : list uniq varlist
	local nvars_after  : list sizeof varlist

	if (`nvars_before' != `nvars_after') {
		di as txt "{p 0 6 2}"
		di as txt "note: duplicate variables removed from {it:varlist}"
		di as txt "{p_end}"
	}

	return local varlist `varlist'
end

program ParseVarlistUpdate, rclass
	syntax [anything] , class(name)

	local vl `class'

	if (`"`anything'"' == "") {
		.`vl'.get_vlsys_varlist varlist
		return local varlist `varlist'
		exit
	}

	ParseVarlistNumeric `anything'

	.`vl'.assert_variables_in_vlsys `r(varlist)'

	return add
end

program DisplayNotes

	di as txt "Notes"
	di
	di as txt "{p 6 9 2}"
	di as txt "1. Review contents of {bf:vlcategorical} and"
	di as txt "{bf:vlcontinuous} to ensure they are correct."
	di as txt "Type {bind:{bf:vl list vlcategorical}} and type"
	di as txt "{bind:{bf:vl list vlcontinuous}}."
	di as txt "{p_end}"
	di
	di as txt "{p 6 9 2}"
	di as txt "2. If there are any variables in {bf:vluncertain},"
	di as txt "you can reallocate them to {bf:vlcategorical},"
	di as txt "{bf:vlcontinuous}, or {bf:vlother}."
	di as txt "Type {bind:{bf:vl list vluncertain}}."
	di as txt "{p_end}"
	di
	di as txt "{p 6 9 2}"
	di as txt "3. Use {bf:vl move} to move variables among classifications."
	di as txt "For example, type"
 	di as txt "{bind:{bf:vl move (x50 x80) vlcontinuous}}"
	di as txt "to move variables {bf:x50} and {bf:x80} to the continuous"
	di as txt "classification."
	di as txt"{p_end}"
	di
	di as txt "{p 6 9 2}"
	di as txt "4. {it:vlnames} are global macros."
	di as txt "Type the {it:vlname} without the leading dollar sign"
	di as txt "({bf:$}) when using {bf:vl} commands."
	di as txt "Example: {bf:vlcategorical} {it:not}"
	di as txt "{bf:$}{bf:vlcategorical}."
	di as txt "Type the dollar sign with other Stata commands to get a"
	di as txt "{it:varlist}."
	di as txt "{p_end}"
end

program CheckListOptions, sclass
	syntax [,	       ///
		  MINimum      ///
		  MAXimum      ///
		  OBServations ///
		  LSTRETCH     /// undocumented
		]
end

program CheckCutoffs, sclass 
	syntax [, categorical(numlist integer max=1 >=2 miss)   ///
		  uncertain(  numlist integer max=1 >=0 miss) ]
		  
	// missing is infinity. 
	// uncertain(0) means no "uncertain" category.

	local catset   1
	local uncerset 1

	if ("`categorical'" == "") {
		local categorical 10  // default
		local catset 0
	}

	if ("`uncertain'" == "") {
		local uncertain 100  // default
		local uncerset 0
	}
	else if (`uncertain' == 0) {
		local uncertain `categorical'  // no "uncertain" category
	}

	if (`uncertain' < `categorical') {

		di as err "{bf:uncertain()} must be greater than or equal " _c
		di as err "to {bf:categorical()}"

		if (!`catset') {
			di as err "{p 4 4 2}"
			di as err "{bf:categorical()} at default value"
			di as err "`categorical'."
			di as err "Set {bf:categorical()} to a lower value."
			di as err "{p_end}"
	    	}

		if (!`uncerset') {
			di as err "{p 4 4 2}"
			di as err "{bf:uncertain()} at default value"
			di as err "`uncertain'."
			di as err "Set {bf:uncertain()} to a higher value."
			di as err "{p_end}"
	    	}

		exit 198
	}

	sreturn local categorical `categorical'
	sreturn local uncertain   `uncertain'
end

program SetChars
	syntax , uncertain(numlist integer miss) [ dummy ]

	char _dta[_vl_version_1] 1

	if ("`dummy'" != "") {
		local vldummy vldummy
		char _dta[_vlsys_has_dummy] 1  // so detected on a -merge-
	}

	char _dta[_vlsysnames]  `vldummy'     ///
				vlcategorical ///
				vlcontinuous  ///
				vluncertain   ///
				vlother

	// Descriptions of variables in _vlsysnames.

	local d_dum   `"vldummy `"0/1"'"'
	local d_cat   `"vlcategorical `"categorical"'"'
	local d_cont  `"vlcontinuous `"continuous"'"'
	local d_uncer `"vluncertain `"perhaps continuous, perhaps categorical"'"'
	local d_other `"vlother `"all missing or constant"'"'

	char _dta[_vlsysnames_desc] ///
		`"`d_dum' `d_cat' `d_cont' `d_uncer' `d_other'"'

	// Descriptions of .a, ..., .d coding of _vl_nlevels.

	local d_big  `""integers >=2^31""'
	local d_miss `""all missing""'

	char _dta[_vl_levels_desc] ///
		`"`d_big' negative noninteger `d_miss'"'
end

program AddDummyToChars
	syntax [, dummy ]

	if ("`dummy'" == "") {
		exit
	}

	if (`"`: char _dta[_vlsys_has_dummy]'"' == "") {

		local vlsysnames : char _dta[_vlsysnames]

		char _dta[_vlsysnames] vldummy `vlsysnames'

		char _dta[_vlsys_has_dummy] 1

		local descs : char _dta[_vlsysnames_desc]

		char _dta[_vlsysnames_desc] `"0/1 `descs'"'
	}
end

program SetVLsys
	args macname colon x is_update

	if (`"`: char _dta[_vlsys_has_dummy]'"' != "") {
		IsDummy vlsysname : `x' `is_update'
	}

	if ("`vlsysname'" == "") {
		IsCategorical vlsysname : `x' `is_update'
	}

	if ("`vlsysname'" == "") {
		IsContinuous vlsysname : `x' `is_update'
	}

	if ("`vlsysname'" == "") {
		IsUncertain vlsysname : `x' `is_update'
	}

	if ("`vlsysname'" == "") {
		IsOther vlsysname : `x' `is_update'
	}

	c_local `macname' `vlsysname'
end

program IsDummy
	args macname colon x is_update

	if ("`r(class)'" == "categorical" & "`r(r)'" == "2") {

		cap assert inlist(`x', 0, 1) if `x' < ., fast
		if (c(rc) == 0) {
			if (!`is_update') {

				char `x'[_vlsysname] vldummy

				global vldummy $vldummy `x'

				IncrementNVars
			}

			SetVarChars `x' 2

			c_local `macname' vldummy
		}
		else if (c(rc) != 9) {
			error c(rc)
		}
	}
end

program IsCategorical
	args macname colon x is_update

	if ("`r(class)'" == "categorical") {

		if (!`is_update') {

			char `x'[_vlsysname] vlcategorical

			global vlcategorical $vlcategorical `x'

			IncrementNVars
		}

		SetVarChars `x' `r(r)'

		c_local `macname' vlcategorical
	}
end

program IsContinuous
	args macname colon x is_update

	if ("`r(class)'" == "continuous integer") {
		local nlevels -`r(bound)'
	}
	else if ("`r(class)'" == "big") {
		local nlevels .a
	}
	else if ("`r(class)'" == "negative") {
		local nlevels .b
	}
	else if ("`r(class)'" == "noninteger") {
		local nlevels .c
	}

	// If any of these were true, add to vlcontinuous.

	if ("`nlevels'" != "") {

		if (!`is_update') {

			char `x'[_vlsysname] vlcontinuous

			global vlcontinuous $vlcontinuous `x'

			IncrementNVars
		}

		SetVarChars `x' `nlevels'

		c_local `macname' vlcontinuous
	}
end

program IsUncertain
	args macname colon x is_update

	if ("`r(class)'" == "uncertain") {

		if (!`is_update') {

			char `x'[_vlsysname] vluncertain

			global vluncertain $vluncertain `x'

			IncrementNVars
		}

		SetVarChars `x' `r(r)'

		c_local `macname' vluncertain
	}
end

program IsOther
	args macname colon x is_update

	if ("`r(class)'" == "constant") {
		local nlevels 1
	}
	else if ("`r(class)'" == "all missing") {
		local nlevels .d
	}

	// If either of these were true, add to vlother.

	if ("`nlevels'" != "") {

		if (!`is_update') {

			char `x'[_vlsysname] vlother

			global vlother $vlother `x'

			IncrementNVars
		}

		SetVarChars `x' `nlevels'

		c_local `macname' vlother
	}
end

program SetVarChars
	args x nlevels

	char `x'[_vl_N]       `r(N)'
	char `x'[_vl_min]     `r(min)'
	char `x'[_vl_max]     `r(max)'
	char `x'[_vl_nlevels] `nlevels'
end

program IncrementNVars

	local n : char _dta[_vlsys_nvars]

	if ("`n'" == "") {
		char _dta[_vlsys_nvars] 1
		exit
	}

	confirm integer number `n'

	local ++n

	char _dta[_vlsys_nvars] `n'
end

program SetN
	syntax varname  // intended for string variables

	qui count if !missing(`varlist')

	char `varlist'[_vl_N] `r(N)'
end

exit

-vl set- sets

    char _dta[]

	_dta[_vl_version_1]

	_dta[_vlsysnames]

		vldummy	  	<-- optional
		vlcategorical
		vlcontinuous
		vluncertain
		vlother

	char _dta[_vlsysnames_desc]

	_dta[_vlsys_has_dummy]  <-- for detection on a -merge-

	_dta[_vl_levels_desc]

		all missing
		constant
		noninteger
		negative
		integers >=2^31
		integers >=0

	_dta[_vlsys_nvars]

		number of variables classified

    char varname[]

        varname[_vlsysname]

        	to which vlsysname it belongs

	varname[_vl_nlevels]

		#	when nonnegative integer and
		        # distinct values <= uncertain(#)

		-bound = -uncertain(#)  continuous integer
		.a	big
		.b	negative
		.c	noninteger
		.d	all missing

		(the missing values are flags for which description from
		char _dta[_vl_levels_desc] to use)

        varname[_vl_min]

        	minimum value

        varname[_vl_max]

        	maximum value

        varname[_vl_N]

		number of nonmissing observations

END OF FILE
