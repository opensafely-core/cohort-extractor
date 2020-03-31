*! version 1.0.0  12mar2019
program _lasso_rngstate, sclass
	local rngstate = c(rngstate)
	local rngstate rngstate(`rngstate')

	sret local rngstate `rngstate'
end
