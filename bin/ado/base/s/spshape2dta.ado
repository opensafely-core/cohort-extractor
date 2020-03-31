*! version 1.0.12  06apr2017
program define spshape2dta
	version 15

	preserve
	qui drop _all

	syntax anything(id="filename" name=filename)			///
		[, saving(string) replace]

	spshape2dta_get_shp_dbf_name using `filename'
//	returns:
//		shp_file:	.shp filename
//		dbf_file:	.dbf filename
	spshape2dta_get_shp_dbf_dta_name `"`shp_file'"' `"`saving'"' "`replace'"
//	returns:
//		shp_dta_file:	__shp.dta filename
//		dbf_dta_file:	dta filename in memory

	local scol = 3
	di as text _col(`scol') "(importing .shp file)"
	capture noi spshape2dta_import_shp_file `"`shp_file'"'		///
		 `"`shp_dta_file'"' "`replace'"
	nobreak {
		local rc = _rc
		if (`rc') {
			di as err  "could not import .shp file"
			capture erase `"`shp_dta_file'"'
			exit `rc'
		}
	}
//	returns:
//		stype:		.shp file shape type

	di as text _col(`scol') "(importing .dbf file)"
	capture spshape2dta_import_dbf_file `"`dbf_file'"'		///
		`"`shp_dta_file'"' `"`dbf_dta_file'"' "`replace'"
	nobreak {
		local rc = _rc
		if (`rc') {
			di as err  "could not import .dbf file"
			capture erase `"`shp_dta_file'"'
			capture erase `"`dbf_dta_file'"'
			exit `rc'
		}
	}

	capture noi spshape2dta_spset_data `"`shp_dta_file'"'
	nobreak {
		local rc = _rc
		if (`rc') {
			capture erase `"`shp_dta_file'"'
			capture erase `"`dbf_dta_file'"'
			exit `rc'
		}
	}
//	return scalar shape_type = `stype'
	// save spsetting
	capture save "`dbf_dta_file'", replace
	nobreak {
		local rc = _rc
		if (`rc') {
			capture erase `"`shp_dta_file'"'
			capture erase `"`dbf_dta_file'"'
			exit `rc'
		}
	}
//	return local sp_dbf_dta "`dbf_dta_file'"
	di
	di as text `"  file `shp_dta_file' created"'
	di as text `"  file `dbf_dta_file'     created"'
	restore
end

program spshape2dta_get_shp_dbf_name
	syntax using/

	mata:st_local("filename", pathrmsuffix(`"`using'"'))

	local shp_file `"`filename'.shp"'
	local dbf_file : subinstr local shp_file `".shp"' `".dbf"'

	confirm file `"`shp_file'"'
	confirm file `"`dbf_file'"'

	c_local shp_file `"`shp_file'"'
	c_local dbf_file `"`dbf_file'"'
end

program spshape2dta_get_shp_dbf_dta_name
	args shp_file saving replace

	mata:st_local("just_the_file", pathbasename(`"`shp_file'"'))
	if ("`saving'" == "") {
		loc dbf_dta_file : subinstr loc just_the_file ".shp" ".dta"
		loc shp_dta_file : subinstr loc just_the_file ".shp" "_shp.dta"
	}
	else {
		mata:file_has_path(`"`saving'"')
		if (`"`path'"' != "") {
di as err "invalid path"
di as err "    The translated shapefile must be saved to the current directory"
	                exit(601)
		}
		loc dbf_dta_file "`saving'.dta"
		loc shp_dta_file "`saving'_shp.dta"
	}

	if ("`replace'" == "") {
		confirm new file "`shp_dta_file'"
		confirm new file "`dbf_dta_file'"
	}

	c_local shp_dta_file "`shp_dta_file'"
	c_local dbf_dta_file "`dbf_dta_file'"
end

program spshape2dta_import_shp_file
	args shp_file shp_dta_file replace

	qui import_shp using "`shp_file'"
	qui save `"`shp_dta_file'"', `replace'
//	c_local stype : char _dta[shp_type]
end

program spshape2dta_import_dbf_file
	args dbf_file shp_dta_file dbf_dta_file replace
	qui import_dbase using "`dbf_file'", clear

	// must save dbf dta before spsetting
	save "`dbf_dta_file'", `replace'
end

program spshape2dta_spset_data
	args shp_dta_file

	tempvar id
	gen long `id' = _n
	spset `id' using `"`shp_dta_file'"', coordsys(planar)
	drop `id'
	sort _ID
	qui compress _ID
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
end
