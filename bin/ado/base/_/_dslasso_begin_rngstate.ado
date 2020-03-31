*! version 1.0.0  15apr2019
program _dslasso_begin_rngstate, sclass
	version 16.0

	local state = c(rngstate)
	set rngstate `e(rngstate)'
	sret local state `state'
end
