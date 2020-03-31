*! version 1.0.1  02jun2008

program asprobit_lf
	version 10

	args todo b lnf g negH

	tempvar lf
	.$ASPROBIT_model.evaluate `lf', b(`b') todo(`todo')

	if `r(error)' == 1 {
		if `todo' == 0 {
			if $ASPROBIT_trace {
				di as err "covariance is not positive definite"
				if `.$ASPROBIT_model.cholesky' {
					tempname V
					.$ASPROBIT_model.cov.list
					local R `.$ASPROBIT_model.cov.matname'
					matrix `V' = `R'*`R''
				}
				else {
					local V `R'
				}
				di
				di "covariance"
				matrix list `V', noheader
			}
			/*  force step-halve	*/
			scalar `lnf' = .
			exit
		}
		/* should not happen! =:0	*/
		error 506
	}
	mlsum `lnf' = `lf'

	if (`lnf'>=.) exit

	if `todo' {
		.$ASPROBIT_model.scores, g(`g')
		if `todo' > 1 {
			.$ASPROBIT_model.opg, h(`negH')
		}
	}
end

exit
