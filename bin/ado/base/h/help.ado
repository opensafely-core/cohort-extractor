*! version 1.0.1  18sep2019
program help
	version 9

	if "`c(console)'" == "console" || c(textresultsmode) != 0 {
		chelp `0'
	}
	else {
		whelp `0'
	}
end
