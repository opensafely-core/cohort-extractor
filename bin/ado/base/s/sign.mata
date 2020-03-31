*! version 1.0.1  20jan2005
version 9.0

mata:

/*
	sign(x)

	returns elementwise sign of x, defined as 
		-1	if x<0
		 0	if x==0
		 1	if x>0
		 .	if x>=. 
*/

real matrix sign(real matrix x)
{
	real matrix	res
	real scalar	i, j, r, c, v 

	res = J(r=rows(x),c=cols(x),1)
	for (i=1;i<=r;i++) { 
		for (j=1;j<=c;j++) { 
			v = x[i,j]
			res[i,j] = (v>0 ? (v>=. ? . : 1) :
					(v==0 ? 0 : -1)
				   )

		}
	}
	return(res)
}
end
