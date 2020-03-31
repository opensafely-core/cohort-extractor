*! version 1.0.0  15apr2019
program _dslasso_end_rngstate, sclass
	version 16.0

	syntax , state(string) rc(string)
	set rngstate `state'

	if (`rc') {
		exit `rc'
	}
end
