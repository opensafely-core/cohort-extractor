*! version 1.0.1  13jun2019
program esrf
	version 16.0

	gettoken sub 0 : 0 , parse(" ,")
	local 0 = subinstr(`"`0'"', `","' , `" , "' , .)
	
 	local len = length(`"`sub'"')
        if `len'==0 {
               di as err "No subcommand specified"
               exit 198
        }

	if (`"`sub'"' == "create") {
		Create `0'
	}
	else if (`"`sub'"' == "clear") {
		Clear
	}
	else if (`"`sub'"' == "rm") {
		Remove `0'
	}
	else if (`"`sub'"' == "rename") {
		Rename `0'
	}
	else if (`"`sub'"' == "copy") {
		Copy `0'
	}
	else if (`"`sub'"' == "sync") {
		Sync `0'
	}
	else if (`"`sub'"' == "post") {
		Post `0'
	}
	else if (`"`sub'"' == "post_stored") {
		PostStored `0'
	}
	else if (`"`sub'"' == "assert") {
		Assert `0'
	}
	else if (`"`sub'"' == "create_savefn") {
		CreateSaveFn `0'		// NotDoc
	}
	else if (`"`sub'"' == "fromeclass") {
		FromEclass `0'			// NotDoc
	}
	else if (`"`sub'"' == "toeclass") {
		ToEclass `0'			// NotDoc
	}
	else if (`"`sub'"' == "add") {
		Add `0'				// NotDoc
	}
	else if (`"`sub'"' == "get") {
		Get `0'				// NotDoc
	}
	else if (`"`sub'"' == "getdate") {
		GetDate `0'			// NotDoc
	}
	else if (`"`sub'"' == "onames") {
		Onames `0'			// NotDoc
	}
	else if (`"`sub'"' == "type") {
		Type `0'			// NotDoc
	}
	else if (`"`sub'"' == "default_filename") {
		DefaultFilename 		// NotDoc
	}
	else if (`"`sub'"' == "get_save_name") {
		GetSaveName `0'			// NotDoc
	}
	else if (`"`sub'"' == "get_store_name") {
		GetStoreName `0'		// NotDoc
	}
 	else {
                di as error `"`sub' unknown subcommand"'
                exit 198
        }
	
	if (`"`s(set)'"' != "") c_local `s(name)' `s(val)'
end

					//----------------------------//
					// create esrf
					//----------------------------//
program Create
	syntax anything(name=filename id=filename) [, subspace(string)]

	mata : esrf_create(`"`filename'"', `"`subspace'"')
end
					//----------------------------//
					// create esrf with saving e(esrf)
					//----------------------------//
program CreateSaveFn
	syntax anything(name=filename id=filename)

	mata : esrf_create_savefn(`"`filename'"')
end

					//----------------------------//
					// delete esrf
					//----------------------------//
program	Remove 
	syntax anything(name=filename id=filename) 	///
		[, nocheck]
	
	if (`"`check'"' == "nocheck") {
		local is_not_check = 1
	}
	else {
		local is_not_check = 0 
	}

	mata : esrf_rm(`"`filename'"', `is_not_check', `"`subspace'"')
end

					//----------------------------//
					// Rename esrf
					//----------------------------//
program Rename
	syntax anything [, replace]
	gettoken from anything : anything
	gettoken to anything : anything

	mata : esrf_rename(`"`from'"', `"`to'"', `"`replace'"')
end

					//----------------------------//
					// Copy esrf
					//----------------------------//
program Copy
	syntax anything [, replace]
	gettoken from anything : anything
	gettoken to anything : anything

	mata : esrf_copy(`"`from'"', `"`to'"', `"`replace'"')
end

					//----------------------------//
					// add one object in esrf
					//----------------------------//
program Add
	cap syntax anything [, subspace(string) ]
	local rc = _rc

	// args filename oname otype obj_value
	gettoken filename anything : anything
	gettoken oname anything : anything
	gettoken otype anything : anything
	gettoken obj_value anything : anything

	local len : list sizeof anything

	if (`len' != 0 | `rc' ) {
		di as err "invalid syntax"
		di "{p 4 4 2}"
		di as err "the full syntax is {bf: esrf add} {it:filename} " ///
			"{it:oname} {it:type} {it:object_value}"
		di "{p_end}"
		exit 198
	}

	local 0 , `otype'
	cap syntax [, scalar macro smatrix mmatrix]

	if _rc {
		di as err "type must be one of scalar, macro, smatrix, mmatrix"
		exit 198
	}

	if (`"`otype'"' == "scalar") {
		cap confirm number `obj_value'
		local rc1 = _rc

		cap confirm scalar `obj_value'
		local rc2 = _rc

		if (`rc1' != 0 & `rc2' != 0 ) {
			di as err "`obj_value' found where a scalar expected"
			exit 111
		}

	}
	else if (`"`otype'"' == "smatrix") {
		confirm matrix `obj_value'
	}
	else if (`"`otype'"' == "mmatrix") {
		cap mata : assert(findexternal(`"`obj_value'"') != NULL)
		if _rc {
			di as err "`obj_value' found where mata matrix expected"
			exit 111
		}
	}

	if (`"`otype'"' == "macro" | `"`otype'"' ==  `"`smatrix'"') {
		local obj_value `""`obj_value'""'
	}

	cap confirm scalar `obj_value'
	if (_rc == 0) {
		local obj_value = `obj_value'
	}

	mata : esrf_add(`"`filename'"', `"`oname'"', 	///
		`"`otype'"', `obj_value', `"`subspace'"')
end

					//----------------------------//
					// get object value
					//----------------------------//
program Get, sclass
	cap _on_colon_parse `0'	

	local rc = _rc
	local _x `s(before)'
	local 0 `s(after)'

	cap syntax anything(name=oname) [, subspace(string) using(string) ]
	local rc = _rc + `rc'

	local l1 : list sizeof _x
	local l2 : list sizeof oname 

	if (`l1' != 1 | `l2' != 1 | `rc' != 0 ) {
		di as err "invalid syntax"
		di "{p 4 4 2}"
		di as err "the syntax should be {bf: esrf get} {it:x} "	///
			"{bf::} {it:oname}, using(filename)"
		di "{p_end}"
		exit 198
	}

	cap confirm name `_x'
	if (_rc) {
		di as err "`_x' found where name expected"
		exit 198
	}

	if (`"`using'"' == "") {
		esrf default_filename
		local using `s(stxer_default)'
	}

	mata : st_esrf_get(`"`_x'"', `"`using'"', 	///
		`"`oname'"', `"`subspace'"')
	
	if (`"``_x''"' != "") {
		sret local name `_x'
		sret local val ``_x''
		sret local set set_local
	}
end
					//----------------------------//
					// get date
					//----------------------------//
program GetDate , sclass

	cap _on_colon_parse `0'	

	local rc = _rc
	local _x `s(before)'
	local fn `s(after)'

	local l1 : list sizeof _x
	local l2 : list sizeof fn

	if (`l1' != 1 | `l2' != 1 | `rc' != 0 ) {
		di as err "invalid syntax"
		di "{p 4 4 2}"
		di as err "the syntax should be {bf: esrf getdate} {it:x} " ///
			"{bf::} {it:filename}"
		di "{p_end}"
		exit 198
	}

	mata : st_esrf_getdate(`"`_x'"', `"`fn'"')

	if (`"``_x''"' != "") {
		sret local set set_local
		sret local name `_x'
		sret local val ``_x''
	}
end
					//----------------------------//
					// get onames
					//----------------------------//
program Onames, sclass

	cap _on_colon_parse `0'	

	local rc = _rc
	local _x `s(before)'
	local 0 `s(after)'

	cap syntax anything(name=fn) [, subspace(string)]
	local rc = `rc' + _rc
	
	local l1 : list sizeof _x
	local l2 : list sizeof fn

	if (`l1' != 1 | `l2' != 1 | `rc' != 0 ) {
		di as err "invalid syntax"
		di "{p 4 4 2}"
		di as err "the syntax should be {bf: esrf onames} {it:x} " ///
			"{bf::} {it:filename}"
		di "{p_end}"
		exit 198
	}

	mata : st_esrf_onames(`"`_x'"', `"`fn'"', `"`subspace'"')

	if (`"``_x''"' != "") {
		sret local set set_local
		sret local name `_x'
		sret local val ``_x''
	}
end

					//----------------------------//
					// get object value
					//----------------------------//
program Type, sclass
	cap _on_colon_parse `0'	

	local rc = _rc
	local _x `s(before)'
	local 0 `s(after)'

	cap syntax anything(name=after) [, subspace(string)]
	local rc = `rc' + _rc

	local l1 : list sizeof _x
	local l2 : list sizeof after

	if (`l1' != 1 | `l2' != 2 | `rc' != 0 ) {
		di as err "invalid syntax"
		di "{p 4 4 2}"
		di as err "the syntax should be {bf: esrf type} {it:x} " ///
			"{bf::} {it:filename} {it:oname}"
		di "{p_end}"
		exit 198
	}

	cap confirm name `_x'
	if (_rc) {
		di as err "`_x' found where name expected"
		exit 198
	}

	gettoken filename oname : after
	local filename = ustrtrim(`"`filename'"')
	local oname = ustrtrim(`"`oname'"')

	cap confirm name `oname'
	if (_rc) {
		di as err "`oname' found where name expected"
		exit 198
	}

	mata : st_esrf_type(`"`_x'"', `"`filename'"', 	///
		`"`oname'"', `"`subspace'"')
	
	if (`"``_x''"' != "") {
		sret local name `_x'
		sret local val ``_x''
		sret local set set_local
	}
end
					//----------------------------//
					// sync
					//----------------------------//
/*
	put what's in e() to the esrf file
	put what's in the esrf file to e()

	Note :
	
	If there is already e() in memory, sync do a -ereturn repost-, so the
	old e() is NOT erased.

	If there is no e() in memory, sync do a -ereturn post-
*/

program Sync, eclass
	syntax anything(name=filename id=filename) [, subspace(string)]

	tempname est_old
	cap _est hold `est_old', copy
	local rc_old = _rc

	cap noi {
		mata : st_esrf_sync(`"`filename'"', `"`subspace'"')
	}
	local rc_new = _rc

	if (`rc_old' == 0 & `rc_new' != 0) {
		qui _est unhold `est_old'
		exit `rc_new'
	}
end
					//----------------------------//
					// Post
					//----------------------------//
/*
	1. ereturn clear
	2. puts what's in an esrf file into e()
*/
program Post, eclass
	syntax anything(name=filename id=filename) [, subspace(string)]

	tempname est_old
	cap _est hold `est_old', copy
	local rc_old = _rc

	cap noi {
		ereturn clear
		mata : st_esrf_sync(`"`filename'"', `"`subspace'"')
	}
	local rc_new = _rc

	if (`rc_old' == 0 & `rc_new' != 0) {
		qui _est unhold `est_old'
		exit `rc_new'
	}
end
					//----------------------------//
					// Post stored estimation results
					//----------------------------//
/*
	1. ereturn clear
	2. puts what's in an esrf file into e()
*/
program PostStored, eclass
	syntax [anything(name=est)] [, *]

	if (`"`est'"' == ".") {
		esrf default_filename 
		local fn `s(stxer_default)'
	}
	else {
		esrf get_store_name `est'
		local fn `s(stxer_stname)'
	}

	esrf post `fn', `options'
end
					//----------------------------//
					// From e()
					//----------------------------//
/*
	puts a specific element in e() into the esrf file
*/
program FromEclass
	syntax anything(name=filename id=filename)	///
		[, pattern(string) subspace(string) replace ]

	mata : st_esrf_from_eclass(`"`filename'"', `"`pattern'"', 	///
		`"`subspace'"', `"`replace'"')
end

					//----------------------------//
					// To e()
					//----------------------------//
/*
	puts a specific element in the esrf file into e()
*/
program ToEclass, eclass
	syntax anything(name=filename id=filename) 	///
		[, pattern(string) subspace(string)]

	tempname est_old
	cap _est hold `est_old', copy
	local rc_old = _rc

	cap noi {
		ereturn clear
		mata : st_esrf_to_eclass(`"`filename'"', `"`pattern'"',	///
			`"`subspace'"')
	}
	local rc_new = _rc

	if (`rc_old' == 0 & `rc_new' != 0) {
		qui _est unhold `est_old'
		exit `rc_new'
	}
end

					//----------------------------//
					// assert esrf file
					//----------------------------//
program Assert
	syntax anything(name=filename id="stxer filename")	

	mata : esrf_assert_file(`"`filename'"')	
end

					//----------------------------//
					// default filename
					//----------------------------//
program DefaultFilename, sclass
	mata : st_global("s(stxer_default)", _esrf_default_filename())
end

					//----------------------------//
					// get save name
					//----------------------------//
program GetSaveName, sclass
	syntax anything(name=stname) , slot_num(string)
	
	mata : st_global("s(stxer_save_name)", 	///
		_esrf_get_save_name(`"`stname'"', `slot_num'))
end
					//----------------------------//
					// get save name
					//----------------------------//
program GetStoreName, sclass
	syntax anything(name=stname)
	
	mata : st_global("s(stxer_stname)", _esrf_get_store_name(`"`stname'"'))
end

					//----------------------------//
					// clear current esrf file
					//----------------------------//
program Clear
	esrf default_filename
	local fn `s(stxer_default)'
	esrf rm `fn', nocheck
end
