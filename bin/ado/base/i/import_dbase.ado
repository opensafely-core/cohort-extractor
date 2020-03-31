*! version 1.0.7  01sep2019
program define import_dbase, rclass
	version 15

	gettoken filename rest : 0, parse(" ,")
	gettoken comma : rest, parse(" ,")

	if (`"`filename'"' != "" & (trim(`"`comma'"') == "," |	///
		trim(`"`comma'"') == "")) {
		local 0 `"using `0'"'
	}

	syntax using/ , [clear case(string)]

	mata: import_dbase_import_file()

	return add

	qui compress
end

