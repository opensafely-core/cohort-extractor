*! version 1.1.1  08jul2008
program define _cpmatnm
/*
    Syntax:

    	_cpmatnm matname [, vector(matlist) square(matlist) ]

*/
	version 6
	local vv : display "version " string(_caller()) ":"
	gettoken A 0 : 0, parse(", ")
	syntax [, VECtor(string) SQuare(string)]

	local names   : colnames(`A')
	local eqnames : coleq(`A')

	tokenize `vector'
	local i 1
	while "``i''"!="" {
		`vv' matrix colnames ``i'' = `names'
		matrix coleq    ``i'' = `eqnames'
		local i = `i' + 1
	}

	tokenize `square'
	local i 1
	while "``i''"!="" {
		`vv' matrix colnames ``i'' = `names'
		matrix coleq    ``i'' = `eqnames'
		`vv' matrix rownames ``i'' = `names'
		matrix roweq    ``i'' = `eqnames'
		local i = `i' + 1
	}
end
