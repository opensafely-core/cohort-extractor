*! version 1.0.0  03nov2002
program _gs_islivefile , rclass
	args filenm

	tempname loghndl

	file open `loghndl' using `"`filenm'"' , text read
	capture _gs_rdfilehdr `filenm' `loghndl'
	local rc = _rc
	file close `loghndl'

	return scalar live = ! `rc'
end
