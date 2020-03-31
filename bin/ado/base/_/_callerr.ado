*! version 1.0.0
program define _callerr
	version 6
	di in red "the program you are running has an error;"
	di in red "it includes the line"
	di in red _col(8) `"`0'"'
	exit 197
end
