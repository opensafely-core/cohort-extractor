*! version 1.0.6  28mar2017
program define spcompress, rclass
	version 15

	syntax [, force]

	spcompress_check_spset

	spcompress_check_shp_dta
	// returns:
	//	shp_dta:		currently linked _shp.dta name

	spcompress_check_dbf_dta ""`force'"
	// returns:
	//	new_shp_dta:		new _shp.dta name
	//	dbf_dta:		dataset name of data in memory

	spcompress_copy_to_new_shp_dta `"`shp_dta'"' `"`new_shp_dta'"'

	capture noi vsp_validate shapefile : drop_shape_id
	if (_rc) {
		char _dta[sp__shp_dta] `"`shp_dta'"'
		if ("`force'" == "") {
			capture erase `"`new_shp_dta'"'
		}
		exit _rc
	}
	local num_ids = `r(sp_num_ids)'
	local num_drop_ids = `r(sp_num_drop_ids)'

	if (`num_drop_ids' > 0) {
		spcompress_output `"`shp_dta'"' `"`new_shp_dta'"'	///
			`"`dbf_dta'"' "`num_ids'" "`num_drop_ids'"
		capture qui save `"`dbf_dta'"', replace
		if (_rc) {
			if ("`force'" == "") {
				capture erase `"`new_shp_dta'"'
			}
			di as err "could not save data in memory"
			exit(601)
		}
		return scalar num_ids = `num_ids'
		return scalar num_drop_ids = `num_drop_ids'
	}
	else {
		di as txt "no action taken or needed"
		di "{p 4 4 2}"
		di as txt "The spatial units in `dbf_dta' and `shp_dta' are identical."
		di as txt "{p_end}"
	}
end

program spcompress_check_spset
	vsp_validate noshapefile
	vsp_validate is_xtset
	if ("`r(panelvar)'" == "") {
		vsp_validate is_id
	}
end

program spcompress_check_shp_dta
	vsp_validate shp_dta
	c_local shp_dta "`r(sp_shp_dta)'"
end

program spcompress_check_dbf_dta
	args shp_dta force

	vsp_validate dbf_dta
	local dbf_dta `"`r(sp_dbf_dta)'"'
	mata:st_local("new_shp_dta", pathrmsuffix(`"`dbf_dta'"'))
	local new_shp_dta `"`new_shp_dta'_shp.dta"'
	
	if ("`force'" == "") {
		confirm new file `"`new_shp_dta'"'
	}
	c_local new_shp_dta `"`new_shp_dta'"'
	c_local dbf_dta `"`dbf_dta'"'
end

program spcompress_copy_to_new_shp_dta
	args shp_dta new_shp_dta

	if (`"`shp_dta'"' != `"`new_shp_dta'"') {
		capture copy `"`shp_dta'"' `"`new_shp_dta'"', replace
		if (_rc) {
			di as err `"cannot copy `shp_dta' to `new_shp_dta'"'
			exit _rc
		}
	}
	char _dta[sp__shp_dta] `"`new_shp_dta'"'
end

program spcompress_output
	args shp_dta new_shp_dta dbf_dta num_recs num_rm_recs
	local fmt_num_recs : display %10.0gc `num_recs'
	local fmt_num_rm_recs : display %10.0gc `num_rm_recs'
	di as txt "{p 2 3 2}"
	di as txt `"(`new_shp_dta' created with `fmt_num_recs' spatial units, `fmt_num_rm_recs' fewer than previously)"'
	di as txt "{p_end}"
	di as txt `"  (`new_shp_dta' saved)"'
	di as txt `"  (`dbf_dta' saved)"'
end

