*! version 1.0.1  27mar2013
program search
	version 13

	if _caller() < 13 {
		_search `0'
		exit
	}
	if "`c(console)'" == "console" {
		_search `0'
		exit
	}

	if (`"`0'"' != "") {
		local orig0 `"`0'"'
		local rest `"`0'"'
		while `"`rest'"' != "" {
			gettoken token rest : rest, parse(" ,") quotes
			if `"`token'"' == "," {
				local 0 `", `rest'"'
				syntax [anything] [, local net all * ]
				if `"`options'"' == "" {
					view search `orig0'
					exit
				}
				_search `orig0'
				exit
			}
		}
		view search `0'
		exit
	}

	_search `0'
end
