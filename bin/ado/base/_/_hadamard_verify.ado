*! version 1.0.0  03jan2005
program _hadamard_verify, rclass
	version 9
	syntax name(name=hmat) [, optname(name) ]

	confirm matrix `hmat'

	local order = colsof(`hmat')
	if `order' != rowsof(`hmat') {
		if "`optname'" == "" {
			di as err "matrix `hmat' is not square"
		}
		else {
			di as err ///
			"option `optname'() requires a square matrix"
		}
		exit 459
	}

	tempname square nI
	matrix `square' = `hmat'*`hmat''
	matrix `nI' = `order'*I(`order')
	if mreldif(`square',`nI') != 0 {
		if "`optname'" == "" {
			di as err "matrix `hmat' is not a Hadamard matrix"
		}
		else {
			di as err ///
			"option `optname'() requires a Hadamard matrix"
		}
		exit 459
	}

	return scalar order = `order'
end
exit
