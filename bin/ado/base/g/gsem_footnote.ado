*! version 1.0.2  05aug2014
program gsem_footnote
	version 13

	if e(estimates) == 0 {
		di as txt "{p 0 6 2 79}"
		di as txt "Note: The above coefficient values are starting"
		di as txt "values and not the result of a fully fitted model."
		di as txt "{p_end}"
	}
	else if `"`e(adapt_conv)'"' == "no" {
		di as txt "{p 0 6 2 79}"
		di as txt "Note: The above coefficient values are the result"
		di as txt "of non-adaptive quadrature because the adaptive"
		di as txt "parameters could not be computed."
		di as txt "{p_end}"
	}
end
exit
