*! version 1.0.12  11apr2019
program define export 
	version 12

	gettoken subcmd 0 : 0

	if `"`subcmd'"' == "dbas" {
		ExpDbase `macval(0)'
	}
	else if `"`subcmd'"' == "dbase" {
		ExpDbase `macval(0)'
	}
	else if `"`subcmd'"' == "delim" {
		ExpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimi" {
		ExpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimit" {
		ExpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimite" {
		ExpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "delimited" {
		ExpDelim `macval(0)'
	}
	else if `"`subcmd'"' == "exc" {
		ExpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "exce" {
		ExpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "excel" {
		ExpExcel `macval(0)'
	}
	else if `"`subcmd'"' == "sasxport5" {
		ExpSasxport5 `0'
	}
	else if `"`subcmd'"' == "sasxport8" {
		ExpSasxport8 `0'
	}
	else if `"`subcmd'"' == "sasxport" {
		if (_caller() < 16) {
			ExpSasxport5 `macval(0)'
		}
		else {
			di as error "invalid syntax"
			di as error "   specify either {cmd:export sasxport5} or {cmd:export sasxport8}"
			exit 198
		}
	}
	else if `"`subcmd'"' == "shp" {
		ExpShape `macval(0)'
	}
	else {
		display as error `"export: unknown subcommand "`subcmd'""' 
		exit 198
	}

end

program ExpDbase
	version 15

	scalar ExpDbaseCleanUp = -1
	capture noi export_dbase `macval(0)'
	nobreak {
		local rc = _rc
		if `rc' {
			if scalar(ExpDbaseCleanUp) >= 0 {
				mata : fclose(st_numscalar("ExpDbaseCleanUp"))
			}
		}
	}
	scalar drop ExpDbaseCleanUp
	exit `rc'
end

program ExpDelim
	version 13

	export_delimited `macval(0)'
end

program ExpExcel
	version 12

	scalar ExpExcelCleanUp = -1

	capture noi export_excel `macval(0)'
	nobreak {
		local rc = _rc
		if `rc' {
			if scalar(ExpExcelCleanUp) >= 0 {
				mata : export_excel_cleanup()
			}
		}
	}
	scalar drop ExpExcelCleanUp
	exit `rc'
end

program ExpSasxport5
	fdasave `0'
end

program ExpSasxport8
	version 16
	scalar ExpXport8CleanUp = -1
	capture noi export_sasxport8 `macval(0)'
	nobreak {
		local rc = _rc
		if `rc' {
			if scalar(ExpXport8CleanUp) >= 0 {
				mata : fclose(st_numscalar("ExpXport8CleanUp"))
			}
		}
	}
	scalar drop ExpXport8CleanUp
	exit `rc'
end

program ExpShape
	version 15

	scalar ExpShpCleanUp = -1
	scalar ExpShxCleanUp = -1
	capture noi export_shp `macval(0)'
	nobreak {
		local rc = _rc
		if `rc' {
			if scalar(ExpShpCleanUp) >= 0 {
				mata : fclose(st_numscalar("ExpShpCleanUp"))
			}
			if scalar(ExpShxCleanUp) >= 0 {
				mata : fclose(st_numscalar("ExpShxCleanUp"))
			}
		}
	}
	scalar drop ExpShpCleanUp
	scalar drop ExpShxCleanUp
	exit `rc'
end

version 12.0
mata:

void export_excel_cleanup()
{
	_xlbkrelease(st_numscalar("ExpExcelCleanUp"))
}
end
