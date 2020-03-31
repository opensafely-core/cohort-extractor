*! version 1.0.1  18mar2009
version 11.0

mata:

void _sublowertriangle(numeric matrix A, | real scalar p) 
{
        real matrix     idx
        real scalar     r_a, c_a, i, maxj, temp, start
        real scalar     offset
	scalar 		zero
	real scalar 	d

	if(args()==1) {
		d = 0
	}
	else {
		d = p
	}
	
       	r_a	= rows(A) 
	c_a	= cols(A) 
	zero 	= (iscomplex(A) ? 0i : 0)
	offset 	= floor(d)
	
	if(offset >= r_a) {
        	A = J(r_a, c_a, zero) 
		return
	}

	if(offset <= -c_a) return       
 
	start = offset + 1
	if(start <= 0) start = 1

	if(start > 1) {
		idx = (1, 1 \ start-1, c_a)
		A[|idx|] = J(start-1, c_a, zero)
	}

        for(i = start; i <= r_a; i++) {
                temp = i-offset;
		maxj = (temp<c_a ? temp : c_a)
                
                if(maxj < c_a ) {
		 	idx = (i, maxj+1 \ i, c_a)
                	A[|idx|] = J(1, c_a-maxj, zero)
		}
        }
}

end
