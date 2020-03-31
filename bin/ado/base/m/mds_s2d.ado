*! version 1.0.0  15mar2007
program mds_s2d
	version 10

	#del ;
	syntax  anything(id=matrix name=m)
	[,
		ONEminus
		STandard
		FIXDiagonal
	] ;
	#del cr

	confirm matrix `m'
	assert  issym(`m')
	
	local method `oneminus' `standard'
	if `:list sizeof method' == 0 {
		local method standard
	}
	opts_exclusive "`method'"

	if "`fixdiagonal'" != "" {
		mata : UnitDiag("`m'")
	}	

	if "`method'" == "oneminus" {
		// code allows missing values
		matrix `m' = J(rowsof(`m'),colsof(`m'),1) - `m'
	}
	else {
		mata : Standard("`m'")
	}
end


mata:

// converts in-situ a matrix of similarities to dissimilarities
//   MOUT[i,j] = sqrt(M[i,i] - 2*M[i,j] + M[j,j])
void function Standard(string scalar _M)
{
	real matrix  M

	M = st_matrix(_M)
	st_replacematrix(_M, sqrt(-2*M :+ diagonal(M) :+ diagonal(M)'))
}


void function UnitDiag(string scalar _M)
{
	real scalar  i, n
	real matrix  M

	M = st_matrix(_M)
	n = min((cols(M),rows(M)))
	for (i=1; i<=n; i++) {
		if (M[i,i] >= .) {
			M[i,i] = 1
		}	
	}	

	st_replacematrix(_M, M)
}
end
