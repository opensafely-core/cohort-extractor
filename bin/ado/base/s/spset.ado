*! version 1.0.16  20feb2020
program define spset, rclass
	version 15

	capture syntax 
	if (_rc==0) {
		spset_query
		return add
		exit
	}

	capture syntax, clear
	if (_rc==0) {
		spset_clear
		ret clear
		exit
	}

	gettoken comma rest: 0, parse(" ,")
	if (trim(`"`comma'"') == ",") {
		syntax, MODify [COORDSYS(string asis)			///
			COORD(varlist numeric min=2 max=2) NOCOORD	///
			SHPfile(string)	NOSHPfile DROP]
		spset_modify "`coordsys'" "`coord'" "`nocoord'"		///
			`"`shpfile'"' "`noshpfile'" "`drop'"
		return add
		exit
	}

	gettoken comma rest: rest, parse(" ,")
	if (trim(`"`comma'"') == "," & strpos(`"`rest'"', "modify")>0) {
		syntax varlist(numeric min=1 max=1), modify [replace]
		spset_id_modify `varlist' `replace'
		return add
		exit
	}

	capture spset
	if (_rc==0) {
		di as err "data already {bf:spset}"
		di as err "{p 4 4 2}"
		di as err "Use {bf:spset, clear} first or use {bf:spset, modify}."
		di as err "{p_end}"
		exit(459)
	}

	capture syntax varlist(numeric min=1 max=1)			///
		using/ [, COORDSYS(string asis)]
	if (_rc==0) {
		spset_shapefile `varlist' `"`using'"' "`coordsys'"
		return add
		exit
	}

	syntax varlist(numeric min=1 max=1)				///
		[, COORD(varlist numeric min=2 max=2) COORDSYS(string asis)]
	spset_noshapefile `varlist' "`coord'" "`coordsys'"
	return add
	exit
end

program spset_query, rclass
	vsp_validate noshapefile
	local coordsys "`r(sp_coord_sys)'"

	local shp_dta : char _dta[sp__shp_dta]

	if ("`shp_dta'" != "") {
		vsp_validate shapefile
		local dbf_dta `"`r(sp_dbf_dta)'"'
	}
	vsp_validate dbf_dta
	local sp_dbf_dta `"`r(sp_dbf_dta)'"'

	vsp_validate is_xtset
	local tvar "`r(timevar)'"

	spset_output "`sp_dbf_dta'" "`shp_dta'" "`coordsys'" "`tvar'"

	if("`tvar'" != "") {
		vsp_validate is_panel_id
	}
	else {
		vsp_validate is_id
	}
	spset_return_chars
	return add
end

program spset_zap_chars
	char _dta[sp__shp_dta] ""
	char _dta[sp__coord_sys] ""
	char _dta[sp__coord_sys_dunit] ""
	char _dta[sp__ID] ""
	char _dta[sp__ID_var] ""
	char _dta[sp__CX] ""
	char _dta[sp__CY] ""
	char _dta[sp__ver] ""
end

program spset_clear
	spset_zap_chars
	capture qui drop _ID
	capture qui drop _CX
	capture qui drop _CY 
end

program spset_modify, rclass
	args coordsys coord nocoord shpfile noshpfile drop

	vsp_validate noshapefile

	spset_modify_check_syntax "`coordsys'" "`coord'" "`nocoord'"	///
		`"`shpfile'"' "`noshpfile'" "`drop'"
	
	if ("`coordsys'" != "") {
		spset_set_coordsys "`coordsys'"
	}
	else {
        	local coordsys : char _dta[sp__coord_sys]
	}
	
	if ("`coord'" != "") {
		spset_create_coord_vars "`coord'" "_ID"
		if ("`coordsys'" == "") {
			local coordsys "planar"
		}
		local sp_id_var : char _dta[sp__ID_var]
		spset_set_chars "`sp_id_var'" "`coordsys'" "_CX" "_CY" ""
	}

	if ("`nocoord'" != "") {
		spset_set_nocoords
        	local coordsys ""
	}

	if ("`noshpfile'" != "") {
		spset_set_noshpfile
	}

	if (`"`shpfile'"' != "") {
		vsp_validate is_xtset
		local tvar "`r(timevar)'"

		if ("`tvar'" == "") {
			vsp_validate is_id
		}
		spset_set_shpfile `"`shpfile'"' "`drop'"
		if ("`drop'" != "") {
			local n = `r(sp_num_drop_ids)'
			if (`n' == 1) local v value
			else local v values
			local msg "  (`n' _ID `v' removed from data in memory)"
			return add
		}
		if ("`coordsys'" == "") {
			local coordsys "planar"
		}
		
	}
	vsp_validate dbf_dta
	local sp_dbf_dta `"`r(sp_dbf_dta)'"'

	spset_return_chars
	return add
	spset_output "`sp_dbf_dta'" "`shpfile'" "`coordsys'" "`tvar'"
	di "`msg'"
end

program spset_modify_check_syntax
	args coordsys coord nocoord shpfile noshpfile drop

	if ("`coordsys'" == "" & `"`shpfile'"' == "" &			///
		"`noshpfile'" == "" & "`nocoord'" == "" &		///
		"`coord'" == "" & "`drop'" == "") {
di as err "option required"
di as err "   No {bf:spset, modify <options>} option specified"
		exit(198)
	}
//nocoord checks
	if ("`coordsys'" != "" & "`nocoord'" != "") {
di as err "options {bf:coordsys()} and {bf:nocoord} cannot be combined"
		exit(198)
	}
	if ("`coord'" != "" & "`nocoord'" != "") {
di as err "options {bf:coord()} and {bf:nocoord} cannot be combined"
		exit(198)
	}
	if (`"`shpfile'"' != "" & "`nocoord'" != "") {
di as err "options {bf:shpfile()} and {bf:nocoord} cannot be combined"
		exit(198)
	}
//shpfile checks
	if ("`noshpfile'" != "" & `"`shpfile'"' != "") {
di as err "options {bf:noshpfile} and {bf:shpfile()} cannot be combined"
		exit(198)
	}
	if (`"`shpfile'"' == "" & `"`drop'"' != "") {
di as err "option {bf:drop} requires option {bf:shpfile()}"
		exit(198)
	}
	if ("`coord'" != "" & `"`shpfile'"' != "") {
di as err "options {bf:coord()} and {bf:shpfile()} cannot be combined"
		exit(198)
	}
	local sp_cx : char _dta[sp__CX]
	if ("`coordsys'" != "" & "`sp_cx'" == "") {
di as err "no coordinate variables set"
di
di as err "{p 4 4 2}"
di as err "Type {bf:spset, modify coord(<xvar> <yvar>)} to set coordinate variables."
di as err "{p_end}"
		exit(198)
	}
end

program spset_set_coordsys
	args coordsys

	if (strpos("`coordsys'", ",")>0) {
		gettoken coordsys rest : coordsys, parse(" ,")
        	gettoken comma dunit: rest, parse(" ,")
		local dunit = strtrim("`dunit'")
	}
	local coordsys = strtrim("`coordsys'")
	if ("`dunit'"!="" & "`coordsys'"!="latlong") {
di as err "option {bf:`dunit'} invalid"
di as err "   Syntax is {bf:coordsys(planar)} or {bf:coordys(latlong [,miles | kilometers])}."
		exit(198)
	}
	if ("`coordsys'"=="latlong") {
		if ("`dunit'"=="") {
			local dunit kilometers
		}
		if ("`dunit'"!="miles" & "`dunit'" != "kilometers") {
di as err "option {bf:`dunit'} invalid"
di as err "   Syntax is {bf:coordys(latlong [, kilometers|miles])}."
		exit(198)
		}
	}

	if ("`coordsys'" != "latlong" & "`coordsys'" != "planar") {
di as err "option {bf:`coordsys'} invalid"
di as err "   Syntax is {bf:coordsys(planar)} or {bf:coordys(latlong [,kilometers | miles])}."
		exit(198)
	}
	char _dta[sp__coord_sys] "`coordsys'"
	c_local coordsys "`coordsys'"
	if ("`coordsys'" == "latlong") {
		if ("`dunit'" != "") {
			char _dta[sp__coord_sys_dunit] "`dunit'"
		}
		else {
			char _dta[sp__coord_sys_dunit] kilometers
		}
	}
	else {
		char _dta[sp__coord_sys_dunit]
	}
end

program spset_set_nocoords
	char _dta[sp__coord_sys] ""
	char _dta[sp__CX] ""
	char _dta[sp__CY] ""
	capture qui drop _CX _CY 
end

program spset_set_noshpfile
	char _dta[sp__shp_dta] ""
end

program spset_set_shpfile, rclass
	args shpfile drop

	char _dta[sp__shp_dta] "`shpfile'"
	vsp_validate dbf_dta
	local sp_dbf_dta `"`r(sp_dbf_dta)'"'

	if ("`drop'" != "") {
		capture noi vsp_validate shapefile : drop_attribute_id
		return scalar sp_num_ids = `r(sp_num_ids)'
		return scalar sp_num_drop_ids = `r(sp_num_drop_ids)'
	}
	else {
		capture noi vsp_validate shapefile : check_attribute_id
	}
	if (_rc) {
		char _dta[sp__shp_dta] ""
		exit _rc
	}

	local shp_dta "`r(sp_shp_dta)'"

	local sp_id : char _dta[sp__ID]
	local sys : char _dta[sp__coord_sys]
	local dunit : char _dta[sp__coord_sys_dunit]
	if ("`dunit'" != "") {
		local coordsys "`sys', `dunit'" 
	}
	else {
		local coordsys "`sys'"
	}

	tempvar id
	qui clonevar `id' = `sp_id'
	qui spset, clear

	spset `id' using `"`shp_dta'"', coordsys(`coordsys')
	return add
	global S_FN `"`sp_dbf_dta'"'
end

program spset_return_chars, rclass
	return clear
	local sp_id : char _dta[sp__ID]
	local sp_id_var : char _dta[sp__ID_var]
	local sp_ver : char _dta[sp__ver]
	local sp_cx : char _dta[sp__CX]
	local sp_cy : char _dta[sp__CY]
	local sp_coord_sys : char _dta[sp__coord_sys]
	local sp_coord_sys_dunit : char _dta[sp__coord_sys_dunit]
	local sp_shp_dta : char _dta[sp__shp_dta]

	return local sp_id "`sp_id'"
	return local sp_id_var "`sp_id_var'"
	return local sp_ver "`sp_ver'"
	return local sp_cx "`sp_cx'"
	return local sp_cy "`sp_cy'"
	return local sp_coord_sys "`sp_coord_sys'"
	return local sp_coord_sys_dunit "`sp_coord_sys_dunit'"
	return local sp_shp_dta "`sp_shp_dta'"
end

program spset_id_modify, rclass
	args varlist replace

	vsp_validate noshapefile

	local shp_dta : char _dta[sp__shp_dta]

	if ("`shp_dta'" != "") {
		if ("`replace'" == "") {
di as err "option {bf:replace} required"
di as err "{p 4 4 2}"
di as err "This command reindexes the data in memory and its _shp.dta file.  If the linkage between the files is to continue to work in the future, the reindexed data in memory must be resaved.  To ensure that, this command resaves the data in the in memory.  Type:"
di as err "{p_end}"
di
di as err "       {bf: spset `varlist', modify replace}"
			exit(198)
		}
		vsp_validate is_xtset

		if ("`r(timevar)'" == "") {
			vsp_validate is_id
			vsp_validate is_id : `varlist'
		}
		spset_id_modify_shpdta "`shp_dta'" "`varlist'"
	}
	else {
		if ("`replace'" != "") {
di as err "option {bf:replace} not allowed"
di as err "{p 4 4 2}"
di as err "The data in memory are not linked to a _shp.dta file that would need to be reindexed.  You can change the contents of variable _ID freely.  It is your responsibility to resave the dataset if you want to make the change permanent."
di as err "{p_end}"
			exit(198)
		}
		vsp_validate is_xtset

		if ("`r(timevar)'" == "") {
			vsp_validate is_id : `varlist'
		}
		spset_create_idvar `varlist'
		qui order _ID, first
	}
	unab idvar : `varlist' 
	char _dta[sp__ID_var] `idvar'
	spset
	return add
end

program spset_id_modify_shpdta, rclass
	args shp_dta newidvar

	vsp_validate dbf_dta
	local sp_dbf_dta `"`r(sp_dbf_dta)'"'

	if ("`sp_dbf_dta'" == "") {
di as err "dataset in memory not saved to disk"
di as err "{p 4 4 2}"
di as err "This command reindexes the data in memory and it's _shp.dta file.  To do this, the dataset in memory must be saved so that the linkage between the files will be preserved."
di as err "{p_end}"
		exit(198)
	}

	vsp_validate shapefile_newid : `newidvar'
end

program spset_noshapefile, rclass
	args varlist coord coordsys

	preserve

	spset_zap_chars

	spset_create_idvar `varlist'

	if ("`coord'" == "" & "`coordsys'" != "") {
		di as err "option {bf:coordsys()} requires {bf:coord()}"
		exit(198)
	}

	if ("`coord'" != "") {
		if ("`coordsys'" != "") {
			spset_set_coordsys "`coordsys'"
		}
		else {
			local coordsys "planar"
		}
		spset_create_coord_vars "`coord'" "`varlist'"
		spset_set_chars "`varlist'" "`coordsys'" "_CX" "_CY" ""
	}
	else {
		spset_set_chars "`varlist'" "" "" "" ""
	}

	vsp_validate noshapefile

	capture xtset
	if (_rc != 459 & _rc != 0) {
		di as err "invalid panel setting"
		di as err "    Type {bf:xtset} to view panel data settings."
		exit(459)
	}
	local tvar "`r(timevar)'"

	if ("`tvar'" == "") {
		vsp_validate is_id
	}
	else {
		vsp_validate is_xtset
		if ("`tvar'" != "") {
			vsp_validate is_panel_id
		}
	}

	unab idvar : `varlist' 
	char _dta[sp__ID_var] `idvar'
	vsp_validate dbf_dta
	local sp_dbf_dta `"`r(sp_dbf_dta)'"'

	spset_output "`sp_dbf_dta'" "" "`coordsys'" "`tvar'"

	spset_return_chars
	return add

	restore, not
end

program spset_create_idvar
	args varlist

	if ("`varlist'" == "_ID") {
		tempname newid
		rename _ID `newid'
		qui clonevar _ID = `newid'
		qui drop `newid'
	}
	else {
		capture qui drop _ID
		qui clonevar _ID = `varlist'
	}
	label variable _ID "Spatial-unit ID"
end

program spset_create_coord_vars
	args coord idvar

	local shp_dta : char _dta[sp__shp_dta]
	if (`"`shp_dta'"' != "") {
	di as err "coordinate variables defined and linked to _shp.dta file"
		di as err "{p 4 4 2}"
		di as err "To change coordinate variables use {bf:spset, modify noshpfile} to unlink _shp.dta from data in memory."
		di as err "{p_end}"
		exit(198)
	}

	local cx : word 1 of `coord'
	capture assert "`cx'" != "`idvar'"
	if _rc {
		di as err "`idvar' invalid"
		di as err "     Variable `idvar' multiply specified."
		exit(198)
	}
	if ("`cx'" != "_CX") {
		capture qui drop _CX
		clonevar _CX = `cx'
	}
	else {
		tempname cx
		rename _CX `cx'
		qui clonevar _CX = `cx'
		qui drop `cx'
	}
	local cy : word 2 of `coord'
	capture assert "`cy'" != "`idvar'"
	if _rc {
		di as err "`idvar' invalid"
		di as err "     Variable `idvar' multiply specified."
		exit(198)
	}
	if ("`cy'" != "_CY") {
		capture qui drop _CY
		clonevar _CY = `cy'
	}
	else {
		tempname cy
		rename _CY `cy'
		qui clonevar _CY = `cy'
		qui drop `cy'
	}
end

program spset_shapefile, rclass
	args varlist shp_dta coordsys

	preserve

	spset_zap_chars

	if ("`coordsys'" != "") {
		spset_set_coordsys "`coordsys'"
	}
	else {
		local coordsys "planar"
	}

	noi di as txt "  (creating _ID spatial-unit id)"
	spset_create_idvar `varlist'
	spset_set_chars "_ID" "`coordsys'" "" "" "`shp_dta'"

	vsp_validate is_xtset
	local tvar "`r(timevar)'"
	if ("`tvar'" == "") {
		vsp_validate is_id
	}
	vsp_validate shapefile
	local dbf_dta "`r(sp_dbf_dta)'"
	local shp_dta "`r(sp_shp_dta)'"

	spset_create_coord_vars_shpdta "`shp_dta'" "`tvar'"
	spset_set_chars "_ID" "`coordsys'" "_CX" "_CY" `"`shp_dta'"'

	spset_return_chars
	return add

	qui sort _ID
	restore, not
end

program spset_create_coord_vars_shpdta
	args shp_dta tvar

	tempfile dbf_file

	local filename $S_FN
	qui sort _ID
	qui save `"`dbf_file'"'
	qui drop _all
	qui use `"`shp_dta'"'
	local shp_type : char _dta[shp_type]

	local clist : char _dta[]
	foreach c in `clist' {
		char _dta[`c']
	}
	qui {
		noi di as txt "  (creating _CX coordinate)"
		capture confirm variable shape_order
		if (_rc) {
			qui gen double shape_order = _n
			qui sort _ID shape_order
		}
		// Point data
		if "`shp_type'" == "1" {
			gen double _CX = _X
			noi di as txt "  (creating _CY coordinate)"
			gen double _CY = _Y
		}
		else {
			tempvar x y 
			// _n == 1: _X and _Y missing.
			// _n == 2 and _n == _N are same point.
			// Possible to have islands within _ID,
			// so missing can occur in middle as well.

			// duplicates only once
			local exp (_X < . & _X[_n - 1] < .)

			// Average of _X and _Y.
			by _ID: gen double `x'=				///
				sum(cond(`exp',_X, 0))/sum(`exp')	
			by _ID: gen double `y'=				///
				sum(cond(`exp', _Y, 0))/sum(`exp')

			// Differences from averages.

			local x1 (_X - `x'[_N])
			local x2 (_X[_n + 1] - `x'[_N])

			local y1 (_Y - `y'[_N])
			local y2 (_Y[_n + 1] - `y'[_N])

			local xy (`x1'*`y2' - `x2'*`y1')

			by _ID: gen double _CX = ///
				sum((`x1' + `x2')*`xy')/(3*sum(`xy')) + `x'
				
			noi di as txt "  (creating _CY coordinate)"
				
			by _ID: gen double _CY = ///
				sum((`y1' + `y2')*`xy')/(3*sum(`xy')) + `y'
		}

		lab var _CX "x-coordinate of area centroid"
		lab var _CY "y-coordinate of area centroid"
		label variable _ID "Spatial-unit ID"

		by _ID: keep if _n == _N
		keep _ID _CX _CY

		sort _ID
	}

	if ("`tvar'" != "") {
		local mtype "1:m"
	}
	else {
		local mtype "1:1"
	}

	tempname merge
	qui merge `mtype' _ID using `"`dbf_file'"',		///
		gen(`merge') nonotes
	// drop extra shape _ids that are not matched to data in memory
	qui drop if `merge' == 1
	qui drop `merge'
	global S_FN `"`filename'"'
end

program spset_set_chars
	args _ID coordsys _CX _CY shp_dta

	char _dta[sp__ver] "1"
	char _dta[sp__ID] "_ID"
        char _dta[sp__ID_var] "`_ID'"
	char _dta[sp__coord_sys] "`coordsys'"
	char _dta[sp__CX] "`_CX'"
	char _dta[sp__CY] "`_CY'"
	char _dta[sp__shp_dta] "`shp_dta'"
end

program spset_output, rclass
	args dbf_dta shp_dta coordsys tvar
        local dunit : char _dta[sp__coord_sys_dunit]
        local shp_dta : char _dta[sp__shp_dta]
        local IDvar : char _dta[sp__ID_var]
/*
        local sp_coord_sys : char _dta[sp__coord_sys]
*/
	di as text "{p 2 5 2}"
	di as text `"Sp dataset {bf:`dbf_dta'}"'
	di as text "{p_end}"

	if ("`IDvar'" == "" | "`IDvar'" == "_ID") {
		local ID "_ID"
	}
	else {
		local ID "_ID (equal to `IDvar')"
	}

	if ("`tvar'" != "") {
		di as text "                data:  panel"
		di as text "     spatial-unit id:  `ID'"
		di as text "             time id:  `tvar' (see {bf:xtset})"
	}
	else {
		di as text "                data:  cross sectional"
		di as text "     spatial-unit id:  `ID'"
	}
	if ("`coordsys'" != "") {
		if ("`coordsys'" == "latlong") {
		local coordsys "_CY, _CX (latitude-and-longitude, `dunit')"
		}
		else {
		local coordsys "_CX, _CY (planar)"
		}
		di as text "         coordinates:  `coordsys'"
	}
	else {
		di as text "         coordinates:  none"
	}

	if ("`shp_dta'" != "") {
		di as text "    linked shapefile:  {bf:`shp_dta'}"
	}
	else {
		di as text "    linked shapefile:  none"
	}
end

