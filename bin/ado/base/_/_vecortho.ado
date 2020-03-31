*! version 1.0.0  13oct2003
program define _vecortho, rclass
	version 8.1 

	args mat ocomp

 	local r = rowsof(`mat')
	local c = colsof(`mat')

	if `r' <= `c' {
		mat `ocomp' = J(`r',1,0)
	}
	else {
		tempname proj vals vecs
		mat `proj' =  `mat'*syminv(`mat''*`mat')*`mat''
		mat symeigen `vecs' `vals' = `proj'
		mat `ocomp' = `vecs'[1...,`c'+1...]
	}
end
