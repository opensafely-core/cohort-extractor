*! version 1.0.0  15jan2018
version 16.0

mata:

/*
	randomization_t_one_sample(real colvector x, | real scalar errortype)

		computes p-values from the exact distribution of the
		one-sample randomization t test.

		When the data are signed ranks, this is the exact
		distribution of Wilcoxon signed-ranks statistic.

		x must contain integers; else it is an error.
		x may contain missing values.

		Returns 1 x 3 real rowvector (p, p_l, p_u) where
		p   = two-sided p-value,
		p_l = lower one-sided p-value,
		p_u = upper one-sided p-value.
		Reference for one-sided p-values is the sum of the
		positive data values.

		When errortype is specified and !=0, ado-style error
		messages are issued; otherwise, mata-style error messages.
		When errortype==1, it is an error message for ttest.ado;
		for other values of errortype!=0, it is an error for
		signrank.ado.

	randomization_t_two_sample(real matrix x, | real scalar errortype)

		computes p-values from the exact distribution of the
		two-sample randomization t test.

		When the data are ranks, this is the exact
		distribution of Wilcoxon rank-sum statistic.

		x must be a N x 2 matrix. The first column contains the
		data, which must be integers; else it is an error.
		The second column must be a dichotomous group indicator
		variable. x may contain missing values.

		Returns 1 x 3 real rowvector (p, p_l, p_u) as above.
		Reference group for one-sided p-values is the group given
		by the smallest value of the second column of x.

		When errortype is specified and !=0, ado-style error
		messages are issued; otherwise, mata-style error messages.
		When errortype==1, it is an error message for ttest.ado;
		for other values of errortype!=0, it is an error for
		ranksum.ado.
*/

/*
	Errors from _randomization_t_one_sample() and
	            _randomization_t_two_sample()

	NoError                = 0,
	NoObservations         = 1,
	AbsValuesTooBig        = 2, // 100,000
	NotIntegers            = 3,
	ExceededMaxOneSample   = 4, // 2000
	ExceededMaxTwoSample   = 5, // 1000
	OnlyOneGroup           = 6,
	GroupMoreThanTwoValues = 7,
	Overflow               = 8,
*/

real rowvector randomization_t_one_sample(  real colvector x,
                                          | real scalar errortype)
{
	real scalar     errorcode
	string scalar   exact
	real rowvector  p

	if (args() == 1) {
		errortype = 0
	}

	errorcode = _randomization_t_one_sample(x, p=., errortype)

	if (!errorcode | !errortype) {
		return(p)
	}

	// If here, errorcode nonzero and errortype nonzero.

	if (errortype == 1) {  // for ttest
		exact = "exactp"
	}
	else {  // for signrank
		exact = "exact"
	}

	displayas("error")

	if (errorcode == 1) {  // no observations
		exit(error(2000))
	}

	if (errorcode == 2) {  // too big

		display("absolute values of data must be <= 100,000 " +
			"for option {bf:" + exact + "}")

		exit(499)
	}

	if (errorcode == 3) {  // not integers

		display("data must be exact integers " +
			"for option {bf:" + exact + "}")

		exit(459)
	}

	if (errorcode == 4) {  // >2000

		display("number of observations must be <= 2,000 " +
			"for option {bf:" + exact + "}")

		exit(459)
	}

	if (errorcode == 8) {  // overflow

		display("numerical overflow " +
			"from {bf:" + exact + "} computation.")
		display("    The sample size is too big.")

		exit(1400)  // 1400 = "numerical overflow"
	}

	// The following should never happen.

	display("error from option {bf:" + exact + "}")
	exit(499)
}

real rowvector randomization_t_two_sample(  real matrix x,
                                          | real scalar errortype)
{
	real scalar     errorcode
	string scalar   exact
	real rowvector  p

	if (args() == 1) {
		errortype = 0
	}

	errorcode = _randomization_t_two_sample(x, p=., errortype)

	if (!errorcode | !errortype) {
		return(p)
	}

	// If here, errorcode nonzero and errortype nonzero.

	if (errortype == 1) {  // for ttest
		exact = "exactp"
	}
	else {  // for ranksum
		exact = "exact"
	}

	displayas("error")

	if (errorcode == 1) {  // no observations
		exit(error(2000))
	}

	if (errorcode == 2) {  // too big

		display("absolute values of data must be <= 100,000 " +
			"for option {bf:" + exact + "}")

		exit(499)
	}

	if (errorcode == 3) {  // not integers

		display("data must be exact integers " +
			"for option {bf:" + exact + "}")

		exit(459)
	}

	if (errorcode == 5) {  // >1000

		display("number of observations must be <= 1,000 " +
			"for option {bf:" + exact + "}")

		exit(459)  // 459 = "too many values"
	}

	if (errorcode == 6) {  // only 1 group

		/*
			. ranksum x, by(one)
			1 group found, 2 required
			r(499);

			Should be r(420) but cannot change now.
		*/

		display("1 group found, 2 required")
		exit(499)
	}

	if (errorcode == 7) {  // >2 groups

		/*
			. ranksum x, by(g)
			more than 2 groups found, only 2 allowed
			r(499);

			Should be r(420) but cannot change now.
		*/

		display("more than 2 groups found, only 2 allowed")
		exit(499)
	}

	if (errorcode == 8) {  // overflow

		display("numerical overflow " +
			"from {bf:" + exact + "} computation.")
		display("    The sample size is too big.")

		exit(1400)  // 1400 = "numerical overflow"
	}

	// The following should never happen.

	display("error from option {bf:" + exact + "}")
	exit(499)
}

end
