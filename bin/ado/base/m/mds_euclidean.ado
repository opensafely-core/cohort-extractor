*! version 1.0.0  19mar2007
program mds_euclidean
	version 10

	args F colon Yexp
	assert inlist(`"`colon'"', ":", "=")

	tempname Y 	
	matrix `Y' = `Yexp'

	mata: st_matrix("`F'", _mds_euclidean(st_matrix("`Y'")))

	matrix rownames `F' = `:rownames `Y''
	matrix colnames `F' = `:rownames `Y''
end	
exit

mdseuclidean F {:|=} Y 

computes a square matrix F with the euclidean distances between the rows of Y
the number of columns of Y is arbitrary

note that the diagonal of F is 0

