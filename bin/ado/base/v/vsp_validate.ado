*! version 1.0.12  09sep2019
program define vsp_validate, rclass
	version 15

	gettoken type opts : 0, parse(":")
	local type = trim("`type'")
	gettoken colon opts : opts, parse(":")
	local opts = trim("`opts'")

	if ("`type'" == "noshapefile") {
		vsp_validate_noshapefile
		return local sp_idvar "`sp_idvar'"
		return local sp_ver "`sp_ver'"
		return local sp_cx "`sp_cx'"
		return local sp_cy "`sp_cy'"
		return local sp_coord_sys "`sp_coord_sys'"
		return local sp_coord_sys_dunit "`sp_coord_sys_dunit'"
	}
	else if ("`type'" == "shapefile") {
		vsp_validate_shp_dta
		return local sp_shp_dta "`sp_shp_dta'"
		vsp_validate_dbf_dta
		return local sp_dbf_dta "`sp_dbf_dta'"

		if ("`opts'" == "check_attribute_id") {
			vsp_validate_sync_ids "`sp_shp_dta'" "attribute_id"
			exit
		}
		else if ("`opts'" == "check_shape_id") {
			vsp_validate_sync_ids "`sp_shp_dta'" "shape_id"
			exit
		}
		else if ("`opts'" == "check_both_id") {
			vsp_validate_sync_ids "`sp_shp_dta'" "both_id"
			exit
		}
		else if ("`opts'" == "drop_attribute_id") {
			vsp_validate_sync_ids "`sp_shp_dta'" "drop_attribute_id"
			return scalar sp_num_drop_ids = `num_drop_ids'
			return scalar sp_num_ids = `num_ids'
			exit
		}
		else if ("`opts'" == "drop_shape_id") {
			vsp_validate_sync_ids "`sp_shp_dta'" "drop_shape_id"
			return scalar sp_num_drop_ids = `num_drop_ids'
			return scalar sp_num_ids = `num_ids'
			exit
		}
		if ("`opts'" != "") {
			di as err "invalid vsp_validate option"
			exit 198
		}
	}
	else if ("`type'" == "shapefile_newid") {
		vsp_validate_shp_dta
		return local sp_shp_dta "`sp_shp_dta'"
		vsp_validate_dbf_dta
		return local sp_dbf_dta "`sp_dbf_dta'"
		vsp_validate_sync_newid "`sp_shp_dta'" "`opts'"
	}
	else if ("`type'" == "shp_dta") {
		vsp_validate_shp_dta
		return local sp_shp_dta "`sp_shp_dta'"
	}
	else if ("`type'" == "dbf_dta") {
		vsp_validate_dbf_dta
		return local sp_dbf_dta "`sp_dbf_dta'"
	}
	else if ("`type'" == "is_xtset") {
		vsp_validate_is_xtset
		ret add
	}
	else if ("`type'" == "is_id") {
		vsp_validate_isid "`opts'"
	}
	else if ("`type'" == "is_panel_id") {
		vsp_validate_is_panel_id
	}
	else {
		// should not happen
		di as err "invalid vsp_validate subcommand"
		exit 198
	}
end

program vsp_validate_noshapefile
	local sp_idvar : char _dta[sp__ID]
	local sp_ver : char _dta[sp__ver]
	local sp_coord_sys : char _dta[sp__coord_sys]
	local sp_coord_sys_dunit : char _dta[sp__coord_sys_dunit]

	if (c(k)==0 & _N==0) {
		error 3
	}

	if ("`sp_idvar'" == "" | "`sp_ver'" == "") {
		di as err "data not {bf:spset}"
		exit(459)
	}
	capture assert "`sp_ver'" == "1"
	if (_rc) {
		di as err "Sp version invalid"
		exit(459)
	}
	capture confirm variable `sp_idvar'
	if _rc {
		di as err "variable `sp_idvar' not found"
		exit(111)
	}

	if ("`sp_coord_sys'" != "") {
		vsp_validate_coord_sys "`sp_coord_sys'" "`sp_coord_sys_dunit'"
		c_local sp_coord_sys "`sp_coord_sys'"
		c_local sp_coord_sys_dunit "`sp_coord_sys_dunit'"
	}

	// check _CX, _CY, system variables
	local sp_cx : char _dta[sp__CX]
	local sp_cy : char _dta[sp__CY]
	if ("`sp_cx'" != "" | "`sp_cx'" != "") {
		capture confirm numeric variable `sp_cx'
		if (_rc) {
			di as err "variable _CX not found"
			exit(111)
		}
		capture confirm numeric variable `sp_cy'
		if (_rc) {
			di as err "variable _CY not found"
			exit(111)
		}
		c_local sp_cx "`sp_cx'"
		c_local sp_cy"`sp_cy'"
	}

	c_local sp_idvar "`sp_idvar'"
	c_local sp_ver "`sp_ver'"
end

program vsp_validate_coord_sys
	args sp_coord_sys sp_coord_sys_dunit

	if ("`sp_coord_sys'"!="planar" & "`sp_coord_sys'"!="latlong"){
		di as err "{bf:`sp_coord_sys'}: invalid coordinate system"
		exit(459)
	}
	if ("`sp_coord_sys_dunit'" != "") {
		if ("`sp_coord_sys'"!="latlong") {
di as err "{bf:`sp_coord_sys_dunit'} invalid coordinate system distance unit for planar"
			exit(459)
		}
		if ("`sp_coord_sys_dunit'"!="miles" &			///
			"`sp_coord_sys_dunit'"!="kilometers") {
di as err "{bf:`sp_coord_sys_dunit'} invalid coordinate system distance unit"
			exit(459)
		}
	}
end

program vsp_validate_shp_dta
	local sp_shp_dta : char _dta[sp__shp_dta]

	if (`"`sp_shp_dta'"' == "") {
		di as err "Sp data not linked to shapefile"
		di as txt "{p 4 4 2}"
		di as err "Type {bf:spset, modify filename(<filename>_shp.dta)}"
		di as err " to link a _shp.dta file to the dataset in memory."
		di as txt "{p_end}"
		exit(601)
	}
	// remove path and check current directory for file
	mata:file_has_path(`"`sp_shp_dta'"')
	if (`"`path'"' != "") {
di as err `"_shp.dta not found"'
di as err `"    The translated shapefile must be in the current directory"'
		exit(601)
	}

	mata:st_local("ext", pathsuffix(`"`sp_shp_dta'"'))
	if ("`ext'" == "") {
		local sp_shp_dta `"`sp_shp_dta'.dta"'
	}

	capture confirm file `"`sp_shp_dta'"'
	if (_rc) {
di as err `"_shp.dta not found"'
di as err `"    The translated shapefile must be in the current directory"'
		exit(601)
	}
	c_local sp_shp_dta `"`sp_shp_dta'"'
end

program vsp_validate_dbf_dta
	mata:st_local("sp_dbf_dta", pathbasename(`"$S_FN"'))
	c_local sp_dbf_dta `"`sp_dbf_dta'"'
/*
	mata:st_local("sp_dbf_dta", pathbasename(`"$S_FN"'))
	capture confirm file `"`sp_dbf_dta'"'
	if (_rc) {
		di as err `"file not found"'
		di as err "{p 4 4 2}"
		di as err `"Both _shp.dta and the data in memory "'
		di as err "must be saved in your current directory"
		di as err "{p_end}"
		exit(601)
	}

	c_local sp_dbf_dta `"`sp_dbf_dta'"'
*/
end

program vsp_validate_sync_ids
	args shp_dta check_type

	tempfile tmp_dbf
	local error = 0

	preserve

	vsp_validate_is_xtset

	if("`r(timevar)'" != "") {
		qui bysort _ID : keep if _n == 1
	}

	qui keep _ID
	local clist : char _dta[]
	foreach c in `clist' {
		char _dta[`c']
	}
	qui sort _ID
	qui save "`tmp_dbf'", replace

	qui use `"`shp_dta'"', clear
	tempname merge
	capture merge m:1 _ID  using `"`tmp_dbf'"', gen(`merge') nonotes
	if (_rc == 111) {
		di as err "variable _ID not found in _shp.dta"
		exit _rc
	}
	if ( _rc != 0) {
		di as err "problem matching _ID variable in _shp.dta"
		exit _rc
	}

	if ("`check_type'" == "attribute_id") {
		vsp_validate_check_attribute_ids `merge' `"`shp_dta'"'
	}
	else if ("`check_type'" == "shape_id") {
		vsp_validate_check_shape_ids `merge' `"`shp_dta'"'
	}
	else if ("`check_type'" == "both_id") {
		vsp_validate_check_attribute_ids `merge' `"`shp_dta'"'
		vsp_validate_check_shape_ids `merge' `"`shp_dta'"'
	}
	else if ("`check_type'" == "drop_shape_id") {
		vsp_validate_check_attribute_ids `merge' `"`shp_dta'"'
		vsp_validate_drop_shape_ids `merge'
		c_local num_drop_ids "`num_drop_ids'"
		c_local num_ids "`num_ids'"
	}
	else if ("`check_type'" == "drop_attribute_id") {
		vsp_validate_get_drop_attr_ids `merge' `"`shp_dta'"'
		c_local num_drop_ids "`num_drop_ids'"
		c_local num_ids "`num_ids'"
	}

	restore

	if ("`check_type'" == "drop_attribute_id") {
		if (`num_drop_ids' > 0) {
			vsp_validate_drop_attribute_ids `merge' `"`shp_dta'"'
		}
	}
end

program vsp_validate_sync_newid
	args shp_dta newid

	tempfile tmp_dbf
	local error = 0

	preserve
	vsp_validate_is_xtset

	if("`r(timevar)'" != "") {
		qui bysort _ID : keep if _n == 1
	}
	qui keep _ID `newid'

	local clist : char _dta[]
	foreach c in `clist' {
		char _dta[`c']
	}
	qui sort _ID
	qui save "`tmp_dbf'", replace

	qui use `"`shp_dta'"', clear
	capture confirm variable shape_order
	if (_rc) {
		qui gen double shape_order = _n
	}
	tempname merge
	qui sort _ID
	capture merge m:1 _ID using "`tmp_dbf'", gen(`merge') nonotes
	if (_rc == 111) {
		di as err "variable _ID not found in _shp.dta"
		exit _rc
	}
	if ( _rc != 0) {
		di as err "problem matching _ID variable in _shp.dta"
		exit _rc
	}

	vsp_validate_check_attribute_ids `merge' "`shp_dta'"
	vsp_validate_check_shape_ids `merge' `"`shp_dta'"'

	qui drop `merge'
	if ("`newid'" != "_ID") {
		qui drop _ID
		qui rename `newid' _ID
	}
	qui order _ID
	qui sort _ID shape_order
	qui compress
	nobreak {
		qui save, replace
		di as text "  (_shp.dta file saved)"

		restore
		if ("`newid'" != "_ID") {
			qui drop _ID
			qui clonevar _ID = `newid'
			label variable _ID "Spatial-unit ID"
		}
		qui order _ID
		qui save, replace
		di as text "  (data in memory saved)"
	}
end

program vsp_validate_check_attribute_ids
	args merge shp_dta

	qui count if `merge' == 2
	if (`r(N)' != 0) {
		tempvar touse
		qui bys _ID : gen byte `touse' = 1 if `merge' == 2 & _n == 1
		qui count if `touse' == 1
		local id_count `r(N)'
		qui drop `touse'
		if (`id_count' > 1) {
			local value "values"
			local do_not "do not"
			local s "s"
		}
		else {
			local value "value"
			local do_not "does not"
			local s ""
		}
di as err "_ID contains invalid values"
di as txt "{p 4 4 2}"
di as err `"_ID contains `id_count' `value' that `do_not' appear in `shp_dta'."'
di as err "If you want to drop not-on-the-map observation`s', use {bf:spset}"
di as err " with the {bf:drop} option."
di as txt "{p_end}"
di
di as err _col(8) `"{bf:spset, modify shpfile("`shp_dta'") drop}"'
di
di as txt "{p 4 4 2}"
di as err "Alternatively, find and drop the observations yourself."
di as txt "{p_end}"
		exit(459)
	}
end

program vsp_validate_check_shape_ids
	args merge shp_dta

	qui count if `merge' == 1
	if (`r(N)' != 0) {
		tempvar touse
		qui bys _ID : gen byte `touse' = 1 if `merge' == 1 & _n == 1
		qui count if `touse' == 1
		local id_count `r(N)'
		qui drop `touse'
di as err "data do not contain observations for all spatial units"
di as txt "{p 4 4 2}"
di as err `"File `shp_dta' defines places not in the data in memory."'
di as err `"You can drop the extra places from the _shp.dta file using"'
di as err "{bf:spcompress}."
di as txt "{p_end}"
		exit(459)
	}
end

program vsp_validate_drop_shape_ids
	args merge

	qui count if `merge' == 1
	if (`r(N)' != 0) {
		tempvar touse
		qui bys _ID : gen byte `touse' = 1 if `merge' == 1 & _n == 1
		qui count if `touse' == 1
		local num_drop_ids `r(N)'
		c_local num_drop_ids  `num_drop_ids'
		qui drop `touse'
		local num_rec : char _dta[shp_num_records]
		local num_rec = `num_rec' - `num_drop_ids'
		if (`num_rec' <= 0 | `num_rec' > 70000000) {
		di as err `"`num_rec': invalid number of records in _shp.dta"'
			exit(625)
		}
		char _dta[shp_num_records] `num_rec'
		c_local num_ids  "`num_rec'"
		qui drop if `merge' == 1
		qui drop `merge'
		nobreak {
			sort _ID shape_order
			capture save, replace
			if _rc {
				di as err "could not save new _shp.dta file"
				exit _rc
			}
		}
	}
	else {
		c_local num_drop_ids  0
		local num_rec : char _dta[shp_num_records]
		c_local num_ids  `num_rec'
	}
end

program vsp_validate_get_drop_attr_ids
	args merge shp_dta

	qui count if `merge' == 2
	if (`r(N)' != 0) {
		tempvar touse
		qui bys _ID : gen byte `touse' = 1 if `merge' == 2 & _n == 1
		mata:vsp_validate__get_attribute_ids("`touse'")
		qui drop `touse'
		c_local num_drop_ids  `num_drop_ids'

		local num_rec : char _dta[shp_num_records]
		if (`num_rec' <= 0 | `num_rec' > 70000000) {
			di as err `"invalid number of records in __shp.dta"'
			exit(625)
		}
		c_local num_ids  "`num_rec'"
	}
	else {
		c_local num_drop_ids  0
		local num_rec : char _dta[shp_num_records]
		c_local num_ids  `num_rec'
	}
end

program vsp_validate_drop_attribute_ids
	args merge shp_dta

	mata:vsp_validate__drop_attribute_ids()
end

program vsp_validate_is_xtset, rclass
	capture xtset
	if (_rc != 459 & _rc != 0) {
		di as err "invalid panel setting"
		di as err "    Type {bf:xtset} to view panel data settings."
		capture noi xtset
		exit(459)
	}
	if ("`r(panelvar)'" != "" & "`r(panelvar)'" != "_ID") {
		vsp_validate_re_xtset "`r(panelvar)'" "`r(timevar)'"	///
			"`r(tdeltas)'" "`r(unit)'"
	}
	if ("`r(panelvar)'" != "" & "`r(balanced)'" != "strongly balanced") {
		di as err "data not strongly balanced"
		di as txt "{p 4 4 2}"
		di as err "    Use {bf:spbalance} to balance the data.  Then type {bf:spset} again to verify that all went well."
		di as txt "{p_end}"
		exit(459)
	}

	return add
end

program vsp_validate_re_xtset, sortpreserve
	args panelvar timevar delta unit
	qui sort `panelvar'
	capture qui by `panelvar' : assert _ID == _ID[1]
	if _rc {
		di as err "`panelvar' and _ID do not identify the same panels"
		exit(459)
	}
	local opts ""
	if ("`delta'" != "" | ("`unit'" != "" & "`unit'" != ".")) {
		local opts ", "
		if ("`delta'" != "") {
			local delta : subinstr local delta "units" "", all
			local delta : subinstr local delta "unit" "", all
			local opts "`opts' delta(`delta')"
		}
		if ("`unit'" != "" & "`unit'" != ".") {
			local opts "`opts' `unit'"
		}
	}
	capture qui xtset _ID `timevar' `opts'
	if (_rc == 451) {
		di as err "Panels and spatial units inconsistent"
		di as txt "{p 4 4 2}"
		di as err "Data are xtset on `panelvar'--`timevar'. "
		di as err "`panelvar' identifies"
		di as err " the panels.  Sp's _ID identifies the spatial"
		di as err " units.  Panels and spatial units must be"
		di as err "coincident."
		di as txt "{p_end}"
		exit(451)
	}
end

program vsp_validate_isid
	args newid

	if ("`newid'" != "") {
		local sp_idvar `newid'
	}
	else {
		local sp_idvar : char _dta[sp__ID]
	}

	capture noisily isid `sp_idvar' // isid will issue error message
	local rc = _rc
	if (`rc') {
		vsp_validate_isid_errmsg `sp_idvar' // additional message
		exit(`rc')
	}
end

program vsp_validate_isid_errmsg, sortpreserve
	args sp_idvar
	
	capture assert !missing(`sp_idvar')
	if (_rc) {
		exit
	}
	
	tempvar N

	qui bysort `sp_idvar': gen double `N' = _N if _n == 1

	summarize `N', meanonly 
	
	// If `N' averages to 2 or more, could be panel data.

	if (r(mean) >= 2) {	
		di as txt "    Do these data need to be {bf:xtset}?"
	}
end	
	
program vsp_validate_is_panel_id
	capture xtset
	if (_rc == 0) {
		if ("`r(balanced)'" != "strongly balanced") {
di as text "  (data are not strongly balanced; run {bf:spbalance})"
		}
	}
end

version 15.0

mata:
mata set matastrict on

void file_has_path(string scalar path)
{
	string scalar		path1,filename

	path1 = ""
	filename = ""
	pathsplit(path, path1, filename)

	st_local("path", path1)
}

void vsp_validate__get_attribute_ids(string scalar touse)
{
	pointer() scalar	 p
	real scalar		ID_touse
	real colvector		ids

	ID_touse = 0
	rmexternal("vsp_validate__attr_drop_ids")
	p = crexternal("vsp_validate__attr_drop_ids")
	st_view(ID_touse, ., ("_ID", touse), 0)
	ids = ID_touse[.,1]
	*p = ids
	st_local("num_drop_ids", strofreal(rows(ids)))
}

void vsp_validate__drop_attribute_ids()
{
	real scalar		i, rows
	string scalar		cmd
	pointer(real)		 p
	real colvector		ids

	p = findexternal("vsp_validate__attr_drop_ids")
	rows  = rows(*p)
	ids = *p
	for (i=1; i<=rows;i++) {
		cmd = sprintf("drop if _ID == %f", ids[i])
		stata(cmd, 1)
	}
	rmexternal("vsp_validate__attr_drop_ids")
}
end

