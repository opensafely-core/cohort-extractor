*! version 1.0.1  22aug2009

/* Computes rank of matrix currently in e(V) and stores
   result in scalar e(rank)
*/

program _post_vce_rank

	syntax, [CHecksize]

	/* use checksize option if it is possible to have a [0,0] e(V)
 	   matrix */

	if "`checksize'" != "" {
		tempname V
		capture matrix `V' = e(V)
		if _rc {
			exit
		}
		local cols = colsof(`V')
		if `cols' == 0 {
			exit
		}
	}
	tempname V Vi rank
	
	mat `V' = e(V)
	mat `Vi' = invsym(`V')
	sca `rank' = rowsof(`V') - diag0cnt(`Vi')
	
	mata:st_numscalar("e(rank)", st_numscalar("`rank'"))
	
end

