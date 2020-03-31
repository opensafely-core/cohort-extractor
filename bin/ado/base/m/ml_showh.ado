*! version 1.0.0  03may2007
program ml_showh
	version 10
	args h

	local coln : colf $ML_b
	matrix coln `h' = `coln'
	if "$ML_dots" == "ml_dots" {
		di
	}
	di as txt "h vector (for numerical derivatives):"
	matrix list `h', noheader noblank format(%9.0g)
end
