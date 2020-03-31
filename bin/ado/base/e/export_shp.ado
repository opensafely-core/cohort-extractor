*! version 1.0.6  14mar2017
program define export_shp
	version 15

	gettoken filename rest : 0, parse(" ,")
	gettoken comma : rest, parse(" ,")

	if ((`"`filename'"' != "" & `"`filename'"' != "using") &	///
		(trim(`"`comma'"') == "," | trim(`"`comma'"') == "")) {
		local 0 `"using `0'"'
	}

	syntax using/ , [REPLACE shx id(varname numeric)]

	mata: export_shp()
end

