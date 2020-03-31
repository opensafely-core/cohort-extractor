*! version 1.0.6  02sep2003
program tsrline
	version 8.1

	if `"`0'"' == "" {
		graph					// replay
	}
	else {
		graph twoway tsrline `0'
	}
end

exit
