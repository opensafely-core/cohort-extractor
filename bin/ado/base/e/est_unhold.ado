*! version 1.0.1  07may2003
program est_unhold
	version 8
	args name esample

	Drop `esample'
	capt gen byte `esample' = _est_`name'
	_est unhold `name'
	Drop _est_`name'
end


// drop v if it exists, ensuring that v is not an abbreviation
program Drop
	version 8
	args v
	
	capt confirm var `v'
	if (_rc)  exit

	capt confirm new var `v'
	if (_rc)  drop `v' 
end
exit
