*! version 2.0.1  19nov2002
program define findit
	version 8
	if _caller() < 8 {
		findit_7 `0'
		exit
	}
	if ("`c(console)'" == "console") {
		search `0', all
		exit
	}
	view search `0', all
end
