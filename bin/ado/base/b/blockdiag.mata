*! version 1.1.0  25jan2005
version 9.0
mata:

		/*
			matrix = blockdiag(A,B)

			make a block diagonal matrix
		*/

numeric matrix blockdiag(numeric matrix a, numeric matrix b)
{
	return(a, J(rows(a),cols(b),0) \ J(rows(b),cols(a),0),b)
}

end

