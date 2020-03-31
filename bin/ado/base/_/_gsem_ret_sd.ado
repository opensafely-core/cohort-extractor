*! version 1.0.0  05feb2017
program _gsem_ret_sd, rclass
	version 15
	args bmat Vmat

	tempname b V

	return add

	if "`bmat'" == "" {
		mat `b' = e(b_sd)
	}
	else	mat `b' = `bmat'
	
	if "`Vmat'" == "" {
		mat `V' = e(V_sd)
	}
	else	mat `V' = `Vmat'
	
	return matrix V = `V'
	return matrix b = `b'
end

