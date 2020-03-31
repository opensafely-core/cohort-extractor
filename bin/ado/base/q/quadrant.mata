*! version 1.0.1  01jun2013
version 9.0
mata:

/*
	Quadrants:
			     (2)
			   2  |  1
			      | 
		    (3)	------+------ (1)
			   3  |  4
			     (4)

	quadrant(0i) = quadrant(C(.)) = .  
	Note treatment of degenerate cases:  quadrant(5+0i) = 1

	Thus, after exclusion of Re==Im==0:

			Q1:	Re>0  & Im>=0
			Q2:	Re<=0 & Im>0
			Q3:	Re<0  & Im<=0
*/


real matrix quadrant(complex matrix z)
{
	real matrix	q
	complex scalar	a
	real scalar	ar, ai, res
	real scalar	i, j, r, c

	q = J(r=rows(z),c=cols(z),.)
	for (i=1;i<=r;i++) { 
		for (j=1;j<=c;j++) { 
			a = z[i,j]
			if (a!=. & a!=0) { 
				ar = Re(a)
				ai = Im(a)
				if      (ar> 0 & ai>=0) res = 1
				else if (ar<=0 & ai> 0) res = 2 
				else if (ar< 0 & ai<=0) res = 3 
				else res = 4 
				q[i,j] = res
			}
		}
	}
	return(q)
}

end
