*! version 1.0.8  01jan2019
program define import_shp, rclass
	version 15

	gettoken filename rest : 0, parse(" ,")
	gettoken comma : rest, parse(" ,")

	if ((`"`filename'"' != "" & `"`filename'"' != "using") &	///
		(trim(`"`comma'"') == "," | trim(`"`comma'"') == "")) {
		local 0 `"using `0'"'
	}

	syntax using/ , [clear]

	mata: import_shp()
end
