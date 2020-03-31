*! version 1.0.1  30jun2008
program _b_post0, eclass
	version 11
	tempname b V
	local dim : list sizeof 0
	matrix `b' = J(    1,`dim',0)
	matrix `V' = J(`dim',`dim',0)
	matrix colnames `b' = `0'
	matrix colnames `V' = `0'
	matrix rownames `V' = `0'
	ereturn post `b' `V'
end
