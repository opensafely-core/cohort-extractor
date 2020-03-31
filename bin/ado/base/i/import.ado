*! version 1.1.2  27sep2018
program define import
	version 12
	local version : di "version " string(_caller()) ":"

	gettoken subcmd 0 : 0, parse(" ,")

	if `"`subcmd'"' == "dbase" {
		`version' ImpDbase `macval(0)'
	}
	else if `"`subcmd'"' == "delim" {
		`version' ImpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimi" {
		`version' ImpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimit" {
		`version' ImpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimite" {
		`version' ImpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimited" {
		`version' ImpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "exc" {
		ImpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "exce" {
		ImpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "excel" {
		ImpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "fred" {
		ImpFred `macval(0)'
	}
	else if `"`subcmd'"' == "hav" {
		ImpHaver `macval(0)'
	}
	else if `"`subcmd'"' == "have" {
		ImpHaver `macval(0)'
	}
	else if `"`subcmd'"' == "haver" {
		ImpHaver `macval(0)'
	}
	else if `"`subcmd'"' == "sas" {
		ImpSas `macval(0)'
	}
	else if `"`subcmd'"' == "sasxport5" {
		ImpSasxport5 `macval(0)'
	}
	else if `"`subcmd'"' == "sasxport8" {
		ImpSasxport8 `macval(0)'
	}
	else if `"`subcmd'"' == "sasxport" {
		if (_caller() < 16) {
			ImpSasxport5 `macval(0)'
		}
		else {
			di as error "invalid syntax"
			di as error "   specify either {cmd:import sasxport5} or {cmd:import sasxport8}"
			exit 198
		}
	}
	else if `"`subcmd'"' == "shp" {
		ImpShape `macval(0)'
	}
	else if `"`subcmd'"' == "spss" {
		ImpSpss `macval(0)'
	}
	else {
		display as error `"import: unknown subcommand "`subcmd'""'
		exit 198
	}

end

program ImpDbase
	version 15
	local version : di "version " string(_caller()) ":"

	scalar ImpDbaseCleanUp = -1
	capture noi import_dbase `macval(0)'

	nobreak {
		local rc = _rc
		if `rc' {
			if ImpDbaseCleanUp >= 0 {
				mata : fclose(st_numscalar("ImpDbaseCleanUp"))
			}
		}
	}
	scalar drop ImpDbaseCleanUp
	exit `rc'
end

program ImpDelim
	version 13
	local version : di "version " string(_caller()) ":"
	`version' import_delimited `macval(0)'
end

program ImpExcel
	version 12

	scalar ImpExcelCleanUp = -1
	capture noi import_excel `macval(0)'

	nobreak {
		local rc = _rc
		if `rc' {
			if ImpExcelCleanUp >= 0 {
				mata : import_excel_cleanup()
			}
		}
	}
	scalar drop ImpExcelCleanUp
	exit `rc'
end

program ImpFred
	version 14

	capture noi import_fred `macval(0)'

	nobreak {
		local rc = _rc
	}
	exit `rc'
end

program ImpHaver
	version 12

	capture noi import_haver `macval(0)'

	nobreak {
		local rc = _rc
		if `rc' {
			mata : import_haver_cleanup()
		}
	}
	exit `rc'
end

program ImpSas
	version 16

	capture noi import_sas `macval(0)'
	nobreak {
		local rc = _rc
	}
	exit `rc'
end

program ImpSasxport5
	capture syntax [anything] , Describe [*]
	if _rc==0 {
		fdadescribe `anything', `options'
		exit
	}

	fdause `macval(0)'
end

program ImpSasxport8
	version 16

	capture noi import_sasxport8 `macval(0)'
	nobreak {
		local rc = _rc
	}
	exit `rc'
end

program ImpShape
	version 15

	scalar ImpShapeCleanUp = -1
	capture noi import_shp `macval(0)'

	nobreak {
		local rc = _rc
		if `rc' {
			if ImpShapeCleanUp >= 0 {
				mata : fclose(st_numscalar("ImpShapeCleanUp"))
			}
		}
	}
	scalar drop ImpShapeCleanUp
	exit `rc'

end

program ImpSpss
	version 16

	capture noi import_spss `macval(0)'
	nobreak {
		local rc = _rc
	}
	exit `rc'
end

version 12.0
mata:

void import_excel_cleanup()
{
	_xlbkrelease(st_numscalar("ImpExcelCleanUp"))
}

void import_haver_cleanup()
{
	if (st_global("c(os)") == "Windows") {
		(void) _haver_set_aggregation(0)
		(void) _haver_close_db()
	}
}


end

