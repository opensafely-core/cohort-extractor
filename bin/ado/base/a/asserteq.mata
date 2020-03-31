*! version 1.0.0  15oct2004
version 9.0
mata:

void asserteq(transmorphic matrix a, transmorphic matrix b)
{
	real scalar	r, c, cnt

	if (a==b) return
	sprintf("asserteq: %s <arg1>[%g,%g] != %s <arg2>[%g,%g]",
		eltype(a),rows(a),cols(a),eltype(b),rows(b),cols(b))
	if (rows(a)==rows(b) & cols(a)==cols(b) & eltype(a)==eltype(b)) { 
		cnt=0
		for (r=1;r<=rows(a);r++) {
			for (c=1;c<=cols(b);c++) {
				if (a[r,c] != b[r,c]) cnt++  
			}
		}
		sprintf("asserteq:  %g mismatches",cnt)
	}
	_error("assertion is false")
}

end
