*! version 3.0.1  06nov2017
version 9.0
mata:

real scalar rank(numeric matrix X, |real scalar tol) 
{
	numeric matrix Xcpy

	pragma unset Xcpy	// [sic]
	pragma unused Xcpy

	return(rank_from_singular_values(_svdsv(isfleeting(X) ? X : (Xcpy=X)),
					tol))
}

end
