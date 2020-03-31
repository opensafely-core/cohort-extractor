*! version 1.0.1  08oct2002
program define _mkkmn
	version 8.0
	syntax , k(string) m(integer) n(integer)

	mat `k'=J(`n'*`m', `n'*`m' , 0 )

	local m1 = `m' - 1
	forvalues i=1(1)`n' {
		forvalues j = 0(1)`m1' {
			local r = `j'*`n' + `i'
			local c = (`i'-1)*`m'+`j'+1
			mat `k'[`r',`c'] = 1	
		}
	}
end	

exit

/* This program makes a commutation matrix which, for any (m x n) matrix
   A solves 

	vec(A')=Kmn vec(A) 
   see Lutkepohl 1993 pages 464-467 
*/
