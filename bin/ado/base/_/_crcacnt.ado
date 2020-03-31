*! version 2.0.0  07/20/91  (anachronism)
program define _crcacnt
	version 3.0
	mac def S_1 1		/* count of arguments	*/
	while ("`$S_1'"!="") { 
		mac def S_1 = $S_1 + 1 
	}
	mac def S_1 = $S_1 - 1
end
