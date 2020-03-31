*! version 1.0.0  17mar2004
program define veclmar, rclass sortpreserve
	version 8.2

	tempname rmac
	syntax , [ * ]
	capture noi veclmar_w , `options' rmac(`rmac') 
	local rc = _rc

	local r = ``rmac''

	capture noi _vecpclean, rank(`r')
	local rc2 = _rc

	if `rc' == 0 & `rc2' > 0 {
		local rc = `rc2'
	}

	if `rc' == 0 {
		tempname lm
		mat `lm' = r(lm)
		ret mat lm = `lm'
	}	
	else {
		exit `rc'
	}

end	


