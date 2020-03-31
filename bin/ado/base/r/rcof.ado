*! version 2.0.1  19mar1998
program define rcof
	* version statement intentionally omitted -- this command is transparent
	gettoken cmd 0: 0, parse("=~!><")
	capture `cmd'
	if _rc `0' { 
		exit
	}
	di in red _n "rcof:  _rc `0' *NOT TRUE* from"
	di in red `"       `cmd'"'
	di in red "       _rc == " _rc
	exit 9
end
