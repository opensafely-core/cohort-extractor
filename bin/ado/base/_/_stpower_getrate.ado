*! version 1.1.0  19feb2019
program _stpower_getrate
	version 10
	args fncval colon currate
	scalar `fncval' = -($GR_Pr - (-expm1(-`currate'*$GR_Z))/	///
				   (-expm1(-`currate'*$GR_R)))^2
end
