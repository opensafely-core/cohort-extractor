*! version 1.0.0  18dec2003
program define _matsort 
	version 8.0
	
	args mat col

	confirm matrix `mat'

	local r    = rowsof(`mat')
	local cols = colsof(`mat')


	if `col' > `cols' {
		di as err "sorting column is larger than number of "	///
			"columns  in matrix `mat'"
	}		

	tempname temp

	if `r' == 1 {
		exit
	}
	else {
		tempname s1 
		forvalues j = 2/`r' {
			local j2 = `j'
			local i = `j' - 1
			while (`i' > 0 & `mat'[`j2',`col'] > `mat'[`i',`col']) {
				mat `temp' = `mat'[`i',1...]
				forvalues c=1/`cols' {
					mat `mat'[`i',`c']=`mat'[`j2',`c']
					mat `mat'[`j2',`c']=`temp'[1,`c']
				}
				local --i
				local --j2
			}
		}
	}
end
exit

_matsort sorts a matrix by the specified column vector from largest to
smallest
