*! version 1.0.5  03jun2009
program gr_example
	version 8.2
	if (_caller() < 8.2)  version 8
	else		      version 8.2

	gettoken dsn : 0, parse(" :")
	if "`dsn'"=="graph" {
		`0'
		exit
	}
	gettoken dsn 0 : 0, parse(" :")
	gettoken colon 0 : 0, parse(" :")
	if "`colon'"!=":" {
		di as err "gr_example syntax error"
		exit 198
	}

	di as txt
	di as txt "-> " as res "preserve"
	preserve
	di as txt
	di as txt "-> " as res "sysuse `dsn', clear"
	capture noi sysuse `dsn', clear
	if _rc {
		if _rc>900 { 
			window stopbox stop ///
			"Dataset used in this example" ///
			"too large for Small Stata"
		}
		exit _rc 
	}
			
	di as txt
	di as txt "-> " as res _asis `"`0'"'
	`0'
	di as txt
	di as txt "-> " as res `"restore"'
	
end
