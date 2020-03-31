*! version 1.0.4  06may2019
program _pglm_parse_enpenalty, rclass
	version 16.0

	syntax [, alphas(string)]

	if (`"`alphas'"' == "") {
		ret local n_alpha = 3
		ret local enp 1 0.75 0.5
		exit 
		// NotReached
	}

	cap confirm matrix `alphas'
	local is_mat = !_rc

	local is_num = 0
	if (!`is_mat') {
		local 0 , alphas(`alphas')
		cap syntax , alphas(numlist min=1 >=0 <=1)
		local is_num = !_rc
	}

	if (!`is_num' & !`is_mat') {
		di as err "invalid {bf:alphas()}"
		di "{p 4 4 2}"
		di as err "option {bf:alphas()} must be either a matrix " ///
			"or numlist consisting of numbers between 0 and 1"
		di "{p_end}"
		exit 198
	}

	mata : parse_enp(`"`alphas'"', `is_mat')
end


mata :
mata set matastrict on
					//----------------------------//
					// check alphas
					//----------------------------//
void parse_enp(				///
	string scalar	enp_mat,	///
	real scalar	is_mat)	
{
	real vector enp

	if (is_mat) {
		enp = st_matrix(enp_mat)
	}
	else {
		enp = strtoreal(tokens(enp_mat))
	}
	check_enp(enp)
	enp = uniqrows(enp)
	_sort(enp, -1)		
	st_global("r(enp)", invtokens(strofreal(enp)'))
	st_global("r(n_alpha)", strofreal(length(enp)))
	stata("return add")
}

void check_enp(real matrix enp)
{
	real scalar bad

	bad = sum(enp:<0) + sum(enp:>1)

	if (bad) {
		errprintf("{p 0 2 2}")
		errprintf("option {bf:alphas()} must be a vector " ///
		 	+ "between 0 and 1")
		errprintf("{p_end}")
		exit(198)
	}

	if (rows(enp) > 1 & cols(enp) > 1) {
		errprintf("{p 0 2 2}")
		errprintf("option {bf:alphas()} must be a "	///
			+ "vector")
		errprintf("{p_end}")
		exit(198)
	}

	if (rows(enp) == 1) {
		_transpose(enp)
	}
}

end
