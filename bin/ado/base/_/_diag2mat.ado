*! version 1.0.1  02may2007
program define _diag2mat
	version 8.0

	syntax , Mat(string) Dmat(string) Rows(integer) Cols(integer) /*
		*/[ COrder ]

	capture confirm matrix `mat'
	if _rc > 0 {
		di as err "mat() does not define a matrix"
		exit 198
	}

	tempname mat2
	mat `mat2' = `mat'

	local mrows = rowsof(`mat2')
	local mcols = colsof(`mat2')

	if `mrows' != `mcols' {
		di as err "diag2mat only works on square matrices"
		exit 198
	}

	if `mcols' != `rows'*`cols' {
		di as err "rows() * cols() is not equal to number of " /*
			*/ "diagonal elements in mat()"
			exit 198
	}

 	mat `dmat' = J(`rows',`cols', 0)
	
	if "`corder'" == "" {
		forvalue i = 1/`rows' {
			forvalue j = 1/`cols' {
				mat `dmat'[`i',`j'] = 			/*
					*/ `mat2'[`j'+(`i'-1)*`cols', 	/*
					*/ `j'+(`i'-1)*`cols']
			}
		}
	}
	else {
		forvalue i = 1/`rows' {
			forvalue j = 1/`cols' {
				mat `dmat'[`j',`i'] = 			/*
					*/ `mat2'[`j'+(`i'-1)*`cols', 	/*
					*/ `j'+(`i'-1)*`cols']
			}
		}
	}
	
end
